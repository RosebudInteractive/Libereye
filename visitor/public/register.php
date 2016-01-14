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

$oUserReg  	= new Account();
$oZoom  	= new Zoom();
$bSuccess 	= $oReq->get('success');
$aUserReg 	= $oReq->getArray('aUser');

$aFields = array(
    'aUser[fname]' 	=> array('title'=>Conf::format('Name'),  'pattern'=>'/^.{1,255}$/'),
  //  'aUser[lname]' 	=> array('title'=>Conf::format('Surname'),  'pattern'=>'/^.{1,255}$/'),
    'aUser[email]' 		=> array('title'=>Conf::format('Email'),    'pattern'=>'/^[A-Za-z_0-9\.\-]+@[A-Za-z0-9\.\-]+\.[A-Za-z]{2,}$/'),
  //  'aUser[phone]' 		=> array('title'=>Conf::format('Phone'),    'def'=>'required'),
  //  'aUser[address]' 		=> array('title'=>Conf::format('Delivery address'),    'def'=>'required'),
  //  'aUser[timezone]' 		=> array('title'=>Conf::format('Time zone'),    'def'=>'required'),
    'aUser[pass]'  	=> array('title'=>Conf::format('Password'),   'pattern'=>'/^.{6,20}$/'),
    'pass_confirm'  => array('title'=>Conf::format('The password again'),   'pattern'=>'/^.{6,20}$/'),
);

$oValidator = new Validator($aFields, array(array('aUser[pass]', 'pass_confirm', '==')));
$aErrors 	= array();

switch ($oReq->getAction())
{
    case 'facebook':
        $nUserId = 0;
        $aUserReg = array(
            'fname' => $oReq->get('name'),
            'email' => $oReq->get('email'),
            'register_id' => $oReq->get('id'),
            'token' => $oReq->get('token'),
        );
        $aFields = array(
            'fname'  => array('title'=>Conf::format('Name'),  'def'=>'required'),
            'email' => array('title'=>Conf::format('Email'),  'pattern'=>'/^[A-Za-z_0-9\.\-]+@[A-Za-z0-9\.\-]+\.[A-Za-z]{2,}$/'),
            'register_id' => array('title'=>Conf::format('ID'),  'def'=>'required'),
            'token' => array('title'=>Conf::format('Token'),  'def'=>'required'),
        );
        $oValidator = new Validator($aFields);
        if ($oValidator->isValid($aUserReg)){

            // Проверяем валидность данных
            require_once Conf::get('path') . '/include/classes/utils/facebook/vendor/autoload.php';
            $fb = new Facebook\Facebook([
                'app_id' => Conf::get('facebook_app_id'),
                'app_secret' => Conf::get('facebook_app_secret'),
                'default_graph_version' => 'v2.5',
            ]);
            try {
                // Returns a `Facebook\FacebookResponse` object
                $response = $fb->get('/me?fields=id,name,email', $aUserReg['token']);
            } catch(Facebook\Exceptions\FacebookResponseException $e) {
                $aErrors[] = 'Facebook: Graph returned an error: ' . $e->getMessage();
            } catch(Facebook\Exceptions\FacebookSDKException $e) {
                $aErrors[] = 'Facebook: Facebook SDK returned an error: ' . $e->getMessage();
            }

            if (!$aErrors) {
                $user = $response->getGraphUser();
                $oUserReg->aData = $aUserReg;
                $oUserReg->aData['cdate'] = Database::date();
                $oUserReg->aData['status'] = 'client';
                $oUserReg->aData['register_type'] = 'facebook';
                $oUserReg->aData['is_active'] = 1;
                $oUserReg->aData['fname'] = $user['name'];
                $oUserReg->aData['email'] = $user['email'];
                $oUserReg->aData['register_id'] = $user['id'];
                if ($oUserReg->isUniqueEmail()) {
                    if (($nUserId = $oUserReg->insert())) {
                        if (!$oUserReg->login('', '', array('client'), 'facebook', $user['id']))
                            $aErrors = $oUserReg->getErrors();
                    } else
                        $aErrors = $oUserReg->getErrors();
                } else
                    $aErrors[] = Conf::format('This email address is already registered');
            }
        } else
            $aErrors = $oValidator->getErrors();
        echo json_encode(array('errors'=>$aErrors, 'id'=>$nUserId));
        exit;
        break;
    case 'register':
        if ($oValidator->isValid($oReq->getAll())){
	    	$oUserReg->aData = $aUserReg;        	        	
	    	$oUserReg->aData['pass'] = md5($oUserReg->aData['pass']);
	    	$oUserReg->aData['cdate'] = Database::date();
	    	$oUserReg->aData['status'] = 'client';
	    	
	        if ($oUserReg->isUniqueEmail())
	        {
              /*  $oZoomUser = $oZoom->addUser(array(
                    'email' => $aUserReg['email'],
                    'type' => 1,
                    'first_name' => $aUserReg['fname'],
                ));*/
                $oZoomUser = true;

                if ($oZoomUser) {
                    if (is_object($oZoomUser) && property_exists($oZoomUser, 'id'))
                        $oUserReg->aData['zoom_id'] = $oZoomUser->id;
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
                                'confirm_code_url'	=>  Conf::get('http').Conf::get('host').'confirm/?code='.$sConfirmCode,
                            )
                        ,array(), array(), $aLanguage['language_id']);

                        $oReq->forward('/'.$aLanguage['alias'].'/register/success/?email=' . urlencode($aUserReg['email']));

                    }else
                        $aErrors = $oUserReg->getErrors();
                } else {
                    $aErrors = $oZoom->getErrors();
                }
	        }
	        else
	            $aErrors[] = Conf::format('This email address is already registered');
        } else
            $aErrors = $oValidator->getErrors();
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
