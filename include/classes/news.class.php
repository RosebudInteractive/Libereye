<?php
/** ============================================================
 * Class News.
 * 
 * @author Rudenko S.
 * @package
 * ============================================================ */
require_once 'classes/utils/dbitem.class.php';

class News extends DbItem
{

    function News()
    {
        parent::DbItem();
        $this->_initTable('news');
        $this->nObjectType = 10;
    }

    /** Select from DB list of records.
     * @param array $aCond      conditions like array('name'=>'LIKE "zz%"', 'price'=>'<12') (usually prepared by Filter class)
     * @param int   $iOffset    page number (may be corrected)
     * @param int   $iPageSize  page size (row per page)
     * @param string $sSort     'order by' statement (usually prepared by Sorder class)
     * @return array ($aRows, $iCnt)
     */
    function getList($aCond=array(), $iPage=0, $iPageSize=0, $sSort='', $aFields=array(), $nLangId=0)
    {
        $nLangId = $nLangId? $nLangId: LANGUAGEID;
        $aMap = $this->aFields;
        $sCond = $this->_parseCond($aCond, $aMap);
        $sSql = 'SELECT COUNT(*) FROM `'.$this->sTable.'` AS '.$this->sAlias.
        ' WHERE '.$sCond;
        $iCnt = $this->oDb->getField($sSql);
        $aRows = array();
        if ($iCnt)
        {
            $iOffset = $this->_getOffset($iPage, $iPageSize, $iCnt);
            $sSql = 'SELECT '.$this->_joinFields($aMap, $aFields).
                    ', pd1.phrase title'.
                    ', pd2.phrase annotation'.
                    ', pd3.phrase full_news'.
                    ', (SELECT name FROM image i WHERE i.object_id='.$this->sAlias.'.news_id AND i.object_type="news" LIMIT 1) image'.
                    ' FROM '.$this->sTable.' AS '.$this->sAlias.
                    ' LEFT JOIN phrase p1 ON p1.object_id='.$this->sAlias.'.news_id AND p1.object_type_id='.$this->nObjectType.'   AND p1.object_field="title" '.
                    ' LEFT JOIN phrase_det pd1 ON pd1.phrase_id=p1.phrase_id AND pd1.language_id='.$nLangId.'  '.
                    ' LEFT JOIN phrase p2 ON p2.object_id='.$this->sAlias.'.news_id AND p2.object_type_id='.$this->nObjectType.'   AND p2.object_field="annotation" '.
                    ' LEFT JOIN phrase_det pd2 ON pd2.phrase_id=p2.phrase_id AND pd2.language_id='.$nLangId.'  '.
                    ' LEFT JOIN phrase p3 ON p3.object_id='.$this->sAlias.'.news_id AND p3.object_type_id='.$this->nObjectType.'   AND p3.object_field="full_news" '.
                    ' LEFT JOIN phrase_det pd3 ON pd3.phrase_id=p3.phrase_id AND pd3.language_id='.$nLangId.'  '.
                    ' WHERE  '.$sCond.
                    ($sSort?(' ORDER BY '.$sSort):'').
                    ($iPageSize?(' LIMIT '.$iOffset.','.$iPageSize):'');
            $aRows = $this->oDb->getRows($sSql);
        }
        return array($aRows, $iCnt);
    }

    /** Loads info from DB by PK
     * @param int $nId PK
     * @return boolean 1 - loaded, false - not found
     */
    function load($nId, $nLangId=0)
    {
        $this->aData = array();
        if ($nId) {
            $sSql = 'SELECT '.join(',', $this->aFields).
                ', (SELECT name FROM image i WHERE i.object_id='.$this->sAlias.'.news_id AND i.object_type="news" LIMIT 1) image'.
                ' FROM '.$this->sTable.' AS '.$this->sAlias.
                ' WHERE '.$this->sId.'="'.$nId.'"';
            $this->aData = $this->oDb->getRow($sSql);

            $sSql = 'SELECT p.object_field, pd.phrase, pd.language_id'.
                ' FROM  phrase p '.
                ' LEFT JOIN phrase_det pd ON pd.phrase_id=p.phrase_id  '.
                ' WHERE p.object_type_id='.$this->nObjectType.' AND p.object_id="'.$nId.'"';
            $aRows = $this->oDb->getRows($sSql);
            $aInfo = array();
            foreach ($aRows as $aRow) {
                $aInfo[$aRow['object_field']][$aRow['language_id']] = $aRow['phrase'];
            }

            if ($nLangId) {
                $this->aData['title'] = $aInfo['title'][$nLangId];
                $this->aData['annotation'] = $aInfo['annotation'][$nLangId];
                $this->aData['full_news'] = $aInfo['full_news'][$nLangId];
            } else {
                $this->aData['title'] = $aInfo['title'];
                $this->aData['annotation'] = $aInfo['annotation'];
                $this->aData['full_news'] = $aInfo['full_news'];
            }
        }

        return sizeof($this->aData);
    }



