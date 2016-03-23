define([
    "views/forms/seller2",
    "helpers/grid",
    "helpers/record",
    'views/forms/slotgen2'
], function(accountform, grid, record, slotgen){

    var data = {};
    function _setData(item, setfields) {
        data = item;
        if (setfields) {
            $$('grid-seller').define('url', '/admin/index.php/part_accounts/act_get/?shop_id='+data.shop_id)
        }
    }


    var controls = [
        { view: "button", id:'addBtn', type: "iconButton", icon: "plus", label: "Добавить", width: 120, click: function(){
            var ui = this.$scope.ui(accountform.$ui);
            accountform.setData({account_id:0, shop_id:data.shop_id, status:'seller'});
            ui.show();
        }},
        { view: "button", id:'account-edit-btn', disabled:true, type: "iconButton", icon: "pencil", label: "Редактировать", width: 150, click: function(){
            var grid = $$('grid-seller'), selId = grid.getSelectedId(), that=this;
            if (selId) {
                var id = grid.getItem(selId)['account_id'];
                record.load('/admin/index.php/part_accounts/act_load?id='+id, function(data){
                    var ui = that.$scope.ui(accountform.$ui);
                    accountform.setData(data, true);
                    ui.show();
                });
            }
        }},{ view: "button", id:'account-del-btn', disabled:true, type: "iconButton", icon: "trash", label: "Удалить", width: 120, click: function(){
            var gridItem = $$('grid-seller'), selId = gridItem.getSelectedId(), that=this;
            if (selId) {
                var id = gridItem.getItem(selId)['account_id'];
                record.remove("/admin/index.php/part_accounts/act_destroy", {id:id}, function(data){
                    grid.refresh($$('grid-seller'), '/admin/index.php/part_accounts/act_get/?shop_id='+data.shop_id);
                });
            }
        }},{ view: "button", id:'account-slots-btn', type: "iconButton", icon: "", label: "Генерация слотов", width: 200, click: function(){
            slotgen.setData(data);
            var ui = this.$scope.ui(slotgen.$ui);
            slotgen.setData(data, true);
            ui.show();
        }},
        {},
        { view: "icon", icon: "refresh",width: 40 , click: function(){
            grid.refresh($$('grid-seller'), '/admin/index.php/part_accounts/act_get/?shop_id='+data.shop_id);
        }}
    ];

    var gridseller = {
        margin:10,
        rows:[
            {
                id:"grid-seller",
                view:"datatable",
                columns:[
                    {id:"account_id", header:"ID", width:60, sort:"server" },
                    {id:"fname", header:["Имя", {content:"serverFilter"}], width:200, sort:"server"},
                    {id:"email", header:["Email", {content:"serverFilter"}], width:200, sort:"server"},
                    {id:"phone", header:["Телефон", {content:"serverFilter"}], width:200, sort:"server"}
                ],
                select:"row",
                pager:"pagerA",
                on:{
                    onSelectChange: function () {
                        var sel = this.getSelectedId(true);
                        if (sel.length > 0) {
                            $$('account-edit-btn').enable();
                            $$('account-del-btn').enable();
                        } else {
                            $$('account-edit-btn').disable();
                            $$('account-del-btn').disable();
                        }
                    }
                }//,
                //url:'/admin/index.php/part_accounts/act_get'
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
                    gridseller,
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
            var id = window.location.hash.substr(1).match(/sellers\/([0-9]+)/)[1];
            if (!id) {document.location = "/adminw/";return;}
            record.load('/admin/index.php/part_shops/act_load?id='+id, function(data) {
                $$('title').data = {title: data.title[1], details: "Шопперы"};
                $$('title').refresh();
                _setData(data, true);
            });
        }
    };

});