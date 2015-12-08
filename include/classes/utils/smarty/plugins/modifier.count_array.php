<?php
/**
 * Smarty plugin
 * @package Smarty
 * @subpackage plugins
 * @author Rudenko S.
 */


/**
 * Smarty count modifier plugin
 *
 * Type:     modifier<br>
 * Name:     count array<br>
 * Purpose:  Count elements in an array
 * @param array
 * @return integer
 */
function smarty_modifier_count_array($string)
{
    return count($string);
}

/* vim: set expandtab: */

?>
