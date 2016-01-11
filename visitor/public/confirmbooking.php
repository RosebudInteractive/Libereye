<?php
/** ============================================================
 * Страница подтверждения емайла
 *   Area: admin
 *   Sect: register
 * @author Rudenko S.
 * @package visitor
 * ============================================================ */
Conf::loadClass('Booking');
Conf::loadClass('utils/mail/Mailer'); 

$oBookingRemind = new Booking();
$sConfirmCode = $oReq->get('code');
$bConfirmed = false;
if ($sConfirmCode && $oBooking->loadBy(array('confirm_code'=>'="'.Database::escape($sConfirmCode).'"', 'is_active'=>'=0')))
{
    $oBooking->aData['is_active'] = 1;
    $oBooking->aData['confirm_date'] = Database::date();
    $bConfirmed = $oBooking->update();
}
$oTpl->assign(array(
    'bConfirmed'    	=> $bConfirmed,
));


?>
