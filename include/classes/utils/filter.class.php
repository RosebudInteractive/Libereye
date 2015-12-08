<?php
/** ============================================================
 * Class for performing filter.
 * @package core
 * ============================================================ */

class Filter {

    /** Filter name
     * @var string
     */
    var $sFilterName;

    /** WHERE-statement config.
     * @var array
     */
    var $aWhereCfg;

    /** HAVING-statement config.
     * @var array
     */
    var $aHavingCfg;


    var $aData;
    var $aFields;
    var $bIsActive;

    /** Create filter.
     * @param string $sFilterName filter name
     * @return Filter
     */
    function Filter($sFilterName='default') {
        $this->sFilterName = $sFilterName;
        $this->aData = array();
        $this->bIsActive = false;
    }

    /** Initialise filter.
     * @param array $aFieldsDefs filter fields configuration
     * @param array $aWhereCfg   where-statement configuration
     * @param array $aHavingCfg  having-statement configuration
     */
    function init($aFieldsDefs, $aWhereCfg, $aHavingCfg=array()) {
        $this->aWhereCfg  = $aWhereCfg;
        $this->aHavingCfg = $aHavingCfg;
        $this->aFields    = $aFieldsDefs;
        if (isset($_SESSION['filter'][$this->sFilterName])) {
            $this->_loadFilter(); //load (from session)
            $this->bIsActive = isset($_SESSION['filter'][$this->sFilterName]['__isActive__']);
        }
        else
            $this->_resetToDefault(); //set default values
    }

    /** Set (turn on) filter.
     * @param array $aData filter data (usually from POST)
     */
    function set($aData) {
        $this->aData = $aData;
        $this->_processData($aData);
        $this->_saveFilter();
        $this->bIsActive = true;
        $_SESSION['filter'][$this->sFilterName]['__isActive__'] = 1;
    }

    /** Reset (turn off) filter
     * @param bool $bIsClear true - deactivate filter and reset data, false - only deactivate
     */
    function reset($bIsClear=true) {
        if ( isset($_SESSION['filter'][$this->sFilterName]['__isActive__']) ) {
            unset($_SESSION['filter'][$this->sFilterName]['__isActive__']);
        }
        if ($bIsClear) {
            $this->_resetToDefault();
            if ( isset($_SESSION['filter'][$this->sFilterName]) ) {
            unset($_SESSION['filter'][$this->sFilterName]);
            }
        }
        $this->bIsActive = false;
    }

    /** Parse WHERE-statement
     * @return string where-statement (to substitute in sql statement)
     */
    function parseWhere() {
        return $this->_parse(1);
    }

    /** Parse HAVING-statement
     * @return string having-statement (to substitute in sql statement)
     */
    function parseHaving() {
        return $this->_parse(2);
    }

    function _parse($sType) {
        switch ($sType) {
            case 2:
                $aCfg = $this->aHavingCfg;
                break;
            case 1:
            default:
                $aCfg = $this->aWhereCfg;
                break;
        }

        $sCond = '1';
        if ($this->bIsActive) {//d($aCfg);d($this->aData);
            foreach($aCfg as $k=>$v) {
                if (!empty($this->aData[$k])) { //current filter part must be included
                    $sCond .= ' AND ('.$v.')';
                }
            }
            if ($sCond!='1') { //replace {{val}} with real values
                foreach($this->aData as $k=>$v) {
                    if (!is_array($v))
                    {
                        $v = Database::escape($v);
                    }
                    else {
                        foreach($v as $k1=>$v1)
                            $v[$k1] = Database::escape($v1);
                        $v = '"'.implode('","',$v).'"';
                    }
                    $sCond = str_replace('{$'.$k.'}', $v, $sCond);
                }
            }
        }
        return $sCond;
    }

    function _loadFilter() {
        $this->aData = $_SESSION['filter'][$this->sFilterName];
    }

    function _saveFilter() {
        $_SESSION['filter'][$this->sFilterName] = $this->aData;
    }

