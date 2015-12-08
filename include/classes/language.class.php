<?php
/** ============================================================
 * Class Purchase.
 * 
 * @author Rudenko S.
 * @package
 * ============================================================ */
require_once 'classes/utils/dbitem.class.php';

class Language extends DbItem
{

    function Language()
    {
        parent::DbItem();
        $this->_initTable('language');
    }

}
?>