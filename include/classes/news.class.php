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
    }

    /** Select from DB list of records.
     * @param array $aCond      conditions like array('name'=>'LIKE "zz%"', 'price'=>'<12') (usually prepared by Filter class)
     * @param int   $iOffset    page number (may be corrected)
     * @param int   $iPageSize  page size (row per page)
     * @param string $sSort     'order by' statement (usually prepared by Sorder class)
     * @return array ($aRows, $iCnt)
     */
    function getList($aCond=array(), $iPage=0, $iPageSize=0, $sSort='', $aFields=array())
    {
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
                    ', (SELECT phrase FROM lang_phrase l WHERE l.object_id='.$this->sAlias.'.news_id AND language_id=1 AND object_type_id=10 AND object_field="title") title'.
                    ', (SELECT phrase FROM lang_phrase l WHERE l.object_id='.$this->sAlias.'.news_id AND language_id=1 AND object_type_id=10 AND object_field="annotation") annotation'.
                    ', (SELECT phrase FROM lang_phrase l WHERE l.object_id='.$this->sAlias.'.news_id AND language_id=1 AND object_type_id=10 AND object_field="full_news") full_news'.
                    ', (SELECT name FROM image i WHERE i.object_id='.$this->sAlias.'.news_id AND i.object_type="news" LIMIT 1) image'.
                    ' FROM '.$this->sTable.' AS '.$this->sAlias.
                    ' WHERE '.$sCond.
                    ($sSort?(' ORDER BY '.$sSort):'').
                    ($iPageSize?(' LIMIT '.$iOffset.','.$iPageSize):'');
            $aRows = $this->oDb->getRows($sSql);
        }
        return array($aRows, $iCnt);
    }

    
}
?>