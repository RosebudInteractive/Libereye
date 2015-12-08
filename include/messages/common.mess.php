<?php
/** ============================================================
 * Application-level messages.
 *  Language: english
 *  Encoding: ISO-8859-1
 * @author Rudenko S.
 * @package messages
 * ============================================================ */

global $_MSG;

$_MSG['db.common']    = 'Database error';
$_MSG['db.connect']   = 'db.connect %s, %s, %s';
$_MSG['db.select_db'] = 'db.select_db';
$_MSG['db.sql']       = 'sql: "%s",  error: "%s"';
$_MSG['dbitem.no_id'] = 'The ID for update operation was not passed.';
$_MSG['dbitem.insert'] = 'Insert failed';

$_MSG['app.name'] = 'LiberEye';
$_MSG['app.separator'] = ' - ';

//login
$_MSG['login.error']  = 'Неверный логин или пароль';//'Incorrect login';
$_MSG['login.pass']   = 'Неверный логин или пароль';//'Incorrect Password';
$_MSG['login.status'] = 'Неверный логин или пароль';//'Incorrect User Status';

//form default
$_MSG['confirm'] = 'Confirm %s';
$_MSG['fields.updated'] = 'Fields have been updated.';

//javascript messages
$_MSG['js.sure']    = 'Are you sure?';
$_MSG['js.delete']  = 'Do you really want to delete this %s?';
$_MSG['js.retire']  = 'Do you really want to retire this %s?';
$_MSG['js.add_to_cart']  = 'Your selection is being added to your shopping cart.\n\n You will see it under the Shopping Cart button on the top right of this window.';
$_MSG['js.auth.wait']  = 'This may take a few seconds.  Please be patient!';

//mail messages
$_MSG['mail.empty_to'] = 'Empty e-mail address.';
$_MSG['mail.sent']     = 'Ваше письмо отправлено.';
$_MSG['mail.send']     = 'Ваше письмо отправлено.';


$_MSG['Upload error']     = '%s : Ошибка при загрузке';
$_MSG['Invalid file type']     = '%s : Недопустимый тип файла';



?>
