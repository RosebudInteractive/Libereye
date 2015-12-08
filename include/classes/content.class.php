<?php
require_once 'classes/utils/dbitem.class.php';

/** ============================================================
 * Class Content for working with data in table `content`
 * @author Rudenko S.
 * @package Content
 * ============================================================ */
class Content extends DbItem
{

    function Content()
    {
        parent::DbItem();
        $this->_initTable('content');
    }

    /** Loads info from DB by PK
     * @param int $nId PK
     * @return boolean 1 - loaded, false - not found
     */
    function load($nId)
    {
        $sSql = 'SELECT '.join(',', $this->aFields).', l.title lang_title, l.alias lang_alias'.
            ' FROM '.$this->sTable.' AS '.$this->sAlias.
            ' LEFT JOIN language AS l ON l.language_id=c.language_id'.
            ' WHERE '.$this->sId.'="'.$nId.'"';
        $this->aData = $this->oDb->getRow($sSql);
        return sizeof($this->aData);
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
            $sSql = 'SELECT '.$this->_joinFields($aMap, $aFields).', COUNT(c2.content_id) childs_num, l.title lang_title, l.alias lang_alias'.
                    ' FROM '.$this->sTable.' AS '.$this->sAlias.
                    ' LEFT JOIN '.$this->sTable.' AS c2 ON c2.parent_id=c.content_id'.
                    ' LEFT JOIN language AS l ON l.language_id=c.language_id'.
                    ' WHERE '.$sCond.
                    ' GROUP BY c.content_id'.
                    ($sSort?(' ORDER BY '.$sSort):'').
                    ($iPageSize?(' LIMIT '.$iOffset.','.$iPageSize):'');
            $aRows = $this->oDb->getRows($sSql);
        }
        return array($aRows, $iCnt);
    }
    
    /** Load info from DB by given condition
     * @param array $aCond condition
     * @return array data
     */
    function loadBy($aCond)
    {
        $sSql = 'SELECT '.$this->_joinFields($this->aFields).
        		' FROM '.$this->sTable.' AS '.$this->sAlias.
                '  WHERE '.$this->_parseCond($aCond, $this->aFields);
        $this->aData = $this->oDb->getRow($sSql);
        
        if ($this->aData)
        	$this->aData['path'] = $this->getPath($this->aData['content_id']);
        
        return sizeof($this->aData);
    }
      
	/**
	 * Return tree of posts
	 *
	 * @param unknown_type $aPosts
	 * @param unknown_type $nParentId
	 * @param unknown_type $nLevel
	 * @return unknown
	 */
	function getTree($aPosts, $nParentId=0, $nLevel=0) 
	{
		$aPostTree = array(); 
		$aChilds = $this->findChilds($aPosts, $nParentId);
		usort($aChilds, array('Content', 'sortByPriority'));
		for ($i=0; $i<count($aChilds);$i++)
		{
			$aChilds[$i]['level'] = $nLevel;
			$aPostTree[] = $aChilds[$i];
			$children = $this->getTree($aPosts, $aChilds[$i]['content_id'], $nLevel+1);
			for ($j=0; $j<count($children); $j++)
			{
				$aPostTree[] = $children[$j];
			}			
		}
		return $aPostTree;
	}    
	
	static function sortByPriority($aPost1, $aPost2)
	{
        if ($aPost1['priority'] == $aPost2['priority']) {
            return 0;
        }
        return ($aPost1['priority'] > $aPost2['priority']) ? +1 : -1;
		
	}
    
    function findChilds($aPosts, $nPostId, $bIdOnly=false)
    {
    	$aChilds = array();
    	foreach ($aPosts as $aPost)
    	{
    		if ($aPost['parent_id'] == $nPostId)
    		{
    			if ($bIdOnly)
    			{
    				$aChilds[$nPostId][] = $aPost['content_id'];
    			}
    			else 
    			{
    				$aChilds[] = $aPost;
    			}
    		}
    	}
    	return $aChilds;
    }	
    
    function getPath($nForumId)
    {
    	$aPath = array();
    	do{
	    	$aRow = $this->oDb->getRow('SELECT * FROM content WHERE content_id='.(int)$nForumId);    		
	   		$nForumId = $aRow['parent_id'];
	   		$aPath[] = $aRow;
    	}while ($nForumId);    	
    	$aPath = array_reverse($aPath);    	
    	return $aPath;
    } 

}
?>