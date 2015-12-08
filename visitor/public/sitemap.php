<?php
Conf::loadClass('Content');

$oContent   = &new Content();

list($aContents, $iCnt) = $oContent->getList(array('is_hide'=>'=0', 'language_id'=>'='.$aLanguage['language_id']), 0, 0, 'IF(c.parent_id=0,0,1), priority, title');
$aContentsTree = array();
foreach ($aContents as $aContentItem)
{
	if (!$aContentItem['parent_id'])
		$aContentsTree[$aContentItem['content_id']] = $aContentItem;
}
foreach ($aContents as $aContentItem)
{
	if ($aContentItem['parent_id'] && isset($aContentsTree[$aContentItem['parent_id']]))
		$aContentsTree[$aContentItem['parent_id']]['childs'][] = $aContentItem;
}

//$oTpl->sTemplateFile = 'template_sitemap.html';
$oTpl->assign(array(
    'aContentsTree'  => $aContentsTree,
));

//header ("Content-Type: text/xml");
?>