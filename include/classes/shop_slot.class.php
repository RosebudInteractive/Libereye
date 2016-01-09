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

}
?>