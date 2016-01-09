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

// валидация
if (!$nShopId || !$oShop->load($nShopId, LANGUAGEID))
{
    $oReq->forward('/'.$aLanguage['alias'].'/page/404.html');
}
$aShop = $oShop->aData;

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

// дни недели
foreach($aItems as $aShopper) {
    $aShoppers[$aShopper['account_id']] = $aShopper;
    $aShoppers[$aShopper['account_id']]['total'] = 0;
    $aShoppers[$aShopper['account_id']]['days'] = array();
    $sStartTime = strtotime(date('Y-m-d'));
    for($time=$sStartTime; $time<$sStartTime+7*86400; $time+=86400) {
        $sDayTitle = date('d')==date('d', $time) ? Conf::format('Today') :  date('d', $time).' '.Conf::format($aWeekDays[date('w', $time)]).'.';
        $aShoppers[$aShopper['account_id']]['days'][$time] = array('title'=>$sDayTitle, 'morning'=>array('busy'=>0, 'free'=>0, 'total'=>0, 'times'=>array()),
            'day'=>array('busy'=>0, 'free'=>0, 'total'=>0, 'times'=>array()));
    }
}

foreach ($aSlots as $aSlot) {
    $sDateTime = strtotime(date('Y-m-d',strtotime($aSlot['time_from'])));
    if (isset($aShoppers[$aSlot['seller_id']]['days'][$sDateTime])) {
        $sTime = strtotime($aSlot['time_from']);
        if (date('G', $sTime)*60+date('i', $sTime) < 720) { // утренний слот
            if ($aSlot['status']=='free')
                $aShoppers[$aSlot['seller_id']]['days'][$sDateTime]['morning']['times'][] = date('G:i', $sTime);
            $aShoppers[$aSlot['seller_id']]['days'][$sDateTime]['morning'][$aSlot['status']=='booked'?'busy':'free'] +=1;
            $aShoppers[$aSlot['seller_id']]['days'][$sDateTime]['morning']['total'] +=1;
            if ($aSlot['status']=='free')
                $aShoppers[0]['days'][$sDateTime]['morning']['times'][]  = $aSlot['seller_id'].'|'.date('G:i', $sTime);
            $aShoppers[0]['days'][$sDateTime]['morning'][$aSlot['status']=='booked'?'busy':'free'] +=1;
            $aShoppers[0]['days'][$sDateTime]['morning']['total'] +=1;

        } else {
            if ($aSlot['status']=='free')
                $aShoppers[$aSlot['seller_id']]['days'][$sDateTime]['day']['times'][] = date('G:i', $sTime);
            $aShoppers[$aSlot['seller_id']]['days'][$sDateTime]['day'][$aSlot['status']=='booked'?'busy':'free'] +=1;
            $aShoppers[$aSlot['seller_id']]['days'][$sDateTime]['day']['total'] +=1;
            if ($aSlot['status']=='free')
                $aShoppers[0]['days'][$sDateTime]['day']['times'][]  = $aSlot['seller_id'].'|'.date('G:i', $sTime);
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