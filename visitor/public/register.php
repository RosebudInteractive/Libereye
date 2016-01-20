<?php
/** ============================================================
 * Страница регистрации новых пользователей
 *   Area: admin
 *   Sect: register
 * @author Rudenko S.
 * @package visitor
 * ============================================================ */
Conf::loadClass('Account');
Conf::loadClass('utils/Zoom');
Conf::loadClass('utils/Validator');
Conf::loadClass('utils/file/Image');
Conf::loadClass('utils/mail/Mailer');
Conf::loadClass('utils/vk/Vk');

$oUserReg  	= new Account();
$oZoom  	= new Zoom();
$bSuccess 	= $oReq->get('success');
$aUserReg 	= $oReq->getArray('aUser');

$aFields = array(
    'fname' 	=> array('title'=>Conf::format('Name'),  'pattern'=>'/^.{1,255}$/'),
    'email' 		=> array('title'=>Conf::format('Email'),    'pattern'=>'/^[A-Za-z_0-9\.\-]+@[A-Za-z0-9\.\-]+\.[A-Za-z]{2,}$/'),
    'pass'  	=> array('title'=>Conf::format('Password'),   'pattern'=>'/^.{6,20}$/'),
    'pass_confirm'  => array('title'=>Conf::format('The password again'),   'pattern'=>'/^.{6,20}$/'),
);

$oValidator = new Validator($aFields, array(array('pass', 'pass_confirm', '==')));
$aErrors 	= array();

