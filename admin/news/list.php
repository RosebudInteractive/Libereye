<?php
/** ============================================================
 * Part section.
 *   Area:    News
 *   Part:    stats
 *   Section: sales
 * @author Rudenko S.
 * @package News
 * ============================================================ */
Conf::loadClass('utils/Validator');
Conf::loadClass('utils/Sorter');
Conf::loadClass('utils/Pager');
Conf::loadClass('News');
Conf::loadClass('Image');

$oImage = new Image();
$oNews = new News();


// ========== processing actions ==========
switch($oReq->getAction())
{
    case 'load':
        $iNewsId = $oReq->getInt('id');
        if ($iNewsId && $oNews->load($iNewsId)) {
            echo json_encode($oNews->aData);
            exit;
        }
        echo '{"error":"Новость не найдена"}';
        exit;
        break;

    case 'get':
        // search
        $aCond = array();
        if (isset($_GET['filter']))
        {
            if (isset($_GET['filter']['value']) && $_GET['filter']['value'])
                $aCond['{#title}'] = 'pd1.phrase LIKE "%'.Database::escapeLike($_GET['filter']['value']).'%"';
            if (isset($_GET['filter']['title']) && $_GET['filter']['title'])
                $aCond['{#title}'] = 'pd1.phrase LIKE "%'.Database::escapeLike($_GET['filter']['title']).'%"';
            if (isset($_GET['filter']['annotation']) && $_GET['filter']['annotation'])
                $aCond['{#annotation}'] = 'pd2.phrase LIKE "%'.Database::escapeLike($_GET['filter']['annotation']).'%"';
            if (isset($_GET['filter']['full_news']) && $_GET['filter']['full_news'])
                $aCond['{#full_news}'] = 'pd3.phrase LIKE "%'.Database::escapeLike($_GET['filter']['full_news']).'%"';
            if (isset($_GET['filter']['cdate']) && $_GET['filter']['cdate'] && $_GET['filter']['cdate']!='null')
                $aCond['cdate'] = '="'.Database::date(strtotime($_GET['filter']['cdate'])).'"';
        }

        $iPos = $oReq->getInt('start');
        $iPageSize = $oReq->getInt('count', 50);
        $aSort = $oReq->getArray('sort' , array('news_id'=>'desc'));
        list($aItems, $iCnt) = $oNews->getListOffset($aCond, $iPos, $iPageSize, str_replace('=', ' ', http_build_query($aSort, ' ', ', ')));

        if (!$oReq->get('suggest')) {
            echo '{"pos":' . $iPos . ', "total_count":"' . $iCnt . '","data":' . json_encode($aItems) . '}';
        } else {
            $aNewssSuggest = array();
            foreach($aItems as $aItem){
                $aNewssSuggest[] = array("id"=>$aItem['news_id'],"value"=>$aItem['title']);
            }
            echo json_encode($aNewssSuggest);
        }

        exit;
        break;

    case 'del':
   		if ($oNews->delete($oReq->getInt('id'))){
   			$oReq->forward(conf::getUrl('admin.accounts.list'), 'Новость была успешно удалена');
   		}
   		break;

    case 'upload':
        $iImageId = 0;
        $sImageName = '';
        $sType = $oReq->get('type', 'news');
        if (isset($_FILES['upload']) && isset($_FILES['upload']['tmp_name'])) {
            $sExt = strtolower(substr($_FILES['upload']['name'], strrpos($_FILES['upload']['name'], '.')+1));
            if ($iImageId = $oImage->upload($_FILES['upload']['tmp_name'], $sType, 0, $sExt) ) {
                $sImageName = $oImage->aData['name'];
            }
            else
                $aErrors = $oImage->getErrors();
        } else {
            $aErrors[] = 'File not upload';
        }
        echo '{ "status":"'.($aErrors?'error':'server').'", "id":"'.$iImageId.'", "sname":"'.$sImageName.'"}';
        exit;
        break;

    case 'update':
    case 'create':
        $iNewsId = $oReq->getInt('id');
        $aNewsPost = $oReq->getArray('aNews');
        $aImages = $oReq->get('images') ? explode(',', $oReq->get('images')) : array();
        $oNews->aData = $aNewsPost;
        if ($aNewsPost) {
            if ($iNewsId) {
                $oNews->aData['news_id'] = $iNewsId;
                $oNews->aData['udate'] = Database::date();
                if (!$oNews->update(array(), true, array('title', 'annotation', 'full_news'))) {
                    $aErrors = $oNews->getErrors();
                }
            } else {
                $oNews->aData['account_id'] = $oAdmin->isLoggedIn();
                $oNews->aData['cdate'] = $oNews->aData['udate'] = Database::date();
                if (!($iNewsId = $oNews->insert(true, array('title', 'annotation', 'full_news')))) {
                    $aErrors = $oNews->getErrors();
                }
            }
        }



        echo '{ "id":"'.$iNewsId.'", "error":'.json_encode($aErrors).'}';
        exit;
        break;


    case 'destroy':
        $iNewsId = $oReq->getInt('id');
        if (!$oNews->delete($iNewsId)){
            $aErrors = $oNews->getErrors();
        }
        echo '{ "id":"'.$iNewsId.'", "error":'.json_encode($aErrors).'}';exit;
        break;
}


?>