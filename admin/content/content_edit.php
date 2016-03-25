<?php
/** ============================================================
 * Part section.
 *   Area:    admin
 *   Part:    news
 *   Section: news_edit
 * @author Rudenko S.
 * @package admin
 * ============================================================ */
Conf::loadClass('utils/Validator');
Conf::loadClass('Content');
Conf::loadClass('Language');

$oContent = new Content();
$oLanguage = new Language();
$iContentId = $oReq->getInt('id');
$iParentId = $oReq->getInt('parent'); 
$aContent = array(
	'is_text_block' => 1,
	//'is_can_delete' => 1,
	//'is_can_parent' => 1,
	'is_can_uri' => 1,
	//'is_can_index' => 1,
	//'is_can_hide' => 1,
);
$aParent = array();

if ($iContentId)
{
    if (!$oContent->load($iContentId))
    	$oReq->forward(conf::getUrl('admin.content.list'));
    $aContent = $oContent->aData;
}
if ($iParentId)
{
    if (!$oContent->load($iParentId))
    	$oReq->forward(conf::getUrl('admin.content.list'));
    $aParent = $oContent->aData;
}

$aFields = array(
    'aContent[title]'       => array('title'=>'Заголовок', 'def'=>'required',),
);     


//create validator
$oValidator = new Validator($aFields); 
    
// ========== processing actions ==========
switch($oReq->getAction())
{
    // === update ====
    case 'save':
    	$aContent = $oReq->getArray('aContent');
        $oContent->aData = $aContent;        
        $oContent->aData['content_id'] = $iContentId;
        $oContent->aData['cdate'] = Database::date($aContent['cdate']?strtotime($aContent['cdate']):0);
        $oContent->aData['udate'] = Database::date();
                
        if ($oValidator->isValid($oReq->getAll())){            
        	
        	if ($oReq->get('uri_autocomplete') && !$oContent->aData['uri'])
        	{
        		$oContent->aData['uri'] = $oUrl->translit($oContent->aData['title']).'.html';
        	}
        	
            if ($oContent->update())
                $oReq->forward(conf::getUrl('admin.content.list'), conf::getMessages('content.updated'));
            else 
                $aErrors = $oContent->getErrors();
        }
        else
            $aErrors = $oValidator->getErrors();
        break; 
    case 'add':
        $aContent = $oReq->getArray('aContent');
        $oContent->aData = $aContent;
        if ($iParentId)
            $oContent->aData['parent_id'] = $iParentId;
        $oContent->aData['is_can_delete'] = 1;
        $oContent->aData['is_can_parent'] = 1;
        $oContent->aData['is_can_hide'] = 1;
        $oContent->aData['is_can_index'] = 1;
        $oContent->aData['cdate'] = Database::date($aContent['cdate']?strtotime($aContent['cdate']):0);

        if ($oValidator->isValid($oReq->getAll())) {
        	
	      	if ($oReq->get('uri_autocomplete') && !$oContent->aData['uri'])
        	{
        		$oContent->aData['uri'] = $oUrl->translit($oContent->aData['title']).'.html';
        	}
  
        	
            if ($iContentId = $oContent->insert())
            {
                if ($oReq->get('add_another'))
	        	{
	        		$oReq->forward(conf::getUrl('admin.content.content_edit').($iParentId?'/parent_'.$iParentId:''), conf::getMessages('content.created'));
	        	}
	        	else 
	        		$oReq->forward(conf::getUrl('admin.content.list'), conf::getMessages('content.created'));
            }
            else 
                $aErrors = $oContent->getErrors();
        }
        else
            $aErrors = $oValidator->getErrors();
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
        
    case 'del':
        if($oContent->delete($oReq->getInt('id'))){            
            $oReq->forward($oUrl->getUrl(), conf::getMessages('content.deleted'));
        }
        else 
            $aErrors = $oContent->getErrors();
        break;
        
        
}

list($aContents, $iCnt) = $oContent->getList();
$aContentsTree = $oContent->getTree($aContents);

$oTpl->assign(array(
    'bLoadEditor' => true,
    'aContentsTree'  => $aContentsTree,
    'aLanguages'  => $oLanguage->getHash('title', array(), 'language_id'),
   // 'sStyleFile'  => $iContentId==1?'style.css':'inner.css',
));
$oTpl->assignSrc(array(
    'aContent' => $aContent,
    'aParent' => $aParent,
));

?>