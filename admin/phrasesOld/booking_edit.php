<?php
/** ============================================================
 * Part section.
 *   Area:    admin
 *   Part:    stats
 *   Section: sales
 * @author Rudenko S.
 * @package admin
 * ============================================================ */
Conf::loadClass('utils/Validator');
Conf::loadClass('Booking');

$oBooking = new Booking();

$iBookingId = $oReq->getInt('id'); 
if($iBookingId)
    $oBooking->load($iBookingId);
else 
    $oBooking->aData = array('fname' => '', 'email' => '', 'booking_id' => '0');    

if ($iBookingId)
//validator fields
$aFields = array(
    'aBooking[fname]'   => array('title'=>'Имя', 'def'=>'required',),
    'aBooking[email]'   => array('title'=>'Email', 'def'=>'email'),
    'aBooking[pass]'    => array('title'=>'Пароль', 'def'=>'password', 'optional' =>true),
    'pass_confirm'      => array('title'=>'Повторить пароль', 'def'=>'password', 'optional' =>true),
);     
else
//validator fields
$aFields = array(
    'aBooking[fname]'   => array('title'=>'Имя', 'def'=>'required',),
    'aBooking[email]'   => array('title'=>'Email', 'def'=>'email'),
    'aBooking[pass]'    => array('title'=>'Пароль', 'def'=>'password'),
    'pass_confirm'      => array('title'=>'Повторить пароль', 'def'=>'password'),
);     

//create validator
$oValidator = new Validator($aFields, array(array('aBooking[pass]', 'pass_confirm', '=='))); 
    
// ========== processing actions ==========
switch($oReq->getAction())
{
    // === update ====
    case 'Сохранить':
        if ($oValidator->isValid($oReq->getAll()))
        {
            $oBooking->aData = $oReq->getArray('aBooking');
            $oBooking->aData['booking_id'] = $iBookingId;

            if ($oBooking->update())
                $oReq->forward(conf::getUrl('admin.bookings'), conf::getMessages('booking.updated'));
            else
                $aErrors = $oBooking->getErrors();
        }
        else
            $aErrors = $oValidator->getErrors();
        break; 
    case 'Создать':
        if ($oValidator->isValid($oReq->getAll()))
        {
            $oBooking->aData = $oReq->getArray('aBooking');
            $oBooking->aData['cdate'] = Database::date();
            if ($oBooking->isUniqueEmail($iBookingId))
            {                                
                    if ($oBooking->insert())
                        $oReq->forward(conf::getUrl('admin.bookings'), conf::getMessages('booking.created'));
                    else 
                        $aErrors = $oBooking->getErrors();
            }
            else
                $aErrors = $oBooking->getErrors();
        }
        else
            $aErrors = $oValidator->getErrors();
        break; 
  
    case 'Удалить':    
        if($oBooking->delete($oReq->getInt('id')))        
            $oReq->forward(conf::getUrl('admin.bookings'), conf::getMessages('booking.deleted'));
        else 
            $aErrors = $oBooking->getErrors();
    case 'Отмена':    
            $oReq->forward(conf::getUrl('admin.bookings'));
        break;
        
                
}

$oTpl->assign(array(
    'aBooking' => $oBooking->aData,
    'sJs'      => $oValidator->makeJS(),    
    'aStatuses'      => array('client'=>'client', 'seller'=>'seller', 'admin'=>'admin'),
));
?>