<?php
require_once 'validator.class.php';

/** Classe for maintaing data with multi-page forms.
 * Stores data in parts (group of data usually used by
 * single business-object), create validators etc.
 */
class Wizard
{

    /** Wizard name
     * @var string
     */
    var $_sName;

    /** Wizard steps
     * @var array
     */
    var $_aSteps;

    /** Wizard configuration
     * @var array
     */
    var $_aConf;

    /** Forms data (aggregated)
     * @var array
     */
    var $_aData;

    /** Step name
     * @var Url
     */
    var $_oUrl;

    /** Validator
     * @var Validator
     */
    var $_oValidator;

    /** Constructor
     * @param array   $aConf wizard config
     * @param Request $oReq  request to parse current step
     * @param string  $sName wizar name (user for store in session etc.)
     * @return Wizard
     */
    function Wizard($aSteps, $aConf, $oUrl, $sName='default')
    {
        $this->_aConf  = $aConf;
        $this->_sName  = $sName;
        $this->_oUrl   = $oUrl;
        $this->_aData  = array();
        $this->_aSteps = $aSteps;

        if (!$this->_checkStep())
            $this->gotoStep($this->_aSteps[0]); //wrong step -- goto first step

        //create initial data
        foreach($this->_aConf as $k=>$v)
        {
            $this->_aData[$k] = array();
            foreach($v as $k1=>$v1)
                $this->_aData[$k][$k1] = (isset($this->_aConf[$k][$k1]['init'])?$this->_aConf[$k][$k1]['init']:'');
        }

        //if isset session -- load data from session
        $this->load();
        $this->_oValidator = &$this->_getValidator();
    }

    /** Returns current step.
     * @return string current step name.
     */
    function getStep()
    {
        return $this->_oUrl->getParam('step', '1');
    }

    /** Add data to wizard storage.
     * @param array $aData data to add
     */
    function addData($aData)
    {
        foreach($aData as $k=>$v)
        {
            if (isset($this->_aConf[$k]) && is_array($v))
            {
                foreach($v as $k1=>$v1)
                {
                    if (isset($this->_aConf[$k][$k1]))
                        $this->_aData[$k][$k1] = $v1;
                }
            }
        }
    }

    /** Return wizard info:
     *     'aFields' => stored data
     *     'jsVal'   => current validator info
     * @return array wizard info
     */
    function getInfo()
    {
        $oVal = $this->_oValidator;

        $aRes = array(
            'aFields'=>$this->_aData,
            'aValidator' => $oVal->makeJS(),
        );
        return $aRes;
    }

    /** Get data for wizard part
     * @param unknown_type $sArrKey
     * @return unknown
     */
    function getData($sArrKey)
    {
        return isset($this->_aData[$sKey])?$this->_aData[$sKey]:array();
    }

    /** Returns value for given parameter (part+key)
     * @param string $sArrKey   part key
     * @param string $sValueKey value key
     * @return mixed parameter value
     */
    function getValue($sArrKey, $sValueKey)
    {
        return isset($this->_aData[$sKey][$sValueKey])?$this->_aData[$sKey][$sValueKey]:false;
    }

    /** Load data from session.
     */
    function load()
    {
        if (isset($_SESSION['wizard'][$this->_sName]))
        {
            foreach($_SESSION['wizard'][$this->_sName] as $k=>$v)
                foreach($v as $k1=>$v1)
                    $this->_aData[$k][$k1] = $v1;
        }
    }

    /** Save data to session.
     */
    function save()
    {
        foreach($this->_aData as $k=>$v)
            foreach($v as $k1=>$v1)
                $_SESSION['wizard'][$this->_sName][$k][$k1] = $v1;

        //mark step as passed
        $_SESSION['wizard'][$this->_sName]['_passed'][$this->getStep()] = true;
    }

    /** Clear all data.
     */
    function clear()
    {
        $this->_aData = array();
        unset($_SESSION['wizard'][$this->_sName]);
    }

    /** Goto selected step
     * @param string $sStep step name
     */
    function gotoStep($sStep)
    {
        $this->save();
        $oReq = &new Request($oUrl);
        $this->_oUrl->setParam('step', $sStep);
        $oReq->forward($this->_oUrl->getUrl());
    }

    /** Goto next step
     * Next step = intval(Curent step) + 1)
     *
     */
    function gotoNext()
    {
        $iNextStep = array_search($this->getStep(), $this->_aSteps) + 1;
        if (isset($this->_aSteps[$iNextStep]))
            $this->gotoStep($this->_aSteps[$iNextStep]);
        else
            $this->gotoStep($this->_aSteps[0]);
    }

    // ========== Validation-realted functions ==========

    /** Returns validator for given step
     * @param string $sStep
     * @return Validator
     */
    function &_getValidator() {
        $sStep = $this->getStep();
        $aValConf = array();
        foreach($this->_aConf as $k=>$v)
        {
            foreach($v as $k1=>$v1)
            {
                if ($v1['step']==$sStep)
                {
                    unset($v1['step']);
                    unset($v1['init']);
                    $aValConf[$k.'['.$k1.']'] = $v1;
                }
            }
        }
        $oValidator = &new Validator($aValConf);
        return $oValidator;
    }

    /** Check validation (delegate call to validator object)
     * @return bool true -- data valid, false -- errors occured
     * @see isValid()
     */
    function isValid()
    {
        return $this->_oValidator->isValid($this->_aData);
    }

    /** Get validation errors (delegate call to Validator object)
     * @return array errors messages or empty array if no errors.
     * @see getErrors()
     */
    function getErrors()
    {
        return $this->_oValidator->getErrors();
    }

    /**
     * Check current step. If error -- redirect to first step
     *
     */
    function _checkStep()
    {
        //selected step must be in steps config
        if (!isset($this->_aSteps[$this->getStep()]))
            return false;

        //all previous steps must be passed
        $bPassed = false;
        foreach($this->_aSteps as $sStep)
        {
            if ($sStep==$this->getStep())
            {
                $bPassed = true;
                break;
            }
            else {
                if (!isset($_SESSION['wizard'][$this->_sName]['_passed'][$this->getStep()]))
                    break; //found step that was not passed
            }
        }
        return $bPassed;

    }
}

?>