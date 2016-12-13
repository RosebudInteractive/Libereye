define(['helpers/record', 'helpers/grid'], function(record, grid){

    var data = "";

    function _setData(item) {
        data = item;
        $$('brand-form').setValues({id:item.brand_id}, true);
        $$('brand-win').getHead().setHTML(item.brand_id==0?'Добавить бренд':'Редактирование бренда');
        $$('save-brand-btn').setValue(item.brand_id==0?'Добавить':'Сохранить');$$('save-brand-btn').refresh();
        $$('brand-form').clearValidation();

        var translated = ['title', 'description'];
        for(var i in LANGUAGES) {
            for(var j in translated) {
                var value = data[translated[j]] && data[translated[j]][LANGUAGES[i].language_id] ? data[translated[j]][LANGUAGES[i].language_id] : '';
                $$(translated[j]+LANGUAGES[i].language_id).setValue(value);
            }
        }
    }

    var form = {
        view:"window", modal:true, id:"brand-win", position:"center", width:600,
        head:"Добавить бренд",
        body:{
            paddingY:20, paddingX:30, elementsConfig:{labelWidth: 140}, view:"form", id:"brand-form", elements:[
                {
                    "rows": [
                        {
                            "id": "tabbar",
                            "view": "tabbar",
                            "multiview": true,
                            "animate": {
                                "type": "flip",
                                "subtype": "vertical"
                            },
                            "options": [
                                /*{
                                    "id": "tab1",
                                    "value": "Русский"
                                },
                                {
                                    "id": "tab2",
                                    "value": "English"
                                },
                                {
                                    "id": "tab3",
                                    "value": "Français"
                                }*/
                            ]
                        },
                        {
                            "cells": [
                                /*{
                                    "id": "tab1",
                                    "rows": [
                                        {
                                            "translated": true,
                                            "view": "text",
                                            "label": "Название",
                                            "name": "aBrand[title][1]",
                                            "required": true,
                                            "invalidMessage": "Поле обязательное",
                                            "id": "title1"
                                        },
                                        {
                                            "translated": true,
                                            "view": "textarea",
                                            "label": "Описание",
                                            "height": 100,
                                            "name": "aBrand[description][1]",
                                            "id": "description1"
                                        }
                                    ],
                                    "show": true
                                },
                                {
                                    "id": "tab2",
                                    "rows": [
                                        {
                                            "translated": true,
                                            "view": "text",
                                            "label": "Название",
                                            "name": "aBrand[title][2]",
                                            "required": true,
                                            "invalidMessage": "Поле обязательное",
                                            "id": "title2"
                                        },
                                        {
                                            "translated": true,
                                            "view": "textarea",
                                            "label": "Описание",
                                            "height": 100,
                                            "name": "aBrand[description][2]",
                                            "id": "description2"
                                        }
                                    ],
                                    "show": false
                                },
                                {
                                    "id": "tab3",
                                    "rows": [
                                        {
                                            "translated": true,
                                            "view": "text",
                                            "label": "Название",
                                            "name": "aBrand[title][3]",
                                            "required": true,
                                            "invalidMessage": "Поле обязательное",
                                            "id": "title3"
                                        },
                                        {
                                            "translated": true,
                                            "view": "textarea",
                                            "label": "Описание",
                                            "height": 100,
                                            "name": "aBrand[description][3]",
                                            "id": "description3"
                                        }
                                    ],
                                    "show": false
                                }*/
                            ]
                        },
                        {
                            "margin": 5,
                            "cols": [
                                {},
                                { view:"button", id:"save-brand-btn", type:"form", value: "Сохранить", click:function(){
                                    var that = this;
                                    if ($$("brand-form").validate()) {
                                        record.save("/admin/index.php/part_brands/act_create", $$('brand-form').getValues(), function(data){
                                            that.getTopParentView().hide();
                                            grid.refresh($$('grid-brand'), '/admin/index.php/part_brands/act_get');
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
        form.body.elements[0].rows[0].options.push({
            "id": "tab"+LANGUAGES[i].language_id,
            "value": LANGUAGES[i].title
        });
        form.body.elements[0].rows[1].cells.push({
            "id": "tab"+LANGUAGES[i].language_id,
            "rows": [
                {
                    "view": "text",
                    "label": "Название",
                    "name": "aBrand[title]["+LANGUAGES[i].language_id+"]",
                    "required": true,
                    "invalidMessage": "Поле обязательное",
                    "id": "title"+LANGUAGES[i].language_id
                },
                {
                    "view": "textarea",
                    "label": "Описание",
                    "height": 100,
                    "name": "aBrand[description]["+LANGUAGES[i].language_id+"]",
                    "id": "description"+LANGUAGES[i].language_id
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