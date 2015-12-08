<?php
class Ogone extends DbItem {

    /**
     * Последние сообщения об ошибках
     * @var array
     */
    protected $_errors = array();

    function Ogone()
    {
        parent::DbItem();
        $this->_initTable('ogone_api');
    }


    /**
     * Сформировываем запрос
     *
     * @param string $method Данные о вызываемом методе перевода
     * @param array $params Дополнительные параметры
     * @return array / boolean Response array / boolean false on failure
     */
    public function request($url, $params = array()) {
        $this -> _errors = array();

        $ch = curl_init($url);
        $curlOptions = array (
            CURLOPT_URL => $url,
            CURLOPT_VERBOSE => 1,
            CURLOPT_RETURNTRANSFER => 1,
            CURLOPT_POST => 1,
            CURLOPT_POSTFIELDS => http_build_query($params)
        );
        curl_setopt_array($ch, $curlOptions);
        $response = curl_exec($ch);

        $this->aData = array(
            'request' => serialize($params),
            'response' => $response?$response:(curl_errno($ch)?('Error:'.curl_error($ch)):'unknown'),
            'account_id' => isset($_SESSION['account'])?$_SESSION['account']['id']:0,
            'purchase_id' => $params['ORDERID'],
            'cdate' => Database::date()
        );
        $this->insert();

        // Проверяем, нету ли ошибок в инициализации cURL
        if (curl_errno($ch)) {
            $this -> _errors[] = curl_error($ch);
            curl_close($ch);
            return false;
        } else  {
            curl_close($ch);
            return $response;
        }
    }

    function getErrors() {
        return $this -> _errors;
    }
}
?>