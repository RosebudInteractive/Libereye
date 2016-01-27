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
Conf::loadClass('Shop');
Conf::loadClass('Account');
Conf::loadClass('utils/Zoom');

$oShop = new Shop();
$oAccount = new Account();
$oZoom  	= new Zoom();

$iShopId = $oReq->getInt('id');
$aShop = array();
if($iShopId) {
    if ($oShop->load($iShopId))
        $aShop = $oShop->aData;
}else
    $oShop->aData = array('fname' => '', 'email' => '', 'shop_id' => '0');


if ($iShopId)
//validator fields
$aFields = array(
    'aShop[fname]'   => array('title'=>'Имя', 'def'=>'required',),
    'aShop[lname]'   => array('title'=>'Фамилия', 'def'=>'required',),
    //'aShop[email]'   => array('title'=>'Email', 'def'=>'email'),
    'aShop[phone]' 		=> array('title'=>'Телефон',    'def'=>'required'),
    'aShop[address]' 		=> array('title'=>'Адрес доставки',    'def'=>'required'),
    'aShop[timezone]' 		=> array('title'=>'Часовой пояс',    'def'=>'required'),
    'aShop[pass]'    => array('title'=>'Пароль', 'def'=>'password', 'optional' =>true),
    'pass_confirm'      => array('title'=>'Повторить пароль', 'def'=>'password', 'optional' =>true),
);     
else
//validator fields
$aFields = array(
    'aShop[fname]'   => array('title'=>'Имя', 'def'=>'required',),
    'aShop[lname]'   => array('title'=>'Фамилия', 'def'=>'required',),
    'aShop[email]'   => array('title'=>'Email', 'def'=>'email'),
    'aShop[phone]' 		=> array('title'=>'Телефон',    'def'=>'required'),
    'aShop[address]' 		=> array('title'=>'Адрес доставки',    'def'=>'required'),
    'aShop[timezone]' 		=> array('title'=>'Часовой пояс',    'def'=>'required'),
    'aShop[pass]'    => array('title'=>'Пароль', 'def'=>'password'),
    'pass_confirm'      => array('title'=>'Повторить пароль', 'def'=>'password'),
);     

//create validator
$oValidator = new Validator($aFields, array(array('aShop[pass]', 'pass_confirm', '=='))); 
    
// ========== processing actions ==========
switch($oReq->getAction())
{
    // === update ====
    case 'Сохранить':
        if ($oValidator->isValid($oReq->getAll()))
        {
            $oShop->aData = $oReq->getArray('aShop');
            $oShop->aData['shop_id'] = $iShopId;
            if (!$oShop->aData['pass']) unset($oShop->aData['pass']);
            else $oShop->aData['pass'] = md5($oShop->aData['pass']);

            // запретить править почту иначе слетят бронирования
            if (isset($oShop->aData['email']))
                unset($oShop->aData['email']);

            $oZoomUser = true;
            if ($aShop['status']=='seller' && $oShop->aData['fname']!=$aShop['fname'])
                $oZoomUser = $oZoom->updateUser(array('id'=>$aShop['zoom_id'], 'type'=>1, 'first_name'=>$oShop->aData['fname']));

          //  if ($oShop->isUniqueEmail($iShopId))
           // {
                if ($oZoomUser) {
                    if ($oShop->update())
                        $oReq->forward(conf::getUrl('admin.accounts'), conf::getMessages('account.updated'));
                    else
                        $aErrors = $oShop->getErrors();
                } else {
                    $aErrors = $oZoom->getErrors();
                }
           // }
            //else
                //$aErrors = $oShop->getErrors();
        }
        else
            $aErrors = $oValidator->getErrors();
        break; 
    case 'Создать':
        if ($oValidator->isValid($oReq->getAll()))
        {
            $oShop->aData = $oReq->getArray('aShop');
            $oShop->aData['pass'] = md5($oShop->aData['pass']);
            $oShop->aData['cdate'] = Database::date();

            if ($oShop->isUniqueEmail($iShopId))
            {
                $oZoomUser = true;
                if ($oShop->aData['status']=='seller')
                $oZoomUser = $oZoom->addUser(array(
                    'email' => $oShop->aData['email'],
                    'type' => 1,
                    'first_name' => $oShop->aData['fname'],
                    'timezone' => $oShop->aData['timezone'],
                ));

                if ($oZoomUser) {
                    if (property_exists($oZoom, 'id'))
                        $oShop->aData['zoom_id'] = $oZoomUser->id;
                    if ($oShop->insert())
                        $oReq->forward(conf::getUrl('admin.accounts'), conf::getMessages('account.created'));
                    else
                        $aErrors = $oShop->getErrors();
                } else {
                    $aErrors = $oZoom->getErrors();
                }
            }
            else
                $aErrors = $oShop->getErrors();

        }
        else
            $aErrors = $oValidator->getErrors();
        break; 
  
    case 'Удалить':    
        if($oShop->delete($oReq->getInt('id')))        
            $oReq->forward(conf::getUrl('admin.accounts'), conf::getMessages('account.deleted'));
        else 
            $aErrors = $oShop->getErrors();
    case 'Отмена':    
            $oReq->forward(conf::getUrl('admin.accounts'));
        break;
        
                
}

$aSellers = $oAccount->getHash('fname', array('shop_id'=>'='.$iShopId, 'status'=>'="seller"'), 'fname');

$oTpl->assign(array(
    'aShop' => $oShop->aData,
));

$oTpl->assignSrc(array(
    'aShopJson' => json_encode($oShop->aData),
    'aSellersJson' => json_encode($aSellers),
));

?>