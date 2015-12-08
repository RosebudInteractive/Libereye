<?php
/** ============================================================
 * Class Member. Base class for all roles in system.
 * Fields:
 *  - 'account_id' -- 
 *  - 'email'      -- 
 *  - 'pass'       --
 *  - 'fname'      --
 *  - 'lname'      --
 *  - 'addr'       --
 *  - 'city'       --
 *  - 'state'      --
 *  - 'zip'        --
 *  - 'country'    --
 *  - 'phone'      -- 
 *  - 'status'     -- 
 * 
 * @author Rudenko S.
 * @package
 * ============================================================ */
require_once 'classes/utils/dbitem.class.php';

class Account extends DbItem
{

    var $aFields = array(
        'account_id',   // 
        'email',   // 
        'pass',   // 
        'fname',   // 
        'lname',   // 
        'status',   // 
    );

    /** @var string user type
     */
    var  $sUserType;

    /** Permissions array.
     * @var array
     */
    var $aPerms;

    /** Login fields
     * @var string
     */
    var $sLoginField = 'email';

    function Account()
    {
        parent::DbItem();
        $this->_initTable('account');
        $this->sUserType = 'admin';
    }



    /** Try user login: check login,
     *  set new login session variables: login flag (user ID).
     *  Attention! Do not override this method - if you need some
     *  additional checks -- override method _loginAddCheck().
     * @param string $sLogin    user login
     * @param string $sPassword user password
     * @param string $aStatuses statuses eligeble to login
     * @return bool true - login ok, false - error
     * @see _loginAddCheck()
     */
    function login($sLogin, $sPassword, $aStatuses=array())
    {
        
        $sSql = 'SELECT account_id, pass, status '.
                '  FROM '.$this->sTable.
                '  WHERE '.$this->sLoginField.'="'.$sLogin.'"';
        $aRow = $this->oDb->getRow($sSql);
        if ($aRow) //user account exists
        {
            //check password
            $sPassword = md5($sPassword); 
            if ($aRow['pass'] != $sPassword)
                $this->_addError('login.pass');

            //check status if needed
            if ($aStatuses && !in_array($aRow['status'], $aStatuses))
                    $this->_addError('login.status');

            if (!$this->aErrors) {
                if ($this->_loginAddCheck($aRow['account_id']))
                {
                    $_SESSION[$this->sUserType]['id'] = $aRow['account_id'];
                    $this->oDb->update($this->sTable, array('last_login'=>$this->oDb->date()), 'account_id='.$aRow['account_id']);
                }
            }
        }
        else
            $this->_addError('login.error');

        return !$this->aErrors;
    }


    /** Additional checks for login -- override this method to
     *  perform additional checks.
     * @return bool true - additional checks succesfully passed
     *              false - checks failed.
     * @see login()
     */
    function _loginAddCheck()
    {
        return true;
    }

    /** Check is user logged on (by session or autologin cookie)
     * @return int account id or 0 - if not logged in
     */
    function isLoggedIn()
    {
        $iAccountId = 0;
        if (isset($_SESSION[$this->sUserType]['id']))
            $iAccountId = $_SESSION[$this->sUserType]['id'];            
        return $iAccountId;
    }

    /** Do logout: clear session variable.
     */
    function logout()
    {
        unset($_SESSION[$this->sUserType]);
    }
    
    /**
     * Verify unique email
     *
     * @return bool
     */
    function isUniqueEmail($nId=0)
    {
        if (!$this->oDb->getField('SELECT COUNT(*) FROM '.conf::getT('account').' WHERE email = "'.$this->aData['email'].'" AND account_id <> "'.$nId.'"', false))
            return true;
        else 
            return false;
    }    


    function hasPerms($mPerms)
    {
        /* ---- reference implementation of permission checks ----
        if (! is_array($mPerms))
            $mPerms = array($mPerms); //pack in array if single string
        foreach ($mPerms as $sPerm)
        } //iterate through
            foreach ($this->aPerms as $aPerm)
                    if ($sPerm == $aPerm)
                       return true;
        {

        return false; //no permissions found
        */

        return true;
    }
    
    
    function genPass($nChar=8)
    {
    	$sSymbols = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    	$sPass = '';
    	for ($i=0;$i<$nChar;$i++)
    	 $sPass .= $sSymbols{rand(0, strlen($sSymbols)-1)};
    	return $sPass;
    }
}
?>