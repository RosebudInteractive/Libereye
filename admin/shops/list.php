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

$oShop = new Shop();


// ========== processing actions ==========
switch($oReq->getAction())
{
   case 'get':
		// delete
		if (isset($_GET['subact']) && $_GET['subact']=='del')
		{
			if ($oReq->get('ids'))
				$oShop->deleteByCond(array('shop_id'=>'IN('.$oReq->get('ids').')'));
		}
		// search
		$aCond = array();
		if (isset($_GET['subact']) && $_GET['subact']=='search' && trim($_GET['query']))
		{
			$aCond['{#field}'] = $oReq->get('field').' LIKE "%'.Database::escapeLike($oReq->get('query')).'%"';
		}
		
		$iPage = $oReq->getInt('start', 1);
		$iPageSize = $oReq->getInt('count', 100);
		$aSort = $oReq->getArray('sort');
		$aSort = array(
			'property'=>'shop_id',
			'direction'=>'DESC',
		);
		list($aItems, $iCnt) = $oShop->getList($aCond, $iPage, $iPageSize, $aSort['property'].' '.$aSort['direction']);
		echo '{"pos":0, "total_count":"'.$iCnt.'","data":'.json_encode($aItems).'}';
		exit;
		break;
   case 'del':
   		if ($oShop->delete($oReq->getInt('id'))){
   			$oReq->forward(conf::getUrl('admin.accounts.list'), 'Пользователь был успешно удален');
   		}
   		break;
}


?>