<?php
/** ============================================================
 * Class Shop.
 * 
 * @author Rudenko S.
 * @package
 * ============================================================ */
require_once 'classes/utils/dbitem.class.php';

class Shop extends DbItem
{

    function Shop()
    {
        parent::DbItem();
        $this->_initTable('shop');
        $this->nObjectType = 4;
    }

    /** Select from DB list of records.
     * @param array $aCond      conditions like array('name'=>'LIKE "zz%"', 'price'=>'<12') (usually prepared by Filter class)
     * @param int   $iOffset    page number (may be corrected)
     * @param int   $iPageSize  page size (row per page)
     * @param string $sSort     'order by' statement (usually prepared by Sorder class)
     * @return array ($aRows, $iCnt)
     */
    function getList($aCond=array(), $iPage=0, $iPageSize=0, $sSort='', $aFields=array(), $nLangId=0)
    {
        $nLangId = $nLangId? $nLangId: LANGUAGEID;
        $aMap = $this->aFields;
        $sCond = $this->_parseCond($aCond, $aMap);
        $sSql = 'SELECT COUNT(*) FROM `'.$this->sTable.'` AS '.$this->sAlias.
        ' WHERE '.$sCond;
        $iCnt = $this->oDb->getField($sSql);
        $aRows = array();
        if ($iCnt)
        {
            $iOffset = $this->_getOffset($iPage, $iPageSize, $iCnt);
            $sSql = 'SELECT '.$this->_joinFields($aMap, $aFields).
                    ', pd1.phrase title'.
                    ', pd2.phrase timezone'.
                    ', t.time_shift'.
                    ' FROM '.$this->sTable.' AS '.$this->sAlias.
                    ' LEFT JOIN phrase p1 ON p1.object_id='.$this->sAlias.'.shop_id AND p1.object_type_id='.$this->nObjectType.'   AND p1.object_field="title" '.
                    ' LEFT JOIN phrase_det pd1 ON pd1.phrase_id=p1.phrase_id AND pd1.language_id='.$nLangId.'  '.
                    ' LEFT JOIN timezone t ON t.timezone_id='.$this->sAlias.'.timezone_id'.
                    ' LEFT JOIN phrase p2 ON p2.object_id=t.timezone_id AND p2.object_type_id=9 AND p2.object_field="title" '.
                    ' LEFT JOIN phrase_det pd2 ON pd2.phrase_id=p2.phrase_id AND pd2.language_id='.$nLangId.'  '.
                    ' WHERE  '.$sCond.
                    ($sSort?(' ORDER BY '.$sSort):'').
                    ($iPageSize?(' LIMIT '.$iOffset.','.$iPageSize):'');
            $aRows = $this->oDb->getRows($sSql);
        }
        return array($aRows, $iCnt);
    }

    /** Loads info from DB by PK
     * @param int $nId PK
     * @return boolean 1 - loaded, false - not found
     */
    function load($nId, $nLangId=0)
    {
        $this->aData = array();
        if ($nId) {
            $sSql = 'SELECT '.join(',', $this->aFields). ', i.name promo_head, t.code timezone_code, p.def_phrase timezone_title, t.time_shift '.
                ' FROM '.$this->sTable.' AS '.$this->sAlias.
                ' LEFT JOIN image i ON s.promo_head=i.image_id'.
                ' LEFT JOIN timezone t ON s.timezone_id=t.timezone_id'.
                ' LEFT JOIN phrase p ON p.phrase_id=t.title_id '.
                ' WHERE '.$this->sId.'="'.$nId.'"';
            $this->aData = $this->oDb->getRow($sSql);

            if ($this->aData) {

                $sShiftUTC = 0;
                if (preg_match('@\(GMT(.*?)\)@i', $this->aData['timezone_title'], $aMatches)) {
                    list($sHours, $sMinutes) = explode(':', $aMatches[1]);
                    $sShiftUTC = $sHours*60 + $sMinutes;
                }
                $this->aData['timezone_shift'] = $sShiftUTC;

                $sSql = 'SELECT p.object_field, pd.phrase, pd.language_id'.
                    ' FROM  phrase p '.
                    ' LEFT JOIN phrase_det pd ON pd.phrase_id=p.phrase_id  '.
                    ' WHERE p.object_type_id='.$this->nObjectType.' AND p.object_id="'.$nId.'"';
                $aRows = $this->oDb->getRows($sSql);
                $aInfo = array();
                foreach ($aRows as $aRow) {
                    $aInfo[$aRow['object_field']][$aRow['language_id']] = $aRow['phrase'];
                }

                if ($nLangId) {
                    $this->aData['title'] = isset($aInfo['title'])?$aInfo['title'][$nLangId]:'';
                    $this->aData['description'] = isset($aInfo['description'])?$aInfo['description'][$nLangId]:'';
                    $this->aData['brand_desc'] = isset($aInfo['brand_desc'])?$aInfo['brand_desc'][$nLangId]:'';
                } else {
                    $this->aData['title'] = isset($aInfo['title'])?$aInfo['title']:array();
                    $this->aData['description'] = isset($aInfo['description'])?$aInfo['description']:array();
                    $this->aData['brand_desc'] = isset($aInfo['brand_desc'])?$aInfo['brand_desc']:array();
                }
            }
        }

        return sizeof($this->aData);
    }



