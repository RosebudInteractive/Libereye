<?php
/**
 * Smarty plugin
 * @package Smarty
 * @subpackage plugins
 */


/**
 * Smarty capitalize modifier plugin
 *
 * Type:     modifier<br>
 * Name:     plural<br>
 * Purpose:  makes plural (table -> tables, status->ststuses, etc.)
 * @param string
 * @return string
 */
function smarty_modifier_plural($string)
{
    if (in_array(substr($string,-1), array('s','z')) ||
        in_array(substr($string,-2), array('sh','ch')) )
        $string .= 'es';
    else
        $string .= 's';
    return $string;
}

?>
