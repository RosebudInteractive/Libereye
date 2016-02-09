define(['helpers/record', 'helpers/grid'], function(record, grid){

    var data = "";

    function _setData(item) {
        data = item;
        $$('setting-form').setValues({id:item.id, "aSetting[name]":item.name?item.name:'', "aSetting[code]":item.code?item.code:'', "aSetting[val]":item.val?item.val:''}, true);
        $$('setting-win').getHead().setHTML(item.setting_id==0?'Добавить настройку':'Редактирование настройки');
        $$('save-setting-btn').setValue(item.setting_id==0?'Добавить':'Сохранить');$$('save-setting-btn').refresh();
        $$('setting-form').clearValidation();

    }

    var form = {
        view:"window", modal:true, id:"setting-win", position:"center", width:600,
        head:"Добавить настройку",
        body:{
            paddingY:20, paddingX:30, elementsConfig:{labelWidth: 140}, view:"form", id:"setting-form", elements:[
                {
                    "rows": [
                        {
                            "view": "text",
                            "label": "Название",
                            "name": "aSetting[name]",
                            "required": true,
                            "invalidMessage": "Поле обязательное",
                            "id": "name"
                        },{
                            "view": "text",
                            "label": "Код",
                            "name": "aSetting[code]",
                            "required": true,
                            "invalidMessage": "Поле обязательное",
                            "id": "code"
                        },{
                            "view": "text",
                            "label": "Значение",
                            "name": "aSetting[val]",
                            "required": true,
                            "invalidMessage": "Поле обязательное",
                            "id": "val"
                        },
                        {
                            "margin": 5,
                            "cols": [
                                {},
                                { view:"button", id:"save-setting-btn", type:"form", value: "Сохранить", click:function(){
                                    var that = this;
                                    if ($$("setting-form").validate()) {
                                        record.save("/admin/index.php/part_settings/act_create", $$('setting-form').getValues(), function(data){
                                            that.getTopParentView().hide();
                                            grid.refresh($$('grid-setting'), '/admin/index.php/part_settings/act_get');
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