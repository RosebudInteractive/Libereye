<?php
require_once 'classes/utils/file/file.class.php';

class CImage extends CFile
{
    var $nH;
    var $nW;

    function CImage()
    {
        parent::CFile();
        $this->aLimits['PERMITTED_TYPES'] = conf::get('image.types');
        $this->aLimits['FILE_MAX_SIZE']   = conf::get('image.max_size');
        $this->aLimits['MAX_IMAGE_W']     = conf::get('image.max_w');
        $this->aLimits['MAX_IMAGE_H']     = conf::get('image.max_h');
        $this->aLimits['MIN_IMAGE_W']     = conf::get('image.min_w');
        $this->aLimits['MIN_IMAGE_H']     = conf::get('image.min_h');
        $this->sDestPath = Conf::get('image.path');
    }

    function loadInfo($sPath)
    {
        if (!parent::loadInfo($sPath))
            return false;

        if ($aInfo = @getImageSize($this->sPath))
        {
            $aTypes = array('', 'gif', 'jpg', 'png', 'swf', 'psd', 'bmp', 'tiff', 'tiff', 'jpc', 'jp2', 'jpx', 'jb2', 'swc', 'iff', 'wbmp', 'xbm');

            $this->nW = $aInfo[0];
            $this->nH = $aInfo[1];
            $this->sType = $aTypes[$aInfo[2]];
            //PHP >= 4.3.0
            $this->sMimeType = $aInfo['mime'];
            return true;
        }
        return $this->_addError('image.unsupported_type', $this->getName());
    }

    function _checkLimits()
    {
        if (! parent::_checkLimits())
            return false;

        if ($this->aLimits['MAX_IMAGE_W'] and $this->nW > $this->aLimits['MAX_IMAGE_W'])
            $this->_addError('image.max_w', $this->aLimits['MAX_IMAGE_W'] );

        if ($this->aLimits['MIN_IMAGE_W'] and $this->nW < $this->aLimits['MIN_IMAGE_W'])
            $this->_addError('image.min_w', $this->aLimits['MIN_IMAGE_W'] );

        if ($this->aLimits['MAX_IMAGE_H'] and $this->nH > $this->aLimits['MAX_IMAGE_H'])
            $this->_addError('image.max_h', $this->aLimits['MAX_IMAGE_H'] );

        if ($this->aLimits['MIN_IMAGE_H'] and $this->nH < $this->aLimits['MIN_IMAGE_H'])
            $this->_addError('image.min_h', $this->aLimits['MIN_IMAGE_H'] );

        if ($this->aLimits['PERMITTED_TYPES'] and !in_array($this->sType, $this->aLimits['PERMITTED_TYPES']))
            $this->_addError('image.unsupported_type');

        return (sizeof($this->aErrors) == 0);
    }

    /** Adds watermark to current image file
     * @see http://www.sitepoint.com/article/watermark-images-php
     * @param string $sWmPath path to _PNG-8_ image with watermark
     * @return boolean
     */
    /*function addWatermark($sWmPath)
    {

        $hWm   = imageCreateFromPng($sWmPath);
        $nW    = imageSx($hWm);
        $nH    = imageSy($hWm);
        $hImg  = $this->_createImg();

        $nDestX = $this->nW - $nW - 5;
        $nDestY = $this->nH - $nH - 5;
        imageCopyMerge($hImg, $hWm, $nDestX, $nDestY, 0, 0, $nW, $nH, 100);

        imageJpeg($hImg, $this->sPath);

        imageDestroy($hImg);
        imageDestroy($hWm);

        return true;
    }*/
    
    function addWatermark($sWmPath)
    {
	    $offset = 5;//отступ от правого нижнего края
	    $img  = $this->_createImg();
	    $r = imagecreatefrompng($sWmPath);
	    $x = imagesx($r);
	    $y = imagesy($r);
	    $xDest = $this->nW - ($x + $offset);
	    $yDest = $this->nH - ($y + $offset);
	    imageAlphaBlending($img,1);
	    imageAlphaBlending($r,1);
	    imagesavealpha($img,1);
	    imagesavealpha($r,1);
	    imagecopyresampled($img,$r,$xDest,$yDest,0,0,$x,$y,$x,$y);
	    switch ($this->sType) {
	            case "jpg":
	            case "jpeg":
	                imagejpeg($img, $this->sPath, 90);
	            break;
	            case "gif":
	                imagegif($img, $this->sPath);
	            break;
	            case "png":
	                imagepng($img, $this->sPath);
	            break;
	        }
	    imagedestroy($r);
	    imagedestroy($img);
	}

