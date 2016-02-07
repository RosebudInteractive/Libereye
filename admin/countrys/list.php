<?php
/** ============================================================
 * Part section.
 *   Area:    Country
 *   Part:    stats
 *   Section: sales
 * @author Rudenko S.
 * @package Country
 * ============================================================ */
Conf::loadClass('utils/Validator');
Conf::loadClass('utils/Sorter');
Conf::loadClass('utils/Pager');
Conf::loadClass('Country');

$oCountry = new Country();


// ========== processing actions ==========
switch($oReq->getAction())
{
   case 'load':
		$iCountryId = $oReq->getInt('id');
        if ($iCountryId && $oCountry->load($iCountryId)) {
            echo json_encode($oCountry->aData);
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
            if (isset($_GET['filter']['code2']) && $_GET['filter']['code2'])
                $aCond['code2'] = 'LIKE "%'.Database::escapeLike($_GET['filter']['code2']).'%"';
            if (isset($_GET['filter']['code3']) && $_GET['filter']['code3'])
                $aCond['code3'] = 'LIKE "%'.Database::escapeLike($_GET['filter']['code3']).'%"';
        }

		$iPos = $oReq->getInt('start');
		$iPageSize = $oReq->getInt('count', 50);
		$aSort = $oReq->getArray('sort' , array('country_id'=>'desc'));
		list($aItems, $iCnt) = $oCountry->getListOffset($aCond, $iPos, $iPageSize, str_replace('=', ' ', http_build_query($aSort, ' ', ', ')));

        if (!$oReq->get('suggest'))
            echo '{"pos":'.$iPos.', "total_count":"'.$iCnt.'","data":'.json_encode($aItems).'}';
        else {
            $aCountrysSuggest = array();
            foreach($aItems as $aItem){
                $aCountrysSuggest[] = array("id"=>$aItem['country_id'],"value"=>$aItem['title']);
            }
            echo json_encode($aCountrysSuggest);
        }

		exit;
		break;

    case 'update':
    case 'create':
        $iCountryId = $oReq->getInt('id');
        $aCountry = $oReq->getArray('aCountry');
        $oCountry->aData = $aCountry;
        if ($iCountryId) {
            $oCountry->aData['country_id'] = $iCountryId;
            if (!$oCountry->update(array(), true, array('title'))){
                $aErrors = $oCountry->getErrors();
            }
        } else {
            if (!($iCountryId = $oCountry->insert(true, array('title')))){
                $aErrors = $oCountry->getErrors();
            }
        }
        echo '{ "id":"'.$iCountryId.'", "error":'.json_encode($aErrors).'}';
        exit;
        break;
   case 'destroy':
        $iCountryId = $oReq->getInt('id');
   		if (!$oCountry->delete($iCountryId)){
            $aErrors = $oCountry->getErrors();
   		}
        echo '{ "id":"'.$iCountryId.'", "error":'.json_encode($aErrors).'}';exit;
   		break;
}


?>