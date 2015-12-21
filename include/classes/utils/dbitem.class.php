<?php
/** ============================================================
 * Base class for all classes working with db
 * @package core
 * ============================================================ */

require_once 'classes/utils/common.class.php';

/** DbItem -- parent for all classes thats works with entities in db.
 *
 */
class DbItem extends Common
{
    /** DB driver
     * @var Database
     */
    var $oDb;

    /** Table columns (alias=>real_name).
     * @var array
     */
    var $aFields  = array();

    /** Insert/update/load  data (alias=>value).
     * @var array
     */
    var $aData    = array();

    /** Table name
     * @var string
     */
    var $sTable   = '';

    /** Table alias
     * @var string
     */
    var $sAlias = '';

    /** Primary key name
     * @var string
     */
    var $sId      = '';

    /** "Name" field - used for getHash()
     * @var unknown_type
     */
    var $sNameField = '';

    /**
     * Тип объекта, 1 - common
     * @var int
     */
    var $nObjectType = 1;

    /** Default Constructor.
     */
    function DbItem()
    {
        parent::Common();
        $this->oDb = &Database::get();
    }

    function _initTable($sTableCode)
    {
        list($this->sTable, $this->sAlias, $this->sId) = Conf::getTi($sTableCode);
        $this->_loadFields();
    }

    function _loadFields()
    {
        //load filed from database
        $this->aFields = array();
        $sSql = 'SHOW COLUMNS FROM '.$this->sTable;
        $aRows = $this->oDb->getRows($sSql);
        foreach($aRows as $aRow)
            $this->aFields[$aRow['Field']] = $this->sAlias.'.'.$aRow['Field'];
    }


    /** Removes from $this->aData incorrect keys (used $this->aFields by default)
     * @param $aField field for filtering, if omitted used $this->aFields
     * @return true
     */
    function _filterData($aFields=array())
    {
        if (! $aFields)
            $aFields = array_keys($this->aFields);
        foreach($this->aData as $sKey=>$sVal)
        {
            if (! in_array($sKey, $aFields))
                unset($this->aData[$sKey]);
        }
    }

    /** Performs insert.
    * @return int new item ID or false on error
    */
    function insert($bEscape=true)
    {
        $this->_filterData();
        $iId = $this->oDb->insert($this->sTable, $this->aData, $bEscape);
        if (!$iId)
            return $this->_addError('dbitem.insert');

        return $iId;
    }

    /** Performs update of current item ( You should fill in $this->aData ...)
     * @param array $aFields fields to update: all other fields will be omitted
     *                       or empty array for no filtration
     * @param bool  $bEscape true (default) - escape all data, false - do not escape
     * @param bool  $aPhraseFields array
     * @return bool
     */
    function update($aFields=array(), $bEscape=true, $aPhraseFields=array())
    {

        if (isset($this->aData[$this->sId]))
            $nId = intval($this->aData[$this->sId]);
        else
            return $this->_addError('dbitem.no_id', true);

        $aData = $this->aData;

        //trucate fields set (for security purposes)
        unset($aData[$this->sId]);
        $this->_filterData($aFields);

        // переводимые поля
        foreach($aPhraseFields as $sField) {
            if (isset($aData[$sField])) {
                $nPhraseId = $this->oDb->getField('SELECT phrase_id FROM phrase WHERE object_type_id='.$this->nObjectType.' AND object_field="'.$sField.'" AND object_id='.$nId);
                if (!$nPhraseId) {
                    $aValues = array(
                        'object_type_id' => $this->nObjectType,
                        'object_field' => $sField,
                        'object_id' => $nId,
                    );
                    $nPhraseId = $this->oDb->insert('phrase', $aValues);
                    if (!$nPhraseId)
                        return $this->_addError('dbitem.insert');
                }

                foreach($aData[$sField] as $nLangId=>$sTitle) {
                    $nPhraseDetId = $this->oDb->getField('SELECT phrase_det_id FROM phrase_det WHERE phrase_id=' . $nPhraseId . ' AND language_id=' . $nLangId);
                    if ($nPhraseDetId) {
                        if (!$this->oDb->update('phrase_det', array('phrase' => $sTitle), 'phrase_det_id=' . $nPhraseDetId, $bEscape))
                            return $this->_addError('dbitem.update');
                    } else {
                        $aValues = array(
                            'phrase_id' => $nPhraseId,
                            'language_id' => $nLangId,
                            'phrase' => $sTitle,
                        );
                        $nPhraseDetId = $this->oDb->insert('phrase_det', $aValues);
                        if (!$nPhraseDetId)
                            return $this->_addError('dbitem.insert');
                    }
                }
                unset($aData[$sField]);
            }
        }

        if ($this->oDb->update($this->sTable, $aData, $this->sId.' = '.$nId, $bEscape))
            return true;
        else
            return $this->_addError('dbitem.update');
    }

