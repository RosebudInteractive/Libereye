<?php
/** ============================================================
 * Validator config
 * @author Rudenko S.
 * @package validator
 * ============================================================ */

//validator's deafults

global $_CONF;

//validator's deafults
$_CONF['validator.def']= array(
    'login' => array(
        'pattern'=>'/^[A-Za-z_0-9]+$/'
    ),
    'email' => array(
        'pattern'=>'/^[A-Za-z_0-9\.\-]+@[A-Za-z0-9\.\-]+\.[A-Za-z]{2,}$/'
    ),
    'name' => array(
        'minlen'=>1,
        'maxlen'=>150
    ),
    'address' => array(
        'minlen'=>1,
        'maxlen'=>150
    ),
    'city' => array(
        'minlen'=>1,
        'maxlen'=>150,
        'pattern'=>'/^[\d\w\-\s\']+$/'
    ),
    'zip'  => array(
        'pattern'=>'/^[a-zA-Z0-9]{1,10}$/',
    ),

    'zip_us'  => array(
        'pattern'=>'/^([0-9]{5})|([0-9]{5}-[0-9]{4})$/',
    ),

    'phone'  => array(
        'minlen'=>7,
        'pattern'=>'/^[0-9\-\(\)\.\+]+$/',
    ),
    'phone_us' => array(
        'minlen'=>7,
        'pattern'=>'/^[\d]{3}-[\d]{3}-[\d]{4}$/',
    ),

    'password' => array(
        'minlen'=>6,
        'maxlen'=>12,
    ),
    'required'  => array(
        'minlen'=>1,
    ),

    'website'  => array(
        'pattern'=>'/^http:\/\/([a-zA-Z0-9\-]{2,}\.)+[a-zA-Z0-9]{2,}$/',
    ),
    
    'url'  => array(
        'pattern'=>'/^http:\/\/([a-zA-Z0-9\-]{2,}\.)+[a-zA-Z0-9]{2,}(\/.+)?$/',
    ),
    'freindly-url' => array(
        'pattern'=>'/^[A-Za-z_0-9\-]+$/'
    ),    
    'ccard'  => array(
        'minlen' =>16,
        'maxlen' =>18,
        'pattern'=>'/^[0-9]+$/',
    ),
    'cvv'  => array(
        'minlen' =>3,
        'maxlen' =>4,
        'pattern'=>'/^[\d]+$/',
    ),
    'ssn' => array(
        'pattern'=>'/^([\d]{3}-[\d]{2}-[\d]{4})|([\d]{2}-[\d]{7})$/',
    ),
    'integer' => array(
        'pattern'=>'/^[\d]+$/',
    ),
    'float' => array(
        'pattern'=>'/^[\d]+(\.[\d]{1,2})?$/',
    ),
    'date_us' => array(
        'pattern'=>'/^(0?[1-9]|1[0-2])\/(0?[1-9]|[1-2][0-9]|3[0,1])\/((19|20)[0-9][0-9]{1})$/',
    ),
    'date_card'  => array(
        'pattern'=>'/^[0-9]{2}\/[0-9]{2}$/',
    ),
    'money' => array(
        'pattern'=>'/^[\d]+(\.[\d]{1,2}){0,1}$/',
    ),
    'pos' => array(
        'pattern'=>'/^[\d]+$/',
        'min'    =>1,
    ),
    'sitemap_page' => array(
        'pattern'=>'/^[\d]+$/',
        'max'    =>6,
    ),
    'exam_code'  => array(
        'pattern'=>'/^[a-zA-Z0-9\+\-]+$/',
        'minlen' => 1,
        'maxlen' => 20,
    ),
    'keyword'  => array(
        'pattern'=>'/^[\w\s]+[\w\s\,]*$/',
    ),
);

?>