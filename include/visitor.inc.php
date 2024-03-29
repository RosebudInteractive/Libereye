<?php
/** ============================================================
 * Area configureation.
 *   Area: member
 * @author Rudenko S.
 * @package member
 * ============================================================ */
require_once 'common.inc.php';
require_once 'messages/'.LANGUAGE.'/member.mess.php';

$aParts = array(
    'ajax' => array(
        'title'   =>Conf::format('part.ajax'),
        'url'     =>Conf::getUrl('visitor.ajax'),
        'sections'=>array(
            'getbrands' => array('url'  =>Conf::getUrl('visitor.ajax.getbrands')),
        ),
    ), // end part "public"
    'public' => array(
        'title'   =>Conf::format('part.public'),
        'url'     =>Conf::getUrl('visitor.public'),
        'sections'=>array(
            'index' => array('url'  =>Conf::getUrl('visitor.public.index')),
            'sitemap' => array('url'  =>Conf::getUrl('visitor.public.sitemap')),
            'page' => array('url'  =>Conf::getUrl('visitor.public.page')),
            'search' => array('url'  =>Conf::getUrl('visitor.public.search')),
            'register' => array('url'  =>Conf::getUrl('visitor.public.register')),
            'login' => array('url'  =>Conf::getUrl('visitor.public.login')),
            'remind' => array('url'  =>Conf::getUrl('visitor.public.remind')),
            'confirm' => array('url'  =>Conf::getUrl('visitor.public.confirm')),
            'shop' => array('url'  =>Conf::getUrl('visitor.public.shop')),
            'news' => array('url'  =>Conf::getUrl('visitor.public.news')),
        ),
    ), // end part "public"
    'private' => array(
        'title'   =>Conf::format('part.private'),
        'url'     =>Conf::getUrl('visitor.private'),
        'sections'=>array(
            'profile' => array('url'  =>Conf::getUrl('visitor.private.profile')),
            'logout' => array('url'  =>Conf::getUrl('visitor.private.logout')),
            'booking' => array('url'  =>Conf::getUrl('visitor.private.booking')),
            'meetings' => array('url'  =>Conf::getUrl('visitor.private.meetings')),
           // 'purchases' => array('url'  =>Conf::getUrl('visitor.private.purchases')),
           // 'mypurchases' => array('url'  =>Conf::getUrl('visitor.private.mypurchases')),
           // 'purchase' => array('url'  =>Conf::getUrl('visitor.private.purchase')),
            'cart' => array('url'  =>Conf::getUrl('visitor.private.cart')),
            'cart_shopper' => array('url'  =>Conf::getUrl('visitor.private.cart_shopper')),
            'mymeetings' => array('url'  =>Conf::getUrl('visitor.private.mymeetings')),
        ),
    ), // end part "private"
);

$aMenu = array(
);

$oReq->setAreaConfig('visitor', $aParts, $aMenu);
?>
