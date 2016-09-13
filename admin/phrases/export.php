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
Conf::loadClass('utils/Csv');

$oPhrase = new Phrase();
$oPhraseDet = new PhraseDet();
$oLanguage = new Language();

$aCond = array('{#object_type_id}'=>'p.object_type_id=1');
$iPos = $oReq->getInt('start');
$iPageSize = $oReq->getInt('count', 50);
$aSort = $oReq->getArray('sort' , array('phrase_id'=>'desc'));
list($aItems, $iCnt) = $oPhraseDet->getListOffset($aCond, 0, 0, 'phrase_id');
$aPhrases = [];
foreach($aItems as $aItem){
    $aPhrases[$aItem['phrase_id']][0] = $aItem['phrase_id'];
    $aPhrases[$aItem['phrase_id']][$aItem['language_id']] = $aItem['phrase'];
}

$oCsv = new Csv();
$oCsv->export($aPhrases);
exit;
?>