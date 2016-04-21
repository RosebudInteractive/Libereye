<?php
Conf::loadClass('Shop');
Conf::loadClass('News');

$oShop   = new Shop();
$oNews   = new News();

// контент
$iNewsId = $oReq->getInt('id', 'main.html');
if ($iNewsId && !$oNews->load($iNewsId, LANGUAGEID))
{
	$oReq->forward('/'.$aLanguage['alias'].'/');
}
$aNews = $oNews->aData;

// Variables
$oTpl->assignSrc(array(
	'aNews' => $aNews,
));

?>
