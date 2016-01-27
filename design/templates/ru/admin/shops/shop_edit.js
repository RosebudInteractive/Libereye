webix.ready(function(){

    var options = {
        translated: [],
        urls: {
            get: "/admin/index.php/part_shops/act_getslots/id_"+aShopJson.shop_id,
            getsellers: "/admin/index.php/part_shops/act_getsellers/id_"+aShopJson.shop_id,
            load: "/admin/index.php/part_shops/act_loadslot",
            destroy: "/admin/index.php/part_shops/act_destroyslot",
            update: "/admin/index.php/part_shops/act_createslot",
            create: "/admin/index.php/part_shops/act_createslot"
        },
        id: 'shop_slot_id'
    };


    function getSellers() {
        var sellers = [];
        for(var i in aSellersJson)
            sellers.push({id:i, value:aSellersJson[i]});
        return sellers;
    }

    var buttons = {
        view:"toolbar", elements:[
            { view:"button", width:100, value:"Добавить",  click:function(){
                $$('form').setValues({id:0}, true);
                $$('time_from_slot').setValue('');
                $$('time_to_slot').setValue('');
                $$('seller_id_slot').define("options", getSellers());
                $$('seller_id_slot').setValue(0);
                $$('status_slot').setValue('free');
                showForm("win1", this.$view);
            }},
            { view:"button", width:100, disabled:true, value:"Изменить", id:"editBtn", click:function(){
                editNode(slotGrid.getSelectedId(true)[0], $$("editBtn").$view, slotGrid, options, function(item){
                    $$('time_from_slot').setValue(item.time_from ? item.time_from : '');
                    $$('time_to_slot').setValue(item.time_to ? item.time_to : '');
                    $$('seller_id_slot').define("options", getSellers());
                    $$('seller_id_slot').setValue(item.seller_id);
                    $$('status_slot').setValue(item.status);
                });

            }}, { view:"button", width:100, disabled:true, value:"Удалить", id:"delBtn",  click:function(){
                removeNode(slotGrid.getSelectedId(true)[0], slotGrid, options);
            }},
            {},
            { view:"button", width:80, value:"Обновить", click:function(){
                var griItem = slotGrid;
                griItem.clearSelection();
                griItem.clearAll();
                griItem.load(options.urls.get);
            }}
        ]
    };
    var buttonsS = {
        view:"toolbar", elements:[
            { view:"button", width:100, value:"Добавить",  click:function(){
                $$('form2').setValues({id:0}, true);

                showForm("win1", this.$view);
            }},
            { view:"button", width:100, disabled:true, value:"Изменить", id:"editBtnS", click:function(){
                editNode(slotGrid.getSelectedId(true)[0], $$("editBtn").$view, slotGrid, options, function(item){

                });

            }}, { view:"button", width:100, disabled:true, value:"Удалить", id:"delBtnS",  click:function(){
                removeNode(slotGrid.getSelectedId(true)[0], slotGrid, options);
            }},
            {},
            { view:"button", width:80, value:"Обновить", click:function(){
                var griItem = $$('sellerGrid');
                griItem.clearSelection();
                griItem.clearAll();
                griItem.load(options.urls.getsellers);
            }}
        ]
    };

    var form = {
        id: "form",
        view:"form",
        width:870,
        //borderless:true,
        elements: [ {rows : [
            {cols:[
                {template:'Расписание:<br><small>10:00-19:00</small>', width:100, height:43, borderless:true},
                {view:"text", name:"open_time[0]", id:"open_time0", placeholder:"Пн" },
                {view:"text", name:"open_time[1]", id:"open_time1", placeholder:"Вт" },
                {view:"text", name:"open_time[2]", id:"open_time2", placeholder:"Ср" },
                {view:"text", name:"open_time[3]", id:"open_time3", placeholder:"Чт"},
                {view:"text", name:"open_time[4]", id:"open_time4", placeholder:"Пт" },
                {view:"text", name:"open_time[5]", id:"open_time5", placeholder:"Сб" },
                {view:"text", name:"open_time[6]", id:"open_time6", placeholder:"Вс" }
            ]},
            {},
            {cols:[
                {template:'Шопперы:', width:100, height:43, borderless:true},
                {rows:[buttonsS,{
                    id: "sellerGrid",
                    view:"datatable",
                    columns:[
                        { id:"seller",	sort:"text", header:["Имя", {content:"selectFilter"}], width:600}
                    ],
                    select:"row",
                    height:200,
                    width:'100%',
                    on:{
                        onSelectChange:function(){
                            var sel = this.getSelectedId(true);
                            if (sel.length > 0) {
                                $$('editBtnS').enable();
                                $$('delBtnS').enable();
                            } else {
                                $$('editBtnS').disable();
                                $$('delBtnS').disable();
                            }
                        }
                    },
                    url:options.urls.getsellers
                }]}

            ]},
            {},
            {cols:[
                {template:'Слоты:', width:100, height:43, borderless:true},
                {rows:[buttons,{
                    id: "slotsGrid",
                    view:"datatable",
                    scheme:{
                        $init:function(obj){
                            obj.time_from = new Date(obj.time_from);
                            obj.time_to = new Date(obj.time_to);
                        }
                    },
                    columns:[
                        //{ id:"id",	header:"", css:"id", width:50},
                        { id:"seller",	sort:"text", header:["Шоппер", {content:"selectFilter"}], width:250},
                        { id:"time_from", sort:"int",	header:["Дата начала", {content:"datepickerFilter"}] , width:180, format:webix.Date.dateToStr("%d.%m.%y %H:%i")},
                        { id:"time_to", sort:"int",	header:["Дата конца", {content:"datepickerFilter"}], 	width:180, format:webix.Date.dateToStr("%d.%m.%y %H:%i")},
                        { id:"status",	sort:"text",	header:["Статус", {content:"selectFilter"}], 	width:100}
                    ],
                    select:"row",
                    height:300,
                    width:'100%',
                    on:{
                        onSelectChange:function(){
                            var sel = this.getSelectedId(true);
                            if (sel.length > 0) {
                                $$('editBtn').enable();
                                $$('delBtn').enable();
                            } else {
                                $$('editBtn').disable();
                                $$('delBtn').disable();
                            }
                        }
                    },
                    url:options.urls.get
                }]}

            ]},

            { margin:5, cols:[
                {},
                { view:"button", width:100, type:"form", value: "Сохранить", click:function(){
                    var that = this;
                    $$("files").send(function(){ //sending files
                        var images = [];
                        $$("files").files.data.each(function(obj){
                            var status = obj.status;
                            if(status=='server' && obj.id!="0") {
                                images.push(obj.id);
                            }
                        });
                        options.images = images.join(',');
                        saveItem.apply(that, [options]);
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
    };


    var formSlot = {
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
    };



    var formObj = webix.ui({
        container:"shop_edit_form",
        rows:[
           form
        ]
    });

    var slotGrid = $$('slotsGrid'), parentFilterByAll = slotGrid.filterByAll;
    $$('slotsGrid').filterByAll=function(){
        //gets filter values
        var seller = this.getFilter("seller").value;
        var time_from = this.getFilter("time_from").getValue();
        var time_to = this.getFilter("time_to").getValue();
        var status = this.getFilter("status").value;

        //unfilter if values was not selected
        if (!seller && !status && !time_from && !time_to) return this.filter();

        //filter using or logic
        this.filter(function(obj){
            var state = true;
            if (seller && seller!=obj.seller) state=false;
            if (status && status!=obj.status) state=false;
            if (time_from && time_to) {
                    if (obj.time_from.getFullYear()+''+obj.time_from.getMonth()+''+obj.time_from.getDate() != time_from.getFullYear()+''+time_from.getMonth()+''+time_from.getDate() ||
                        obj.time_to.getFullYear()+''+obj.time_to.getMonth()+''+obj.time_to.getDate() != time_to.getFullYear()+''+time_to.getMonth()+''+time_to.getDate()) state=false;
            } else if (time_from) {
                if (obj.time_from.getFullYear()+''+obj.time_from.getMonth()+''+obj.time_from.getDate() != time_from.getFullYear()+''+time_from.getMonth()+''+time_from.getDate()) state=false;
            } else if (time_to) {
                if (obj.time_to.getFullYear()+''+obj.time_to.getMonth()+''+obj.time_to.getDate() != time_to.getFullYear()+''+time_to.getMonth()+''+time_to.getDate()) state=false;
            }
            return state;
        });


    };

    webix.ui({
        view:"popup",
        id:"win1",
        width:870,
        head:false,
        body:formSlot
    });

    loadItem("/admin/index.php/part_shops/act_load?id="+aShopJson.shop_id, options, function(item){
        $$('open_time0').setValue(item.open_time && item.open_time[0] ? item.open_time[0] : '');
        $$('open_time1').setValue(item.open_time && item.open_time[1] ? item.open_time[1] : '');
        $$('open_time2').setValue(item.open_time && item.open_time[2] ? item.open_time[2] : '');
        $$('open_time3').setValue(item.open_time && item.open_time[3] ? item.open_time[3] : '');
        $$('open_time4').setValue(item.open_time && item.open_time[4] ? item.open_time[4] : '');
        $$('open_time5').setValue(item.open_time && item.open_time[5] ? item.open_time[5] : '');
        $$('open_time6').setValue(item.open_time && item.open_time[6] ? item.open_time[6] : '');
    });
});