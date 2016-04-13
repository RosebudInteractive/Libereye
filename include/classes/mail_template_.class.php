<?php
require_once 'classes/utils/dbitem.class.php';

/** ============================================================
 * Class MailTemplate for working with data in table `mail_template`
 * @author Rudenko S.
 * @package mail_var
 * ============================================================ */
class MailTemplate extends DbItem
{

    function MailTemplate()
    {
        parent::DbItem();
        $this->_initTable('mail_template');
    }
    
    /**
     * Get list of manual templates
     *
     * @return array
     */
    function getTemplates()
    {
        return $this->oDb->getRows('SELECT template_id, code, description FROM '.$this->sTable.' WHERE status="manual"');
    }
}
?>