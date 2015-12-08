<?php
/** ============================================================
 * Class .
 * @author Rudenko S.
 * @package
 * ============================================================ */
require_once 'classes/account.class.php';

class Admin extends Account
{

    /**
     * Constructor
     *
     */
    function Admin()
    {
        parent::Account();
        $this->sUserType = 'admin';        
    }
    
    /**
     * Verify unique login
     *
     * @return bool
     */
    function isUnique($nId)
    {
        if (!$this->oDb->getField('SELECT COUNT(*) FROM '.conf::getT('account').' WHERE email = "'.$this->aData['email'].'" AND account_id <> "'.$nId.'"'))
            return true;
        else 
            return $this->_addError('admin.exist');
    }
    
    /** Performs insert.
    * @return int new item ID or false on error
    */
    function insert($bEscape=true)
    {
        $this->_filterData();
        $this->aData['cdate'] = $this->oDb->date();
        $this->aData['pass'] = md5($this->aData['pass']);                       
        
        $iId = $this->oDb->insert($this->sTable, $this->aData, $bEscape);
        if (!$iId)
            return $this->_addError('dbitem.insert');

        return $iId;
    }
    
    

}
?>