<?php

require_once 'classes/utils/dbitem.class.php';

class Zoom extends DbItem {
    var $aErrors = array();
	function Zoom()
	{
        parent::DbItem();
        $this->_initTable('zoom_api');
	}

    function getErrors() {
        return $this->aErrors;
    }

    function addUser($aData) {
        return $this->send('/user/custcreate', $aData);
    }

    function updateUser($aData) {
        return $this->send('/user/update', $aData);
    }

    function recreate($aData) {
        if ($this->deleteUser(array('id'=>$aData['id']))) {
            return $this->addUser($aData);
        }
        return false;
    }

    function deleteUser($aData) {
        return $this->send('/user/delete', $aData);
    }

    function addMeeting($aData) {
        return $this->send('/meeting/create', $aData);
    }

    function deleteMeeting($aData) {
        return $this->send('/meeting/delete', $aData);
    }

	function send($sUrl, $aData)
	{
        $aData['api_key'] = Conf::getSetting('ZOOM_API_KEY');
        $aData['api_secret'] = Conf::getSetting('ZOOM_API_SECRET');
        $ch = curl_init('https://api.zoom.us/v1'.$sUrl);
        curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($aData));
        curl_setopt($ch, CURLOPT_HEADER, 0);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 10);
        curl_setopt($ch, CURLOPT_TIMEOUT, 10);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        $sRetData = curl_exec($ch);
        curl_close($ch);

        $this->aData = array(
            'request' => json_encode($aData),
            'response' => $sRetData,
            'account_id' => isset($_SESSION['account'])?$_SESSION['account']['id']:0,
            'cdate' => Database::date()
        );
        $this->insert();

        $oRetData = json_decode($sRetData);
        if  (property_exists($oRetData, 'error') && $oRetData->error->code) {
            $this->aErrors[] = 'Error '.$oRetData->error->code .': '.$oRetData->error->message;
            return false;
        }



        return $oRetData;
	}
}