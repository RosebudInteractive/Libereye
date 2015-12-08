<?php
Conf::loadClass('Rubric');
Conf::loadClass('Product');
Conf::loadClass('utils/Pager');

$iPage = $oReq->get('page', 1);
$iPageSize = 15;
$oRubric = new Rubric();
$oProduct = new Product();
$sQuery = $oReq->get('q');
	
if ($sQuery) {
	list($aProducts, $iCnt) = $oProduct->getList(array('{#search}'=>'p.title LIKE "%'.Database::escapeLike($sQuery).'%"  OR p.description LIKE  "%'.Database::escapeLike($sQuery).'%" OR p.annotation LIKE  "%'.Database::escapeLike($sQuery).'%"', 'city_id'=>'='.$aCity['city_id']), $iPage, $iPageSize, '');
	$oPager = new Pager($iCnt, $iPage, $iPageSize);
	$oTpl->assignSrc(array(
	    'aProducts'   => $aProducts,
	));

	$oTpl->assign(array(
	   'sTitle'   => $sTitle,
	   'sQuery'   => $sQuery,
	   'iPage'   => $iPage,
	   'aPaging'  => $oPager->getInfoCustom('/search/?q='.urlencode($sQuery).'&page='),
	));
}
?>