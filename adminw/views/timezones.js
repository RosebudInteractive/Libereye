define([
    "views/forms/timezone",
    "helpers/grid",
    "helpers/record"
], function(timezoneform, grid, record){

    var controls = [
        { view: "button", id:'addBtn', type: "iconButton", icon: "plus", label: "Добавить", width: 120, click: function(){
            var ui = this.$scope.ui(timezoneform.$ui);
            timezoneform.setData({timezone_id:0});
            ui.show();
        }},
        { view: "button", id:'timezone-edit-btn', disabled:true, type: "iconButton", icon: "pencil", label: "Редактировать", width: 150, click: function(){
            var grid = $$('grid-timezone'), selId = grid.getSelectedId(), that=this;
            if (selId) {
                var id = grid.getItem(selId)['timezone_id'];
                record.load('/admin/index.php/part_timezones/act_load?id='+id, function(data){
                    var ui = that.$scope.ui(timezoneform.$ui);
                    timezoneform.setData(data);
                    ui.show();
                });
            }
        }},{ view: "button", id:'timezone-del-btn', disabled:true, type: "iconButton", icon: "trash", label: "Удалить", width: 120, click: function(){
            var gridItem = $$('grid-timezone'), selId = gridItem.getSelectedId(), that=this;
            if (selId) {
                var id = gridItem.getItem(selId)['timezone_id'];
                record.remove("/admin/index.php/part_timezones/act_destroy", {id:id}, function(data){
                    grid.refresh($$('grid-timezone'), '/admin/index.php/part_timezones/act_get');
                });
            }
        }},
        {},
        { view: "icon", icon: "refresh",width: 40 , click: function(){
            grid.refresh($$('grid-timezone'), '/admin/index.php/part_timezones/act_get');
        }}
    ];

    var gridtimezone = {
        margin:10,
        rows:[
            {
                id:"grid-timezone",
                view:"datatable",
                columns:[
                    {id:"timezone_id", header:"ID", width:60, sort:"server" },
                    {id:"title", header:["Название", {content:"serverFilter"}], width:300, sort:"server"},
                    {id:"code",	header:["Код зоны", {content:"serverFilter"}], width:200, sort:"server"},
                    {id:"time_shift",	header:["Смещенение", {content:"serverFilter"}], width:'100%', sort:"server"}
                ],
                select:"row",
                pager:"pagerA",
                on:{
                    onSelectChange: function () {
                        var sel = this.getSelectedId(true);
                        if (sel.length > 0) {
                            $$('timezone-edit-btn').enable();
                            $$('timezone-del-btn').enable();
                        } else {
                            $$('timezone-edit-btn').disable();
                            $$('timezone-del-btn').disable();
                        }
                    }
                },
                url:'/admin/index.php/part_timezones/act_get'
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
                    gridtimezone,
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