<?php
/** ============================================================
 * Class Setting.
 * 
 * @author Rudenko S.
 * @package
 * ============================================================ */
require_once 'classes/utils/dbitem.class.php';

class Setting extends DbItem
{

    function Setting()
    {
        parent::DbItem();
        $this->_initTable('setting');
        $this->nObjectType = 0;
    }



    
}
?>