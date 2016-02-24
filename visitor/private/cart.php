<?php
/** ============================================================
 * —траница регистрации новых пользователей
 *   Area: admin
 *   Sect: register
 * @author Rudenko S.
 * @package visitor
 * ============================================================ */
Conf::loadClass('Account');
Conf::loadClass('Country');
Conf::loadClass('Purchase');
Conf::loadClass('Product2purchase');

$oPurchase = new Purchase();
$oProduct2purchase = new Product2purchase();
$iPurchaseId = $oReq->getInt('id');
$aPurchase = array();
if ($oPurchase->loadBy(array('account_id'=>'='.$oAccount->isLoggedIn(), 'purchase_id'=>'='.$iPurchaseId)))
    $aPurchase = $oPurchase->aData;
else
    $oReq->forward('/');

list($aProducts,) = $oProduct2purchase->getList(array('purchase_id'=>'='.$iPurchaseId));

$oUserReg  	= new Account();
$oCountry  	= new Country();
$aErrors 	= array();
$aUserReg 	= $aAccount;
d($aPurchase);



$oTpl->assignSrc(array(
    'aUserReg' 			=> $aUserReg,
    'aErrors'		=> $aErrors,
    'aAccount'		=> $aAccount,
    'aPurchase'		=> $aPurchase,
    'aProducts'		=> $aProducts,
    'aCountries' => $oCountry->getHash('title',array(),'',$aLanguage['language_id'])
));

?>
