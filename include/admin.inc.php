<?php
/** ============================================================
 * Area configuration.
 *   Area: admin
 * @author Rudenko S.
 * @package admin
 * ============================================================ */
require_once 'common.inc.php';
require_once 'messages/'.LANGUAGE.'/admin.mess.php';


$aParts = array(
    'accounts' => array(
        'title'   =>Conf::format('part.accounts'),
        'url'     =>Conf::getUrl('admin.accounts'),
        'sections'=>array(
            'list'=>array('url' =>Conf::getUrl('admin.accounts.list')),
            'account_edit'=>array('url' =>Conf::getUrl('admin.accounts.account_edit')),
        ),
    ), //end part "accounts"
    'bookings' => array(
        'title'   =>Conf::format('part.bookings'),
        'url'     =>Conf::getUrl('admin.bookings'),
        'sections'=>array(
            'list'=>array('url' =>Conf::getUrl('admin.bookings.list')),
            'booking_edit'=>array('url' =>Conf::getUrl('admin.bookings.booking_edit')),
        ),
    ), //end part "bookings"
    'phrases' => array(
        'title'   =>Conf::format('part.phrases'),
        'url'     =>Conf::getUrl('admin.phrases'),
        'sections'=>array(
            'list'=>array('url' =>Conf::getUrl('admin.phrases.list')),
            'phrase_edit'=>array('url' =>Conf::getUrl('admin.phrases.phrase_edit')),
        ),
    ), //end part "phrases"
    'purchases' => array(
        'title'   =>Conf::format('part.purchases'),
        'url'     =>Conf::getUrl('admin.purchases'),
        'sections'=>array(
            'list'=>array('url' =>Conf::getUrl('admin.purchases.list')),
            'purchase_edit'=>array('url' =>Conf::getUrl('admin.purchases.purchase_edit')),
        ),
    ), //end part "bookings"
    'content' => array(
        'title'   =>Conf::format('part.content'),
        'url'     =>Conf::getUrl('admin.content'),
        'sections'=>array(
            'list'=>array('url' =>Conf::getUrl('admin.content.list')),
            'content_edit'=>array('url' =>Conf::getUrl('admin.content.content_edit')),
        ),
    ), //end part "content"
    'subscribe' => array(
        'title'   =>Conf::format('part.subscribe'),
        'url'     =>Conf::getUrl('admin.subscribe'),
        'sections'=>array(
            'list'=>array('url' =>Conf::getUrl('admin.subscribe.list')),
        ),
    ), //end part "subscribe"
    'settings' => array(
        'title'   =>Conf::format('part.settings'),
        'url'     =>Conf::getUrl('admin.settings'),
        'sections'=>array(
            'settings'=>array('url' =>Conf::getUrl('admin.settings.settings')),
        ),
    ), //end part "settings"
);

$aMenu = array(
    'accounts'       => array('url' => 'admin.accounts', 'title' => Conf::format('menu.accounts')),
    'bookings'       => array('url' => 'admin.bookings', 'title' => Conf::format('menu.bookings')),
    'purchases'       => array('url' => 'admin.purchases', 'title' => Conf::format('menu.purchases')),
    'content'       => array('url' => 'admin.content', 'title' => Conf::format('menu.content')),
    'subscribe'       => array('url' => 'admin.subscribe', 'title' => Conf::format('menu.subscribe')),
    'phrases'       => array('url' => 'admin.phrases', 'title' => Conf::format('menu.phrases')),
    'settings'    => array('url' => 'admin.settings', 'title' => Conf::format('menu.settings')),
);

$oReq->setAreaConfig('admin', $aParts, $aMenu);
?>