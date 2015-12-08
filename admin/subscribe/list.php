<?php
/** ============================================================
 * Part section.
 *   Area:    Subscribe
 *   Part:    stats
 *   Section: sales
 * @author Rudenko S.
 * @package Subscribe
 * ============================================================ */
Conf::loadClass('utils/Validator');
Conf::loadClass('utils/Sorter');
Conf::loadClass('utils/Pager');
Conf::loadClass('Subscribe');

$oSubscribe = new Subscribe();


// ========== processing actions ==========
switch($oReq->getAction())
{
   case 'get':
		// delete
		if (isset($_GET['subact']) && $_GET['subact']=='del')
		{
			if ($oReq->get('ids'))
				$oSubscribe->deleteByCond(array('subscribe_id'=>'IN('.$oReq->get('ids').')'));
		}
		// search
		$aCond = array();
		if (isset($_GET['subact']) && $_GET['subact']=='search' && trim($_GET['query']))
		{
			$aCond['{#field}'] = $oReq->get('field').' LIKE "%'.Database::escapeLike($oReq->get('query')).'%"';
		}
		
		$iPage = $oReq->getInt('page', 1);
		$iPageSize = intval($_REQUEST['limit']);
		$iPageSize = $iPageSize > 1000 ? 1000 : $iPageSize;
		$aSort = json_decode($_REQUEST['sort']);
		$aSort = array(
			'property'=>isset($aSort[0]) && in_array($aSort[0]->property, array('subscribe_id','title'))?$aSort[0]->property:'subscribe_id', 
			'direction'=>isset($aSort[0]) && in_array($aSort[0]->direction, array('DESC','ASC'))?$aSort[0]->direction:'DESC', 
		);
		list($aItems, $iCnt) = $oSubscribe->getList($aCond, $iPage, $iPageSize, $aSort['property'].' '.$aSort['direction']);
		echo '{"total":"'.$iCnt.'","data":'.json_encode($aItems).'}';
		exit;
		break;
   case 'del':
   		if ($oSubscribe->delete($oReq->getInt('id'))){
   			$oReq->forward(conf::getUrl('admin.subscribes.list'), 'Пользователь был успешно удален');
   		}
   		break;
}


?>