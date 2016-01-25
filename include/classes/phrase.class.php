<?php
/** ============================================================
 * Class Phrase.
 * 
 * @author Rudenko S.
 * @package
 * ============================================================ */
require_once 'classes/utils/dbitem.class.php';

class Phrase extends DbItem
{

    function Phrase()
    {
        parent::DbItem();
        $this->_initTable('phrase');
    }

    /** Loads info from DB by PK
     * @param int $nId PK
     * @return boolean 1 - loaded, false - not found
     */
    function load($nId, $nLangId=0)
    {
        $this->aData = array();
        if ($nId) {
            $sSql = 'SELECT '.join(',', $this->aFields).
                ' FROM '.$this->sTable.' AS '.$this->sAlias.
                ' WHERE '.$this->sId.'="'.$nId.'"';
            $this->aData = $this->oDb->getRow($sSql);

            $sSql = 'SELECT p.object_field, pd.phrase, pd.language_id'.
                ' FROM  phrase p '.
                ' LEFT JOIN phrase_det pd ON pd.phrase_id=p.phrase_id  '.
                ' WHERE  pd.phrase_id="'.$nId.'"';
            $aRows = $this->oDb->getRows($sSql);
            $aInfo = array();
            foreach ($aRows as $aRow) {
                $aInfo[$aRow['language_id']] = $aRow['phrase'];
            }

            $this->aData['phrase'] = $aInfo;
        }

        return sizeof($this->aData);
    }

    /**
     * Verify unique alias
     *
     * @return bool
     */
    function isUniqueAlias($nId=0)
    {
        if (!$this->oDb->getField('SELECT COUNT(*) FROM '.conf::getT('phrase').' WHERE alias = "'.Database::escape($this->aData['alias']).'" AND phrase_id <> "'.$nId.'"', false))
            return true;
        else
            return false;
    }

}
?>