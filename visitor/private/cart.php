<?php
/** ============================================================
 * Страница регистрации новых пользователей
 *   Area: visitor
 *   Part: private
 *   Sect: cart
 * @author Rudenko S.
 * @package visitor
 * ============================================================ */
Conf::loadClass('Account');
Conf::loadClass('Country');
Conf::loadClass('Purchase');
Conf::loadClass('Product2purchase');
Conf::loadClass('utils/Paypal');

$oPaypal = new Paypal();
$oCountry = new Country();
$oPurchase = new Purchase();
$oProduct2purchase = new Product2purchase();
$iPurchaseId = $oReq->getInt('id');
$aPurchase = array();

switch ($oReq->getAction())
{
    case 'pay':
        $iPurchaseId = $oReq->getInt('id');
        if ($iPurchaseId && $oPurchase->loadBy(array('account_id'=>'='.$oAccount->isLoggedIn(), 'purchase_id'=>'='.$iPurchaseId, 'status'=>'!="paid"'))) {

            $aPurchase = $oPurchase->aData;

            // Проверяем заполненность адреса доставки
            if (!$oReq->get('city')) $aErrors[] = Conf::format('City is not specified');
            if (!$oReq->getInt('country_id')) $aErrors[] = Conf::format('Country is not specified');
            if ($oReq->getInt('country_id') && !$oCountry->load($oReq->getInt('country_id'), $aLanguage['language_id']))  $aErrors[] = Conf::format('Country is not found');
            if (!$oReq->get('street')) $aErrors[] = Conf::format('Street is not specified');
            if (!$oReq->get('building')) $aErrors[] = Conf::format('Building is not specified');
            if (!$oReq->get('phone')) $aErrors[] = Conf::format('Phone is not specified');
            if ($aErrors) {
                echo json_encode(array('errors'=>$aErrors));
                exit;
            }

            // обновляем адрес доставки
            $aAddress = array(
                $oCountry->aData['title'],
                $oReq->get('city'),
                $oReq->get('street'),
                $oReq->get('building'),
                $oReq->get('housing')?$oReq->get('housing'):'-',
                $oReq->get('apartment')?$oReq->get('apartment'):'-',
            );
            $oPurchase->aData = array('purchase_id'=>$iPurchaseId, 'delivery_address'=>join(', ', $aAddress), 'delivery_phone'=>$oReq->get('phone'));
            $oPurchase->update();

            // Параметры нашего запроса
            $requestParams = array(
                'RETURNURL' => Conf::get('http').Conf::get('host').'/'.($aLanguage['alias']).'/account/cart/'.$iPurchaseId.'/?act=notify&success=true',
                'CANCELURL' => Conf::get('http').Conf::get('host').'/'.($aLanguage['alias']).'/account/cart/'.$iPurchaseId.'/?act=notify&success=false'
            );

            // данные о заказе
            $fAmount = round($aPurchase['price']+$aPurchase['price']*Conf::getSetting('MARKUP')/100, 2)+$aPurchase['delivery'];//$oPurchase->getAmount($aPurchase);
            $orderParams = array(
                'PAYMENTREQUEST_0_AMT' => $fAmount,
                //'PAYMENTREQUEST_0_SHIPPINGAMT' => 100,
                'PAYMENTREQUEST_0_CURRENCYCODE' => $aPurchase['currency'],
                'PAYMENTREQUEST_0_ITEMAMT' => $fAmount,
                'PAYMENTREQUEST_0_INVNUM' => uniqid($aPurchase['purchase_id'].'-'),
            );

            // Описание
            $item = array(
                'L_PAYMENTREQUEST_0_NAME0' => '№'.$aPurchase['purchase_id'],
                'L_PAYMENTREQUEST_0_DESC0' => $aPurchase['description'],
                'L_PAYMENTREQUEST_0_AMT0' => $fAmount,
                // 'L_PAYMENTREQUEST_0_QTY0' => '1'
            );

            $oPaypal = new Paypal();
            $response = $oPaypal->request('SetExpressCheckout',$requestParams + $orderParams + $item);

            // Если запрос был успешным, мы получим токен в параметре TOKEN в ответе от PayPal.
            if(is_array($response) && isset($response['ACK']) && $response['ACK'] == 'Success') { // Запрос был успешно принят
                $token = $response['TOKEN'];
                //header( 'Location: https://www.'.(Conf::getSetting('PAYPAL_TEST_MODE')?'sandbox.':'').'paypal.com/webscr?cmd=_express-checkout&useraction=commit&token=' . urlencode($token) );
                echo json_encode(array('paypalUrl'=> 'https://www.'.(Conf::getSetting('PAYPAL_TEST_MODE')?'sandbox.':'').'paypal.com/webscr?cmd=_express-checkout&useraction=commit&token=' . urlencode($token)));
                exit;
            } else {
                if (isset($response['ACK']) && $response['ACK'] == 'Failure')
                    $aErrors[] = $response['L_SHORTMESSAGE0'];
                else
                    $aErrors = Conf::format('The request failed paypal');//$aErrors = $oPaypal->getErrors();//$aErrors = 'Ошибка запроса paypal';
            }
        } else
            $aErrors[] = Conf::format('Purchase Found');

        echo json_encode(array('errors'=>$aErrors));
        exit;
        break;

    case 'notify':
        if( isset($_GET['token']) && !empty($_GET['token']) ) { // Токен присутствует
            // Получаем детали оплаты, включая информацию о покупателе.
            // Эти данные могут пригодиться в будущем для создания, к примеру, базы постоянных покупателей
            $checkoutDetails = $oPaypal->request('GetExpressCheckoutDetails', array('TOKEN' => $_GET['token']));
            $iPurchaseId = intval($checkoutDetails['PAYMENTREQUEST_0_INVNUM']);

            if ($oPurchase->loadBy(array('purchase_id'=>'='.$iPurchaseId))) {
                // Завершаем транзакцию
                $aPurchase = $oPurchase->aData;
                $fAmount = $oPurchase->getAmount($aPurchase);
                $requestParams = array(
                    'PAYMENTREQUEST_0_PAYMENTACTION' => 'Sale',
                    'PAYMENTREQUEST_0_ITEMAMT' => $checkoutDetails['PAYMENTREQUEST_0_ITEMAMT'],
                    'PAYMENTREQUEST_0_CURRENCYCODE' => $checkoutDetails['PAYMENTREQUEST_0_CURRENCYCODE'],
                    'PAYMENTREQUEST_0_AMT' => $checkoutDetails['PAYMENTREQUEST_0_AMT'],
                    'L_PAYMENTREQUEST_0_AMT0' => $checkoutDetails['L_PAYMENTREQUEST_0_AMT0'],
                    'PAYMENTREQUEST_0_INVNUM' => $checkoutDetails['PAYMENTREQUEST_0_INVNUM'],
                    'PAYERID' => isset($_GET['PayerID'])?$_GET['PayerID']:'',
                    'TOKEN' => $_GET['token']
                );

                $response = $oPaypal->request('DoExpressCheckoutPayment',$requestParams);
                if( is_array($response) && $response['ACK'] == 'Success') { // Оплата успешно проведена
                    // Здесь мы сохраняем ID транзакции, может пригодиться во внутреннем учете
                    $transactionId = $response['PAYMENTINFO_0_TRANSACTIONID'];
                    $oPurchase->aData = array('purchase_id'=>$iPurchaseId, 'status'=>'paid', 'track_id'=>$transactionId, 'udate'=>Database::date(), 'pay_system_id'=>'1');
                    $oPurchase->update();
                    $oReq->forward('/'.($aLanguage['alias']).'/account/cart/'.$iPurchaseId.'/', Conf::format('Purchase was successfully paid'));
                } else
                    $aErrors[] = Conf::format('Error payment');
            } else
                $aErrors[] = Conf::format('Purchase Found');
        }
        break;

}


