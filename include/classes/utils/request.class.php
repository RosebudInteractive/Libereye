<?php
/** ============================================================
 * Class <code>Request</code> is abstraction
 * of the http request with arguments.
 * @package core
 * @todo rename this class to Application
 * ============================================================ */

class Request
{
    // DATA MEMBERS

    /** Arguments of the request
     * @var array
     * @access private
     */
    var $_aArgs;

    /** Action Name
     * @var string
     * @access private
     */
    var $_sAction;


    /** Url wrapper object
     * @var string
     * @access private
     */
    var $_oUrl;

    /** Current area parts.
     * @var array
     */
    var $_aParts;

    /** Menu
     * @var array
     */
    var $_aMenu = array();
    
    /** Menu
     * @var array
     */
    var $_aSubMenu = array();
    
    /** Current area.
     * @var string
     */
    var $_sArea;

    /** Current part.
     * @var string
     */
    var $_sPart;

    /** Current section.
     * @var string
     */
    var $_sSect;


    /** Construct a new Request object.
     * @param Url $oUrl url object for curren url
     */
    function Request($oUrl)
    {
    	if (isset($_SERVER['REQUEST_URI']))
    		$_SERVER['QUERY_STRING'] .= '&'.substr($_SERVER['REQUEST_URI'], strrpos($_SERVER['REQUEST_URI'], '?')+1);
        $this->_aArgs = array_merge($_GET, $oUrl->aParams, $_POST);
        $mAction = $this->get('act');
        if (is_array($mAction))
            $mAction = array_pop(array_keys($mAction));
        $this->_sAction = $mAction;
        $this->_oUrl = $oUrl;
    }

    /** Forward to given url.
     * @param string $sLogicUrl logical URL name ('admin.login' etc.)
     * @param array  $aParams   paramters (name=>value)
     * @param mixed  $mMes      message(s) that should be displayed on target page
     * @param bool   $bErr      is error message(s)
     */
    function gotoUrl($sLogicUrl, $aParams=array(), $mMes=array(), $bErr=false)
    {
        $this->_oUrl->setUrl(Conf::getUrl($sLogicUrl));
        $this->_oUrl->setParams($aParams);
        $this->forward($this->_oUrl->getUrl(), $mMes, $bErr);
    }

    /** Forward request to new URL. ( sends header and call exit() ).
     * @param string $sUrl      absolute URL to forward
     * @param mixed  $mMes      message or array of messages
     * @param string $sLogicUrl logical url corresponding to forwarder (For store messages)
     * @return void
     */
    function forward($sUrl, $mMes=array(), $bErr=false, $sLogicUrl='')
    {
        if (!is_array($mMes) && $mMes)
            $mMes = array($mMes);

//        if ('/' == substr($sUrl, -1))
//            $sUrl = substr($sUrl, 0, -1);

        $sLogicUrl = $sLogicUrl ? $sLogicUrl : $sUrl;
        $sLogicUrl = preg_replace('@([^\:])//@', '\\1/', $sLogicUrl);        
        if ($mMes)
            $_SESSION[$sLogicUrl]['err'] = array($mMes, $bErr,  'aSessErr');
        header('Location: '.$sUrl);
        exit;
    }
 

    /** Get action name.
     * @return string action name
     */
    function getAction($sDefault='')
    {
        return ($this->_sAction ? $this->_sAction : $sDefault);
    }

    /** Retrieve parameter value from request.
     * @param string $sName name of argument
     * @param string $sDef  optional default value
     * @return string parameter value
     */
    function get($sName, $mDef='')
    {
        return (isset($this->_aArgs[$sName]) ? $this->_aArgs[$sName] : $mDef);
    }

    /** Retrieve parameter value as integer from request.
     * @param string $sName name of argument
     * @param string $iDef  optional default value
     * @return int parameter value
     */
    function getInt($sName, $iDef=0)
    {
        return intVal($this->get($sName, $iDef));
    }

    /** Retrieve parameter value as float from request.
     * @param string $sName name of argument
     * @param string $fDef  optional default value
     * @return float parameter value
     */
    function getFloat($sName, $fDef=0.0)
    {
        return floatVal($this->get($sName, $fDef));
    }

    /** Retrieve parameter value as array from request.
     * @param string $sName name of argument
     * @param string $fDef  optional default value
     * @return array parameter value
     */
    function getArray($sName, $mDef=array())
    {
        return (array)$this->get($sName, $mDef);
    }

    /**  Retrieve from request all arguments.
     * @return array
     */
    function &getAll()
    {
        return $this->_aArgs;
    }

