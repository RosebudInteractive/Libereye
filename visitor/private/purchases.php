<?php
/** ============================================================
 * Страница Покупки клиентов
 *   Area: admin
 *   Sect: register
 * @author Rudenko S.
 * @package visitor
 * ============================================================ */
Conf::loadClass('Purchase');
Conf::loadClass('utils/Sorter');
Conf::loadClass('utils/Pager');
Conf::loadClass('Image');

// доступна только продавцам
if ($aAccount['status'] != 'seller') {
    $oReq->forward('/');
}

$oPurchase  	= new Purchase();
$oImageObj = new Image();
$aErrors 	= array();
$iPage = $oReq->get('page', 1);

switch ($oReq->getAction())
{
    case 'del':
        $iPurchaseId = $oReq->getInt('id');
        if (!$iPurchaseId)
            $aErrors[] = 'Не указан номер покупки';
        elseif (!$oPurchase->loadBy(array('seller_id'=>'='.$oAccount->isLoggedIn(), 'purchase_id'=>'='.$iPurchaseId)))
            $aErrors[] = 'Покупка не найдена';

        if (!$aErrors) {
            if (!$oPurchase->delete($oPurchase->aData['purchase_id']))
                $aErrors = $oBooking->getErrors();
            else
                $oReq->forward('/account/purchases/?page='.$iPage, 'Покупка успешно удалена');
        }
        break;
}


// ----- sorter ----
$aSortFields = array('purchase_id');
$aCurrSort = array($oReq->get('field', 'purchase_id') => $oReq->get('order', 'down'));
$oSorter = new Sorter($aSortFields, $aCurrSort);
$aSorting = $oSorter->getSorting($oUrl);
$oUrl->aParams['order'] = $oReq->get('order', 'down');

// ----- pager -----
$iPage = $oReq->get('page', 1);
$iPageSize = 10;
$sOrder = $oSorter->getOrder();
list($aPurchases, $iCnt) = $oPurchase->getList(array('seller_id'=>'='.$oAccount->isLoggedIn()), $iPage, $iPageSize, 'purchase_id desc');
$oPager = new Pager($iCnt, $iPage, $iPageSize);
foreach($aPurchases as $nKey=>$aPurchase) {
    $aPurchases[$nKey]['amount'] = $oPurchase->getAmount($aPurchase);
}

$aPurchaseImages = array();
if ($aPurchases) {
    list($aImages,) = $oImageObj->getList(array('object_id'=>'IN('.$oPurchase->getListIds($aPurchases, true).')', 'object_type'=>'="purchase"'));
    foreach($aImages as $aImage)
        $aPurchaseImages[$aImage['object_id']][] = $aImage;
}

$sTitle = 'Покупки клиентов';
$oTpl->assignSrc(array(
    'aErrors'		=> $aErrors,
    'aPurchases'	=> $aPurchases,
    'aPaging'  => $oPager->getInfoCustom('/account/purchases/?page='),
    'aSorting' => $aSorting,
    'aErrors' => $aErrors,
    'aPurchaseImages' => $aPurchaseImages,
));

?>
