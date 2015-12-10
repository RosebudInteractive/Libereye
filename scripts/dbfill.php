<?php
set_time_limit(0);
$bNoSession = true;

// Необходимые классы
require_once dirname(__FILE__).'/../include/visitor.inc.php';
$oDb = Database::get();


// зоны
$aItems = file('timezone.txt');
$oDb->query('TRUNCATE TABLE timezone;');
$oDb->query('DELETE FROM lang_phrase WHERE object_type_id=9;');
foreach($aItems as $sItem) {
    $sItem = trim($sItem);
    $aItem = array_map('trim', explode('|', $sItem));
    $oDb->query('INSERT INTO `timezone` (`title`, `code`) VALUES ("' . Database::escape($aItem[2]) . '", "' . Database::escape($aItem[0]) . '")');
    $nItemId = $oDb->getLastID();
    $oDb->query('INSERT INTO `lang_phrase` (`language_id`, `object_type_id`, `object_field`, `object_id`, `phrase`, `alias`) VALUES ("1", "9", "title", "'.$nItemId.'", "'.Database::escape($aItem[1]).'", "'.Database::escape($aItem[2]).'")');
    $oDb->query('INSERT INTO `lang_phrase` (`language_id`, `object_type_id`, `object_field`, `object_id`, `phrase`, `alias`) VALUES ("2", "9", "title", "'.$nItemId.'", "'.Database::escape($aItem[2]).'", "'.Database::escape($aItem[2]).'")');
    $oDb->query('INSERT INTO `lang_phrase` (`language_id`, `object_type_id`, `object_field`, `object_id`, `phrase`, `alias`) VALUES ("3", "9", "title", "'.$nItemId.'", "'.Database::escape($aItem[3]).'", "'.Database::escape($aItem[2]).'")');
}
echo 'Таблица timezone: добавлено '.count($aItems).' штук из timezone.txt'."<br>\n";
exit;

// зоны
$aItems = file('country.txt');
$oDb->query('TRUNCATE TABLE country;');
$oDb->query('DELETE FROM lang_phrase WHERE object_type_id=8;');
foreach($aItems as $sItem) {
    $sItem = trim($sItem);
    $aItem = array_map('trim', explode('|', $sItem));
    $oDb->query('INSERT INTO `country` (`title`, `code2`, `code3`) VALUES ("' . Database::escape($aItem[1]) . '", "' . Database::escape($aItem[3]) . '", "' . Database::escape($aItem[4]) . '")');
    $nItemId = $oDb->getLastID();
    $oDb->query('INSERT INTO `lang_phrase` (`language_id`, `object_type_id`, `object_field`, `object_id`, `phrase`, `alias`) VALUES ("1", "8", "title", "'.$nItemId.'", "'.Database::escape($aItem[0]).'", "'.Database::escape($aItem[1]).'")');
    $oDb->query('INSERT INTO `lang_phrase` (`language_id`, `object_type_id`, `object_field`, `object_id`, `phrase`, `alias`) VALUES ("2", "8", "title", "'.$nItemId.'", "'.Database::escape($aItem[1]).'", "'.Database::escape($aItem[1]).'")');
    $oDb->query('INSERT INTO `lang_phrase` (`language_id`, `object_type_id`, `object_field`, `object_id`, `phrase`, `alias`) VALUES ("3", "8", "title", "'.$nItemId.'", "'.Database::escape($aItem[2]).'", "'.Database::escape($aItem[1]).'")');
}
echo 'Таблица country: добавлено '.count($aItems).' штук из country.txt'."<br>\n";


