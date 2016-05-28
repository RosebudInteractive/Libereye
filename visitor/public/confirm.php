<?php
/** ============================================================
 * Страница подтверждения емайла
 *   Area: admin
 *   Sect: register
 * @author Rudenko S.
 * @package visitor
 * ============================================================ */
Conf::loadClass('Account');
Conf::loadClass('utils/mail/Mailer'); 

$oAccountRemind = new Account();
$sConfirmCode = $oReq->get('code');
$bConfirmed = false;
if ($sConfirmCode && $oAccount->loadBy(array('confirm_code'=>'="'.Database::escape($sConfirmCode).'"', 'is_active'=>'=0')))
{
    $oAccount->aData = array('account_id'=>$oAccount->aData['account_id']);
    $oAccount->aData['is_active'] = 1;
    $oAccount->aData['confirm_date'] = Database::date();
    $bConfirmed = $oAccount->update();
    if ($bConfirmed)
        $oReq->forward('/'.$aLanguage['alias'].'/');
}
$oTpl->assign(array(
    'bConfirmed'    	=> $bConfirmed,
));


?>
