<?php
/** ============================================================
 * Area controller.
 *   Area: member
 * @author Rudenko S.
 * @package member
 * ============================================================ */
error_reporting(E_ALL);
ini_set('display_errors', true);
/* Установка внутренней кодировки в UTF-8 */
mb_internal_encoding("UTF-8");
setlocale(LC_ALL, "en_US.UTF-8");
require_once '../include/visitor.inc.php';

Conf::loadClass('Account');
Conf::loadClass('Language');
Conf::loadClass('LangPhrase');
Conf::loadClass('Content');
$oAccount = new Account();
$oLanguage = new Language();
$oContent = new Content();
global $_PHRASES;

// Попытка логина из кукисов
if ($oReq->_sSect != 'logout' && !$oAccount->isLoggedIn() && isset($_COOKIE['username']) && isset($_COOKIE['password'])) {
    if ($oAccount->login($_COOKIE['username'], $_COOKIE['password'], array(), 'common', 0, true, true))
        $oReq->forward('/'.$aLanguage['alias'].'/');
}

// данные пользователя
$aAccount = array();
if ($oAccount->isLoggedIn() && $oAccount->load($oAccount->isLoggedIn())) {
	$aAccount = $oAccount->aData;
    if (isset($aAccount['timezone']))
        date_default_timezone_set($aAccount['timezone']);
    else
        date_default_timezone_set('UTC');
} else {
    date_default_timezone_set('UTC');
}

$aLanguage = false;
if ($oReq->get('lang')) {
    if ($oLanguage->loadBy(array('alias'=>'="'.Database::escape($oReq->get('lang')).'"'))) {
        $aLanguage = $oLanguage->aData;
    }
}
if (!$aLanguage) {
    $oLanguage->loadBy(array('is_default'=>'=1'));
    $aLanguage = $oLanguage->aData;
}
list($aLanguages,) = $oLanguage->getList(array(), 0,0, 'is_default DESC, title');
$_PHRASES = LangPhrase::getPhrases($aLanguage['language_id']);
$_MSG = $_MSG + $_PHRASES;
define('LANGUAGEID', $aLanguage['language_id']);


// Проверка на приватный раздел
if ($oReq->_sPart == 'private' && !$oAccount->isLoggedIn()){
    $oReq->forward('/');
}

$oTpl->assignSrc(array(
    'aPhrases' =>  $_PHRASES,
    'aPhrasesJson' =>  json_encode($_PHRASES),
    'aLanguage' => $aLanguage,
));

//START process request
$aErrors = array();
$sTitle = $oReq->getSectionTitle();
require_once $oReq->getSectionFile();
//END request process area
$oTpl->addMes($_SERVER['REQUEST_URI']);

$sLangUrl = str_replace('/'.LANGUAGE.'/', '/'.(LANGUAGE=='ru'?'en':'ru').'/', $_SERVER['REQUEST_URI'], $nReplCount);
if ($nReplCount==0) $sLangUrl = '/'.(LANGUAGE=='ru'?'en':'ru').$sLangUrl;


list($aContentPages, ) = $oContent->getList(array('parent_id'=>'=0', 'language_id'=>'="'.$aLanguage['language_id'].'"'), 0, 0, 'priority, title');

$oTpl->assign(array(
    'aErrors'        => $aErrors,
    'sTitle'         => $sTitle,
    'sPart'          => $oReq->_sPart,
    'sSect'          => $oReq->_sSect,
    'sLang' => LANGUAGE,
    'sLangUrl' => $sLangUrl,
    'aAccount' => $aAccount,

    'aLanguages' => $aLanguages,
    'aContentPages' => $aContentPages ,
    'REQUEST_URI' => preg_replace('@^/(ru|en|fr)/@si', '/', $_SERVER['REQUEST_URI']),
));

$oTpl->assignSrc(array(
    'apiConfigJson' => json_encode(array(
        'facebook_app_id' => Conf::get('facebook_app_id'),
        'vk_app_id' => Conf::get('vk_app_id'),
        'google_app_id' => Conf::get('google_app_id'),
        'google_client_id' => Conf::get('google_client_id'),
    )),
));
// View
$oTpl->view('visitor/'.$oReq->getSectionFile('html'));

?>