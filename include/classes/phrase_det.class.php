<?php
/** ============================================================
 * Class PhraseDet.
 * 
 * @author Rudenko S.
 * @package
 * ============================================================ */
require_once 'classes/utils/dbitem.class.php';

class PhraseDet extends DbItem
{

    function PhraseDet()
    {
        parent::DbItem();
        $this->_initTable('phrase_det');
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
            ' LEFT JOIN phrase p ON p.phrase_id='.$this->sAlias.'.phrase_id'.
            ' WHERE '.$sCond;
        $iCnt = $this->oDb->getField($sSql);
        $aRows = array();
        if ($iCnt)
        {
            $sSql = 'SELECT '.$this->_joinFields($aMap, $aFields).
                ' FROM '.$this->sTable.' AS '.$this->sAlias.
                ' LEFT JOIN phrase p ON p.phrase_id='.$this->sAlias.'.phrase_id'.
                ' WHERE  '.$sCond.
                ($sSort?(' ORDER BY '.$sSort):'').
                ($iPageSize?(' LIMIT '.$iOffset.','.$iPageSize):'');
            $aRows = $this->oDb->getRows($sSql);
        }
        return array($aRows, $iCnt);
    }
}
?>