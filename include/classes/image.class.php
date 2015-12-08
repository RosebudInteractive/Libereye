<?php
/** ============================================================
 * Class Bank. 
 * 
 * @author Rudenko S.
 * @package
 * ============================================================ */
require_once 'classes/utils/dbitem.class.php';

class Image extends DbItem
{

    function Image()
    {
        parent::DbItem();
        $this->_initTable('image');
    }
    
    function upload($sFrom, $sObject, $sObjectId, $sExt, $sToken='')
    {
    	$sFromClear = preg_replace('@\?.*@i', '', $sFrom); // image.jpg?www=1&ddd=2 => image.jpg
		$sFileName = md5(uniqid(rand(), true)).($sExt?('.'.$sExt):substr($sFromClear, strrpos($sFromClear, '.')));
		$sFileDir = implode('/', str_split(substr($sFileName, 0, 3), 1)).'/'; // a/b/c/d/
		$sFileFullDir = Conf::get('image.path').$sObject.'/'.$sFileDir;

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
		
		if (!$this->aErrors)
		{
			//$nAttempt = 2;			
			//do
			//{

				$bCopy = $this->copyFile($sFrom, $sFileFullDir.$sFileName);
				//if (!$bCopy) sleep(1);
				//$nAttempt--;
           // echo $sFrom.' '.$sFileFullDir.$sFileName. ' '.$bCopy;
			//}while (!$bCopy && $nAttempt>0);
			
			if ($bCopy && @getimagesize($sFileFullDir.$sFileName))
			{
				@chmod($sFileFullDir.$sFileName, 0644);
				list($width, $height, $type, $attr) = getimagesize($sFileFullDir.$sFileName);
				if ($width && $height)
				{
					$this->aData = array(
						'object_type' => $sObject,
						'object_id' => $sObjectId,
						'name' => $sFileDir.$sFileName,
						'width' => $width,
						'height' => $height,
						'md5_file'=> md5_file($sFileFullDir.$sFileName),
						'cdate' => Database::date(),
						'token' => $sToken
					);
					return $this->insert();
				}
				else 
				{
					return false;
				}
			}
			else 
			{
				return false;
			}
		}
		
    	return false;
    }
    
    function copyFile($source, $dest)
	{
		
		/*if (function_exists('curl_init')) {
			echo 's';
			$ch = curl_init ($source);
			$fp = @fopen ($dest, "w");
			if ($fp)
			{
				curl_setopt ($ch, CURLOPT_FILE, $fp);
				curl_setopt ($ch, CURLOPT_HEADER, 0);
				curl_setopt ($ch, CURLOPT_TIMEOUT, 10);
				curl_exec ($ch);
				curl_close ($ch);
				fclose ($fp); 
				echo 'f';	
				if (filesize($dest))				
				{
					return true;
				}
				else 
				{
					unlink($dest);
					return false;
				}
			}
			return false;
		}
		else*/ {
			return copy($source, $dest);
		}
	}
    
}
?>