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
    'content' => array(
        'title'   =>Conf::format('part.content'),
        'url'     =>Conf::getUrl('admin.content'),
        'sections'=>array(
            'list'=>array('url' =>Conf::getUrl('admin.content.list')),
            'content_edit'=>array('url' =>Conf::getUrl('admin.content.content_edit')),
        ),
    ), //end part "content"
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

    'shops' => array(
        'title'   =>Conf::format('part.shops'),
        'url'     =>Conf::getUrl('admin.shops'),
        'sections'=>array(
            'list'=>array('url' =>Conf::getUrl('admin.shopslist')),
            'shop_edit'=>array('url' =>Conf::getUrl('admin.shops.shop_edit')),
        ),
    ), //end part "shops"
    'brands' => array(
        'title'   =>Conf::format('part.brands'),
        'url'     =>Conf::getUrl('admin.brands'),
        'sections'=>array(
            'list'=>array('url' =>Conf::getUrl('admin.brands.list')),
            'brand_edit'=>array('url' =>Conf::getUrl('admin.brands.brand_edit')),
        ),
    ), //end part "brands"
    'boxes' => array(
        'title'   =>Conf::format('part.boxes'),
        'url'     =>Conf::getUrl('admin.boxes'),
        'sections'=>array(
            'list'=>array('url' =>Conf::getUrl('admin.boxes.list')),
        ),
    ), //end part "brands"
    'carriers' => array(
        'title'   =>Conf::format('part.carriers'),
        'url'     =>Conf::getUrl('admin.carriers'),
        'sections'=>array(
            'list'=>array('url' =>Conf::getUrl('admin.carriers.list')),
        ),
    ), //end part "brands"
    'regions' => array(
        'title'   =>Conf::format('part.regions'),
        'url'     =>Conf::getUrl('admin.regions'),
        'sections'=>array(
            'list'=>array('url' =>Conf::getUrl('admin.regions.list')),
        ),
    ), //end part "brands"
    'countrys' => array(
        'title'   =>Conf::format('part.countrys'),
        'url'     =>Conf::getUrl('admin.countrys'),
        'sections'=>array(
            'list'=>array('url' =>Conf::getUrl('admin.countrys.list')),
        ),
    ), //end part "brands"
    'currencys' => array(
        'title'   =>Conf::format('part.currencys'),
        'url'     =>Conf::getUrl('admin.currencys'),
        'sections'=>array(
            'list'=>array('url' =>Conf::getUrl('admin.currencys.list')),
        ),
    ), //end part "brands"
    'timezones' => array(
        'title'   =>Conf::format('part.timezones'),
        'url'     =>Conf::getUrl('admin.timezones'),
        'sections'=>array(
            'list'=>array('url' =>Conf::getUrl('admin.timezones.list')),
        ),
    ), //end part "brands"
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
            'list'=>array('url' =>Conf::getUrl('admin.settings.list')),
            'settings'=>array('url' =>Conf::getUrl('admin.settings.settings')),
        ),
    ), //end part "settings"
    'news' => array(
        'title'   =>Conf::format('part.news'),
        'url'     =>Conf::getUrl('admin.news'),
        'sections'=>array(
            'list'=>array('url' =>Conf::getUrl('admin.news.list')),
            'news_edit'=>array('url' =>Conf::getUrl('admin.news.news_edit')),
        ),
    ), //end part "news"
);

$aMenu = array(
    //'accounts'       => array('url' => 'admin.accounts', 'title' => Conf::format('menu.accounts')),
    //'news'       => array('url' => 'admin.news', 'title' => Conf::format('menu.news')),
    //'bookings'       => array('url' => 'admin.bookings', 'title' => Conf::format('menu.bookings')),
    //'purchases'       => array('url' => 'admin.purchases', 'title' => Conf::format('menu.purchases')),
    //'brands'    => array('url' => 'admin.brands', 'title' => Conf::format('menu.brands')),
    //'shops'    => array('url' => 'admin.shops', 'title' => Conf::format('menu.shops')),
    'content'       => array('url' => 'admin.content', 'title' => Conf::format('menu.content')),
    //'subscribe'       => array('url' => 'admin.subscribe', 'title' => Conf::format('menu.subscribe')),
    //'phrases'       => array('url' => 'admin.phrases', 'title' => Conf::format('menu.phrases')),
    //'settings'    => array('url' => 'admin.settings', 'title' => Conf::format('menu.settings')),
);

$oReq->setAreaConfig('admin', $aParts, $aMenu);
?>