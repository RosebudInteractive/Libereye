<?php
/** ============================================================
 * Страница регистрации новых пользователей
 *   Area: admin
 *   Sect: register
 * @author Rudenko S.
 * @package visitor
 * ============================================================ */
Conf::loadClass('Subscribe');
Conf::loadClass('utils/Validator');
Conf::loadClass('utils/mail/Mailer');
Conf::loadClass('Content');

$oSubscribe  	= new Subscribe();
$aSubscribe 	= $oReq->getArray('aUser');

$aFields = array(
    'aUser[fname]' 	=> array('title'=>'Имя',  'pattern'=>'/^.{1,100}$/'),
    'aUser[email]' 		=> array('title'=>'Электронная почта',    'pattern'=>'/^[A-Za-z_0-9\.\-]+@[A-Za-z0-9\.\-]+\.[A-Za-z]{2,}$/'),
);

$oValidator = new Validator($aFields, array(array('aUser[pass]', 'pass_confirm', '==')));
$aErrors 	= array();

switch ($oReq->getAction())
{
    case 'subscribe':
        if ($oValidator->isValid($oReq->getAll())){
            $oSubscribe->aData = $aSubscribe;
            $oSubscribe->aData['cdate'] = Database::date();

            if ($oSubscribe->isUniqueEmail())
            {
                if (($oSubscribe->insert()))
                    $oReq->forward('/', Conf::format('You have successfully subscribed'));
                else
                    $aErrors = $oSubscribe->getErrors();
            }
            else
                $aErrors[] = Conf::format('This email address is already subscribed');
        } else
            $aErrors = $oValidator->getErrors();
        break;
}


// Title
$oTpl->assign(array(
    'aSubscribe' 	=> $aSubscribe,
    'aErrors'		=> $aErrors,
));



?>
