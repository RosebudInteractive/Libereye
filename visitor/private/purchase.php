<?php
/** ============================================================
 * Part section.
 *   Area:    admin
 *   Part:    stats
 *   Section: sales
 * @author Rudenko S.
 * @package admin
 * ============================================================ */
Conf::loadClass('utils/Validator');
Conf::loadClass('Purchase');
Conf::loadClass('Booking');
Conf::loadClass('utils/file/Image');
Conf::loadClass('Image');

$oPurchase = new Purchase();
$oBooking = new Booking();
$oImage= new CImage();
$oImageObj = new Image();

$iPurchaseId = $oReq->getInt('id');
$aPurchase = array();
if($iPurchaseId){
    if ($oPurchase->loadBy(array('seller_id'=>'='.$oAccount->isLoggedIn(), 'purchase_id'=>'='.$iPurchaseId)))
        $aPurchase = $oPurchase->aData;
    else
        $oReq->forward('/');
}

$iBookingId = $oReq->getInt('bid');
$aBooking = array();
if($iBookingId){
    if ($oBooking->loadBy(array('seller_id'=>'='.$oAccount->isLoggedIn(), 'booking_id'=>'='.$iBookingId)))
        $aBooking = $oBooking->aData;
    else
        $oReq->forward('/');
}

if (!$iPurchaseId && !$iBookingId && $oReq->getAction()!='upload' && $oReq->getAction()!='delimage')
    $oReq->forward('/');

//validator fields
$aFields = array(
    'aPurchase[currency]'   => array('title'=>Conf::format('Currency of payment'), 'def'=>'required',),
    'aPurchase[price]'   => array('title'=>Conf::format('Price'), 'def'=>'money',),
    'aPurchase[vat]'   => array('title'=>Conf::format('VAT'), 'def'=>'float',),
    'aPurchase[delivery]'   => array('title'=>Conf::format('Cost of delivery'), 'def'=>'money',),
    'aPurchase[description]'   => array('title'=>Conf::format('Description'), 'def'=>'required',),
  //  'token'   => array('title'=>'token', 'def'=>'required',),
);

//create validator
$oValidator = new Validator($aFields);

