<?php

require __DIR__ . '/paypal/vendor/autoload.php';
use PayPal\Api\Amount;
use PayPal\Api\CreditCard;
use PayPal\Api\Details;
use PayPal\Api\FundingInstrument;
use PayPal\Api\Item;
use PayPal\Api\ItemList;
use PayPal\Api\Payer;
use PayPal\Api\Payment;
use PayPal\Api\Transaction;

class Paypal extends DbItem {

    /**
     * Последние сообщения об ошибках
     * @var array
     */
    protected $_errors = array();

    /**
     * Данные API
     * Обратите внимание на то, что для песочницы нужно использовать соответствующие данные
     * @var array
     */
    protected $_credentials = array();

    /**
     * Указываем, куда будет отправляться запрос
     * Реальные условия - https://api-3t.paypal.com/nvp
     * Песочница - https://api-3t.sandbox.paypal.com/nvp
     * @var string
     */
    protected $_endPoint = 'https://api-3t.sandbox.paypal.com/nvp';

    /**
     * Версия API
     * @var string
     */
    protected $_version = '74.0';


    function Paypal()
    {
        parent::DbItem();
        $this->_initTable('payment_log');
        $this->_credentials = array(
            'USER' => Conf::getSetting('PAYPAL_USER'),
            'PWD' => Conf::getSetting('PAYPAL_PWD'),
            'SIGNATURE' => Conf::getSetting('PAYPAL_SIGNATURE'),
        );
        if (Conf::getSetting('PAYPAL_TEST_MODE'))
            $this->_endPoint = 'https://api-3t.sandbox.paypal.com/nvp';
        else
            $this->_endPoint = 'https://api-3t.paypal.com/nvp';
    }


    /**
     * Сформировываем запрос
     *
     * @param string $method Данные о вызываемом методе перевода
     * @param array $params Дополнительные параметры
     * @return array / boolean Response array / boolean false on failure
     */
    public function request($method,$params = array()) {
        $this -> _errors = array();
        if( empty($method) ) { // Проверяем, указан ли способ платежа
            $this -> _errors = array('Не указан метод перевода средств');
            return false;
        }

        // Параметры нашего запроса
        $requestParams = array(
                'METHOD' => $method,
                'VERSION' => $this -> _version
            ) + $this -> _credentials;

        // Сформировываем данные для NVP
        $request = http_build_query($requestParams + $params);

        // Настраиваем cURL
        $curlOptions = array (
            CURLOPT_URL => $this -> _endPoint,
            CURLOPT_VERBOSE => 1,
            //CURLOPT_SSL_VERIFYPEER => true,
            //CURLOPT_SSL_VERIFYHOST => 2,
            //CURLOPT_CAINFO => dirname(__FILE__) . '/cacert.pem', // Файл сертификата
            CURLOPT_RETURNTRANSFER => 1,
            CURLOPT_POST => 1,
            CURLOPT_POSTFIELDS => $request
        );


        $ch = curl_init();
        curl_setopt_array($ch,$curlOptions);

        // Отправляем наш запрос, $response будет содержать ответ от API
        $response = curl_exec($ch);

        $this->aData = array(
            'request' => json_encode(array(
                    'METHOD' => $method,
                    'VERSION' => $this -> _version
                ) + $params),
            'response' => $response?$response:(curl_errno($ch)?('Error:'.curl_error($ch)):'unknown'),
            'account_id' => isset($_SESSION['account'])?$_SESSION['account']['id']:'NULL',
            'purchase_id' => isset($params['PAYMENTREQUEST_0_INVNUM'])?intval($params['PAYMENTREQUEST_0_INVNUM']):'NULL',
            'cdate' => Database::date()
        );
        $this->insert(array('purchase_id', 'account_id'));

        // Проверяем, нету ли ошибок в инициализации cURL
        if (curl_errno($ch)) {
            $this -> _errors[] = curl_error($ch);
            curl_close($ch);
            return false;
        } else  {
            curl_close($ch);
            $responseArray = array();
            parse_str($response,$responseArray); // Разбиваем данные, полученные от NVP в массив
            return $responseArray;
        }
    }

    function getErrors() {
        return $this -> _errors;
    }

