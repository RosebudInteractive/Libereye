<?php

class Parser {
	function Parser()
	{
		
	}
	
	function openUrl($url, $sCookie='', $sPostFields='', $sRef='', $sProxy='')
	{
	   $nTries = 10;
	   
	   do {	
		   $data = '';
	       $ch = curl_init($url);
	       curl_setopt($ch, CURLOPT_ENCODING, 'gzip');
	       if ($sCookie)
	       {
	       		curl_setopt($ch, CURLOPT_COOKIE, $sCookie);
	       }
	       if ($sPostFields)		
	       {
	       		curl_setopt($ch, CURLOPT_POST, 1);
	       		curl_setopt($ch, CURLOPT_POSTFIELDS, $sPostFields);
	       }
	       if ($sRef)
	       		curl_setopt($ch, CURLOPT_REFERER, $sRef); 
	       if ($sProxy)
	       		curl_setopt($ch, CURLOPT_PROXY, $sProxy);
	       		
	       curl_setopt($ch, CURLOPT_HEADER, 1);
	       curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
	       //curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
	       curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 10);
	       curl_setopt($ch, CURLOPT_TIMEOUT, 10);
	       curl_setopt($ch, CURLOPT_USERAGENT, 'Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.0.17) Gecko/2009122116 Firefox/3.0.17');
	       curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
	       
	       $data = curl_exec($ch);
	       curl_close($ch);
	       $nTries--;
       
	   } while (!$data && $nTries > 0);	  
       
            
	   return $data;
	}
	
	function getCookies($sUrl, $sPostFields='')
	{
		$ch = curl_init($sUrl);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
		curl_setopt($ch, CURLOPT_HEADER, 1);
		curl_setopt($ch, CURLOPT_NOBODY, 1);
		
		if ($sPostFields)		
		{
			curl_setopt($ch, CURLOPT_POST, 1);
			curl_setopt($ch, CURLOPT_POSTFIELDS, $sPostFields);
		}
	       
		$sCookies = '';
		if (preg_match_all('/^Set-Cookie: (.*?);/m', curl_exec($ch), $m))
		{
			$sCookies = implode('; ', $m[1]);
		}
		return $sCookies;
	}
	
	/**
	 * ���y file
	 *
	 * @param from $source
	 * @param to $dest
	 * @return bool
	 */
	function copyFile($source, $dest, $curl=true)
	{
		
		if(function_exists('curl_init') && $curl)
    	{	  
    		$fp = fopen ($dest, "w");
			if ($fp)
			{  		
				$ch = curl_init ($source);
				curl_setopt ($ch, CURLOPT_HEADER, 1);
				curl_setopt ($ch, CURLOPT_NOBODY, 1);
				curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
				$sHeader = curl_exec ($ch);
				curl_close ($ch);
				
				if (preg_match('@Location: (.*)@', $sHeader, $aM))
				{
					$source = trim($aM[1]);
				}
				
				$ch = curl_init ($source);
				curl_setopt($ch, CURLOPT_TIMEOUT, 60*60); 
				curl_setopt ($ch, CURLOPT_FILE, $fp);
				curl_setopt ($ch, CURLOPT_HEADER, 0);
				curl_exec ($ch);
				curl_close ($ch);
				chmod($dest, 0666);	
				fclose ($fp); 	
			}
			return file_exists($dest);
    	}
    	else 
    	{	    		
    		return copy($source, $dest);
    	}
		
		return false;
	}	
	
	function getHttpResponseCode($url)
    {
        $ch = @curl_init($url);
        @curl_setopt($ch, CURLOPT_HEADER, TRUE);
        @curl_setopt($ch, CURLOPT_NOBODY, TRUE);
        @curl_setopt($ch, CURLOPT_FOLLOWLOCATION, FALSE);
        @curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
        $status = array();
        $status = @curl_getinfo($ch);
        return $status['http_code'];
    }	
    
    function getLocation($sUrl)
    {
		$ch = curl_init ($sUrl);
		curl_setopt ($ch, CURLOPT_HEADER, 1);
		curl_setopt ($ch, CURLOPT_NOBODY, 1);
		curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
		$sHeader = curl_exec ($ch);
		curl_close ($ch);
		
		if (preg_match('@Location: (.*)@', $sHeader, $aM))
		{
			$sUrl = trim($aM[1]);
		}     
		return $sUrl;   
    }  
      
    function getHeaderLine($sUrl, $sLine)
    {
		$ch = curl_init ($sUrl);
		curl_setopt ($ch, CURLOPT_HEADER, 1);
		curl_setopt ($ch, CURLOPT_NOBODY, 1);
		curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
		$sHeader = curl_exec ($ch);
		curl_close ($ch);
		
		if (preg_match('@'.preg_quote($sLine).' (.*)@', $sHeader, $aM))
		{
			$sUrl = trim($aM[1]);
		}     
		return $sUrl;   
    }
	
	function getMatched($sPattern, $sSubject, $bAll=false)
	{
		$aMatches = array();
		if (!$bAll) {
			preg_match($sPattern, $sSubject, $aMatches);
		} else {
			preg_match_all($sPattern, $sSubject, $aMatches);
		}
		return $aMatches;
	}
	
	
	function html2text($sHtml)
	{
		// $document should contain an HTML document.
		// This will remove HTML tags, javascript sections
		// and white space. It will also convert some
		// common HTML entities to their text equivalent.
		$search = array ('@<script[^>]*?>.*?</script>@si', // Strip out javascript
		                 '@<[\/\!]*?[^<>]*?>@si',          // Strip out HTML tags
		                 '@([\r\n])[\s]+@',                // Strip out white space
		                 '@&(quot|#34);@i',                // Replace HTML entities
		                 '@&(amp|#38);@i',
		                 '@&(lt|#60);@i',
		                 '@&(gt|#62);@i',
		                 '@&(nbsp|#160);@i',
		                 '@&(iexcl|#161);@i',
		                 '@&(cent|#162);@i',
		                 '@&(pound|#163);@i',
		                 '@&(copy|#169);@i',
		                 '@&#(\d+);@e');                    // evaluate as php
		
		$replace = array ('',
		                  '',
		                  '\1',
		                  '"',
		                  '&',
		                  '<',
		                  '>',
		                  ' ',
		                  chr(161),
		                  chr(162),
		                  chr(163),
		                  chr(169),
		                  'chr(\1)');
		
		$sText = preg_replace($search, $replace, $sHtml);
		return $sText;
	}
	
}