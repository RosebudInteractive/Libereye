<?php

require_once 'classes/utils/dbitem.class.php';

class Subscribe extends DbItem
{

    var $aFields = array(
        'subscribe_id',   //
        'email',   // 
        'fname',   //
        'cdate',   //
    );

    function Subscribe()
    {
        parent::DbItem();
        $this->_initTable('subscribe');
    }

    /**
     * Verify unique email
     *
     * @return bool
     */
    function isUniqueEmail($nId=0)
    {
        if (!$this->oDb->getField('SELECT COUNT(*) FROM '.conf::getT('subscribe').' WHERE email = "'.$this->aData['email'].'" AND subscribe_id <> "'.$nId.'"'))
            return true;
        else 
            return false;
    }    

}
?>