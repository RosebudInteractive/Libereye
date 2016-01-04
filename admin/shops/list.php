<?php
/** ============================================================
 * Part section.
 *   Area:    Shop
 *   Part:    stats
 *   Section: sales
 * @author Rudenko S.
 * @package Shop
 * ============================================================ */
Conf::loadClass('utils/Validator');
Conf::loadClass('utils/Sorter');
Conf::loadClass('utils/Pager');
Conf::loadClass('Shop');

$oShop = new Shop();


// ========== processing actions ==========
switch($oReq->getAction())
{
    case 'load':
        $iShopId = $oReq->getInt('id');
        if ($iShopId && $oShop->load($iShopId)) {
            echo json_encode($oShop->aData);
            exit;
        }
        echo '{"error":"Магазин не найден"}';
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

        $iPos = $oReq->getInt('start');
        $iPageSize = $oReq->getInt('count', 50);
        $aSort = $oReq->getArray('sort' , array('shop_id'=>'desc'));
        list($aItems, $iCnt) = $oShop->getListOffset($aCond, $iPos, $iPageSize, str_replace('=', ' ', http_build_query($aSort, ' ', ', ')));

        if (!$oReq->get('suggest'))
            echo '{"pos":'.$iPos.', "total_count":"'.$iCnt.'","data":'.json_encode($aItems).'}';
        else {
            $aShopsSuggest = array();
            foreach($aItems as $aItem){
                $aShopsSuggest[] = array("id"=>$aItem['shop_id'],"value"=>$aItem['title']);
            }
            echo json_encode($aShopsSuggest);
        }
        exit;
        break;

    case 'update':
    case 'create':
        $iShopId = $oReq->getInt('id');
        $aShop = $oReq->getArray('aShop');
        $oShop->aData = $aShop;
        if ($iShopId) {
            $oShop->aData['shop_id'] = $iShopId;
            if (!$oShop->update(array(), true, array('title', 'description', 'brand_desc'))){
                $aErrors = $oShop->getErrors();
            }
        } else {
            if (!($iShopId = $oShop->insert(true, array('title', 'description', 'brand_desc')))){
                $aErrors = $oShop->getErrors();
            }
        }
        echo '{ "id":"'.$iShopId.'", "error":'.json_encode($aErrors).'}';
        exit;
        break;
    case 'destroy':
        $iShopId = $oReq->getInt('id');
        if (!$oShop->delete($iShopId)){
            $aErrors = $oShop->getErrors();
        }
        echo '{ "id":"'.$iShopId.'", "error":'.json_encode($aErrors).'}';
        break;
}


?>