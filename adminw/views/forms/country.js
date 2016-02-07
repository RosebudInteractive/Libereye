define(['helpers/record', 'helpers/grid'], function(record, grid){

    var data = "";

    function _setData(item) {
        data = item;
        $$('country-form').setValues({id:item.country_id, "aCountry[code2]":item.code2, "aCountry[code3]":item.code3}, true);
        $$('country-win').getHead().setHTML(item.country_id==0?'Добавить страну':'Редактирование страны');
        $$('save-country-btn').setValue(item.country_id==0?'Добавить':'Сохранить');$$('save-country-btn').refresh();
        $$('country-form').clearValidation();

        var translated = ['title'];
        for(var i in LANGUAGES) {
            for(var j in translated) {
                var value = data[translated[j]] && data[translated[j]][LANGUAGES[i].language_id] ? data[translated[j]][LANGUAGES[i].language_id] : '';
                $$(translated[j]+LANGUAGES[i].language_id).setValue(value);
            }
        }
    }

    var form = {
        view:"window", modal:true, id:"country-win", position:"center", width:600,
        head:"Добавить страну",
        body:{
            paddingY:20, paddingX:30, elementsConfig:{labelWidth: 140}, view:"form", id:"country-form", elements:[
                {
                    "rows": [
                        {
                            "view": "text",
                            "label": "Код два символа",
                            "name": "aCountry[code2]",
                            "required": true,
                            "invalidMessage": "Поле обязательное",
                            "id": "code2"
                        },
                        {
                            "view": "text",
                            "label": "Код три символа",
                            "name": "aCountry[code3]",
                            "required": true,
                            "invalidMessage": "Поле обязательное",
                            "id": "code3"
                        },
                        {
                            "id": "tabbar",
                            "view": "tabbar",
                            "multiview": true,
                            "animate": {
                                "type": "flip",
                                "subtype": "vertical"
                            },
                            "options": [
                            ]
                        },
                        {
                            "cells": [
                            ]
                        },
                        {
                            "margin": 5,
                            "cols": [
                                {},
                                { view:"button", id:"save-country-btn", type:"form", value: "Сохранить", click:function(){
                                    var that = this;
                                    if ($$("country-form").validate()) {
                                        record.save("/admin/index.php/part_countrys/act_create", $$('country-form').getValues(), function(data){
                                            that.getTopParentView().hide();
                                            grid.refresh($$('grid-country'), '/admin/index.php/part_countrys/act_get');
                                        });
                                    }
                                }},
                                { view:"button", value:"Отмена", click:function(){
                                    this.getTopParentView().hide(); //hide window
                                }}
                            ]
                        }
                    ]
                }

            ]
        }
    }

    for(var i in LANGUAGES) {
        form.body.elements[0].rows[2].options.push({
            "id": "tab"+LANGUAGES[i].language_id,
            "value": LANGUAGES[i].title
        });
        form.body.elements[0].rows[3].cells.push({
            "id": "tab"+LANGUAGES[i].language_id,
                "rows": [
                    {
                        "view": "text",
                        "label": "Название",
                        "name": "aCountry[title]["+LANGUAGES[i].language_id+"]",
                        "required": true,
                        "invalidMessage": "Поле обязательное",
                        "id": "title"+LANGUAGES[i].language_id
                    }
            ],
            "show": LANGUAGES[i].is_default ? true : false
        });
    }

	return {
        setData:_setData,
		$ui:form
	};

});