    /** Returns image handler
    */
    function _createImg()
    {
        $hImg = 0;
        switch ($this->sType)
        {
            case 'gif':
                $hImg = imageCreateFromGif($this->sPath);
                break;
            case 'png':
                $hImg = imageCreateFromPng($this->sPath);
                break;
            default:
                $hImg = imageCreateFromJpeg($this->sPath);
        }
        return $hImg;
    }

    /** Resizes image and writes to file
     * @param int $sPath   destination image file
     * @param int $nMaxW   maximum width
     * @param int $nMaxH   maximum height
     * @param string $sDr   transformation driver code ( gd, im)
     * @param array $aDrParam   driver specific params ( e.g for IM path and quality)
     * @return float ratio in % beetwen full image and thumbnail
     */
    function makeThumbnail($sPath, $nMaxW, $nMaxH, $sDr='gd', $aDrParam=array())
    {
    	if ($this->nW < $nMaxW && $this->nH < $nMaxH)
    		return;
    	
        list($nNewW, $nNewH) = $this->_calcSize($nMaxW, $nMaxH);
        switch ($sDr)
        {
            case 'im': //image magic
               $sCmd  = '"'.$aDrParam['path'].'"'; // //full path to ImageMagick's convert utility
               $sCmd .= ' -geometry '.$nNewW.'x'.$nNewH;
               if ('jpg' == $this->sType)
                   $sCmd .= ' -quality '.$aDrParam['quality'];
               $sCmd .= ' "'.escapeshellcmd($this->sPath).'" "'.escapeshellcmd($sPath).'"';
               exec($sCmd);
            break;
            case 'gd':
            default:
                $hFrm = $this->_createImg();

                $hTo = ImageCreateTrueColor($nNewW, $nNewH);

                imageCopyResampled($hTo, $hFrm, 0, 0, 0, 0, $nNewW, $nNewH, $this->nW, $this->nH);
                switch ($this->sType)
                {
                    case 'gif':
                    case 'png':
                        imagepng($hTo, $sPath);
                        break;
                    default:
                       imagejpeg($hTo, $sPath);
                }
                imageDestroy($hTo);
                imageDestroy($hFrm);
        }
        return ($nNewW * $nNewH)/($this->nW * $this->nH);
    }

    /** Calculates size for resizing.
     * @param int $nMaxW  maximum width
     * @param int $nMaxH  maximum height
     * @return array new size (width, height)
     * @see makeThumbnail()
     */
    function _calcSize($nMaxW, $nMaxH)
    {
        $w  = $nMaxW;
        $h  = $nMaxH;

        if ($this->nW > $nMaxW || ($this->nW < $nMaxW && $this->nH < $nMaxH))
        {
            $w  = $nMaxW;
            $h  = floor($this->nH * $nMaxW/$this->nW);
            if ($h > $nMaxH)
            {
              $h  = $nMaxH;
              $w  = floor($this->nW * $nMaxH/$this->nH);
            }
        }
        elseif ($this->nH > $nMaxH)
        {
            $h  = $nMaxH;
            $w  = floor($this->nW * $nMaxH/$this->nH);
        }

        return array($w, $h);
    }

    // creates random image ( acc to params) and displays it
    // static
    // $nLeft text left offset
    // $nTop text top offset
    // @todo optimize and improve
    function displayRandom($sText='', $nW=245, $nH=75, $nLeft=25, $nTop=5, $aParam=array())
    {
        $hImg = imageCreate($nW, $nH);
        //The first call to imagecolorallocate() fills the background color.
        $nBgColor  = imageColorAllocate ($hImg, 255, 255, 255); //white background
        $nTxtColor = imageColorAllocate($hImg, 92, 92, 92);

        imageString($hImg, 5, $nLeft, $nTop,  $sText, $nTxtColor);

        /*advansed protection : each letter drows with own font and  angle
        $nX = $nLeft;
        for ($i=0; $i < strlen($sText); $i++)
        {
            //select random font
            $sFontPath = $aParam['font_path'].$aParam['fonts'][rand(0, sizeof($aParam['fonts']))];
            $nSize     = $aParam['letter_w']+rand(3,5);
            $nAngle    = rand(-30, 30);
            ImageFtText($hImg, $nSize, $nAngle, $nX, $nH/2 + $aParam['letter_h']/2, $nTxtColor, $sFontPath, $sText[$i]);
            $nX += $aParam['letter_spacing'];
        }
        */
        header('Content-Type: image/jpeg');
        imagejpeg($hImg);
    }
}
?>