    /** Removes record by PK
     * @param mixed $nId PK value
     * @return mixed result of oDb->query
     */
    function delete($mId)
    {
        if (!$mId)
        	return true;
        	
        if (is_array($mId))
            $mId = implode(', ', array_map('intVal', $mId));
        else
            $mId = intval($mId);
        $sSql = 'DELETE FROM `'.$this->sTable.'` WHERE '.$this->sId.' IN('.$mId.')';
        return $this->oDb->query($sSql);
    }
    
    
    /** Removes record by PK
     * @param mixed $nId PK value
     * @return mixed result of oDb->query
     */
    function deleteBy($mId, $aCond=array())
    {
        if (!$mId)
        	return true;
        	
        if (is_array($mId))
            $mId = implode(', ', array_map('intVal', $mId));
        else
            $mId = intval($mId);
            
		$aFields = $this->aFields;
       	foreach ($aFields as $sKey => $sField) {
       		$aFields[$sKey] = $sKey;
       	}
        $sSql = 'DELETE FROM `'.$this->sTable.'` WHERE '.$this->sId.' IN('.$mId.') AND 
        		'.$this->_parseCond($aCond, $aFields);
        
        return $this->oDb->query($sSql);
    }  

	/** Removes record by conditions
     * @return mixed result of oDb->query
     */
    function deleteByCond($aCond=array())
    {
		$aFields = $this->aFields;
       	foreach ($aFields as $sKey => $sField) {
       		$aFields[$sKey] = $sKey;
       	}
        $sSql = 'DELETE FROM `'.$this->sTable.'` WHERE '.$this->_parseCond($aCond, $aFields);
        
        return $this->oDb->query($sSql);
    }         

    /** Loads info from DB by PK
     * @param int $nId PK
     * @return boolean 1 - loaded, false - not found
     */
    function load($nId)
    {
        $sSql = 'SELECT '.join(',', $this->aFields).' FROM '.$this->sTable.' AS '.$this->sAlias.' WHERE '.$this->sId.'="'.$nId.'"';
        $this->aData = $this->oDb->getRow($sSql);
        return sizeof($this->aData);
    }

    /** Load info from DB by given condition
     * @param array $aCond condition
     * @return array data
     */
    function loadBy($aCond)
    {
        $sSql = 'SELECT '.$this->_joinFields($this->aFields).' FROM '.$this->sTable.' AS '.$this->sAlias.
                '  WHERE '.$this->_parseCond($aCond, $this->aFields);
        $this->aData = $this->oDb->getRow($sSql);
        return sizeof($this->aData);
    }
    
   /** Prepare 'where' statement for sql query
     * @todo optimize and move to Sql class
     * @param array $aCond conditions like array('name'=>'LIKE "zz%"', 'price'=>'<12')
     * @param array $aMap mapping like array('name'=>'p.product_name', 'price'=>'p2o.price')
     * @return string where ststement like 1 AND p.product_name LIKE "zz%" AND p2o.price < 12
     */
    function _parseCond($aCond, $aMap)
    {
        $aRes = array('1');
        foreach($aCond as $sKey => $sExp)
        {
            if(is_numeric($sKey))
                $aRes[] = $sExp;
            else 
                $aRes[] = (isset($aMap[$sKey])?$aMap[$sKey]:'').' '.$sExp;
        }

        $sCond = join(' AND ', $aRes);
        foreach($aMap as $k=>$v)
        {
            if (false === strpos($sCond, '{#'))
                break; //no more {#..} -- exit
            $sCond = str_replace('{#'.$k.'}', $v, $sCond);
        }
        return $sCond;
    }

    /** Prepare list of fields for select sql query
     * @todo comment !! optimize and move to Sql class
     * @param
     * @return
     */
    function _joinFields($aMap, $aFields=array())
    {
        $aRes = array();
        $aFields = $aFields ? $aFields : array_keys($aMap);
        foreach($aFields as $sAlias)
            $aRes[] = $aMap[$sAlias].' AS '.$sAlias;
        return join(', ',$aRes);
    }

