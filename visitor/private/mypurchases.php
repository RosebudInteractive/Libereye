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
Conf::loadClass('utils/Paypal');
Conf::loadClass('utils/Ogone');
Conf::loadClass('Image');
Conf::loadClass('utils/SplClassLoader');

// ogone payments include
$myLibLoader = new SplClassLoader('Ogone', Conf::get('path').'include/classes/utils');
$myLibLoader->register();
use Ogone\DirectLink\DirectLinkPaymentRequest;
use Ogone\Passphrase;
use Ogone\ShaComposer\AllParametersShaComposer;
use Ogone\DirectLink\Alias;
use Ogone\Ecommerce\EcommercePaymentRequest;
use Ogone\FormGenerator\SimpleFormGenerator;
use Ogone\Ecommerce\EcommercePaymentResponse;

// доступна только покупателям
if ($aAccount['status'] != 'client') {
    $oReq->forward('/'.($aLanguage['alias']).'/');
}

$oPurchase  	= new Purchase();
$oImageObj = new Image();
$oPaypal = new Paypal();
$aErrors 	= array();


switch ($oReq->getAction())
{
    case 'pay':
        $iPurchaseId = $oReq->getInt('id');
        if ($iPurchaseId && $oPurchase->loadBy(array('account_id'=>'='.$oAccount->isLoggedIn(), 'purchase_id'=>'='.$iPurchaseId, 'status'=>'!="paid"'))) {

            $aPurchase = $oPurchase->aData;

            // Параметры нашего запроса
            $requestParams = array(
                'RETURNURL' => Conf::get('http').Conf::get('host').'/'.($aLanguage['alias']).'/account/mypurchases/?act=notify&success=true',
                'CANCELURL' => Conf::get('http').Conf::get('host').'/'.($aLanguage['alias']).'/account/mypurchases/?act=notify&success=false'
             );

            // данные о заказе
            $fAmount = $oPurchase->getAmount($aPurchase);
            $orderParams = array(
                'PAYMENTREQUEST_0_AMT' => $fAmount,
                //'PAYMENTREQUEST_0_SHIPPINGAMT' => 100,
                'PAYMENTREQUEST_0_CURRENCYCODE' => $aPurchase['currency'],
                'PAYMENTREQUEST_0_ITEMAMT' => $fAmount,
                'PAYMENTREQUEST_0_INVNUM' => $aPurchase['purchase_id'],
            );

            // Описание
            $item = array(
                'L_PAYMENTREQUEST_0_NAME0' => '№'.$aPurchase['purchase_id'],
                'L_PAYMENTREQUEST_0_DESC0' => $aPurchase['description'],
                'L_PAYMENTREQUEST_0_AMT0' => $fAmount,
               // 'L_PAYMENTREQUEST_0_QTY0' => '1'
            );

            $oPaypal = new Paypal();
            $response = $oPaypal->request('SetExpressCheckout',$requestParams + $orderParams + $item);
//d($response);
            // Если запрос был успешным, мы получим токен в параметре TOKEN в ответе от PayPal.
            if(is_array($response) && isset($response['ACK']) && $response['ACK'] == 'Success') { // Запрос был успешно принят
                $token = $response['TOKEN'];
                header( 'Location: https://www.'.(Conf::getSetting('PAYPAL_TEST_MODE')?'sandbox.':'').'paypal.com/webscr?cmd=_express-checkout&useraction=commit&token=' . urlencode($token) );
                exit;
            } else {
                //d($response);
                if (isset($response['ACK']) && $response['ACK'] == 'Failure')
                    $aErrors[] = $response['L_SHORTMESSAGE0'];
                else
                    $aErrors = Conf::format('The request failed paypal');//$aErrors = $oPaypal->getErrors();//$aErrors = 'Ошибка запроса paypal';
            }


        } else
            $aErrors[] = Conf::format('Purchase Found');
        break;
    
    case 'notify':
        if( isset($_GET['token']) && !empty($_GET['token']) ) { // Токен присутствует
            // Получаем детали оплаты, включая информацию о покупателе.
            // Эти данные могут пригодиться в будущем для создания, к примеру, базы постоянных покупателей
            $checkoutDetails = $oPaypal->request('GetExpressCheckoutDetails', array('TOKEN' => $_GET['token']));
            $iPurchaseId = $checkoutDetails['PAYMENTREQUEST_0_INVNUM'];

            if ($oPurchase->loadBy(array('purchase_id'=>'='.$iPurchaseId))) {
                // Завершаем транзакцию
                $aPurchase = $oPurchase->aData;
                $fAmount = $oPurchase->getAmount($aPurchase);
                $requestParams = array(
                    'PAYMENTREQUEST_0_PAYMENTACTION' => 'Sale',
                    'PAYMENTREQUEST_0_ITEMAMT' => $checkoutDetails['PAYMENTREQUEST_0_ITEMAMT'],
                    'PAYMENTREQUEST_0_CURRENCYCODE' => $checkoutDetails['PAYMENTREQUEST_0_CURRENCYCODE'],
                    'PAYMENTREQUEST_0_AMT' => $checkoutDetails['PAYMENTREQUEST_0_AMT'],
                    'L_PAYMENTREQUEST_0_AMT0' => $checkoutDetails['L_PAYMENTREQUEST_0_AMT0'],
                    'PAYMENTREQUEST_0_INVNUM' => $checkoutDetails['PAYMENTREQUEST_0_INVNUM'],
                    'PAYERID' => isset($_GET['PayerID'])?$_GET['PayerID']:'',
                    'TOKEN' => $_GET['token']
                );

                $response = $oPaypal->request('DoExpressCheckoutPayment',$requestParams);
                if( is_array($response) && $response['ACK'] == 'Success') { // Оплата успешно проведена
                    // Здесь мы сохраняем ID транзакции, может пригодиться во внутреннем учете
                    $transactionId = $response['PAYMENTINFO_0_TRANSACTIONID'];
                    $oPurchase->aData = array('purchase_id'=>$iPurchaseId, 'status'=>'paid', 'track_id'=>$transactionId, 'udate'=>Database::date(), 'pay_system'=>'paypal');
                    $oPurchase->update();
                    $oReq->forward('/'.($aLanguage['alias']).'/account/mypurchases/', Conf::format('Purchase successfully paid', array($iPurchaseId)));
                } else
                    $aErrors[] = Conf::format('Error payment');
            } else
                $aErrors[] = Conf::format('Purchase Found');
        }
        break;
    case 'payOgone':

        $iPurchaseId = $oReq->getInt('id');
        if ($iPurchaseId && $oPurchase->loadBy(array('account_id'=>'='.$oAccount->isLoggedIn(), 'purchase_id'=>'='.$iPurchaseId, 'status'=>'!="paid"'))) {
            $aPurchase = $oPurchase->aData;
            $fAmount = $oPurchase->getAmount($aPurchase);

          /*  $passphrase = new Passphrase(Conf::getSetting('OGONE_SHAIN'));
            $shaComposer = new AllParametersShaComposer($passphrase);
            $directLinkRequest = new DirectLinkPaymentRequest($shaComposer);
            $directLinkRequest->setOrderid($aPurchase['purchase_id']);
            $alias = new Alias('a'.$aPurchase['purchase_id']);
            $directLinkRequest->setAlias($alias);
            $directLinkRequest->setPspid(Conf::getSetting('OGONE_PSPID'));
            $directLinkRequest->setUserId(Conf::getSetting('OGONE_API_USER'));
            $directLinkRequest->setPassword(Conf::getSetting('OGONE_API_PASS'));
            $directLinkRequest->setAmount(intval($fAmount*100));
            $directLinkRequest->setCurrency($aPurchase['currency']);
            $directLinkRequest->validate();
            $aParams = $directLinkRequest->toArray();
            $aParams['SHASIGN'] = $directLinkRequest->getShaSign();
            $oOgone = new Ogone();
            $response = $oOgone->request($directLinkRequest->getOgoneUri(), $aParams);
            d($response);*/

            $passphrase = new Passphrase(Conf::getSetting('OGONE_SHAIN'));
            $shaComposer = new AllParametersShaComposer($passphrase);
            $ecommercePaymentRequest = new EcommercePaymentRequest($shaComposer);

            // Optionally set Ogone uri, defaults to TEST account
            if (!Conf::getSetting('OGONE_TEST_MODE'))
                $ecommercePaymentRequest->setOgoneUri(EcommercePaymentRequest::PRODUCTION);

            // Set various params:
            $ecommercePaymentRequest->setOrderid($aPurchase['purchase_id']);
            $ecommercePaymentRequest->setAmount(intval($fAmount*100)); // in cents
            $ecommercePaymentRequest->setCurrency($aPurchase['currency']);
            $ecommercePaymentRequest->setPspid(Conf::getSetting('OGONE_PSPID'));
            $ecommercePaymentRequest->setAccepturl(Conf::get('http').Conf::get('host').'/'.($aLanguage['alias']).'/account/mypurchases/?act=notifyOgone&success=true');
            $ecommercePaymentRequest->setDeclineurl(Conf::get('http').Conf::get('host').'/'.($aLanguage['alias']).'/account/mypurchases/?act=notifyOgone');
            $ecommercePaymentRequest->setExceptionurl(Conf::get('http').Conf::get('host').'/'.($aLanguage['alias']).'/account/mypurchases/?act=notifyOgone&exception=true');
            $ecommercePaymentRequest->setCancelurl(Conf::get('http').Conf::get('host').'/'.($aLanguage['alias']).'/account/mypurchases/?act=notifyOgone&cancel=true');
            // ...
            $ecommercePaymentRequest->validate();
            $formGenerator = new SimpleFormGenerator;
            $html = $formGenerator->render($ecommercePaymentRequest);
            echo $html;
            exit;
        } else
            $aErrors[] = Conf::format('Purchase Found');
        break;

    case 'notifyOgone':
        $ecommercePaymentResponse = new EcommercePaymentResponse($_REQUEST);
        $passphrase = new Passphrase(Conf::getSetting('OGONE_SHAOUT'));
        $shaComposer = new AllParametersShaComposer($passphrase);
        $transactionId = $oReq->get('PAYID');
        $iPurchaseId = $oReq->get('orderID');

        if($ecommercePaymentResponse->isValid($shaComposer) && $ecommercePaymentResponse->isSuccessful()) {
            // handle payment confirmation
            // Здесь мы сохраняем ID транзакции, может пригодиться во внутреннем учете
            $oPurchase->aData = array('purchase_id'=>$iPurchaseId, 'status'=>'paid', 'track_id'=>$transactionId, 'udate'=>Database::date(), 'pay_system'=>'ogone');
            $oPurchase->update();
            $bResult = true;
        }
        else {
            // perform logic when the validation fails
            $aErrors[] = Conf::format('Error payment');
            $bResult = false;
        }

        // сохраняем все нотификации
        $oOgone = new Ogone();
        $oOgone->aData = array(
            'request' => 'notifyOgone:'.$bResult,
            'response' => serialize($_REQUEST),
            'account_id' => $oAccount->isLoggedIn(),
            'purchase_id' => $iPurchaseId,
            'cdate' => Database::date()
        );
        $oOgone->insert();

        if ($bResult)
            $oReq->forward('/'.($aLanguage['alias']).'/account/mypurchases/', Conf::format('Purchase successfully paid', array($iPurchaseId)));
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
list($aPurchases, $iCnt) = $oPurchase->getList(array('account_id'=>'='.$oAccount->isLoggedIn()), $iPage, $iPageSize, 'purchase_id desc');
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


$sTitle = Conf::format('My purchases');
$oTpl->assignSrc(array(
    'aErrors'		=> $aErrors,
    'aPurchases'	=> $aPurchases,
    'aPaging'  => $oPager->getInfoCustom('/'.($aLanguage['alias']).'/account/mypurchases/?page='),
    'aSorting' => $aSorting,
    'aErrors' => $aErrors,
    'aPurchaseImages' => $aPurchaseImages,
));

?>
