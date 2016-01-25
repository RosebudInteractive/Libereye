<?php
/** ============================================================
 * Class PhraseDet.
 * 
 * @author Rudenko S.
 * @package
 * ============================================================ */
require_once 'classes/utils/dbitem.class.php';

class PhraseDet extends DbItem
{

    function PhraseDet()
    {
        parent::DbItem();
        $this->_initTable('phrase_det');
    }

}
?>