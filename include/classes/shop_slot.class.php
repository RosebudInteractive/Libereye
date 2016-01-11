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
            FROM booking b
            LEFT JOIN shop_slot ss USING(shop_slot_id)
            WHERE b.status="free" AND ss.time_from="'.Database::date($nTimeOffset).'" LIMIT 1');
    }
}
?>