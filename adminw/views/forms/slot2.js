define(['helpers/record', 'helpers/grid'], function(record, grid){

    var data = "";

    function _setData(item, setfields) {
        data = item;
        if (setfields) {
            $$('seller_id').define("options", {body:{url: '/admin/index.php/part_accounts/act_get/?shop_id='+data.shop_id+'&continue=true&sort[fname]=asc&suggest=1'}});
            $$('slot-form').setValues({
                id:item.shop_slot_id,
                shop_id:item.shop_id,
                "seller_id":item.seller_id?item.seller_id:'',
                "status":item.status?item.status:'',
                "time_from":item.time_from?item.time_from:'',
                "time_to":item.time_to?item.time_to:''
            }, true);
            $$('slot-win').getHead().setHTML(item.shop_slot_id==0?'Добавить слот':'Редактирование слота');
            $$('save-slot-btn').setValue(item.shop_slot_id==0?'Добавить':'Сохранить');$$('save-slot-btn').refresh();
            $$('slot-form').clearValidation();
        }
    }

    // var shopValues = new webix.DataCollection({ url: '/admin/index.php/part_shops/act_get/suggest_1'});

    var form = {
        view:"window", modal:true, id:"slot-win", position:"center", width:600,
        head:"Добавить слот",
        body:{
            paddingY:20, paddingX:30, elementsConfig:{labelWidth: 140}, view:"form", id:"slot-form", elements: [ {rows : [
                {label:"Шоппер", name:"seller_id", id:"seller_id", value:0,  view:"richselect", options:{
                    body:{
                        url: '/admin/index.php/part_slots/act_get/?shop_id='+data.shop_id+'&continue=true&sort[fname]=asc&suggest=1'
                    }
                }
                },
                {view:"select", label:"Статус", name:"status", id:"status_slot", placeholder:"Статус", value:'free', options:['draft', 'free', 'booked'] },
                {cols:[
                    //{template:':', width:100, borderless:true},
                    {view:"datepicker", timepicker:true, name:"time_from", id:"time_from_slot", placeholder:"Начало" },
                    {view:"datepicker", timepicker:true, name:"time_to", id:"time_to_slot", placeholder:"Конец" }
                ]},
                {
                    "margin": 5,
                    "cols": [
                        {},
                        { view:"button", id:"save-slot-btn", type:"form", value: "Сохранить", click:function(){
                            var data = $$('slot-form').getValues(), that = this;
                            if ($$("slot-form").validate()) {
                                record.save("/admin/index.php/part_shops/act_createslot", data, function(res){
                                    if (!res.error || res.error.length == 0) {
                                        that.getTopParentView().hide();
                                        grid.refresh($$('grid-slot'), "/admin/index.php/part_shops/act_getslots/id_"+data.shop_id);
                                    }
                                });
                            }
                        }},
                        { view:"button", value:"Отмена", click:function(){
                            this.getTopParentView().hide(); //hide window
                        }}
                    ]
                }
            ]}
            ]
        }
    }

    return {
        setData:_setData,
        $ui:form
    };

});