// ========== processing actions ==========
switch($oReq->getAction())
{
    // === update ====
    case 'save':
        if ($oValidator->isValid($oReq->getAll()))
        {
            $oPurchase->aData = $oReq->getArray('aPurchase');
            $oPurchase->aData['purchase_id'] = $iPurchaseId;
            $oPurchase->aData['udate'] = Database::date();

            if (isset($_FILES['file_upload'])) {
                foreach ($_FILES['file_upload']['tmp_name'] as $nKey=>$tempFile) {
                    $fileTypes = array('jpg','jpeg','gif','png'); // File extensions
                    $fileParts = pathinfo($_FILES['file_upload']['name'][$nKey]);
                    if (in_array(strtolower($fileParts['extension']),$fileTypes)) {
                        if ($nImageId = $oImageObj->upload($tempFile, 'purchase', $iPurchaseId, $fileParts['extension'])) {
                            //$oImageObj->load($nImageId);
                        } else {
                            $aErrors[] =  Conf::format('Upload error', array($_FILES['file_upload']['name'][$nKey]));
                        }
                    } else {
                        $aErrors[] = Conf::format('Invalid file type', array($_FILES['file_upload']['name'][$nKey]));
                    }
                }
            }

            if (!$aErrors) {
                if ($oPurchase->update())
                    $oReq->forward('/'.$aLanguage['alias'].'/account/purchases/', Conf::format('Buying successfully saved'));
                else
                    $aErrors = $oPurchase->getErrors();
            }
        }
        else
            $aErrors = $oValidator->getErrors();
        break;
    case 'add':
        if ($oValidator->isValid($oReq->getAll()))
        {
            $oPurchase->aData = $oReq->getArray('aPurchase');
            $oPurchase->aData['cdate'] = Database::date();
            $oPurchase->aData['udate'] = Database::date();
            $oPurchase->aData['status'] = 'pending';
            $oPurchase->aData['account_id'] = $aBooking['account_id'];
            $oPurchase->aData['seller_id'] = $oAccount->isLoggedIn();
            $oPurchase->aData['booking_id'] = $aBooking['booking_id'];
           // $oPurchase->aData['currency'] = Conf::getSetting('CURRENCYCODE');

            if ($iPurchaseId = $oPurchase->insert()) {
                // добавляем залитые картинки
                $oImageObj->oDb->query('UPDATE image SET object_id='.$iPurchaseId.' WHERE token="'.$oReq->get('token').'" AND object_id=0 AND object_type="purchase"');

                // добавляем дедовским способом картинки
                if (isset($_FILES['file_upload'])) {
                    foreach ($_FILES['file_upload']['tmp_name'] as $nKey=>$tempFile) {
                        $fileTypes = array('jpg','jpeg','gif','png'); // File extensions
                        $fileParts = pathinfo($_FILES['file_upload']['name'][$nKey]);
                        if (in_array(strtolower($fileParts['extension']),$fileTypes)) {
                            if ($nImageId = $oImageObj->upload($tempFile, 'purchase', $iPurchaseId, $fileParts['extension'])) {
                                //$oImageObj->load($nImageId);
                            } else {
                                $aErrors[] =  Conf::format('Upload error', array($_FILES['file_upload']['name'][$nKey]));
                            }
                        } else {
                            $aErrors[] = Conf::format('Invalid file type', array($_FILES['file_upload']['name'][$nKey]));
                        }
                    }
                }

                if (!$aErrors)
                    $oReq->forward('/'.$aLanguage['alias'].'/account/purchases/', Conf::format('Buying successfully added'));


            } else
                $aErrors = $oPurchase->getErrors();
        }
        else
            $aErrors = $oValidator->getErrors();
        break;

    case 'del':
        if($oPurchase->delete($iPurchaseId))
            $oReq->forward('/'.$aLanguage['alias'].'/account/purchases/', 'Покупка успешно удалена');
        else
            $aErrors = $oPurchase->getErrors();
        break;

    case 'upload':
        $iProductId = $oReq->get('id');
        $verifyToken = md5('unique_salt' . $oReq->get('timestamp'));
        if (!empty($_FILES) && $oReq->get('token') == $verifyToken) {
            $tempFile = $_FILES['Filedata']['tmp_name'];
            $fileTypes = array('jpg','jpeg','gif','png'); // File extensions
            $fileParts = pathinfo($_FILES['Filedata']['name']);
            if (in_array(strtolower($fileParts['extension']),$fileTypes)) {
                if ($nImageId = $oImageObj->upload($tempFile, 'purchase', $iProductId, $fileParts['extension'], $verifyToken)) {
                    $oImageObj->load($nImageId);
                    /*$oImage->loadInfo(Conf::get('path').'images/product/'.$oImageObj->aData['name']);
                    $oImage->addWatermark(Conf::get('path').'/design/pic/watertext.png');*/
                    echo json_encode($oImageObj->aData);
                } else {
                    echo 'Ошибка при закачке';
                }
            } else {
                echo 'Недопустимый тип файла';
            }
        }
        exit;
        break;
    case 'delimage':
        $oImageObj->deleteBy($oReq->getInt('imageid'), array('object_id'=>'='.$iPurchaseId));
        exit;
}

// галерея
$sTimestamp = time();
$sToken = md5('unique_salt' . $sTimestamp);
$aImages = array();
if ($iPurchaseId) {
    list($aImages,) = $oImageObj->getList(array('object_id'=>'='.$iPurchaseId, 'object_type'=>'="purchase"'));
}

$oTpl->assign(array(
    'aPurchase' => $aPurchase,
    'aErrors' => $aErrors,
    'aBooking' => $aBooking,
    'sTimestamp' => $sTimestamp,
    'sToken' => $sToken,
    'aImages' => $aImages,
    'aConf' => array('CURRENCYCODE'=>Conf::getSetting('CURRENCYCODE')),
));
?>