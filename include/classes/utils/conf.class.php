<?php
/** ============================================================
 * Class for accessing constants and formatting messages.
 * @package core
 * ============================================================ */

class Conf
{
    /** Gets value of configuration parameter
     * @param string $sName parameter name
     * @param string $sKey  key for array values
     * @return mixed parameter value: string or array
     */
    static function get($sName, $sKey = '')
    {
        global $_CONF;
        return ($sKey ? $_CONF[$sName][$sKey] : $_CONF[$sName]);
    }

    /** Return URL for given logical URL name.
     * @param string $sName URL name
     * @return string URL
     */
    static function getUrl($sName)
    {
        global $_URL;
        $sUrl = '';

        if (isset($_URL[$sName]))
            $sUrl = $_URL[$sName];
        else
        {
            $aParts = explode('.',$sName);
            $sUrl = Conf::get('url').'/';

            if (isset($aParts[0]) && $aParts[0])
                $sUrl .= $aParts[0].'/';

            if (isset($aParts[1]) && $aParts[1])
                $sUrl .= 'index.php/part_'.$aParts[1].'/';

            if (isset($aParts[2]) && $aParts[2])
                $sUrl .= 'sect_'.$aParts[2].'/';
        }
        return $sUrl;
    }

    /** Returns system setting stored in DB (performs caching)
     * @param string $sKey setting key
     * @return mixed setting value
     */
    static function getSetting($sKey)
    {
        static $aSett = array();
        if (! array_key_exists($sKey, $aSett)) //not found in cache
        {
            $oDb = &Database::get();
            $aSett[$sKey] = $oDb->getField('SELECT val FROM '.conf::getT('setting').' WHERE code="'.$sKey.'"');
        }
        return $aSett[$sKey];
    }

    /** Returns formatted mesage
     * @param string $sKey message key
     * @param array  $aParam array of message parameters
     * @return string formateed message
     */
    static function format($sKey, $aParam=array())
    {
        global $_MSG;
        if (!isset($_MSG[$sKey]))
            return $sKey;
        return vsprintf($_MSG[$sKey], $aParam);
    }

    /** Returns message by language
     * @param string $sName parameter name
     * @param string $sKey  key for array values
     * @return mixed parameter value: string or array
     */
    static function getTranslate($sName, $sKey = '')
    {
        global $_MSG;
        return ($sKey!=='' ? $_MSG[LANGUAGE][$sName][$sKey] : $_MSG[LANGUAGE][$sName]);
    }

    /** Returns messages (or subset of messages)
     * @param string $sStartWith if not empty - return only messages
     *                           start with given string
     * @return array messages ($key => $message)
     */
    static function getMessages($sStartWith='')
    {
        global $_MSG;
        if ($sStartWith)
        {
            $aRes = array();
            foreach($_MSG as $k=>$v)
            {
                if (strpos($k, $sStartWith)===0)
                    $aRes[$k] = $v;
            }
            return $aRes;
        }

        return $_MSG;
    }

    /** Returns hash of id => message
     * @param string $sKey message code ( in settings and messages). must be equal
     * @return array
     */
    static function getValues($sKey)
    {
        $aHash = Conf::get($sKey);
        $aRes = array();
        foreach ($aHash as $k=>$v)
            $aRes[$v] = Conf::format($sKey.'.'.$k);
        return $aRes;
    }

    /** Returns table name.
     * @param string $sTable table code
     * @return string real table name
     */
    static function getT($sTable)
    {
        global $_TBL;
        return $_TBL[$sTable][0];
    }

    /** Returns full table info as array.
     * @param string $sTable table code
     * @return array info on table (0 - real name, 1 - alias, 2 - PK)
     */
    static function getTi($sTable) {
        global $_TBL;
        return $_TBL[$sTable];
    }

    /** Does given message present in messages array.
     * @param string $sKey message key
     * @return bool true -- mesage present, false -- otherwise
     */
    static function hasMes($sKey)
    {
        global $_MSG;
        return array_key_exists($sKey,$_MSG);
    }

    /** Load class
     * @param string $sClass class file name (without '.class.php' suffix)
     * @param string[optional] $sClass2
     */
    static function loadClass($sClass)
    {
        $aArgs = func_get_args();
        foreach($aArgs as $sClass)
        {
            $sClass = 'classes/'.strtolower(preg_replace('/([A-Z]{1})/','_$1',$sClass)).'.class.php';
            $sClass = str_replace('/_','/',$sClass);
            require_once $sClass;
        }
    }

}

?>