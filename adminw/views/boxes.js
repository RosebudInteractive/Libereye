define([
    "views/forms/box",
    "helpers/grid",
    "helpers/record"
], function(boxform, grid, record){

    var controls = [
        { view: "button", id:'addBtn', type: "iconButton", icon: "plus", label: "Добавить", width: 120, click: function(){
            var ui = this.$scope.ui(boxform.$ui);
            boxform.setData({box_id:0});
            ui.show();
        }},
        { view: "button", id:'box-edit-btn', disabled:true, type: "iconButton", icon: "pencil", label: "Редактировать", width: 150, click: function(){
            var grid = $$('grid-box'), selId = grid.getSelectedId(), that=this;
            if (selId) {
                var id = grid.getItem(selId)['box_id'];
                record.load('/admin/index.php/part_boxes/act_load?id='+id, function(data){
                    var ui = that.$scope.ui(boxform.$ui);
                    boxform.setData(data);
                    ui.show();
                });
            }
        }},{ view: "button", id:'box-del-btn', disabled:true, type: "iconButton", icon: "trash", label: "Удалить", width: 120, click: function(){
            var gridItem = $$('grid-box'), selId = gridItem.getSelectedId(), that=this;
            if (selId) {
                var id = gridItem.getItem(selId)['box_id'];
                record.remove("/admin/index.php/part_boxes/act_destroy", {id:id}, function(data){
                    grid.refresh($$('grid-box'), '/admin/index.php/part_boxes/act_get');
                });
            }
        }},
        {},
        { view: "icon", icon: "refresh",width: 40 , click: function(){
            grid.refresh($$('grid-box'), '/admin/index.php/part_boxes/act_get');
        }}
    ];

    var gridbox = {
        margin:10,
        rows:[
            {
                id:"grid-box",
                view:"datatable",
                columns:[
                    {id:"box_id", header:"ID", width:60, sort:"server" },
                    {id:"title", header:["Название", {content:"serverFilter"}], width:300, sort:"server"},
                    {id:"width",	header:["Ширина", {content:"serverFilter"}], width:200, sort:"server"},
                    {id:"length",	header:["Длина", {content:"serverFilter"}], width:200, sort:"server"},
                    {id:"height",	header:["Высота", {content:"serverFilter"}], width:200, sort:"server"}
                ],
                select:"row",
                pager:"pagerA",
                on:{
                    onSelectChange: function () {
                        var sel = this.getSelectedId(true);
                        if (sel.length > 0) {
                            $$('box-edit-btn').enable();
                            $$('box-del-btn').enable();
                        } else {
                            $$('box-edit-btn').disable();
                            $$('box-del-btn').disable();
                        }
                    }
                },
                url:'/admin/index.php/part_boxes/act_get'
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
                    gridbox,
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