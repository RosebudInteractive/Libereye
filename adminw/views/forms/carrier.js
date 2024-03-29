define(['helpers/record', 'helpers/grid'], function(record, grid){

    var data = "";

    function _setData(item) {
        data = item;
        $$('carrier-form').setValues({
            id:item.carrier_id, 
            "aCarrier[tax]":item.tax?item.tax:'',
            "aCarrier[customs]":item.customs?item.customs:'',
            "aCarrier[box_charge]":item.box_charge?item.box_charge:'',
            "aCarrier[insurance]":item.insurance?item.insurance:''
        }, true);
        $$('carrier-win').getHead().setHTML(item.carrier_id==0?'Добавить перевозчика':'Редактирование перевозчика');
        $$('save-carrier-btn').setValue(item.carrier_id==0?'Добавить':'Сохранить');$$('save-carrier-btn').refresh();
        $$('carrier-form').clearValidation();

        var translated = ['title'];
        for(var i in LANGUAGES) {
            for(var j in translated) {
                var value = data[translated[j]] && data[translated[j]][LANGUAGES[i].language_id] ? data[translated[j]][LANGUAGES[i].language_id] : '';
                $$(translated[j]+LANGUAGES[i].language_id).setValue(value);
            }
        }

        if ($$('carrier-form').getValues()['aRegion[1][first_kg_price]'] == undefined) {
            var rates = { rows:[
                { template:"Стоимость доставки по регионам", type:"section"},
                {cols:[{ view:"label", label:"", height:20 }, { view:"label", label:"Цена первого кг", height:20 }, { view:"label", label:"Шаг стоимости", height:20 }]},
                {view:"scrollview",
                    id:"verses",
                    scroll:"y", //vertical scrolling
                    height:150,
                    borderless:true,
                    body:{rows:[
                        /*{cols:[{ view:"label", label:"Москва" }, { view:"text", name:'aRegion[1][first_kg_price]',  value:'' }, { view:"text", name:'aRegion[1][kg_step_price]', value:'' }]},
                        */
                    ]
                    }
                }]
            }
            for(var i in item.rates) {
                rates.rows[2].body.rows.push({
                    cols:[
                        { view:"label", label:item.rates[i].title},
                        { view:"text", id:'region'+item.rates[i].region_id, name:'aRegion['+item.rates[i].region_id+'][first_kg_price]',  value:item.rates[i].first_kg_price },
                        { view:"text", name:'aRegion['+item.rates[i].region_id+'][kg_step_price]', value:item.rates[i].kg_step_price }
                    ]
                });
            }
            $$("carrier-form").addView(rates, 4);
        } else {
            for(var i in item.rates) {
                var values = {};
                values['aRegion['+item.rates[i].region_id+'][first_kg_price]'] = item.rates[i].first_kg_price;
                values['aRegion['+item.rates[i].region_id+'][kg_step_price]'] = item.rates[i].kg_step_price;
                $$('carrier-form').setValues(values, true);
            }
        }
    }

    var form = {
        view:"window", modal:true, id:"carrier-win", position:"center", width:600,
        head:"Добавить перевозчика",
        body:{
            paddingY:20, paddingX:30, elementsConfig:{labelWidth: 200}, view:"form", id:"carrier-form", elements:[


                        {
                            "view": "text",
                            "label": "Коэффициент",
                            "name": "aCarrier[tax]",
                            "id": "tax"
                        },{
                            "view": "text",
                            "label": "Таможенные сборы",
                            "name": "aCarrier[customs]",
                            "id": "customs"
                        },{
                            "view": "text",
                            "label": "Стоимость упаковки",
                            "name": "aCarrier[box_charge]",
                            "id": "box_charge"
                        },{
                            "view": "text",
                            "label": "Страховка, %",
                            "name": "aCarrier[insurance]",
                            "id": "insurance"
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
                                { view:"button", id:"save-carrier-btn", type:"form", value: "Сохранить", click:function(){
                                    var that = this;
                                    if ($$("carrier-form").validate()) {
                                        record.save("/admin/index.php/part_carriers/act_create", $$('carrier-form').getValues(), function(data){
                                            that.getTopParentView().hide();
                                            grid.refresh($$('grid-carrier'), '/admin/index.php/part_carriers/act_get');
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
    }

    for(var i in LANGUAGES) {
        form.body.elements[4].options.push({
            "id": "tab"+LANGUAGES[i].language_id,
            "value": LANGUAGES[i].title
        });
        form.body.elements[5].cells.push({
            "id": "tab"+LANGUAGES[i].language_id,
            "rows": [
                {
                    "view": "text",
                    "label": "Название",
                    "name": "aCarrier[title]["+LANGUAGES[i].language_id+"]",
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