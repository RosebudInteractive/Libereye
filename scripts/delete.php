<?php
set_time_limit(0);
date_default_timezone_set('UTC');
$bNoSession = true;

// Необходимые классы
require_once dirname(__FILE__).'/../include/visitor.inc.php';
Conf::loadClass('Account');
Conf::loadClass('Booking');

$_CONF['debug'] = 1;

$sEmail = $oReq->get('email');
if ($sEmail) {
    $oAccount = new Account();
    //$oBooking = new Booking();
    if ($oAccount->loadBy(array('email'=>'="'.Database::escape($sEmail).'"'))) {
     //   $oBooking->deleteByCond(array('account_id'=>'='.$oAccount->aData['account_id']));
        if ($oAccount->delete($oAccount->aData['account_id']))
            echo 'Account with email '.$sEmail.' deleted';
        else
            echo join('<br>', $oAccount->getErrors());
    } else
        echo 'Email not found';


} else
    echo 'Email not set';


?>