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
Conf::loadClass('News');
Conf::loadClass('Language');
Conf::loadClass('Image');

$oNews = new News();
$oLanguage = new Language();
$aLanguages = $oLanguage->getHash('title', array(), 'language_id');
$oImage= new Image();
$iNewsId = $oReq->getInt('id');
$aFields = array();
foreach($aLanguages as $nLangId=>$sLanguage) {
    $aFields['aNews[title]['.$nLangId.']'] = array('title'=>'Заголовок ('.$sLanguage.')', 'def'=>'required',);
    $aFields['aNews[annotation]['.$nLangId.']'] = array('title'=>'Аннотация ('.$sLanguage.')', 'def'=>'required',);
    $aFields['aNews[full_news]['.$nLangId.']'] = array('title'=>'Полный текст новости ('.$sLanguage.')', 'def'=>'required',);
}

//create validator
$oValidator = new Validator($aFields);

// ========== processing actions ==========
switch($oReq->getAction())
{
    // === update ====
    case 'Сохранить':
        $oNews->aData = $oReq->getArray('aNews');
        $oNews->aData['news_id'] = $iNewsId;
        $oNews->aData['udate'] = Database::date();
        $oNews->aData['account_id'] = $oAdmin->isLoggedIn();
        if ($oValidator->isValid($oReq->getAll())){

            // Delete image
            if ($oReq->get('image_delete'))
            {
                $oNews->aData['image']  = '';
            }

            // Upload image
            if ($_FILES['image']['tmp_name'])
            {
                $sExt = strtolower(substr($_FILES['image']['name'], strrpos($_FILES['image']['name'], '.')+1));
                if ($iImageId = $oImage->upload($_FILES['image']['tmp_name'], 'news', $iNewsId, $sExt) ) {
                }
                else
                    $aErrors = $oImage->getErrors();
            }

            if ($oNews->update(array(), true, array('title', 'annotation', 'full_news')))
                $oReq->forward(conf::getUrl('admin.news.list'), conf::getMessages('news.updated'));
            else
                $aErrors = $oNews->getErrors();
        }
        else
            $aErrors = $oValidator->getErrors();
        break;
    case 'Создать':
        $oNews->aData = $oReq->getArray('aNews');
        $oNews->aData['cdate'] = $oNews->aData['udate'] = Database::date();
        $oNews->aData['account_id'] = $oAdmin->isLoggedIn();
        if ($oValidator->isValid($oReq->getAll())) {

            // Upload image
            if ($_FILES['image']['tmp_name'])
            {
                $sExt = strtolower(substr($_FILES['image']['name'], strrpos($_FILES['image']['name'], '.')+1));
                if ($iImageId = $oImage->upload($_FILES['image']['tmp_name'], 'news', $iNewsId, $sExt) ) {
                }
                else
                    $aErrors = $oImage->getErrors();
            }

            if ($oNews->insert(true, array('title', 'annotation', 'full_news')))
                $oReq->forward(conf::getUrl('admin.news.list'), conf::getMessages('news.created'));
            else
                $aErrors = $oNews->getErrors();
        }
        else
            $aErrors = $oValidator->getErrors();
        break;
    case 'Удалить':
        if($oNews->delete($iNewsId))
            $oReq->forward(conf::getUrl('admin.news.list'), conf::getMessages('news.deleted'));
        else
            $aErrors = $oNews->getErrors();
    case 'Отмена':
        $oReq->forward(conf::getUrl('admin.news.list'));
        break;
}

if (!$aErrors)
    $oNews->load($iNewsId);

$oTpl->assign(array(
    'aNews' => $oNews->aData,
    'aLanguages' => $aLanguages,
    // 'sJs'   => $oValidator->makeJS(),
    'bLoadEditor' => true,
));
?>