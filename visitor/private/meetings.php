<?php
/** ============================================================
 * Страница бронирования времени
 *   Area: admin
 *   Sect: register
 * @author Rudenko S.
 * @package visitor
 * ============================================================ */
Conf::loadClass('Account');
Conf::loadClass('ShopSlot');
Conf::loadClass('Shop');
Conf::loadClass('utils/Validator');
Conf::loadClass('utils/file/Image');
Conf::loadClass('utils/mail/Mailer'); 

$oAccount  	= new Account();
$oShopSlot  	= new ShopSlot();
$oShop  	= new Shop();
$aErrors 	= array();
$sTimezoneOffset = isset($_COOKIE['timezone'])?$_COOKIE['timezone']:0;

// доступна только продавцам
if ($aAccount['status'] != 'seller') {
    $oReq->forward('/');
}


switch ($oReq->getAction())
{
    case 'add':
    	$iTime = $oReq->get('time');
    	$iSeller = $oReq->getInt('seller');
        if ($iSeller && $oAccount->loadBy(array('account_id'=>'='.$iSeller))) {
        } else {
            $aErrors[] = Conf::format('Seller is not found');
        }
        if (strtotime(Database::date($iTime))===false)
            $aErrors[] = Conf::format('Time booking stated incorrectly');

        if (!$aErrors) {
            if ($oBooking->getCount(array('seller_id'=>'='.$iSeller, 'fromdate'=>'="'.Database::date($iTime).'"')))
                $aErrors[] = Conf::format('Time booking is already taken');
        }

        $iTimeHour = date('H', $iTime)*60*60 + date('i', $iTime)*60;
        if (!(isset($aTimes[$iTimeHour]) && !$aTimes[$iTimeHour]['dinner']))
            $aErrors[] = Conf::format('Time booking is not available');


        if (!$aErrors) {
            $oBooking->aData = array(
                'account_id' => $oAccount->isLoggedIn(),
                'seller_id' => $iSeller,
                'status' => 'pending',
                'cdate' => Database::date(),
                'udate' => Database::date(),
                'fromdate' => Database::date($iTime),
                'todate' => Database::date($iTime+30*60),
            );
            $oZoomMeeting = $oZoom->addMeeting(array(
                'host_id'=>$aSeller['zoom_id'],
                'topic'=>$aSeller['fname'].' '.date('d/m/Y H:i', $iTime),
                'type'=>2,
                'start_time'=>date('Y-m-d\TH:i:s\Z', $iTime),
                'duration'=>30,
                'timezone'=>$aAccount['timezone']
            ));

            if ($oZoomMeeting) {
                $oBooking->aData['zoom_id'] = $oZoomMeeting->id;
                $oBooking->aData['zoom_start_url'] = $oZoomMeeting->start_url;
                $oBooking->aData['zoom_join_url'] = $oZoomMeeting->join_url;
                if (!$oBooking->insert())
                    $aErrors = $oBooking->getErrors();
            } else {
                $aErrors = $oZoom->getErrors();
            }
        }

        echo json_encode(array('errors'=>$aErrors, 'item'=>array('zoom_join_url'=>$oBooking->aData['zoom_join_url'])));
        exit;
        break;

    case 'del':
    	$iTime = $oReq->get('time');
    	$iSeller = $oReq->getInt('seller');
        if ($iSeller && $oAccount->loadBy(array('account_id'=>'='.$iSeller))) {
        } else {
            $aErrors[] = Conf::format('Seller is not found');
        }
        if (strtotime(Database::date($iTime))===false)
            $aErrors[] = Conf::format('Time booking stated incorrectly');

        if (!$aErrors) {
            if (!$oBooking->loadBy(array('seller_id'=>'='.$iSeller, 'fromdate'=>'="'.Database::date($iTime).'"', 'seller_id'=>'='.$oAccount->isLoggedIn())))
                $aErrors[] =  Conf::format('Time is not found');
            else
                $aBooking = $oBooking->aData;
        }


        if (!$aErrors) {
            $oZoomMeeting = $oZoom->deleteMeeting(array(
                'id'=>$aBooking['zoom_id'],
                'host_id'=>$aSeller['zoom_id'],
            ));
            if ($oZoomMeeting) {
                if (!$oBooking->delete($aBooking['booking_id']))
                    $aErrors = $oBooking->getErrors();
            } else {
                $aErrors = $oZoom->getErrors();
            }
        }

        echo json_encode(array('errors'=>$aErrors));
        exit;
        break;

    case 'canceled':
    case 'missed':
    case 'restore':
        $iSlotId = $oReq->getInt('id');
        if (!$oShopSlot->loadBy(array('shop_slot_id'=>'="'.$iSlotId.'"', 'seller_id'=>'='.$oAccount->isLoggedIn(), 'status'=>'IN('.($oReq->getAction()=='restore'?'"canceled","missed"':'"booked"').')')))
            $aErrors[] =  Conf::format('Slot is not found');
        else
            $aSlot = $oShopSlot->aData;

        if (!$aErrors) {
            $oShopSlot->aData = array(
                'shop_slot_id' => $iSlotId,
                'status' => $oReq->getAction()=='restore'?'booked':$oReq->getAction(),
                'udate' => Database::date(),
            );
            if (!$oShopSlot->update())
                $aErrors = $oShopSlot->getErrors();
        }
        echo json_encode(array('errors'=>$aErrors));
        exit;
        break;
}


