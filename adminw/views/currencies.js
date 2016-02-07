define([
    "views/forms/currency",
    "helpers/grid",
    "helpers/record"
], function(currencyform, grid, record){

    var controls = [
        { view: "button", id:'addBtn', type: "iconButton", icon: "plus", label: "Добавить", width: 120, click: function(){
            var ui = this.$scope.ui(currencyform.$ui);
            currencyform.setData({currency_id:0});
            ui.show();
        }},
        { view: "button", id:'currency-edit-btn', disabled:true, type: "iconButton", icon: "pencil", label: "Редактировать", width: 150, click: function(){
            var grid = $$('grid-currency'), selId = grid.getSelectedId(), that=this;
            if (selId) {
                var id = grid.getItem(selId)['currency_id'];
                record.load('/admin/index.php/part_currencys/act_load?id='+id, function(data){
                    var ui = that.$scope.ui(currencyform.$ui);
                    currencyform.setData(data);
                    ui.show();
                });
            }
        }},{ view: "button", id:'currency-del-btn', disabled:true, type: "iconButton", icon: "trash", label: "Удалить", width: 120, click: function(){
            var gridItem = $$('grid-currency'), selId = gridItem.getSelectedId(), that=this;
            if (selId) {
                var id = gridItem.getItem(selId)['currency_id'];
                record.remove("/admin/index.php/part_currencys/act_destroy", {id:id}, function(data){
                    grid.refresh($$('grid-currency'), '/admin/index.php/part_currencys/act_get');
                });
            }
        }},
        {},
        { view: "icon", icon: "refresh",width: 40 , click: function(){
            grid.refresh($$('grid-currency'), '/admin/index.php/part_currencys/act_get');
        }}
    ];

    var gridcurrency = {
        margin:10,
        rows:[
            {
                id:"grid-currency",
                view:"datatable",
                columns:[
                    {id:"currency_id", header:"ID", width:60, sort:"server" },
                    {id:"code",	header:["Код валюты", {content:"serverFilter"}], width:100, sort:"server"}
                ],
                select:"row",
                pager:"pagerA",
                on:{
                    onSelectChange: function () {
                        var sel = this.getSelectedId(true);
                        if (sel.length > 0) {
                            $$('currency-edit-btn').enable();
                            $$('currency-del-btn').enable();
                        } else {
                            $$('currency-edit-btn').disable();
                            $$('currency-del-btn').disable();
                        }
                    }
                },
                url:'/admin/index.php/part_currencys/act_get'
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
                    gridcurrency,
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