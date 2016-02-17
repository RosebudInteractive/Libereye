<?php
/** ============================================================
 * Part section.
 *   Area:    Carrier
 *   Part:    stats
 *   Section: sales
 * @author Rudenko S.
 * @package Carrier
 * ============================================================ */
Conf::loadClass('utils/Validator');
Conf::loadClass('utils/Sorter');
Conf::loadClass('utils/Pager');
Conf::loadClass('Carrier');
Conf::loadClass('Region');
Conf::loadClass('RegionRate');

$oCarrier = new Carrier();
$oRegion = new Region();
$oRegionRate = new RegionRate();


// ========== processing actions ==========
switch($oReq->getAction())
{
   case 'loadrates':
       $aRegions = $oRegion->getHash('title', array(), 'region_id asc');
       foreach($aRegions as $nRegionId=>$sRegion)
           $aCarrierRates[] = array(
               'region_id'=>$nRegionId,
               'title'=>$sRegion,
               'first_kg_price'=>'',
               'kg_step_price'=>'',
           );
       $aData = array();
       $aData['rates'] = $aCarrierRates;
       echo json_encode($aData);
       exit;
       break;
   case 'load':
		$iCarrierId = $oReq->getInt('id');
        if ($iCarrierId && $oCarrier->load($iCarrierId)) {

            $aRegions = $oRegion->getHash('title', array(), 'region_id asc');
            list($aRates,) = $oRegionRate->getList(array('carrier_id'=>'='.$iCarrierId, 'region_id'=>'IN('.join(',', array_keys($aRegions)).')'));
            $aRatesRegions = $aCarrierRates = array();
            foreach($aRates as $aRate)
                if ($aRate['region_id'])
                    $aRatesRegions[$aRate['region_id']] = $aRate;
            foreach($aRegions as $nRegionId=>$sRegion)
                $aCarrierRates[] = array(
                    'region_id'=>$nRegionId,
                    'title'=>$sRegion,
                    'first_kg_price'=>isset($aRatesRegions[$nRegionId])?$aRatesRegions[$nRegionId]['first_kg_price']:'',
                    'kg_step_price'=>isset($aRatesRegions[$nRegionId])?$aRatesRegions[$nRegionId]['kg_step_price']:'',
                );
            $oCarrier->aData['rates'] = $aCarrierRates;

            echo json_encode($oCarrier->aData);
            exit;
        }
		echo '{"error":"Перевозчик не найден"}';
		exit;
		break;

    case 'get':
		// search
		$aCond = array();
		if (isset($_GET['filter']))
		{
            if (isset($_GET['filter']['value']) && $_GET['filter']['value'])
                $aCond['{#title}'] = 'pd1.phrase LIKE "%'.Database::escapeLike($_GET['filter']['value']).'%"';
            if (isset($_GET['filter']['title']) && $_GET['filter']['title'])
                $aCond['{#title}'] = 'pd1.phrase LIKE "%'.Database::escapeLike($_GET['filter']['title']).'%"';
            if (isset($_GET['filter']['tax']) && $_GET['filter']['tax'])
                $aCond['tax'] = '="'.Database::escape($_GET['filter']['tax']).'"';
            if (isset($_GET['filter']['customs']) && $_GET['filter']['customs'])
                $aCond['customs'] = '="'.Database::escape($_GET['filter']['customs']).'"';
            if (isset($_GET['filter']['box_charge']) && $_GET['filter']['box_charge'])
                $aCond['box_charge'] = '="'.Database::escape($_GET['filter']['box_charge']).'"';
            if (isset($_GET['filter']['insurance']) && $_GET['filter']['insurance'])
                $aCond['insurance'] = '="'.Database::escape($_GET['filter']['insurance']).'"';
        }


		$iPos = $oReq->getInt('start');
		$iPageSize = $oReq->getInt('count', 50);
		$aSort = $oReq->getArray('sort' , array('carrier_id'=>'desc'));
		list($aItems, $iCnt) = $oCarrier->getListOffset($aCond, $iPos, $iPageSize, str_replace('=', ' ', http_build_query($aSort, ' ', ', ')));

        if (!$oReq->get('suggest'))
            echo '{"pos":'.$iPos.', "total_count":"'.$iCnt.'","data":'.json_encode($aItems).'}';
        else {
            $aCarriersSuggest = array();
            foreach($aItems as $aItem){
                $aCarriersSuggest[] = array("id"=>$aItem['carrier_id'],"value"=>$aItem['title']);
            }
            echo json_encode($aCarriersSuggest);
        }

		exit;
		break;

    case 'update':
    case 'create':
        $iCarrierId = $oReq->getInt('id');
        $aCarrier = $oReq->getArray('aCarrier');

        $aCarrier['tax'] = $oReq->getStrFloat($aCarrier['tax']);
        $aCarrier['customs'] = $oReq->getStrFloat($aCarrier['customs']);
        $aCarrier['box_charge'] = $oReq->getStrFloat($aCarrier['box_charge']);
        $aCarrier['insurance'] = $oReq->getStrFloat($aCarrier['insurance']);

        $oCarrier->aData = $aCarrier;
        if ($iCarrierId) {
            $oCarrier->aData['carrier_id'] = $iCarrierId;
            if (!$oCarrier->update(array(), true, array('title'))){
                $aErrors = $oCarrier->getErrors();
            }
        } else {
            if (!($iCarrierId = $oCarrier->insert(true, array('title')))){
                $aErrors = $oCarrier->getErrors();
            }
        }

        if (!$aErrors) {
            $aRegions = $oReq->getArray('aRegion');
            foreach($aRegions as $nRegionId=>$aRegion) {
                $aRegion['first_kg_price'] = $oReq->getStrFloat($aRegion['first_kg_price']);
                $aRegion['kg_step_price'] = $oReq->getStrFloat($aRegion['kg_step_price']);
                if ($oRegionRate->loadBy(array('carrier_id'=>'='.$iCarrierId, 'region_id'=>'='.$nRegionId))) {
                    $oRegionRate->aData['first_kg_price'] = $aRegion['first_kg_price'];
                    $oRegionRate->aData['kg_step_price'] = $aRegion['kg_step_price'];
                    if (!$oRegionRate->update())
                        $aErrors = $oRegionRate->getErrors();
                } else {
                    $oRegionRate->aData = array(
                      'carrier_id' => $iCarrierId,
                      'region_id' => $nRegionId,
                      'first_kg_price' => $aRegion['first_kg_price'],
                      'kg_step_price' => $aRegion['kg_step_price'],
                    );
                    if (!$oRegionRate->insert())
                        $aErrors = $oRegionRate->getErrors();
                }
            }
        }

        echo '{ "id":"'.$iCarrierId.'", "error":'.json_encode($aErrors).'}';
        exit;
        break;
   case 'destroy':
        $iCarrierId = $oReq->getInt('id');
   		if (!$oCarrier->delete($iCarrierId)){
            $aErrors = $oCarrier->getErrors();
   		}
        echo '{ "id":"'.$iCarrierId.'", "error":'.json_encode($aErrors).'}';exit;
   		break;
}


?>