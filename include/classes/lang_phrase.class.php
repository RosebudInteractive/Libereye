<?php
/** ============================================================
 * Class Purchase.
 * 
 * @author Rudenko S.
 * @package
 * ============================================================ */
require_once 'classes/utils/dbitem.class.php';

class LangPhrase extends DbItem
{
    function LangPhrase()
    {
        parent::DbItem();
        $this->_initTable('lang_phrase');
    }

    /** Returns system setting stored in DB (performs caching)
     * @param string $sKey setting key
     * @return mixed setting value
     */
    static function getPhrase($sKey, $nLang=0)
    {
        static $aSett = array();
        if (! array_key_exists($sKey, $aSett)) //not found in cache
        {
            $oDb = &Database::get();
            $aSett[$sKey] = $oDb->getField('SELECT val FROM '.conf::getT('lang_phrase').' WHERE alias="'.Database::escape($sKey).'" and language_id="'.$nLang.'"');
        }
        return $aSett[$sKey];
    }

    /** Returns system setting stored in DB (performs caching)
     * @param string $sKey setting key
     * @return mixed setting value
     */
    static function getPhrases($nLang=0, $bRecreate=0)
    {
        static $aPhrases = array();
        if (!$aPhrases)
        {
            $oDb = &Database::get();
            // Expiration times can be set from 0, meaning "never expire", to 30 days.
            $aPhrasesDef = array();
            $aPhrasesAll = $oDb->getRows('SELECT p.alias, pd.phrase FROM '.conf::getT('phrase_det').' pd '.
                ' LEFT JOIN '.conf::getT('phrase').' p ON p.phrase_id=pd.phrase_id '.
                ' WHERE pd.language_id=(SELECT language_id FROM language WHERE is_default=1 LIMIT 1) and p.object_type_id=1', true, 0);
            foreach($aPhrasesAll as $aPhrase) {
                $aPhrasesDef[$aPhrase['alias']] = $aPhrase['phrase'];
            }
            $aPhrasesAll = $oDb->getRows('SELECT p.alias, pd.phrase FROM '.conf::getT('phrase_det').' pd '.
                ' LEFT JOIN '.conf::getT('phrase').' p ON p.phrase_id=pd.phrase_id '.
                ' WHERE pd.language_id="'.$nLang.'" and p.object_type_id=1', true, 0);
            foreach($aPhrasesAll as $aPhrase) {
                $aPhrases[$aPhrase['alias']] = $aPhrase['phrase']?$aPhrase['phrase']:$aPhrasesDef[$aPhrase['alias']];
            }
        }
        return $aPhrases;
    }

    /** Select from DB list of records.
     * @param array $aCond      conditions like array('name'=>'LIKE "zz%"', 'price'=>'<12') (usually prepared by Filter class)
     * @param int   $iOffset    page number (may be corrected)
     * @param int   $iPageSize  page size (row per page)
     * @param string $sSort     'order by' statement (usually prepared by Sorder class)
     * @return array ($aRows, $iCnt)
     */
    function getListCustom($aCond=array(), $iPage=0, $iPageSize=0, $sSort='', $aFields=array())
    {
        $aMap = $this->aFields;

        $sCond = $this->_parseCond($aCond, $aMap);
        $sSql = 'SELECT COUNT(*) FROM `'.$this->sTable.'` AS '.$this->sAlias.' WHERE '.$sCond;
        $iCnt = $this->oDb->getField($sSql);
        $aRows = array();
        if ($iCnt)
        {
            $iOffset = $this->_getOffset($iPage, $iPageSize, $iCnt);
            $sSql = 'SELECT '.$this->_joinFields($aMap, $aFields).', lp_ru.phrase title_ru, lp_en.phrase title_en, lp_fr.phrase title_fr'.
                ' FROM '.$this->sTable.' AS '.$this->sAlias.
                ' LEFT JOIN lang_phrase lp_ru ON lp.alias=lp_ru.alias AND lp_ru.language_id=1'.
                ' LEFT JOIN lang_phrase lp_en ON lp.alias=lp_en.alias AND lp_en.language_id=2'.
                ' LEFT JOIN lang_phrase lp_fr ON lp.alias=lp_fr.alias AND lp_fr.language_id=3'.
                ' WHERE '.$sCond.
                ($sSort?(' ORDER BY '.$sSort):'').
                ($iPageSize?(' LIMIT '.$iOffset.','.$iPageSize):'');
            $aRows = $this->oDb->getRows($sSql);
        }
        return array($aRows, $iCnt);
    }

}
?>