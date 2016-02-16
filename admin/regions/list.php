<?php
/** ============================================================
 * Part section.
 *   Area:    Region
 *   Part:    stats
 *   Section: sales
 * @author Rudenko S.
 * @package Region
 * ============================================================ */
Conf::loadClass('utils/Validator');
Conf::loadClass('utils/Sorter');
Conf::loadClass('utils/Pager');
Conf::loadClass('Region');

$oRegion = new Region();


// ========== processing actions ==========
switch($oReq->getAction())
{
   case 'load':
		$iRegionId = $oReq->getInt('id');
        if ($iRegionId && $oRegion->load($iRegionId)) {
            echo json_encode($oRegion->aData);
            exit;
        }
		echo '{"error":"Бренд не найден"}';
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
            if (isset($_GET['filter']['country']) && $_GET['filter']['country'])
                $aCond['{#country}'] = 'pd2.phrase LIKE "%'.Database::escapeLike($_GET['filter']['country']).'%"';
		}

		$iPos = $oReq->getInt('start');
		$iPageSize = $oReq->getInt('count', 50);
		$aSort = $oReq->getArray('sort' , array('region_id'=>'desc'));
		list($aItems, $iCnt) = $oRegion->getListOffset($aCond, $iPos, $iPageSize, str_replace('=', ' ', http_build_query($aSort, ' ', ', ')));

        if (!$oReq->get('suggest'))
            echo '{"pos":'.$iPos.', "total_count":"'.$iCnt.'","data":'.json_encode($aItems).'}';
        else {
            $aRegionsSuggest = array();
            foreach($aItems as $aItem){
                $aRegionsSuggest[] = array("id"=>$aItem['region_id'],"value"=>$aItem['title']);
            }
            echo json_encode($aRegionsSuggest);
        }

		exit;
		break;

    case 'update':
    case 'create':
        $iRegionId = $oReq->getInt('id');
        $aRegion = $oReq->getArray('aRegion');
        $oRegion->aData = $aRegion;
        if ($iRegionId) {
            $oRegion->aData['region_id'] = $iRegionId;
            if (!$oRegion->update(array(), true, array('title', 'description'))){
                $aErrors = $oRegion->getErrors();
            }
        } else {
            if (!($iRegionId = $oRegion->insert(true, array('title', 'description')))){
                $aErrors = $oRegion->getErrors();
            }
        }
        echo '{ "id":"'.$iRegionId.'", "error":'.json_encode($aErrors).'}';
        exit;
        break;
   case 'destroy':
        $iRegionId = $oReq->getInt('id');
   		if (!$oRegion->delete($iRegionId)){
            $aErrors = $oRegion->getErrors();
   		}
        echo '{ "id":"'.$iRegionId.'", "error":'.json_encode($aErrors).'}';exit;
   		break;
}


?>