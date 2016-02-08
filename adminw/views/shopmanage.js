define(['helpers/record', 'helpers/grid', 'views/forms/slotgen', 'views/forms/seller', 'views/forms/slot'],
    function(record, grid, slotgen, seller, slot){

    var data = "", aSellersJson=[];

    var options = {
        translated: [],
        urls: {
            get: "/admin/index.php/part_shops/act_getslots/id_"+data.shop_id,
            getsellers: "/admin/index.php/part_shops/act_getsellers/id_"+data.shop_id,
            load: "/admin/index.php/part_shops/act_loadslot",
            destroy: "/admin/index.php/part_shops/act_destroyslot/id_"+data.shop_id,
            update: "/admin/index.php/part_shops/act_createslot/id_"+data.shop_id,
            create: "/admin/index.php/part_shops/act_createslot/id_"+data.shop_id,
            todraft: "/admin/index.php/part_shops/act_todraft/id_"+data.shop_id,
            tofree: "/admin/index.php/part_shops/act_tofree/id_"+data.shop_id,
            brandsIn: "/admin/index.php/part_brands/act_get/suggest_1/count_1000/?sort[title]=asc&shopIn="+data.shop_id,
            brandsOut: "/admin/index.php/part_brands/act_get/suggest_1/count_1000/?sort[title]=asc&shopOut="+data.shop_id
        },
        id: 'shop_slot_id'
    };

    var optionsSeller = {
        translated: [],
        urls: {
            get: "/admin/index.php/part_shops/act_getsellers/id_"+data.shop_id,
            load: "/admin/index.php/part_shops/act_loadseller",
            destroy: "/admin/index.php/part_shops/act_destroyseller/id_"+data.shop_id,
            update: "/admin/index.php/part_shops/act_createseller/id_"+data.shop_id,
            create: "/admin/index.php/part_shops/act_createseller/id_"+data.shop_id
        },
        id: 'account_id'
    };

    function getSellers() {
        var sellers = [];
        var dtable =  $$('sellerGrid');
        if (dtable) {
            dtable.eachRow(
                function (row){
                    var item =  dtable.getItem(row);
                    sellers.push({id:item.account_id, value:item.fname});
                }
            );
        }
        return sellers;
    }

    function setStatus(grid, status) {
        var sel = $$('slotsGrid').getSelectedId(true)
        webix.confirm({
            text:"Вы уверены что хотите сменить статус "+sel.length+" слотов в "+status+"?", ok:"Да", cancel:"Отмена",
            callback:function(res){
                if(res) {
                    var slots = [];
                    for (var i in sel)
                        slots.push(getSelField(grid, 'shop_slot_id', i));
                    webix.ajax().post(options.urls['to'+status], {slots:slots.join(',')}, {
                        success: function(text, data){
                            data = data.json()
                            if (data.error && data.error!="")
                                webix.message({type: "error", text: data.error});
                            else
                                webix.message("Слоты успешно изменили статус на "+status);
                            grid.clearSelection();
                            grid.clearAll();
                            grid.load(options.urls.get);
                        }
                    });
                    return false;
                }
            }
        });
    }

    function saveItemForm(form, grid, options, cb) {
        if (form.validate()){
            var data = form.getValues();
            if (options.images)
                data.images = options.images;
            var that = this;
            webix.ajax().post(options.urls.create, data, {
                success: function(text, data){
                    data = data.json()
                    if (data.error && data.error.length>0) {
                        webix.message({ type:"error", text:Array.isArray(data.error)?data.error.join("<br>"):data.error });
                    } else {
                        webix.message("Изменения сохранены");

                        if (grid) {
                            grid.clearSelection();
                            grid.clearAll();
                            grid.load(options.urls.get);
                        }
                    }
                    if (cb) cb(data);
                }
            });
        }
    }


    function getSelField(grid, id, index) {
        index = index?index:0;
        var item = grid.getItem(grid.getSelectedId(true)[index]);
        if (item) return item[id];
        return false;
    }


    function showForm(winId, node){
        //$$(winId).getBody().clear();
        $$(winId).show(node);
        $$(winId).getBody().focus();
    }

    function getDefaultLang() {
        for(var i in LANGUAGES)
            if (LANGUAGES[i].is_default == 1)
                return LANGUAGES[i];
    }


    function editNode(node, grid, options, cb){
        var id  = grid.getItem(node.row)[options.id], translated = options.translated;
        webix.ajax(options.urls.load+"?id="+id, function(text, data){
            data = data.json();
            if (data.error) {
                webix.message({type:"error", text:data.error});
                return false;
            }

            $$('formSeller').setValues({account_id:id}, true);

            if (cb) cb(data);
        });

        return false;
    };


    function removeNode(node, grid, options){
        webix.confirm({
            text:"Вы уверены?", ok:"Да", cancel:"Отмена",
            callback:function(res){
                if(res) {
                    var id  = grid.getItem(node.row)[options.id];
                    var data = {id:id};
                    webix.ajax().post(options.urls.destroy, data, {
                        success: function(text, data){
                            data = data.json()
                            if (data.error && data.error!="")
                                webix.message({type: "error", text: data.error});
                            else
                                webix.message("Объект успешно удален");
                            grid.clearSelection();
                            grid.clearAll();
                            grid.load(options.urls.get);
                        }
                    });
                    return false;
                }
            }
        });
        return false;
    };



    function _setData(item, setfields) {
        data = item; //console.log(data);

        options = {
            translated: [],
            urls: {
                get: "/admin/index.php/part_shops/act_getslots/id_"+data.shop_id,
                getsellers: "/admin/index.php/part_shops/act_getsellers/id_"+data.shop_id,
                load: "/admin/index.php/part_shops/act_loadslot",
                destroy: "/admin/index.php/part_shops/act_destroyslot/id_"+data.shop_id,
                update: "/admin/index.php/part_shops/act_createslot/id_"+data.shop_id,
                create: "/admin/index.php/part_shops/act_createslot/id_"+data.shop_id,
                todraft: "/admin/index.php/part_shops/act_todraft/id_"+data.shop_id,
                tofree: "/admin/index.php/part_shops/act_tofree/id_"+data.shop_id,
                brandsIn: "/admin/index.php/part_brands/act_get/suggest_1/count_1000/?sort[title]=asc&shopIn="+data.shop_id,
                brandsOut: "/admin/index.php/part_brands/act_get/suggest_1/count_1000/?sort[title]=asc&shopOut="+data.shop_id
            },
            id: 'shop_slot_id'
        };

        optionsSeller = {
            translated: [],
            urls: {
                get: "/admin/index.php/part_shops/act_getsellers/id_"+data.shop_id,
                load: "/admin/index.php/part_shops/act_loadseller",
                destroy: "/admin/index.php/part_shops/act_destroyseller/id_"+data.shop_id,
                update: "/admin/index.php/part_shops/act_createseller/id_"+data.shop_id,
                create: "/admin/index.php/part_shops/act_createseller/id_"+data.shop_id
            },
            id: 'account_id'
        };

        if (setfields) {
                $$('open_time0').setValue(item.open_time && item.open_time[0] ? item.open_time[0] : '');
                $$('open_time1').setValue(item.open_time && item.open_time[1] ? item.open_time[1] : '');
                $$('open_time2').setValue(item.open_time && item.open_time[2] ? item.open_time[2] : '');
                $$('open_time3').setValue(item.open_time && item.open_time[3] ? item.open_time[3] : '');
                $$('open_time4').setValue(item.open_time && item.open_time[4] ? item.open_time[4] : '');
                $$('open_time5').setValue(item.open_time && item.open_time[5] ? item.open_time[5] : '');
                $$('open_time6').setValue(item.open_time && item.open_time[6] ? item.open_time[6] : '');
                $$('sellerGrid').define('url', options.urls.getsellers);
                $$('slotsGrid').define('url', options.urls.get);
                $$('listAllBrands').define('url', options.urls.brandsOut);
                $$('listShopBrands').define('url', options.urls.brandsIn);
        }
    }

    var buttons = {
        view:"toolbar", elements:[
            { view:"button", width:100, value:"Добавить",  click:function(){
                $$('formSlot').setValues({shop_slot_id:0}, true);
                $$('time_from_slot').setValue('');
                $$('time_to_slot').setValue('');
                $$('seller_id_slot').define("options", getSellers());
                $$('seller_id_slot').setValue(0);
                $$('status_slot').setValue('free');
                slot.setData(data);
                showForm("win1", this.$view);
            }},
            { view:"button", width:100, disabled:true, value:"Изменить", id:"editBtn", click:function(){
                editNode($$('slotsGrid').getSelectedId(true)[0], $$('slotsGrid'), options, function(item){
                    $$('formSlot').setValues({shop_slot_id:getSelField($$('slotsGrid'), 'shop_slot_id')}, true);
                    $$('time_from_slot').setValue(item.time_from ? item.time_from : '');
                    $$('time_to_slot').setValue(item.time_to ? item.time_to : '');
                    $$('seller_id_slot').define("options", getSellers());
                    $$('seller_id_slot').setValue(item.seller_id);
                    $$('status_slot').setValue(item.status);
                    slot.setData(data);
                    showForm("win1", $$('editBtn').$view);
                });

            }}, { view:"button", width:100, disabled:true, value:"Удалить", id:"delBtn",  click:function(){
                removeNode($$('slotsGrid').getSelectedId(true)[0], $$('slotsGrid'), options);
            }}, { view:"button", width:130, disabled:true, value:"Статус -> draft", id:"toDraftBtn",  click:function(){
                setStatus($$('slotsGrid'), 'draft');
            }}, { view:"button", width:130, disabled:true, value:"Статус -> free", id:"toFreeBtn",  click:function(){
                setStatus($$('slotsGrid'), 'free');
            }},
            {},
            { view:"button", width:80, value:"Обновить", click:function(){
                var griItem = $$('slotsGrid');
                griItem.clearSelection();
                griItem.clearAll();
                griItem.load(options.urls.get);
            }}
        ]
    };
    var buttonsS = {
        view:"toolbar", elements:[
            { view:"button", width:100, value:"Добавить",  click:function(){
                $$('formSeller').setValues({account_id:0}, true);
                $$('formSeller').clearValidation();
                $$('doclist').clearAll();
                $$('image').setValues({src:null});
                $$('doclist').clearAll();
                $$('fname').setValue('');
                $$('email').setValue('');
                $$('pass').setValue(null);
                $$('pass_confirm').setValue(null);
                $$('pass').define("required", true);
                $$('pass_confirm').define("required", true);
                seller.setData(data);
                showForm("winSeller", this.$view);
            }},
            { view:"button", width:100, disabled:true, value:"Изменить", id:"editBtnS", click:function(){
                editNode($$('sellerGrid').getSelectedId(true)[0], $$('sellerGrid'), optionsSeller, function(item){
                    $$('formSeller').setValues({account_id:getSelField($$('sellerGrid'), 'account_id')}, true);
                    $$('formSeller').clearValidation();
                    $$('doclist').clearAll();
                    $$('image').setValues({src:item.image && item.image!=""?('/images/account/'+item.image):null});
                    $$('fname').setValue(item.fname);
                    $$('email').setValue(item.email);
                    $$('pass').setValue(null);
                    $$('pass_confirm').setValue(null);
                    $$('pass').define("required", false);
                    $$('pass_confirm').define("required", false);
                    seller.setData(data);
                    showForm("winSeller", $$("editBtnS").$view);
                });

            }}, { view:"button", width:100, disabled:true, value:"Удалить", id:"delBtnS",  click:function(){
                removeNode($$('sellerGrid').getSelectedId(true)[0], $$('sellerGrid'), optionsSeller);
            }}, { view:"button", width:150, /*disabled:true,*/ value:"Генерация слотов", id:"genBtnS",  click:function(){
                var id  = getSelField($$('sellerGrid'), 'account_id');
                $$('seller_id_gen').define("options", getSellers());
                $$('seller_id_gen').setValue(id);
                slotgen.setData(data);
                showForm("winGen", this.$view);
            }},
            {},
            { view:"button", width:80, value:"Обновить", click:function(){
                var griItem = $$('sellerGrid');
                griItem.clearSelection();
                griItem.clearAll();
                griItem.load(optionsSeller.urls.get);
            }}
        ]
    };


    var form = { view:"form", id:"shop-form", elements:[

                {
                    "id": "tabbar",
                    "view": "tabbar",
                    "multiview": true,
                    /*"animate": {
                        "type": "flip",
                        "subtype": "vertical"
                    },*/
                    "options": [
                        {
                            "id": "tab1",
                            "value": "Расписание"
                        },
                        {
                            "id": "tab2",
                            "value": "Шопперы"
                        },
                        {
                            "id": "tab3",
                            "value": "Слоты"
                        },
                        {
                            "id": "tab4",
                            "value": "Бренды"
                        }
                    ]
                },

                {
                    "cells": [
                        {
                            "id": "tab1",
                            "rows": [
                                {cols:[
                                    {view:"text", name:"open_time[0]", id:"open_time0", placeholder:"Пн" },
                                    {view:"text", name:"open_time[1]", id:"open_time1", placeholder:"Вт" },
                                    {view:"text", name:"open_time[2]", id:"open_time2", placeholder:"Ср" },
                                    {view:"text", name:"open_time[3]", id:"open_time3", placeholder:"Чт"},
                                    {view:"text", name:"open_time[4]", id:"open_time4", placeholder:"Пт" },
                                    {view:"text", name:"open_time[5]", id:"open_time5", placeholder:"Сб" },
                                    {view:"text", name:"open_time[6]", id:"open_time6", placeholder:"Вс" },
                                    { view:"button", width:100, type:"form", value: "Сохранить", click:function(){
                                        $$('shop-form').setValues({id:data.shop_id}, true);
                                        saveItemForm($$('shop-form'), null, {urls:{create:'/admin/index.php/part_shops/act_create'}});
                                    }}
                                ]}
                            ],
                            "show": true
                        },
                        {
                            "id": "tab2",
                            "rows": [
                                {cols:[

                                    {rows:[buttonsS,{
                                        id: "sellerGrid",
                                        view:"datatable",
                                        columns:[
                                            { id:"fname",	sort:"text", header:"Имя", width:300},
                                            { id:"email",	sort:"text", header:"Email", width:200},
                                            { id:"phone",	sort:"text", header:"Phone", width:210}
                                        ],
                                        select:"row",
                                        height:375,
                                        width:'100%',
                                        on:{
                                            onSelectChange:function(){
                                                var sel = this.getSelectedId(true);
                                                if (sel.length > 0) {
                                                    $$('editBtnS').enable();
                                                    $$('delBtnS').enable();
                                                    //  $$('genBtnS').enable();
                                                } else {
                                                    $$('editBtnS').disable();
                                                    $$('delBtnS').disable();
                                                    // $$('genBtnS').disable();
                                                }
                                            }
                                        }//,
                                       // url:options.urls.getsellers
                                    }]}

                                ]}
                            ],
                            "show": false
                        },
                        {
                            "id": "tab3",
                            "rows": [
                                {cols:[

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
                                            { id:"ch1", header:{ content:"masterCheckbox" }, template:"{common.checkbox()}", width:40},
                                            { id:"seller",	sort:"text", header:["Шоппер", {content:"selectFilter"}], width:250},
                                            { id:"time_from", sort:"int",	header:["Дата начала", {content:"datepickerFilter"}] , width:150, format:webix.Date.dateToStr("%d.%m.%y %H:%i")},
                                            { id:"time_to", sort:"int",	header:["Дата конца", {content:"datepickerFilter"}], 	width:150, format:webix.Date.dateToStr("%d.%m.%y %H:%i")},
                                            { id:"status",	sort:"text",	header:["Статус", {content:"selectFilter"}], 	width:100}
                                        ],
                                        select:"row",
                                        multiselect:true,
                                        checkboxRefresh:true,
                                        height:375,
                                        width:'100%',
                                        on:{
                                            onSelectChange:function(){
                                                var sel = this.getSelectedId(true);
                                                if (sel.length > 0) {
                                                    $$('editBtn').enable();
                                                    $$('delBtn').enable();
                                                    $$('toDraftBtn').enable();
                                                    $$('toFreeBtn').enable();
                                                } else {
                                                    $$('editBtn').disable();
                                                    $$('delBtn').disable();
                                                    $$('toDraftBtn').disable();
                                                    $$('toFreeBtn').disable();
                                                }


                                                for(var i in sel) {

                                                }
                                            },
                                            onCheck: function(row, column, state){
                                                if (state == 1)
                                                    this.select(row, true);
                                                else
                                                    this.unselect(row, true);
                                            },
                                            onItemClick:function(id){
                                                if (this.getItem(id.row).ch1 != 1) {
                                                    this.getItem(id.row).ch1 = 1;
                                                    this.refresh(id.row);
                                                }
                                            }
                                        }//,
                                       // url:options.urls.get
                                    }]}

                                ]}
                            ],
                            "show": false
                        },
                        {
                            "id": "tab4",
                            "rows": [
                                {cols:[

                                    {rows:[
                                        {
                                            height: 35,
                                            view:"toolbar",
                                            elements:[
                                                {view:"text", id:"listAllBrandsFilter",label:"Нет в магазине",css:"fltr", labelWidth:130
                                                    ,
                                                    on: {
                                                        onTimedKeyPress:function(){
                                                            var value = this.getValue().toLowerCase();
                                                            $$("listAllBrands").filter(function(obj){
                                                                return obj.value.toLowerCase().indexOf(value)!=-1;
                                                            });
                                                        }
                                                    }}
                                            ]
                                        },
                                        {

                                            view:"list",
                                            id:"listAllBrands",
                                            template:"#value#",
                                            select:"multiselect",
                                            multiselect:true,
                                           // url: options.urls.brandsOut,
                                            drag:true,
                                            on: {
                                                onBeforeDrop: function(context, ev){
                                                    webix.ajax().post("/admin/index.php/part_brands/act_brand2shop/remove_1", {id:context.source.join(','), shop_id:data.shop_id}, {
                                                        success: function(text, data){
                                                            data = data.json()
                                                            if (data.error && data.error!="")
                                                                webix.message({type: "error", text: data.error});
                                                            else
                                                                webix.message("Бренды успешно удалены из магазина");
                                                        }
                                                    });
                                                    return true;
                                                }
                                            }
                                        }
                                    ]}

                                    ,

                                    {rows:[
                                        {
                                            height: 35,
                                            view:"toolbar",
                                            elements:[
                                                {view:"text", id:"listShopBrandsFilter",label:"Бренды магазина",css:"fltr", labelWidth:130
                                                    ,
                                                    on: {
                                                        onTimedKeyPress:function(){
                                                            var value = this.getValue().toLowerCase();
                                                            $$("listShopBrands").filter(function(obj){
                                                                return obj.value.toLowerCase().indexOf(value)!=-1;
                                                            });
                                                        }
                                                    }}
                                            ]
                                        },
                                        {

                                            view:"list",
                                            id:"listShopBrands",
                                            template:"#value#",
                                            select:"multiselect",
                                            multiselect:true,
                                           // url: options.urls.brandsIn,
                                            drag:true,
                                            on: {
                                                onBeforeDrop: function(context, ev){
                                                    webix.ajax().post("/admin/index.php/part_brands/act_brand2shop/add_1", {id:context.source.join(','), shop_id:data.shop_id}, {
                                                        success: function(text, data){
                                                            data = data.json()
                                                            if (data.error && data.error!="")
                                                                webix.message({type: "error", text: data.error});
                                                            else
                                                                webix.message("Бренды успешно добавлены в магазин");
                                                        }
                                                    });
                                                    return true;
                                                }
                                            }
                                        }
                                    ]}



                                ]}
                            ],
                            "show": false
                        }
                    ]
                }

        ]
        }
    ;

    webix.ui({
        view:"popup",
        id:"winGen",
        width:400,
        head:false,
        body:slotgen.$ui
    });


    webix.ui({
        view:"popup",
        id:"winSeller",
        width:600,
        head:false,
        body:seller.$ui
    });


    webix.ui({
        view:"popup",
        id:"win1",
        width:500,
        head:false,
        body:slot.$ui
    });


    /*return {
        setData:_setData,
		$ui:form
	};*/

        var layout = {
            type: "space",
            rows:[
               /* {
                    height:40,
                    cols:controls
                },*/
                {
                    rows:[
                        form,
                        {
                            view: "toolbar",
                            css: "highlighted_header header6",
                            paddingX:5,
                            paddingY:5,
                            height:40,
                            cols:[{
                                view:"pager", id:"pagerA",
                                template:"{common.first()}{common.prev()}&nbsp; {common.pages()}&nbsp; {common.next()}{common.last()}",
                                autosize:true,
                                height: 35,
                                group:5
                            }

                            ]
                        }
                    ]
                }



            ]

        };

        return {
            $ui: layout,
            $oninit:function(app, config){
                var id = window.location.hash.substr(1).match(/shopmanage\/([0-9]+)/)[1];
                $$('app:menu').unselectAll();

                record.load('/admin/index.php/part_shops/act_load?id='+id, function(data) {
                    $$('title').data = {title: data.title[1], details: "Управление магазином"};
                    $$('title').refresh();
                    _setData(data, true);
                    var  parentFilterByAll = $$('slotsGrid').filterByAll;
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
                });
            }
        };

});