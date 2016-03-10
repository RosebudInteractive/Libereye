<?php
/** ============================================================
 * Class Product.
 * 
 * @author Rudenko S.
 * @package
 * ============================================================ */
require_once 'classes/utils/dbitem.class.php';

class Product extends DbItem
{

    function Product()
    {
        parent::DbItem();
        $this->_initTable('product');
        $this->nObjectType = 2;
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
            ' LEFT JOIN phrase p1 ON p1.object_id='.$this->sAlias.'.product_id AND p1.object_type_id='.$this->nObjectType.'   AND p1.object_field="title" '.
            ' LEFT JOIN phrase_det pd1 ON pd1.phrase_id=p1.phrase_id AND pd1.language_id='.$nLangId.'  '.
            ' LEFT JOIN phrase p2 ON p2.object_id='.$this->sAlias.'.product_id AND p2.object_type_id='.$this->nObjectType.'   AND p2.object_field="description" '.
            ' LEFT JOIN phrase_det pd2 ON pd2.phrase_id=p2.phrase_id AND pd2.language_id='.$nLangId.'  '.
            ' LEFT JOIN brand b ON b.brand_id='.$this->sAlias.'.brand_id '.
            ' LEFT JOIN phrase p3 ON p3.object_id=b.brand_id AND p2.object_type_id=6   AND p2.object_field="title" '.
            ' LEFT JOIN phrase_det pd3 ON pd3.phrase_id=p3.phrase_id AND pd3.language_id='.$nLangId.'  '.
            ' WHERE '.$sCond;
        $iCnt = $this->oDb->getField($sSql);
        $aRows = array();
        if ($iCnt)
        {
            $iOffset = $this->_getOffset($iPage, $iPageSize, $iCnt);
            $sSql = 'SELECT '.$this->_joinFields($aMap, $aFields).
                ', pd1.phrase title'.
                ', pd2.phrase description'.
                ', pd3.phrase brand'.
                ', (SELECT name FROM image i WHERE i.object_id='.$this->sAlias.'.product_id AND i.object_type="product" LIMIT 1) image'.
                ', pr.price'.
                ' FROM '.$this->sTable.' AS '.$this->sAlias.
                ' LEFT JOIN phrase p1 ON p1.object_id='.$this->sAlias.'.product_id AND p1.object_type_id='.$this->nObjectType.'   AND p1.object_field="title" '.
                ' LEFT JOIN phrase_det pd1 ON pd1.phrase_id=p1.phrase_id AND pd1.language_id='.$nLangId.'  '.
                ' LEFT JOIN phrase p2 ON p2.object_id='.$this->sAlias.'.product_id AND p2.object_type_id='.$this->nObjectType.'   AND p2.object_field="description" '.
                ' LEFT JOIN phrase_det pd2 ON pd2.phrase_id=p2.phrase_id AND pd2.language_id='.$nLangId.'  '.
                ' LEFT JOIN brand b ON b.brand_id='.$this->sAlias.'.brand_id '.
                ' LEFT JOIN phrase p3 ON p3.object_id=b.brand_id AND p3.object_type_id=6   AND p3.object_field="title" '.
                ' LEFT JOIN phrase_det pd3 ON pd3.phrase_id=p3.phrase_id AND pd3.language_id='.$nLangId.'  '.
                ' LEFT JOIN price pr ON pr.product_id='.$this->sAlias.'.product_id '.
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
    function load($nId)
    {
        $sSql = 'SELECT '.join(',', $this->aFields).', pr.price'.
            ' FROM '.$this->sTable.' AS '.$this->sAlias.
            ' LEFT JOIN price pr ON pr.product_id='.$this->sAlias.'.product_id '.
            ' WHERE '.$this->sAlias.'.'.$this->sId.'="'.$nId.'"';
        $this->aData = $this->oDb->getRow($sSql);
        return sizeof($this->aData);
    }

}
?>