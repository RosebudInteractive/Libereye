<?
/** ============================================================
 * PDF Module.
 * Creates PDF from HTML.
 * @package core
 * ============================================================ */

/** PDF pics default path */
define('PDF_PICS_PATH','http://'.$_SERVER['SERVER_NAME'].'/pdf/pics/');

class PDF {

  /** 'htmldoc' command-line program name
   * @var string
   * @access private
   */
  var $htmldoc = 'htmldoc';

  /** Path to picture folders.
   * @var string
   * @access private
   */
  var $pic_path='';

  /** Output file PDF Version (now v1.4 = 'pdf14')
   * @var string
   * @access private
   */
  var $pdf_version = 'pdf14';

  /** Sended filename.
   * @var string
   * @access private
   */
  var $pdf_filename = 'page.pdf';


  /**
   * PDF convertor object constructor.
   * @param $pic_path - path to PDF pictures (checkboxes, radiobuttons).
   *        If none given then use default.
   * @return PDF convertor object
   * @access public
   */
  function PDF($pic_path = PDF_PICS_PATH){
    $this->pic_path = $pic_path;
    $this->htmldoc = Conf::get('pdf.htmldoc_path');
  }

  /** Makes a PDF-document from HTML and output it direct to user.
   * @param string $html source code of HTML document
   * @return void
   * @access public
   */
  function convert($html)
  {
    if (!$html) return;
    if (get_magic_quotes_gpc())
    {
      $html = stripslashes($html);
    }
    $html = str_replace("\n", '' , $html);

    //replace <span class=formitem...eltype="datebox"...>...</span>
    $html = preg_replace_callback("'<span class=formitem ([^>]+)eltype=\"datebox\"([^>]+)>(.*?)</span>'si", array($this, 'replace_datebox'), $html);

    //replace <textarea>...</textarea> with inner text
    $html = preg_replace_callback("/<textarea([^>]*)>([^<]*)<\/textarea>/is",
                                  array($this, 'replaceTextArea'),
                                  $html);

    //replace <input[...]type=["]text["][...]> with VALUE text
    $html = preg_replace_callback("/<input([^>]*)type=\"?text\"?([^>]*)>/is",
                                  array($this, 'replaceInputText'),
                                  $html);

    //replace <input[...]type=["]checkbox["][...]> with icons
    $html = preg_replace_callback("/<input([^>]*)type=\"?checkbox\"?([^>]*)>/is",
                                  array($this, 'replaceCheckBox'),
                                  $html);

    //replace <input[...]type=["]radio["][...]> with image
    $html = preg_replace_callback("/<input([^>]*)type=\"?radio\"?([^>]*)>/is",
                                  array($this, 'replaceRadioItem'),
                                  $html);


   //replace <select>...</select>
    $html = preg_replace_callback("/<select[^>]*>(.*)<\/select>/is",
                                  array($this, 'replaceSelect'),
                                  $html);


    $search = array (
      "'<([\w]+) class=([^ |>]*)([^>]*)'si",    //remove class="..."
      "'<([\w]+) style=\"([^\"]*)\"([^>]*)'si", //remove style="..."
      "'<\?xml[^>]*>'si",                       //remove <?xml...>
      "'<\/?\w+:[^>]*>'si",                     //remove <?...:...>
      "'<p([^>])*>(&nbsp;)*\s*<\/p>'si",        //remove <p...>[&nbsp;...]</p>
      "'<span([^>]+)>(.*?)<\/span>'si",         //remove <span...>...</span>
      "'<v:imagedata([^>])*><\/v:imagedata>'si" //remove <v:imagedata></v:imagedata>
    );

    $replace = array (
      "<$1$3",
      "<$1$3",
      "",
      "",
      "",
      "$2",
      ""
    );

    $html = preg_replace ($search, $replace, $html);
    $html = str_replace('\"', '\&quot;', $html);     // \"    -> \&quot;
    $html = str_replace('<?', '&lt;?', $html);       // <?   -> &lt;?
    $html = str_replace('"<img', '"&lt;img', $html); // <img -> &lt;img
    $html = str_replace('$', '\$', $html);           // $    -> \$
    $html = str_replace('"', '\"', $html);           // "    -> \"

    header('Content-Type: application/pdf');
    header('Content-Disposition: inline; filename="'.$this->pdf_filename.'"');
    flush();
    passthru('echo "'.$html.'"|'.$this->htmldoc.' --no-compression -t '.$this->pdf_version.' --quiet --jpeg --webpage -');
    //print 'echo "'.$html.'"|'.$this->htmldoc.' --no-compression -t '.$this->pdf_version.' --quiet --jpeg --webpage -';
    //exit;
  }


