define([
    "views/forms/carrier",
    "helpers/grid",
    "helpers/record"
], function(carrierform, grid, record){

    var controls = [
        { view: "button", id:'addBtn', type: "iconButton", icon: "plus", label: "Добавить", width: 120, click: function(){
            var ui = this.$scope.ui(carrierform.$ui);
            carrierform.setData({carrier_id:0});
            ui.show();
        }},
        { view: "button", id:'carrier-edit-btn', disabled:true, type: "iconButton", icon: "pencil", label: "Редактировать", width: 150, click: function(){
            var grid = $$('grid-carrier'), selId = grid.getSelectedId(), that=this;
            if (selId) {
                var id = grid.getItem(selId)['carrier_id'];
                record.load('/admin/index.php/part_carriers/act_load?id='+id, function(data){
                    var ui = that.$scope.ui(carrierform.$ui);
                    carrierform.setData(data);
                    ui.show();
                });
            }
        }},{ view: "button", id:'carrier-del-btn', disabled:true, type: "iconButton", icon: "trash", label: "Удалить", width: 120, click: function(){
            var gridItem = $$('grid-carrier'), selId = gridItem.getSelectedId(), that=this;
            if (selId) {
                var id = gridItem.getItem(selId)['carrier_id'];
                record.remove("/admin/index.php/part_carriers/act_destroy", {id:id}, function(data){
                    grid.refresh($$('grid-carrier'), '/admin/index.php/part_carriers/act_get');
                });
            }
        }},
        {},
        { view: "icon", icon: "refresh",width: 40 , click: function(){
            grid.refresh($$('grid-carrier'), '/admin/index.php/part_carriers/act_get');
        }}
    ];

    var gridcarrier = {
        margin:10,
        rows:[
            {
                id:"grid-carrier",
                view:"datatable",
                columns:[
                    {id:"carrier_id", header:"ID", width:60, sort:"server" },
                    {id:"title", header:["Название", {content:"serverFilter"}], width:300, sort:"server"},
                    {id:"tax",	header:["Коэффициент", {content:"serverFilter"}], width:180, sort:"server"},
                    {id:"customs",	header:["Таможенные сборы", {content:"serverFilter"}], width:180, sort:"server"},
                    {id:"box_charge",	header:["Стоимость упаковки", {content:"serverFilter"}], width:180, sort:"server"},
                    {id:"insurance",	header:["Страховка, %", {content:"serverFilter"}], width:180, sort:"server"}
                ],
                select:"row",
                pager:"pagerA",
                on:{
                    onSelectChange: function () {
                        var sel = this.getSelectedId(true);
                        if (sel.length > 0) {
                            $$('carrier-edit-btn').enable();
                            $$('carrier-del-btn').enable();
                        } else {
                            $$('carrier-edit-btn').disable();
                            $$('carrier-del-btn').disable();
                        }
                    }
                },
                url:'/admin/index.php/part_carriers/act_get'
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
                    gridcarrier,
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