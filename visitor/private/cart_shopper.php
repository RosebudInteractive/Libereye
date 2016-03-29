<?php
/** ============================================================
 * Страница регистрации новых пользователей
 *   Area: visitor
 *   Part: private
 *   Sect: cart
 * @author Rudenko S.
 * @package visitor
 * ============================================================ */
Conf::loadClass('Account');
Conf::loadClass('Country');
Conf::loadClass('Purchase');
Conf::loadClass('Product');
Conf::loadClass('ShopSlot');
Conf::loadClass('Product2purchase');
Conf::loadClass('Brand');
Conf::loadClass('Image');
Conf::loadClass('Box');
Conf::loadClass('Price');
Conf::loadClass('Carrier');

$oCarrier = new Carrier();
$oCountry = new Country();
$oBrand = new Brand();
$oPurchase = new Purchase();
$oProduct = new Product();
$oShopSlot = new ShopSlot();
$oImage = new Image();
$oBox = new Box();
$oPrice = new Price();
$oProduct2purchase = new Product2purchase();
$iShopSlotId = $oReq->getInt('id');
$aPurchase = array();

// доступна только продавцам
if ($aAccount['status'] != 'seller') {
    $oReq->forward('/');
}

if ($oShopSlot->loadBy(array('seller_id'=>'='.$oAccount->isLoggedIn(), 'shop_slot_id'=>'='.$iShopSlotId)))
    $aShopSlot = $oShopSlot->aData;
else
    $oReq->forward('/');

if ($oPurchase->loadBy(array('shop_slot_id'=>'='.$iShopSlotId)))
    $aPurchase = $oPurchase->aData;
else {
    $aPurchase = $oPurchase->aData = array(
        'seller_id' => $oAccount->isLoggedIn(),
        'shop_slot_id'=> $iShopSlotId,
        'account_id'=> $aShopSlot['account_id'],
        'status'=> 'pending',
        'currency_id'=> 1,
        'cdate' => Database::date(),
        'udate' => Database::date(),
    );
    $aPurchase['purchase_id'] = $oPurchase->insert();
    $oPurchase->loadBy(array('shop_slot_id'=>'='.$iShopSlotId));
    $aPurchase = $oPurchase->aData;
}

