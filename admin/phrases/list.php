<?php
/** ============================================================
 * Part section.
 *   Area:    LangPhrase
 *   Part:    stats
 *   Section: sales
 * @author Rudenko S.
 * @package LangPhrase
 * ============================================================ */
Conf::loadClass('utils/Validator');
Conf::loadClass('utils/Sorter');
Conf::loadClass('utils/Pager');
Conf::loadClass('LangPhrase');

$oLangPhrase = new LangPhrase();


// ========== processing actions ==========
switch($oReq->getAction())
{
   case 'get':
		// delete
		if (isset($_GET['subact']) && $_GET['subact']=='del')
		{
			if ($oReq->get('ids'))
				$oLangPhrase->deleteByCond(array('alias'=>'IN("'.$oReq->get('ids').'")'));
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
			'property'=>isset($aSort[0]) && in_array($aSort[0]->property, array('lang_phrase_id','title'))?$aSort[0]->property:'lang_phrase_id', 
			'direction'=>isset($aSort[0]) && in_array($aSort[0]->direction, array('DESC','ASC'))?$aSort[0]->direction:'DESC', 
		);
		list($aItems, $iCnt) = $oLangPhrase->getListCustom($aCond, $iPage, $iPageSize, $aSort['property'].' '.$aSort['direction']);
		echo '{"total":"'.$iCnt.'","data":'.json_encode($aItems).'}';
		exit;
		break;
   case 'del':
   		if ($oLangPhrase->delete($oReq->getInt('id'))){
   			$oReq->forward(conf::getUrl('admin.phrases.list'), 'Бронирование было успешно удалено');
   		}
   		break;
  case 'update':
        $aData = json_decode(file_get_contents('php://input'))->data;
        $nLang = 0;
        $sPhrase = '';
       // d($aData);
        if (property_exists($aData, 'title_ru')) {
            $sPhrase = $aData->title_ru;
            $nLang = 1;
            if ($oLangPhrase->loadBy(array('alias'=>'="'.Database::escape($aData->alias).'"', 'language_id'=>'='.$nLang))) {
                $oLangPhrase->aData['phrase'] = $sPhrase;
                $oLangPhrase->update();
            } else if ($oLangPhrase->loadBy(array('alias'=>'="'.Database::escape($aData->alias).'"'))) {
                $oLangPhrase->aData = array(
                    'alias'=>$aData->alias,
                    'phrase'=>$sPhrase,
                    'language_id'=>$nLang,
                );
                $oLangPhrase->insert();
            }
        }
        if (property_exists($aData, 'title_en')) {
            $sPhrase = $aData->title_en;
            $nLang = 2;
            if ($oLangPhrase->loadBy(array('alias'=>'="'.Database::escape($aData->alias).'"', 'language_id'=>'='.$nLang))) {
                $oLangPhrase->aData['phrase'] = $sPhrase;
                $oLangPhrase->update();
            } else if ($oLangPhrase->loadBy(array('alias'=>'="'.Database::escape($aData->alias).'"'))) {
                $oLangPhrase->aData = array(
                    'alias'=>$aData->alias,
                    'phrase'=>$sPhrase,
                    'language_id'=>$nLang,
                );
                $oLangPhrase->insert();
            }
        }
        if (property_exists($aData, 'title_fr')) {
            $sPhrase = $aData->title_fr;
            $nLang = 3;
            if ($oLangPhrase->loadBy(array('alias'=>'="'.Database::escape($aData->alias).'"', 'language_id'=>'='.$nLang))) {
                $oLangPhrase->aData['phrase'] = $sPhrase;
                $oLangPhrase->update();
            } else if ($oLangPhrase->loadBy(array('alias'=>'="'.Database::escape($aData->alias).'"'))) {
                    $oLangPhrase->aData = array(
                        'alias'=>$aData->alias,
                        'phrase'=>$sPhrase,
                        'language_id'=>$nLang,
                    );
                    $oLangPhrase->insert();
            }
        }


        list($aRows,) = $oLangPhrase->getListCustom(array('alias'=>'="'.Database::escape($aData->alias).'"'),0,1);
        echo '{"data":'.json_encode($aRows[0]).'}';
        exit;
   		break;
  case 'create':
        $aData = json_decode(file_get_contents('php://input'))->data;
        $aData = property_exists($aData, 'title_ru') ? $aData: $aData[0];
        $nLang = 0;
        $sPhrase = '';

        if ($oLangPhrase->loadBy(array('alias'=>'="'.Database::escape($aData->alias).'"'))) {
            echo '{"success":false,"errors":"Общее название должно быть уникально!","data":null}';
            exit;
        }



        $oLangPhrase->aData = array();
        if (property_exists($aData, 'title_ru') && $aData->title_ru && $aData->title_en) {
            $oLangPhrase->aData['alias'] = $aData->alias;
            $oLangPhrase->aData['phrase'] = $aData->title_ru;
            $oLangPhrase->aData['language_id'] = 1;
            $oLangPhrase->insert();
        }
        if (property_exists($aData, 'title_en') && $aData->title_en) {
            $oLangPhrase->aData['alias'] = $aData->alias;
            $oLangPhrase->aData['phrase'] = $aData->title_en;
            $oLangPhrase->aData['language_id'] = 2;
            $oLangPhrase->insert();
        }
        if (property_exists($aData, 'title_fr') && $aData->title_fr && $aData->title_en) {
            $oLangPhrase->aData['alias'] = $aData->alias;
            $oLangPhrase->aData['phrase'] = $aData->title_fr;
            $oLangPhrase->aData['language_id'] = 3;
            $oLangPhrase->insert();
        }
        list($aRows,) = $oLangPhrase->getListCustom(array('alias'=>'="'.Database::escape($aData->alias).'"', 'language_id'=>'=2'));
        echo '{"data":'.json_encode($aRows[0]).'}';
        exit;
   		break;
}


?>