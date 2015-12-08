<?php
/** ============================================================
 * Application init.
 * When completed:
 *  A. Loaded config, messages, base class definition,
 *     defined include_path
 *  B. Created:
 *     1. $oUrl  - URL wrapper for current URL
 *     2. $oReq  - request wrapper
 *     3. $oTpl  - Smarty template
 *  C. Variables created
 *     1. $aErrors - empty array for errors
 *     2. $sTitle  - emty string: page title
 *  D. Variables assigned to template:
 *     1. sUrl            - current URL
 *     2. sFormatDate     - date format
 *     3. sFormatDateTime - datetime format
 *     4. sJsMessages     - javascript with messages
 * Possible in-flags:
 *  A. $bNoSession bool true - no session,
 *                      false or not defined - start session
 * @author Rudenko S.
 * @package core
 * ============================================================ */

if (! (isset($bNoSession) && $bNoSession) )
    session_start();

//load configurations
require_once 'settings/server.sett.php';
require_once 'settings/common.sett.php';
require_once 'settings/tables.sett.php';
require_once 'settings/url.sett.php';

//messages
require_once 'messages/common.mess.php';

//set include path
if ($_CONF['hosting_type'] == 'windows')
    ini_set('include_path', '.;'.$_CONF['path'].'include');
else 
    ini_set('include_path', '.:'.$_CONF['path'].'include');

//base classes
require_once 'classes/utils/conf.class.php';
require_once 'classes/utils/url.class.php';
require_once 'classes/utils/request.class.php';
require_once 'classes/utils/database.class.php';

//load debug subsytem
require_once 'debug.inc.php';

//create base classes
$oUrl = new Url(); // current url
$oReq = new Request($oUrl);

// language
//$sLang = $oReq->get('lang', 'ru');
//if (!in_array($sLang, array('ru', 'en')))
$sLang = 'ru';
define('LANGUAGE', $sLang);

// additional classes
require_once 'classes/utils/template.class.php';
require_once 'classes/utils/validator.class.php';
require_once 'messages/'.LANGUAGE.'/translate.mess.php';
$oTpl = new Template();
$oValidator = new Validator(array());

//javascript messages
$sJsMessages = '<script>var aMessages = [];';
foreach(Conf::getMessages('js.') as $k=>$v)
    $sJsMessages .= "aMessages['$k']='$v';";
$sJsMessages .= '</script>';

$oTpl->assignSrc('sJsMessages', $sJsMessages);
$oTpl->assignSrc('jsValidatorMess', $oValidator->makeJsMess());

$oTpl->assign(array(
    'sUrl'            => $oUrl->getUrl(),
    'sFormatDate'     => Conf::get('format.date%'),
    'sFormatDateTime' => Conf::get('format.datetime%'),
));

//create variables
$aErrors = array(); //empty errors array

?>