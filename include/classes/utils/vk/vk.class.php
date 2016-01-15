<?php
class Vk {
    var $appId = null;
    var $appSecret = null;
    var $session = null;

    function Vk($appId, $appSecret, $session){
        $this->appId = $appId;
        $this->appSecret = $appSecret;
        $this->session = $session;
    }

    function authOpenAPIMember() {
        $session = array();
        $member = FALSE;
        $valid_keys = array('expire', 'mid', 'secret', 'sid', 'sig');
        foreach ($this->session as $key=>$value) {
            if (empty($key) || empty($value) || !in_array($key, $valid_keys)) {
                continue;
            }
            $session[$key] = $value;
        }
        foreach ($valid_keys as $key) {
            if (!isset($session[$key])) return $member;
        }
        ksort($session);
        $sign = '';
        foreach ($session as $key => $value) {
            if ($key != 'sig') {
                $sign .= ($key.'='.$value);
            }
        }
        $sign .= $this->appSecret;
        $sign = md5($sign);
        if ($session['sig'] == $sign && $session['expire'] > time()) {
            $member = array(
                'id' => intval($session['mid']),
                'secret' => $session['secret'],
                'sid' => $session['sid']
            );
        }
        return $member;
    }
}
?>