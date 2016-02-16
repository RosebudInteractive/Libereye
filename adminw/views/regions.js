define([
    "views/forms/region",
    "helpers/grid",
    "helpers/record"
], function(regionform, grid, record){

    var controls = [
        { view: "button", id:'addBtn', type: "iconButton", icon: "plus", label: "Добавить", width: 120, click: function(){
            var ui = this.$scope.ui(regionform.$ui);
            regionform.setData({region_id:0});
            ui.show();
        }},
        { view: "button", id:'region-edit-btn', disabled:true, type: "iconButton", icon: "pencil", label: "Редактировать", width: 150, click: function(){
            var grid = $$('grid-region'), selId = grid.getSelectedId(), that=this;
            if (selId) {
                var id = grid.getItem(selId)['region_id'];
                record.load('/admin/index.php/part_regions/act_load?id='+id, function(data){
                    var ui = that.$scope.ui(regionform.$ui);
                    regionform.setData(data);
                    ui.show();
                });
            }
        }},{ view: "button", id:'region-del-btn', disabled:true, type: "iconButton", icon: "trash", label: "Удалить", width: 120, click: function(){
            var gridItem = $$('grid-region'), selId = gridItem.getSelectedId(), that=this;
            if (selId) {
                var id = gridItem.getItem(selId)['region_id'];
                record.remove("/admin/index.php/part_regions/act_destroy", {id:id}, function(data){
                    grid.refresh($$('grid-region'), '/admin/index.php/part_regions/act_get');
                });
            }
        }},
        {},
        { view: "icon", icon: "refresh",width: 40 , click: function(){
            grid.refresh($$('grid-region'), '/admin/index.php/part_regions/act_get');
        }}
    ];

    var gridregion = {
        margin:10,
        rows:[
            {
                id:"grid-region",
                view:"datatable",
                columns:[
                    {id:"region_id", header:"ID", width:60, sort:"server" },
                    {id:"title", header:["Название", {content:"serverFilter"}], width:300, sort:"server"},
                    {id:"country",	header:["Страна", {content:"serverFilter"}], width:300, sort:"server"}
                ],
                select:"row",
                pager:"pagerA",
                on:{
                    onSelectChange: function () {
                        var sel = this.getSelectedId(true);
                        if (sel.length > 0) {
                            $$('region-edit-btn').enable();
                            $$('region-del-btn').enable();
                        } else {
                            $$('region-edit-btn').disable();
                            $$('region-del-btn').disable();
                        }
                    }
                },
                url:'/admin/index.php/part_regions/act_get'
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
                    gridregion,
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