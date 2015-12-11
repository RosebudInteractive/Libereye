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
$aCond = array('parent_id'=>'=0');
list($aParentPages, $iCnt) = $oContent->getList($aCond, 0, 0, 'priority, title');

$oTpl->assign(array(
    'aParentPages'   => $aParentPages,
    'sPage' => $sPage,
));


// Подчиненные страницы
$aChildPages = array();	
$aParentPage = array();
if ($aPage['parent_id'] && $oContent->loadBy(array('content_id'=>'="'.$aPage['parent_id'].'"')))
{
	$aParentPage = $oContent->aData;
}
list($aChildPages, $iCnt) = $oContent->getList(array('parent_id'=>'='.$aPage['content_id']), 0, 0, 'priority, title');

$aCond = array();

// дин. контент на статических страницах
switch ($sPage)
{
    case 'main':
        Conf::loadClass('News');
        $oNews  	= new News();
        $aErrors 	= array();

        switch ($oReq->getAction())
        {
            case 'getNews':
                $iPage = $oReq->getInt('page');
                list($aNews,) = $oNews->getList(array(), $iPage, 3, 'cdate desc');
                $oTpl->assign(array(
                    'aNews' 	=> $aNews,
                ));
                echo $oTpl->fetch('blocks/news.html');
                exit;
                break;
        }

        list($aNews,) = $oNews->getList(array(), 0, 3, 'cdate desc');
        $oTpl->assign(array(
            'aNews' 	=> $aNews,
        ));
        break;
	default:
		list($aContents, $iCnt) = $oContent->getList(array('parent_id'=>'='.$aPage['content_id']), 0, 0, 'IF(c.parent_id=0,0,1), priority, title');
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
