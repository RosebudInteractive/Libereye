define(['helpers/record', 'helpers/grid'], function(record, grid){

    var data = "";

    function _setData(item) {
        data = item;
        $$('timezone-form').setValues({
             id:item.timezone_id,
            "aTimezone[code]":item.code?item.code:'',
            "aTimezone[time_shift]":item.time_shift?item.time_shift:''
        }, true);
        $$('timezone-win').getHead().setHTML(item.timezone_id==0?'Добавить временную зону':'Редактирование страны');
        $$('save-timezone-btn').setValue(item.timezone_id==0?'Добавить':'Сохранить');$$('save-timezone-btn').refresh();
        $$('timezone-form').clearValidation();

        var translated = ['title'];
        for(var i in LANGUAGES) {
            for(var j in translated) {
                var value = data[translated[j]] && data[translated[j]][LANGUAGES[i].language_id] ? data[translated[j]][LANGUAGES[i].language_id] : '';
                $$(translated[j]+LANGUAGES[i].language_id).setValue(value);
            }
        }
    }

    var form = {
        view:"window", modal:true, id:"timezone-win", position:"center", width:600,
        head:"Добавить страну",
        body:{
            paddingY:20, paddingX:30, elementsConfig:{labelWidth: 140}, view:"form", id:"timezone-form", elements:[
                {
                    "rows": [
                        {
                            "view": "text",
                            "label": "Код",
                            "name": "aTimezone[code]",
                            "required": true,
                            "invalidMessage": "Поле обязательное",
                            "id": "code"
                        },
                        {
                            "view": "text",
                            "label": "Смещение(мин)",
                            "name": "aTimezone[time_shift]",
                            "required": true,
                            "invalidMessage": "Поле обязательное",
                            "id": "time_shift"
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
                                { view:"button", id:"save-timezone-btn", type:"form", value: "Сохранить", click:function(){
                                    var that = this;
                                    if ($$("timezone-form").validate()) {
                                        record.save("/admin/index.php/part_timezones/act_create", $$('timezone-form').getValues(), function(data){
                                            that.getTopParentView().hide();
                                            grid.refresh($$('grid-timezone'), '/admin/index.php/part_timezones/act_get');
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
                        "name": "aTimezone[title]["+LANGUAGES[i].language_id+"]",
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