switch ($oReq->getAction())
{
    case 'google_register':
    case 'google_login':
        $nUserId = 0;
        $aSession = $oReq->getArray('session');

        // login
        require_once Conf::get('path') . '/include/classes/utils/google/vendor/autoload.php';
        $client = new Google_Client();
        $client->setApplicationName("Google+ PHP Starter Application");

        $client->setClientId(Conf::get('google_client_id'));
        $client->setClientSecret(Conf::get('google_app_secret'));
        $client->setDeveloperKey(Conf::get('google_app_id'));
        // {"access_token":"TOKEN", "refresh_token":"TOKEN", "token_type":"Bearer",
        // "expires_in":3600, "id_token":"TOKEN", "created":1320790426}
        $client->setAccessToken(json_encode(array(
            'access_token' => $aSession['access_token'],
            'token_type' => $aSession['token_type'],
            'created' => $aSession['issued_at'],
            'expires_in' => $aSession['expires_in'],
            'refresh_token' => 'TOKEN',
            'id_token' => 'TOKEN',
        )));
        $client->setScopes(array('https://www.googleapis.com/auth/userinfo.email','https://www.googleapis.com/auth/userinfo.profile'));
        $oauth = new Google_Service_Oauth2($client);
        $user = $oauth->userinfo->get();
        if ($user->email)
        if (!$user->givenName) $aErrors[] = Conf::format('Name required');
        if (!$user->email) $aErrors[] = Conf::format('Email required');
        if (!$user->id) $aErrors[] = Conf::format('ID required');

        if (!$aErrors) {
            if ($oReq->getAction() == 'google_register') {
                $oUserReg->aData = array();
                $oUserReg->aData['cdate'] = Database::date();
                $oUserReg->aData['status'] = 'client';
                $oUserReg->aData['register_type'] = 'google';
                $oUserReg->aData['is_active'] = 1;
                $oUserReg->aData['fname'] = $user->givenName.' '.$user->familyName;
                $oUserReg->aData['email'] = $user->email;
                $oUserReg->aData['register_id'] = $user->id;
                if ($oUserReg->isUniqueEmail()) {
                    if ($oUserReg->isUniqueRegID('google', $user->id)) {
                        if (($nUserId = $oUserReg->insert())) {
                            if (!$oUserReg->login('', '', array('client'), 'google', $user->id))
                                $aErrors = $oUserReg->getErrors();
                        } else
                            $aErrors = $oUserReg->getErrors();
                    } else
                        $aErrors[] = Conf::format('This account already registered');
                } else
                    $aErrors[] = Conf::format('This email already registered');
            } else {
                if (!$oUserReg->login('', '', array('client'), 'google', $user->id))
                    $aErrors = $oUserReg->getErrors();
            }
        }
        echo json_encode(array('errors'=>$aErrors, 'id'=>$nUserId));
        exit;
        break;
    case 'vk_register':
    case 'vk_login':
        $nUserId = 0;
        $aSession = $oReq->getArray('session');
        $oVk = new Vk(Conf::get('vk_app_id'), Conf::get('vk_app_secret'), $aSession);
        if ($oVk->authOpenAPIMember()) {
            require_once Conf::get('path') . '/include/classes/utils/vk/VK.php';
            require_once Conf::get('path') . '/include/classes/utils/vk/VKException.php';
            try {
                $vk = new VK\VK(Conf::get('vk_app_id'), Conf::get('vk_app_secret'), $aSession['sid']);
                // User authorization failed: access_token was given to another ip address.
                //$user = $vk->api('users.get', array('fields' => 'uid,first_name,last_name,email'));
                $user = array('response'=>array(array('uid'=>$aSession['user']['id'],'first_name'=>$aSession['user']['first_name'],'last_name'=>$aSession['user']['last_name'])));
                if ($aSession['sid'] && isset($user['response']) && isset($user['response'][0]) && isset($user['response'][0]['uid'])) {
                    if (!$user['response'][0]['first_name']) $aErrors[] = Conf::format('Name required');
                    if (!$user['response'][0]['uid']) $aErrors[] = Conf::format('ID required');
                    if (!$aErrors) {
                        if ($oReq->getAction() == 'vk_register') {
                            $oUserReg->aData = array();
                            $oUserReg->aData['cdate'] = Database::date();
                            $oUserReg->aData['status'] = 'client';
                            $oUserReg->aData['register_type'] = 'vk';
                            $oUserReg->aData['is_active'] = 1;
                            $oUserReg->aData['fname'] = $user['response'][0]['first_name'] . ' ' . $user['response'][0]['last_name'];
                            $oUserReg->aData['register_id'] = $user['response'][0]['uid'];
                            $oUserReg->aData['email'] = $user['response'][0]['uid'] . '@vk.com';
                            if ($oUserReg->isUniqueRegID('vk', $user['response'][0]['uid'])) {
                                if (($nUserId = $oUserReg->insert())) {
                                    if (!$oUserReg->login('', '', array('client'), 'vk', $user['response'][0]['uid']))
                                        $aErrors = $oUserReg->getErrors();
                                } else
                                    $aErrors = $oUserReg->getErrors();
                            } else
                                $aErrors[] = Conf::format('This account already registered');
                        } else {
                            if (!$oUserReg->login('', '', array('client'), 'vk', $user['response'][0]['uid']))
                                $aErrors = $oUserReg->getErrors();
                        }
                    }
                } else
                    $aErrors[] = Conf::format('User not authorized');
            } catch (VK\VKException $error) {
                $aErrors[] = $error->getMessage();
            }
        } else
            $aErrors[] = Conf::format('User not authorized');
        echo json_encode(array('errors'=>$aErrors, 'id'=>$nUserId));
        exit;
        break;
    case 'facebook_register':
    case 'facebook_login':
        $nUserId = 0;
        $sToken = $oReq->get('token');

        // Проверяем валидность данных
        require_once Conf::get('path') . '/include/classes/utils/facebook/vendor/autoload.php';
        $fb = new Facebook\Facebook([
            'app_id' => Conf::get('facebook_app_id'),
            'app_secret' => Conf::get('facebook_app_secret'),
            'default_graph_version' => 'v2.5',
        ]);
        try {
            // Returns a `Facebook\FacebookResponse` object
            $response = $fb->get('/me?fields=id,name,email', $sToken);
        } catch(Facebook\Exceptions\FacebookResponseException $e) {
            $aErrors[] = 'Facebook: Graph returned an error: ' . $e->getMessage();
        } catch(Facebook\Exceptions\FacebookSDKException $e) {
            $aErrors[] = 'Facebook: Facebook SDK returned an error: ' . $e->getMessage();
        }

        if (!$aErrors) {
            $user = $response->getGraphUser();
            if (!$user['name']) $aErrors[] = Conf::format('Name required');
            if (!$user['email']) $aErrors[] = Conf::format('Email required');
            if (!$user['id']) $aErrors[] = Conf::format('ID required');

            if (!$aErrors) {
                $user = $response->getGraphUser();
                if ($oReq->getAction() == 'facebook_register') {
                    $oUserReg->aData = $aUserReg;
                    $oUserReg->aData['cdate'] = Database::date();
                    $oUserReg->aData['status'] = 'client';
                    $oUserReg->aData['register_type'] = 'facebook';
                    $oUserReg->aData['is_active'] = 1;
                    $oUserReg->aData['fname'] = $user['name'];
                    $oUserReg->aData['email'] = $user['email'];
                    $oUserReg->aData['register_id'] = $user['id'];
                    if ($oUserReg->isUniqueEmail()) {
                        if ($oUserReg->isUniqueRegID('facebook', $user['id'])) {
                            if (($nUserId = $oUserReg->insert())) {
                                if (!$oUserReg->login('', '', array('client'), 'facebook', $user['id']))
                                    $aErrors = $oUserReg->getErrors();
                            } else
                                $aErrors = $oUserReg->getErrors();
                        } else
                            $aErrors[] = Conf::format('This account already registered');
                    } else
                        $aErrors[] = Conf::format('This email already registered');
                } else {
                    if (!$oUserReg->login('', '', array('client'), 'facebook', $user['id']))
                        $aErrors = $oUserReg->getErrors();
                }
            }
        }
        echo json_encode(array('errors'=>$aErrors, 'id'=>$nUserId));
        exit;
        break;
    case 'register':
        $nUserId = 0;
        if ($oValidator->isValid($oReq->getAll())){
            $aUserReg = $oUserReg->aData = array(
                'fname' => $oReq->get('name'),
                'email' => $oReq->get('email'),
                'pass' => $oReq->get('pass'),
                'birthday' => $oReq->get('birthday'),
                'status' => 'client',
                'register_type' => 'common',
                'cdate' => Database::date(),
            );
	    	$oUserReg->aData['pass'] = md5($oUserReg->aData['pass']);

	        if ($oUserReg->isUniqueEmail())
	        {
                if (($nUserId = $oUserReg->insert())) {
                    $sConfirmCode = md5(uniqid(rand(), true));
                    $oUserReg->aData = array('account_id'=>$nUserId, 'confirm_code'=>$sConfirmCode);
                    $oUserReg->update();
                    // отправляем подтверждение
                    $oMailer = new Mailer();
                    $bSended = $oMailer->send(
                        'confirm_template',
                        $aUserReg['email'],
                        array(
                            'confirm_code_url'	=>  Conf::get('http').Conf::get('host').$aLanguage['alias'].'/confirm/?code='.$sConfirmCode,
                        )
                    ,array(), array(), $aLanguage['language_id']);
                    if ($oReq->get('ajax')) {
                        echo json_encode(array('errors'=>$aErrors, 'id'=>$nUserId));
                        exit;
                    } else
                        $oReq->forward('/'.$aLanguage['alias'].'/register/success/?email=' . urlencode($aUserReg['email']));
                }else
                    $aErrors = $oUserReg->getErrors();
	        }
	        else
	            $aErrors[] = Conf::format('This email address is already registered');
        } else
            $aErrors = $oValidator->getErrors();

        if ($oReq->get('ajax')) {
            echo json_encode(array('errors'=>$aErrors, 'id'=>$nUserId));
            exit;
        }
        break;
}



// Title
$sTitle = Conf::format('Register');
$oTpl->assignSrc(array(
    'aUserReg' 			=> $aUserReg,
    'aErrors'		=> $aErrors,
    'bSuccess'		=> $bSuccess,
    'sEmail'		=> $oReq->get('email'),
    'aTimezones'		=> Conf::get('timezones'),
));

?>
