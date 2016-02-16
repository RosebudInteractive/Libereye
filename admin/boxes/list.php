<?php
/** ============================================================
 * Part section.
 *   Area:    Box
 *   Part:    stats
 *   Section: sales
 * @author Rudenko S.
 * @package Box
 * ============================================================ */
Conf::loadClass('utils/Validator');
Conf::loadClass('utils/Sorter');
Conf::loadClass('utils/Pager');
Conf::loadClass('Box');

$oBox = new Box();


// ========== processing actions ==========
switch($oReq->getAction())
{
   case 'load':
		$iBoxId = $oReq->getInt('id');
        if ($iBoxId && $oBox->load($iBoxId)) {
            echo json_encode($oBox->aData);
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
            if (isset($_GET['filter']['height']) && $_GET['filter']['height'])
                $aCond['height'] = '="'.Database::escape($_GET['filter']['height']).'"';
            if (isset($_GET['filter']['width']) && $_GET['filter']['width'])
                $aCond['width'] = '="'.Database::escape($_GET['filter']['width']).'"';
            if (isset($_GET['filter']['length']) && $_GET['filter']['length'])
                $aCond['length'] = '="'.Database::escape($_GET['filter']['length']).'"';
		}
		$iPos = $oReq->getInt('start');
		$iPageSize = $oReq->getInt('count', 50);
		$aSort = $oReq->getArray('sort' , array('box_id'=>'desc'));
		list($aItems, $iCnt) = $oBox->getListOffset($aCond, $iPos, $iPageSize, str_replace('=', ' ', http_build_query($aSort, ' ', ', ')));

        if (!$oReq->get('suggest'))
            echo '{"pos":'.$iPos.', "total_count":"'.$iCnt.'","data":'.json_encode($aItems).'}';
        else {
            $aBoxsSuggest = array();
            foreach($aItems as $aItem){
                $aBoxsSuggest[] = array("id"=>$aItem['box_id'],"value"=>$aItem['title']);
            }
            echo json_encode($aBoxsSuggest);
        }

		exit;
		break;

    case 'update':
    case 'create':
        $iBoxId = $oReq->getInt('id');
        $aBox = $oReq->getArray('aBox');
        $oBox->aData = $aBox;
        if ($iBoxId) {
            $oBox->aData['box_id'] = $iBoxId;
            if (!$oBox->update(array(), true, array('title'))){
                $aErrors = $oBox->getErrors();
            }
        } else {
            if (!($iBoxId = $oBox->insert(true, array('title')))){
                $aErrors = $oBox->getErrors();
            }
        }
        echo '{ "id":"'.$iBoxId.'", "error":'.json_encode($aErrors).'}';
        exit;
        break;
   case 'destroy':
        $iBoxId = $oReq->getInt('id');
   		if (!$oBox->delete($iBoxId)){
            $aErrors = $oBox->getErrors();
   		}
        echo '{ "id":"'.$iBoxId.'", "error":'.json_encode($aErrors).'}';exit;
   		break;
}


?>