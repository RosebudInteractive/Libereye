<?php
/** ============================================================
 * Part section.
 *   Area:    Currency
 *   Part:    stats
 *   Section: sales
 * @author Rudenko S.
 * @package Currency
 * ============================================================ */
Conf::loadClass('utils/Validator');
Conf::loadClass('utils/Sorter');
Conf::loadClass('utils/Pager');
Conf::loadClass('Currency');

$oCurrency = new Currency();


// ========== processing actions ==========
switch($oReq->getAction())
{
   case 'load':
		$iCurrencyId = $oReq->getInt('id');
        if ($iCurrencyId && $oCurrency->load($iCurrencyId)) {
            echo json_encode($oCurrency->aData);
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
            if (isset($_GET['filter']['code']) && $_GET['filter']['code'])
                $aCond['code'] = 'LIKE "%'.Database::escapeLike($_GET['filter']['code']).'%"';
        }

		$iPos = $oReq->getInt('start');
		$iPageSize = $oReq->getInt('count', 50);
		$aSort = $oReq->getArray('sort' , array('currency_id'=>'desc'));
		list($aItems, $iCnt) = $oCurrency->getListOffset($aCond, $iPos, $iPageSize, str_replace('=', ' ', http_build_query($aSort, ' ', ', ')));

        if (!$oReq->get('suggest'))
            echo '{"pos":'.$iPos.', "total_count":"'.$iCnt.'","data":'.json_encode($aItems).'}';
        else {
            $aCurrencysSuggest = array();
            foreach($aItems as $aItem){
                $aCurrencysSuggest[] = array("id"=>$aItem['currency_id'],"value"=>$aItem['title']);
            }
            echo json_encode($aCurrencysSuggest);
        }

		exit;
		break;

    case 'update':
    case 'create':
        $iCurrencyId = $oReq->getInt('id');
        $aCurrency = $oReq->getArray('aCurrency');
        $oCurrency->aData = $aCurrency;
        if ($iCurrencyId) {
            $oCurrency->aData['currency_id'] = $iCurrencyId;
            if (!$oCurrency->update()){
                $aErrors = $oCurrency->getErrors();
            }
        } else {
            if (!($iCurrencyId = $oCurrency->insert())){
                $aErrors = $oCurrency->getErrors();
            }
        }
        echo '{ "id":"'.$iCurrencyId.'", "error":'.json_encode($aErrors).'}';
        exit;
        break;
   case 'destroy':
        $iCurrencyId = $oReq->getInt('id');
   		if (!$oCurrency->delete($iCurrencyId)){
            $aErrors = $oCurrency->getErrors();
   		}
        echo '{ "id":"'.$iCurrencyId.'", "error":'.json_encode($aErrors).'}';exit;
   		break;
}


?>