<?php
/** ============================================================
 * Class ShopSlot.
 * 
 * @author Rudenko S.
 * @package
 * ============================================================ */
require_once 'classes/utils/dbitem.class.php';

class ShopSlot extends DbItem
{

    function ShopSlot()
    {
        parent::DbItem();
        $this->_initTable('shop_slot');
    }

    function findSeller($nTimeOffset) {
        return $this->oDb->getField('SELECT seller_id
            FROM shop_slot ss
            WHERE ss.status="free" AND ss.time_from="'.Database::date($nTimeOffset).'" LIMIT 1');
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
            ' LEFT JOIN account a2 ON a2.account_id=ss.seller_id'.
            ' WHERE '.$sCond;
        $iCnt = $this->oDb->getField($sSql);
        $aRows = array();
        if ($iCnt)
        {
            $iOffset = $this->_getOffset($iPage, $iPageSize, $iCnt);
            $sSql = 'SELECT '.$this->_joinFields($aMap, $aFields).', a.fname, a.email, a2.fname seller, a2.email seller_email, i.name image, i2.name seller_image'.
                ', p.price, c.sign'.
                ' FROM '.$this->sTable.' AS '.$this->sAlias.
                ' LEFT JOIN account a USING(account_id)'.
                ' LEFT JOIN image i ON a.image_id=i.image_id'.
                ' LEFT JOIN account a2 ON a2.account_id=ss.seller_id'.
                ' LEFT JOIN image i2 ON a2.image_id=i2.image_id'.
                ' LEFT JOIN purchase p ON p.shop_slot_id='.$this->sAlias.'.shop_slot_id'.
                ' LEFT JOIN currency c ON c.currency_id=p.currency_id '.
                ' WHERE '.$sCond.
                ($sSort?(' ORDER BY '.$sSort):'').
                ($iPageSize?(' LIMIT '.$iOffset.','.$iPageSize):'');
            $aRows = $this->oDb->getRows($sSql);
        }
        return array($aRows, $iCnt);
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
            ' LEFT JOIN account a USING(account_id)'.
            ' LEFT JOIN account a2 ON a2.account_id=ss.seller_id'.
            ' WHERE '.$sCond;
        $iCnt = $this->oDb->getField($sSql);
        $aRows = array();
        if ($iCnt)
        {
            $sSql = 'SELECT '.$this->_joinFields($aMap, $aFields).', a.fname, a.email, a2.fname seller, a2.email seller_email'.
                ' FROM '.$this->sTable.' AS '.$this->sAlias.
                ' LEFT JOIN account a USING(account_id)'.
                ' LEFT JOIN account a2 ON a2.account_id=ss.seller_id'.
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
            ' LEFT JOIN account a2 ON a2.account_id=ss.seller_id'.
            '  WHERE '.$this->_parseCond($aCond, $this->aFields);
        $this->aData = $this->oDb->getRow($sSql);
        return sizeof($this->aData);
    }


    /** Loads info from DB by PK
     * @param int $nId PK
     * @return boolean 1 - loaded, false - not found
     */
    function load($nId)
    {
        $sSql = 'SELECT '.join(',', $this->aFields).', t.time_shift'.
            ' FROM '.$this->sTable.' AS '.$this->sAlias.
            ' LEFT JOIN shop s ON s.shop_id=ss.shop_id'.
            ' LEFT JOIN timezone t ON s.timezone_id=t.timezone_id'.
            ' WHERE '.$this->sId.'="'.$nId.'"';
        $this->aData = $this->oDb->getRow($sSql);
        return sizeof($this->aData);
    }
}
?>