define(['helpers/record', 'helpers/grid'], function(record, grid){

    var data = "";

    function _setData(item) {
        data = item;
        _setFields($$('account-form'));
    }

    function _setFields(obj) {
        var item = data;
        obj.clearValidation();
        obj.setValues({
            id:item.account_id,
            "aAccount[fname]":item.fname?item.fname:'',
            "aAccount[email]":item.email?item.email:'',
            "aAccount[status]":item.status?item.status:'seller',
            "aAccount[shop_id]":item.shop_id?item.shop_id:0,
            "aAccount[country_id]":item.country_id?item.country_id:0,
            "aAccount[city]":item.city?item.city:'',
            "aAccount[street]":item.street?item.street:'',
            "aAccount[building]":item.building?item.building:'',
            "aAccount[housing]":item.housing?item.housing:'',
            "aAccount[apartment]":item.apartment?item.apartment:'',
            "aAccount[phone]":item.phone?item.phone:'',
            "aAccount[pass]":''
        }, true);
        $$('account-win').getHead().setHTML(item.account_id==0?'Добавить пользователя':'Редактирование пользователя');
        $$('save-account-btn').setValue(item.account_id==0?'Добавить':'Сохранить');$$('save-account-btn').refresh();
        $$('account-doclist').clearAll();
        $$('account-image').setValues({src:item.image && item.image!=""?('/images/account/'+item.image):null});
    }

    var form = {
        view:"window", modal:true, id:"account-win", position:"center", width:800,
        head:"Добавить пользователя",
        body:{
            paddingY:20, paddingX:30, elementsConfig:{labelWidth: 140}, view:"form", id:"account-form", elements:[
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
                            }, id:'account-image', width:100,borderless:true},
                            { view:"list", scroll:false, id:"account-doclist", type:"uploader", borderless:true },{
                                view:"uploader", upload:"/admin/index.php/part_shops/act_upload/type_account/",
                                id:"account-files", name:"files",
                                value:"Выбрать",
                                link:"account-doclist",
                                autosend:false, //!important
                                sync: false, width:100, multiple:false,borderless:true
                            }]},
                        {
                            "template": "<div style=\"border-top:1px solid #ddd\"></div>",
                            "borderless": true,
                            "height": 10
                        },
                        {
                            "view": "text",
                            "label": "Имя",
                            "name": "aAccount[fname]",
                            "required": true,
                            "invalidMessage": "Поле обязательное",
                            "id": "fname"
                        },{
                            "view": "text",
                            "label": "Email",
                            "name": "aAccount[email]",
                            "required": true,
                            "invalidMessage": "Поле обязательное",
                            "id": "email"
                        },
                        {
                            "view": "text",
                            "label": "Пароль",
                            "name": "aAccount[pass]",
                            "id": "pass"
                        },
                        {view:"select", label:"Статус", name:"aAccount[status]", id:"status", value:'seller', options:[{id:'client', value:'Клиент'},{id:'seller', value:'Шоппер'},{id:'admin', value:'Админ'}] },
                        {label:"Магазин шоппера", name:"aAccount[shop_id]", id:"shop_id", value:0,  view:"richselect", options:{
                                body:{
                                    url: '/admin/index.php/part_shops/act_get/suggest_1/?sort[title]=asc&count=1000'
                                }
                            }
                        },
                        {cols:[
                            {
                                "view": "text",
                                "label": "Город",
                                "name": "aAccount[city]",
                                "id": "city"
                            },
                            {label:"Страна", name:"aAccount[country_id]", id:"country_id", value:0,  view:"richselect", options:{
                                body:{
                                    url: '/admin/index.php/part_countrys/act_get/suggest_1/?sort[title]=asc&count=1000'
                                }
                            }
                            }
                        ]},
                        {cols:[
                            {
                                "view": "text",
                                "label": "Улица",
                                "name": "aAccount[street]",
                                "id": "street"
                            },
                            {
                                "view": "text",
                                "label": "Дом",
                                "name": "aAccount[building]",
                                "id": "building"
                            },
                        ]},
                        {cols:[
                            {
                                "view": "text",
                                "label": "Корпус",
                                "name": "aAccount[housing]",
                                "id": "housing"
                            },
                            {
                                "view": "text",
                                "label": "Квартира",
                                "name": "aAccount[apartment]",
                                "id": "apartment"
                            }
                        ]},
                        {cols:[
                            {
                                "view": "text",
                                "label": "Телефон",
                                "name": "aAccount[phone]",
                                "id": "phone"
                            },
                            {

                            }
                        ]},
                        {
                            "margin": 5,
                            "cols": [
                                {},
                                { view:"button", id:"save-account-btn", type:"form", value: "Сохранить", click:function(){
                                    var that = this;
                                    $$("account-files").send(function(){ //sending files
                                        var images = [];
                                        $$("account-files").files.data.each(function(obj){
                                            var status = obj.status;
                                            if(status=='server' && obj.id!="0") {
                                                images.push(obj.id);
                                            }
                                        });
                                        var data = $$('account-form').getValues();
                                        data.images = images.join(',');
                                        if ($$("account-form").validate()) {
                                            record.save("/admin/index.php/part_accounts/act_create", data, function(data){
                                                if (!data.error || data.error.length == 0) {
                                                    that.getTopParentView().hide();
                                                    grid.refresh($$('grid-account'), '/admin/index.php/part_accounts/act_get');
                                                }
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
            ]/*,
            scheme:{
                $init:function(obj){console.log(obj);_setFields(obj);}
            }*/
        }
    }

	return {
        setData:_setData,
		$ui:form
	};

});