    function payCreditCard($aPurchase, $aParams) {

        $aParams['card-number'] = preg_replace('/[^\d]/', '', $aParams['card-number']);
        if (strlen($aParams['card-exp-year'])==2) $aParams['card-exp-year'] = '20'.$aParams['card-exp-year'];
        list($aParams['card-holder-first'], $aParams['card-holder-last']) =  explode(' ', $aParams['card-holder-name'], 2);

        $apiContext = new \PayPal\Rest\ApiContext(
            new \PayPal\Auth\OAuthTokenCredential(
                Conf::getSetting('PAYPAL_API_CLIENT_ID'),  // ClientID
                Conf::getSetting('PAYPAL_API_SECRET')      // ClientSecret
            )
        );
        $apiContext->setConfig(
            array(
                'mode' => Conf::getSetting('PAYPAL_TEST_MODE')?'sandbox':'live',
                'log.LogEnabled' => true,
                'log.FileName' => Conf::get('path').'logs/PayPal.log',
                'log.LogLevel' => 'DEBUG', // PLEASE USE `INFO` LEVEL FOR LOGGING IN LIVE ENVIRONMENTS
              //  'cache.enabled' => true,
                // 'http.CURLOPT_CONNECTTIMEOUT' => 30
                // 'http.headers.PayPal-Partner-Attribution-Id' => '123123123'
                //'log.AdapterFactory' => '\PayPal\Log\DefaultLogFactory' // Factory class implementing \PayPal\Log\PayPalLogFactory
            )
        );

        // ### CreditCard
        // A resource representing a credit card that can be
        // used to fund a payment.
        $card = new CreditCard();
        $card->setType($this->cardType($aParams['card-number']))
            ->setNumber($aParams['card-number'])
            ->setExpireMonth($aParams['card-exp-month'])
            ->setExpireYear($aParams['card-exp-year'])
            ->setCvv2($aParams['card-cvv'])
            ->setFirstName($aParams['card-holder-first'])
            ->setLastName($aParams['card-holder-last']);

        // ### FundingInstrument
        // A resource representing a Payer's funding instrument.
        // For direct credit card payments, set the CreditCard
        // field on this object.
        $fi = new FundingInstrument();
        $fi->setCreditCard($card);

        // ### Payer
        // A resource representing a Payer that funds a payment
        // For direct credit card payments, set payment method
        // to 'credit_card' and add an array of funding instruments.
        $payer = new Payer();
        $payer->setPaymentMethod("credit_card")
            ->setFundingInstruments(array($fi));

        // ### Itemized information
        // (Optional) Lets you specify item wise
        // information
        $item1 = new Item();
        $item1->setName('LiberEye #'.$aPurchase['purchase_id'])
           // ->setDescription('')
            ->setCurrency($aPurchase['currency'])
            ->setQuantity(1)
           // ->setTax(0)
            ->setPrice($aPurchase['amount']);
        /*$item1->setName('№'.$aPurchase['purchase_id'])
            ->setDescription('')
            ->setCurrency($aPurchase['currency'])
            ->setQuantity(1)
            ->setTax(0)
            ->setPrice($aPurchase['amount']);*/
        $itemList = new ItemList();
        $itemList->setItems(array($item1));


        // ### Amount
        // Lets you specify a payment amount.
        // You can also specify additional details
        // such as shipping, tax.
        $amount = new Amount();
        $amount->setCurrency($aPurchase['currency'])
            ->setTotal($aPurchase['amount']);

        // ### Transaction
        // A transaction defines the contract of a
        // payment - what is the payment for and who
        // is fulfilling it.
        $transaction = new Transaction();
        $transaction->setAmount($amount)
            ->setItemList($itemList)
            ->setInvoiceNumber(uniqid());

        // ### Payment
        // A Payment Resource; create one using
        // the above types and intent set to sale 'sale'
        $payment = new Payment();
        $payment->setIntent("sale")
            ->setPayer($payer)
            ->setTransactions(array($transaction));



        // ### Create Payment
        // Create a payment by calling the payment->create() method
        // with a valid ApiContext (See bootstrap.php for more on `ApiContext`)
        // The return object contains the state.
        try {
            $result = $payment->create($apiContext);
            return $payment;
        } catch (Exception $ex) {
            return $this->_addError(Conf::format('Paypal connection error'));
        }

    }

    /**
     * Detect Credit card type
     * @param $number
     * @return Valid types are: `visa`, `mastercard`, `discover`, `amex`
     */
    function cardType($number)
    {
        $number=preg_replace('/[^\d]/','',$number);
        if (preg_match('/^3[47][0-9]{13}$/',$number))
        {
            return 'amex';
        }
        elseif (preg_match('/^6(?:011|5[0-9][0-9])[0-9]{12}$/',$number))
        {
            return 'discover';
        }
        elseif (preg_match('/^5[1-5][0-9]{14}$/',$number))
        {
            return 'mastercard';
        }
        elseif (preg_match('/^4[0-9]{12}(?:[0-9]{3})?$/',$number))
        {
            return 'visa';
        }
        return false;
    }

}
?>