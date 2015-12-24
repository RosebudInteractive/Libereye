<?php

Conf::loadClass('Shop');
Conf::loadClass('OpenTime');
Conf::loadClass('Pgroup');
Conf::loadClass('Ptype');
Conf::loadClass('Ptype2group');
Conf::loadClass('Brand');

$oShop   = new Shop();
$oOpenTime   = new OpenTime();
$oPgroup   = new Pgroup();
$oPtype   = new Ptype();
$oPtype2group   = new Ptype2group();
$oBrand   = new Brand();
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



$oTpl->assignSrc(array(
   'aShop' => $aShop,
   'aGroups' => $aGroups,
   'iGroupsCnt' => $iGroupsCnt,
   'aOpenTimes' => $aOpenTimes,
   //'aBrands' => $aBrands,
   'iBrandsCnt' => $iBrandsCnt,
   'sDepartmentsDataJson' => json_encode($aPtypes2Group)
));

?>