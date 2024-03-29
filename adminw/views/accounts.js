define([
    "views/forms/account",
    "helpers/grid",
    "helpers/record"
], function(accountform, grid, record){

    var controls = [
        { view: "button", id:'addBtn', type: "iconButton", icon: "plus", label: "Добавить", width: 120, click: function(){
            var ui = this.$scope.ui(accountform.$ui);
            accountform.setData({account_id:0});
            ui.show();
        }},
        { view: "button", id:'account-edit-btn', disabled:true, type: "iconButton", icon: "pencil", label: "Редактировать", width: 150, click: function(){
            var grid = $$('grid-account'), selId = grid.getSelectedId(), that=this;
            if (selId) {
                var id = grid.getItem(selId)['account_id'];
                record.load('/admin/index.php/part_accounts/act_load?id='+id, function(data){
                    var ui = that.$scope.ui(accountform.$ui);
                    accountform.setData(data);
                    ui.show();
                });
            }
        }},{ view: "button", id:'account-del-btn', disabled:true, type: "iconButton", icon: "trash", label: "Удалить", width: 120, click: function(){
            var gridItem = $$('grid-account'), selId = gridItem.getSelectedId(), that=this;
            if (selId) {
                var id = gridItem.getItem(selId)['account_id'];
                record.remove("/admin/index.php/part_accounts/act_destroy", {id:id}, function(data){
                    grid.refresh($$('grid-account'), '/admin/index.php/part_accounts/act_get');
                });
            }
        }},
        {},
        { view: "icon", icon: "refresh",width: 40 , click: function(){
            grid.refresh($$('grid-account'), '/admin/index.php/part_accounts/act_get');
        }}
    ];

    var gridaccount = {
        margin:10,
        rows:[
            {
                id:"grid-account",
                view:"datatable",
                columns:[
                    {id:"account_id", header:"ID", width:60, sort:"server" },
                    {id:"fname", header:["Имя", {content:"serverFilter"}], width:200, sort:"server"},
                    {id:"email", header:["Email", {content:"serverFilter"}], width:200, sort:"server"},
                    {id:"phone", header:["Телефон", {content:"serverFilter"}], width:200, sort:"server"},
                    {id:"status", header:["Статус", {content:"selectFilter"}], width:200, sort:"server"},
                    { id:"cdate", sort:"int",	header:["Дата создания", {content:"datepickerFilter"}] , width:150, format:webix.Date.dateToStr("%d.%m.%y %H:%i"), sort:"server"}
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
                },
                url:'/admin/index.php/part_accounts/act_get'
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
                    gridaccount,
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