    function _processData($aData) {
        foreach ($this->aFields as $k=>$v) {
            $sSrc = isset($this->aFields[$k]['src'])?$this->aFields[$k]['src']:$k;
            switch($v['type']) {
                case 'int':
                    if (! empty($aData[$sSrc]))
                        $this->aData[$k] = intval($aData[$sSrc]);
                    break;
                case 'float':
                    if (! empty($aData[$sSrc]))
                        $this->aData[$k] = floatval($aData[$sSrc]);
                    break;
                case 'string':
                    $this->aData[$k] = $aData[$sSrc];
                    break;
                case 'date':
                case 'date_from':
                    $this->aData[$k] = $this->makeDate($aData[$sSrc.'Year'], $aData[$sSrc.'Month'], $aData[$sSrc.'Day']);
                    break;
                case 'date_to':
                    $this->aData[$k] = $this->makeDate($aData[$sSrc.'Year'], $aData[$sSrc.'Month'], $aData[$sSrc.'Day'], 23,59,59);
                    break;
                case 'array':
                    $this->aData[$k] = $aData[$sSrc];//'"'.implode('","',$aData[$sSrc]).'"';
                    break;
            }
        }
    }

    function _resetToDefault() {
        $this->aData = array();
        foreach($this->aFields as $k=>$v) {
            if (isset($v['def']))
                $this->aData[$k] = $v['def'];
        }
    }

    /** Compile filter date as string from separate calues
     * @param int $iYear  year
     * @param int $iMonth month
     * @param int $iDay   day
     * @param int $iHour  hour
     * @param int $iMin   minute
     * @param int $iSec   second
     * @return string formatted data
     */
    function makeDate($iYear, $iMonth=1, $iDay=1, $iHour=0, $iMin=0, $iSec=0) {
        /** @todo check date and get format from config*/
        $sDate = sprintf('%04d-%02d-%02d', $iYear, $iMonth, $iDay);
        $sTime = sprintf('%02d:%02d:%02d', $iHour, $iMin, $iSec);
        return $sDate.' '.$sTime;
    }

    /** Create trivial filter based on simple config
     * @param string $sName filter name
     * @param array  $aConf configuratin array ($field => $type)
     * @return Filter filter object
     */
    function createFilter($sName, $aConf)
    {
        $oFilter = &new Filter($sName);
        $aWhereConf = array();
        $aFieldDefs = array();
        foreach($aConf as $k=>$v)
        {
            list($sParam, $sCond, $aDefs) = Filter::_processCond($k, $v);
            $aWhereConf[$sParam] = $sCond;
            foreach($aDefs as $k2=>$v2)
                $aFieldDefs[$k2] = $v2;

        }
        $oFilter->init($aFieldDefs, $aWhereConf);
        return $oFilter;
    }

    function _processCond($sField, $sCond)
    {
        $sRes = '1';
        $aFieldDefs = array();
        switch ($sCond) {

        	case '=':
        	case '<': case '>':
        	case '<=': case '>=':
        	    $sRes = $sField.' '.$sCond.' "{$'.$sField.'}"';
        		break;

        	case 'like':
         	    $sRes = $sField.' LIKE "%{$'.$sField.'}%"';
        		break;

        	case 'range':
        	    $sRes = $sField.' BETWEEN "{$'.$sField.'_from}" AND "{$'.$sField.'_to}"';
        	    $sField .= '_from';
        		break;

        	case 'date_range':
        	    $sRes = $sField.' BETWEEN "{$'.$sField.'_from}" AND "{$'.$sField.'_to}"';
        	    $aFieldDefs[$sField.'_from'] = array(
        	       'type'=>'date_from',
                   'def'=>Filter::makeDate(date('Y'),1, 1) );
        	    $aFieldDefs[$sField.'_to'] = array(
        	       'type'=>'date_to',
                   'def'=>Filter::makeDate(date('Y'), 12, 31) );
        	    $sField .= '_from';
        		break;

        	case 'array':
       	    	$sRes = ' '.$sField.' IN ({$'.$sField.'}) ';
        	    $aFieldDefs[$sField] = array('type'=>'array');
        		break;
        }
        return array($sField, $sRes, $aFieldDefs);
    }



}

?>