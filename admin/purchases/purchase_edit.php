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

$oAccount = new Account();

$iAccountId = $oReq->getInt('id'); 
if($iAccountId)
    $oAccount->load($iAccountId);
else 
    $oAccount->aData = array('fname' => '', 'email' => '', 'account_id' => '0');    

if ($iAccountId)
//validator fields
$aFields = array(
    'aAccount[fname]'   => array('title'=>'Имя', 'def'=>'required',),
    'aAccount[email]'   => array('title'=>'Email', 'def'=>'email'),
    'aAccount[pass]'    => array('title'=>'Пароль', 'def'=>'password', 'optional' =>true),
    'pass_confirm'      => array('title'=>'Повторить пароль', 'def'=>'password', 'optional' =>true),
);     
else
//validator fields
$aFields = array(
    'aAccount[fname]'   => array('title'=>'Имя', 'def'=>'required',),
    'aAccount[email]'   => array('title'=>'Email', 'def'=>'email'),
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

            if ($oAccount->isUniqueEmail($iAccountId))
            {                                
                    if ($oAccount->update())
                        $oReq->forward(conf::getUrl('admin.accounts'), conf::getMessages('account.updated'));
                    else 
                        $aErrors = $oAccount->getErrors();
            }
            else
                $aErrors = $oAccount->getErrors();
        }
        else
            $aErrors = $oValidator->getErrors();
        break; 
    case 'Создать':
        if ($oValidator->isValid($oReq->getAll()))
        {
            $oAccount->aData = $oReq->getArray('aAccount');
            $oAccount->aData['cdate'] = Database::date();
            if ($oAccount->isUniqueEmail($iAccountId))
            {                                
                    if ($oAccount->insert())
                        $oReq->forward(conf::getUrl('admin.accounts'), conf::getMessages('account.created'));
                    else 
                        $aErrors = $oAccount->getErrors();
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
));
?>