<?php

Conf::loadClass('Shop');
Conf::loadClass('OpenTime');
Conf::loadClass('Pgroup');
Conf::loadClass('Ptype');
Conf::loadClass('Ptype2group');
Conf::loadClass('Brand');
Conf::loadClass('ShopSlot');
Conf::loadClass('Booking');

$oShop   = new Shop();
$oOpenTime   = new OpenTime();
$oPgroup   = new Pgroup();
$oPtype   = new Ptype();
$oPtype2group   = new Ptype2group();
$oBrand   = new Brand();
$oShopSlot   = new ShopSlot();
$oBooking   = new Booking();
$nShopId = $oReq->getInt('id');
$nTimezoneOffset = isset($_COOKIE['timezone'])?intval($_COOKIE['timezone'])*60:0;

// валидация
if (!$nShopId || !$oShop->load($nShopId, LANGUAGEID))
{
    $oReq->forward('/'.$aLanguage['alias'].'/page/404.html');
}
$aShop = $oShop->aData;

switch($oReq->getAction()) {
    case 'booking':
        $sDate = $oReq->get('date');
        $sDesc = $oReq->get('description');
        $sEmail = $oReq->get('email');
        $iSellerId = $oReq->getInt('seller');

        if (!$sDate) $aErrors[] = Conf::format('Date is not specified');
        if (!$sEmail) $aErrors[] = Conf::format('Email is not specified');
        if ($sEmail && !filter_var($sEmail, FILTER_VALIDATE_EMAIL)) $aErrors[] = Conf::format('Email is incorrect');
        if (!$sDesc) $aErrors[] = Conf::format('Aim of the meeting is not specified');

        if (!$aErrors) {

            // смещенение в UTC
            $nTimeOffset = strtotime($sDate)+$nTimezoneOffset;

            // если не указан продавец находим любого свободного
            if (!$iSellerId) {
                $iSellerId = intval($oShopSlot->findSeller($nTimeOffset));
                if (!$iSellerId) {
                    $aErrors[] = Conf::format('Slot not found');
                }
            }

            if (!$aErrors) {
                if ($oAccount->loadBy(array('account_id' => '=' . $iSellerId, 'status' => '="seller"'))) {
                    if ($oShopSlot->loadBy(array('shop_id' => '=' . $nShopId, 'time_from' => '="' . Database::date($nTimeOffset) . '"'))) {
                        if ($oBooking->loadBy(array('shop_slot_id' => '=' . $oShopSlot->aData['shop_slot_id'], 'seller_id' => '=' . $iSellerId))) {
                            if ($oBooking->aData['status'] == 'free') {
                                $oBooking->aData = array('booking_id'=>$oBooking->aData['booking_id']);
                                if ($oAccount->isLoggedIn()) $oBooking->aData['account_id'] = $oAccount->isLoggedIn();
                                $oBooking->aData['email'] = $sEmail;
                                $oBooking->aData['description'] = $sDesc;
                                $oBooking->aData['status'] = 'booked';
                                $oBooking->aData['udate'] = Database::date();
                                $oBooking->aData['ip'] = $_SERVER['REMOTE_ADDR'];
                                if (!$oBooking->update())
                                    $aErrors = $oBooking->getErrors();
                            } else {
                                $aErrors[] = Conf::format('Slot is already booked');
                            }
                        } else {
                            $aErrors[] = Conf::format('Slot not found');
                        }
                    } else {
                        $aErrors[] = Conf::format('Slot not found');
                    }
                } else {
                    $aErrors[] = Conf::format('Shopper not found');
                }
            }
        }

        echo json_encode(array('errors'=>$aErrors));
        exit;
        break;
}

// время работы
list($aOpenTimesTmp, ) = $oOpenTime->getList(array('shop_id'=>'='.$nShopId, 'type'=>'="open"'), 0, 0, 'week_day');
$aOpenTimes = array();
foreach ($aOpenTimesTmp as $nKey=>$aTime) {
    $aOpenTimes[$aTime['week_day']]['times'] = sprintf('%02d:%02d — %02d:%02d', intval($aTime['time_from']/60), $aTime['time_from']-intval($aTime['time_from']/60)*60, intval($aTime['time_to']/60), $aTime['time_to']-intval($aTime['time_to']/60)*60);
}

// группы товаров
list($aGroups, $iGroupsCnt) = $oPgroup->getList(array('shop_id'=>'='.$nShopId), 0, 0);

// типы товаров
$aPtypes2Group = array();
list($aPtypes, ) = $oPtype->getListGroup(array('shop_id'=>'='.$nShopId), 0, 0);
foreach ($aPtypes as $nKey=>$aPtype) {
    $aPtypes2Group[$aPtype['pgroup_id']][$aPtype['ptype_id']] = $aPtype['title'];
}

// бренды c картинками
//list($aBrands, $iBrandsCnt) = $oBrand->getList(array('{#s2b.shop_id}'=>'s2b.shop_id='.$nShopId, '{#image_id}'=>'b.image_id IS NOT NULL'), 0, 0);
$iBrandsCnt = $oBrand->getCount(array('{#s2b.shop_id}'=>'s2b.shop_id='.$nShopId), 0, 0);

