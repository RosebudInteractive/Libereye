<?php
/**
 * Smarty plugin
 * @package Smarty
 * @subpackage plugins
 */

/**
 * Smarty money_format modifier plugin
 *
 * Type:     modifier<br>
 * Name:     money_format<br>
 * Purpose:  Formats a number as a currency string
 * @link http://www.php.net/number_format
 * @param float  $number             number to convert
 * @param int    $nDecimalPlaces     number of decimal positions
 * @param string $sDecSep            separator of decimals
 * @param string $sThousandsSep      separator between every group of thousands
 * @return string
 */
function smarty_modifier_money_format($number, $nDecimalPlaces=2, $sDecSep='.', $sThousandsSep=' ')
{
	return number_format($number, $nDecimalPlaces, $sDecSep, $sThousandsSep);
}

?>