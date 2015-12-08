<?php
/** ============================================================
* Site urls map.
* @author Rudenko S.
* @package core.config
* ============================================================ */
global $_URL;

// ========== AREA:admin ==========
$_URL['admin'] = $_CONF['url'].'admin/';
    
    // ===== PAGES =====
    $_URL['admin.login']                = $_CONF['url.admin'].'login.php';
    $_URL['admin.logout']               = $_CONF['url.admin'].'logout.php';

// ========== AREA:visitor ==========
$_URL['visitor'] = $_CONF['url'].'visitor/';

    $_URL['visitor.public.item']         = $_CONF['host'].'/item/$1';

?>