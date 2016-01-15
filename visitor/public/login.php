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

$oAccount  = new Account();
$sLogin = $oReq->get('email');
$sPass = $oReq->get('pass');

$aFields = array(
    'email' => array('title'=>Conf::format('Email'),    'pattern'=>'/^[A-Za-z_0-9\.\-]+@[A-Za-z0-9\.\-]+\.[A-Za-z]{2,}$/'),
    'pass'  => array('title'=>Conf::format('Password'),   'pattern'=>'/^.{6,20}$/')
);

$oValidator = new Validator($aFields);
$aErrors = array();
$sRedirect = '';

switch ($oReq->getAction())
{
    case 'login':
        if ($oValidator->isValid($oReq->getAll()))
        {
            if ($oAccount->login($sLogin, $sPass, array(), 'common', 0, $oReq->get('remember'))){
                if ($oReq->get('ajax')) {
                    echo json_encode(array('errors'=>$aErrors));
                    exit;
                }
                else
                    $oReq->forward('/'.$aLanguage['alias'].'/');
            } 
            else           
            	$aErrors[] = Conf::format('Incorrect password or e-mail');
        }
        else
            $aErrors[] = Conf::format('Incorrect password or e-mail');
        if ($oReq->get('ajax')) {
            echo json_encode(array('errors'=>$aErrors));
            exit;
        }
        break;
}

// Title
$sTitle = Conf::format('Enter the site');
$oTpl->assignSrc(array(
    'aErrors'		=> $aErrors,
    'sLogin'		=> $sLogin,
));
?>