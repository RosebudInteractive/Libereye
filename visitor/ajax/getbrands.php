<?php
/** ============================================================
 * Part section.
 *   Area:    visitor
 *   Part:    ajax
 *   Section: getclinics
 * @author Rudenko S.
 * @package visitor
 * ============================================================ */
Conf::loadClass('Brand');

$oBrand = new Brand();
$sSearch = $oReq->get('q');
if ($sSearch)
{
	$nLimit = $oReq->getInt('limit', 100);
	$aBrands = $oBrand->getHash('title', array('{#title}'=>'pd1.phrase LIKE "'.Database::escapeLike($sSearch).'%"'), 'title asc', $nLimit);
	echo json_encode(array_merge(array(), $aBrands));
}
exit;
?>