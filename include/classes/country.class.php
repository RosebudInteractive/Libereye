<?php
/** ============================================================
 * Class Country.
 * 
 * @author Rudenko S.
 * @package
 * ============================================================ */
require_once 'classes/utils/dbitem.class.php';

class Country extends DbItem
{

    function Country()
    {
        parent::DbItem();
        $this->_initTable('country');
        $this->nObjectType = 8;
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
                    ' FROM '.$this->sTable.' AS '.$this->sAlias.
                    ' LEFT JOIN phrase p1 ON p1.object_id='.$this->sAlias.'.country_id AND p1.object_type_id='.$this->nObjectType.'   AND p1.object_field="title" '.
                    ' LEFT JOIN phrase_det pd1 ON pd1.phrase_id=p1.phrase_id AND pd1.language_id='.$nLangId.'  '.
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
                ' FROM '.$this->sTable.' AS '.$this->sAlias.
                ' LEFT JOIN phrase p ON p.phrase_id=c.title_id '.
                ' WHERE '.$this->sId.'="'.$nId.'"';
            $this->aData = $this->oDb->getRow($sSql);

            if ($this->aData) {

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
                    $this->aData['title'] = isset($aInfo['title'])?$aInfo['title'][$nLangId]:'';
                } else {
                    $this->aData['title'] = isset($aInfo['title'])?$aInfo['title']:array();
                }
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
            (isset($aCond['{#title}'])?(' LEFT JOIN phrase p1 ON p1.object_id='.$this->sAlias.'.country_id AND p1.object_type_id='.$this->nObjectType.'   AND p1.object_field="title" '.
                ' LEFT JOIN phrase_det pd1 ON pd1.phrase_id=p1.phrase_id AND pd1.language_id='.$nLangId.'  '):' ').
            ' WHERE '.$sCond;
        $iCnt = $this->oDb->getField($sSql);
        $aRows = array();
        if ($iCnt)
        {
            $sSql = 'SELECT '.$this->_joinFields($aMap, $aFields).
                ', pd1.phrase title'.
                ' FROM '.$this->sTable.' AS '.$this->sAlias.
                ' LEFT JOIN phrase p1 ON p1.object_id='.$this->sAlias.'.country_id AND p1.object_type_id='.$this->nObjectType.'   AND p1.object_field="title" '.
                ' LEFT JOIN phrase_det pd1 ON pd1.phrase_id=p1.phrase_id AND pd1.language_id='.$nLangId.'  '.
                ' WHERE  '.$sCond.
                ($sSort?(' ORDER BY '.$sSort):'').
                ($iPageSize?(' LIMIT '.$iOffset.','.$iPageSize):'');
            $aRows = $this->oDb->getRows($sSql);
        }
        return array($aRows, $iCnt);
    }


    /** Select data from table as hash.
     * @param string $sValue name of columns with values
     * @param array  $aCond  condition array
     * @return array hash ($id=>$value)
     */
    function getHash($sValue='name', $aCond=array(), $sSort='', $nLangId=0)
    {
        $nLangId = $nLangId? $nLangId: LANGUAGEID;
        $sCond = $this->_parseCond($aCond, $this->aFields);
        $sSql = 'SELECT '.$this->sId.', pd1.phrase title'.
            ' FROM '.$this->sTable.' AS '.$this->sAlias.
            ' LEFT JOIN phrase p1 ON p1.object_id='.$this->sAlias.'.country_id AND p1.object_type_id='.$this->nObjectType.'   AND p1.object_field="title" '.
            ' LEFT JOIN phrase_det pd1 ON pd1.phrase_id=p1.phrase_id AND pd1.language_id='.$nLangId.'  '.
            ($sCond?'  WHERE '.$sCond:'').
            '  ORDER BY '.($sSort?$sSort:$sValue);
        $aRows = $this->oDb->getRows($sSql);
        $aRes = array();
        foreach($aRows as $aRow)
            $aRes[$aRow[$this->sId]] = $aRow[$sValue];
        return $aRes;
    }
    
}
?>