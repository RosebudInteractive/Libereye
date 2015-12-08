<?php
class Foursquare {
	function Foursquare()
	{

	}
	
	function getItems($sHtml) {
		$aLinks = array();
		if (preg_match_all('@<div class="venueName"><h2><a href="(.*?)"@si', $sHtml, $aM)) {
			$aLinks = $aM[1];
		}
		return $aLinks;
	}
	
	function getFields($sHtml) {
		$aProduct = array();
		if (preg_match('@<span itemprop="ratingValue">(.*?)</span>@si', $sHtml, $aM2))
			$aProduct['popular']=$aM2[1];
		if (preg_match('@<h1[^>]*>(.*?)</h1>@si', $sHtml, $aM2))
			$aProduct['title'] = trim(strip_tags($aM2[1]));
		if (preg_match('@<p class="venueDescription">(.*?)</p>@si', $sHtml, $aM2))
			$aProduct['annotation'] = trim(strip_tags($aM2[1]));
		if (preg_match('@itemprop="address"[^>]*>(.*?)</div>@si', $sHtml, $aM2))
			$aProduct['adres'] = trim(strip_tags($aM2[1]));
		if (preg_match('@<span class="open">(.*?)</span>@si', $sHtml, $aM2))
			$aProduct['works'] = trim(strip_tags($aM2[1]));
		if (preg_match('@<span itemprop="telephone" class="tel">(.*?)</span>@si', $sHtml, $aM2))
			$aProduct['contacts'] = trim(strip_tags($aM2[1]));
		if (preg_match('@<a href="([^"]+)" class="url" itemprop="url"@si', $sHtml, $aM2))
			$aProduct['site'] = trim($aM2[1]);
		if (preg_match('@<div class="venueAttr "><div class="attrKey">Меню:</div><div class="attrValue">(.*?)</div>@si', $sHtml, $aM2))
			$aProduct['features'] = trim(strip_tags($aM2[1]));
		return $aProduct;
	}
	
	function getImages($sHtml, $nLimit=10) {
		$aImages = array();
		if (preg_match_all('@<img src="([^"]+)" class="mainPhoto"@si', $sHtml, $aM2)) {
			$aImages = array_slice($aM2[1], 0, $nLimit);
		}
		return $aImages;
	}
}

?>