define(['helpers/progress', 'helpers/record'], function(p, r){
    var data = {};
	return {
        setData: function(d, setitems){
            data = d;
            if (setitems) {
                $$('seller_id_gen').define("options", {body:{url: '/admin/index.php/part_accounts/act_get/?shop_id='+data.shop_id+'&continue=true&sort[fname]=asc&suggest=1'}});
            }
        },
		$ui:{
            id: "formGen",
            view:"window", modal:true, id:"slotsgen-win", position:"center", width:600,
            head:"Генерация слотов",
            body:{
                paddingY:20, paddingX:30, elementsConfig:{labelWidth: 140}, view:"form", id:"slotsgen-form",
                elements: [ {rows : [
               // {view:"select", label:"Шоппер", name:"seller_id", id:"seller_id_gen", placeholder:"Шоппер", value:0, options:[] },
                {label:"Шоппер", name:"seller_id", id:"seller_id_gen", value:0,  view:"richselect", options:{
                    body:{
                       url: '/admin/index.php/part_accounts/act_get/?shop_id='+data.shop_id+'&continue=true&sort[fname]=asc&suggest=1'
                    }
                }
                },
                {cols:[
                    {view:"datepicker", name:"time_from", id:"time_from_gen", placeholder:"Начало", value:new Date() },
                    {view:"datepicker", name:"time_to", id:"time_to_gen", placeholder:"Конец", value:new Date(((new Date()).setDate((new Date()).getDate()+1))) }
                ]},
                {view:"checkbox", name:"publish", label:"Опубликовать"},
                { margin:5, cols:[
                    {},
                    { view:"button", width:130, type:"form", value: "Генерировать", click:function(){
                        var that = this;
                        p.show('slotsgen-form');
                        r.post("/admin/index.php/part_shops/act_genslots?id="+data.shop_id, $$('slotsgen-form').getValues(), function(item){
                            p.hide('slotsgen-form');
                            if (!item.error) {
                                webix.message({text: "Генерация слотов прошла успешно"});
                                that.getTopParentView().hide(); //hide window
                            }
                        });
                    }},
                    { view:"button", width:100,  value:"Отмена", click:function(){
                        this.getTopParentView().hide(); //hide window
                    }}
                ]}
            ]}
                ]
            }
        }
	};

});