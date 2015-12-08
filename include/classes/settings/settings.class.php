<?php

require_once 'classes/utils/dbitem.class.php';

/** Class to work with changeable system settings.
 *
 */
class Settings extends DbItem {
    function Settings()
    {
        parent::DbItem();
        $this->_initTable('setting');
    }

    /** Get all setting for given page (settings type)
     * @param int     $iPage   settings page (settings type) code
     * @param boolean $bByOrder is seleceted by order (default) or by code
     * @return array settings data
     */
    function getSettings()
    {
        $sSQL = 'SELECT '.$this->_joinFields($this->aFields).
                '  FROM `'.$this->sTable.'` AS '.$this->sAlias.
                '  ORDER BY block, pos';
        return $this->oDb->getRows($sSQL);
    }
    
    /** Get value setting for given code (settings type)
     * @param string  $sCode  code of setting (settings type)
     * @return string value of setting
     */
    function getVal($sCode)
    {
        $sSQL = 'SELECT '.$this->aFields['val'].
                ' FROM '.$this->sTable.
                ' WHERE code = "'.strval($sCode).'"
                  LIMIT 1';
        return $this->oDb->getRow($sSQL);
    }


    /** Update selected setting.
     * @param string $sCode  setting code
     * @param mixed  $mValue setting value
     * @return unknown
     */
    function updateSetting($sCode, $mValue)
    {
        return $this->oDb->update($this->sTable, array('val'=>$mValue), 'code="'.$sCode.'"');
    }
}
?>