// Время со смещением временной зоны на сегодня
$nTime = time();
$nUtcTime = $nTime + date("Z", $nTime);
$nTimeOffset = $nUtcTime - Conf::getTimezoneOffset(time(), $sTimezoneOffset);


list($aSlots, $iSlotsCnt) = $oShopSlot->getList(array('seller_id'=>'='.$aAccount['account_id'], 'status'=>'="booked"'), 0, 0, 'ss.time_from');
$aShops = array();
$aSlotsNormal = array();
foreach ($aSlots as $nKey=>$aSlot) {
    if (!isset($aShops[$aSlot['shop_id']])) {
        $oShop->load($aSlot['shop_id'], LANGUAGEID);
        $aShops[$aSlot['shop_id']] = $oShop->aData;
    }

    $aSlots[$nKey]['time_from'] = strtotime($aSlot['time_from']) - Conf::getTimezoneOffset(strtotime($aSlot['time_from']), $sTimezoneOffset, $aShops[$aSlot['shop_id']]['time_shift']);
    $aSlots[$nKey]['time_to'] = strtotime($aSlot['time_to']) - Conf::getTimezoneOffset(strtotime($aSlot['time_to']), $sTimezoneOffset, $aShops[$aSlot['shop_id']]['time_shift']);
    $aSlots[$nKey]['shop'] =  $aShops[$aSlot['shop_id']]['title'];

    $aSlots[$nKey]['cancel_time'] =  $aSlots[$nKey]['time_from']-$nTimeOffset-86400; // отменять можно за сутки
    if ($aSlots[$nKey]['cancel_time']>0) {
        $nDays = floor($aSlots[$nKey]['cancel_time']/86400);
        $nHours = floor(($aSlots[$nKey]['cancel_time']-86400*$nDays)/3600);
        $nMinutes = floor(($aSlots[$nKey]['cancel_time']-86400*$nDays-3600*$nHours)/60);
        $aSlots[$nKey]['cancel_time'] =  ($nDays>0?$nDays.Conf::format('d.').' ':'').($nHours>0?$nHours.Conf::format('h.').' ':'').($nMinutes>0?$nMinutes.Conf::format('m.'):'');
    }


    $aSlotsNormal[date('Y-m-d', $aSlots[$nKey]['time_from'])][] = $aSlots[$nKey];
}


$aMonths = array(
    '01' => Conf::format('January'),
    '02' => Conf::format('February'),
    '03' => Conf::format('March'),
    '04' => Conf::format('April'),
    '05' => Conf::format('May'),
    '06' => Conf::format('June'),
    '07' => Conf::format('July'),
    '08' => Conf::format('August'),
    '09' => Conf::format('September'),
    '10' => Conf::format('October'),
    '11' => Conf::format('November'),
    '12' => Conf::format('December')
);

//d($aSlotsNormal);

// Title
$sTitle = Conf::format('Meetings');
$oTpl->assign(array(
    'aSlotsNormal' => $aSlotsNormal,
    'iSlotsCnt' => $iSlotsCnt,
    'aMonths' => $aMonths,
));

?>
