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
        $aBrand = array(
            'brand_id' => $oReq->getInt('brand_id'),
            'title' => $oReq->get('title'),
        );
   		if (!$oBrand->update($oReq->getInt('id'))){
            $aErrors = $oBrand->getErrors();
        }
        exit;
   		break;
    case 'create':
        echo '{ "id":"0", "mytext":"saved" }';
        exit;
        break;
   case 'del':
   		if ($oBrand->delete($oReq->getInt('id'))){
   			$oReq->forward(conf::getUrl('admin.accounts.list'), 'Пользователь был успешно удален');
   		}
   		break;
}


?>