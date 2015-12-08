<?php
/** ============================================================
 * Area configuration.
 *   Area: admin
 * @author Rudenko S.
 * @package admin
 * ============================================================ */

$aParts = array(
   'products' => array(
        'title'   =>Conf::format('part.products'),
        'url'     =>Conf::getUrl('admin.products'),
        'sections'=>array(
            'list'=>array('url' =>Conf::getUrl('admin.products.list')),
        ),
    ), //end part "products"    
);

$aMenu = array(
//    'content'       => array('url' => 'admin.content', 'title' => Conf::format('menu.content')),
    'products'      => array('url' => 'admin.products', 'title' => Conf::format('menu.products')),
 //   'logout'      => array('url' => 'admin.logout', 'title' => Conf::format('menu.logout')),
);

$oReq->setAreaConfig('admin', $aParts, $aMenu);
?>