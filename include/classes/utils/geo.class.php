<?php
/** ============================================================
 * Class for working with geographical data: countries, states,
 * cities etc.
 * @package core
 * ============================================================ */


class Geo
{

    /** Default constructor.
     * @return Geo
     */
    function Geo(){}

    /** Get countries list
    * @return array list of countries
    */
    function getCountries()
    {
        $oDb  = &Database::get();
        $sSql = 'SELECT country_id, country_name FROM `'.Conf::getT('hc_country').'` ORDER BY country_name';
        return $oDb->getHash($sSql);
    }

    /** Return states/regions of selected country.
    * @param int $iCountryId country ID
    * @return array list of states or empty array if given country have no region
    */
    function getStates($iCountryId) {
        $oDb  = &Database::get();
        $sSql = 'SELECT state_id, state_name FROM `'.Conf::getT('hc_state').'` WHERE country_id ='.$iCountryId.' ORDER BY state_name';
        return $oDb->getHash($sSql);
    }

    /** Returns country name
     * @param int $iCountryId country ID
     * @return string country name or false if no such country
     */
    function getCountryName($iCountryId) {
        $oDb  = &Database::get();
        $sSql = 'SELECT country_name FROM `'.Conf::getT('hc_country').'` WHERE country_id='.$iCountryId;
        return $oDb->getField($sSql);
    }

    /** Returns state name
     * @param int $iStateId state ID
     * @return string state name or false if no such state
     */
    function getStateName($iStateId) {
        $oDb  = &Database::get();
        $sSql = 'SELECT state_name FROM `'.Conf::getT('hc_state').'` WHERE state_id='.$iStateId;
        return $oDb->getField($sSql);
    }

    /** Checks that country include given state
     * @param int $iStateId state ID
     * @param int $iCountryId country ID
     * @return boolean true - check ok, false - country does not contain give state
     */
    function checkGeo($iCountryId, $iStateId)
    {
        $oDb  = &Database::get();
        $sSql = 'SELECT country_id'.
                ' FROM '.Conf::getT('state').
                ' INNER JOIN '.Conf::getT('hc_country').' USING(country_id) '.
                ' WHERE state_id='.$iStateId;
        return ($oDb->getField($sSql) == $iCountryId);
    }

}
?>