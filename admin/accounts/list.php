<?php
/** ============================================================
 * Part section.
 *   Area:    Account
 *   Part:    stats
 *   Section: sales
 * @author Rudenko S.
 * @package Account
 * ============================================================ */
Conf::loadClass('utils/Validator');
Conf::loadClass('utils/Sorter');
Conf::loadClass('utils/Pager');
Conf::loadClass('Account');

$oAccount = new Account();


// ========== processing actions ==========
switch($oReq->getAction())
{
   case 'get':
		// delete
		if (isset($_GET['subact']) && $_GET['subact']=='del')
		{
			if ($oReq->get('ids'))
				$oAccount->deleteByCond(array('account_id'=>'IN('.$oReq->get('ids').')'));
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
			'property'=>isset($aSort[0]) && in_array($aSort[0]->property, array('account_id','title'))?$aSort[0]->property:'account_id', 
			'direction'=>isset($aSort[0]) && in_array($aSort[0]->direction, array('DESC','ASC'))?$aSort[0]->direction:'DESC', 
		);
		list($aItems, $iCnt) = $oAccount->getList($aCond, $iPage, $iPageSize, $aSort['property'].' '.$aSort['direction']);
		echo '{"total":"'.$iCnt.'","data":'.json_encode($aItems).'}';
		exit;
		break;
   case 'del':
   		if ($oAccount->delete($oReq->getInt('id'))){
   			$oReq->forward(conf::getUrl('admin.accounts.list'), 'Пользователь был успешно удален');
   		}
   		break;
}


?>