// разбиваем описание на две части
if (mb_strlen($aShop['description']) > 600) {
    $aShop['description_part1'] = mb_substr($aShop['description'], 0, 500);
    $nPos = mb_strrpos($aShop['description_part1'], ".");
    $aShop['description_part1'] = mb_substr($aShop['description_part1'], 0, $nPos+1);
    $aShop['description_part2'] = mb_substr($aShop['description'], $nPos+1);
} else {
    $aShop['description_part1'] = $aShop['description'];
}

// шопперы
$aShoppers = $aSlots = array();
$aWeekDays = array('Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa');
list($aItems,) = $oAccount->getList(array('shop_id'=>'='.$nShopId, 'status'=>'="seller"'));
if ($aItems) list($aSlots,) = $oBooking->getList(array('{#shop_id}'=>'ss.shop_id='.$nShopId, 'seller_id'=>'IN('.$oAccount->getListIds($aItems, true).')'), 0, 0, 'ss.time_from');

// добавим всех шопперов
array_unshift($aItems, array('account_id'=>0, 'fname'=>Conf::format('All shoppers')));

// Время со смещением временной зоны
$nTimeOffset = time()-$nTimezoneOffset;

// дни недели
foreach($aItems as $aShopper) {
    $aShoppers[$aShopper['account_id']] = $aShopper;
    $aShoppers[$aShopper['account_id']]['total'] = 0;
    $aShoppers[$aShopper['account_id']]['days'] = array();
    $sStartTime = strtotime(date('Y-m-d', $nTimeOffset));
    for($time=$sStartTime; $time<$sStartTime+7*86400; $time+=86400) {
        $sDayTitle = date('d')==date('d', $time) ? Conf::format('Today') :  date('d', $time).' '.Conf::format($aWeekDays[date('w', $time)]).'.';
        $aShoppers[$aShopper['account_id']]['days'][$time] = array('day_title'=>$sDayTitle, 'day_date'=>date('Y-m-d', $time), 'morning'=>array('busy'=>0, 'free'=>0, 'total'=>0, 'times'=>array()),
            'day'=>array('busy'=>0, 'free'=>0, 'total'=>0, 'times'=>array()));
    }
}

foreach ($aSlots as $aSlot) {
    $sDateTime = strtotime(date('Y-m-d',strtotime($aSlot['time_from'])-$nTimezoneOffset));
    if (isset($aShoppers[$aSlot['seller_id']]['days'][$sDateTime])) {
        $sTime = strtotime($aSlot['time_from'])-$nTimezoneOffset;
        $sTimeFormat = date('G:i', $sTime);
        if (date('G', $sTime)*60+date('i', $sTime) < 720) { // утренний слот
            if ($aSlot['status']=='free')
                $aShoppers[$aSlot['seller_id']]['days'][$sDateTime]['morning']['times'][$sTimeFormat] = $sTimeFormat;
            $aShoppers[$aSlot['seller_id']]['days'][$sDateTime]['morning'][$aSlot['status']=='booked'?'busy':'free'] +=1;
            $aShoppers[$aSlot['seller_id']]['days'][$sDateTime]['morning']['total'] +=1;
            if ($aSlot['status']=='free')
                $aShoppers[0]['days'][$sDateTime]['morning']['times'][$sTimeFormat]  = $sTimeFormat;
            $aShoppers[0]['days'][$sDateTime]['morning'][$aSlot['status']=='booked'?'busy':'free'] +=1;
            $aShoppers[0]['days'][$sDateTime]['morning']['total'] +=1;

        } else {
            if ($aSlot['status']=='free')
                $aShoppers[$aSlot['seller_id']]['days'][$sDateTime]['day']['times'][$sTimeFormat] = $sTimeFormat;
            $aShoppers[$aSlot['seller_id']]['days'][$sDateTime]['day'][$aSlot['status']=='booked'?'busy':'free'] +=1;
            $aShoppers[$aSlot['seller_id']]['days'][$sDateTime]['day']['total'] +=1;
            if ($aSlot['status']=='free')
                $aShoppers[0]['days'][$sDateTime]['day']['times'][$sTimeFormat]  = $sTimeFormat;
            $aShoppers[0]['days'][$sDateTime]['day'][$aSlot['status']=='booked'?'busy':'free'] +=1;
            $aShoppers[0]['days'][$sDateTime]['day']['total'] +=1;
        }
        if ($aSlot['status']=='free') {
            $aShoppers[$aSlot['seller_id']]['total'] +=1;
            $aShoppers[0]['total'] +=1;
        }
    }
}

foreach ($aShoppers as $nKey1=>$aShopper) {
    foreach ($aShopper['days'] as $nKey2=>$aDay) {
        $aShoppers[$nKey1]['days'][$nKey2]['day']['times'] = join(';', $aDay['day']['times']);
    }
    foreach ($aShopper['days'] as $nKey2=>$aDay) {
        $aShoppers[$nKey1]['days'][$nKey2]['morning']['times'] = join(';', $aDay['morning']['times']);
    }
}

$oTpl->assignSrc(array(
   'aShop' => $aShop,
   'aGroups' => $aGroups,
   'iGroupsCnt' => $iGroupsCnt,
   'aOpenTimes' => $aOpenTimes,
   //'aBrands' => $aBrands,
   'iBrandsCnt' => $iBrandsCnt,
   'sDepartmentsDataJson' => json_encode($aPtypes2Group),
   'aShoppers' => $aShoppers,
));

?>