<?php
/** ============================================================
 * Class Carrier.
 * 
 * @author Rudenko S.
 * @package
 * ============================================================ */
require_once 'classes/utils/dbitem.class.php';

class Carrier extends DbItem
{

    function Carrier()
    {
        parent::DbItem();
        $this->_initTable('carrier');
        $this->nObjectType = 13;
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
                    ' FROM '.$this->sTable.' AS '.$this->sAlias.
                    ' LEFT JOIN phrase p1 ON p1.object_id='.$this->sAlias.'.carrier_id AND p1.object_type_id='.$this->nObjectType.'   AND p1.object_field="title" '.
                    ' LEFT JOIN phrase_det pd1 ON pd1.phrase_id=p1.phrase_id AND pd1.language_id='.$nLangId.'  '.
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
            $sSql = 'SELECT '.join(',', $this->aFields).
                ' FROM '.$this->sTable.' AS '.$this->sAlias.
                ' LEFT JOIN phrase p ON p.phrase_id=c.title_id '.
                ' WHERE '.$this->sId.'="'.$nId.'"';
            $this->aData = $this->oDb->getRow($sSql);

            if ($this->aData) {

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
                } else {
                    $this->aData['title'] = isset($aInfo['title'])?$aInfo['title']:array();
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
            (isset($aCond['{#title}'])?(' LEFT JOIN phrase p1 ON p1.object_id='.$this->sAlias.'.carrier_id AND p1.object_type_id='.$this->nObjectType.'   AND p1.object_field="title" '.
                ' LEFT JOIN phrase_det pd1 ON pd1.phrase_id=p1.phrase_id AND pd1.language_id='.$nLangId.'  '):' ').
            ' WHERE '.$sCond;
        $iCnt = $this->oDb->getField($sSql);
        $aRows = array();
        if ($iCnt)
        {
            $sSql = 'SELECT '.$this->_joinFields($aMap, $aFields).
                ', pd1.phrase title'.
                ' FROM '.$this->sTable.' AS '.$this->sAlias.
                ' LEFT JOIN phrase p1 ON p1.object_id='.$this->sAlias.'.carrier_id AND p1.object_type_id='.$this->nObjectType.'   AND p1.object_field="title" '.
                ' LEFT JOIN phrase_det pd1 ON pd1.phrase_id=p1.phrase_id AND pd1.language_id='.$nLangId.'  '.
                ' WHERE  '.$sCond.
                ($sSort?(' ORDER BY '.$sSort):'').
                ($iPageSize?(' LIMIT '.$iOffset.','.$iPageSize):'');
            $aRows = $this->oDb->getRows($sSql);
        }
        return array($aRows, $iCnt);
    }


    /** Select data from table as hash.
     * @param string $sValue name of columns with values
     * @param array  $aCond  condition array
     * @return array hash ($id=>$value)
     */
    function getHash($sValue='name', $aCond=array(), $sSort='', $nLangId=0)
    {
        $nLangId = $nLangId? $nLangId: LANGUAGEID;
        $sCond = $this->_parseCond($aCond, $this->aFields);
        $sSql = 'SELECT '.$this->sId.', pd1.phrase title'.
            ' FROM '.$this->sTable.' AS '.$this->sAlias.
            ' LEFT JOIN phrase p1 ON p1.object_id='.$this->sAlias.'.carrier_id AND p1.object_type_id='.$this->nObjectType.'   AND p1.object_field="title" '.
            ' LEFT JOIN phrase_det pd1 ON pd1.phrase_id=p1.phrase_id AND pd1.language_id='.$nLangId.'  '.
            ($sCond?'  WHERE '.$sCond:'').
            '  ORDER BY '.($sSort?$sSort:$sValue);
        $aRows = $this->oDb->getRows($sSql);
        $aRes = array();
        foreach($aRows as $aRow)
            $aRes[$aRow[$this->sId]] = $aRow[$sValue];
        return $aRes;
    }

    /**
     * Расчитать доставку
     * @param $aParams (price, box_id, weight, region_id)
     * @return float
     */
    function calcDelivery($aParams) {

        $aParams['price'] = isset($aParams['price'])?floatval($aParams['price']):0;
        $aParams['box_id'] = isset($aParams['box_id'])?intval($aParams['box_id']):0;
        $aParams['region_id'] = isset($aParams['region_id'])?intval($aParams['region_id']):0;
        $aParams['carrier_id'] = isset($aParams['carrier_id'])?intval($aParams['carrier_id']):0;
        $aParams['weight'] = isset($aParams['weight'])?floatval($aParams['weight']):0;

        if (!$aParams['price']) $this->_addError('Price not set');
        if (!$aParams['box_id']) $this->_addError('Box not set');
        if (!$aParams['region_id']) $this->_addError('Region not set');
        if (!$aParams['carrier_id']) $this->_addError('Carrier not set');
        // Фактический вес (кг)
        if (!$aParams['weight']) $this->_addError('Weight not set');
        if ($this->getErrors()) return false;

        // "Оплачиваемый вес (кг)"
        // данные коробки
        $aBox = $this->oDb->getRow('SELECT * FROM box WHERE box_id='.$aParams['box_id']);
        if (!$aBox) { $this->_addError('Box not found'); return false; }
        // данные по доставке в регион перевозчиком
        $aCarrier = $this->oDb->getRow('SELECT * FROM carrier WHERE carrier_id='.$aParams['carrier_id']);
        if (!$aCarrier) { $this->_addError('Carrier rates not found'); return false; }
        // данные по доставке в регион перевозчиком
        $aRegionRate = $this->oDb->getRow('SELECT * FROM region_rate WHERE carrier_id='.$aParams['carrier_id'].' AND region_id='.$aParams['region_id']);
        if (!$aRegionRate) { $this->_addError('Region rates not found'); return false; }

        // =ЕСЛИ(B4>(C3*D3*E3/5000);B4;(C3*D3*E3/5000))
        $aParams['weightPay'] = $aBox['length']*$aBox['width']*$aBox['height'] / Conf::getSetting('FACT_WEIGHT');
        if ($aParams['weight'] > $aParams['weightPay'])
            $aParams['weightPay'] = $aParams['weight'];

        // "Комиссия (€)"
        // =ЕСЛИ(B2>9999;B2*G6;ЕСЛИ(B2>999;B2*G4;B2*G8))
        if ($aParams['price'] > 9999)
            $aParams['vat'] = $aParams['price'] * Conf::getSetting('VAT_FROM_10000');
        else if ($aParams['price'] > 999)
            $aParams['vat'] = $aParams['price'] * Conf::getSetting('VAT_1000_9999');
        else
            $aParams['vat'] = $aParams['price'] * Conf::getSetting('VAT_LESS_1000');

        // До Vantaa
        //='Ставки - Paris-Vantaa SVH (Lafa'!$D$25+($B$5-0,5)/0,5*'Ставки - Paris-Vantaa SVH (Lafa'!$B$25
        $aParams['tovantaa'] = Conf::getSetting('PARIS_VANTAA_FIRST_HALFKG') + ($aParams['weightPay'] - 0.5) / 0.5 * Conf::getSetting('PARIS_VANTAA_STEP');
        // До СПБ
        //=$B$4*'Ставки - Vantaa-СПБ (TFL)'!$B$3
        $aParams['tospb'] = $aParams['weight'] * Conf::getSetting('VANTAA_SPB_KG');
        // До клиента
        //=($B$5-1)*'Ставки - СПСР'!F4+'Ставки - СПСР'!C4
        $aParams['toclient'] = ($aParams['weightPay']-1) * $aRegionRate['kg_step_price'] / Conf::getSetting('RUR_EURO') + $aRegionRate['first_kg_price'] / Conf::getSetting('RUR_EURO');
        // Итого с/с, €
        //=$B$8+J2+K2+L2
        $aParams['total'] = (Conf::getSetting('USE_EXPORT_DOC')&&$aParams['price']>2999?Conf::getSetting('EXPORT_DOC_PRICE'):0) +
            $aParams['tovantaa'] + $aParams['tospb'] + $aParams['toclient'];
        // Итого счет GL, €
        //=(M2*$B$11)+$B$6
        $aParams['togl'] = ($aParams['total'] * $aCarrier['customs']) + $aParams['vat'];

        return round($aParams['togl'], 2);
    }

    function calcDeliverySum($iPurchaseId) {
        $aPurchase = $this->oDb->getRow('SELECT * FROM purchase WHERE purchase_id='.$iPurchaseId);
        if (!$aPurchase) return false;

        $aProducts = $this->oDb->getRows('SELECT pp.product_id, pp.price, p.box_id, p.weight FROM product2purchase pp LEFT JOIN product p USING(product_id)  WHERE pp.status!="deleted" AND pp.purchase_id='.$iPurchaseId);
        $fDelivery = 0;

        foreach($aProducts as $aProduct) {
            $fDelivery += $this->calcDelivery(array(
                'price' => $aProduct['price'],
                'box_id' => $aProduct['box_id'],
                'region_id' => 1, //$aProduct['region_id'],
                'carrier_id' => 1, //$aProduct['carrier_id'],
                'weight' => $aProduct['weight'],
            ));
        }
        return $fDelivery;
    }
    
}
?>