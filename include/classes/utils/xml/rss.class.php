<?php

class RSS {

    var $_aChannel;

    var $_aImage;

    var $_aItems;


	function RSS () {
		$this->_aItems = array();
	}

	/** Set channel information
	 * @param string $sTitle  channel's title
	 * @param string $sDescr  channel's descripton
	 * @param string $sLink   channel's link
	 * @param string $sAbout  channel's url (url of RSS)
	 * @param array  $aParams additional parameters for different modules:
	 *                       1 Syndication - 'sy:updatePeriod', 'sy:updateFrequency', 'sy:updateBase'
	 */
	function setChannel($sTitle, $sDescr, $sLink, $sAbout, $aParams=array()) {
        $this->_aChannel['title']  = $sTitle;
        $this->_aChannel['descr']  = $sDescr;
        $this->_aChannel['link']   = $sLink;
        $this->_aChannel['about']  = $sAbout;
	    $this->_aChannel['params'] = $aParams;
	}

	/** Set image for channel
	 * @param array $image image info:
	 *           1. title - image title
	 *           3. url   - url of image file
	 *           2. link  - url for image href
	 */
	function setImage ($image) {
		$this->_aImage = array (
			'title' => $image['title'],
			'link' => $image['link'],
			'url' => $image['url']
		);
	}

    /** Add items to feed. For imte format - see addItem().
     * @param array $aItems items info (array of info arrays)
     * @see addItem()
     */
	function addData($aItems) {
		foreach($aItems as $aItem) {
			array_push($this->_aItems, $aItem);
		}
	}

	/** Add single item to feed.
	 * @param array $aItem single item info:
	 *         1. title   - item title
	 *         2. descr   - item description
	 *         3. link    - link for item full version
	 *         4. dc:...  - [optional] Dublin Core module params (see http://dublincore.org/documents/1999/07/02/dces/)
	 * @see addData()
	 */
	function addItem ($aItem) {
		array_push($this->_aItems, $aItem);
	}

	/** Get source XML-code for RSS.
	 * @return string XML-code
	 * @see send()
	 */
	function get() {
		$doc =
    		'<?xml version="1.0"?>'."\n".
            '<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"'.
    		' xmlns="http://purl.org/rss/1.0/" '.
    		' xmlns:dc="http://purl.org/dc/elements/1.1/"'. //Dublin Core
    		' xmlns:sy="http://purl.org/rss/1.0/modules/syndication/"'. //Syndication
    		'>'."\n\n";
		$doc .= $this->_getChannel();
		$doc .= $this->_getImage();
		$doc .= $this->_getItems();
		$doc .= "</rdf:RDF>";
		return $doc;
	}

	/** Send generated XML-code to output.
	 * @see get()
	 */
	function send()
	{
	    header('Content-type: text/xml');
	    echo $this->get();
	    exit();
	}

	/** Create channel part of code
	 * @return string source for channel part of RSS.
	 */
	function _getChannel() {
		// start channel info
		$sChannel =
			'  <channel rdf:about="'.$this->_aChannel['about'].'">'."\n".
			'    <title>'.$this->_escape($this->_aChannel['title']).'</title> '."\n".
			'    <link>'.$this->_aChannel['link'].'</link> '."\n".
			'    <description>'.$this->_escape($this->_aChannel['descr']).'</description>'."\n";
		// add image rdf resource if it exists
		if (isset($this->_aImage['url']))
			$sChannel .= '    <image rdf:resource="'.$this->_aImage['url'].'" />'."\n";

		if ($this->_aItems)
		{
            $sChannel .= '    <items>'."\n".'      <rdf:Seq>'."\n";

            $aUniqueUrls = array();
            foreach($this->_aItems as $aItem)
            {
                if (!isset($aUniqueUrls[$aItem['link']]))
                    $aUniqueUrls[$aItem['link']] = $aItem['link'];
            }
            foreach($aUniqueUrls as $sUrl)
                $sChannel .= '      <rdf:li resource="'.$sUrl.'" />';
            $sChannel .= '      </rdf:Seq>'."\n".'    </items>'."\n";
		}


		//textinput
        if (isset($this->_aChannel['input']))
		  $sChannel .= '    <textinput rdf:resource="'.$this->_aChannel['input'].'" />'."\n";

        //additional parameters (syndication etc.)
		foreach ($this->_aChannel['params'] as $k=>$v)
		  $sChannel .= '    <'.$k.'>'.$v.'</'.$k.'>'."\n";


		$sChannel .= '  </channel>'."\n\n";
		return $sChannel;
	}

	/** Create image part of code
	 * @return string source for image part of RSS.
	 */
	function _getImage() {
		if (isset($this->_aImage)) {
			$image =
				'  <image rdf:about="'.$this->_aImage['url'].'\">'."\n".
				'    <title>'.$this->_escape($this->_aImage['title']).'</title>'."\n".
				'    <link>'.$this->_aImage['link'].'</link>'."\n".
				'    <url>'.$this->_aImage['url'].'</url>'."\n".
				'  </image>'."\n\n";
			return $image;
		} else {
			return "";
		}
	}

	/** Create code for items
	 * @return string source  code for items
	 */
	function _getItems() {
		$sItems = "";
		foreach ($this->_aItems as $aItem) {
			$sItems .= '  <item rdf:about="'.$aItem['link'].'">'."\n".
			           '    <title>'.$this->_escape($aItem['title']).'</title>'."\n".
                       '    <link>'.$aItem['link'].'</link>'."\n".
                       '    <description>'.$this->_escape($aItem['descr']).'</description>'."\n";
            foreach($aItem as $k=>$v) //process additionla parameters
            {
                if (! in_array($k, array('link', 'title', 'descr')))
                    $sItems .= '    <'.$k.'>'.$this->_escape($v).'</'.$k.'>';
            }
            $sItems .= '  </item>'."\n\n";
		}
		return $sItems;
	}

	/** Enclode string in <![CDATA[ ... ]]> if needed
	 * @param string $sStr source string
	 * @return string enclosed string
	 */
	function _escape($sStr)
	{
	    if ( (strpos($sStr,'>')!==false) ||
	         (strpos($sStr,'<')!==false) ||
	         (strpos($sStr,'"')!==false) )
    	    return '<![CDATA['.$sStr.']]>';
    	else
    	    return $sStr;
	}

}

?>