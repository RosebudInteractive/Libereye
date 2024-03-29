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

    function getDefLanguage() {
        return $this->oDb->getField('select language_id from language where is_default=1 limit 1');
    }

}
?>