    /** Get offset for given page (fix pagen number if needed)
     * @param int $iPage      page number
     * @param int $iPageSize  page size (rows per page)
     * @param int $iCnt       records number
     * @return int offset of LIMIT in SQL
     */
    function _getOffset($iPage, $iPageSize, $iCnt)
    {
        if ($iPageSize) //if get page -- fix current page and get offset
        {
            $iPages  = ceil($iCnt / $iPageSize);
            $iPage   = max(1, min($iPages, $iPage));
            return $iPageSize*($iPage-1);
        }

        return 0;
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
            $sSql = 'SELECT '.$this->_joinFields($aMap, $aFields).
                    ' FROM '.$this->sTable.' AS '.$this->sAlias.
                    ' WHERE '.$sCond.
                    ($sSort?(' ORDER BY '.$sSort):'').
                    ($iPageSize?(' LIMIT '.$iOffset.','.$iPageSize):'');
            $aRows = $this->oDb->getRows($sSql);
        }
        return array($aRows, $iCnt);
    }
    
    /**
     * Get list  of primary keys
     *
     * @param array $aList
     */
    function getListIds($aList, $bJoin=false)
    {
    	$aIds = array(0);
    	foreach ($aList as $aItem) {
    		$aIds[] = $aItem[$this->sId];
    	}
    	if ($bJoin)
    		return join(',', $aIds);
    	return $aIds;
    }


    /** Select data from table as hash.
     * @param string $sValue name of columns with values
     * @param array  $aCond  condition array
     * @return array hash ($id=>$value)
     */
    function getHash($sValue='name', $aCond=array(), $sSort='')
    {
        $sCond = $this->_parseCond($aCond, $this->aFields);
        $sSql = 'SELECT '.$this->sId.','.$sValue.'  FROM '.$this->sTable.' AS '.$this->sAlias.
                ($sCond?'  WHERE '.$sCond:'').
                '  ORDER BY '.($sSort?$sSort:$sValue);
        $aRows = $this->oDb->getRows($sSql);
        $aRes = array();
        foreach($aRows as $aRow)
            $aRes[$aRow[$this->sId]] = $aRow[$sValue];
        return $aRes;
    }
    
    /**
     * Gets a next order value for new object in the table:
     * (next_order = max_order + 1)
     * @param string  $sOrderField field name for ordering
     * @param string  $sInTable table name (container for ordering item)
     * @param integer $nInId ID of container
     * @author Alexander Martinkevich
     * @return numeric order
     */
    function getNextPos($sOrderField, $sInTable='', $nInId=0)
    {
        $sWhere = '';
        if ($sInTable && $nInId)
        {
            $oInTable = new DbItem();
            $oInTable->_initTable($sInTable);
            $sWhere .= ' AND '.$oInTable->sId.'="'.$nInId.'"';
        }
        $sSql = 'SELECT max('.$sOrderField.')'.
                ' FROM '.$this->sTable.
                ' WHERE 1'.$sWhere;
        $nOrder = $this->oDb->getField($sSql);

        return $nOrder + 1;
    }

    /**
     * Updates an order of items  according to requested args
     * @param string  $sOrderField field name for ordering
     * @param integer $nOrder new order of item
     * @param string  $nId ID of item
     * @param string  $sInTable table name (container for ordering item)
     * @param integer $nInId ID of container
     * @author Alexander Martinkevich
     */
    function updatePoses($sOrderField, $nOrder, $nId=0, $sInTable='', $nInId=0)
    {
        $sWhere = '';
        if ($sInTable && $nInId)
        {
            $oInTable = new DbItem();
            $oInTable->_initTable($sInTable);
            $sWhere .= ' AND '.$oInTable->sId.'="'.$nInId.'"';
        }
        $sWhere .= $nId ? ' AND '.$this->sId.'!='.$nId : '';
        
        // get number of items to update
        $sSql = 'SELECT count('.$this->sId.')
                 FROM '.$this->sTable.'
                 WHERE '.$sOrderField.'='.$nOrder.
                 $sWhere;
        $nCnt = $this->oDb->getField($sSql);
        if (!$nCnt)
            return;
        
        $sSql = 'SELECT '.$sOrderField.', '.$this->sId.'
                 FROM '.$this->sTable.'
                 WHERE '.$sOrderField.'>='.$nOrder.
                 $sWhere.
                 'ORDER BY '.$sOrderField.' ASC';
        $aItems = $this->oDb->getRows($sSql);
        
        $nLastOrder = $nOrder;
        for ($i = 0; $i < count($aItems); $i++)
        {
            if ($aItems[$i][$sOrderField] == $nLastOrder)
            {
                $nLastOrder++;
                $sSql = 'UPDATE '.$this->sTable.'
                         SET '.$sOrderField.'="'.($nLastOrder).'"
                         WHERE '.$this->sId.'="'.$aItems[$i][$this->sId].'"';
                $this->oDb->query($sSql);
            }
        }
    }
    
    /**
     * Checks if deleted row with requested ID (cehcks by "is_deleted" field)
     *
     * @param int $nId
     * @return bool;
     */
    function checkDeleted($nId)
    {
        $sSql = 'SELECT is_deleted FROM '.$this->sTable.
                ' WHERE '.$this->sId.'='.intval($nId);
        return $this->oDb->getField($sSql);
    }
    
 	/**
     * Translite Russian to English
     * @param  string $sStr string for alias generating
     * @param  int    $nId  ID of row (optional if row is not inserted yet)
     * @return string alias
     */
    function genAlias($sStr, $nId=0)
    {    
        $sTempStr = $sStr = $this->translit($sStr);
        $i = 2;
        do
        {
            $bFlag  = $this->checkAlias($sStr, $nId);
            $sAlias = $sStr;
            $sStr   = $sTempStr;
            $sStr  .= '-'.$i;
            $i++;
        } while (!$bFlag);
        return $sAlias;
    }
    
    
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
        
    /**
     * Checks, does another related object have such alias
     * (use only "alias" field from table)
     * @param  string $sAlias alias for check
     * @param  int    $nId    ID of row (optional if row is not inserted yet)
     * @author Alexander Martinkevich
     * @return bool true if alias does not exist, false otherwise
     */
    function checkAlias($sAlias, $nId=0)
    {
        $sAlias     = $this->oDb->escape($sAlias);
        $sWhere     = '';

        if ($nId)
        {
            $sWhere .= ' AND '.$this->sId.'<>"'.$nId.'" ';
        }

        $sSql = 'SELECT COUNT(alias)'.
                ' FROM '.$this->sTable.
                ' WHERE alias="'.$sAlias.'" '.$sWhere;

        return 0 == $this->oDb->getField($sSql);
    }
    
    
    
    function getMonthLang($nMonth, $sLang = 'ru')
    {
        $aMonth = array(
        				'ru'=>array(1=>'январь','февраль','март','апрель','май','июнь','июль','август','сентябрь','октябрь','ноябрь','декабрь'),
        				'en'=>array(1 => 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'),
        				);  
        return $aMonth[$sLang][$nMonth];
    }      
    
    function getDateLang($iTimestamp, $sLang = 'ru', $sYear='Y', $bTime=false, $bTimeFirst=false)
    {
        $aMonth = array(
        				'ru'=>array(1=>'января','февраля','марта','апреля','мая','июня','июля','августа','сентября','октября','ноября','декабря'),
        				'en'=>array(1 => 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'),
        				);  
        $aMonth =  $aMonth[$sLang];
        $sDate = '';
        if ($iTimestamp){
       	$sDate .= $bTimeFirst && $bTime ? date('G-i, ', $iTimestamp) : '';
       	
        $sDate .= date('j ', $iTimestamp);
        $sDate .= $aMonth[date('n', $iTimestamp)].' ';
        
        if ($sYear != false)
        	$sDate .= $sYear=='Y' && date('Y', $iTimestamp)!=date('Y') ? date($sYear, $iTimestamp):'';
        
        $sDate = trim($sDate). (!$bTimeFirst && $bTime ? date(', G:i', $iTimestamp) : '');
        }
        return $sDate;
    }   
    
    
    function getCount($aCond=array()) 
    {
        $aMap = $this->aFields;
        $sCond = $this->_parseCond($aCond, $aMap);
        $sSql = 'SELECT COUNT(*) FROM `'.$this->sTable.'` AS '.$this->sAlias.' WHERE '.$sCond;
        return $this->oDb->getField($sSql);    
    }
}
?>