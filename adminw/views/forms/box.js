define(['helpers/record', 'helpers/grid'], function(record, grid){

    var data = "";

    function _setData(item) {
        data = item;
        $$('box-form').setValues({
            id:item.box_id,
            "aBox[length]":item.length?item.length:'',
            "aBox[width]":item.width?item.width:'',
            "aBox[height]":item.height?item.height:''
        }, true);
        $$('box-win').getHead().setHTML(item.box_id==0?'Добавить коробку':'Редактирование коробки');
        $$('save-box-btn').setValue(item.box_id==0?'Добавить':'Сохранить');$$('save-box-btn').refresh();
        $$('box-form').clearValidation();

        var translated = ['title'];
        for(var i in LANGUAGES) {
            for(var j in translated) {
                var value = data[translated[j]] && data[translated[j]][LANGUAGES[i].language_id] ? data[translated[j]][LANGUAGES[i].language_id] : '';
                $$(translated[j]+LANGUAGES[i].language_id).setValue(value);
            }
        }
    }

    var form = {
        view:"window", modal:true, id:"box-win", position:"center", width:600,
        head:"Добавить коробку",
        body:{
            paddingY:20, paddingX:30, elementsConfig:{labelWidth: 140}, view:"form", id:"box-form", elements:[
                {
                    "rows": [
                        {
                            "view": "text",
                            "label": "Ширина",
                            "name": "aBox[width]",
                            "required": true,
                            "invalidMessage": "Поле обязательное",
                            "id": "width"
                        },
                        {
                            "view": "text",
                            "label": "Длина",
                            "name": "aBox[length]",
                            "required": true,
                            "invalidMessage": "Поле обязательное",
                            "id": "length"
                        },

                        {
                            "view": "text",
                            "label": "Высота",
                            "name": "aBox[height]",
                            "required": true,
                            "invalidMessage": "Поле обязательное",
                            "id": "height"
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
                                { view:"button", id:"save-box-btn", type:"form", value: "Сохранить", click:function(){
                                    var that = this;
                                    if ($$("box-form").validate()) {
                                        record.save("/admin/index.php/part_boxes/act_create", $$('box-form').getValues(), function(data){
                                            that.getTopParentView().hide();
                                            grid.refresh($$('grid-box'), '/admin/index.php/part_boxes/act_get');
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
        form.body.elements[0].rows[3].options.push({
            "id": "tab"+LANGUAGES[i].language_id,
            "value": LANGUAGES[i].title
        });
        form.body.elements[0].rows[4].cells.push({
            "id": "tab"+LANGUAGES[i].language_id,
                "rows": [
                    {
                        "view": "text",
                        "label": "Название",
                        "name": "aBox[title]["+LANGUAGES[i].language_id+"]",
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