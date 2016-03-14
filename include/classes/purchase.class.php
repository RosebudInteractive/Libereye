<?php
/** ============================================================
 * Class Purchase.
 * 
 * @author Rudenko S.
 * @package
 * ============================================================ */
require_once 'classes/utils/dbitem.class.php';

class Purchase extends DbItem
{

    function Purchase()
    {
        parent::DbItem();
        $this->_initTable('purchase');
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
        ' LEFT JOIN account a USING(account_id)'.
        ' WHERE '.$sCond;
        $iCnt = $this->oDb->getField($sSql);
        $aRows = array();
        if ($iCnt)
        {
            $iOffset = $this->_getOffset($iPage, $iPageSize, $iCnt);
            $sSql = 'SELECT '.$this->_joinFields($aMap, $aFields).', a.fname, a.email, a2.fname seller,
                        a2.email seller_email, i2.name seller_image, pd1.phrase shop_title, ss.shop_id, ss.time_from, c.sign'.
                    ' FROM '.$this->sTable.' AS '.$this->sAlias.
                    ' LEFT JOIN account a USING(account_id)'.
                    ' LEFT JOIN account a2 ON a2.account_id=p.seller_id'.
                    ' LEFT JOIN image i2 ON i2.image_id=a2.image_id'.
                ' LEFT JOIN currency c ON c.currency_id='.$this->sAlias.'.currency_id '.
                ' LEFT JOIN shop_slot ss ON ss.shop_slot_id=p.shop_slot_id'.
                ' LEFT JOIN shop s ON s.shop_id=ss.shop_id'.
                ' LEFT JOIN phrase p1 ON p1.object_id=s.shop_id AND p1.object_type_id=4   AND p1.object_field="title" '.
                ' LEFT JOIN phrase_det pd1 ON pd1.phrase_id=p1.phrase_id AND pd1.language_id='.$nLangId.'  '.
                    ' WHERE '.$sCond.
                    ($sSort?(' ORDER BY '.$sSort):'').
                    ($iPageSize?(' LIMIT '.$iOffset.','.$iPageSize):'');
            $aRows = $this->oDb->getRows($sSql);
        }
        return array($aRows, $iCnt);
    }

    /** Load info from DB by given condition
     * @param array $aCond condition
     * @return array data
     */
    function loadBy($aCond, $nLangId=0)
    {
        $nLangId = $nLangId? $nLangId: LANGUAGEID;
        $sSql = 'SELECT '.$this->_joinFields($this->aFields).', a.fname, a.email, a2.fname seller'.
            ', a2.email seller_email, c.code currency, c.sign, i2.name image, i.name seller_image, pd1.phrase shop_title, ss.time_from, ss.time_to, s.time_shift shop_time_shift'.
            ' FROM '.$this->sTable.' AS '.$this->sAlias.
            ' LEFT JOIN account a USING(account_id)'.
            ' LEFT JOIN account a2 ON a2.account_id=p.seller_id'.
            ' LEFT JOIN image i ON i.image_id=a2.image_id'.
            ' LEFT JOIN image i2 ON i2.image_id=a.image_id'.
            ' LEFT JOIN currency c ON c.currency_id='.$this->sAlias.'.currency_id '.
            ' LEFT JOIN shop_slot ss ON ss.shop_slot_id=p.shop_slot_id'.
            ' LEFT JOIN shop s ON s.shop_id=ss.shop_id'.
            ' LEFT JOIN phrase p1 ON p1.object_id=s.shop_id AND p1.object_type_id=4   AND p1.object_field="title" '.
            ' LEFT JOIN phrase_det pd1 ON pd1.phrase_id=p1.phrase_id AND pd1.language_id='.$nLangId.'  '.
            '  WHERE '.$this->_parseCond($aCond, $this->aFields);
        $this->aData = $this->oDb->getRow($sSql);
        return sizeof($this->aData);
    }

    function getAmount($aPurchase, $fIncome=10) {
        return round($aPurchase['price']
                +$aPurchase['price']*$fIncome/100
                -$aPurchase['price']*$aPurchase['vat']/100
                +$aPurchase['delivery'], 2);
    }
}
?>