if ($oPurchase->loadBy(array('account_id'=>'='.$oAccount->isLoggedIn(), 'purchase_id'=>'='.$iPurchaseId)))
    $aPurchase = $oPurchase->aData;
else
    $oReq->forward('/');

list($aProducts,) = $oProduct2purchase->getList(array('purchase_id'=>'='.$iPurchaseId, 'status'=>'!="deleted"'));
foreach($aProducts as $nKey=>$aProduct) {
    $aProducts[$nKey]['price'] = round($aProduct['price']+$aProduct['price']*Conf::getSetting('MARKUP')/100, 2);
    $aProducts[$nKey]['price_sum'] = round($aProduct['price_sum']+$aProduct['price_sum']*Conf::getSetting('MARKUP')/100, 2);
}
$aPurchase['price'] = round($aPurchase['price']+$aPurchase['price']*Conf::getSetting('MARKUP')/100, 2);


$oUserReg  	= new Account();
$oCountry  	= new Country();
$aErrors 	= array();
$aUserReg 	= $aAccount;

// Время со смещением временной зоны на сегодня
$sTimezoneOffset = isset($_COOKIE['timezone'])?$_COOKIE['timezone']:0;
$nTime = time();
$nUtcTime = $nTime + date("Z", $nTime);
$nTimeOffset = $nUtcTime - Conf::getTimezoneOffset(time(), $sTimezoneOffset);
$aPurchase['time_from'] = Database::date(strtotime($aPurchase['time_from']) - Conf::getTimezoneOffset($nTimeOffset, $sTimezoneOffset, $aPurchase['shop_time_shift']));

$sTitle = Conf::format('Shopping cart');

$oTpl->assignSrc(array(
    'aUserReg' 			=> $aUserReg,
    'aErrors'		=> $aErrors,
    'aAccount'		=> $aAccount,
    'aPurchase'		=> $aPurchase,
    'aProducts'		=> $aProducts,
    'aCountries' => $oCountry->getHash('title',array(),'',$aLanguage['language_id'])
));

?>