// бренды
$oDb->query('TRUNCATE TABLE brand;');
$oDb->query('DELETE FROM lang_phrase WHERE object_type_id=6;');
$aBrands = file('brand.txt');
foreach($aBrands as $sBrand) {
    $sBrand = trim($sBrand);
    $oDb->query('INSERT INTO `brand` (title) VALUES ("'.Database::escape($sBrand).'")');
    $nBrandId = $oDb->getLastID();
    $oDb->query('INSERT INTO `shop2brand` (`shop_id`, `brand_id`) VALUES ("1", "' . $nBrandId . '")');
    $oDb->query('INSERT INTO `lang_phrase` (`language_id`, `object_type_id`, `object_field`, `object_id`, `phrase`, `alias`) VALUES ("1", "6", "title", "'.$nBrandId.'", "'.Database::escape($sBrand).'", "'.Database::escape($sBrand).'")');
    $oDb->query('INSERT INTO `lang_phrase` (`language_id`, `object_type_id`, `object_field`, `object_id`, `phrase`, `alias`) VALUES ("2", "6", "title", "'.$nBrandId.'", "'.Database::escape($sBrand).'", "'.Database::escape($sBrand).'")');
    $oDb->query('INSERT INTO `lang_phrase` (`language_id`, `object_type_id`, `object_field`, `object_id`, `phrase`, `alias`) VALUES ("3", "6", "title", "'.$nBrandId.'", "'.Database::escape($sBrand).'", "'.Database::escape($sBrand).'")');
}
echo 'Таблица brand: добавлено '.count($aBrands).' штук из brand.txt'."<br>\n";

// группы товаров
$oDb->query('TRUNCATE TABLE pgroup;');
$oDb->query('DELETE FROM lang_phrase WHERE object_type_id=7;');
$aItems = file('pgroup.txt');
foreach($aItems as $sItem) {
    $sItem = trim($sItem);
    $aItem = array_map('trim', explode('|', $sItem));
    $oDb->query('INSERT INTO `pgroup` (title) VALUES ("'.Database::escape($aItem[1]).'")');
    $nItemId = $oDb->getLastID();
    $oDb->query('INSERT INTO `lang_phrase` (`language_id`, `object_type_id`, `object_field`, `object_id`, `phrase`, `alias`) VALUES ("1", "7", "title", "'.$nItemId.'", "'.Database::escape($aItem[0]).'", "'.Database::escape($aItem[1]).'")');
    $oDb->query('INSERT INTO `lang_phrase` (`language_id`, `object_type_id`, `object_field`, `object_id`, `phrase`, `alias`) VALUES ("2", "7", "title", "'.$nItemId.'", "'.Database::escape($aItem[1]).'", "'.Database::escape($aItem[1]).'")');
    $oDb->query('INSERT INTO `lang_phrase` (`language_id`, `object_type_id`, `object_field`, `object_id`, `phrase`, `alias`) VALUES ("3", "7", "title", "'.$nItemId.'", "'.Database::escape($aItem[2]).'", "'.Database::escape($aItem[1]).'")');
}
echo 'Таблица pgroup: добавлено '.count($aItems).' штук из pgroup.txt'."<br>\n";


// типы товаров
$oDb->query('TRUNCATE TABLE ptype2group;');
$oDb->query('TRUNCATE TABLE ptype;');
$oDb->query('DELETE FROM lang_phrase WHERE object_type_id=3;');
$aItems = file('ptype.txt');
foreach($aItems as $sItem) {
    $sItem = trim($sItem);
    $aItem = array_map('trim', explode('|', $sItem));
    $nItemId = $oDb->getField('SELECT ptype_id cnt FROM ptype WHERE title="' . Database::escape($aItem[1]) . '"');
    if (!$nItemId) {
        $oDb->query('INSERT INTO `ptype` (shop_id, title, cdate) VALUES (1, "' . Database::escape($aItem[1]) . '", NOW())');
        $nItemId = $oDb->getLastID();
        $oDb->query('INSERT INTO `lang_phrase` (`language_id`, `object_type_id`, `object_field`, `object_id`, `phrase`, `alias`) VALUES ("1", "3", "title", "' . $nItemId . '", "' . Database::escape($aItem[0]) . '", "' . Database::escape($aItem[1]) . '")');
        $oDb->query('INSERT INTO `lang_phrase` (`language_id`, `object_type_id`, `object_field`, `object_id`, `phrase`, `alias`) VALUES ("2", "3", "title", "' . $nItemId . '", "' . Database::escape($aItem[1]) . '", "' . Database::escape($aItem[1]) . '")');
        $oDb->query('INSERT INTO `lang_phrase` (`language_id`, `object_type_id`, `object_field`, `object_id`, `phrase`, `alias`) VALUES ("3", "3", "title", "' . $nItemId . '", "' . Database::escape($aItem[2]) . '", "' . Database::escape($aItem[1]) . '")');
    }
    $oDb->query('INSERT INTO `ptype2group` (`ptype_id`, `pgroup_id`) VALUES ("' . $nItemId . '", "' . $aItem[3] . '")');
}
echo 'Таблица ptype: добавлено '.count($aItems).' штук из ptype.txt'."<br>\n";

