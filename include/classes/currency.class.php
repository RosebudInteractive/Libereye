<?php
/** ============================================================
 * Class Currency.
 * 
 * @author Rudenko S.
 * @package
 * ============================================================ */
require_once 'classes/utils/dbitem.class.php';

class Currency extends DbItem
{

    function Currency()
    {
        parent::DbItem();
        $this->_initTable('currency');
        $this->nObjectType = 0;
    }



    
}
?>