switch ($oReq->getAction())
{
    case 'getproducts':
        $aCond = $aProducts = array();
        $aCond['{#title}'] = 'pd1.phrase LIKE "%'.Database::escapeLike($oReq->get('q')).'%" OR
            pd2.phrase LIKE "%'.Database::escapeLike($oReq->get('q')).'%"  OR
            pd3.phrase LIKE "%'.Database::escapeLike($oReq->get('q')).'%"';
        list($aItems, $iCnt) = $oProduct->getList($aCond, 0, 10);
        foreach($aItems as $aItem) {
            $aProducts[] = array(
                'id' => $aItem['product_id'],
                'name' => $aItem['title'],
                'img' => $aItem['image'],
                'color' => $aItem['color'],
                'brand' => $aItem['brand'],
                'price' => $aItem['price'],
            );
        }

        echo json_encode(array('errors'=>$aErrors, 'products'=>$aProducts));
        exit;
        // [{"name":"\u0422\u043e\u0432\u0430\u0440 1",
        //            "img":"http:\/\/placehold.it\/171x114",
        //            "color":"\u0426\u0432\u0435\u0442\u0430\u0441\u0442\u044b\u0439",
        //            "brand":"Apple","price":"100"}]
        break;

    case 'addproduct':
        $iProductId = $oReq->getInt('product');
        if ($oProduct->load($iProductId)) {
            if (!$oProduct2purchase->loadBy(array('product_id' => '='.$iProductId, 'purchase_id' => '='.$aPurchase['purchase_id'], 'status'=>'!="deleted"'))) {

                $oProduct2purchase->aData = array(
                    'product_id' => $iProductId,
                    'purchase_id' => $aPurchase['purchase_id'],
                    'amount' => 1,
                    'price' => $oProduct->aData['price'],
                    'price_sum' => $oProduct->aData['price'],
                );
                if ($oProduct2purchase->insert()) {

                    // пересчитываем сумму корзины и стоимость доставки
                    $iSum = $oProduct2purchase->getSum($aPurchase['purchase_id']);
                    $oPurchase->aData = array(
                        'purchase_id' => $aPurchase['purchase_id'],
                        'price' => $iSum,
                        'delivery' => $aPurchase['delivery_manual']?$aPurchase['delivery']:$oCarrier->calcDeliverySum($aPurchase['purchase_id'])
                    );
                    $oPurchase->update();

                } else
                    $aErrors = $oProduct2purchase->getErrors();
            } else
                $aErrors[] = Conf::format('Product already in shopper cart');

        } else
            $aErrors[] = Conf::format('Product not found');
        echo json_encode(array('errors'=>$aErrors, 'price'=>$iSum, 'sign'=>$aPurchase?$aPurchase['sign']:''));
        exit;
        break;

    case 'delproduct':
        $iProductId = $oReq->getInt('product');
        if ($oProduct->load($iProductId)) {
            if ($oProduct2purchase->loadBy(array('product_id' => '='.$iProductId, 'purchase_id' => '='.$aPurchase['purchase_id'], 'status'=>'="normal"'))) {
                $oProduct2purchase->aData = array('product2purchase_id'=>$oProduct2purchase->aData['product2purchase_id'], 'status'=>'deleted');
               if (!$oProduct2purchase->update())
                   $aErrors = $oProduct2purchase->getErrors();

                // пересчитываем сумму корзины и стоимость доставки
                $iSum = $oProduct2purchase->getSum($aPurchase['purchase_id']);
                $oPurchase->aData = array(
                    'purchase_id' => $aPurchase['purchase_id'],
                    'price' => $iSum,
                    'delivery' => $aPurchase['delivery_manual']?$aPurchase['delivery']:$oCarrier->calcDeliverySum($aPurchase['purchase_id'])
                );
                $oPurchase->update();

            } else
                $aErrors[] = Conf::format('Product not found in shopper cart');
        } else
            $aErrors[] = Conf::format('Product not found');
        echo json_encode(array('errors'=>$aErrors, 'price'=>$iSum, 'sign'=>$aPurchase?$aPurchase['sign']:''));
        exit;
        break;

    case 'boxselect':
        $iBoxId = $oReq->getInt('box');
        $iDelivery = $oReq->getStrFloat($oReq->getInt('delivery'));
        $iWeight = $oReq->getStrFloat($oReq->getInt('weight'));
       /* if ($iBoxId) {
            if ($oBox->load($iBoxId)) {

                $aDeliveryParams = array(
                    'price' => $aPurchase['price'],
                    'box_id' => $iBoxId,
                    'region_id' => 1, // сделать выбор
                    'carrier_id' => 1, // сделать выбор
                    'weight' => $iWeight,
                );

                $oPurchase->aData = array('purchase_id' => $aPurchase['purchase_id'], 'box_id' => $iBoxId, 'delivery' => $oCarrier->calcDelivery($aDeliveryParams));
                if (!$oPurchase->update())
                    $aErrors = $oPurchase->getErrors();
            } else
                $aErrors[] = Conf::format('Box not found');
        } else if ($iDelivery>=0) {
            $oPurchase->aData = array('purchase_id' => $aPurchase['purchase_id'], 'box_id' => 'NULL', 'delivery' => $iDelivery, 'delivery_manual'=>1);
            if (!$oPurchase->update(array(), array('box_id')))
                $aErrors = $oPurchase->getErrors();

        } else {
            $aErrors[] = Conf::format('Need set delivery value');
        }*/

        $oPurchase->aData = array('purchase_id' => $aPurchase['purchase_id'], 'box_id' => 'NULL', 'delivery' => $iDelivery, 'delivery_manual'=>$iDelivery>0?1:0);
        if (!$oPurchase->update(array(), array('box_id')))
            $aErrors = $oPurchase->getErrors();

        list($aProducts,) = $oProduct2purchase->getList(array('purchase_id'=>'='.$aPurchase['purchase_id'], 'status'=>'!="deleted"'));
        $iSum = 0;
        foreach($aProducts as $aProduct) {
            $iSum += $aProduct['amount']*$aProduct['price'];
        }
        $oPurchase->aData = array(
            'purchase_id' => $aPurchase['purchase_id'],
            'price' => $iSum,
            'delivery' => $aPurchase['delivery_manual']?$aPurchase['delivery']:$oCarrier->calcDeliverySum($aPurchase['purchase_id'])
        );
        $oPurchase->update();

        echo json_encode(array('errors'=>$aErrors, 'msg'=>Conf::format('Delivery price saved')));
        exit;
        break;

    case 'restoreproduct':
        $iProductId = $oReq->getInt('product');
        if ($oProduct->load($iProductId)) {
            if ($oProduct2purchase->loadBy(array('product_id' => '='.$iProductId, 'purchase_id' => '='.$aPurchase['purchase_id'], 'status'=>'="deleted"'))) {
                $oProduct2purchase->aData = array('product2purchase_id'=>$oProduct2purchase->aData['product2purchase_id'], 'status'=>'normal');
               if (!$oProduct2purchase->update())
                   $aErrors = $oProduct2purchase->getErrors();

                // пересчитываем сумму корзины и стоимость доставки
                $iSum = $oProduct2purchase->getSum($aPurchase['purchase_id']);
                $oPurchase->aData = array(
                    'purchase_id' => $aPurchase['purchase_id'],
                    'price' => $iSum,
                    'delivery' => $aPurchase['delivery_manual']?$aPurchase['delivery']:$oCarrier->calcDeliverySum($aPurchase['purchase_id'])
                );
                $oPurchase->update();

            } else
                $aErrors[] = Conf::format('Product not found in shopper cart');
        } else
            $aErrors[] = Conf::format('Product not found');
        echo json_encode(array('errors'=>$aErrors, 'price'=>$iSum, 'sign'=>$aPurchase?$aPurchase['sign']:''));
        exit;
        break;

    case 'newproduct':

        $aProduct = array(
            'brand_id' => $oReq->getInt('brand'),
            'title' => array(LANGUAGEID=>$oReq->get('name')),
            'color' => $oReq->get('color'),
            'article' => $oReq->get('article'),
            'box_id' => $oReq->getInt('box'),
            'weight' => $oReq->getStrFloat($oReq->get('weight')),
        );
        $aPrice = array(
            'price' => $oReq->getFloat('price'),
            'shop_id' => $aShopSlot['shop_id'],
            'currency_id' => 1, // euro
            'cdate' => Database::date(),
        );

        if (!$aProduct['title']) $aErrors[] = Conf::format('Name is required');
        if (!$aProduct['box_id']) $aErrors[] = Conf::format('Box is required');
        if (!$aPrice['price']) $aErrors[] = Conf::format('Price is required');

        if (!$aErrors) {

            $oProduct->aData = $aProduct;
            if ($iProductId = $oProduct->insert(true, array('title'))) {

                if (isset($_FILES['photo']) && isset($_FILES['photo']['tmp_name']) && $_FILES['photo']['tmp_name']) {
                    $sExt = strtolower(substr($_FILES['photo']['name'], strrpos($_FILES['photo']['name'], '.') + 1));
                    if ($iImageId = $oImage->upload($_FILES['photo']['tmp_name'], 'product', $iProductId, $sExt)) {
                        $aProduct['img'] = $oImage->aData['name'];
                    } else
                        $aErrors = $oImage->getErrors();
                }

                list($aProducts,) = $oProduct2purchase->getList(array('purchase_id'=>'='.$aPurchase['purchase_id'], 'status'=>'!="deleted"'));
                $iSum = 0;
                foreach($aProducts as $aItem) {
                    $iSum += $aItem['amount']*$aItem['price'];
                }

                $oProduct2purchase->aData = array(
                    'product_id' => $iProductId,
                    'purchase_id' => $aPurchase['purchase_id'],
                    'amount' => 1,
                    'price' => $aPrice['price'],
                    'price_sum' => $aPrice['price'],
                );
                if ($oProduct2purchase->insert()) {
                    // покупка
                    $oPurchase->aData = array(
                        'purchase_id' => $aPurchase['purchase_id'],
                        'currency_id' => $aPrice['currency_id'],
                        'price' => $iSum+$aPrice['price'],
                        'delivery' => $aPurchase['delivery_manual']?$aPurchase['delivery']:$oCarrier->calcDeliverySum($aPurchase['purchase_id'])
                    );
                    $oPurchase->update();

                    // прайс магазина
                    $aPrice['product_id'] = $iProductId;
                    $oPrice->aData = $aPrice;
                    if (!$oPrice->insert())
                        $aErrors = $oPrice->getErrors();
                } else
                    $aErrors = $oProduct2purchase->getErrors();

                list($aProducts,) = $oProduct2purchase->getList(array('product_id'=>'='.$iProductId, 'status'=>'!="deleted"'));
                $aProduct = $aProducts[0];


            } else
                $aErrors = $oProduct->getErrors();
        }


        echo json_encode(array('errors'=>$aErrors, 'product'=>$aProduct));
        exit;
        break;

}
list($aProducts,) = $oProduct2purchase->getList(array('purchase_id'=>'='.$aPurchase['purchase_id'], 'status'=>'!="deleted"'));

