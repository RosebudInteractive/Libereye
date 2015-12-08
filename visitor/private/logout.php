<?php
/** ============================================================
 *   Area: visitor
 *   Page: logout
 * @author Rudenko S.
 * @package visitor
 * ============================================================ */
Conf::loadClass('Account');
$oAccount = new Account();
$oAccount->logout();
$oReq->forward('/'.$aLanguage['alias'].'/');

?>