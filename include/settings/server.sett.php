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
$_CONF['db']['user'] = 'root';
$_CONF['db']['pass'] = '111111';
$_CONF['db']['name'] = 'libereye2';
$_CONF['memcache'] = array(
    'enable' => true,
    'host' => 'localhost',
    'port' => 11211,
    'expire' => 10
);

// root path
$_CONF['path'] = 'd:/Server/domains/libereye2/Libereye/';

// Host name
$_CONF['host']  = 'libereye.it/';

// Protocols
$_CONF['http']  = 'http://';
$_CONF['https'] = 'https://';

// With www or without
$_CONF['www']   = '';

// Hosting type windows or unix
$_CONF['hosting_type'] = 'windows'; 
//$_CONF['hosting_type'] = 'unix';

?>