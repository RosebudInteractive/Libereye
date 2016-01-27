<?php
/** ============================================================
 * Part section.
 *   Area:    Shop
 *   Part:    stats
 *   Section: sales
 * @author Rudenko S.
 * @package Shop
 * ============================================================ */
Conf::loadClass('utils/Validator');
Conf::loadClass('utils/Sorter');
Conf::loadClass('utils/Pager');
Conf::loadClass('Shop');
Conf::loadClass('ShopSlot');
Conf::loadClass('Image');
Conf::loadClass('OpenTime');

$oImage 		= new Image();
$oShop = new Shop();
$oShopSlot = new ShopSlot();
$oOpenTime = new OpenTime();


// ========== processing actions ==========
switch($oReq->getAction())
{
    case 'load':
        $iShopId = $oReq->getInt('id');
        if ($iShopId && $oShop->load($iShopId)) {
            list($aOpenTimes, ) = $oOpenTime->getList(array('shop_id'=>'='.$iShopId), 0, 0, 'week_day');
            $aItem = $oShop->aData;
            foreach($aOpenTimes as $aOpenTime) {
                $aItem['open_time'][$aOpenTime['week_day']] = sprintf('%02d:%02d-%02d:%02d', intval($aOpenTime['time_from']/60), $aOpenTime['time_from']-intval($aOpenTime['time_from']/60)*60, intval($aOpenTime['time_to']/60), $aOpenTime['time_to']-intval($aOpenTime['time_to']/60)*60);
            }
            echo json_encode($aItem);
            exit;
        }
        echo '{"error":"Магазин не найден"}';
        exit;
        break;

    case 'get':
        // search
        $aCond = array();
        if (isset($_GET['filter']))
        {
            if (isset($_GET['filter']['value']) && $_GET['filter']['value'])
                $aCond['{#title}'] = 'pd1.phrase LIKE "%'.Database::escapeLike($_GET['filter']['value']).'%"';
            if (isset($_GET['filter']['title']) && $_GET['filter']['title'])
                $aCond['{#title}'] = 'pd1.phrase LIKE "%'.Database::escapeLike($_GET['filter']['title']).'%"';
            if (isset($_GET['filter']['description']) && $_GET['filter']['description'])
                $aCond['{#description}'] = 'pd2.phrase LIKE "%'.Database::escapeLike($_GET['filter']['description']).'%"';
        }

        $iPos = $oReq->getInt('start');
        $iPageSize = $oReq->getInt('count', 50);
        $aSort = $oReq->getArray('sort' , array('shop_id'=>'desc'));
        list($aItems, $iCnt) = $oShop->getListOffset($aCond, $iPos, $iPageSize, str_replace('=', ' ', http_build_query($aSort, ' ', ', ')));

        if (!$oReq->get('suggest'))
            echo '{"pos":'.$iPos.', "total_count":"'.$iCnt.'","data":'.json_encode($aItems).'}';
        else {
            $aShopsSuggest = array();
            foreach($aItems as $aItem){
                $aShopsSuggest[] = array("id"=>$aItem['shop_id'],"value"=>$aItem['title']);
            }
            echo json_encode($aShopsSuggest);
        }
        exit;
        break;

    case 'loadslot':
        $iShopSlotId = $oReq->getInt('id');
        if ($iShopSlotId && $oShopSlot->load($iShopSlotId)) {
            $aItem = $oShopSlot->aData;
            $aItem['time_from'] = Database::date(strtotime($aItem['time_from'])+$aItem['time_shift']*60);
            $aItem['time_to'] = Database::date(strtotime($aItem['time_to'])+$aItem['time_shift']*60);
            echo json_encode($aItem);
            exit;
        }
        echo '{"error":"Слот не найден"}';
        exit;
        break;

    case 'getslots':
        // search
        $iShopId = $oReq->getInt('id');
        if ($iShopId && $oShop->load($iShopId)) {
            $aShop = $oShop->aData;
            $aCond = array('shop_id'=>'='.$iShopId, 'time_from'=>'>="'.Database::date(time() + date("Z")).'"');
            if (isset($_GET['filter']))
            {
                if (isset($_GET['filter']['value']) && $_GET['filter']['value'])
                    $aCond['{#title}'] = 'pd1.phrase LIKE "%'.Database::escapeLike($_GET['filter']['value']).'%"';
                if (isset($_GET['filter']['title']) && $_GET['filter']['title'])
                    $aCond['{#title}'] = 'pd1.phrase LIKE "%'.Database::escapeLike($_GET['filter']['title']).'%"';
                if (isset($_GET['filter']['description']) && $_GET['filter']['description'])
                    $aCond['{#description}'] = 'pd2.phrase LIKE "%'.Database::escapeLike($_GET['filter']['description']).'%"';
            }

            $iPos = $oReq->getInt('start');
            $iPageSize = $oReq->getInt('count', 10000);
            $aSort = $oReq->getArray('sort' , array('time_from'=>'asc'));
            list($aItems, $iCnt) = $oShopSlot->getListOffset($aCond, $iPos, $iPageSize, str_replace('=', ' ', http_build_query($aSort, ' ', ', ')));

            if (!$oReq->get('suggest')) {
                foreach ($aItems as $nKey => $aItem) {
                    $aItems[$nKey]['time_from'] = Database::date(strtotime($aItem['time_from'])+$aShop['time_shift']*60);
                    $aItems[$nKey]['time_to'] = Database::date(strtotime($aItem['time_to'])+$aShop['time_shift']*60);
                }
                echo '{"pos":' . $iPos . ', "total_count":"' . $iCnt . '","data":' . json_encode($aItems) . '}';
            } else {
                $aShopsSuggest = array();
                foreach($aItems as $aItem){
                    $aShopsSuggest[] = array("id"=>$aItem['shop_slot_id'],"value"=>$aItem['title']);
                }
                echo json_encode($aShopsSuggest);
            }
            exit;
        }
        exit;
        break;

    case 'update':
    case 'create':
        $iShopId = $oReq->getInt('id');
        $aShop = $oReq->getArray('aShop');
        $aImages = $oReq->get('images') ? explode(',', $oReq->get('images')) : array();
        $oShop->aData = $aShop;
        if ($aImages && intval($aImages[0]))
            $oShop->aData['promo_head'] = intval($aImages[0]);
        if ($iShopId) {
            $oShop->aData['shop_id'] = $iShopId;
            if (!$oShop->update(array(), true, array('title', 'description', 'brand_desc'))){
                $aErrors = $oShop->getErrors();
            }
        } else {
            if (!($iShopId = $oShop->insert(true, array('title', 'description', 'brand_desc')))){
                $aErrors = $oShop->getErrors();
            }
        }

        if (!$aErrors) {
            $aOpenTime = $oReq->getArray('open_time');
            foreach($aOpenTime as $nWeekDay=>$sOpenTime) {
                $nWeekDay = intval($nWeekDay);
                if ($sOpenTime) {
                    list($aFrom, $aTo) = explode('-', $sOpenTime, 2);
                    list($iFromHour, $iFromMinute) = explode(':', $aFrom, 2);
                    $iFrom = 60*intval($iFromHour) + intval($iFromMinute);
                    list($iToHour, $iToMinute) = explode(':', $aTo, 2);
                    $iTo = 60*intval($iToHour) + intval($iToMinute);
                    if ($iTo>=0 && $iTo<=1440 && $iFrom>=0 && $iFrom<=1440 && $iFrom<$iTo && $nWeekDay>=0 && $nWeekDay<=6) {
                        if ($oOpenTime->loadBy(array('shop_id'=>'='.$iShopId, 'week_day'=>'='.intval($nWeekDay)))) {
                            $oOpenTime->aData = array('open_time_id'=>$oOpenTime->aData['open_time_id']);
                            $oOpenTime->aData['time_from'] = $iFrom;
                            $oOpenTime->aData['time_to'] = $iTo;
                            if (!$oOpenTime->update())
                                $aErrors += $oOpenTime->getErrors();
                        } else {
                            $oOpenTime->aData = array(
                                'shop_id' => $iShopId,
                                'week_day' => $nWeekDay,
                                'time_from' => $iFrom,
                                'time_to' => $iTo,
                            );
                            if (!$oOpenTime->insert())
                                $aErrors += $oOpenTime->getErrors();
                        }
                    } else {
                        $aErrors[] = 'Ошибка в расписании #'.$nWeekDay;
                    }
                } else {
                    if ($oOpenTime->loadBy(array('shop_id'=>'='.$iShopId, 'week_day'=>'='.intval($nWeekDay)))) {
                        if (!$oOpenTime->delete($oOpenTime->aData['open_time_id']))
                            $aErrors += $oOpenTime->getErrors();
                    }
                }
            }
        }

        echo '{ "id":"'.$iShopId.'", "error":'.json_encode($aErrors).'}';
        exit;
        break;
    case 'destroy':
        $iShopId = $oReq->getInt('id');
        if (!$oShop->delete($iShopId)){
            $aErrors = $oShop->getErrors();
        }
        echo '{ "id":"'.$iShopId.'", "error":'.json_encode($aErrors).'}';
        break;

    case 'upload':
        $iImageId = 0;
        $sImageName = '';
        if (isset($_FILES['upload']) && isset($_FILES['upload']['tmp_name'])) {
            $sExt = strtolower(substr($_FILES['upload']['name'], strrpos($_FILES['upload']['name'], '.')+1));
            if ($iImageId = $oImage->upload($_FILES['upload']['tmp_name'], 'shop', 0, $sExt) ) {
                $sImageName = $oImage->aData['name'];
            }
            else
                $aErrors = $oImage->getErrors();
        } else {
            $aErrors[] = 'File not upload';
        }
        echo '{ "status":"'.($aErrors?'error':'server').'", "id":"'.$iImageId.'", "sname":"'.$sImageName.'"}';
        exit;
        break;
}


?>