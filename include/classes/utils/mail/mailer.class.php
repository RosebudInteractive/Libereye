<?php
require_once 'mime.class.php';

class Mailer extends Common
{
    /**
     * Mailer
     *
     * @var Mail_Mime
     */
    var $oSender;

    function Mailer()
    {
        parent::Common();
        $this->oSender = new Mail_Mime();
    }

    function get($aConf=array())
    {
        if (! $aConf)
            $aConf = Conf::get('mail');
        $oMailer = new Mailer();
        $oMailer->oSender->setReturnPath($aConf['return_path']);
        $oMailer->oSender->images_dir  = $aConf['images_dir'];
        $oMailer->oSender->smtp_params = $aConf['smtp'];

        return $oMailer;
    }

    function send($sTplCode, $sEmail, $aVars=array(), $aParams=array(), $aFiles=array(), $nLanguage=0)
    {
        if (!$sEmail)
            return $this->_addError('mail.empty_to');

        $oDb = &Database::get();
        $aTpl = $oDb->getRow('SELECT m_subject, m_text, m_html, m_fname, m_faddr, m_rname, m_raddr FROM '.Conf::getT('mail_template').' WHERE code="'.$sTplCode.'" and language_id="'.$nLanguage.'"');
        if (! $aTpl)
            return $this->_addError('mail.invalid_code', $sTplCode, true);

        if ($aParams)
            $aTpl = array_merge($aTpl, $aParams);

        if ($aVars)
        {
            $aTpl['m_subject'] = $this->_compile($aTpl['m_subject'], $aVars);
            $aTpl['m_text']  = $this->_compile($aTpl['m_text'], $aVars);
            $aTpl['m_html'] = $this->_compile($aTpl['m_html'], $aVars);
        }

        foreach ($aFiles as $sName => $sPath)
            $this->oSender->addAttachment(file_get_contents($sPath), $sName);

        $this->oSender->setSubject($this->_encode($aTpl['m_subject'], true));
        //$this->oSender->setText($this->_encode($aTpl['m_text']));
        
        $oTpl = new Template();
        $oTpl->assignSrc(array('sHtml'=>$aTpl['m_html']));
        $aTpl['m_html'] = $oTpl->fetch('visitor/mail_template.html');
        
        $this->oSender->setHtml($aTpl['m_html'], $aTpl['m_text']);

        $this->oSender->setHeader('From', $this->_encode($aTpl['m_fname'], true).' <'.$aTpl['m_faddr'].'>');
        // $this->oSender->setHeader('Reply-To', $aTpl['rname'].' <'.$aTpl['raddr'].'>');

        if (! $this->oSender->send(array($sEmail)))
            return $this->_addError('mail.send', $this->oSender->errors);

        return true;
    }

    function _compile($sStr, $aVars)
    {
        foreach( $aVars as $k => $v)
          $sStr = str_replace('{'.strtolower($k).'}',$v, $sStr);
        return $sStr;
    }
    
    function _encode($input, $from=false)
    {
    	if ($from)
        	$input = '=?utf-8?B?'.base64_encode($input).'?=';
        else 
        	$input = base64_encode($input);
        return $input;
    }    
}

?>