$oUserReg  	= new Account();
$oCountry  	= new Country();
$aErrors 	= array();
$aUserReg 	= $aAccount;

// Время со смещением временной зоны на сегодня
$sTimezoneOffset = isset($_COOKIE['timezone'])?$_COOKIE['timezone']:0;
$nTime = time();
$nUtcTime = $nTime + date("Z", $nTime);
$nTimeOffset = $nUtcTime - Conf::getTimezoneOffset(time(), $sTimezoneOffset);
$aPurchase['time_from'] = Database::date(strtotime($aPurchase['time_from']) - Conf::getTimezoneOffset($nTimeOffset, $sTimezoneOffset, $aPurchase['shop_time_shift']));
$aPurchase['time_to'] = Database::date(strtotime($aPurchase['time_to']) - Conf::getTimezoneOffset($nTimeOffset, $sTimezoneOffset, $aPurchase['shop_time_shift']));

$sTitle = Conf::format('Shopping cart');

//d($aProducts);
$oTpl->assignSrc(array(
    'aUserReg' 			=> $aUserReg,
    'aErrors'		=> $aErrors,
    'aPurchase'		=> $aPurchase,
    'aProducts'		=> $aProducts,
    'aCountries' => $oCountry->getHash('title',array(),'',$aLanguage['language_id']),
    'aBrands' => $oBrand->getHash('title',array('{#s2b.shop_id}'=>'s2b.shop_id='.$aShopSlot['shop_id']),'',1000,$aLanguage['language_id']),
    'aBoxes' => $oBox->getHash(),
));

?>
