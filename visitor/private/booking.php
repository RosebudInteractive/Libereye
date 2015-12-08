<?php
/** ============================================================
 * Страница бронирования времени
 *   Area: admin
 *   Sect: register
 * @author Rudenko S.
 * @package visitor
 * ============================================================ */
Conf::loadClass('Account');
Conf::loadClass('Booking');
Conf::loadClass('utils/Zoom');
Conf::loadClass('utils/Validator');
Conf::loadClass('utils/file/Image');
Conf::loadClass('utils/mail/Mailer'); 

$oAccount  	= new Account();
$oZoom  	= new Zoom();
$oBooking  	= new Booking();
$aErrors 	= array();
$iSellerId = $oReq->getInt('seller');
$aSeller = array();

if ($iSellerId) {
    if (!$oAccount->loadBy(array('status'=>'="seller"', 'account_id'=>'='.$iSellerId)))
        $oReq->forward('/'.($aLanguage['alias']).'/account/booking/', Conf::format('Seller is not found'), true);
    else
        $aSeller = $oAccount->aData;
}

// время работы
$aTimes = array();
for($j=9*60; $j<18*60; $j+=30) {
    $aTimes[$j*60] = array('dinner'=> $j>=13*60 && $j<14*60?true:false, 'time'=>floor($j/60).':'.sprintf('%02d', $j-floor($j/60)*60));
}

switch ($oReq->getAction())
{
    case 'add':
    	$iTime = $oReq->get('time');
    	$iSeller = $oReq->getInt('seller');
    	$sDesc = $oReq->get('desc');
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
            $aErrors[] = Conf::format('Time booking is not available');'';


        if (!$aErrors) {
            $oBooking->aData = array(
                'account_id' => $oAccount->isLoggedIn(),
                'seller_id' => $iSeller,
                'status' => 'pending',
                'cdate' => Database::date(),
                'udate' => Database::date(),
                'fromdate' => Database::date($iTime),
                'todate' => Database::date($iTime+30*60),
                'description' => $sDesc,
                'ip' => $_SERVER['REMOTE_ADDR'],
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

        echo json_encode(array('errors'=>$aErrors,
            'item'=>array(
                'zoom_join_url'=>$oBooking->aData['zoom_join_url'],
                'description'=>$oBooking->aData['description']
            )));
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
            if (!$oBooking->loadBy(array('seller_id'=>'='.$iSeller, 'fromdate'=>'="'.Database::date($iTime).'"', 'account_id'=>'='.$oAccount->isLoggedIn())))
                $aErrors[] = Conf::format('Time is not found');
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
}



// неделя
$sDateTime = join('-', array_reverse(explode('/', substr($oReq->get('date'), 0, 10) , 3)));
$sDateTime = strtotime($sDateTime)===false?mktime(0,0,0,date("m"),date("d"),date("Y")):strtotime($sDateTime);
$aWeekTimes = array();
for ($i=0;$i<7;$i++)
{
    // date('N') ISO-8601 numeric representation of the day of the week (added in PHP 5.1.0)
    // 1 (for Monday) through 7 (for Sunday)
    $aWeekTimes[] = mktime(0,0,0,date('m', $sDateTime),date('d', $sDateTime)+$i-date('N', $sDateTime)+1,date('Y', $sDateTime));
}

$aSellers = $oAccount->getHash('fname', array('status'=>'="seller"'));
list($aBookings,) = $oBooking->getList(array('fromdate'=>'>="'.Database::date($aWeekTimes[0]).'"', 'todate'=>'<"'.Database::date($aWeekTimes[6]+24*60*60).'"', 'seller_id'=>'='.$iSellerId));

$aBookingsItems = array();
foreach ($aBookings as $aBooking) {
    $sTime = strtotime($aBooking['fromdate']);
    if (isset($aBookingsItems[$sTime])) {
        if ($oAccount->isLoggedIn()==$aBooking['account_id'])
            $aBookingsItems[$sTime] = array('type'=>'own', 'item'=>$aBooking);
    } else {
        if ($oAccount->isLoggedIn()==$aBooking['account_id'])
            $aBookingsItems[$sTime] = array('type'=>'own', 'item'=>$aBooking);
        else
            $aBookingsItems[$sTime] =array('type'=> 'busy');
    }
}


// Title
$sTitle = Conf::format('Booking time');
$oTpl->assign(array(
    'iSellerId'		=> $iSellerId,
    'aErrors'		=> $aErrors,
    'aSellers'		=> $aSellers,
    'aSeller'		=> $aSeller,
    'aTimes'	=> $aTimes,
    'aWeekTimes'	=> $aWeekTimes,
    'aBookingsItems'	=> $aBookingsItems,
    'aWeekDays' => array(Conf::format('Mo'),Conf::format('Tu'),Conf::format('We'),Conf::format('Th'),Conf::format('Fr'),Conf::format('Sa'),Conf::format('Su'),),
    'sNextWeek' => date('d/m/Y', $aWeekTimes[6]+24*60*60),
    'sPrevWeek' => date('d/m/Y', $aWeekTimes[0]-7*24*60*60),
));
$oTpl->assignSrc(array(
    'aSeller'		=> $aSeller,
));

?>