  /** Callback function for replacing input fileds.
   * @param array $matches matches from preg_replace_callback()
   * @return string
   * @access private
   */
  function replaceInputText($matches) {
    //$matches
    //1 - <input(...)type=["]text["]...>
    //2 - <input...type=["]text["](...)>

    //get size
    $size = 0;
    if (preg_match('/size=\"?(\d*)\"?/is',$matches[0],$submatch)) { //get size
      $size = intval($submatch[1]);
    }

    //get VALUE text
    $txt = '';
    if (preg_match('/value=\"?([^\"]*)\"?/is',$matches[0],$submatch)) { //have value
      $txt = $submatch[1];
    }

    //format text
    if ($size>0) {
      if ($txt) { return wordwrap($txt, $size, '<br>'); } //wrap text
          else  { return str_pad('', $size, '_'); } //create "___" text
    }
    else { return $txt; }  //return text as is
  }

  /** Callback function for replacing text areas.
   * @param array $matches matches from preg_replace_callback()
   * @return string
   * @access private
   */
  function replaceTextArea($matches) {
    //$matches:
    // 1 - <textarea(...)>...</textarea>
    // 2 - <textarea...>(...)</textarea>
    $rows = 0;
    if (preg_match("/rows=\"?(\d+)\"?/is",$matches[1],$submatches)) {
      $rows = intval($submatches[1]);
    }
    $cols = 0;
    if (preg_match("/cols=\"?(\d+)\"?/is",$matches[1],$submatches)) {
      $cols = intval($submatches[1]);
    }
    if (strlen($matches[2])>0) { //have text inside
      if ($rows && $cols) { //break inside text with <br>
        return wordwrap(substr($matches[2], 0, $cols * $rows), $cols, '<br>');
      }
      else { //return text as is
        return $matches[2];
      }
    }
    else { //no text between tags
       return str_pad('', (int)$matches[3], '_');
    }
  }

  /**
   * Callback function for checboxes replace.
   * @param array $matches matches from preg_replace_callback()
   * @return string
   * @access private
   */
  function replaceCheckBox($matches) {
    //$matches:
    //1 - <input(...)type=["]checkbox["]...>
    //2 - <input...type=["]checkbox["](...)>
    if (preg_match('/\Wchecked\W/is',$matches[0])) {
      return '<img src="'.$this->pic_path.'checkbox_checked.gif" width="13" height="13">';
    }
    else {
      return '<img src="'.$this->pic_path.'checkbox.gif" width="13" height="13">';
    }
  }

  /** Callback function for replacing radio input fileds.
   * @param array $matches matches from preg_replace_callback()
   * @return string
   * @access private
   */
  function replaceRadioItem($matches) {
    //$matches:
    //1 - <input(...)type=["]radio["]...>
    //2 - <input...type=["]radio["](...)>
    if (preg_match('/\Wchecked\W/is',$matches[0])) {
      return '<img src="'.$this->pic_path.'radio_checked.gif" width="13" height="13">';
    }
    else {
      return '<img src="'.$this->pic_path.'radio.gif" width="12" height="12">';
    }
  }

  /** Callback function for replacing select fileds.
   * @param array $matches matches from preg_replace_callback()
   * @return string
   * @access private
   */
  function replaceSelect($matches) {
    return preg_replace_callback('/<option([^>]*)>([^<]*)<\/option>/si',
                                 array($this, 'replaceSelectItem'),
                                 $matches[1]);
  }

  /** Callback function for replacing select items.
   * @param array $matches matches from preg_replace_callback()
   * @return unknown
   * @access private
   */
  function replaceSelectItem($matches) {
    //<option(...)>(...)</option>
    if (preg_match('/\Wselected\W/',$matches[1])) { return $matches[2].'<br>'; }
                                             else { return ''; }
  }

  /** Callback function for replace date boxes.
   * @param array $matches matches from preg_replace_callback()
   * @return string
   * @access private
   */
  function replace_datebox($matches)
  {
    $mon_array = array(
      'JAN' => 1, 'FEB' => 2, 'MAR' => 3, 'APR' => 4,
      'MAY' => 5, 'JUN' => 6, 'JUL' => 7, 'AUG' => 8,
      'SEP' => 9, 'OCT' => 10, 'NOV' => 11 , 'DEC' => 12
    );

    preg_match("'<input ([^>]+) value=([\d]+) name=([^>]+)_day>'si",
               $matches[3], $day);
    preg_match("'<input ([^>]+) value=([\d]+) name=([^>]+)_year>'si",
               $matches[3], $year);
    preg_match("'<option value=([^>]+) selected>'si",
               $matches[3], $mon);

    $month = (isset($mon_array[$mon[1]])) ? $mon_array[$mon[1]] : @$mon[1];

    if (isset($day[2]) and isset($year[2]))
      return ((int)$month && (int)$day[2] && (int)$year[2]) ? sprintf('%02u/%02u/%04u',$day[2],$month,$year[2]) : '__________';
    else
      return '__________';
  }
}
?>