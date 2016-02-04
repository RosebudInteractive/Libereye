define(['helpers/progress', 'helpers/record'], function(p, r){
    var shop = {};

    function saveItemForm(form, grid, options, cb) {
        if (form.validate()){
            var postdata = form.getValues();
            if (options.images)
                postdata.images = options.images;
            var that = this;
            webix.ajax().post("/admin/index.php/part_shops/act_createslot/id_"+shop.shop_id, postdata, {
                success: function(text, data){
                    data = data.json()
                    if (data.error && data.error.length>0) {
                        webix.message({ type:"error", text:Array.isArray(data.error)?data.error.join("<br>"):data.error });
                    } else {
                        webix.message("Изменения сохранены");
                        if ( that.getTopParentView() )
                            that.getTopParentView().hide(); //hide window
                        if (grid) {
                            grid.clearSelection();
                            grid.clearAll();
                            grid.load("/admin/index.php/part_shops/act_getslots/id_"+shop.shop_id);
                        }
                    }
                    if (cb) cb(data);
                }
            });
        }
    }

	return {
        setData: function(d){shop = d;},
		$ui:{
            id: "formSlot",
            view:"form",
            width:600, borderless:true,
            //borderless:true,
            elements: [ {rows : [
                {view:"select", label:"Шоппер", name:"seller_id", id:"seller_id_slot", placeholder:"Шоппер", value:0, options:[] },
                {view:"select", label:"Статус", name:"status", id:"status_slot", placeholder:"Статус", value:'free', options:['draft', 'free', 'booked'] },
                {cols:[
                    //{template:':', width:100, borderless:true},
                    {view:"datepicker", timepicker:true, name:"time_from", id:"time_from_slot", placeholder:"Начало" },
                    {view:"datepicker", timepicker:true, name:"time_to", id:"time_to_slot", placeholder:"Конец" }
                ]},
                { margin:5, cols:[
                    {},
                    { view:"button", width:100, type:"form", value: "Сохранить", click:function(){
                        var that = this;
                        saveItemForm.apply(that, [$$('formSlot'), $$('slotsGrid'), {}]);
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