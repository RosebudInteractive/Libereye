<?php
/** ============================================================
 * Part section.
 *   Area:    Timezone
 *   Part:    stats
 *   Section: sales
 * @author Rudenko S.
 * @package Timezone
 * ============================================================ */
Conf::loadClass('utils/Validator');
Conf::loadClass('utils/Sorter');
Conf::loadClass('utils/Pager');
Conf::loadClass('Timezone');

$oTimezone = new Timezone();


// ========== processing actions ==========
switch($oReq->getAction())
{
   case 'load':
		$iTimezoneId = $oReq->getInt('id');
        if ($iTimezoneId && $oTimezone->load($iTimezoneId)) {
            echo json_encode($oTimezone->aData);
            exit;
        }
		echo '{"error":"Зона не найдена"}';
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
            if (isset($_GET['filter']['code']) && $_GET['filter']['code'])
                $aCond['code'] = 'LIKE "%'.Database::escapeLike($_GET['filter']['code']).'%"';
            if (isset($_GET['filter']['time_shift']) && $_GET['filter']['time_shift'])
                $aCond['time_shift'] = '="'.Database::escape($_GET['filter']['time_shift']).'"';
        }

		$iPos = $oReq->getInt('start');
		$iPageSize = $oReq->getInt('count', 50);
		$aSort = $oReq->getArray('sort' , array('timezone_id'=>'desc'));
		list($aItems, $iCnt) = $oTimezone->getListOffset($aCond, $iPos, $iPageSize, str_replace('=', ' ', http_build_query($aSort, ' ', ', ')));

        if (!$oReq->get('suggest'))
            echo '{"pos":'.$iPos.', "total_count":"'.$iCnt.'","data":'.json_encode($aItems).'}';
        else {
            $aTimezonesSuggest = array();
            foreach($aItems as $aItem){
                $aTimezonesSuggest[] = array("id"=>$aItem['timezone_id'],"value"=>$aItem['title']);
            }
            echo json_encode($aTimezonesSuggest);
        }

		exit;
		break;

    case 'update':
    case 'create':
        $iTimezoneId = $oReq->getInt('id');
        $aTimezone = $oReq->getArray('aTimezone');
        $oTimezone->aData = $aTimezone;
        if ($iTimezoneId) {
            $oTimezone->aData['timezone_id'] = $iTimezoneId;
            if (!$oTimezone->update(array(), true, array('title'))){
                $aErrors = $oTimezone->getErrors();
            }
        } else {
            if (!($iTimezoneId = $oTimezone->insert(true, array('title')))){
                $aErrors = $oTimezone->getErrors();
            }
        }
        echo '{ "id":"'.$iTimezoneId.'", "error":'.json_encode($aErrors).'}';
        exit;
        break;
   case 'destroy':
        $iTimezoneId = $oReq->getInt('id');
   		if (!$oTimezone->delete($iTimezoneId)){
            $aErrors = $oTimezone->getErrors();
   		}
        echo '{ "id":"'.$iTimezoneId.'", "error":'.json_encode($aErrors).'}';exit;
   		break;
}


?>