<?php
/** ============================================================
 *  Smarty template object extension
 * @package core
 * @todo check and comment
 * ============================================================ */

require_once 'classes/utils/smarty/Smarty.class.php';

class Template extends Smarty
{
    /** Template file name (template.html by default)
     * @var string
     */
    var $sTemplateFile = 'template.html';
    
    /** Constructor
    */
    function Template($aConf=array())
    {
        parent::__construct();
        if (! $aConf)
            $aConf = conf::get('template');

        $this->template_dir = $aConf['dir'].LANGUAGE.'/';
        $this->compile_dir  = $aConf['c_dir'].LANGUAGE.'/';
        $this->use_sub_dirs = false;

        $this->assign('sBaseUrl', $aConf['url']);
    }

    /** Display
    * @see Smarty::display
    */
    function view($sTpl, $sDir='')
    {
        $this->assign(array(
            'sTplName'   => $sTpl,
        ));

        if (!$sDir)
            $sDir = substr($sTpl, 0, strpos($sTpl, '/'));
        //echo $sDir.'/template.html';
        
        $this->display( $sDir.'/'.$this->sTemplateFile );
        //showSql();
    }

    function addMes($sUrl)
    {    	    	
        if (isset($_SESSION[$sUrl]['err']))
        {
            $this->assign($_SESSION[$sUrl]['err'][2], $_SESSION[$sUrl]['err'][0]);
            $this->assign('bSessErr', $_SESSION[$sUrl]['err'][1]);
            unset($_SESSION[$sUrl]['err']);
        }
    }

    function assign($mVar, $mVal=null)
    {
        if (is_array($mVar))
        {
            foreach($mVar as $sVal=>$mVal)
                $this->assign($sVal, $mVal);
        }
        elseif(! is_object($mVar))
        {
            parent::assign($mVar, $this->_escape($mVal));
        }
    }

    function assignSrc($mVar, $mVal=null)
    {
        parent::assign($mVar, $mVal);
    }


    function _escape($mVal)
    {
        if (is_array($mVal))
        {
            foreach($mVal as $k=>$v)
                $mVal[$k] = $this->_escape($v);
        }
        elseif(is_object($mVal))
        {
            /** @todo do something with class!!! */
        }
        else
            $mVal = htmlspecialchars($mVal);

        return $mVal;
    }

}
?>