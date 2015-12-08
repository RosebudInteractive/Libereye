<?php
/** ============================================================
 * URL wrapper class
 * @package core
 * ============================================================ */

class Url
{
    /** The scheme(protocol) of the url, e.g. <code>http://</code>
     * @var string
     */
    var $sProtocol='http';

    /** Allowed protocols
     * @var array
     */
    var $_aProtocols = array('http', 'https', 'ftp');

    /** The host of the url, e.g. <code>www.example.com</code>
     * @var string
     */
    var $sHost='';

    /** The dirs of the url, e.g. <code>dir1/dir2/</code>
     * @var string
     */
    var $sDirs='';

    /** The file of the url, e.g. <code>script.php</code>
     * @var string
     */
    var $sFile='';

    /** The parameters of the url (from 'PATH_INFO')
     * e.g <code>a_1/b_2</code>
     * @var array
     */
    var $aParams=array();

    /** The fragment of the url
     * e.g <code>top</code>
     * @var array
     */
    var $sFragment='';


    /** The internal URL represtation (cache)
     * e.g <code>http://www.example.com/dir1/dir2/script.php/a_1/b_2/#top</code>
     * @var string
     */
    var $sUrl='';

    /** Internal flag to check if the cache was changed
     * @var boolean
     */
    var $bChanged=true;

    /** SEO: source url regexp (unmodified url pattern)
     *       ex. '!^(.+)/visitor/index.php/part_([a-z_]+)/sect_([a-z_]+)(.+)$!'
     * @var string regexp
     * @see $sSeoTrg
     */
    var $sSeoSrc = '';

    /** SEO: target url (modified url)
     *       ex. '$1/$2/$3/index$4.html'
     * @var unknown_type
     * @see $sSeoSrc
     */
    var $sSeoTrg = '';



    /** Constructs a new Url object.
     * @param string $sUrl    the optional URL (a string) to base the Url on
     * @param string $sParams the optional URL (a string) with parameters only
     */
    function Url($sUrl = '', $sParams = '')
    {
        $this->makeFromCurrent();
    }

    /** Parses parameters in a <code>key1_value1/key2_value2/...</code> string
     * @param string $sParams the URL-encoded string with the parameters
     * @return void
     * @access private
     */
    function _parseParams($sParams)
    {
        $this->aParams = array();
        $aList = explode('/', trim($sParams,'/ '));
        for ($i = 0, $n=count($aList); $i < $n; ++$i)
        {
            $aPair = explode('_', $aList[$i], 2);
            if (isset($aPair[1]))
                $this->aParams[$aPair[0]] = urldecode($aPair[1]);
        }
        $this->bChanged = true;
    }

    /** Parses url from the string
     * @param string $sUrl url to parse
     * @return void
     * @access private
     */
    function _parseUrl($sUrl)
    {
        // parse_url generate warning if URL contains more than 1 ':'
        if ($n = strpos($sUrl, ':', 7))
            $sUrl = substr($sUrl, 0, $n);
        $aInfo = parse_url($sUrl);

        // clear previous state
        $this->setDirs('');
        $this->setFile('');
        $this->clearParams();
        $this->setFragment('');

        if (array_key_exists('scheme', $aInfo))
            $this->setProtocol($aInfo['scheme']);

        if (array_key_exists('host', $aInfo))
            $this->setHost($aInfo['host']);

        if (array_key_exists('path', $aInfo))
        {
            if (strpos($aInfo['path'], '.'))
            {
                if (preg_match('!^(.*?)/([^/]+\.[^/]+)(.*)$!', $aInfo['path'], $aM))
                {
                    $this->setDirs($aM[1]);
                    $this->setFile($aM[2]);
                    $this->_parseParams($aM[3]);
                }
            }
            else
                $this->setDirs($aInfo['path']);
        }

        if (array_key_exists('fragment', $aInfo))
            $this->setFragment($aInfo['fragment']);
    }

    /** Set a new value to the Url
     * @param string $sUrl    the URL (a string) to base this Url on
     * @param string $sParams the optional string of parameters (URL-encoded)
     * @return void
     */
    function setUrl($sUrl, $sParams = '')
    {
        // Reset the current URL
        $this->aParams = array();

        // Create the new URL
        $this->_parseParams($sParams);
        $this->_parseUrl($sUrl);
    }

    /** Set the Url to the URL of the current page;
     * @return void
     */
    function makeFromCurrent()
    {
        //$this->_parseUrl($_SERVER['PHP_SELF'] );
        $this->_parseUrl($_SERVER['PHP_SELF'].(isset($_SERVER['ORIG_PATH_INFO'])?$_SERVER['ORIG_PATH_INFO']:'') );
        $this->setProtocol(isset($_SERVER['HTTPS']) ? 'https' : 'http');
        $this->setHost(Conf::get('host'));
    }

    /** Retruns protocol
     * @return string scheme of the url
     */
    function getProtocol()
    {
        return $this->sProtocol;
    }

    /** Set protocol.
     * @param string $sProtocol new protocol: 'https' or 'https'
     * @return void
     */
    function setProtocol($sProtocol)
    {
        if (in_array($sProtocol, $this->_aProtocols))
        {
            $this->sProtocol = $sProtocol;
            $this->bChanged = true;
        }
    }

    /** Sets the host for the Url
     * @param string $sHost
     * @return void
     */
    function setHost($sHost)
    {
        $this->sHost = trim($sHost,'/ ');
        $this->bChanged = true;
    }

    /** Returns host of the url
     * @return string host
     */
    function getHost()
    {
        return $this->sHost;
    }

    /** Returns dirs of the url
     * @return strung dirs
     */
    function getDirs()
    {
        return $this->sDirs;
    }

