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
    }


}
?>