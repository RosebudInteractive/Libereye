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
Conf::loadClass('Account');
Conf::loadClass('utils/Zoom');

$oAccount = new Account();
$oZoom  	= new Zoom();

$iAccountId = $oReq->getInt('id');
$aAccount = array();
if($iAccountId) {
    if ($oAccount->load($iAccountId))
        $aAccount = $oAccount->aData;
}else
    $oAccount->aData = array('fname' => '', 'email' => '', 'account_id' => '0');


if ($iAccountId)
//validator fields
$aFields = array(
    'aAccount[fname]'   => array('title'=>'Имя', 'def'=>'required',),
    'aAccount[lname]'   => array('title'=>'Фамилия', 'def'=>'required',),
    //'aAccount[email]'   => array('title'=>'Email', 'def'=>'email'),
    'aAccount[phone]' 		=> array('title'=>'Телефон',    'def'=>'required'),
    'aAccount[address]' 		=> array('title'=>'Адрес доставки',    'def'=>'required'),
    'aAccount[timezone]' 		=> array('title'=>'Часовой пояс',    'def'=>'required'),
    'aAccount[pass]'    => array('title'=>'Пароль', 'def'=>'password', 'optional' =>true),
    'pass_confirm'      => array('title'=>'Повторить пароль', 'def'=>'password', 'optional' =>true),
);     
else
//validator fields
$aFields = array(
    'aAccount[fname]'   => array('title'=>'Имя', 'def'=>'required',),
    'aAccount[lname]'   => array('title'=>'Фамилия', 'def'=>'required',),
    'aAccount[email]'   => array('title'=>'Email', 'def'=>'email'),
    'aAccount[phone]' 		=> array('title'=>'Телефон',    'def'=>'required'),
    'aAccount[address]' 		=> array('title'=>'Адрес доставки',    'def'=>'required'),
    'aAccount[timezone]' 		=> array('title'=>'Часовой пояс',    'def'=>'required'),
    'aAccount[pass]'    => array('title'=>'Пароль', 'def'=>'password'),
    'pass_confirm'      => array('title'=>'Повторить пароль', 'def'=>'password'),
);     

//create validator
$oValidator = new Validator($aFields, array(array('aAccount[pass]', 'pass_confirm', '=='))); 
    
// ========== processing actions ==========
switch($oReq->getAction())
{
    // === update ====
    case 'Сохранить':
        if ($oValidator->isValid($oReq->getAll()))
        {
            $oAccount->aData = $oReq->getArray('aAccount');
            $oAccount->aData['account_id'] = $iAccountId;
            if (!$oAccount->aData['pass']) unset($oAccount->aData['pass']);
            else $oAccount->aData['pass'] = md5($oAccount->aData['pass']);

            // запретить править почту иначе слетят бронирования
            if (isset($oAccount->aData['email']))
                unset($oAccount->aData['email']);

            $oZoomUser = true;
            if ($aAccount['status']=='seller' && $oAccount->aData['fname']!=$aAccount['fname'])
                $oZoomUser = $oZoom->updateUser(array('id'=>$aAccount['zoom_id'], 'type'=>1, 'first_name'=>$oAccount->aData['fname']));

          //  if ($oAccount->isUniqueEmail($iAccountId))
           // {
                if ($oZoomUser) {
                    if ($oAccount->update())
                        $oReq->forward(conf::getUrl('admin.accounts'), conf::getMessages('account.updated'));
                    else
                        $aErrors = $oAccount->getErrors();
                } else {
                    $aErrors = $oZoom->getErrors();
                }
           // }
            //else
                //$aErrors = $oAccount->getErrors();
        }
        else
            $aErrors = $oValidator->getErrors();
        break; 
    case 'Создать':
        if ($oValidator->isValid($oReq->getAll()))
        {
            $oAccount->aData = $oReq->getArray('aAccount');
            $oAccount->aData['pass'] = md5($oAccount->aData['pass']);
            $oAccount->aData['cdate'] = Database::date();

            if ($oAccount->isUniqueEmail($iAccountId))
            {
                $oZoomUser = true;
                if ($oAccount->aData['status']=='seller')
                $oZoomUser = $oZoom->addUser(array(
                    'email' => $oAccount->aData['email'],
                    'type' => 1,
                    'first_name' => $oAccount->aData['fname'],
                    'timezone' => $oAccount->aData['timezone'],
                ));

                if ($oZoomUser) {
                    if (property_exists($oZoom, 'id'))
                        $oAccount->aData['zoom_id'] = $oZoomUser->id;
                    if ($oAccount->insert())
                        $oReq->forward(conf::getUrl('admin.accounts'), conf::getMessages('account.created'));
                    else
                        $aErrors = $oAccount->getErrors();
                } else {
                    $aErrors = $oZoom->getErrors();
                }
            }
            else
                $aErrors = $oAccount->getErrors();

        }
        else
            $aErrors = $oValidator->getErrors();
        break; 
  
    case 'Удалить':    
        if($oAccount->delete($oReq->getInt('id')))        
            $oReq->forward(conf::getUrl('admin.accounts'), conf::getMessages('account.deleted'));
        else 
            $aErrors = $oAccount->getErrors();
    case 'Отмена':    
            $oReq->forward(conf::getUrl('admin.accounts'));
        break;
        
                
}

$oTpl->assign(array(
    'aAccount' => $oAccount->aData,
    'sJs'      => $oValidator->makeJS(),    
    'aStatuses'      => array('client'=>'client', 'seller'=>'seller', 'admin'=>'admin'),
    'aTimezones'		=> Conf::get('timezones'),
    'bLoadEditor' => true,
));
$oTpl->assignSrc(array(
    'sDescription' => $oAccount->aData['description']
));
?>