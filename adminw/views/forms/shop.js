define(['helpers/record', 'helpers/grid'], function(record, grid){

    var data = "";

    function _setData(item) {
        data = item;
        $$('shop-win').getHead().setHTML(item.shop_id==0?'Добавить магазин':'Редактирование магазина');
        $$('save-shop-btn').setValue(item.shop_id==0?'Добавить':'Сохранить');$$('save-shop-btn').refresh();
        $$('shop-form').clearValidation();
        $$('doclist').clearAll();
        $$('promo_head').setValues({src:item.promo_head && item.promo_head!=""?('/images/shop/'+item.promo_head):null});
        $$('shop-form').setValues({id:item.shop_id}, true);

        var translated = ['title', 'description', 'brand_desc'];
        for(var i in LANGUAGES) {
            for(var j in translated) {
                var value = data[translated[j]] && data[translated[j]][LANGUAGES[i].language_id] ? data[translated[j]][LANGUAGES[i].language_id] : '';
                $$(translated[j]+LANGUAGES[i].language_id).setValue(value);
            }
        }
    }

    var form = {
        view:"window", modal:true, id:"shop-win", position:"center", width:600,
        head:"Добавить магазин",
        body:{
            paddingY:20, paddingX:30, elementsConfig:{labelWidth: 140}, view:"form", id:"shop-form", elements:[
                {
                    "rows": [
                        {cols:[
                            {template:'Картинка:', width:100,borderless:true},
                            {template:function (obj) {
                                // obj is a data record object
                                if (obj.src)
                                    return '<a href="'+obj.src+'" target="_blank"><img src="'+obj.src+'" height="30"/></a>';
                                else
                                    return 'нет';
                            }, id:'promo_head', width:100,borderless:true},
                            { view:"list", scroll:false, id:"doclist", type:"uploader", borderless:true },{
                                view:"uploader", upload:"/admin/index.php/part_shops/act_upload",
                                id:"files", name:"files",
                                value:"Выбрать",
                                link:"doclist",
                                autosend:false, //!important
                                sync: false, width:100, multiple:false,borderless:true
                            }]},
                        {
                            "template": "<div style=\"border-top:1px solid #ddd\"></div>",
                            "borderless": true,
                            "height": 10
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
                                {
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
                                }
                            ]
                        },
                        {
                            "cells": [
                                {
                                    "id": "tab1",
                                    "rows": [
                                        {
                                            "translated": true,
                                            "view": "text",
                                            "label": "Название",
                                            "name": "aShop[title][1]",
                                            "required": true,
                                            "invalidMessage": "Поле обязательное",
                                            "id": "title1"
                                        },
                                        {
                                            "translated": true,
                                            "view": "textarea",
                                            "label": "Описание",
                                            "height": 100,
                                            "name": "aShop[description][1]",
                                            "id": "description1"
                                        },
                                        {
                                            "translated": true,
                                            "view": "textarea",
                                            "label": "Описание брендов",
                                            "height": 100,
                                            "name": "aShop[brand_desc][1]",
                                            "id": "brand_desc1"
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
                                            "name": "aShop[title][2]",
                                            "required": true,
                                            "invalidMessage": "Поле обязательное",
                                            "id": "title2"
                                        },
                                        {
                                            "translated": true,
                                            "view": "textarea",
                                            "label": "Описание",
                                            "height": 100,
                                            "name": "aShop[description][2]",
                                            "id": "description2"
                                        },
                                        {
                                            "translated": true,
                                            "view": "textarea",
                                            "label": "Описание брендов",
                                            "height": 100,
                                            "name": "aShop[brand_desc][2]",
                                            "id": "brand_desc2"
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
                                            "name": "aShop[title][3]",
                                            "required": true,
                                            "invalidMessage": "Поле обязательное",
                                            "id": "title3"
                                        },
                                        {
                                            "translated": true,
                                            "view": "textarea",
                                            "label": "Описание",
                                            "height": 100,
                                            "name": "aShop[description][3]",
                                            "id": "description3"
                                        },
                                        {
                                            "translated": true,
                                            "view": "textarea",
                                            "label": "Описание брендов",
                                            "height": 100,
                                            "name": "aShop[brand_desc][3]",
                                            "id": "brand_desc3"
                                        }
                                    ],
                                    "show": false
                                }
                            ]
                        },
                        {
                            "margin": 5,
                            "cols": [
                                {},
                                { view:"button", id:"save-shop-btn", type:"form", value: "Сохранить", click:function(){
                                    var that = this;
                                    $$("files").send(function(){ //sending files
                                        var images = [];
                                        $$("files").files.data.each(function(obj){
                                            var status = obj.status;
                                            if(status=='server' && obj.id!="0") {
                                                images.push(obj.id);
                                            }
                                        });
                                        var data = $$('shop-form').getValues();
                                        data.images = images.join(',');
                                        if ($$("shop-form").validate()) {
                                            record.save("/admin/index.php/part_shops/act_create", data, function(data){
                                                that.getTopParentView().hide();
                                                grid.refresh($$('grid-shop'), '/admin/index.php/part_shops/act_get');
                                            });
                                        }
                                    });
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

	return {
        setData:_setData,
		$ui:form
	};

});