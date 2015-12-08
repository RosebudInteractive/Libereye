<?php

require_once 'classes/utils/validator.class.php';
require_once 'classes/settings/settings.class.php';

$oSettings = new Settings();

$aSettings = $oSettings->getSettings();

$aFields = array();
for ($i = 0; $i < count($aSettings); $i++)
{
    if ($aSettings[$i]['validation'] && $aSettings[$i]['validation']!='bool')
       $aFields['settings['.$aSettings[$i]['code'].']'] = array('title' => $aSettings[$i]['name'], 'def'=>$aSettings[$i]['validation']);
}

$oValidator = new Validator($aFields);
$aErrors = array();

if ('update' == $oReq->getAction())
{
    $aPostSettings = $oReq->getArray('settings');
	foreach($aSettings as $k=>$v)
	{
		$aSettings[$k]['val'] = $aPostSettings[$v['code']];
	}

    if ($oValidator->isValid($oReq->getAll()))
    {
        foreach($aPostSettings as $k=>$v)
        {
            $oSettings->updateSetting($k, $v);
        }

        $oReq->forward($oUrl->getUrl(), Conf::format('settings.updated'), false);
    }
    else
        $aErrors = $oValidator->getErrors();
}

$oTpl->assign(array(
    'sJS'        =>    $oValidator->makeJS(),
    'aSettings'  =>    $aSettings,
));

$oTpl->assign('sPart', 'settings');

?>