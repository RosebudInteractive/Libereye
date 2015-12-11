<?php
/** ============================================================
 * Server specific settings (database, path, etc.)
 * @author Rudenko S.
 * @package core.config
 * ============================================================ */
global $_CONF;

$_CONF = array();

$_CONF['db']['host'] = 'localhost';
$_CONF['db']['user'] = 'abeltchi_liberey';
$_CONF['db']['pass'] = '%VbT{]B1oIC!';
$_CONF['db']['name'] = 'abeltchi_dev_libereye';
$_CONF['memcache'] = array(
    'enable' => false,
    'host' => 'localhost',
    'port' => 11211,
    'expire' => 10
);

// root path
$_CONF['path'] = '/home/abeltchi/sites/dev.libereye.com/';

// Host name
$_CONF['host']  = 'dev.libereye.com/';

// Protocols
$_CONF['http']  = 'http://';
$_CONF['https'] = 'https://';

// With www or without
$_CONF['www']   = '';

// Hosting type windows or unix
//$_CONF['hosting_type'] = 'windows'; 
$_CONF['hosting_type'] = 'unix';

?>