<?php
/** ============================================================
 * Class Box.
 * 
 * @author Rudenko S.
 * @package
 * ============================================================ */
require_once 'classes/utils/dbitem.class.php';

class RegionRate extends DbItem
{

    function RegionRate()
    {
        parent::DbItem();
        $this->_initTable('region_rate');
        $this->nObjectType = null;
    }

    
}
?>