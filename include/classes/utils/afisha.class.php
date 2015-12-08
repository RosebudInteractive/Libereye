<?php
require_once 'classes/utils/parser.class.php';

class Afisha {
	function Afisha()
	{
		
	}
	
	function getPhotos($sFolder, $nItemId, $sItemType, $nNum=5) {
		$aImages = array();
		$oParser = new Parser();
		$sHtml = $oParser->openUrl('http://www.afisha.ru/'.$sItemType.'/photo/'.$nItemId.'/');
		if ($aM4 = $oParser->getMatched('@<a class="photo-link" href=\'(.*?)\'></a>@si', $sHtml, true)) {
			$aM4[1] = array_slice($aM4[1], 0, $nNum);
			foreach ($aM4[1] as $sPhotoUrl) {
				$sHtml = $oParser->openUrl($sPhotoUrl);
				if ($aM = $oParser->getMatched('@<img id="ctl00_CenterPlaceHolder_ucPhotoPageContent_imgBigPhoto" src="(.*?)"@si', $sHtml)) {
					$sName = substr($aM[1], strrpos($aM[1], '/')+1);
					$bCopied = false;
					if (!file_exists($sFolder.$sName)) {
						if ($oParser->copyFile($aM[1], $sFolder.$sName)) {
							$oParser->copyFile($sFolder.$sName, $sFolder.'t'.$sName, false);
							$oImage->loadInfo($sFolder.$sName);
							$oImage->addWatermark(Conf::get('path').'design/css/watermark.png');
							$oImage->loadInfo($sFolder.'t'.$sName);
							$oImage->makeThumbnail($sFolder.'t'.$sName, 100, 100);
							$bCopied = true;
						}
					} else {
						$bCopied = true;
					}
					if ($bCopied)
						$aImages[] = $sName;
				}
			}
		}
		return $aImages;
	}
	
	
}