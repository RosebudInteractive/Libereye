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
        $aTpl = $oDb->getRow('SELECT fname, faddr, rname, raddr'.
            ', pd1.phrase subject'.
            ', pd2.phrase body'.
            ' FROM template AS t'.
            ' LEFT JOIN phrase p1 ON p1.object_id=t.template_id AND p1.object_type_id=14   AND p1.object_field="subject" '.
            ' LEFT JOIN phrase_det pd1 ON pd1.phrase_id=p1.phrase_id AND pd1.language_id='.$nLanguage.'  '.
            ' LEFT JOIN phrase p2 ON p2.object_id=t.template_id AND p2.object_type_id=14   AND p2.object_field="body" '.
            ' LEFT JOIN phrase_det pd2 ON pd2.phrase_id=p2.phrase_id AND pd2.language_id='.$nLanguage.'  '.
            ' WHERE t.code="'.$sTplCode.'"');
        if (! $aTpl)
            return $this->_addError('mail.invalid_code', $sTplCode, true);

        if ($aParams)
            $aTpl = array_merge($aTpl, $aParams);

        if ($aVars)
        {
            $aTpl['subject'] = $this->_compile($aTpl['subject'], $aVars);
            $aTpl['body'] = $this->_compile($aTpl['body'], $aVars);
        }

        foreach ($aFiles as $sName => $sPath)
            $this->oSender->addAttachment(file_get_contents($sPath), $sName);

        $this->oSender->setSubject($this->_encode($aTpl['subject'], true));
        $oTpl = new Template();
        $oTpl->assignSrc(array('sHtml'=>$aTpl['body']));
        $aTpl['body'] = $oTpl->fetch('visitor/mail_template.html');
        
        $this->oSender->setHtml($aTpl['body']);

        $this->oSender->setHeader('From', $this->_encode($aTpl['fname'], true).' <'.$aTpl['faddr'].'>');
        $this->oSender->setHeader('Reply-To', $this->_encode($aTpl['rname'], true).' <'.$aTpl['raddr'].'>');

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