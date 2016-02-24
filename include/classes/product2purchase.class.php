<?php
/** ============================================================
 * Class Product2purchase.
 * 
 * @author Rudenko S.
 * @package
 * ============================================================ */
require_once 'classes/utils/dbitem.class.php';

class Product2purchase extends DbItem
{

    function Product2purchase()
    {
        parent::DbItem();
        $this->_initTable('product2purchase');
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
                ', pd1.phrase product, c.sign'.
                ', (SELECT name FROM image i WHERE i.object_id='.$this->sAlias.'.product_id AND i.object_type="product" ORDER BY image_id DESC LIMIT 1) image'.
                ' FROM '.$this->sTable.' AS '.$this->sAlias.
                ' LEFT JOIN product p ON p.product_id='.$this->sAlias.'.product_id '.
                ' LEFT JOIN phrase p1 ON p1.object_id='.$this->sAlias.'.product_id AND p1.object_type_id=2   AND p1.object_field="title" '.
                ' LEFT JOIN phrase_det pd1 ON pd1.phrase_id=p1.phrase_id AND pd1.language_id='.$nLangId.'  '.
                ' LEFT JOIN purchase pr ON pr.purchase_id='.$this->sAlias.'.purchase_id '.
                ' LEFT JOIN currency c ON c.currency_id=pr.currency_id '.
                ' WHERE  '.$sCond.
                ($sSort?(' ORDER BY '.$sSort):'').
                ($iPageSize?(' LIMIT '.$iOffset.','.$iPageSize):'');
            $aRows = $this->oDb->getRows($sSql);
        }
        return array($aRows, $iCnt);
    }


}
?>