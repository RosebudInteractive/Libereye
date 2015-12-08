<?php
/** ============================================================
 * Part section.
 *   Area:    admin
 *   Part:    stats
 *   Section: sales
 * @author Rudenko S.
 * @package admin
 * ============================================================ */
Conf::loadClass('Content');

$oContent = new Content();

// ========== processing actions ==========
switch($oReq->getAction())
{
    case 'del':
        if($oContent->delete($oReq->getInt('id'))){            
            $oReq->forward($oUrl->getUrl(), conf::getMessages('content.deleted'));
        }
        else 
            $aErrors = $oContent->getErrors();
        break;
    case 'hide':
    case 'show':
    	$oContent->aData = array(
    		'content_id' => $oReq->getInt('id'),
    		'is_hide' => $oReq->getAction()=='hide'?1:0,
    	);
        if($oContent->update()){            
            $oReq->forward($oUrl->getUrl(), conf::getMessages('content.deleted'));
        }
        else 
            $aErrors = $oContent->getErrors();
        break;
}

list($aContents, $iCnt) = $oContent->getList(array(),0,0,'priority, language_id desc');
$aContentsTree = $oContent->getTree($aContents);

$oTpl->assign(array(
    'aContentsTree'  => $aContentsTree,
));
?>