define([
    "views/forms/brand",
    "helpers/grid",
    "helpers/record"
], function(brandform, grid, record){

    var controls = [
        { view: "button", id:'addBtn', type: "iconButton", icon: "plus", label: "Добавить", width: 120, click: function(){
            var ui = this.$scope.ui(brandform.$ui);
            brandform.setData({brand_id:0});
            ui.show();
        }},
        { view: "button", id:'brand-edit-btn', disabled:true, type: "iconButton", icon: "pencil", label: "Редактировать", width: 150, click: function(){
            var grid = $$('grid-brand'), selId = grid.getSelectedId(), that=this;
            if (selId) {
                var id = grid.getItem(selId)['brand_id'];
                record.load('/admin/index.php/part_brands/act_load?id='+id, function(data){
                    var ui = that.$scope.ui(brandform.$ui);
                    brandform.setData(data);
                    ui.show();
                });
            }
        }},{ view: "button", id:'brand-del-btn', disabled:true, type: "iconButton", icon: "trash", label: "Удалить", width: 120, click: function(){
            var gridItem = $$('grid-brand'), selId = gridItem.getSelectedId(), that=this;
            if (selId) {
                var id = gridItem.getItem(selId)['brand_id'];
                record.remove("/admin/index.php/part_brands/act_destroy", {id:id}, function(data){
                    grid.refresh($$('grid-brand'), '/admin/index.php/part_brands/act_get');
                });
            }
        }},
        {},
        { view: "icon", icon: "refresh",width: 40 , click: function(){
            grid.refresh($$('grid-brand'), '/admin/index.php/part_brands/act_get');
        }}
    ];

    var gridbrand = {
        margin:10,
        rows:[
            {
                id:"grid-brand",
                view:"datatable",
                columns:[
                    {id:"brand_id", header:"ID", width:60, sort:"server" },
                    {id:"title", header:["Название", {content:"serverFilter"}], width:300, sort:"server"},
                    {id:"description",	header:["Описание", {content:"serverFilter"}], width:'100%', sort:"server"}
                ],
                select:"row",
                pager:"pagerA",
                on:{
                    onSelectChange: function () {
                        var sel = this.getSelectedId(true);
                        if (sel.length > 0) {
                            $$('brand-edit-btn').enable();
                            $$('brand-del-btn').enable();
                        } else {
                            $$('brand-edit-btn').disable();
                            $$('brand-del-btn').disable();
                        }
                    }
                },
                url:'/admin/index.php/part_brands/act_get'
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
                    gridbrand,
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