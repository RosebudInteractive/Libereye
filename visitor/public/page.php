<?php
Conf::loadClass('Content');

$oContent   = &new Content();

// контент
$sPage = $oReq->get('content', 'main.html');
if ($sPage && !$oContent->loadBy(array('uri'=>'="'.Database::escape($sPage).'"', 'language_id'=>'="'.$aLanguage['language_id'].'"')))
{
	$oReq->forward('/'.$aLanguage['alias'].'/page/404.html');
}
$aPage = $oContent->aData;

// корневые страницы
$aCond = array('parent_id'=>'=0', 'is_hide'=>'=0');
list($aParentPages, $iCnt) = $oContent->getList($aCond, 0, 0, 'priority, title');

$oTpl->assign(array(
    'aParentPages'   => $aParentPages,
    'sPage' => $sPage,
));


// Подчиненные страницы
$aChildPages = array();	
$aParentPage = array();
if ($aPage['parent_id'] && $oContent->loadBy(array('content_id'=>'="'.$aPage['parent_id'].'"', 'is_hide'=>'=0')))
{
	$aParentPage = $oContent->aData;
}
list($aChildPages, $iCnt) = $oContent->getList(array('parent_id'=>'='.$aPage['content_id'], 'is_hide'=>'=0'), 0, 0, 'priority, title');

$aCond = array();

// дин. контент на статических страницах
switch ($sPage)
{
    case 'main':
        Conf::loadClass('Subscribe');
        Conf::loadClass('utils/Validator');
        Conf::loadClass('utils/mail/Mailer');
        Conf::loadClass('Content');

        $oSubscribe  	= new Subscribe();
        $aSubscribe 	= $oReq->getArray('aUser');

        $aFields = array(
            'aUser[fname]' 	=> array('title'=>Conf::format('Name'),  'pattern'=>'/^.{1,100}$/'),
            'aUser[email]' 		=> array('title'=>Conf::format('Email'),    'pattern'=>'/^[A-Za-z_0-9\.\-]+@[A-Za-z0-9\.\-]+\.[A-Za-z]{2,}$/'),
        );

        $oValidator = new Validator($aFields, array(array('aUser[pass]', 'pass_confirm', '==')));
        $aErrors 	= array();

        switch ($oReq->getAction())
        {
            case 'subscribe':
                if ($oValidator->isValid($oReq->getAll())){
                    $oSubscribe->aData = $aSubscribe;
                    $oSubscribe->aData['cdate'] = Database::date();

                    if ($oSubscribe->isUniqueEmail())
                    {
                        if (($oSubscribe->insert()))
                            $oReq->forward('/'.$aLanguage['alias'].'/', Conf::format('You have successfully subscribed'));
                        else
                            $aErrors = $oSubscribe->getErrors();
                    }
                    else
                        $aErrors[] = Conf::format('This email address is already subscribed');
                } else
                    $aErrors = $oValidator->getErrors();
                break;
        }


        // Title
        $oTpl->assign(array(
            'aSubscribe' 	=> $aSubscribe,
            'aErrors'		=> $aErrors,
        ));

        $sSubBlock = $oTpl->fetch('blocks/subscribe.html');
        $aPage['content'] = str_replace('{SUBSCRIBE_FORM}', $sSubBlock, $aPage['content']);
        break;
	default:
		list($aContents, $iCnt) = $oContent->getList(array('is_hide'=>'=0', 'parent_id'=>'='.$aPage['content_id']), 0, 0, 'IF(c.parent_id=0,0,1), priority, title');
		$oTpl->assign(array(
		    'aContents'  => $aContents,
		));
		
		break;	
}

foreach ($aChildPages as $nKey=>$aChildPage) {
	$aChildPages[$nKey]['content_title'] = strip_tags($aChildPage['content']);
}

// Variables
$oTpl->assignSrc(array(
	'aPage' => $aPage,
	'aParentPage' => $aParentPage,
	'aChildPages' => $aChildPages,
));

?>
