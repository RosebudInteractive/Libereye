define([
    "views/forms/shop",
    "views/forms/shopmanage",
    "helpers/grid",
    "helpers/record"
], function(shopform, shopmanage, grid, record){

    var controls = [
        { view: "button", id:'addBtn', type: "iconButton", icon: "plus", label: "Добавить", width: 120, click: function(){
            var ui = this.$scope.ui(shopform.$ui);
            shopform.setData({shop_id:0});
            ui.show();
        }},
        { view: "button", id:'shop-edit-btn', disabled:true, type: "iconButton", icon: "pencil", label: "Редактировать", width: 150, click: function(){
            var grid = $$('grid-shop'), selId = grid.getSelectedId(), that=this;
            if (selId) {
                var id = grid.getItem(selId)['shop_id'];
                record.load('/admin/index.php/part_shops/act_load?id='+id, function(data){
                    var ui = that.$scope.ui(shopform.$ui);
                    shopform.setData(data);
                    ui.show();
                });
            }
        }},{ view: "button", id:'shop-del-btn', disabled:true, type: "iconButton", icon: "trash", label: "Удалить", width: 120, click: function(){
            var gridItem = $$('grid-shop'), selId = gridItem.getSelectedId(), that=this;
            if (selId) {
                var id = gridItem.getItem(selId)['shop_id'];
                record.remove("/admin/index.php/part_shops/act_destroy", {id:id}, function(data){
                    grid.refresh($$('grid-shop'), '/admin/index.php/part_shops/act_get');
                });
            }
        }},{ view: "button", id:'shop-manage-btn', disabled:true, type: "iconButton", icon: "cog", label: "Управлять", width: 120, click: function(){
            var grid = $$('grid-shop'), selId = grid.getSelectedId(), that=this;
            if (selId) {
                var id = grid.getItem(selId)['shop_id'];
                record.load('/admin/index.php/part_shops/act_load?id='+id, function(data){
                    shopmanage.setData(data, false);
                    var ui = that.$scope.ui(shopmanage.$ui);
                    shopmanage.setData(data, true);

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


                    ui.show();

                });
            }
        }},
        {},
        { view: "icon", icon: "refresh",width: 40 , click: function(){
            grid.refresh($$('grid-shop'), '/admin/index.php/part_shops/act_get');
        }}
    ];

    var gridshop = {
        margin:10,
        rows:[
            {
                id:"grid-shop",
                view:"datatable",
                columns:[
                    {id:"shop_id", header:"ID", width:60, sort:"server" },
                    {id:"title", header:["Название", {content:"serverFilter"}], width:300, sort:"server"},
                    {id:"description",	header:["Описание", {content:"serverFilter"}], width:'100%', sort:"server"}
                ],
                select:"row",
                pager:"pagerA",
                on:{
                    onSelectChange: function () {
                        var sel = this.getSelectedId(true);
                        if (sel.length > 0) {
                            $$('shop-edit-btn').enable();
                            $$('shop-del-btn').enable();
                            $$('shop-manage-btn').enable();
                        } else {
                            $$('shop-edit-btn').disable();
                            $$('shop-del-btn').disable();
                            $$('shop-manage-btn').disable();
                        }
                    }
                },
                url:'/admin/index.php/part_shops/act_get'
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
                    gridshop,
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
        $ui: layout
    };

});