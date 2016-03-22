<?php
/** ============================================================
 * Class Price.
 * 
 * @author Rudenko S.
 * @package
 * ============================================================ */
require_once 'classes/utils/dbitem.class.php';

class Price extends DbItem
{

    function Price()
    {
        parent::DbItem();
        $this->_initTable('price');
    }

    
}
?>