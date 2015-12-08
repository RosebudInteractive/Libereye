<?php
/** ============================================================
 * @todo descriptions and comments
 * @package core
 * ============================================================ */

class ExelReport
{
    var $row;

    function ExelReport()
    {
        $this->row = 0;
    }
/** @function   makeExcelHeader
    @abstract   Get Excel report header
    @param      $header - array (column headers titles)
    @param      $filename - string (output filename)
    @return     binary data
*/
    function makeExcelHeader($header, $filename)
    {

        header('Content-type: application/octet-stream; name='.$filename);
        header("Content-Disposition: attachment; filename=".$filename);
        header('Expires: 0');
        header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
        header('Pragma: public');

        $out = pack('vvvvvv', 0x809, 0x08, 0x00,0x10, 0x0, 0x0);

        $col = 0;

        foreach ($header as $key => $value)
        {
            $len = strlen($value);
            $out .= pack('v*', 0x0204, 8 + $len, $this->row, $col, 0x00, $len);
            $out .= $value;
            $col ++;
        }
        $this->row++;
        return $out;
    }

    function addUrl($sUrl)
    {
        $this->row++;
        $len = strlen($sUrl);
        $out = '';
        $out .= pack('v*', 0x0204, 8 + $len, $this->row, 0, 0x00, $len);
        $out .= $sUrl;
        $this->row++;
        return $out;
    }

    function makeAddColumn($aAddCol)
    {
        $this->row++;
        $out = '';
        $out .= pack('v*', 0x0204, 8 + strlen($aAddCol['name_col']), $this->row, $aAddCol['num_col']-1, 0x00, strlen($aAddCol['name_col']));
        $out .= $aAddCol['name_col'];
        $out .= pack('v*', 0x0204, 8 + strlen($aAddCol['val']), $this->row, $aAddCol['num_col'], 0x00, strlen($aAddCol['val']));
        $out .= $aAddCol['val'];
        $this->row++;
        return $out;
    }

/** @function   makeExcelData
    @abstract   Get Excel report from specified data (for all MS Excel versions)
    @param      $header - array (column headers titles)
    @param      $data - array
    @return     binary data
*/

    function makeExcelData($header, $data)
    {
        $out = '';
        $keys = array_keys($header);

        foreach($data as $value)
        {
            $col = 0;
            foreach ($keys as $key)
            {
                $len = strlen($value[$key]);
                $out .= pack('v*', 0x0204, 8 + $len, $this->row, $col, 0x00, $len);
                $out .= $value[$key];
                $col ++;
            }
            $this->row ++;
        }

        return $out;
    }

/** @function   makeExcelData
    @abstract   Get Excel report from specified data (for all MS Excel versions)
    @param      $header - array (column headers titles)
    @param      $data - array
    @return     binary data
*/
    function makeExcelFooter()
    {
        return pack('vv', 0x0A, 0x00);
    }

/** @function   makeExcelReport
    @abstract   Get Excel report from specified data (for all MS Excel versions)
    @param      $header - array (column headers titles)
    @param      $data - array
    @param      $filename - string (output filename)
    @param      $url - string (adding url in report)
    @return     binary data
*/
    function makeExcelReport($header, $data, $filename, $url='', $aAddCol = array())
    {
        print $this->makeExcelHeader($header, $filename, $url);
        print $this->makeExcelData($header, $data);
        if ($aAddCol)
            print $this->makeAddColumn($aAddCol);
        if ($url)
            print $this->addUrl($url);
        print $this->makeExcelFooter();
        exit;
    }

    function makeCsvReport($header, $data, $filename, $url='', $aAddCol = array())
    {
        header('Content-type: application/octet-stream; name='.$filename);
        header("Content-Disposition: attachment; filename=".$filename);
        header('Expires: 0');
        header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
        header('Pragma: public');

        foreach ($header as $val)
        {
            $val = str_replace(';', '', $val);
            print $val.';';
        }
        print "\r\n";
        foreach ($data as $aval)
        {
            foreach ($header as $key => $val)
            {
                $aval[$key] = str_replace(';', '', $aval[$key]);
                print '"'.$aval[$key].'";';
            }
            print "\r\n";
        }
        if ($aAddCol)
        {
            print "\r\n";
            for ($i=0; $i < $aAddCol['num_col']-1; $i++)
            {
                print ';';
            }
            print $aAddCol['name_col'].';'.$aAddCol['val'];
        }
        if ($url)
            print "\r\n\r\n".$url;
        exit;
    }
}
?>