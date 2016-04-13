<?php
/** ============================================================
 * Part section.
 *   Area:    Template
 *   Part:    stats
 *   Section: sales
 * @author Rudenko S.
 * @package Template
 * ============================================================ */
Conf::loadClass('utils/Validator');
Conf::loadClass('utils/Sorter');
Conf::loadClass('utils/Pager');
Conf::loadClass('MailTemplate');
Conf::loadClass('Shop2brand');

$oTemplate = new MailTemplate();


// ========== processing actions ==========
switch($oReq->getAction())
{
   case 'load':
		$iTemplateId = $oReq->getInt('id');
        if ($iTemplateId && $oTemplate->load($iTemplateId)) {
            echo json_encode($oTemplate->aData);
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
                $aCond['{#subject}'] = 'pd1.phrase LIKE "%'.Database::escapeLike($_GET['filter']['value']).'%"';
            if (isset($_GET['filter']['subject']) && $_GET['filter']['subject'])
                $aCond['{#subject}'] = 'pd1.phrase LIKE "%'.Database::escapeLike($_GET['filter']['subject']).'%"';
            if (isset($_GET['filter']['body']) && $_GET['filter']['body'])
                $aCond['{#body}'] = 'pd2.phrase LIKE "%'.Database::escapeLike($_GET['filter']['body']).'%"';
		}

		$iPos = $oReq->getInt('start');
		$iPageSize = $oReq->getInt('count', 50);
		$aSort = $oReq->getArray('sort' , array('template_id'=>'desc'));
		list($aItems, $iCnt) = $oTemplate->getListOffset($aCond, $iPos, $iPageSize, str_replace('=', ' ', http_build_query($aSort, ' ', ', ')));

        if (!$oReq->get('suggest'))
            echo '{"pos":'.$iPos.', "total_count":"'.$iCnt.'","data":'.json_encode($aItems).'}';
        else {
            $aTemplatesSuggest = array();
            foreach($aItems as $aItem){
                $aTemplatesSuggest[] = array("id"=>$aItem['template_id'],"value"=>$aItem['subject']);
            }
            echo json_encode($aTemplatesSuggest);
        }

		exit;
		break;

    case 'update':
    case 'create':
        $iTemplateId = $oReq->getInt('id');
        $aTemplate = $oReq->getArray('aTemplate');
        $oTemplate->aData = $aTemplate;
        if ($iTemplateId) {
            $oTemplate->aData['template_id'] = $iTemplateId;
            if (!$oTemplate->update(array(), true, array('subject', 'body'))){
                $aErrors = $oTemplate->getErrors();
            }
        } else {
            if (!($iTemplateId = $oTemplate->insert(true, array('subject', 'body')))){
                $aErrors = $oTemplate->getErrors();
            }
        }
        echo '{ "id":"'.$iTemplateId.'", "error":'.json_encode($aErrors).'}';
        exit;
        break;
   case 'destroy':
        $iTemplateId = $oReq->getInt('id');
   		if (!$oTemplate->delete($iTemplateId)){
            $aErrors = $oTemplate->getErrors();
   		}
        echo '{ "id":"'.$iTemplateId.'", "error":'.json_encode($aErrors).'}';exit;
   		break;

}


?>