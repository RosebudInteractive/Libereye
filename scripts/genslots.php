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
    $nDateTime = strtotime(date('Y-m-d 00:00:00', time()))+$day*86400;
    $aTime = isset($aOpenTimes[date('w', $nDateTime)]) ? $aOpenTimes[date('w', $nDateTime)]: array('time_to'=>0, 'time_from'=>0);
    for($time=$aTime['time_from']; $time<$aTime['time_to']; $time+=60) {
        $sTimeFrom = strtotime(date('Y-m-d H:00:00', $nDateTime+$time*60));
        $sTimeTo = strtotime(date('Y-m-d H:00:00', $nDateTime+$time*60+3600));
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