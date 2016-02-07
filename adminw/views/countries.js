define([
    "views/forms/country",
    "helpers/grid",
    "helpers/record"
], function(countryform, grid, record){

    var controls = [
        { view: "button", id:'addBtn', type: "iconButton", icon: "plus", label: "Добавить", width: 120, click: function(){
            var ui = this.$scope.ui(countryform.$ui);
            countryform.setData({country_id:0});
            ui.show();
        }},
        { view: "button", id:'country-edit-btn', disabled:true, type: "iconButton", icon: "pencil", label: "Редактировать", width: 150, click: function(){
            var grid = $$('grid-country'), selId = grid.getSelectedId(), that=this;
            if (selId) {
                var id = grid.getItem(selId)['country_id'];
                record.load('/admin/index.php/part_countrys/act_load?id='+id, function(data){
                    var ui = that.$scope.ui(countryform.$ui);
                    countryform.setData(data);
                    ui.show();
                });
            }
        }},{ view: "button", id:'country-del-btn', disabled:true, type: "iconButton", icon: "trash", label: "Удалить", width: 120, click: function(){
            var gridItem = $$('grid-country'), selId = gridItem.getSelectedId(), that=this;
            if (selId) {
                var id = gridItem.getItem(selId)['country_id'];
                record.remove("/admin/index.php/part_countrys/act_destroy", {id:id}, function(data){
                    grid.refresh($$('grid-country'), '/admin/index.php/part_countrys/act_get');
                });
            }
        }},
        {},
        { view: "icon", icon: "refresh",width: 40 , click: function(){
            grid.refresh($$('grid-country'), '/admin/index.php/part_countrys/act_get');
        }}
    ];

    var gridcountry = {
        margin:10,
        rows:[
            {
                id:"grid-country",
                view:"datatable",
                columns:[
                    {id:"country_id", header:"ID", width:60, sort:"server" },
                    {id:"title", header:["Название", {content:"serverFilter"}], width:300, sort:"server"},
                    {id:"code2",	header:["Код два символа", {content:"serverFilter"}], width:100, sort:"server"},
                    {id:"code3",	header:["Код три символа", {content:"serverFilter"}], width:'100%', sort:"server"}
                ],
                select:"row",
                pager:"pagerA",
                on:{
                    onSelectChange: function () {
                        var sel = this.getSelectedId(true);
                        if (sel.length > 0) {
                            $$('country-edit-btn').enable();
                            $$('country-del-btn').enable();
                        } else {
                            $$('country-edit-btn').disable();
                            $$('country-del-btn').disable();
                        }
                    }
                },
                url:'/admin/index.php/part_countrys/act_get'
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
                    gridcountry,
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