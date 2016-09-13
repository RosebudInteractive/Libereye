<?php
/** ============================================================
 * Area controller.
 *   Area: admin
 * @author Rudenko S.
 * @package admin
 * ============================================================ */
date_default_timezone_set('Europe/Moscow');
setlocale(LC_ALL, 'ru_RU');

require_once '../include/admin.inc.php';

Conf::loadClass('Admin');

//START initialisation
$oAdmin = new Admin();
//check login
$iAdminId = $oAdmin->isLoggedIn();
define('LANGUAGEID', 1);

if (!$iAdminId)
    $oReq->gotoUrl('admin.login');
else {
    $oAdmin->load($oAdmin->isLoggedIn());
    $aLoginUserData = $oAdmin->aData;
    unset($aLoginUserData['pass']);
}


?>

<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>Libereye Admin</title>
    <script>var USER = <?php echo json_encode($aLoginUserData); ?></script>
    <script language='JavaScript' src='/design/js/admin/config.js'></script>
	<!-- Webix Library -->
	<!--<script type="text/javascript" src="//cdn.webix.com/edge/webix.js"></script>
    <script src="/design/js/webix/codebase/i18n/ru.js" type="text/javascript" charset="utf-8"></script>
    <script type="text/javascript" charset="utf-8">webix.i18n.setLocale('ru-RU');</script>
	<link rel="stylesheet" href="//cdn.webix.com/edge/webix.css">
	<link rel="stylesheet/less" href="assets/theme.siberia.less">-->

    <script type="text/javascript" src="/design/js/webix/codebase/webix_debug.js"></script>
    <script src="/design/js/webix/codebase/i18n/ru.js" type="text/javascript" charset="utf-8"></script>
    <script type="text/javascript" charset="utf-8">webix.i18n.setLocale('ru-RU');</script>
    <link rel="stylesheet" href="/design/js/webix/codebase/webix.css">
    <link rel="stylesheet/less" href="assets/theme.siberia.less">

	<!-- The app's logic -->
	<script type="text/javascript" data-main="app" src="libs/require.js"></script>
	<script type="text/javascript">
		require.config({
			paths: { text:"libs/text" }
		});
	</script>

	 <!-- Development only -->
	 <script type="text/javascript" src="libs/less.min.js"></script>
</head>
<body></body>
</html>