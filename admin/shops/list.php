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
Conf::loadClass('Account');

$oImage 		= new Image();
$oShop = new Shop();
$oShopSlot = new ShopSlot();
$oOpenTime = new OpenTime();
$oAccount = new Account();
$iShopId = $oReq->getInt('id');
if ($iShopId && $oShop->load($iShopId)) {
    $aShop = $oShop->aData;
}

// ========== processing actions ==========
switch($oReq->getAction())
{
    case 'load':
        $iShopId = $oReq->getInt('id');
        if ($iShopId && $oShop->load($iShopId)) {
            list($aOpenTimes, ) = $oOpenTime->getList(array('shop_id'=>'='.$iShopId), 0, 0, 'week_day');
            $aItem = $oShop->aData;
            foreach($aOpenTimes as $aOpenTime) {
                $aOpenTime['time_from'] +=$aShop['time_shift'];
                $aOpenTime['time_to'] +=$aShop['time_shift'];
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

    case 'getsellers':
        $iShopId = $oReq->getInt('id');
        if ($iShopId && $oShop->load($iShopId)) {
            $aShop = $oShop->aData;
            $aCond = array('shop_id'=>'='.$iShopId, 'status'=>'="seller"');
            if (isset($_GET['filter']))
            {
                if (isset($_GET['filter']['fname']) && $_GET['filter']['fname'])
                    $aCond['fname'] = 'LIKE "%'.Database::escapeLike($_GET['filter']['fname']).'%"';
            }

            $iPos = $oReq->getInt('start');
            $iPageSize = $oReq->getInt('count', 10000);
            $aSort = $oReq->getArray('sort' , array('fname'=>'asc'));
            list($aItems, $iCnt) = $oAccount->getListOffset($aCond, $iPos, $iPageSize, str_replace('=', ' ', http_build_query($aSort, ' ', ', ')));

            if (!$oReq->get('suggest')) {
                foreach($aItems as $nKey=>$aItem){
                    unset($aItems[$nKey]['pass']);
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
            $aCond = array('shop_id'=>'='.$iShopId, 'time_from'=>'>="'.Database::date(strtotime(date('Y-m-d 00:00:00',time() - date("Z")))).'"');
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

    case 'genslots':
        $iShopId = $oReq->getInt('id');
        $nStartDate = strtotime(date('Y-m-d 00:00:00', strtotime($oReq->get('time_from'))));
        $nToDate = strtotime(date('Y-m-d 00:00:00', strtotime($oReq->get('time_to'))));
        $nSellerId = $oReq->getInt('seller_id');
        $bPublish = $oReq->getInt('publish');

        if (!$nStartDate) $aErrors[] = 'Дата начала генерации слотов не указана';
        if (!$nToDate) $aErrors[] = 'Дата конца генерации слотов не указана';
        if (!$nSellerId) $aErrors[] = 'Шоппер не указан';
        if ($nToDate && $nStartDate && $nStartDate>$nToDate) $aErrors[] = 'Дата начала больше даты конца';
        if ($nToDate && $nStartDate && $nToDate-$nStartDate>2678400) $aErrors[] = 'Разрешается генерировать слоты не более чем на 31 день';

        if (!$aErrors){
            if ($iShopId && $oShop->load($iShopId)) {
                $aShop = $oShop->aData;

                // время работы
                $aOpenTimes = array();
                list($aOpenTimesTmp, ) = $oOpenTime->getList(array('shop_id'=>'='.$iShopId, 'type'=>'="open"'), 0, 0, 'week_day');
                $aOpenTimes = array();
                foreach ($aOpenTimesTmp as $nKey=>$aTime) {
                    $aOpenTimes[$aTime['week_day']] = $aTime;
                }

                for($day=$nStartDate; $day<=$nToDate; $day+=86400) {
                    $nDateTime = strtotime(date('Y-m-d 00:00:00', $day));
                    $nWeekDay = date('w', $nDateTime)==0 ? 6 : date('w', $nDateTime)-1;
                    $aTime = isset($aOpenTimes[$nWeekDay]) ? $aOpenTimes[$nWeekDay]: array('time_to'=>0, 'time_from'=>0);
                    for($time=$aTime['time_from']; $time<=$aTime['time_to']-60; $time+=60) {
                        $sTimeFrom = strtotime(date('Y-m-d H:i:00', $nDateTime+$time*60));
                        $sTimeTo = strtotime(date('Y-m-d H:i:00', $nDateTime+$time*60+3600));
                        if (!$oShopSlot->loadBy(array(
                            'shop_id' => '='.$iShopId,
                            'seller_id' => '='.$nSellerId,
                            'time_from' => '>="'.Database::date($sTimeFrom).'"',
                            'time_to' => '<="'.Database::date($sTimeTo).'"'))) {
                            $oShopSlot->aData = array(
                                'shop_id' => $iShopId,
                                'time_from' => Database::date($sTimeFrom),
                                'time_to' => Database::date($sTimeTo),
                                'seller_id' => $nSellerId,
                                'status' => $bPublish?'free':'draft',
                                'cdate' => Database::date(),
                                'udate' => Database::date(),
                            );
                            $nShopSlotId = $oShopSlot->insert();
                        }
                    }
                }
            }
        }
        echo json_encode(array('error'=>join('<br>', $aErrors), 'message'=>'Ok'));
        exit;
        break;

    case 'update':
    case 'create':
        $iShopId = $oReq->getInt('id');
        $aShopPost = $oReq->getArray('aShop');
        $aImages = $oReq->get('images') ? explode(',', $oReq->get('images')) : array();
        $oShop->aData = $aShopPost;
        if ($aImages && intval($aImages[0]))
            $oShop->aData['promo_head'] = intval($aImages[0]);
        if ($aShopPost) {
            if ($iShopId) {
                $oShop->aData['shop_id'] = $iShopId;
                if (!$oShop->update(array(), true, array('title', 'description', 'brand_desc'))) {
                    $aErrors = $oShop->getErrors();
                }
            } else {
                if (!($iShopId = $oShop->insert(true, array('title', 'description', 'brand_desc')))) {
                    $aErrors = $oShop->getErrors();
                }
            }
        }

        if (!$aErrors) {
            $aOpenTime = $oReq->getArray('open_time');
            foreach($aOpenTime as $nWeekDay=>$sOpenTime) {
                $nWeekDay = intval($nWeekDay);
                if ($sOpenTime) {
                    list($aFrom, $aTo) = explode('-', $sOpenTime, 2);
                    list($iFromHour, $iFromMinute) = explode(':', $aFrom, 2);
                    $iFrom = 60*intval($iFromHour) + intval($iFromMinute) - $aShop['time_shift'];
                    list($iToHour, $iToMinute) = explode(':', $aTo, 2);
                    $iTo = 60*intval($iToHour) + intval($iToMinute) - $aShop['time_shift'];
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

    case 'updateseller':
    case 'createseller':
        $iShopId = $oReq->getInt('id');
        $aAccountPost = $oReq->getArray('aShop');
        $aImages = $oReq->get('images') ? explode(',', $oReq->get('images')) : array();
        $oShop->aData = $aShopPost;
        if ($aImages && intval($aImages[0]))
            $oShop->aData['promo_head'] = intval($aImages[0]);
        if ($aShopPost) {
            if ($iShopId) {
                $oShop->aData['shop_id'] = $iShopId;
                if (!$oShop->update(array(), true, array('title', 'description', 'brand_desc'))) {
                    $aErrors = $oShop->getErrors();
                }
            } else {
                if (!($iShopId = $oShop->insert(true, array('title', 'description', 'brand_desc')))) {
                    $aErrors = $oShop->getErrors();
                }
            }
        }

        if (!$aErrors) {
            $aOpenTime = $oReq->getArray('open_time');
            foreach($aOpenTime as $nWeekDay=>$sOpenTime) {
                $nWeekDay = intval($nWeekDay);
                if ($sOpenTime) {
                    list($aFrom, $aTo) = explode('-', $sOpenTime, 2);
                    list($iFromHour, $iFromMinute) = explode(':', $aFrom, 2);
                    $iFrom = 60*intval($iFromHour) + intval($iFromMinute) - $aShop['time_shift'];
                    list($iToHour, $iToMinute) = explode(':', $aTo, 2);
                    $iTo = 60*intval($iToHour) + intval($iToMinute) - $aShop['time_shift'];
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

    case 'updateslot':
    case 'createslot':
        $iShopId = $oReq->getInt('id');
        $iShopSlotId = $oReq->getInt('shop_slot_id');
        if ($iShopId && $oShop->load($iShopId)) {
            $aShop = $oShop->aData;
            $nStartDate = strtotime(date('Y-m-d H:i:00', strtotime($oReq->get('time_from'))));
            $nToDate = strtotime(date('Y-m-d H:i:00', strtotime($oReq->get('time_to'))));
            $nSellerId = $oReq->getInt('seller_id');
            $sStatus = in_array($oReq->get('status'), array('free', 'booked', 'draft'))?$oReq->get('status'):'';

            if (!$nStartDate) $aErrors[] = 'Дата начала не указана';
            if (!$nToDate) $aErrors[] = 'Дата конца не указана';
            if (!$nSellerId) $aErrors[] = 'Шоппер не указан';
            if (!$sStatus) $aErrors[] = 'Статус не указан';
            if ($nToDate && $nStartDate && $nStartDate>$nToDate) $aErrors[] = 'Дата начала больше даты конца';
            if ($nToDate && $nStartDate && $nStartDate==$nToDate) $aErrors[] = 'Дата начала совпадает с датой конца';

            if (!$aErrors) {
                if ($iShopSlotId) {
                    if ($oShopSlot->loadBy(array('shop_id'=>'='.$iShopId, 'shop_slot_id'=>'='.$iShopSlotId))) {
                        $aShopSlot = $oShopSlot->aData;
                        if ($aShopSlot['status'] == 'booked') $aErrors[] = 'Слот со статусом booked не может быть изменен';
                        else if ($sStatus == 'booked') $aErrors[] = 'Статус не может быть booked';
                        if ($oShopSlot->loadBy(array(
                            'shop_slot_id' => '!='.$iShopSlotId,
                            'shop_id' => '='.$iShopId,
                            'seller_id' => '='.$nSellerId,
                            'time_from' => '>="'.Database::date($nStartDate - $aShop['time_shift']*60).'"',
                            'time_to' => '<="'.Database::date($nToDate - $aShop['time_shift']*60).'"'))) $aErrors[] = 'Такой слот уже есть данного шоппера';
                        if (!$aErrors) {
                            $oShopSlot->aData = array(
                              'shop_slot_id' => $aShopSlot['shop_slot_id'],
                              'time_from' => Database::date($nStartDate - $aShop['time_shift']*60),
                              'time_to' => Database::date($nToDate - $aShop['time_shift']*60),
                              'seller_id' => $nSellerId,
                              'status' => $sStatus,
                              'udate' => Database::date()
                            );
                            if (!$oShopSlot->update())
                                $aErrors = $oShopSlot->getErrors();
                        }
                    } else
                        $aErrors[] = 'Слот не найден';
                } else {
                    if ($sStatus == 'booked') $aErrors[] = 'Статус не может быть booked';
                    if (!$aErrors) {
                        $oShopSlot->aData = array(
                            'time_from' => Database::date($nStartDate - $aShop['time_shift']*60),
                            'time_to' => Database::date($nToDate - $aShop['time_shift']*60),
                            'seller_id' => $nSellerId,
                            'status' => $sStatus,
                            'shop_id' => $iShopId,
                            'cdate' => Database::date(),
                            'udate' => Database::date(),
                        );
                        if (!($iShopSlotId=$oShopSlot->insert()))
                            $aErrors = $oShopSlot->getErrors();
                    }
                }
            }

        }
        echo '{ "id":"'.$iShopSlotId.'", "error":'.json_encode($aErrors).'}';
        exit;
        break;

    case 'destroy':
        $iShopId = $oReq->getInt('id');
        if (!$oShop->delete($iShopId)){
            $aErrors = $oShop->getErrors();
        }
        echo '{ "id":"'.$iShopId.'", "error":'.json_encode($aErrors).'}';
        break;

   case 'destroyslot':
       $iShopSlotId = $oReq->getInt('id');
       if ($oShopSlot->loadBy(array('shop_slot_id'=>'='.$iShopSlotId))) {
           if ($oShopSlot->aData['status'] == 'booked') $aErrors[] = 'Слот со статусом booked не может быть удален';
           if (!$aErrors) {
              if (!$oShopSlot->delete($iShopSlotId))
                $aErrors = $oShop->getErrors();
           }
       }else
           $aErrors[] = 'Слот не найден';
        echo '{ "id":"'.$iShopId.'", "error":'.json_encode($aErrors).'}';
        exit;
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