// товары
$oDb->query('TRUNCATE TABLE price;');
$oDb->query('TRUNCATE TABLE product;');
$oDb->query('DELETE FROM lang_phrase WHERE object_type_id=2;');
$aItems = file('product.txt');
foreach($aItems as $sItem) {
    $sItem = trim($sItem);
    $aItem = array_map('trim', explode('|', $sItem));
    $oDb->query('INSERT INTO `product` (`brand_id`, `ptype_id`, `title`, `description`, `article`) VALUES ("'.$aItem[0].'", "'.$aItem[1].'", "' . Database::escape($aItem[4]) . '", "' . Database::escape($aItem[7]) . '", "' . Database::escape($aItem[2]) . '")');
    $nItemId = $oDb->getLastID();
    $oDb->query('INSERT INTO `lang_phrase` (`language_id`, `object_type_id`, `object_field`, `object_id`, `phrase`, `alias`) VALUES ("1", "2", "title", "' . $nItemId . '", "' . Database::escape($aItem[3]) . '", "' . Database::escape($aItem[4]) . '")');
    $oDb->query('INSERT INTO `lang_phrase` (`language_id`, `object_type_id`, `object_field`, `object_id`, `phrase`, `alias`) VALUES ("2", "2", "title", "' . $nItemId . '", "' . Database::escape($aItem[4]) . '", "' . Database::escape($aItem[4]) . '")');
    $oDb->query('INSERT INTO `lang_phrase` (`language_id`, `object_type_id`, `object_field`, `object_id`, `phrase`, `alias`) VALUES ("3", "2", "title", "' . $nItemId . '", "' . Database::escape($aItem[5]) . '", "' . Database::escape($aItem[4]) . '")');
    $oDb->query('INSERT INTO `lang_phrase` (`language_id`, `object_type_id`, `object_field`, `object_id`, `phrase`, `alias`) VALUES ("1", "2", "description", "' . $nItemId . '", "' . Database::escape($aItem[6]) . '", "' . Database::escape($aItem[7]) . '")');
    $oDb->query('INSERT INTO `lang_phrase` (`language_id`, `object_type_id`, `object_field`, `object_id`, `phrase`, `alias`) VALUES ("2", "2", "description", "' . $nItemId . '", "' . Database::escape($aItem[7]) . '", "' . Database::escape($aItem[7]) . '")');
    $oDb->query('INSERT INTO `lang_phrase` (`language_id`, `object_type_id`, `object_field`, `object_id`, `phrase`, `alias`) VALUES ("3", "2", "description", "' . $nItemId . '", "' . Database::escape($aItem[8]) . '", "' . Database::escape($aItem[7]) . '")');

}
echo 'Таблица product: добавлено '.count($aItems).' штук из product.txt'."<br>\n";


// цены
$aItems = file('price.txt');
foreach($aItems as $sItem) {
    $sItem = trim($sItem);
    $aItem = array_map('trim', explode('|', $sItem));
    $oDb->query('INSERT INTO `price` (`product_id`, `shop_id`, `price`, `currency_id`, `cdate`) VALUES ("'.$aItem[0].'", "'.$aItem[1].'", "' . Database::escape($aItem[2]) . '", "' . Database::escape($aItem[3]) . '", NOW())');
    $nItemId = $oDb->getLastID();
}
echo 'Таблица price: добавлено '.count($aItems).' штук из price.txt'."<br>\n";




?>