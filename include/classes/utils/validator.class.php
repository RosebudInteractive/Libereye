<?php
/** ============================================================
 *  Input validator - checks user input against specified rules.
 * @package core
 * @see validator.mess.php
 * ============================================================ */

require_once 'messages/'.LANGUAGE.'/validator.mess.php';
require_once 'settings/validator.sett.php';


class Validator extends Common
{

    /** Validation fields configuration
     * @var array
     */
    var $aFields = array();

    /** Validation rules
     * @var array
     */
    var $aRules = array();  // 0 - first op, 1 - second op, 2 - operation


    /** Constuctor.
     * @param array $aFields array of field validation schemes
     * @param array $aRules validation rules
     */
    function Validator($aFields, $aRules=array() )
    {
        // vitally important (!) for debug
        $aKeys = array('def', 'title', 'pattern', 'optional', 'minlen', 'maxlen', 'min', 'max', 'enum', 'message');
        foreach($aFields as $sKey => $aScheme)
        {
            if ( isset($aScheme['def']) )
            {
                $aScheme = array_merge($this->_getDef($aScheme['def'], $aScheme['title']), $aScheme);
                unset($aScheme['def']);
            }

            if (array_diff(array_keys($aScheme), $aKeys))
                $this->_addError('validator.unknown_keys', '', true);

            $this->aFields[$sKey] = $aScheme;
        }
        $this->aRules  = $aRules;
    }

    /** Returns specified value from a given array. supports one [] in names
     * @param string $sKey    key of values
     * @param string $aValues values array
     * @access private
     * @return string
     * @todo handle errors
     */
    function _getValue($sKey, &$aValues)
    {
        // vitally important for debug ( do not use isset (!) )
        $sVal = '';
        if ( preg_match('/^(.+)\[(.*)\]$/', $sKey, $aMat) ){
            $sVal = isset($aValues[$aMat[1]][$aMat[2]]) ? $aValues[$aMat[1]][$aMat[2]] : '';
        }
        else
            $sVal = isset($aValues[$sKey])?$aValues[$sKey]:'';

        return $sVal;
    }

    /** Checks whether data is valid according to rules
     *
     * @param array $aValues values to check
     * @return boolean true - values are valid, false - invalid values
     */
    function isValid($aValues)
    {

        foreach ($this->aFields as $sField => $aScheme)
            $this->_validate($this->_getValue($sField, $aValues), $aScheme);

        foreach ($this->aRules as $aRule)
        {
            $mOp1 = $this->_getValue($aRule[0], $aValues);
            $mOp2 = $this->_getValue($aRule[1], $aValues);
            $bError = false;
            switch ($aRule[2])
            {
                case '==':
                    $bError = !($mOp1 == $mOp2);
                break;
                case '!=':
                    $bError = !($mOp1 != $mOp2);
                break;
                case '<=':
                    $bError = (($mOp1!='') && ($mOp2!='') && !($mOp1 <= $mOp2));
                break;
                case '>=':
                    $bError = (($mOp1!='') && ($mOp2!='') && !($mOp1 >= $mOp2));
                break;
                case 'req':
                    $bError = ($mOp1 and ($mOp2 == ''));
                break;
                default:
                    $this->_addError('validator.unknown_rule', $aRule[2], true);
            }// switch

            if ($bError)
                $this->_addError('validator.rule.'.$aRule[2], array(
                    $this->aFields[$aRule[0]]['title'],
                    $this->aFields[$aRule[1]]['title'])
                );

        }// foreach rules

        return (0 == sizeof($this->aErrors));
    }

