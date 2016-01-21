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

// facebook api
$_CONF['facebook_app_id'] = '1037221113009513';
$_CONF['facebook_app_secret'] = 'd06a518678556eb93a39c3dcaae5d05b';

// vk api
$_CONF['vk_app_id'] = '5233032';
$_CONF['vk_app_secret'] = 'OMP1lwfHMENBWQ7Lpjcl'; 

// google api
$_CONF['google_app_id'] = 'AIzaSyBxofvhjTDmlxHcXFzAGvHyS0kjMRthd_A';
$_CONF['google_client_id'] = '958156450156-vq1irfc7amfeb240r4bspfd0b3pguhaj.apps.googleusercontent.com';
$_CONF['google_app_secret'] = 'ZKZTRZv0PN6uuvC9FOmYbJsD';

?>