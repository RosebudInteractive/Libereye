<?php
/** ============================================================
 * Страница бронирования времени
 *   Area: admin
 *   Sect: register
 * @author Rudenko S.
 * @package visitor
 * ============================================================ */
Conf::loadClass('Account');
Conf::loadClass('ShopSlot');
Conf::loadClass('Shop');
Conf::loadClass('Purchase');
Conf::loadClass('Product');
Conf::loadClass('Product2purchase');
Conf::loadClass('utils/Validator');
Conf::loadClass('utils/file/Image');
Conf::loadClass('utils/mail/Mailer');

$oAccount  	= new Account();
$oShopSlot  	= new ShopSlot();
$oShop  	= new Shop();
$oPurchase  	= new Purchase();
$oProduct2purchase  	= new Product2purchase();
$oProduct  	= new Product();
$aErrors 	= array();
$sTimezoneOffset = isset($_COOKIE['timezone'])?$_COOKIE['timezone']:0;

// доступна только покупателям
if ($aAccount['status'] != 'client') {
    $oReq->forward('/');
}


switch ($oReq->getAction())
{
    case 'canceled':
    case 'missed':
    case 'restore':
        $iSlotId = $oReq->getInt('id');
        if (!$oShopSlot->loadBy(array('shop_slot_id'=>'="'.$iSlotId.'"', 'account_id'=>'='.$oAccount->isLoggedIn(), 'status'=>'IN('.($oReq->getAction()=='restore'?'"canceled","missed"':'"booked"').')')))
            $aErrors[] =  Conf::format('Slot is not found');
        else
            $aSlot = $oShopSlot->aData;

        if (!$aErrors) {
            $oShopSlot->aData = array(
                'shop_slot_id' => $iSlotId,
                'status' => $oReq->getAction()=='restore'?'booked':$oReq->getAction(),
                'udate' => Database::date(),
            );
            if (!$oShopSlot->update())
                $aErrors = $oShopSlot->getErrors();
        }
        echo json_encode(array('errors'=>$aErrors));
        exit;
        break;


    case 'delproduct':
        $iSum = 0; $aPurchase = array();
        $iProduct2purchaseId = $oReq->getInt('product');
        if ($oProduct2purchase->loadBy(array('{#account_id}'=>'pr.account_id='.$aAccount['account_id'], 'product2purchase_id' => '='.$iProduct2purchaseId, 'status'=>'="normal"'))) {
            $iPurchaseId = $oProduct2purchase->aData['purchase_id'];
            $oProduct2purchase->aData = array('product2purchase_id'=>$oProduct2purchase->aData['product2purchase_id'], 'status'=>'deleted');
            if ($oProduct2purchase->update()) {
                // пересчитываем сумму корзины и стоимость доставки
                $oPurchase->loadBy(array('purchase_id'=>'='.$iPurchaseId));
                $aPurchase = $oPurchase->aData;
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
            $aErrors[] = Conf::format('Product not found in shopper cart');
        echo json_encode(array('errors'=>$aErrors, 'price'=>$iSum, 'sign'=>$aPurchase?$aPurchase['sign']:''));
        exit;
        break;

    case 'restoreproduct':
        $iSum = 0; $aPurchase = array();
        $iProduct2purchaseId = $oReq->getInt('product');
        if ($oProduct2purchase->loadBy(array('{#account_id}'=>'pr.account_id='.$aAccount['account_id'], 'product2purchase_id' => '='.$iProduct2purchaseId, 'status'=>'="deleted"'))) {
            $iPurchaseId = $oProduct2purchase->aData['purchase_id'];
            $oProduct2purchase->aData = array('product2purchase_id'=>$oProduct2purchase->aData['product2purchase_id'], 'status'=>'normal');
            if ($oProduct2purchase->update()) {
                // пересчитываем сумму корзины и стоимость доставки
                $oPurchase->loadBy(array('purchase_id'=>'='.$iPurchaseId));
                $aPurchase = $oPurchase->aData;
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
            $aErrors[] = Conf::format('Product not found in shopper cart');
        echo json_encode(array('errors'=>$aErrors, 'price'=>$iSum, 'sign'=>$aPurchase?$aPurchase['sign']:''));
        exit;
        break;
}


// Время со смещением временной зоны на сегодня
$nTime = time();
$nUtcTime = $nTime + date("Z", $nTime);
$nTimeOffset = $nUtcTime - Conf::getTimezoneOffset(time(), $sTimezoneOffset);

list($aSlots, $iSlotsCnt) = $oShopSlot->getList(array('account_id'=>'='.$aAccount['account_id'], 'status'=>'="booked"'), 0, 0, 'ss.time_from');
$aShops = array();
$aSlotsNormal = array();
foreach ($aSlots as $nKey=>$aSlot) {
    if (!isset($aShops[$aSlot['shop_id']])) {
        $oShop->load($aSlot['shop_id'], LANGUAGEID);
        $aShops[$aSlot['shop_id']] = $oShop->aData;
    }

    $aSlots[$nKey]['time_from'] = strtotime($aSlot['time_from']) - Conf::getTimezoneOffset(strtotime($aSlot['time_from']), $sTimezoneOffset, $aShops[$aSlot['shop_id']]['time_shift']);
    $aSlots[$nKey]['time_to'] = strtotime($aSlot['time_to']) - Conf::getTimezoneOffset(strtotime($aSlot['time_to']), $sTimezoneOffset, $aShops[$aSlot['shop_id']]['time_shift']);
    $aSlots[$nKey]['shop'] =  $aShops[$aSlot['shop_id']]['title'];

    $aSlots[$nKey]['cancel_time'] =  $aSlots[$nKey]['time_from']-$nTimeOffset-86400; // отменять можно за сутки
    if ($aSlots[$nKey]['cancel_time']>0) {
        $nDays = floor(($aSlots[$nKey]['cancel_time']-$nTimeOffset)/86400);
        $nHours = floor((($aSlots[$nKey]['cancel_time']-$nTimeOffset)-86400*$nDays)/3600);
        $nMinutes = floor((($aSlots[$nKey]['cancel_time']-$nTimeOffset)-86400*$nDays-3600*$nHours)/60);
        $aSlots[$nKey]['cancel_time'] =  ($nDays>0?$nDays.Conf::format('d.').' ':'').($nHours>0?$nHours.Conf::format('h.').' ':'').($nMinutes>0?$nMinutes.Conf::format('m.'):'');
    }

    $aSlots[$nKey]['start_time'] =  $aSlots[$nKey]['time_from']-$nTimeOffset; // начинать митинг можно за час до начала и час вперед

    if ($aSlots[$nKey]['start_time'] > -3600 && $aSlots[$nKey]['start_time'] < 3600 ) {
        $aSlots[$nKey]['start_time'] = 1;
    } else if ($aSlots[$nKey]['start_time'] > 3600 ) {
        $nDays = floor($aSlots[$nKey]['start_time']/86400);
        $nHours = floor(($aSlots[$nKey]['start_time']-86400*$nDays)/3600);
        $nMinutes = floor(($aSlots[$nKey]['start_time']-86400*$nDays-3600*$nHours)/60);
        $aSlots[$nKey]['start_time'] =  ($nDays>0?$nDays.Conf::format('d.').' ':'').($nHours>0?$nHours.Conf::format('h.').' ':'').($nMinutes>0?$nMinutes.Conf::format('m.'):'');
    } else {
        $aSlots[$nKey]['start_time'] = 0;
    }


    $aSlotsNormal[date('Y-m-d', $aSlots[$nKey]['time_from'])][] = $aSlots[$nKey];
}

// Корзины
list($aPurchases,) = $oPurchase->getList(array('account_id'=>'='.$aAccount['account_id']), 0, 0, 'purchase_id desc ');
list($aProducts,) = $oProduct2purchase->getList(array('{#account_id}'=>'pr.account_id='.$aAccount['account_id'], 'status'=>'="normal"'), 0, 0, 'pr.purchase_id desc ');
$aCarts = array();


foreach($aProducts as $aProduct) {
    $aProduct['price'] = round($aProduct['price']+$aProduct['price']*Conf::getSetting('MARKUP')/100, 2);
    $aCarts[$aProduct['purchase_id']][] = $aProduct;
}
foreach($aPurchases as $nKey=>$aPurchase) {
    if (!isset($aShops[$aPurchase['shop_id']])) {
        $oShop->load($aPurchase['shop_id'], LANGUAGEID);
        $aShops[$aPurchase['shop_id']] = $oShop->aData;
    }
    $aPurchases[$nKey]['time_from'] = strtotime($aPurchase['time_from']) - Conf::getTimezoneOffset(strtotime($aPurchase['time_from']), $sTimezoneOffset, $aShops[$aPurchase['shop_id']]['time_shift']);
    $aPurchases[$nKey]['price'] = round($aPurchase['price']+$aPurchase['price']*Conf::getSetting('MARKUP')/100, 2);
}

$aMonths = array(
    '01' => Conf::format('January'),
    '02' => Conf::format('February'),
    '03' => Conf::format('March'),
    '04' => Conf::format('April'),
    '05' => Conf::format('May'),
    '06' => Conf::format('June'),
    '07' => Conf::format('July'),
    '08' => Conf::format('August'),
    '09' => Conf::format('September'),
    '10' => Conf::format('October'),
    '11' => Conf::format('November'),
    '12' => Conf::format('December')
);

// Title
$sTitle = Conf::format('Meetings');
$oTpl->assign(array(
    'aSlotsNormal' => $aSlotsNormal,
    'iSlotsCnt' => $iSlotsCnt,
    'iSlotsNewCnt' => $oShopSlot->getCount(array('account_id'=>'='.$aAccount['account_id'], 'status'=>'="booked"', 'time_from'=>'>"'.Database::date($nTimeOffset).'"')),
    'aMonths' => $aMonths,
    'aPurchases' => $aPurchases,
    'aCarts' => $aCarts,
    'iPurchasesNewCnt' => $oPurchase->getCount(array('account_id'=>'='.$aAccount['account_id'], 'udate'=>'>"'.Database::date(time()-86400*3).'"')),

));

?>
