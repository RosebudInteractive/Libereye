<?php
/** ============================================================
 * Class for creation of detailed paging info
 * @package core
 * ============================================================ */

class Pager
{
    /** Rows count
     * @var integer
     */
    var $nRows;

    /** Current page
     * @var integer
     */
    var $nPage;

    /** Rows per page
     * @var integer
     */
    var $nPageSize;

    /** Pages per frame
     * @var integer
     */
    var $nFrameSize;

    /** Count of pages
     * @var integer
     */
    var $nPagesCount;

    /** First row
     * @var integer
     */
    var $nFirstRow;

    /** Last row
     * @var integer
     */
    var $nLastRow;

    /** URL key for page param e.g. in http://example.com/?page=3 it is 'page'
     * @var string
     */
    var $sUrlKey = 'page';


    /** Creates pager
     * @param int $nRows
     * @param int $nPage
     * @param int $nPageSize
     * @param int $nFrameSize
     * @return object Pager
     * @access public
     */
    function Pager($nRows, $nPage = 1, $nPageSize = 20, $nFrameSize = 10)
    {
        $this->nRows       = max(intVal($nRows), 0);
        $this->nPageSize   = max(intVal($nPageSize), 1);
        $this->nFrameSize  = max(intVal($nFrameSize), 1);
        $this->nPagesCount = ceil($this->nRows / $this->nPageSize);
        $this->nPage       = max(1, min($this->nPagesCount, intVal($nPage)));
        $this->nFirstRow   = $this->nPageSize*($this->nPage-1);
        $this->nLastRow    = min($this->nFirstRow + $this->nPageSize, $this->nRows);
    }

    /** Calculates first/last page in a current frame
     * @return array ($nStart, $nEnd)
     * @access private
     */
    function _getPos()
    {
        $nStart = 1;
        if (($this->nPage - $this->nFrameSize/2)>0)
        {
            if (($this->nPage + $this->nFrameSize/2) > $this->nPagesCount)
                $nStart = (($this->nPagesCount - $this->nFrameSize)>0) ? ( $this->nPagesCount - $this->nFrameSize + 1) : 1;
            else
                $nStart = $this->nPage - floor($this->nFrameSize/2);
        }

        $nEnd = (($nStart + $this->nFrameSize - 1) < $this->nPagesCount) ? ($nStart + $this->nFrameSize - 1) : $this->nPagesCount;
        return array($nStart, $nEnd);
    }

    /** Calculates offset
     * @param  int $nPage page num
     * @param  int $nPageSize page size
     * @return int possition of first record = page_size*(page-1);
     */
    function getOffset($nPage, $nPageSize)
    {
        return max(1, intVal($nPageSize))*(max(1, intVal($nPage))-1);
    }

    /** Returns Sql LIMIT statement
     * @param  int $nPage page num
     * @param  int $nPageSize page size
     * @return string 'LIMIT start,count'
     */
    function getLimit($nPage, $nPageSize)
    {
        return ' LIMIT '.Pager::getOffset($nPage, $nPageSize).','.$nPageSize;
    }

    /** Returns paging info: 'totalPages', 'totalRows', 'current', 'fromRow','toRow', 'firstUrl', 'prevUrl', 'nextUrl', 'lastUrl',  'urls' (url=>page)
     * @param Url $oUrl page url
     * @return array paging info
     * @access public
     */
    function getInfo($oUrl)
    {
        $aInfo = array(
            'totalPages' => $this->nPagesCount,
            'totalRows'  => $this->nRows,
            'current'    => $this->nPage,
            'fromRow'    => $this->nFirstRow+1,
            'toRow'      => $this->nLastRow,
        );
        
        $oUrl->setParam('order', ($oUrl->getParam('order')=='down' ? 'up' : 'down'));
		
        if (1 != $this->nPage)
        {
            $oUrl->setParam($this->sUrlKey, 1);
            $aInfo['firstUrl'] = $oUrl->getUrl();

            $oUrl->setParam($this->sUrlKey, $this->nPage-1);
            $aInfo['prevUrl'] = $oUrl->getUrl();
        }

        list($nStart, $nEnd) = $this->_getPos();
        for ($i=$nStart; $i<=$nEnd; ++$i)
        {
            if ($this->nPage == $i)
                $aInfo['urls'][''] = $i;
            else
            {
                $oUrl->setParam($this->sUrlKey, $i);
                $aInfo['urls'][$oUrl->getUrl()] = $i;
            }
        }

        if ($this->nPagesCount != $this->nPage)
        {
            $oUrl->setParam($this->sUrlKey, $this->nPage+1);
            $aInfo['nextUrl'] = $oUrl->getUrl();
            $oUrl->setParam($this->sUrlKey, $this->nPagesCount);
            $aInfo['lastUrl']= $oUrl->getUrl();
        }
        return $aInfo;
    }
    
    /** Returns paging info: 'totalPages', 'totalRows', 'current', 'fromRow','toRow', 'firstUrl', 'prevUrl', 'nextUrl', 'lastUrl',  'urls' (url=>page)
     * @param Url $oUrl page url
     * @return array paging info
     * @access public
     */
    function getInfoCustom($sUrl, $sPost='')
    {
        $aInfo = array(
            'totalPages' => $this->nPagesCount,
            'totalRows'  => $this->nRows,
            'current'    => $this->nPage,
            'fromRow'    => $this->nFirstRow+1,
            'toRow'      => $this->nLastRow,
        );

        if (1 != $this->nPage)
        {
            $aInfo['firstUrl'] = $sUrl.'1'.$sPost;
            $aInfo['prevUrl'] = $sUrl.($this->nPage-1).$sPost;
        }

        list($nStart, $nEnd) = $this->_getPos();
        for ($i=$nStart; $i<=$nEnd; ++$i)
        {
            if ($this->nPage == $i)
                $aInfo['urls'][''] = $i;
            else
            {
                $aInfo['urls'][$sUrl.$i.$sPost] = $i;
            }
        }

        if ($this->nPagesCount != $this->nPage)
        {
            $aInfo['nextUrl'] = $sUrl.($this->nPage+1).$sPost;
            $aInfo['lastUrl']= $sUrl.$this->nPagesCount.$sPost;
        }
        return $aInfo;
    }


}