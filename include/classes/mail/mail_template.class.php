<?
Conf::loadClass('utils/dbitem');

/** Class for working with mail templates.
 * Fields:
 *   'template_id' -- template ID
 *   'code'        -- template code
 *   'description' -- description
 *   'm_subject'   -- subject
 *   'm_text'      -- text version of message
 *   'm_html'      -- HTML version of message
 *   'm_fname'     -- `from` name
 *   'm_faddr'     -- `from` address
 *   'm_rname'     -- `return-to` name
 *   'm_raddr'     -- `return-to` address
 */
class MailTemplate extends DbItem
{

    function MailTemplate()
    {
        parent::DbItem();
        $this->_initTable('mail_template');
    }

    function getMailTemplatesList()
    {
        $sSql = 'SELECT template_id, description, m_subject, m_text, m_html, m_fname, m_faddr, m_rname, m_raddr, status '.
                '  FROM '.$this->sTable.' WHERE code <> "empty"';
        $aTpls = $this->oDb->getRows($sSql, true, 'template_id');

        $sSql = 'SELECT mail_var_id, template_id, var_name, descr '.
                '  FROM '.Conf::getT('mail_var').
                '  ORDER BY var_name';
        $aVars = $this->oDb->getRows($sSql);
        foreach($aVars as $aVar)
        {
            if (isset($aTpls[$aVar['template_id']]))
                $aTpls[$aVar['template_id']]['vars'][] = $aVar;
        }

        return $aTpls;
    }
}


?>