    /** Retrieve parameter value as data (stored in string) from request.
     * @param string $sName name of argument
     * @param string $sDef  optional default value
     * @return string parameter value
     */
    function getStrDate($sName, $sDef='')
    {
        $sDate = $this->get($sName);
        $aMat=array();
        if (preg_match('/^([\d]{4})-([\d]{2})-([\d]{2})$/', $sDate, $aMat))
            $sDate = date('Y-m-d', mktime(0 ,0, 0, $aMat[2], $aMat[3], $aMat[1]));
        else
            $sDate = $sDef;

        return $sDate;
    }

    /** Retrieve parameter value as data (stored in 3 paramtere) from request.
     * @param string $sName prefix name of arguments
     * @param string $sDef  optional default value
     * @return string parameter value
     */
    function getArrDate($sName)
    {
        return sprintf('%04u-%02u-%02u', $this->get($sName.'Year'), $this->get($sName.'Month'), $this->get($sName.'Day'));
    }

    /** Returns remote ip address
     *  @return string ip address
     */
    function getIP()
    {
        $sAdr = $_SERVER["REMOTE_ADDR"];
        if (isset($_SERVER["HTTP_X_FORWARDED_FOR"]))
        {
            $nPos = strpos($sAdr, ',');
            $sAdr .= ' / ';
            if ($nPos===false)
                $sAdr .= $_SERVER["HTTP_X_FORWARDED_FOR"];
            else
                $sAdr .= substr($_SERVER["HTTP_X_FORWARDED_FOR"], 0, $nPos);
        }
        return $sAdr;
    }

    /** Goto given url with stored back parameters (page, sorting etc)
     * @param string $sLogicUrl url name
     * @param mixed  $mMes     message(s) that should be displayed on target page
     * @param bool   $bErr      is error message(s)
     * @see setBackUrl()
     */
    function gotoBackUrl($sLogicUrl, $mMes=array(), $bErr = false)
    {
        $this->forward($this->getBackUrl($sLogicUrl), $mMes, $bErr);
    }

    /** Set back url parameters for given logical url.
     * @param string $sUrlName logical URL name
     * @param Url    $oUrl     Url wrapper object
     * @see getBackUrl()
     * @see gotoBackUrl()
     */
    function setBackUrl($sUrlName)
    {
        $_SESSION['back_urls'][$sUrlName] = $this->_oUrl->getParams();
        $_SESSION['back_urls']['_last'] = $this->_oUrl->getParams();
    }

    /** Get back url with parameters for given logical url.
     * @param string $sUrlName logical url name (or empty - for last back url)
     * @return string full url with stored parameters or triggers error
     * @see setBackUrl()
     */
    function getBackUrl($sUrlName='')
    {
        if ($sUrlName) //goto selected backURL
        {
            $oUrl = $this->_oUrl->setUrl(Conf::getUrl($sUrlName));
            if (isset($_SESSION['back_urls'][$sUrlName]))
                $this->_oUrl->setParams($_SESSION['back_urls'][$sUrlName]);
            return $this->_oUrl->getUrl();
        }
        else //goto last backURL
        {
            if (isset($_SESSION['back_urls']['_last']))
                $this->_oUrl->setParams($_SESSION['back_urls']['_last']);
        }
    }

    /** Set parts for current area.
     * @param string $sArea  current area name
     * @param array  $aParts part configuration
     */
    function setAreaConfig($sArea, $aParts, $aMenu)
    {
        $this->_sArea  = $sArea;
        $this->_aParts = $aParts;
        $this->_aMenu  = $aMenu;

        $this->_sPart = $this->get('part');
        if (!$this->_sPart)
            $this->_sPart = key($this->_aParts);
        else //check part
            if (!isset($this->_aParts[$this->_sPart]))
                $this->gotoUrl($this->_sArea);

        //if matching menu -- mark as active (highlight menu)
        if (isset($this->_aMenu[$this->_sPart]))
            $this->_aMenu[$this->_sPart]['is_active'] = true;
            
        //get submenu
        isset($aMenu[$this->_sPart]['submenu']) ? $this->_aSubMenu = $aMenu[$this->_sPart]['submenu'] : array();    

        //get section
        $this->_sSect = $this->get('sect');
        if (!$this->_sSect)
            $this->_sSect = key($this->_aParts[$this->_sPart]['sections']);
        else //check section
            if (!isset($this->_aParts[$this->_sPart]['sections'][$this->_sSect]))
                $this->gotoUrl($this->_sArea);

    }

    function getSectionFile($sSuffix='php')
    {
        return $this->_sPart.'/'.$this->_sSect.'.'.$sSuffix;
    }

    function getSectionTitle()
    {
        return $this->_aParts[$this->_sPart]['title'];
    }

    function getMenu()
    {
        return $this->_aMenu;
    }
    
    function getSubMenu()
    {
        return $this->_aSubMenu;
    }
}
?>