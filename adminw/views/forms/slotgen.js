define(['helpers/progress', 'helpers/record'], function(p, r){
    var data = {};
	return {
        setData: function(d){data = d;},
		$ui:{
            id: "formGen",
            view:"form",
            width:600, borderless:true,
            //borderless:true,
            elements: [ {rows : [
                {view:"select", label:"Шоппер", name:"seller_id", id:"seller_id_gen", placeholder:"Шоппер", value:0, options:[] },
                {cols:[
                    {view:"datepicker", name:"time_from", id:"time_from_gen", placeholder:"Начало", value:new Date() },
                    {view:"datepicker", name:"time_to", id:"time_to_gen", placeholder:"Конец", value:new Date(((new Date()).setDate((new Date()).getDate()+1))) }
                ]},
                {view:"checkbox", name:"publish", label:"Опубликовать"},
                { margin:5, cols:[
                    {},
                    { view:"button", width:130, type:"form", value: "Генерировать", click:function(){
                        var that = this;
                        p.show('formGen');
                        r.post("/admin/index.php/part_shops/act_genslots?id="+data.shop_id, $$('formGen').getValues(), function(item){
                            p.hide('formGen');
                            if (!item.error) {
                                $$('slotsGrid').clearSelection();
                                $$('slotsGrid').clearAll();
                                $$('slotsGrid').load("/admin/index.php/part_shops/act_getslots/id_"+data.shop_id);
                                that.getTopParentView().hide(); //hide window
                            }
                        });
                    }},
                    { view:"button", width:100,  value:"Отмена", click:function(){
                        this.getTopParentView().hide(); //hide window
                    }}
                ]}
            ]}
            ],
            elementsConfig:{
                labelWidth:140
            }
        }
	};

});