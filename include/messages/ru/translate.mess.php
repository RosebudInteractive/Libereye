<?php
/** ============================================================
 * Переводы
 * @author Rudenko S.
 * @package core.config
 * ============================================================ */
global $_MSG;

$_MSG['ru'] = array(
    'days' =>  array('Пн','Вт','Ср','Чт','Пт','Cб','Вс'),
    'guestdates' => array( time()+86400 => '1 день',  time()+2*86400 => '2 дня',  time()+3*86400 => '3 дня',  time()+7*86400 => '1 неделя',  time()+30*86400 => '1 месяц', '00/00/0000'=>'бессрочно'),
);

$_MSG['en'] = array(
    'days' =>  array('Mon','Tue','Wed','Thu','Fri','Sat','Sun'),
    'guestdates' => array( time()+86400 => '1 day',  time()+2*86400 => '2 days',  time()+3*86400 => '3 days',  time()+7*86400 => '1 week',  time()+30*86400 => '1 month', '00/00/0000'=>'permanent'),
);

?>