<?php
/** ============================================================
 * Class Shop2brand.
 * 
 * @author Rudenko S.
 * @package
 * ============================================================ */
require_once 'classes/utils/dbitem.class.php';

class Shop2brand extends DbItem
{

    function Shop2brand()
    {
        parent::DbItem();
        $this->_initTable('shop2brand');
    }



    
}
?>