<?php
/** ============================================================
 * Страница регистрации новых пользователей
 *   Area: admin
 *   Sect: register
 * @author Rudenko S.
 * @package visitor
 * ============================================================ */
Conf::loadClass('Account');
Conf::loadClass('Country');
Conf::loadClass('Region');
Conf::loadClass('utils/Zoom');
Conf::loadClass('utils/Validator');
Conf::loadClass('utils/file/Image');
Conf::loadClass('utils/mail/Mailer');
Conf::loadClass('ShopSlot');
Conf::loadClass('Purchase');
Conf::loadClass('Image');

$oShopSlot = new ShopSlot();
$oPurchase = new Purchase();
$oUserReg  	= new Account();
$oCountry  	= new Country();
$oRegion  	= new Region();
$oZoom  	= new Zoom();
$oImage  	= new Image();
$bSuccess 	= $oReq->get('success');
$aUserReg 	= $aAccount;//$oReq->getArray('aUser');
$aErrors 	= array();


switch ($oReq->getAction())
{
    case 'pass':
        $aFields = array(
            'pass'  	=> array('title'=>Conf::format('Password'),   'pattern'=>'/^.{6,20}$/'),
            'pass_confirm'  => array('title'=>Conf::format('The password again'),   'pattern'=>'/^.{6,20}$/'),
        );
        $oValidator = new Validator($aFields, array(array('pass', 'pass_confirm', '==')));
        if ($oValidator->isValid($oReq->getAll())){
            $oUserReg->aData = array('account_id'=>$oAccount->isLoggedIn());
            $oUserReg->aData['pass'] = md5($oUserReg->aData['pass']);
            if ($oUserReg->update()) {
                $oReq->forward('/'.($aLanguage['alias']).'/account/profile/', Conf::format('Data saved successfully'));
            }else
                $aErrors = $oUserReg->getErrors();
        } else
            $aErrors = $oValidator->getErrors();
        break;
    case 'register':
    	$aUserReg 	= $oReq->getArray('aUser');
        $aUserReg['birthday'] = strtotime($oReq->get('byear').'-'.$oReq->get('bmonth').'-'.$oReq->get('bday'))?date('Y-m-d', strtotime($oReq->get('byear').'-'.$oReq->get('bmonth').'-'.$oReq->get('bday'))):'0000-00-00';

        $aFields = array(
            'aUser[fname]' 	=> array('title'=>Conf::format('Name'),  'def'=>'required'),
            'aUser[email]' 		=> array('title'=>Conf::format('Email'),    'pattern'=>'/^[A-Za-z_0-9\.\-]+@[A-Za-z0-9\.\-]+\.[A-Za-z]{2,}$/'),
        );
        if ($aAccount['status']=='seller')
            unset($aFields['aUser[email]']);
        $oValidator = new Validator($aFields);

        if ($oValidator->isValid($oReq->getAll())){
	    	$oUserReg->aData = $aUserReg;       
	    	$oUserReg->aData['account_id'] = $oAccount->isLoggedIn();       
	    	if (isset($oUserReg->aData['pass'])) {
                if ($oUserReg->aData['pass'])
                    $oUserReg->aData['pass'] = md5($oUserReg->aData['pass']);
                else
                    unset($oUserReg->aData['pass']);
            }
	    	
	        if ($oUserReg->isUniqueEmail($oAccount->isLoggedIn()))
	        {
                $oZoomUser = true;

                // запретить править почту для продавцов иначе слетят бронирования
               if ($aAccount['status']!='seller' && isset($aUserReg['email']))
                    unset($aUserReg['email']);

                // для продавцов возможна смена имени
                if ($aAccount['status']=='seller' && $aUserReg['fname']!=$aAccount['fname'])
                    $oZoomUser = $oZoom->updateUser(array('id'=>$aAccount['zoom_id'], 'type'=>1, 'first_name'=>$aUserReg['fname']));

                if (isset($oUserReg->aData['country_id']) && !$oUserReg->aData['country_id'])
                    unset($oUserReg->aData['country_id']);

                if ($oZoomUser) {

                    // загрузка картинки
                    $sType = $oReq->get('type', 'account');
                    if (isset($_FILES['photo']) && isset($_FILES['photo']['tmp_name'])) {
                        $sExt = strtolower(substr($_FILES['photo']['name'], strrpos($_FILES['photo']['name'], '.')+1));
                        if ($iImageId = $oImage->upload($_FILES['photo']['tmp_name'], $sType, 0, $sExt) ) {
                            $oUserReg->aData['image_id'] = $iImageId;
                        }
                        else
                            $aErrors = $oImage->getErrors();
                    } else {
                        $aErrors[] = 'File not upload';
                    }

                    if ($oUserReg->update()) {
                        $oReq->forward('/'.($aLanguage['alias']).'/account/profile/', Conf::format('Data saved successfully'));
                    }else
                        $aErrors = $oUserReg->getErrors();
                } else {
                    $aErrors = $oZoom->getErrors();
                }
	        }
	        else
	            $aErrors[] = Conf::format('This email address is already registered');
        } else
            $aErrors = $oValidator->getErrors();
        break;
}

$aMonths = array(
    1 => Conf::format('January'),
    Conf::format('February'),
    Conf::format('March'),
    Conf::format('April'),
    Conf::format('May'),
    Conf::format('June'),
    Conf::format('July'),
    Conf::format('August'),
    Conf::format('September'),
    Conf::format('October'),
    Conf::format('November'),
    Conf::format('December')
);
/*
Январь - January
Февраль - February
Март - March
Апрель - April
Май - May
Июнь - June
Июль - July
Август - August
Сентябрь - September
Октябрь - October
Ноябрь - November
Декабрь - December*/

if (isset($aUserReg['birthday']) && $aUserReg['birthday'] !='0000-00-00') {
    $aUserReg['bday'] = intval(date('d', strtotime($aUserReg['birthday'])));
    $aUserReg['bmonth'] = intval(date('m', strtotime($aUserReg['birthday'])));
    $aUserReg['byear'] = intval(date('Y', strtotime($aUserReg['birthday'])));
}

// Title
$sTitle = Conf::format('Settings');
$oTpl->assignSrc(array(
    'aUserReg' 			=> $aUserReg,
    'aErrors'		=> $aErrors,
    'bSuccess'		=> $bSuccess,
    'aAccount'		=> $aAccount,
    'aTimezones'		=> Conf::get('timezones'),
    'aDays' => range(1, 31),
    'aMonths' => $aMonths,
    'aYears' => range(date('Y'), date('Y')-100),
    'aCountries' => $oCountry->getHash('title',array(),'',$aLanguage['language_id']),
    'aRegions' => $oRegion->getHash('title',array(),'',$aLanguage['language_id']),
    'iSlotsNewCnt' => $oShopSlot->getCount(array('account_id'=>'='.$aAccount['account_id'], 'status'=>'="booked"', 'time_from'=>'>"'.Database::date(Conf::getTime()).'"')),
    'iPurchasesNewCnt' => $oPurchase->getCount(array('account_id'=>'='.$aAccount['account_id'], 'udate'=>'>"'.Database::date(time()-86400*3).'"')),

));

?>
