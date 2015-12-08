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
        ),
    ), // end part "public"
    'private' => array(
        'title'   =>Conf::format('part.private'),
        'url'     =>Conf::getUrl('visitor.private'),
        'sections'=>array(
            'profile' => array('url'  =>Conf::getUrl('visitor.public.profile')),
            'logout' => array('url'  =>Conf::getUrl('visitor.public.logout')),
            'booking' => array('url'  =>Conf::getUrl('visitor.public.booking')),
            'meetings' => array('url'  =>Conf::getUrl('visitor.public.meetings')),
            'purchases' => array('url'  =>Conf::getUrl('visitor.public.purchases')),
            'mypurchases' => array('url'  =>Conf::getUrl('visitor.public.mypurchases')),
            'purchase' => array('url'  =>Conf::getUrl('visitor.public.purchase')),
        ),
    ), // end part "private"
);

$aMenu = array(
);

$oReq->setAreaConfig('visitor', $aParts, $aMenu);
?>