    /** Select from DB list of records.
     * @param array $aCond      conditions like array('name'=>'LIKE "zz%"', 'price'=>'<12') (usually prepared by Filter class)
     * @param int   $iOffset    page number (may be corrected)
     * @param int   $iPageSize  page size (row per page)
     * @param string $sSort     'order by' statement (usually prepared by Sorder class)
     * @return array ($aRows, $iCnt)
     */
    function getListOffset($aCond=array(), $iOffset=0, $iPageSize=0, $sSort='', $aFields=array(), $nLangId=0)
    {
        $nLangId = $nLangId? $nLangId: LANGUAGEID;
        $aMap = $this->aFields;
        $sCond = $this->_parseCond($aCond, $aMap);
        $sSql = 'SELECT COUNT(*) FROM `'.$this->sTable.'` AS '.$this->sAlias.
            (isset($aCond['{#title}']) || isset($aCond['{#description}'])?(' LEFT JOIN phrase p1 ON p1.object_id='.$this->sAlias.'.shop_id AND p1.object_type_id='.$this->nObjectType.'   AND p1.object_field="title" '.
                ' LEFT JOIN phrase_det pd1 ON pd1.phrase_id=p1.phrase_id AND pd1.language_id='.$nLangId.'  '.
                ' LEFT JOIN phrase p2 ON p2.object_id='.$this->sAlias.'.shop_id AND p2.object_type_id='.$this->nObjectType.'   AND p2.object_field="description" '.
                ' LEFT JOIN phrase_det pd2 ON pd2.phrase_id=p2.phrase_id AND pd2.language_id='.$nLangId.'  '):'').
            ' WHERE '.$sCond;
        $iCnt = $this->oDb->getField($sSql);
        $aRows = array();
        if ($iCnt)
        {
            $sSql = 'SELECT '.$this->_joinFields($aMap, $aFields).', i.name image'.
                ', pd1.phrase title'.
                ', pd2.phrase description'.
                ' FROM '.$this->sTable.' AS '.$this->sAlias.
                ' LEFT JOIN image i ON i.image_id=s.promo_head'.
                ' LEFT JOIN phrase p1 ON p1.object_id='.$this->sAlias.'.shop_id AND p1.object_type_id='.$this->nObjectType.'   AND p1.object_field="title" '.
                ' LEFT JOIN phrase_det pd1 ON pd1.phrase_id=p1.phrase_id AND pd1.language_id='.$nLangId.'  '.
                ' LEFT JOIN phrase p2 ON p2.object_id='.$this->sAlias.'.shop_id AND p2.object_type_id='.$this->nObjectType.'   AND p2.object_field="description" '.
                ' LEFT JOIN phrase_det pd2 ON pd2.phrase_id=p2.phrase_id AND pd2.language_id='.$nLangId.'  '.
                ' WHERE  '.$sCond.
                ($sSort?(' ORDER BY '.$sSort):'').
                ($iPageSize?(' LIMIT '.$iOffset.','.$iPageSize):'');
            $aRows = $this->oDb->getRows($sSql);
        }
        return array($aRows, $iCnt);
    }
    
}
?>