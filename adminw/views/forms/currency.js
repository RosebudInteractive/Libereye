define(['helpers/record', 'helpers/grid'], function(record, grid){

    var data = "";

    function _setData(item) {
        data = item;
        $$('currency-form').setValues({id:item.currency_id, "aCurrency[code]":item.code?item.code:''}, true);
        $$('currency-win').getHead().setHTML(item.currency_id==0?'Добавить валюту':'Редактирование валюты');
        $$('save-currency-btn').setValue(item.currency_id==0?'Добавить':'Сохранить');$$('save-currency-btn').refresh();
        $$('currency-form').clearValidation();

    }

    var form = {
        view:"window", modal:true, id:"currency-win", position:"center", width:600,
        head:"Добавить валюту",
        body:{
            paddingY:20, paddingX:30, elementsConfig:{labelWidth: 140}, view:"form", id:"currency-form", elements:[
                {
                    "rows": [
                        {
                            "view": "text",
                            "label": "Код валюты",
                            "name": "aCurrency[code]",
                            "required": true,
                            "invalidMessage": "Поле обязательное",
                            "id": "code2"
                        },
                        {
                            "margin": 5,
                            "cols": [
                                {},
                                { view:"button", id:"save-currency-btn", type:"form", value: "Сохранить", click:function(){
                                    var that = this;
                                    if ($$("currency-form").validate()) {
                                        record.save("/admin/index.php/part_currencys/act_create", $$('currency-form').getValues(), function(data){
                                            that.getTopParentView().hide();
                                            grid.refresh($$('grid-currency'), '/admin/index.php/part_currencys/act_get');
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



	return {
        setData:_setData,
		$ui:form
	};

});