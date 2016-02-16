define(['helpers/record', 'helpers/grid'], function(record, grid){

    var data = "";

    function _setData(item) {
        data = item;
        $$('region-form').setValues({id:item.region_id, "aRegion[country_id]":item.country_id?item.country_id:''}, true);
        $$('region-win').getHead().setHTML(item.region_id==0?'Добавить регион':'Редактирование региона');
        $$('save-region-btn').setValue(item.region_id==0?'Добавить':'Сохранить');$$('save-region-btn').refresh();
        $$('region-form').clearValidation();

        var translated = ['title'];
        for(var i in LANGUAGES) {
            for(var j in translated) {
                var value = data[translated[j]] && data[translated[j]][LANGUAGES[i].language_id] ? data[translated[j]][LANGUAGES[i].language_id] : '';
                $$(translated[j]+LANGUAGES[i].language_id).setValue(value);
            }
        }
    }

    var form = {
        view:"window", modal:true, id:"region-win", position:"center", width:600,
        head:"Добавить региона",
        body:{
            paddingY:20, paddingX:30, elementsConfig:{labelWidth: 140}, view:"form", id:"region-form", elements:[
                {
                    "rows": [
                        {label:"Страна", name:"aRegion[country_id]",
                            "required": true,
                            "invalidMessage": "Поле обязательное", id:"country_id", value:0,  view:"richselect", options:{body:{url: '/admin/index.php/part_countrys/act_get/suggest_1/?sort[title]=asc&count=1000'}}},
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
                                { view:"button", id:"save-region-btn", type:"form", value: "Сохранить", click:function(){
                                    var that = this;
                                    if ($$("region-form").validate()) {
                                        record.save("/admin/index.php/part_regions/act_create", $$('region-form').getValues(), function(data){
                                            that.getTopParentView().hide();
                                            grid.refresh($$('grid-region'), '/admin/index.php/part_regions/act_get');
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
        form.body.elements[0].rows[1].options.push({
            "id": "tab"+LANGUAGES[i].language_id,
            "value": LANGUAGES[i].title
        });
        form.body.elements[0].rows[2].cells.push({
            "id": "tab"+LANGUAGES[i].language_id,
            "rows": [
                {
                    "view": "text",
                    "label": "Название",
                    "name": "aRegion[title]["+LANGUAGES[i].language_id+"]",
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