/** Format text message for output
 * @param string sKey - key of message
 * @param string aParam - params to substitute
 * @return  string formatted message.
 */
function validator_formatMes(sKey, aParam){
    if (! aValidatorMes)
            alert('No validation messages!');
    var sStr = aValidatorMes[sKey];

    var m;
    for(m=0; m<aParam.length; ++m)
        sStr = sStr.replace('%s'+m, aParam[m]);
    return sStr;
}

/** Gets field value, depending on field type
 * @param object oField field
 * @return string value of field
 * @todo add support for dates
 */
function validator_getValue(oField){
    var sVal = '';
    if (oField[0])
    {
        for(var i=0; i<oField.length; ++i)
           if(oField[i].checked || oField[i].selected)
              sVal = oField[i].value;
    }
    else if (oField.type.toLowerCase() != 'checkbox' || oField.checked)
        sVal = oField.value;

    return sVal;
}
/** Checks is form valid
 * @param object oForm  - form to validate
 * @param array aShema  - array of validation shemas (hash) related to certan field
 * @param array aRules  - array of validation rules bentween 2 fields
 * @param string sDiv  - name of html DIV element for errors output
 * @return  boolean  true if all is ok or false + alert wiht error messages if form contains errors.
 */
function validator_isValid(oForm, aShema, aRules, sDiv) {
    // errors

    var aErr  = [];
    var oFld  = null; // first field with error
    var aErrFields = {};
    var i;
    // for each fields
    for( i=0; i< aShema.length; ++i ){
        var oShema = aShema[i];
        var sVal = validator_getValue(oForm.elements[oShema.field]);
        //optional param
        if( typeof(oShema.optional) != 'undefined' && !sVal.length)
            continue;
        var sMes = ( typeof(oShema.message) != 'undefined' ? oShema.message : '');

        var aTmpErr = [];
        // validation
        if (typeof(oShema.minlen) != 'undefined' &&  oShema.minlen > sVal.length)
            aTmpErr[aTmpErr.length] = validator_formatMes('minlen', [oShema.title, oShema.minlen]);
        if (typeof(oShema.maxlen) != 'undefined' &&  oShema.maxlen < sVal.length)
            aTmpErr[aTmpErr.length] = validator_formatMes('maxlen', [oShema.title, oShema.maxlen]);
        if (typeof(oShema.pattern) != 'undefined' && sVal.search(oShema.pattern) == -1 )
            aTmpErr[aTmpErr.length] = validator_formatMes('pattern', [oShema.title]);
        if (typeof(oShema.min) != 'undefined' &&  oShema.min > sVal)
            aTmpErr[aTmpErr.length] = validator_formatMes('min', [oShema.title, oShema.min]);
        if (typeof(oShema.max) != 'undefined' &&  oShema.max < sVal)
            aTmpErr[aTmpErr.length] = validator_formatMes('max', [oShema.title, oShema.max]);
        if (typeof(oShema.mineq) != 'undefined' &&  oShema.mineq >= sVal)
            aTmpErr[aTmpErr.length] = validator_formatMes('mineq', [oShema.title, oShema.mineq]);
        if (typeof(oShema.maxeq) != 'undefined' &&  oShema.maxeq < sVal)
            aTmpErr[aTmpErr.length] = validator_formatMes('maxeq', [oShema.title, oShema.maxeq]);

        // store error messages for field
        if (sMes && aTmpErr.length) // if given custom error message store only it
            aErr[aErr.length] = sMes;
        else // store all errors
            aErr = aErr.concat(aTmpErr);

        if (aTmpErr.length)
        {
                aErrFields[oShema.field] = oShema.field;
        }
        //setErrorStatus(oForm.elements[oShema.field], aTmpErr.length);

        // if first error, try to set focus
        if (aErr.length && oFld == null)
            oFld = oForm.elements[oShema.field];
    } // end loop by single elements

        // for each rules
    if ( 'undefined' != typeof(aRules) ){
        for( i=0; i < aRules.length; ++i ) { // for each rules  0 - first op, 1 - second op, 2 - operation, 3 - Error message text
            var v1 = validator_getValue(oForm.elements[aRules[i][0]]);
            var v2 = validator_getValue(oForm.elements[aRules[i][1]]);
            var bIsError = false;
            switch( aRules[i][2] ){
                case '==' :
                        if ( v1 != v2 ) {
                            aErr[aErr.length] = aRules[i][3];
                            bIsError = true;
                        }
                break;
                case '<=' :
                        if ( (v1!='') &&  (v2!='') && (parseFloat(v1) > parseFloat(v2)) ) {
                            aErr[aErr.length] = aRules[i][3];
                            bIsError = true;
                        }
                break;
                case '>=' :
                        if  ( (v1!='') && (v2=='') && (parseFloat(v1) < parseFloat(v2)) ) {
                            aErr[aErr.length] = aRules[i][3];
                            bIsError = true;
                        }
                break;
                case '!=' :
                        if ( v1 == v2 ) {
                            aErr[aErr.length] = aRules[i][3];
                            bIsError = true;
                        }
                case 'req' :
                        if ( v1 && !v2 ) {
                            aErr[aErr.length] = aRules[i][3];
                            bIsError = true;

                        }
                break;
            }//switch
            if (aErr.length && oFld == null) // if first error
                oFld = oForm.elements[aRules[i][0]];

            if (bIsError) {
                    aErrFields[aRules[i][0]] = aRules[i][0];
                    aErrFields[aRules[i][1]] = aRules[i][1];
            }

        }// end loop by rules
    }//end rules

    
    //process erorr statuses for fields
    aFields = oForm.elements;
    for(i=0; i<aFields.length; i++) {
        if (aFields[i].type!='hidden') {
                validator_setErrorStatus(aFields[i], aErrFields[aFields[i].name]);
        }
    }
    
    
    // make output
    if ( aErr.length ) {
        var sOut = '';
        var oDiv = document.getElementById(sDiv);
        if (oDiv){
           for(i=0; i<aErr.length; ++i)
                    sOut += '<span class="error">'+aErr[i]+'</span><br>';
           oDiv.innerHTML = sOut;
        } else
            alert(aErr.join("\n"));

	   if (oFld[0] && oFld[0].type == 'radio')
            oFld[0].focus();
        else if (oFld && oFld.type != 'hidden')
            oFld.focus();
            
            return false;
    }

    return true;
}


/** Set/removes error status for field (through class).
 * @param object oFld     field object
 * @param object bIsError true - set error, false - remove error status
 */
function validator_setErrorStatus(oFld, bIsError)
{
        var sClass = oFld.className;
        var iLength = sClass.length;
        if (bIsError){ //set error
            if ('_error' != sClass.substr(iLength-6, 6))
                oFld.className = sClass+'_error';
        }
        else { //remove error
            if ('_error'==sClass.substr(iLength-6, 6))
                oFld.className = sClass.substr(0, iLength-6);
        }
}