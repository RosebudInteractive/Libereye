<?php
/** ============================================================
 * Class Brand.
 * 
 * @author Rudenko S.
 * @package
 * ============================================================ */
require_once 'classes/utils/dbitem.class.php';

class Ptype2group extends DbItem
{

    function Ptype2group()
    {
        parent::DbItem();
        $this->_initTable('ptype2group');
    }


}
?>