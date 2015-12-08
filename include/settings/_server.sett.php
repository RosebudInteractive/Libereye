<?php
/** ============================================================
 * Server specific settings (database, path, etc.)
 * @author Rudenko S.
 * @package core.config
 * ============================================================ */
global $_CONF;

$_CONF = array();

// DateBase settings
$_CONF['db']['host'] = 'localhost';
$_CONF['db']['user'] = 'libereye';
$_CONF['db']['pass'] = '7iFf6Jve';
$_CONF['db']['name'] = 'libereye';

// root path
$_CONF['path'] = '/home/vip/data/www/libereye.optimum.by/';

// Host name
$_CONF['host']  = 'libereye.optimum.by/';

// Protocols
$_CONF['http']  = 'http://';
$_CONF['https'] = 'https://';

// With www or without
$_CONF['www']   = '';

// Hosting type windows or unix
//$_CONF['hosting_type'] = 'windows'; 
$_CONF['hosting_type'] = 'unix';

?>