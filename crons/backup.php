<?php
/* Крон-таск для создания бекапов бд */

// Общие настройки
set_time_limit(0);
date_default_timezone_set('Europe/Moscow');
$bNoSession = true;

// Необходимые классы
require_once '../include/visitor.inc.php';

$aConf = Conf::get('db');
$backupFile = Conf::get('path').'../backup/'. $aConf['name'] . '_' . date("Y-m-d") . '.gz';
$command = "mysqldump --opt -h ".$aConf['host']." -u ".$aConf['user']." -p".$aConf['pass']." ".$aConf['name']." | gzip > $backupFile";
if (file_exists($backupFile))
    echo 'backup created: '.$backupFile;
else
    echo 'failed creating backup: '.$backupFile;

// удаляем старее 10 дней
$sOldBackupFile = Conf::get('path').'../backup/'. $aConf['name'] . '_' . date("Y-m-d", time()-10*86400) . '.gz';
if (file_exists($sOldBackupFile))
    unlink($sOldBackupFile);



?>