    /** Select from DB list of records.
     * @param array $aCond      conditions like array('name'=>'LIKE "zz%"', 'price'=>'<12') (usually prepared by Filter class)
     * @param int   $iOffset    page number (may be corrected)
     * @param int   $iPageSize  page size (row per page)
     * @param string $sSort     'order by' statement (usually prepared by Sorder class)
     * @return array ($aRows, $iCnt)
     */
    function getListOffset($aCond=array(), $iOffset=0, $iPageSize=0, $sSort='', $aFields=array(), $nLangId=0)
    {
        $nLangId = $nLangId? $nLangId: LANGUAGEID;
        $aMap = $this->aFields;
        $sCond = $this->_parseCond($aCond, $aMap);
        $sSql = 'SELECT COUNT(*) FROM `'.$this->sTable.'` AS '.$this->sAlias.
            (isset($aCond['{#title}']) || isset($aCond['{#annotation}']) || isset($aCond['{#full_news}'])?
                (
                ' LEFT JOIN phrase p1 ON p1.object_id='.$this->sAlias.'.news_id AND p1.object_type_id='.$this->nObjectType.'   AND p1.object_field="title" '.
                ' LEFT JOIN phrase_det pd1 ON pd1.phrase_id=p1.phrase_id AND pd1.language_id='.$nLangId.'  '.
                ' LEFT JOIN phrase p2 ON p2.object_id='.$this->sAlias.'.news_id AND p2.object_type_id='.$this->nObjectType.'   AND p2.object_field="annotation" '.
                ' LEFT JOIN phrase_det pd2 ON pd2.phrase_id=p2.phrase_id AND pd2.language_id='.$nLangId.'  '.
                ' LEFT JOIN phrase p3 ON p3.object_id='.$this->sAlias.'.news_id AND p3.object_type_id='.$this->nObjectType.'   AND p3.object_field="full_news" '.
                ' LEFT JOIN phrase_det pd3 ON pd3.phrase_id=p3.phrase_id AND pd3.language_id='.$nLangId.'  '
                ):'').
            ' WHERE '.$sCond;
        $iCnt = $this->oDb->getField($sSql);
        $aRows = array();
        if ($iCnt)
        {
            $sSql = 'SELECT '.$this->_joinFields($aMap, $aFields).
                ', pd1.phrase title'.
                ', pd2.phrase annotation'.
                ', pd3.phrase full_news'.
                ', (SELECT name FROM image i WHERE i.object_id='.$this->sAlias.'.news_id AND i.object_type="news" LIMIT 1) image'.
                ' FROM '.$this->sTable.' AS '.$this->sAlias.
                ' LEFT JOIN phrase p1 ON p1.object_id='.$this->sAlias.'.news_id AND p1.object_type_id='.$this->nObjectType.'   AND p1.object_field="title" '.
                ' LEFT JOIN phrase_det pd1 ON pd1.phrase_id=p1.phrase_id AND pd1.language_id='.$nLangId.'  '.
                ' LEFT JOIN phrase p2 ON p2.object_id='.$this->sAlias.'.news_id AND p2.object_type_id='.$this->nObjectType.'   AND p2.object_field="annotation" '.
                ' LEFT JOIN phrase_det pd2 ON pd2.phrase_id=p2.phrase_id AND pd2.language_id='.$nLangId.'  '.
                ' LEFT JOIN phrase p3 ON p3.object_id='.$this->sAlias.'.news_id AND p3.object_type_id='.$this->nObjectType.'   AND p3.object_field="full_news" '.
                ' LEFT JOIN phrase_det pd3 ON pd3.phrase_id=p3.phrase_id AND pd3.language_id='.$nLangId.'  '.
                ' WHERE  '.$sCond.
                ($sSort?(' ORDER BY '.$sSort):'').
                ($iPageSize?(' LIMIT '.$iOffset.','.$iPageSize):'');
            $aRows = $this->oDb->getRows($sSql);
        }
        return array($aRows, $iCnt);
    }
}
?>