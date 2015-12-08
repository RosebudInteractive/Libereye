<?php
/** ============================================================
 * Validator messages.
 *  Language: english
 *  Encoding: ISO-8859-1
 * @author Aitoc Team
 * @package messages
 * ============================================================ */

global $_MSG;

$_MSG['validator.unknown_rule']  = 'Unknown rule :`%s`!';
$_MSG['validator.unknown_keys']  = 'Unknown keys!';
$_MSG['validator.unknown_def']   = 'Unknown default validation type: `%s`!';

// rules
//$_MSG['validator.rule.==']       = 'Поля `%s` и `%s` должны совпадать.';
$_MSG['validator.rule.!=']       = 'Fields `%s` and `%s` should be different.';
$_MSG['validator.rule.<=']       = 'Field `%s` should be less or equal than `%s`.';
$_MSG['validator.rule.>=']       = 'Field `%s` should be more or equal than `%s`.';
$_MSG['validator.rule.req']      = 'Поле `%2$s` обязательно для заполнения.';

//fields
$_MSG['validator.field.minlen']  = 'Число символов поля `%s` должно быть больше или равно %s символов.';
$_MSG['validator.field.maxlen']  = 'Length of `%s` field should be less than or equal to %s characters.';
$_MSG['validator.field.mineq']   = '`%s`: field value should be more than %s.';
$_MSG['validator.field.maxeq']   = '`%s`: field value should be less than %s.';
$_MSG['validator.field.min']     = '`%s`: field value should be more than or equal to %s.';
$_MSG['validator.field.max']     = '`%s`: field value should be less than or equal to %s.';
//$_MSG['validator.field.pattern'] = 'Ошибка в поле `%s`.';
$_MSG['validator.field.custom']  = '`%s`: %s';

//messagef for default field validators
//$_MSG['validator.def.required']  = 'Поле `%s` обязательно для заполнения.';
$_MSG['validator.def.ssn']       = '`%s` should have XXX-XXX-XXXX format.';
$_MSG['validator.duplicate']     = 'Duplicate value `%s` for `%s`.';

?>