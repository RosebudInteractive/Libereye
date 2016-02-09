define([
    "views/forms/setting",
    "helpers/grid",
    "helpers/record"
], function(settingform, grid, record){

    var controls = [
        { view: "button", id:'addBtn', type: "iconButton", icon: "plus", label: "Добавить", width: 120, click: function(){
            var ui = this.$scope.ui(settingform.$ui);
            settingform.setData({id:0});
            ui.show();
        }},
        { view: "button", id:'setting-edit-btn', disabled:true, type: "iconButton", icon: "pencil", label: "Редактировать", width: 150, click: function(){
            var grid = $$('grid-setting'), selId = grid.getSelectedId(), that=this;
            if (selId) {
                var id = grid.getItem(selId)['id'];
                record.load('/admin/index.php/part_settings/act_load?id='+id, function(data){
                    var ui = that.$scope.ui(settingform.$ui);
                    settingform.setData(data);
                    ui.show();
                });
            }
        }},{ view: "button", id:'setting-del-btn', disabled:true, type: "iconButton", icon: "trash", label: "Удалить", width: 120, click: function(){
            var gridItem = $$('grid-setting'), selId = gridItem.getSelectedId(), that=this;
            if (selId) {
                var id = gridItem.getItem(selId)['id'];
                record.remove("/admin/index.php/part_settings/act_destroy", {id:id}, function(data){
                    grid.refresh($$('grid-setting'), '/admin/index.php/part_settings/act_get');
                });
            }
        }},
        {},
        { view: "icon", icon: "refresh",width: 40 , click: function(){
            grid.refresh($$('grid-setting'), '/admin/index.php/part_settings/act_get');
        }}
    ];

    var gridsetting = {
        margin:10,
        rows:[
            {
                id:"grid-setting",
                view:"datatable",
                columns:[
                    {id:"id", header:"ID", width:60, sort:"server" },
                    {id:"name",	header:["Название", {content:"serverFilter"}], width:300, sort:"server"},
                    {id:"code",	header:["Код", {content:"serverFilter"}], width:200, sort:"server"},
                    {id:"val",	header:["Значение", {content:"serverFilter"}], width:'100%', sort:"server"}
                ],
                select:"row",
                pager:"pagerA",
                on:{
                    onSelectChange: function () {
                        var sel = this.getSelectedId(true);
                        if (sel.length > 0) {
                            $$('setting-edit-btn').enable();
                            $$('setting-del-btn').enable();
                        } else {
                            $$('setting-edit-btn').disable();
                            $$('setting-del-btn').disable();
                        }
                    }
                },
                url:'/admin/index.php/part_settings/act_get'
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
                    gridsetting,
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