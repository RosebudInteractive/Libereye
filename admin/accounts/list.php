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
Conf::loadClass('Image');

$oImage = new Image();
$oAccount = new Account();


// ========== processing actions ==========
switch($oReq->getAction())
{
    case 'load':
        $iAccountId = $oReq->getInt('id');
        if ($iAccountId && $oAccount->load($iAccountId)) {
            echo json_encode($oAccount->aData);
            exit;
        }
        echo '{"error":"Аккаунт не найден"}';
        exit;
        break;

    case 'get':
        // search
        $aCond = array();
        if (isset($_GET['filter']))
        {
            if (isset($_GET['filter']['value']) && $_GET['filter']['value'])
                $aCond['{#title}'] = 'pd1.phrase LIKE "%'.Database::escapeLike($_GET['filter']['value']).'%"';
            if (isset($_GET['filter']['fname']) && $_GET['filter']['fname'])
                $aCond['fname'] = 'LIKE "%'.Database::escapeLike($_GET['filter']['fname']).'%"';
            if (isset($_GET['filter']['email']) && $_GET['filter']['email'])
                $aCond['email'] = 'LIKE "%'.Database::escapeLike($_GET['filter']['email']).'%"';
            if (isset($_GET['filter']['phone']) && $_GET['filter']['phone'])
                $aCond['phone'] = 'LIKE "%'.Database::escapeLike($_GET['filter']['phone']).'%"';
            if (isset($_GET['filter']['status']) && $_GET['filter']['status'])
                $aCond['status'] = '="'.Database::escapeLike($_GET['filter']['status']).'"';
            if (isset($_GET['filter']['cdate']) && $_GET['filter']['cdate'] && $_GET['filter']['cdate']!='null')
                $aCond['cdate'] = '="'.Database::date(strtotime($_GET['filter']['cdate'])).'"';
        }

        if ($oReq->getInt('shop_id')) {
            $aCond['shop_id'] = '='.$oReq->getInt('shop_id');
            $aCond['status'] = '="seller"';
        }

        $iPos = $oReq->getInt('start');
        $iPageSize = $oReq->getInt('count', 50);
        $aSort = $oReq->getArray('sort' , array('account_id'=>'desc'));
        list($aItems, $iCnt) = $oAccount->getListOffset($aCond, $iPos, $iPageSize, str_replace('=', ' ', http_build_query($aSort, ' ', ', ')));

        if (!$oReq->get('suggest')) {
            echo '{"pos":' . $iPos . ', "total_count":"' . $iCnt . '","data":' . json_encode($aItems) . '}';
        } else {
            $aAccountsSuggest = array();
            foreach($aItems as $aItem){
                $aAccountsSuggest[] = array("id"=>$aItem['account_id'],"value"=>$aItem['fname']);
            }
            echo json_encode($aAccountsSuggest);
        }

        exit;
        break;

    case 'del':
        if ($oAccount->delete($oReq->getInt('id'))){
            $oReq->forward(conf::getUrl('admin.accounts.list'), 'Новость была успешно удалена');
        }
        break;

    case 'upload':
        $iImageId = 0;
        $sImageName = '';
        $sType = $oReq->get('type', 'account');
        if (isset($_FILES['upload']) && isset($_FILES['upload']['tmp_name'])) {
            $sExt = strtolower(substr($_FILES['upload']['name'], strrpos($_FILES['upload']['name'], '.')+1));
            if ($iImageId = $oImage->upload($_FILES['upload']['tmp_name'], $sType, 0, $sExt) ) {
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

    case 'update':
    case 'create':
        $iAccountId = $oReq->getInt('id');
        $aAccountPost = $oReq->getArray('aAccount');
        $aImages = $oReq->get('images') ? explode(',', $oReq->get('images')) : array();
        $oAccount->aData = $aAccountPost;
        if ($aAccountPost) {
            if ($iAccountId) {
                $oAccount->aData['account_id'] = $iAccountId;
                if ($oAccount->aData['pass']) $oAccount->aData['pass'] = md5($oAccount->aData['pass']);
                else unset($oAccount->aData['pass']);
                if ($aImages) $oAccount->aData['image_id'] = 'NULL';
                    $oAccount->aData['image_id'] = intval($aImages[0]);
                if (!$oAccount->aData['country_id']) $oAccount->aData['country_id'] = 'NULL';
                else $oAccount->aData['country_id'] = intval($oAccount->aData['country_id']);
                if (isset($oAccount->aData['shop_id'])) {
                    if (!$oAccount->aData['shop_id']) $oAccount->aData['shop_id'] = 'NULL';
                    else $oAccount->aData['shop_id'] = intval($oAccount->aData['shop_id']);
                }
                if ($oAccount->isUniqueEmail($iAccountId)) {
                    if (!$oAccount->update(array(), array('country_id', 'shop_id', 'image_id'))) {
                        $aErrors = $oAccount->getErrors();
                    }
                } else $aErrors[] = 'Пользователь с таким email уже зарегистрирован';
            } else {
                $oAccount->aData['pass'] = md5($oAccount->aData['pass']);
                $oAccount->aData['cdate'] = Database::date();
                if (!$aImages) $oAccount->aData['image_id'] = 'NULL';
                else $oAccount->aData['image_id'] = intval($aImages[0]);
                if (!$oAccount->aData['country_id']) $oAccount->aData['country_id'] = 'NULL';
                else $oAccount->aData['country_id'] = intval($oAccount->aData['country_id']);
                if (!$oAccount->aData['shop_id']) $oAccount->aData['shop_id'] = 'NULL';
                else $oAccount->aData['shop_id'] = intval($oAccount->aData['shop_id']);
                if ($oAccount->isUniqueEmail()) {
                    if (!($iAccountId = $oAccount->insert(array('country_id', 'shop_id', 'image_id')))) {
                        $aErrors = $oAccount->getErrors();
                    }
                } else $aErrors[] = 'Пользователь с таким email уже зарегистрирован';
            }
        }



        echo '{ "id":"'.$iAccountId.'", "error":'.json_encode($aErrors).'}';
        exit;
        break;
    case 'destroy':
        $iAccountId = $oReq->getInt('id');
        if (!$oAccount->delete($iAccountId)){
            $aErrors = $oAccount->getErrors();
        }
        echo '{ "id":"'.$iAccountId.'", "error":'.json_encode($aErrors).'}';exit;
        break;
    
   case 'getext':
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