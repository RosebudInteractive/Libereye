define(['helpers/record', 'helpers/grid'], function(record, grid){

    var data = "";

    function _setData(item) {
        data = item;
        $$('template-form').setValues({
            id:item.template_id,
            "aTemplate[code]":item.code?item.code:'',
            "aTemplate[fname]":item.fname?item.fname:'',
            "aTemplate[faddr]":item.faddr?item.faddr:'',
            "aTemplate[rname]":item.rname?item.rname:'',
            "aTemplate[raddr]":item.raddr?item.raddr:''
        }, true);
        $$('template-win').getHead().setHTML(item.template_id==0?'Добавить шаблон':'Редактирование шаблон');
        $$('save-template-btn').setValue(item.template_id==0?'Добавить':'Сохранить');$$('save-template-btn').refresh();
        $$('template-form').clearValidation();

        var translated = ['subject', 'body'];
        for(var i in LANGUAGES) {
            for(var j in translated) {
                var value = data[translated[j]] && data[translated[j]][LANGUAGES[i].language_id] ? data[translated[j]][LANGUAGES[i].language_id] : '';
                $$(translated[j]+LANGUAGES[i].language_id).setValue(value);
            }
        }
    }

    var form = {
        view:"window", modal:true, id:"template-win", position:"center", width:600,
        head:"Добавить шаблон",
        body:{
            paddingY:20, paddingX:30, elementsConfig:{labelWidth: 140}, view:"form", id:"template-form", elements:[
                {
                    "rows": [
                        {
                            "view": "text",
                            "label": "Alias",
                            "name": "aTemplate[code]",
                            "required": true,
                            "invalidMessage": "Поле обязательное",
                            "id": "code"
                        },
                        {
                            "view": "text",
                            "label": "From name",
                            "name": "aTemplate[fname]",
                            "required": true,
                            "invalidMessage": "Поле обязательное",
                            "id": "fname"
                        },
                        {
                            "view": "text",
                            "label": "From email",
                            "name": "aTemplate[faddr]",
                            "required": true,
                            "invalidMessage": "Поле обязательное",
                            "id": "faddr"
                        },
                        {
                            "view": "text",
                            "label": "Reply name",
                            "name": "aTemplate[rname]",
                            "required": true,
                            "invalidMessage": "Поле обязательное",
                            "id": "rname"
                        },
                        {
                            "view": "text",
                            "label": "Reply email",
                            "name": "aTemplate[raddr]",
                            "required": true,
                            "invalidMessage": "Поле обязательное",
                            "id": "raddr"
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
                                { view:"button", id:"save-template-btn", type:"form", value: "Сохранить", click:function(){
                                    var that = this;
                                    if ($$("template-form").validate()) {
                                        record.save("/admin/index.php/part_templates/act_create", $$('template-form').getValues(), function(data){
                                            that.getTopParentView().hide();
                                            grid.refresh($$('grid-template'), '/admin/index.php/part_templates/act_get');
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
        form.body.elements[0].rows[5].options.push({
            "id": "tab"+LANGUAGES[i].language_id,
            "value": LANGUAGES[i].title
        });
        form.body.elements[0].rows[6].cells.push({
            "id": "tab"+LANGUAGES[i].language_id,
                "rows": [
                    {
                        "view": "text",
                        "label": "Тема",
                        "name": "aTemplate[subject]["+LANGUAGES[i].language_id+"]",
                        "required": true,
                        "invalidMessage": "Поле обязательное",
                        "id": "subject"+LANGUAGES[i].language_id
                    },
                    {
                        "view": "textarea",
                        "height": 200,
                        "label": "Текст",
                        "name": "aTemplate[body]["+LANGUAGES[i].language_id+"]",
                        "required": true,
                        "invalidMessage": "Поле обязательное",
                        "id": "body"+LANGUAGES[i].language_id
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