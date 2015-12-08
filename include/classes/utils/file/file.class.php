<?php
/** CFile (Common File) is an abstraction of uploadable/downloadable file
 */
class CFile extends Common
{
    // filesize
    var $nSize;

    // mime type
    var $sMimeType;

    // full path to file
    var $sPath;

    // uploading limits
    var $aLimits = array();

    // type of file(exstension)
    var $sType;

    // Real name of uploaded file
    var $sRealName = '';
    
    var $sDestPath;
    
    function CFile()
    {
        $this->aLimits['FILE_MAX_SIZE'] = conf::get('file.max_size');
        $this->sDestPath = Conf::get('image.path');
    }

    function getName()
    {
        return basename($this->sPath);
    }

    function loadInfo($sPath)
    {
        if('' == $this->sRealName)
            $this->sRealName = $sPath;

        $this->sPath = $sPath;
        if (! file_exists($sPath))
            return $this->_addError('file.not_exist', $sPath);

        $this->nSize = filesize($this->sPath);
        if (!$this->nSize)
            return $this->_addError('file.not_exist', $this->sRealName);

        if (! $this->sType)
            $this->sType = subStr($this->sPath, strrpos($this->sPath, '.'));
        return true;
    }


    function move($sDest)
    {
        @rename($this->sPath, $sDest);
        $this->sPath = $sDest;
    }

    // $sDestPath (with /)
    function upload($sFormItem)
    {
        $aFile = CFile::_buildFile($sFormItem);
        $this->sMimeType = $aFile['type'];
        $this->sRealName = $aFile['name'];

        $this->sType = strrpos($aFile['name'], '.');

        if (! $this->loadInfo($aFile['tmp_name']))
            return false;

        if (! $this->_checkLimits())
            return false;

        if (! is_uploaded_file($this->sPath))
            return $this->_addError('file.not_uploaded', $aFile['name']);
            
		$aFile['real_name'] = md5(uniqid(rand(), true)).substr($aFile['name'], strrpos($aFile['name'], '.')); 
		$aFile['real_dir'] = implode('/', str_split(substr($aFile['real_name'], 0, 4), 1)).'/'; // a/b/c/d/
		$sFileFullDir = $this->sDestPath.$aFile['real_dir'];
		// create dir
		if (false === is_dir($sFileFullDir)) 
		{
			if (false === mkdir($sFileFullDir, 0777, true)) 
			{
				$this->_addError('mkdir.error', array($sFileFullDir));
			} 
			else 
			{
				@chmod($sFileFullDir, 0777);
			}
		}            

		if (! @move_uploaded_file($this->sPath, $sFileFullDir.$aFile['real_name']) )
            return $this->_addError('file.not_moved', $aFile['name']);

        $this->sPath = $sFileFullDir.$aFile['real_name'];
        @chmod($this->sPath, 0644);
        
        return $aFile;
    }

    //@todo implement
    function _buildFile($sFormItem)
    {
        $aFile = array();
        if (! strpos($sFormItem, ']'))
            $aFile = $_FILES[$sFormItem];
        elseif (preg_match('/^(.+)\[(.+)\]$/', $sFormItem, $aM))
        {
            $aFile['name']     = $_FILES[$aM[1]]['name'][$aM[2]];
            $aFile['type']     = $_FILES[$aM[1]]['type'][$aM[2]];
            $aFile['tmp_name'] = $_FILES[$aM[1]]['tmp_name'][$aM[2]];
            $aFile['error']    = $_FILES[$aM[1]]['error'][$aM[2]];
            $aFile['size']     = $_FILES[$aM[1]]['size'][$aM[2]];
        }
        else // fatal error
            $this->_addError('file.invalid_input_name', $sFormItem, true);

        return $aFile;
    }

    function _checkLimits()
    {
        if ($this->aLimits['FILE_MAX_SIZE'] and $this->nSize >= $this->aLimits['FILE_MAX_SIZE'])
            return $this->_addError('file.max_size', array($this->nSize, $this->aLimits['FILE_MAX_SIZE']) );
        return true;
    }
}
?>