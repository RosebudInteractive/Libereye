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

    static function getTimezoneOffset($nTime, $sTimezoneOffset, $shiftSummer=false) {
        $aDatesOffset = explode(';', $sTimezoneOffset);
        $aOffsets = [];
        foreach($aDatesOffset as $sDateOffset) {
            $aDateOffset = explode(':', $sDateOffset);
            $aOffsets[$aDateOffset[0]] = intval($aDateOffset[1])*60;
        }

        $aOffsets[date('Y-m-d', $nTime)] = isset($aOffsets[date('Y-m-d', $nTime)]) ? $aOffsets[date('Y-m-d', $nTime)]: reset($aOffsets);
        if (isset($aOffsets[date('Y-m-d', $nTime)]) && $aOffsets[date('Y-m-d', $nTime)]) {
            if ($shiftSummer) {
                $this_year = gmdate("Y", $nTime);//Получаем номер года
                //Последнее воскресенье в марте указанного года в час ночи по UTC
                $last_day_of_march = gmmktime(1, 0, 0, 3, 31, $this_year);
                $last_sunday_of_march = strtotime("-" . gmdate("w", $last_day_of_march) . " day", $last_day_of_march);
                //Последнее воскресенье в октябре указанного года в час ночи по UTC
                $last_day_of_october = gmmktime(1, 0, 0, 10, 31, $this_year);
                $last_sunday_of_october = strtotime("-" . gmdate("w", $last_day_of_october) . " day", $last_day_of_october);
                if (($nTime > $last_sunday_of_march) && ($nTime < $last_sunday_of_october))
                    $aOffsets[date('Y-m-d', $nTime)] += 3600;      //поправка на час вперед
            }
            return $aOffsets[date('Y-m-d', $nTime)];
        }
        return 0;
    }

    /**
     * @param int $timestamp
     * @param int $shiftUTC minutes
     * @param bool $shiftSummer summer time
     * @return int
     */
    static function timeShift($timestamp=0, $shiftUTC=0, $shiftSummer=false)
    {
        //Если функция вызвана без указания времени, берем текущее UTC-время
        if ($timestamp==0) $timestamp=time();

        if ($shiftSummer) {
            $this_year = gmdate("Y", $timestamp);//Получаем номер года
            //Последнее воскресенье в марте указанного года в час ночи по UTC
            $last_day_of_march = gmmktime(1, 0, 0, 3, 31, $this_year);
            $last_sunday_of_march = strtotime("-" . gmdate("w", $last_day_of_march) . " day", $last_day_of_march);
            //Последнее воскресенье в октябре указанного года в час ночи по UTC
            $last_day_of_october = gmmktime(1, 0, 0, 10, 31, $this_year);
            $last_sunday_of_october = strtotime("-" . gmdate("w", $last_day_of_october) . " day", $last_day_of_october);
            if (($timestamp > $last_sunday_of_march) && ($timestamp < $last_sunday_of_october))
                $timestamp = $timestamp + 3600;      //поправка на час вперед
        }

        $timestamp = $timestamp + 60*$shiftUTC;
        return $timestamp;
    }

    /**
     * @param int $timestamp
     * @param int $shiftUTC minutes
     * @param bool $shiftSummer summer time
     * @return int
     */
    static function summerShift($timestamp, $shiftSummer=false)
    {
        $this_year = gmdate("Y", $timestamp);//Получаем номер года
        //Последнее воскресенье в марте указанного года в час ночи по UTC
        $last_day_of_march = gmmktime(1, 0, 0, 3, 31, $this_year);
        $last_sunday_of_march = strtotime("-" . gmdate("w", $last_day_of_march) . " day", $last_day_of_march);
        //Последнее воскресенье в октябре указанного года в час ночи по UTC
        $last_day_of_october = gmmktime(1, 0, 0, 10, 31, $this_year);
        $last_sunday_of_october = strtotime("-" . gmdate("w", $last_day_of_october) . " day", $last_day_of_october);
        if (($timestamp > $last_sunday_of_march) && ($timestamp < $last_sunday_of_october))
            return true;      //поправка на час вперед
        return false;
    }

    static  function getFloat($sStr) {

    }
}

?>