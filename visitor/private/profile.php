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
$aUserReg 	= $aAccount;//$oReq->getArray('aUser');
$aErrors 	= array();


switch ($oReq->getAction())
{
    case 'register':
    	$aUserReg 	= $oReq->getArray('aUser');
    	if ($aUserReg['pass']) {
            $aFields = array(
                'aUser[fname]' 	=> array('title'=>Conf::format('Name'),  'def'=>'required'),
                'aUser[lname]' 	=> array('title'=>Conf::format('Surname'),  'def'=>'required'),
                'aUser[email]' 		=> array('title'=>Conf::format('Email'),    'pattern'=>'/^[A-Za-z_0-9\.\-]+@[A-Za-z0-9\.\-]+\.[A-Za-z]{2,}$/'),
                'aUser[phone]' 		=> array('title'=>Conf::format('Phone'),    'def'=>'required'),
                'aUser[address]' 		=> array('title'=>Conf::format('Delivery address'),    'def'=>'required'),
                'aUser[timezone]' 		=> array('title'=>Conf::format('Time zone'),    'def'=>'required'),
                'aUser[pass]'  	=> array('title'=>Conf::format('Password'),   'pattern'=>'/^.{6,20}$/'),
                'pass_confirm'  => array('title'=>Conf::format('The password again'),   'pattern'=>'/^.{6,20}$/'),
            );
            if ($aAccount['status']=='seller')
                unset($aFields['aUser[email]']);
			$oValidator = new Validator($aFields, array(array('aUser[pass]', 'pass_confirm', '==')));
		} else {
            $aFields = array(
                'aUser[fname]' 	=> array('title'=>Conf::format('Name'),  'def'=>'required'),
                'aUser[lname]' 	=> array('title'=>Conf::format('Surname'),  'def'=>'required'),
                'aUser[email]' 		=> array('title'=>Conf::format('Email'),    'pattern'=>'/^[A-Za-z_0-9\.\-]+@[A-Za-z0-9\.\-]+\.[A-Za-z]{2,}$/'),
                'aUser[phone]' 		=> array('title'=>Conf::format('Phone'),    'def'=>'required'),
                'aUser[address]' 		=> array('title'=>Conf::format('Delivery address'),    'def'=>'required'),
                'aUser[timezone]' 		=> array('title'=>Conf::format('Time zone'),    'def'=>'required'),
            );
            if ($aAccount['status']=='seller')
                unset($aFields['aUser[email]']);
			$oValidator = new Validator($aFields);
		}

        if ($oValidator->isValid($oReq->getAll())){
	    	$oUserReg->aData = $aUserReg;       
	    	$oUserReg->aData['account_id'] = $oAccount->isLoggedIn();       
	    	if ($oUserReg->aData['pass']) 	        	
	    	    $oUserReg->aData['pass'] = md5($oUserReg->aData['pass']);
	    	else 
	    	 	unset($oUserReg->aData['pass']);
	    	
	        if ($oUserReg->isUniqueEmail($oAccount->isLoggedIn()))
	        {
                $oZoomUser = true;

                // запретить править почту для продавцов иначе слетят бронирования
               if ($aAccount['status']!='seller' && isset($aUserReg['email']))
                    unset($aUserReg['email']);

                // для продавцов возможна смена имени
                if ($aAccount['status']=='seller' && $aUserReg['fname']!=$aAccount['fname'])
                    $oZoomUser = $oZoom->updateUser(array('id'=>$aAccount['zoom_id'], 'type'=>1, 'first_name'=>$aUserReg['fname']));

                if ($oZoomUser) {
                    if ($oUserReg->update()) {
                        $oReq->forward('/'.($aLanguage['alias']).'/account/profile/', Conf::format('Data saved successfully'));
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
$sTitle = Conf::format('Settings');
$oTpl->assignSrc(array(
    'aUserReg' 			=> $aUserReg,
    'aErrors'		=> $aErrors,
    'bSuccess'		=> $bSuccess,
    'aAccount'		=> $aAccount,
    'aTimezones'		=> Conf::get('timezones'),
));

?>
