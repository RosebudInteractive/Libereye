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
Conf::loadClass('utils/Sorter');
Conf::loadClass('utils/Pager');

// ----- sorter ----
$aSortFields = array('account_id', 'fname', 'email', 'cdate', 'last_login');
$aCurrSort = array($oReq->get('field', 'id') => $oReq->get('order', 'down'));
$oSorter = new Sorter($aSortFields, $aCurrSort);

// ----- pager -----
$iPage = $oReq->get('page', 1);
$iPageSize = Conf::getSetting('ADMIN_PAGESIZE');

// ========== processing actions ==========
switch($oReq->getAction())
{
    case 'del':
        if($oAdmin->delete($oReq->getInt('id')))
        {
            $oReq->forward($oUrl->getUrl(), conf::getMessages('admin.deleted'));
        }
        else
            $aErrors = $oAdmin->getErrors();
        break;
}

$sOrder = $oSorter->getOrder();
list($aAdmins, $iCnt) = $oAdmin->getList(array('status'=>'="admin"'), $iPage, $iPageSize, $sOrder);
$oPager = new Pager($iCnt, $iPage, $iPageSize);

$oTpl->assign(array(
    'aAdmins'  => $aAdmins,
    'aPaging'  => $oPager->getInfo($oUrl),
    'aSorting' => $oSorter->getSorting($oUrl),
));
?>