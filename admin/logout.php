<?php
/** ============================================================
 * Stand-alone page
 *   Area: admin
 *   Page: logout
 * @author Rudenko S.
 * @package admin
 * ============================================================ */
require_once '../include/admin.inc.php';

Conf::loadClass('Admin');

$oAdmin = &new Admin();
$oAdmin->logout();

$oReq->gotoUrl('admin.login');
?>