    /** Sets the dirs for the Url
     * @param string $sDirs
     * @return void
     */
    function setDirs($sDirs)
    {
        $sDirs = trim($sDirs, '/ ');
        $this->sDirs = $sDirs;
        if ($sDirs)
            $this->sDirs .= '/';
        $this->bChanged = true;
    }

    /** Returns dirs of the url
     * @return string file name
     */
    function getFile()
    {
        return $this->sFile;
    }

    /** Sets the file for the Url
     * @param string $sFile
     * @return void
     */
    function setFile($sFile)
    {
        $this->sFile = trim($sFile, '/ ');
        $this->bChanged = true;
    }

    /** Updates the value of a parameter
     * @param string $sName  the name of the parameter to update
     * @param string $sValue the new value of the parameter or null if the parameter should be deleted
     * @return void
     */
    function setParam($sName, $sValue = null)
    {
        if (null === $sValue)
            unset($this->aParams[$sName]);
        else
            $this->aParams[$sName] = $sValue;

        $this->bChanged = true;
    }

    /** Updates the value of  parameters
     * @param array $aParams parameters to update (name=>value)
     * @return void
     */
    function setParams($aParams)
    {
        foreach($aParams as $sName=>$sValue)
            $this->setParam($sName,$sValue);
    }

    /** Returns all parameters
     * @return array all url parameters ($key=>$value)
     */
    function getParams()
    {
        return $this->aParams;
    }

    /** Gets the value of the specified Url parameter
     * @param string $sName parameter name
     * @param string $sDefault default name
     * @return string
     */
    function getParam($sName, $sDefault = '')
    {
        if (array_key_exists($sName, $this->aParams))
            return $this->aParams[$sName];
        return $sDefault;
    }


    /** Checks whether a specific parameter exists in this Url
     * @return boolean
     */
    function hasParam($sName)
    {
        return isset($this->aParams[$sName]);
    }

    /** Clears all params or a single parameter
     * @param string $sName  the name of the parameter to clear.
     * @return void
     */
    function clearParams($sName='')
    {
        if ($sName)
            unset($this->aParams[$sName]);
        else
            $this->aParams = array();

        $this->bChanged = true;
    }


    /** Returns a fragment of the url
     * @return string fragment
     */
    function getFragment()
    {
        return $this->sFragment;
    }

    /** Sets the fragment of the Url
     * @param string $sFragment
     * @return void
     */
    function setFragment($sFragment)
    {
        $this->sFragment = $sFragment;
        $this->bChanged = true;
    }

    /** Returns a string representation of the URL
     * @return string
     */
    function getUrl()
    {
        $sUrl = $this->sUrl;

        if ($this->bChanged)
        {
            $sUrl = $this->getProtocol().'://'.$this->getHost().'/'.$this->getDirs().$this->getFile();
            $aParams = array();
            foreach ($this->aParams as $sName => $sValue)
            {
                if (!empty($sName)) {
                    $aParams[] = $sName . '_' . urlencode($sValue);
                }
            }
            if (sizeof($aParams))
                $sUrl .= '/' . join('/', $aParams);
            if ($this->getFragment())
                $sUrl .= '/#'.urlencode($this->getFragment());

            $this->sUrl = $sUrl;
            $this->bChanged = false;
        }

        //tweak url if seo options not empty
        if ($this->sSeoSrc && $this->sSeoTrg)
            $sUrl = preg_replace($this->sSeoSrc, $this->sSeoTrg, $sUrl);

        return $sUrl;
    }
    
    
      
 	/**
     * Translite Russian to English
     * @param  string $sStr string for alias generating
     * @return string alias
     */
    function translit($sStr, $bLower=true)
    {    
        $aTransRu = array('а','б','в','г','д','е','з','и','к','л','м','н','о','п','р','с', 'т','у','ф','ё','ж', 'й','х','ц', 'ч', 'ш', 'щ',  'ъ','ь','ы','э','ю', 'я',
                            'А','Б','В','Г','Д','Е','З','И','К','Л','М','Н','О','П','Р','С', 'Т','У','Ф','Ё','Ж', 'Й','Х','Ц', 'Ч', 'Ш', 'Щ',  'Ъ','Ь','Ы','Э','Ю', 'Я');                
        $aTransEng = array('a','b','v','g','d','e','z','i','k','l','m','n','o','p','r','s','t','u','f','e','zh','j','h','ts','ch','sh','sch','j','j','y','e','ju','ja',
                            'A','B','V','G','D','E','Z','I','K','L','M','N','O','P','R','S','T','U','F','E','ZH','J','H','TS','CH','SH','SCH','J','J','Y','E','JU','JA');                

        $sStr = preg_replace('/[_\s\.,?!\[\](){}\/]+/', '-', $sStr);
        $sStr = preg_replace('/-{2,}/', '-', $sStr);
        $sStr = str_replace($aTransRu, $aTransEng, $sStr);
        $sStr = preg_replace('/[^0-9a-z\-]/i', '', $sStr);
        $sStr = trim($sStr, '-');
        $sStr = implode('-', array_slice(explode('-', $sStr), 0, 4));
        if ($bLower) $sStr = strtolower($sStr);
       
        return $sStr;
    }


    /** Set parameters for SEO optimising url conversion.
     *  If no parameters given, then Url will not convert url to seo optimised.
     * @param $sSrc pattern for source url (raw url)
     * @param $sTrg target SEO-optimised url
     */
    function setSeoParams($sSrc='', $sTrg='')
    {
        $this->sSeoSrc = $sSrc;
        $this->sSeoTrg = $sTrg;
    }
}
?>