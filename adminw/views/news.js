define([
    "views/forms/news",
    "helpers/grid",
    "helpers/record"
], function(newsform, grid, record){

    var controls = [
        { view: "button", id:'addBtn', type: "iconButton", icon: "plus", label: "Добавить", width: 120, click: function(){
            var ui = this.$scope.ui(newsform.$ui);
            newsform.setData({news_id:0});
            ui.show();
        }},
        { view: "button", id:'news-edit-btn', disabled:true, type: "iconButton", icon: "pencil", label: "Редактировать", width: 150, click: function(){
            var grid = $$('grid-news'), selId = grid.getSelectedId(), that=this;
            if (selId) {
                var id = grid.getItem(selId)['news_id'];
                record.load('/admin/index.php/part_news/act_load?id='+id, function(data){
                    var ui = that.$scope.ui(newsform.$ui);
                    newsform.setData(data);
                    ui.show();
                });
            }
        }},{ view: "button", id:'news-del-btn', disabled:true, type: "iconButton", icon: "trash", label: "Удалить", width: 120, click: function(){
            var gridItem = $$('grid-news'), selId = gridItem.getSelectedId(), that=this;
            if (selId) {
                var id = gridItem.getItem(selId)['news_id'];
                record.remove("/admin/index.php/part_news/act_destroy", {id:id}, function(data){
                    grid.refresh($$('grid-news'), '/admin/index.php/part_news/act_get');
                });
            }
        }},
        {},
        { view: "icon", icon: "refresh",width: 40 , click: function(){
            grid.refresh($$('grid-news'), '/admin/index.php/part_news/act_get');
        }}
    ];

    var gridnews = {
        margin:10,
        rows:[
            {
                id:"grid-news",
                view:"datatable",
                columns:[
                    {id:"news_id", header:"ID", width:60, sort:"server" },
                    {id:"cdate", sort:"int", header:["Дата", {content:"datepickerFilter"}], sort:"server", width:150, format:webix.Date.dateToStr("%d.%m.%y %H:%i")},
                    {id:"title", header:["Название", {content:"serverFilter"}], width:200, sort:"server"},
                    {id:"annotation",	header:["Аннотация", {content:"serverFilter"}], width:300, sort:"server"},
                    {id:"full_news",	header:["Новость", {content:"serverFilter"}], width:'100%', sort:"server"}
                ],
                scheme:{
                    $init:function(obj){
                        obj.cdate = new Date(obj.cdate);
                    }
                },
                select:"row",
                pager:"pagerA",
                on:{
                    onSelectChange: function () {
                        var sel = this.getSelectedId(true);
                        if (sel.length > 0) {
                            $$('news-edit-btn').enable();
                            $$('news-del-btn').enable();
                        } else {
                            $$('news-edit-btn').disable();
                            $$('news-del-btn').disable();
                        }
                    },
                    onBeforeLoad:function(){
                       // console.log(this.getFilter("cdate").getValue())
                       // console.log(1);
                    }
                },
                url:'/admin/index.php/part_news/act_get'
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
                    gridnews,
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