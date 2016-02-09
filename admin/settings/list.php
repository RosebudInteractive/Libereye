<?php
/** ============================================================
 * Part section.
 *   Area:    Setting
 *   Part:    stats
 *   Section: sales
 * @author Rudenko S.
 * @package Setting
 * ============================================================ */
Conf::loadClass('utils/Validator');
Conf::loadClass('utils/Sorter');
Conf::loadClass('utils/Pager');
Conf::loadClass('Setting');

$oSetting = new Setting();


// ========== processing actions ==========
switch($oReq->getAction())
{
   case 'load':
		$iSettingId = $oReq->getInt('id');
        if ($iSettingId && $oSetting->load($iSettingId)) {
            echo json_encode($oSetting->aData);
            exit;
        }
		echo '{"error":"Настройка не найдена"}';
		exit;
		break;

    case 'get':
		// search
		$aCond = array();
		if (isset($_GET['filter']))
		{
            if (isset($_GET['filter']['name']) && $_GET['filter']['name'])
                $aCond['name'] = 'LIKE "%'.Database::escapeLike($_GET['filter']['name']).'%"';
            if (isset($_GET['filter']['code']) && $_GET['filter']['code'])
                $aCond['code'] = 'LIKE "%'.Database::escapeLike($_GET['filter']['code']).'%"';
            if (isset($_GET['filter']['val']) && $_GET['filter']['val'])
                $aCond['val'] = 'LIKE "%'.Database::escapeLike($_GET['filter']['val']).'%"';
        }

		$iPos = $oReq->getInt('start');
		$iPageSize = $oReq->getInt('count', 50);
		$aSort = $oReq->getArray('sort' , array('id'=>'desc'));
		list($aItems, $iCnt) = $oSetting->getListOffset($aCond, $iPos, $iPageSize, str_replace('=', ' ', http_build_query($aSort, ' ', ', ')));

        if (!$oReq->get('suggest'))
            echo '{"pos":'.$iPos.', "total_count":"'.$iCnt.'","data":'.json_encode($aItems).'}';
        else {
            $aSettingsSuggest = array();
            foreach($aItems as $aItem){
                $aSettingsSuggest[] = array("id"=>$aItem['id'],"value"=>$aItem['title']);
            }
            echo json_encode($aSettingsSuggest);
        }

		exit;
		break;

    case 'update':
    case 'create':
        $iSettingId = $oReq->getInt('id');
        $aSetting = $oReq->getArray('aSetting');
        $oSetting->aData = $aSetting;
        if ($iSettingId) {
            $oSetting->aData['id'] = $iSettingId;
            if (!$oSetting->update()){
                $aErrors = $oSetting->getErrors();
            }
        } else {
            if (!($iSettingId = $oSetting->insert())){
                $aErrors = $oSetting->getErrors();
            }
        }
        echo '{ "id":"'.$iSettingId.'", "error":'.json_encode($aErrors).'}';
        exit;
        break;
   case 'destroy':
        $iSettingId = $oReq->getInt('id');
   		if (!$oSetting->delete($iSettingId)){
            $aErrors = $oSetting->getErrors();
   		}
        echo '{ "id":"'.$iSettingId.'", "error":'.json_encode($aErrors).'}';exit;
   		break;
}


?>