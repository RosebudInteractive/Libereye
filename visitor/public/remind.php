<?php
/** ============================================================
 * Stand-alone page
 *   Area: admin
 *   Page: login
 * @author Rudenko S.
 * @package admin
 * ============================================================ */
require_once '../include/visitor.inc.php';
Conf::loadClass('Account');
Conf::loadClass('utils/Validator');
Conf::loadClass('utils/mail/Mailer');

$oUserRemind  = new Account();
$sLogin = $oReq->get('email');
$bSuccess 	= $oReq->get('success');

$aFields = array(
    'email' => array('title'=>Conf::format('Email'),    'pattern'=>'/^[A-Za-z_0-9\.\-]+@[A-Za-z0-9\.\-]+\.[A-Za-z]{2,}$/'),
);

$oValidator = new Validator($aFields);
$aErrors = array();
$sRedirect = '';

switch ($oReq->getAction())
{
    case 'login':
        if ($oValidator->isValid($oReq->getAll()))
        {
            if ($oUserRemind->loadBy(array('email'=>'="'.Database::escape($sLogin).'"')))
            {                  
        		$sPassword = $oUserRemind->genPass();
        		$sName = $oUserRemind->aData['fname'];
        		$sUserEmail = $oUserRemind->aData['email'];
    			$oUserRemind->aData['pass'] = md5($sPassword);
        		if ($oUserRemind->update())
        		{
        			$oMailer = new Mailer();    
                    $bSended = $oMailer->send('remind_template', 
                    				$sUserEmail, 
                    				array(  'name'	=>  $sName,
                    						'password'	=> 	$sPassword,
                    ),array(), array(), $aLanguage['language_id']);
                    $oReq->forward('/'.$aLanguage['alias'].'/account/remind/success/', Conf::format('New password sent to your address'));
        		}
        		else 
        			$aErrors = $oUserRemind->getErrors();
            }
            else
                $aErrors[] = Conf::format('User with this email address will not be found');
        }
        else
            $aErrors[] = Conf::format('Incorrect e-mail');
        break;
}

// Title
$sTitle = Conf::format('Password recovery');
$oTpl->assignSrc(array(
    'aErrors'		=> $aErrors,
    'sLogin'		=> $sLogin,
    'bSuccess'		=> $bSuccess,
));
?>