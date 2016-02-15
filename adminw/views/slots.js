define([
    "views/forms/slot2",
    "helpers/grid",
    "helpers/record"
], function(slotform, grid, record){

    var data = {};
    function _setData(item, setfields) {
        data = item;
        if (setfields) {
            $$('grid-slot').define('url', "/admin/index.php/part_shops/act_getslots/id_"+data.shop_id);
        }
    }

    function setStatus(grid, status) {
        var options = {
            urls: {
                get: "/admin/index.php/part_shops/act_getslots/id_"+data.shop_id,
                todraft: "/admin/index.php/part_shops/act_todraft/id_"+data.shop_id,
                tofree: "/admin/index.php/part_shops/act_tofree/id_"+data.shop_id
            }
        };

        var sel = $$('grid-slot').getSelectedId(true)
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

    function getSelField(grid, id, index) {
        index = index?index:0;
        var item = grid.getItem(grid.getSelectedId(true)[index]);
        if (item) return item[id];
        return false;
    }

    var controls = [
        { view: "button", id:'addBtn', type: "iconButton", icon: "plus", label: "Добавить", width: 120, click: function(){
            var ui = this.$scope.ui(slotform.$ui);
            slotform.setData({shop_slot_id:0, shop_id:data.shop_id},true);
            ui.show();
        }},
        { view: "button", id:'slot-edit-btn', disabled:true, type: "iconButton", icon: "pencil", label: "Редактировать", width: 150, click: function(){
            var grid = $$('grid-slot'), selId = grid.getSelectedId(), that=this;
            if (selId) {
                var id = grid.getItem(selId)['shop_slot_id'];
                record.load('/admin/index.php/part_shops/act_loadslot?id='+id, function(data){
                    var ui = that.$scope.ui(slotform.$ui);
                    slotform.setData(data,true);
                    ui.show();
                });
            }
        }},{ view: "button", id:'slot-del-btn', disabled:true, type: "iconButton", icon: "trash", label: "Удалить", width: 120, click: function(){
            var gridItem = $$('grid-slot'), selId = gridItem.getSelectedId(), that=this;
            if (selId) {
                var id = gridItem.getItem(selId)['shop_slot_id'];
                record.remove("/admin/index.php/part_shops/act_destroyslot", {id:id}, function(data){
                    grid.refresh($$('grid-slot'), "/admin/index.php/part_shops/act_getslots/id_"+data.shop_id);
                });
            }
        }}, { view:"button", width:130, disabled:true, value:"Статус -> draft", id:"toDraftBtn",  click:function(){
            setStatus($$('grid-slot'), 'draft');
        }}, { view:"button", width:130, disabled:true, value:"Статус -> free", id:"toFreeBtn",  click:function(){
            setStatus($$('grid-slot'), 'free');
        }},
        {},
        { view: "icon", icon: "refresh",width: 40 , click: function(){
            grid.refresh($$('grid-slot'), "/admin/index.php/part_shops/act_getslots/id_"+data.shop_id);
        }}
    ];

    var gridslot = {
        margin:10,
        rows:[
            {
                id: "grid-slot",
                view:"datatable",
                scheme:{
                    $init:function(obj){
                        obj.time_from = new Date(obj.time_from);
                        obj.time_to = new Date(obj.time_to);
                        obj.udate = new Date(obj.udate);
                    }
                },
                columns:[
                    //{ id:"id",	header:"", css:"id", width:50},
                    { id:"ch1", header:{ content:"masterCheckbox" }, template:"{common.checkbox()}", width:40},
                    { id:"seller",	sort:"text", header:["Шоппер", {content:"selectFilter"}], width:250},
                    { id:"time_from", sort:"int",	header:["Дата начала", {content:"datepickerFilter"}] , width:150, format:webix.Date.dateToStr("%d.%m.%y %H:%i")},
                    { id:"time_to", sort:"int",	header:["Дата конца", {content:"datepickerFilter"}], 	width:150, format:webix.Date.dateToStr("%d.%m.%y %H:%i")},
                    { id:"status",	sort:"text",	header:["Статус", {content:"selectFilter"}], 	width:100},
                    { id:"fname",	sort:"text", header:["Покупатель", {content:"selectFilter"}], width:250},
                    { id:"udate",	sort:"text", header:["Дата брони", {content:"datepickerFilter"}], 	width:150, format:webix.Date.dateToStr("%d.%m.%y %H:%i"),template:function(obj){
                        if (obj.status == 'booked')
                            return (webix.Date.dateToStr("%d.%m.%y %H:%i"))(obj.udate);
                        else
                            return "-";
                    }}
                ],
                select:"row",
                multiselect:true,
                checkboxRefresh:true,
                pager:"pagerA",
                on:{
                    onSelectChange:function(){
                        var sel = this.getSelectedId(true);
                        if (sel.length > 0) {
                            $$('slot-edit-btn').enable();
                            $$('slot-del-btn').enable();
                            $$('toDraftBtn').enable();
                            $$('toFreeBtn').enable();
                        } else {
                            $$('slot-edit-btn').disable();
                            $$('slot-del-btn').disable();
                            $$('toDraftBtn').disable();
                            $$('toFreeBtn').disable();
                        }
                    },
                    onCheck: function(row, column, state){
                        if (state == 1)
                            this.select(row, true);
                        else
                            this.unselect(row, true);
                    },
                    onItemClick:function(id){
                        /*if (this.getItem(id.row).ch1 != 1) {
                            this.getItem(id.row).ch1 = 1;
                            this.refresh(id.row);
                        }*/
                    }
                }//,
                // url:options.urls.get
            }
        ]

    };

    var layout = {
        type: "space",
        rows:[
            {
                height:40,
                cols:controls
            },
            {
                rows:[
                    gridslot,
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
            var id = window.location.hash.substr(1).match(/slots\/([0-9]+)/)[1];
            if (!id) {document.location = "/adminw/";return;}
            record.load('/admin/index.php/part_shops/act_load?id='+id, function(data) {
                $$('title').data = {title: data.title[1], details: "Слоты"};
                $$('title').refresh();
                _setData(data, true);
                var  parentFilterByAll = $$('grid-slot').filterByAll;
                $$('grid-slot').filterByAll=function(){
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