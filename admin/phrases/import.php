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

header('Content-type: text/json; charset=utf-8');
if (!$_FILES['upload']) { echo '{"error":"Файл не загружен"}';exit; }

$aErrors = [];
if (($handle = fopen($_FILES['upload']['tmp_name'], "r")) !== FALSE) {
    $nLine = 1;
    while (($data = fgetcsv($handle, 1000000, ",")) !== FALSE) {
        if (!isset($data[0]) || !intval($data[0])) { $aErrors[] = 'Строка #'.$nLine.': Не указан ID фразы'; continue; }
        $data[0] = intval($data[0]);
        foreach($data as $iLangId=>$sData) {
            if ($iLangId) {
                if ($oPhraseDet->loadBy(array('phrase_id' => '='.$data[0], 'language_id'=>'='.$iLangId))) {
                    $oPhraseDet->aData['phrase'] = $sData;
                    if (!$oPhraseDet->update())
                        $aErrors[] = 'Строка #'.$nLine.' sql error: '.join(', ', $oPhraseDet->getErrors());
                } else {
                    if ($oPhrase->loadBy(array('phrase_id' => '='.$data[0]))) {
                        $oPhraseDet->aData = array(
                            'phrase_id' => $data[0],
                            'language_id' => $iLangId,
                            'phrase' => $sData,
                        );
                        if (!$oPhraseDet->insert())
                            $aErrors[] = 'Строка #'.$nLine.' sql error: '.join(', ', $oPhraseDet->getErrors());
                    } else {
                        $aErrors[] = 'Строка #'.$nLine.': Фраза с ID='.$data[0].' не найдена';
                    }
                }
            }
        }
        $nLine++;
    }
    fclose($handle);
    if (!$aErrors) echo '{"status":"success","message":"Импорт прошел успешно"}';
    else echo '{"status":"error","errors":'.json_encode(join('<br>', $aErrors)).'}';
} else {
   echo '{"error":"Файл не загружен"}';exit;
}
exit;


?>