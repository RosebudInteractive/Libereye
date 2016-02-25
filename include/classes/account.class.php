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
        $this->sUserType = 'account';
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
    function login($sLogin, $sPassword, $aStatuses=array(), $sRegisterType='common', $sRegisterId=0, $bRemember=false, $bPassMd5=false)
    {
        if ($sRegisterType == 'common') {
            $sSql = 'SELECT account_id, pass, status ' .
                '  FROM ' . $this->sTable .
                '  WHERE ' . $this->sLoginField . '="' . Database::escape($sLogin) . '" AND is_active=1';
            $aRow = $this->oDb->getRow($sSql);
            if ($aRow) //user account exists
            {
                //check password
                if(!$bPassMd5) {
                    $sPassword = md5($sPassword);
                }

                //check password
                if ($aRow['pass'] != $sPassword)
                    $this->_addError('login.pass');

                //check status if needed
                if ($aStatuses && !in_array($aRow['status'], $aStatuses))
                    $this->_addError('login.status');

                if (!$this->aErrors) {
                    if ($this->_loginAddCheck($aRow['account_id'])) {
                        $_SESSION[$this->sUserType]['id'] = $aRow['account_id'];
                        if ($bRemember)
                        {
                            setcookie('username', $sLogin, time()+60*60*24*365, '/');
                            setcookie('password', $sPassword, time()+60*60*24*365, '/');
                        }
                        else
                        {
                            setcookie('username', '', time()-3600*24, '/');
                            setcookie('password', '', time()-3600*24, '/');
                        }
                        $this->oDb->update($this->sTable, array('last_login' => $this->oDb->date()), 'account_id=' . $aRow['account_id']);
                    }
                }
            } else
                $this->_addError('login.error');
        } else {
            $sSql = 'SELECT account_id, pass, status ' .
                '  FROM ' . $this->sTable .
                '  WHERE register_type = "' . Database::escape($sRegisterType) . '" AND register_id = "' . Database::escape($sRegisterId) . '"';
            $aRow = $this->oDb->getRow($sSql);

            if ($sLogin && !$aRow) { // by login
                $sSql = 'SELECT account_id, pass, status ' .
                    '  FROM ' . $this->sTable .
                    '  WHERE ' . $this->sLoginField . '="' . Database::escape($sLogin) . '" AND is_active=1';
                $aRow = $this->oDb->getRow($sSql);
            }

            if ($aRow) //user account exists
            {
                //check status if needed
                if ($aStatuses && !in_array($aRow['status'], $aStatuses))
                    $this->_addError('login.status');

                if (!$this->aErrors) {
                    if ($this->_loginAddCheck($aRow['account_id'])) {
                        $_SESSION[$this->sUserType]['id'] = $aRow['account_id'];
                        $this->oDb->update($this->sTable, array('last_login' => $this->oDb->date()), 'account_id=' . $aRow['account_id']);
                    }
                }
            } else
                $this->_addError('login.error');
        }

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
        setcookie('username', '', time()-3600*24, '/');
        setcookie('password', '', time()-3600*24, '/');
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

    /**
     * Verify unique id
     *
     * @return bool
     */
    function isUniqueRegID($sRegType, $nRegId, $nId=0)
    {
        $nId = intval($nId);
        if (!$this->oDb->getField('SELECT COUNT(*) FROM '.conf::getT('account').' WHERE register_type = "'.Database::escape($sRegType).'" AND register_id = "'.Database::escape($nRegId).'" AND account_id <> "'.$nId.'"', false))
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

    /** Loads info from DB by PK
     * @param int $nId PK
     * @return boolean 1 - loaded, false - not found
     */
    function load($nId)
    {
        $sSql = 'SELECT '.join(',', $this->aFields).', t.code timezone, i.name image'.
            ' FROM '.$this->sTable.' AS '.$this->sAlias.
            ' LEFT JOIN timezone t ON '.$this->sAlias.'.timezone_id=t.timezone_id'.
            ' LEFT JOIN image i ON i.image_id=acc.image_id'.
            ' WHERE '.$this->sId.'="'.$nId.'"';
        $this->aData = $this->oDb->getRow($sSql);
        return sizeof($this->aData);
    }


    /** Select from DB list of records.
     * @param array $aCond      conditions like array('name'=>'LIKE "zz%"', 'price'=>'<12') (usually prepared by Filter class)
     * @param int   $iOffset    page number (may be corrected)
     * @param int   $iPageSize  page size (row per page)
     * @param string $sSort     'order by' statement (usually prepared by Sorder class)
     * @return array ($aRows, $iCnt)
     */
    function getList($aCond=array(), $iPage=0, $iPageSize=0, $sSort='', $aFields=array())
    {
        $aMap = $this->aFields;

        $sCond = $this->_parseCond($aCond, $aMap);
        $sSql = 'SELECT COUNT(*) FROM `'.$this->sTable.'` AS '.$this->sAlias.' WHERE '.$sCond;
        $iCnt = $this->oDb->getField($sSql);
        $aRows = array();
        if ($iCnt)
        {
            $iOffset = $this->_getOffset($iPage, $iPageSize, $iCnt);
            $sSql = 'SELECT '.$this->_joinFields($aMap, $aFields).', i.name image'.
                ' FROM '.$this->sTable.' AS '.$this->sAlias.
                ' LEFT JOIN image i ON i.image_id=acc.image_id'.
                ' WHERE '.$sCond.
                ($sSort?(' ORDER BY '.$sSort):'').
                ($iPageSize?(' LIMIT '.$iOffset.','.$iPageSize):'');
            $aRows = $this->oDb->getRows($sSql);
        }
        return array($aRows, $iCnt);
    }



    /** Select from DB list of records.
     * @param array $aCond      conditions like array('name'=>'LIKE "zz%"', 'price'=>'<12') (usually prepared by Filter class)
     * @param int   $iOffset    page number (may be corrected)
     * @param int   $iPageSize  page size (row per page)
     * @param string $sSort     'order by' statement (usually prepared by Sorder class)
     * @return array ($aRows, $iCnt)
     */
    function getListOffset($aCond=array(), $iOffset=0, $iPageSize=0, $sSort='', $aFields=array(), $nLangId=0)
    {
        $nLangId = $nLangId? $nLangId: LANGUAGEID;
        $aMap = $this->aFields;
        $sCond = $this->_parseCond($aCond, $aMap);
        $sSql = 'SELECT COUNT(*) FROM `'.$this->sTable.'` AS '.$this->sAlias.
            ' WHERE '.$sCond;
        $iCnt = $this->oDb->getField($sSql);
        $aRows = array();
        if ($iCnt)
        {
           $sSql = 'SELECT '.$this->_joinFields($aMap, $aFields).
                ', (SELECT name FROM image i WHERE i.object_id='.$this->sAlias.'.account_id AND i.object_type="account" ORDER BY image_id DESC LIMIT 1) image'.
                ' FROM '.$this->sTable.' AS '.$this->sAlias.
               ' WHERE '.$sCond.
                ($sSort?(' ORDER BY '.$sSort):'').
                ($iPageSize?(' LIMIT '.$iOffset.','.$iPageSize):'');
            $aRows = $this->oDb->getRows($sSql);
        }
        return array($aRows, $iCnt);
    }
}
?>