<?php
/** ============================================================
 * Part section.
 *   Area:    Brand
 *   Part:    stats
 *   Section: sales
 * @author Rudenko S.
 * @package Brand
 * ============================================================ */
Conf::loadClass('utils/Validator');
Conf::loadClass('utils/Sorter');
Conf::loadClass('utils/Pager');
Conf::loadClass('Brand');

$oBrand = new Brand();


// ========== processing actions ==========
switch($oReq->getAction())
{
   case 'load':
		$iBrandId = $oReq->getInt('id');
        if ($iBrandId && $oBrand->load($iBrandId)) {
            echo json_encode($oBrand->aData);
            exit;
        }
		echo '{"error":"Бренд не найден"}';
		exit;
		break;

    case 'get':
		// delete
		if (isset($_GET['subact']) && $_GET['subact']=='del')
		{
			if ($oReq->get('ids'))
				$oBrand->deleteByCond(array('brand_id'=>'IN('.$oReq->get('ids').')'));
		}
		// search
		$aCond = array();
		if (isset($_GET['subact']) && $_GET['subact']=='search' && trim($_GET['query']))
		{
			$aCond['{#field}'] = $oReq->get('field').' LIKE "%'.Database::escapeLike($oReq->get('query')).'%"';
		}

		$iPos = $oReq->getInt('start');
		$iPageSize = $oReq->getInt('count', 50);
		$aSort = $oReq->getArray('sort' , array('brand_id'=>'desc'));
		list($aItems, $iCnt) = $oBrand->getListOffset($aCond, $iPos, $iPageSize, str_replace('=', ' ', http_build_query($aSort, ' ', ', ')));
		echo '{"pos":'.$iPos.', "total_count":"'.$iCnt.'","data":'.json_encode($aItems).'}';
		exit;
		break;

    case 'update':
    case 'create':
        $iBrandId = $oReq->getInt('id');
        $aBrand = $oReq->getArray('aBrand');
        $oBrand->aData = $aBrand;
        if ($iBrandId) {
            $oBrand->aData['brand_id'] = $iBrandId;
            if (!$oBrand->update(array(), true, array('title', 'description'))){
                $aErrors = $oBrand->getErrors();
            }
        } else {
            if (!($iBrandId = $oBrand->insert(true, array('title', 'description')))){
                $aErrors = $oBrand->getErrors();
            }
        }
        echo '{ "id":"'.$iBrandId.'", "error":'.json_encode($aErrors).'}';
        exit;
        break;
   case 'destroy':
        $iBrandId = $oReq->getInt('id');
   		if (!$oBrand->delete($iBrandId)){
            $aErrors = $oBrand->getErrors();
   		}
        echo '{ "id":"'.$iBrandId.'", "error":'.json_encode($aErrors).'}';
   		break;
}


?>