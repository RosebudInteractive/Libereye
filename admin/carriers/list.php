<?php
/** ============================================================
 * Part section.
 *   Area:    Carrier
 *   Part:    stats
 *   Section: sales
 * @author Rudenko S.
 * @package Carrier
 * ============================================================ */
Conf::loadClass('utils/Validator');
Conf::loadClass('utils/Sorter');
Conf::loadClass('utils/Pager');
Conf::loadClass('Carrier');

$oCarrier = new Carrier();


// ========== processing actions ==========
switch($oReq->getAction())
{
   case 'load':
		$iCarrierId = $oReq->getInt('id');
        if ($iCarrierId && $oCarrier->load($iCarrierId)) {
            echo json_encode($oCarrier->aData);
            exit;
        }
		echo '{"error":"Страна не найдена"}';
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
            if (isset($_GET['filter']['tax']) && $_GET['filter']['tax'])
                $aCond['tax'] = '="'.Database::escape($_GET['filter']['tax']).'"';
            if (isset($_GET['filter']['customs']) && $_GET['filter']['customs'])
                $aCond['customs'] = '="'.Database::escape($_GET['filter']['customs']).'"';
            if (isset($_GET['filter']['box_charge']) && $_GET['filter']['box_charge'])
                $aCond['box_charge'] = '="'.Database::escape($_GET['filter']['box_charge']).'"';
            if (isset($_GET['filter']['insurance']) && $_GET['filter']['insurance'])
                $aCond['insurance'] = '="'.Database::escape($_GET['filter']['insurance']).'"';
        }


		$iPos = $oReq->getInt('start');
		$iPageSize = $oReq->getInt('count', 50);
		$aSort = $oReq->getArray('sort' , array('carrier_id'=>'desc'));
		list($aItems, $iCnt) = $oCarrier->getListOffset($aCond, $iPos, $iPageSize, str_replace('=', ' ', http_build_query($aSort, ' ', ', ')));

        if (!$oReq->get('suggest'))
            echo '{"pos":'.$iPos.', "total_count":"'.$iCnt.'","data":'.json_encode($aItems).'}';
        else {
            $aCarriersSuggest = array();
            foreach($aItems as $aItem){
                $aCarriersSuggest[] = array("id"=>$aItem['carrier_id'],"value"=>$aItem['title']);
            }
            echo json_encode($aCarriersSuggest);
        }

		exit;
		break;

    case 'update':
    case 'create':
        $iCarrierId = $oReq->getInt('id');
        $aCarrier = $oReq->getArray('aCarrier');
        $oCarrier->aData = $aCarrier;
        if ($iCarrierId) {
            $oCarrier->aData['carrier_id'] = $iCarrierId;
            if (!$oCarrier->update(array(), true, array('title'))){
                $aErrors = $oCarrier->getErrors();
            }
        } else {
            if (!($iCarrierId = $oCarrier->insert(true, array('title')))){
                $aErrors = $oCarrier->getErrors();
            }
        }
        echo '{ "id":"'.$iCarrierId.'", "error":'.json_encode($aErrors).'}';
        exit;
        break;
   case 'destroy':
        $iCarrierId = $oReq->getInt('id');
   		if (!$oCarrier->delete($iCarrierId)){
            $aErrors = $oCarrier->getErrors();
   		}
        echo '{ "id":"'.$iCarrierId.'", "error":'.json_encode($aErrors).'}';exit;
   		break;
}


?>