define(['helpers/record', 'helpers/grid'], function(record, grid){

    var data = "";

    function _setData(item) {
        data = item;
        $$('calc-form').clearValidation();
    }

    var form = {
        view:"window", modal:true, id:"calc-win", position:"center", width:600,
        head:"Расчет доставки товара",
        body:{
            paddingY:20, paddingX:30, elementsConfig:{labelWidth: 200}, view:"form", id:"calc-form", elements:[

                {label:"Коробка", name:"aCalc[box_id]", "required": true, "invalidMessage": "Поле обязательное", id:"box_id", value:0,  view:"richselect", options:{body:{url: '/admin/index.php/part_boxes/act_get/suggest_1/?sort[title]=asc&count=1000'}}},
                {label:"Регион", name:"aCalc[region_id]", "required": true, "invalidMessage": "Поле обязательное", id:"region_id", value:0,  view:"richselect", options:{body:{url: '/admin/index.php/part_regions/act_get/suggest_1/?sort[region_id]=asc&count=1000'}}},
                {label:"Перевозчик", name:"aCalc[carrier_id]", "required": true, "invalidMessage": "Поле обязательное", id:"carrier_id", value:0,  view:"richselect", options:{body:{url: '/admin/index.php/part_carriers/act_get/suggest_1/?sort[title]=asc&count=1000'}}},
                        {
                            "view": "text",
                            "label": "Фактический вес (кг)",
                            "name": "aCalc[weight]",
                            "id": "weight", "required": true, "invalidMessage": "Поле обязательное"
                        },{
                            "view": "text",
                            "label": "Цена (€)",
                            "name": "aCalc[price]",
                            "id": "price", "required": true, "invalidMessage": "Поле обязательное"
                        },{
                            "view": "text",
                            "label": "Итого счет GL, €", name:'togl',
                            "id": "togl", readonly:true
                        },
                        {
                            "margin": 5,
                            "cols": [
                                {},
                                { view:"button", id:"save-calc-btn", type:"form", value: "Рассчитать", click:function(){
                                    var that = this;
                                    if ($$("calc-form").validate()) {
                                        record.post("/admin/index.php/part_carriers/act_calc", $$('calc-form').getValues(), function(data){
                                            $$('calc-form').setValues({togl:data.result}, true);
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

    return {
        setData:_setData,
        $ui:form
    };

});