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
$_CONF['db']['user'] = 'abeltchi_liberey';
$_CONF['db']['pass'] = '%VbT{]B1oIC!';
$_CONF['db']['name'] = 'abeltchi_libereye';

// root path
$_CONF['path'] = '/home/abeltchi/public_html/';

// Host name
$_CONF['host']  = 'www.libereye.com/';

// Protocols
$_CONF['http']  = 'https://';
$_CONF['https'] = 'https://';

// With www or without
$_CONF['www']   = '';

// Hosting type windows or unix
//$_CONF['hosting_type'] = 'windows'; 
$_CONF['hosting_type'] = 'unix';

?>