    /** Constructs javascript for client-side validation
     * @param string $sForm name of HTML form to validate
     * @param boolean $bReturn sets if returned string contains 'return' statement
     * @param string $sDivName Id of HTML div for error output. if empty js uses alert()
     * @return string javascript code for validation
     */
    function makeJS($sForm = 'this', $bReturn=true, $sDivName='jsErr')
    {
        $sCode = ' validator_isValid('.$sForm.', new Array( ';
        // fields
        foreach ( $this->aFields as  $sField =>$aScheme )
        {
            $sCode .= "{'field':'".$sField."'";
            foreach ($aScheme as  $sKey => $sVal)
            {
                if (!in_array($sKey, array('minlen','min','maxlen','max','pattern','optional')))
                    $sVal = "'".$sVal."'";
                $sCode .= ",'".$sKey."':".$sVal;
            }
            $sCode .= '},';
        }
        //rules
        $sCode = substr($sCode, 0, -1)."), new Array( ";
        foreach ($this->aRules as $aRule)
            $sCode .= sprintf("['%s','%s','%s','%s'],", $aRule[0], $aRule[1], $aRule[2],
                conf::format('validator.rule.'.$aRule[2], array($this->aFields[$aRule[0]]['title'], $this->aFields[$aRule[1]]['title'])));

        $sCode = substr($sCode, 0, -1)."), '".$sDivName."')";
        if ($bReturn)
            $sCode = 'return '.$sCode;
        return $sCode;
    }
    /** Make javascript with messages array.
     * @return string javascript code (with <script> tags) for messages array
     */
    function makeJsMess()
    {
        $sScript = "<script type='text/javascript' language='JavaScript'> var aValidatorMes = [];";
        $aMess = Conf::getMessages('validator.field.');
        foreach ($aMess as $k=>$v)
        {
            $sKey = str_replace('validator.field.', '', $k);
            $sScript .= " aValidatorMes['$sKey']  = '".Conf::format('validator.field.'.$sKey, array('%s0', '%s1', '%s2', '%s3', '%s4'))."';";
        }
        $sScript .= "</script>";
        return $sScript;
    }

    /** Validates single field.
     * @param mixed $mValue
     * @param array $aScheme
     * @access private
     * @returns boolean
     */
    function _validate($mValue, $aScheme)
    {
        if ( isset($aScheme['optional']) and !strlen($mValue))
            return true;

        $aErr = array();

        if ( isset($aScheme['minlen']) and strlen($mValue) < $aScheme['minlen'])
            $aErr['minlen'] = array($aScheme['title'], $aScheme['minlen'], strlen($mValue));

        if ( isset($aScheme['maxlen']) and strlen($mValue) > $aScheme['maxlen'])
            $aErr['maxlen'] =  array($aScheme['title'], $aScheme['maxlen'], strlen($mValue));

        if ( isset($aScheme['pattern']) and !preg_match($aScheme['pattern'], $mValue) )
            $aErr['pattern'] = array($aScheme['title'], $aScheme['pattern'], $mValue );

        if ( isset($aScheme['min']) and $mValue < $aScheme['min'])
            $aErr['min'] = array($aScheme['title'], $aScheme['min'], $mValue);

        if ( isset($aScheme['max']) and $mValue > $aScheme['max'])
            $aErr['max'] = array($aScheme['title'], $aScheme['max'], $mValue);

        if ( isset($aScheme['mineq']) and $mValue <= $aScheme['mineq'])
            $aErr['mineq'] = array($aScheme['title'], $aScheme['mineq'], $mValue);

        if ( isset($aScheme['maxeq']) and $mValue >= $aScheme['maxeq'])
            $aErr['maxeq'] = array($aScheme['title'], $aScheme['maxeq'], $mValue);
/*
        if ( isset($aScheme['enum']) and !in_array($mValue, $aScheme['enum']))
            $aErr['enum'] =  array($aScheme['title'], $mValue);
*/
        if (! $aErr)
            return true;

        if (isset($aScheme['message']))
            $this->_addError('validator.field.custom', array($aScheme['title'], $aScheme['message']));
        else
            foreach($aErr as $sKey=>$aParam)
                $this->_addError('validator.field.'.$sKey, $aParam);

        return false;
    }

    /** Gets default validation schemes by key. If unknown rule throws exeption
     * @access private
     * @param string $sKey
     * @return array scheme
     */
    function _getDef($sKey, $sTitle = '')
    {
        $aValidatorDefs = Conf::get('validator.def');

        if (! array_key_exists($sKey, $aValidatorDefs))
            $this->_addError('validator.unknown_def', $sKey, true);

        if (Conf::hasMes('validator.def.'.$sKey))
            $aValidatorDefs[$sKey]['message'] = Conf::format('validator.def.'.$sKey, array($sTitle));

        return $aValidatorDefs[$sKey];
    }

    /** Check sequence for duplicates absence.
     * @param array $aNums sequence numbers
     * @param string $
     * @return array array of errors or empty array if no errors occured
     */
    function checkSequence($aNums, $sField)
    {
        $aErrors = array();
        $aCnts = array_count_values($aNums);
        foreach($aCnts as $k=>$v)
        {
            if ($k and $v > 1) //not empty value and count > 1
                $aErrors = Conf::format('validator.duplicate', array($k, $sField));
        }
        return $aErrors;
    }

}
?>