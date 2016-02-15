<?php
/** ============================================================
 * Area controller.
 *   Area: admin
 * @author Rudenko S.
 * @package admin
 * ============================================================ */
date_default_timezone_set('Europe/Moscow');
setlocale(LC_ALL, 'ru_RU');

require_once '../include/admin.inc.php';
	
Conf::loadClass('Admin');

//START initialisation
$oAdmin = &new Admin();
//check login
$iAdminId = $oAdmin->isLoggedIn();
define('LANGUAGEID', 1);

if (!$iAdminId)
    $oReq->gotoUrl('admin.login');
else {
	$oAdmin->load($oAdmin->isLoggedIn());
	$aLoginUserData = $oAdmin->aData;
    //$oReq->forward('/adminw/');
}
//END initialisation

if ($aLoginUserData['status'] == 'manager') {
	require_once '../include/manager.inc.php';
}


//START process request
$sTitle = $oReq->getSectionTitle();
require_once $oReq->getSectionFile();
//END request process area

//START post-processing
$oTpl->addMes($oUrl->getUrl());
$oTpl->assign(array(
    'aErrors' => $aErrors,
    'sTitle'  => $sTitle,
    'aMenu'   => $oReq->getMenu(),
    'aSubMenu'=> $oReq->getSubMenu(),
    'aLoginUserData' => $aLoginUserData,
));

unset($aLoginUserData['pass']);
$oTpl->assignSrc(array(
    'aLoginUserDataJson' => json_encode($aLoginUserData),
));

$oTpl->view('admin/'.$oReq->getSectionFile('html'));
//END post-processing
?>