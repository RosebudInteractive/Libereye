<?php
/** ============================================================
 *  This class performs sorting operations
 * @package core
 * ============================================================ */

class Sorter
{
    /** Field for current sorting
     * @var string
     */
    var $sSortField='';

    /** Order (up/down) of current sort
     * @var string
     */
    var $sSortOrder='down';

    /** Aliases of available for sorting fields
     * @var array
     */
    var $aFields = array();

    /** Key in url for storing field for sorting
     * @var string
     */
    var $sUrlFieldKey = 'field';

    /** Key in url for storing order of sorting
     * @var string
     */
    var $sUrlDirKey = 'order';

    /** Name of Up image
     * @var string
     */
    var $sUpImg = 'up.gif';

    /** Name of Down image
     * @var string
     */
    var $sDownImg = 'down.gif';

    /** Name of empty (no sorting) image
     * @var string
     */
    var $sEmptyImg = 'none.gif';

    /** Creates sorting info
     * @param array $aFields fields for sorting e.g. array('id', date, 'name'). Not empty array.
     * @param array $aDefSort ('id'=>'desc', 'name'=>'asc'). Empty array = (first field=>desc)
     * @return object Sorter
     * @access public
     */
    function Sorter($aFields, $aDefSort=array())
    {
        if (!is_array($aDefSort))
            $aDefSort = array('' => 'down');
        list($this->sSortField, $this->sSortOrder) = each($aDefSort);

        $this->sSortField = in_array($this->sSortField, $aFields) ? $this->sSortField : current($aFields);
        $this->sSortOrder = ($this->sSortOrder == 'up' ? 'up' : 'down');
        $this->aFields    = $aFields;
    }

    /** Init sorter with current sorting params
     * @param array $aCurrent field and direction for current sorting  e.g.  array('field'=>'name','order'=>'up')
     * @return void
     * @access public
     */
    function init($aCurrent)
    {
        $sField = $aCurrent[$this->sUrlFieldKey];
        if (in_array($sField, $this->aFields))
            $this->sSortField = $sField;
        $this->sSortOrder = ($aCurrent[$this->sUrlDirKey] == 'up' ? 'up' : 'down');
        return true;
    }

    /** Returns sorting info: array of urls/images
     * @param object $oUrl page url
     * @return array sorting info
     * @access public
     */
    function getSorting($oUrl)
    {
        // array url + img
        $aSortParam = array();

        foreach($this->aFields as $sField)
        {
            $oUrl->setParam($this->sUrlFieldKey, $sField);
            $oUrl->setParam($this->sUrlDirKey, 'up');
            $aSortParam[$sField]['url'] = $oUrl->getUrl();
            $aSortParam[$sField]['img'] = $this->sEmptyImg;
        }

        $oUrl->setParam($this->sUrlFieldKey, $this->sSortField);
        $oUrl->setParam($this->sUrlDirKey, ('up' == $this->sSortOrder ? 'down': 'up'));

        $aSortParam[$this->sSortField]['url'] = $oUrl->getUrl();
        $aSortParam[$this->sSortField]['img'] = ('down'== $this->sSortOrder ? $this->sDownImg : $this->sUpImg);

        return $aSortParam;
    }


    /** Returns sorting info: array of urls/images
     * @param object $oUrl page url
     * @return array sorting info
     * @access public
     */
    function getSortingCustom($sUrl, $sPost='')
    {
        // array url + img
        $aSortParam = array();

        foreach($this->aFields as $sField)
        {
            $aSortParam[$sField]['url'] = $sUrl.$this->sUrlFieldKey.'='.$sField.'&'.$this->sUrlDirKey.'=up';
            $aSortParam[$sField]['img'] = $this->sEmptyImg;
        }
        $aSortParam[$this->sSortField]['url'] = $sUrl.$this->sUrlFieldKey.'='.$this->sSortField.'&'.$this->sUrlDirKey.'='.('up' == $this->sSortOrder ? 'down': 'up');
        $aSortParam[$this->sSortField]['img'] = ('down'== $this->sSortOrder ? $this->sDownImg : $this->sUpImg);

        return $aSortParam;
    }


    /** Prepares string for sql 'order by' statement
     * @return string like 'field_name DESC'  or ''
    */
    function getOrder()
    {
        if ($this->sSortField)
            return $this->sSortField.' '.( $this->sSortOrder == 'up' ? 'ASC' : 'DESC');
        return '';
    }
}
?>