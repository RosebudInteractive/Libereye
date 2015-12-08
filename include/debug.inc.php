<?php
/** ============================================================
 * File contains debugging functions
 * @author Rudenko S.
 * @package core
 * ============================================================ */

error_reporting(Conf::get('debug')? Conf::get('debug_level'): 0);

/** Formats output. Using for debuging
*/
function d($mParam, $bExit=0)
{
    echo '<hr><pre>';
    print_r($mParam);
    echo '</pre><hr>';
    if ($bExit) exit;
}

/** Sets custom error handler
*/
function errorHandler($nErrNo, $sErrMsg, $sFulename, $nLinenum, $aVars)
{
    $bHide = false;
    $aTypes = array (
        1   =>  "Error",
        2   =>  "Warning",
        4   =>  "Parsing Error",
        8   =>  "Notice",
        16  =>  "Core Error",
        32  =>  "Core Warning",
        64  =>  "Compile Error",
        128 =>  "Compile Warning",
        256 =>  "User Error",
        512 =>  "User Warning",
        1024=>  "User Notice",
        2048=>  "Strict",
        4096=>  "Strict",
        8192=>  "Strict",
    );

    if ($nErrNo < 2048)
    {
        $sErr = '<br><b>'.$aTypes[$nErrNo].'</b>:&nbsp;<span style="color:red">'.$sErrMsg.'.</span><br>';
        $aFiles = debug_backtrace();
        for ($i=0, $n=sizeof($aFiles); $i<$n; ++$i)
        {
            if (strpos($aFiles[$i]['file'], 'Smarty') and 8 == $nErrNo)
                $bHide=true;
    
            $sErr .= $i.'&nbsp;&nbsp;&nbsp;IN FILE&nbsp;&nbsp;&nbsp;"'.$aFiles[$i]['file'].'"&nbsp;&nbsp;&nbsp;ON LINE&nbsp;&nbsp;&nbsp;<b>'.$aFiles[$i]['line'].'</b>  <br>';
        }
        if (!$bHide)
        {
            if (Conf::get('debug'))
                echo $sErr.'<br>';
            else if ($nErrNo <= 1024)
            {
            	$sErr = "\r\n".date('H:i:s d-m-y').' '.str_replace(array('&nbsp;', '<br>','<b>','</b>'),array(' ', "\r\n",'_','_'), $sErr);
				$hFp = fopen(Conf::get('debug_errors_dir').'error_log-'.date('Y-m-d').'.txt', 'a');      	
				if ($hFp)
				{
					fwrite($hFp, $sErr, strlen($sErr));
   					fclose($hFp);
				}
            }
                
//            else
//                mail(Conf::get('debug_mail'), 'script_error('.$_SERVER['SERVER_NAME'].')', str_replace(array('&nbsp;', '<br>','<b>','</b>'),array(' ', "\r\n",'_','_'), $sErr));
        }
    }
}

set_error_handler('errorHandler');


/** Shows sql history for current db connection
*/
function showSql()
{

    $oDb = & Database::get();
    $fSum = 0.0;
    $fLimit = 0.1*128;
    $sOut =  '<table width="80%" border="1" cellspacing="0" cellpadding="2" style="color:black; margin:10px; font-family: Tahoma,Sans-Serif">';
    foreach($oDb->aHistory as $aLine){
        $sColor = sprintf('%02X', min(255, $fLimit/$aLine['time']));
        $sOut .= '<tr><td width="1%" style="background-color: #FF'.$sColor.$sColor.'">'.sprintf('%.8f',$aLine['time']).'</td><td width=99%>'.wordwrap($aLine['sql'],100,'<br>').'</td></tr>';
        $fSum += $aLine['time'];
    }
    $sOut .= '<tr><td colspan="2">Total: <b>'.sprintf('%.8f',$fSum).'</b></td></tr></table>';
    echo $sOut;
}

?>