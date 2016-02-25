<?php
class Paypal extends DbItem {

    /**
     * ��������� ��������� �� �������
     * @var array
     */
    protected $_errors = array();

    /**
     * ������ API
     * �������� �������� �� ��, ��� ��� ��������� ����� ������������ ��������������� ������
     * @var array
     */
    protected $_credentials = array();

    /**
     * ���������, ���� ����� ������������ ������
     * �������� ������� - https://api-3t.paypal.com/nvp
     * ��������� - https://api-3t.sandbox.paypal.com/nvp
     * @var string
     */
    protected $_endPoint = 'https://api-3t.sandbox.paypal.com/nvp';

    /**
     * ������ API
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
     * �������������� ������
     *
     * @param string $method ������ � ���������� ������ ��������
     * @param array $params �������������� ���������
     * @return array / boolean Response array / boolean false on failure
     */
    public function request($method,$params = array()) {
        $this -> _errors = array();
        if( empty($method) ) { // ���������, ������ �� ������ �������
            $this -> _errors = array('�� ������ ����� �������� �������');
            return false;
        }

        // ��������� ������ �������
        $requestParams = array(
                'METHOD' => $method,
                'VERSION' => $this -> _version
            ) + $this -> _credentials;

        // �������������� ������ ��� NVP
        $request = http_build_query($requestParams + $params);

        // ����������� cURL
        $curlOptions = array (
            CURLOPT_URL => $this -> _endPoint,
            CURLOPT_VERBOSE => 1,
            //CURLOPT_SSL_VERIFYPEER => true,
            //CURLOPT_SSL_VERIFYHOST => 2,
            //CURLOPT_CAINFO => dirname(__FILE__) . '/cacert.pem', // ���� �����������
            CURLOPT_RETURNTRANSFER => 1,
            CURLOPT_POST => 1,
            CURLOPT_POSTFIELDS => $request
        );


        $ch = curl_init();
        curl_setopt_array($ch,$curlOptions);

        // ���������� ��� ������, $response ����� ��������� ����� �� API
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

        // ���������, ���� �� ������ � ������������� cURL
        if (curl_errno($ch)) {
            $this -> _errors[] = curl_error($ch);
            curl_close($ch);
            return false;
        } else  {
            curl_close($ch);
            $responseArray = array();
            parse_str($response,$responseArray); // ��������� ������, ���������� �� NVP � ������
            return $responseArray;
        }
    }

    function getErrors() {
        return $this -> _errors;
    }
}
?>