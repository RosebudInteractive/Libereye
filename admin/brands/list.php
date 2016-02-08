<?php
/** ============================================================
 * Part section.
 *   Area:    Brand
 *   Part:    stats
 *   Section: sales
 * @author Rudenko S.
 * @package Brand
 * ============================================================ */
Conf::loadClass('utils/Validator');
Conf::loadClass('utils/Sorter');
Conf::loadClass('utils/Pager');
Conf::loadClass('Brand');
Conf::loadClass('Shop2brand');

$oBrand = new Brand();
$oShop2brand = new Shop2brand();


// ========== processing actions ==========
switch($oReq->getAction())
{
   case 'load':
		$iBrandId = $oReq->getInt('id');
        if ($iBrandId && $oBrand->load($iBrandId)) {
            echo json_encode($oBrand->aData);
            exit;
        }
		echo '{"error":"Бренд не найден"}';
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
            if (isset($_GET['filter']['description']) && $_GET['filter']['description'])
                $aCond['{#description}'] = 'pd2.phrase LIKE "%'.Database::escapeLike($_GET['filter']['description']).'%"';
		}

        if ($oReq->getInt('shopOut')) { // не входящие в магазин
            $aCond['{#not_shop_id}'] = 'brand_id NOT IN(select brand_id from shop2brand where shop_id = '.$oReq->getInt('shopOut').')';
        }
        if ($oReq->getInt('shopIn')) { // входящие в магазин
            $aCond['{#shop_id}'] = 's2b.shop_id = '.$oReq->getInt('shopIn').' AND s2b.brand_id IS NOT NULL';
        }

		$iPos = $oReq->getInt('start');
		$iPageSize = $oReq->getInt('count', 50);
		$aSort = $oReq->getArray('sort' , array('brand_id'=>'desc'));
		list($aItems, $iCnt) = $oBrand->getListOffset($aCond, $iPos, $iPageSize, str_replace('=', ' ', http_build_query($aSort, ' ', ', ')));

        if (!$oReq->get('suggest'))
            echo '{"pos":'.$iPos.', "total_count":"'.$iCnt.'","data":'.json_encode($aItems).'}';
        else {
            $aBrandsSuggest = array();
            foreach($aItems as $aItem){
                $aBrandsSuggest[] = array("id"=>$aItem['brand_id'],"value"=>$aItem['title']);
            }
            echo json_encode($aBrandsSuggest);
        }

		exit;
		break;

    case 'update':
    case 'create':
        $iBrandId = $oReq->getInt('id');
        $aBrand = $oReq->getArray('aBrand');
        $oBrand->aData = $aBrand;
        if ($iBrandId) {
            $oBrand->aData['brand_id'] = $iBrandId;
            if (!$oBrand->update(array(), true, array('title', 'description'))){
                $aErrors = $oBrand->getErrors();
            }
        } else {
            if (!($iBrandId = $oBrand->insert(true, array('title', 'description')))){
                $aErrors = $oBrand->getErrors();
            }
        }
        echo '{ "id":"'.$iBrandId.'", "error":'.json_encode($aErrors).'}';
        exit;
        break;
   case 'destroy':
        $iBrandId = $oReq->getInt('id');
   		if (!$oBrand->delete($iBrandId)){
            $aErrors = $oBrand->getErrors();
   		}
        echo '{ "id":"'.$iBrandId.'", "error":'.json_encode($aErrors).'}';exit;
   		break;
  case 'brand2shop':
        $aBrands = array_map('intval', explode(',',$oReq->get('id')));
        $iShopId = $oReq->getInt('shop_id');
        if ($aBrands && $iShopId) {
            if ($oReq->get('remove')) {
                if (!$oShop2brand->deleteByCond(array('shop_id'=>'='.$iShopId, 'brand_id'=>'IN('.join(',',$aBrands).')'))) {
                    $aErrors = $oBrand->getErrors();
                }
            }
            else {
                foreach($aBrands as $nBrandId) {
                    if (!$oShop2brand->loadBy(array('shop_id'=>'='.$iShopId, 'brand_id'=>'='.$nBrandId))) {
                        $oShop2brand->aData = array('shop_id'=>$iShopId, 'brand_id'=>$nBrandId);
                        if (!$oShop2brand->insert())
                            $aErrors+= $oShop2brand->getErrors();
                    }
                }
            }
        }
        echo '{"error":'.json_encode($aErrors).'}';exit;
   		break;
}


?>