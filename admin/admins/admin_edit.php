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

$iAdminId = $oReq->getInt('id'); 
if($iAdminId)
    $oAdmin->load($iAdminId);
else 
    $oAdmin->aData = array('fname' => '', 'email' => '', 'account_id' => '0');    

if ($iAdminId)
//validator fields
$aFields = array(
    'aAccount[fname]'   => array('title'=>'Имя', 'def'=>'required',),
    'aAccount[email]'   => array('title'=>'Логин', 'def'=>'required'),
    'aAccount[pass]'    => array('title'=>'Пароль', 'def'=>'password', 'optional' =>true),
    'pass_confirm'      => array('title'=>'Повторить пароль', 'def'=>'password', 'optional' =>true),
);     
else
//validator fields
$aFields = array(
    'aAccount[fname]'   => array('title'=>'Имя', 'def'=>'required',),
    'aAccount[email]'   => array('title'=>'Логин', 'def'=>'required'),
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
            $oAdmin->aData = $oReq->getArray('aAccount');
            $oAdmin->aData['account_id'] = $iAdminId;
            if (!$oAdmin->aData['pass']) unset($oAdmin->aData['pass']);
            else $oAdmin->aData['pass'] = md5($oAdmin->aData['pass']);                       
            if ($oAdmin->isUnique($iAdminId))
            {                                
                    if ($oAdmin->update())
                        $oReq->forward(conf::getUrl('admin.admins'), conf::getMessages('admin.updated'));
                    else 
                        $aErrors = $oAdmin->getErrors();
            }
            else
                $aErrors = $oAdmin->getErrors();
        }
        else
            $aErrors = $oValidator->getErrors();
        break; 
    case 'Создать':
        if ($oValidator->isValid($oReq->getAll()))
        {
            $oAdmin->aData = $oReq->getArray('aAccount');
            if ($oAdmin->isUnique($iAdminId))
            {                                
                    if ($oAdmin->insert())
                        $oReq->forward(conf::getUrl('admin.admins'), conf::getMessages('admin.created'));
                    else 
                        $aErrors = $oAdmin->getErrors();
            }
            else
                $aErrors = $oAdmin->getErrors();
        }
        else
            $aErrors = $oValidator->getErrors();
        break; 
  
    case 'Удалить':    
        if($oAdmin->delete($oReq->getInt('id')))        
            $oReq->forward(conf::getUrl('admin.admins'), conf::getMessages('admin.deleted'));
        else 
            $aErrors = $oAdmin->getErrors();
    case 'Отмена':    
            $oReq->forward(conf::getUrl('admin.admins'));
        break;
        
                
}

$oTpl->assign(array(
    'aAccount' => $oAdmin->aData,
    'sJs'      => $oValidator->makeJS(),    
));
?>