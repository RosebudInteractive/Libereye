<?php
set_time_limit(0);
date_default_timezone_set('UTC');
$bNoSession = true;

// Необходимые классы
require_once dirname(__FILE__).'/../include/visitor.inc.php';
Conf::loadClass('Shop');
Conf::loadClass('OpenTime');
Conf::loadClass('ShopSlot');
Conf::loadClass('Booking');


$oShop   = new Shop();
$oOpenTime   = new OpenTime();
$oShopSlot   = new ShopSlot();
$oBooking   = new Booking();
$oDb = Database::get();
define('LANGUAGEID', 1);
$nShopId = 1;
$nTimeFrom = $oReq->get('from')?strtotime($oReq->get('from')):time();

// данные магазина
$oShop->load($nShopId);
$aShop = $oShop->aData;
$sShiftUTC = 0;
if (preg_match('@\(GMT(.*?)\)@i', $aShop['timezone_title'], $aMatches)) {
    list($sHours, $sMinutes) = explode(':', $aMatches[1]);
    $sShiftUTC = $sHours*60 + $sMinutes;
}


// время работы
$aOpenTimes = array();
list($aOpenTimesTmp, ) = $oOpenTime->getList(array('shop_id'=>'='.$nShopId, 'type'=>'="open"'), 0, 0, 'week_day');
$aOpenTimes = array();
foreach ($aOpenTimesTmp as $nKey=>$aTime) {
    $aOpenTimes[$aTime['week_day']] = $aTime;
}

// продавцы
$aSellers = array(20,27);

for($day=0; $day<30; $day++) { // на 30 дней
    //$nDateTime = strtotime(date('Y-m-d 00:00:00', mktime(0,0,0,3,20,2016)))+$day*86400;
    $nDateTime = strtotime(date('Y-m-d 00:00:00', time()))+$day*86400;
    $nWeekDay = date('w', $nDateTime)==0 ? 6 : date('w', $nDateTime)-1;
    $aTime = isset($aOpenTimes[$nWeekDay]) ? $aOpenTimes[$nWeekDay]: array('time_to'=>0, 'time_from'=>0);
    for($time=$aTime['time_from']; $time<$aTime['time_to']-60; $time+=60) {

        $sTimeFrom = strtotime(date('Y-m-d H:i:00', $nDateTime+$time*60));
        $sTimeTo = strtotime(date('Y-m-d H:i:00', $nDateTime+$time*60+3600));
        if (!$oShopSlot->loadBy(array(
            'shop_id' => '='.$nShopId,
            'time_from' => '="'.Database::date($sTimeFrom).'"',
            'time_to' => '="'.Database::date($sTimeTo).'"'))) {
            $oShopSlot->aData = array(
                'shop_id' => $nShopId,
                'time_from' => Database::date($sTimeFrom),
                'time_to' => Database::date($sTimeTo)
            );
            $nShopSlotId = $oShopSlot->insert();
            $oBooking->aData = array(
                'shop_slot_id' => $nShopSlotId,
                'seller_id' => $aSellers[rand(0, count($aSellers)-1)],
                'status' => 'free',
                'cdate' => Database::date(),
                'udate' => Database::date(),
            );
            $oBooking->insert();
        }
    }
}

echo 'DONE';