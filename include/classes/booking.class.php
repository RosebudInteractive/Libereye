<?php
/** ============================================================
 * Class Booking.
 * 
 * @author Rudenko S.
 * @package
 * ============================================================ */
require_once 'classes/utils/dbitem.class.php';

class Booking extends DbItem
{

    function Booking()
    {
        parent::DbItem();
        $this->_initTable('booking');
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
        ' LEFT JOIN account a USING(account_id)'.
        ' LEFT JOIN account a2 ON a2.account_id=b.seller_id'.
        ' LEFT JOIN shop_slot ss ON ss.shop_slot_id=b.shop_slot_id'.
        ' WHERE '.$sCond;
        $iCnt = $this->oDb->getField($sSql);
        $aRows = array();
        if ($iCnt)
        {
            $iOffset = $this->_getOffset($iPage, $iPageSize, $iCnt);
            $sSql = 'SELECT '.$this->_joinFields($aMap, $aFields).', a.fname, a.email, a2.fname seller, a2.email seller_email, ss.time_from, ss.time_to'.
                    ' FROM '.$this->sTable.' AS '.$this->sAlias.
                    ' LEFT JOIN account a USING(account_id)'.
                    ' LEFT JOIN account a2 ON a2.account_id=b.seller_id'.
                    ' LEFT JOIN shop_slot ss ON ss.shop_slot_id=b.shop_slot_id'.
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
    function loadBy($aCond)
    {
        $sSql = 'SELECT '.$this->_joinFields($this->aFields).', a.fname, a.email, a2.fname seller, a2.email seller_email'.
            ' FROM '.$this->sTable.' AS '.$this->sAlias.
            ' LEFT JOIN account a USING(account_id)'.
            ' LEFT JOIN account a2 ON a2.account_id=b.seller_id'.
            '  WHERE '.$this->_parseCond($aCond, $this->aFields);
        $this->aData = $this->oDb->getRow($sSql);
        return sizeof($this->aData);
    }

    
}
?>