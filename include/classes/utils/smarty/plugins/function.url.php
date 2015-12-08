<?php
/**
 * Smarty {url} function plugin
 *
 * Type:     function<br>
 * Name:     url<br>
 * @param array
 * @param Smarty
 */
function smarty_function_url($params, &$smarty)
{
    static $oUrl = null;
    if (!$oUrl)
        $oUrl = new Url();
    
    //get link parameter
    if(!isset($params['link']))
        return '/errors/bad_url_nolink.html';
    $sLink = $params['link'];
    unset($params['link']);

    //get URLs
    if (!Conf::getUrl($sLink))
        return '/errors/bad_url_badlink.html';

    if (!$oUrl)
        return '/errors/bad_url_errorinit.html';

    $oUrl->setUrl(Conf::getUrl($sLink));

    if (isset($params['back']))
    {
        if (isset($_SESSION['back_urls'][$sLink]))
            $oUrl->setParams($_SESSION['back_urls'][$sLink]);
        unset($params['back']);
    }
    $oUrl->setParams($params);

    return $oUrl->getUrl();
}
?>