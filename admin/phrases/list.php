<?php
/** ============================================================
 * Part section.
 *   Area:    Phrase
 *   Part:    stats
 *   Section: sales
 * @author Rudenko S.
 * @package Phrase
 * ============================================================ */
Conf::loadClass('utils/Validator');
Conf::loadClass('utils/Sorter');
Conf::loadClass('utils/Pager');
Conf::loadClass('Phrase');
Conf::loadClass('PhraseDet');
Conf::loadClass('Language');

$oPhrase = new Phrase();
$oPhraseDet = new PhraseDet();
$oLanguage = new Language();


// ========== processing actions ==========
switch($oReq->getAction())
{
   case 'load':
		$iPhraseId = $oReq->getInt('id');
        if ($iPhraseId && $oPhrase->load($iPhraseId)) {
            echo json_encode($oPhrase->aData);
            exit;
        }
		echo '{"error":"Фраза не найдена"}';
		exit;
		break;

    case 'get':
		$aCond = array('object_type_id'=>'=1');
		if (isset($_GET['filter'])) { // search
            if (isset($_GET['filter']['alias']) && $_GET['filter']['alias'])
                $aCond['alias'] = 'LIKE "%'.Database::escapeLike($_GET['filter']['alias']).'%"';
            if (isset($_GET['filter']['def_phrase']) && $_GET['filter']['def_phrase'])
                $aCond['def_phrase'] = 'LIKE "%'.Database::escapeLike($_GET['filter']['def_phrase']).'%"';
		}
		$iPos = $oReq->getInt('start');
		$iPageSize = $oReq->getInt('count', 50);
		$aSort = $oReq->getArray('sort' , array('phrase_id'=>'desc'));
		list($aItems, $iCnt) = $oPhrase->getListOffset($aCond, $iPos, $iPageSize, str_replace('=', ' ', http_build_query($aSort, ' ', ', ')));

        if (!$oReq->get('suggest'))
            echo '{"pos":'.$iPos.', "total_count":"'.$iCnt.'","data":'.json_encode($aItems).'}';
        else {
            $aPhrasesSuggest = array();
            foreach($aItems as $aItem){
                $aPhrasesSuggest[] = array("id"=>$aItem['phrase_id'],"value"=>$aItem['title']);
            }
            echo json_encode($aPhrasesSuggest);
        }
		exit;
		break;

    case 'update':
    case 'create':
        $aFields = array(
            'aPhrase[alias]'   => array('title'=>'Alias', 'def'=>'required',)
        );
        $oValidator = new Validator($aFields);
        $iPhraseId = $oReq->getInt('id');
        $aPhrase = $oReq->getArray('aPhrase');
        if ($oValidator->isValid($oReq->getAll())) {
            $oPhrase->aData = $aPhrase;
            if ($iPhraseId) {
                $oPhrase->aData['phrase_id'] = $iPhraseId;
                if ($oPhrase->isUniqueAlias($iPhraseId)) {
                    if (!$oPhrase->update())
                        $aErrors = $oPhrase->getErrors();
                } else
                    $aErrors[] = 'Такой alias уже используется';
            } else {
                $oPhrase->aData['object_type_id'] = 1;
                if (!$aPhrase['def_phrase'])
                    $aPhrase['def_phrase'] = $aLang[$oLanguage->getDefLanguage()];
                $oPhrase->aData['object_type_id'] = 1;
                if ($oPhrase->isUniqueAlias()) {
                    if (!($iPhraseId = $oPhrase->insert()))
                        $aErrors = $oPhrase->getErrors();
                } else
                    $aErrors[] = 'Такой alias уже используется';
            }

            // фразы
            if (!$aErrors) {
                $aLang = $oReq->getArray('aLang');
                foreach($aLang as $iLangId=>$sPhrase) {
                    $iLangId = intval($iLangId);
                    if ($oPhraseDet->loadBy(array('phrase_id'=>'='.$iPhraseId, 'language_id'=>'='.$iLangId))) {
                        $oPhraseDet->aData['phrase'] = $sPhrase;
                        if (!$oPhraseDet->update())
                            $aErrors += $oPhrase->getErrors();
                    } else {
                        $oPhraseDet->aData = array(
                            'phrase_id' => $iPhraseId,
                            'language_id' => $iLangId,
                            'phrase' => $sPhrase,
                        );
                        if (!$oPhraseDet->insert())
                            $aErrors += $oPhrase->getErrors();
                    }
                }
            }

        } else
            $aErrors = $oValidator->getErrors();
        echo '{ "id":"'.$iPhraseId.'", "error":'.json_encode($aErrors).'}';
        exit;
        break;
   case 'destroy':
        $iPhraseId = $oReq->getInt('id');
       if ($oPhraseDet->deleteByCond(array('phrase_id'=>'='.$iPhraseId))) {
           if (!$oPhrase->delete($iPhraseId))
               $aErrors = $oPhrase->getErrors();
       } else
           $aErrors += $oPhrase->getErrors();

        echo '{ "id":"'.$iPhraseId.'", "error":'.json_encode($aErrors).'}';
   		break;
}


?>