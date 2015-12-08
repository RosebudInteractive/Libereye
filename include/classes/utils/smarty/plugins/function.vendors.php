<?php
/**
 * Smarty plugin
 * @package Smarty
 * @subpackage plugins
 */

/**
 * @author Alexander Martinkevich <martin_boy@mail15.com>
 * @version  1.0
 * @param array $params
 * @param Smarty $smarty
 * @return array
 */
function smarty_function_vendors($params, &$smarty)
{
    Conf::loadClass('Vendor');
    $oVendor = &new Vendor();
    list($aVendors) = $oVendor->getList(array('is_hidden' => '=0', 'is_deleted' => '=0'), 0, 0, 'name ASC', array('name', 'vendor_id', 'alias'));

    if (isset($params['assign']))
        $smarty->assign($params['assign'], $aVendors);
}



?>
