<?php
/** ============================================================
 * Stand-alone page
 *   Area: admin
 *   Page: login
 * @author Rudenko S.
 * @package admin
 * ============================================================ */
require_once '../include/admin.inc.php';
Conf::loadClass('Admin');
Conf::loadClass('utils/Validator');

$oAdmin = &new Admin();

$sLogin = $oReq->get('login');
$sPass  = $oReq->get('pass');

$aFields = array(
    'login' => array('title'=>'Логин',    'def'=>'email'),
    'pass'  => array('title'=>'Пароль', 'def'=>'required')
);

$oValidator = new Validator($aFields);

$aErrors = array();

switch ($oReq->getAction())
{
    case 'login':
        if ($oValidator->isValid($oReq->getAll()))
        {
            if ($oAdmin->login($sLogin, $sPass, array('admin', 'manager', 'translator'))) {
                $oAdmin->load($oAdmin->isLoggedIn());
                if ($oAdmin->aData['status'] == 'translator')
                    $oReq->forward('/adminw/#!/app/phrases');
                else
                    $oReq->forward('/adminw/');
            }
            $aErrors[] = conf::format('login.error');
        }
        else
            $aErrors = $oValidator->getErrors();
        break;
}

$oTpl->assign(array(
    'aValidator' => $oValidator->makeJS(),
    'sLogin'     => $sLogin,
    'aErrors'    => $aErrors,
));

$oTpl->display('admin/login.html');
?>