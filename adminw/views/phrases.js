define([
    "views/forms/phrase",
    "helpers/grid",
    "helpers/record"
], function(phraseform, grid, record){

    var controls = [
        { view: "button", id:'addBtn', type: "iconButton", icon: "plus", label: "Добавить", width: 120, click: function(){
            var ui = this.$scope.ui(phraseform.$ui);
            phraseform.setData({phrase_id:0});
            ui.show();
        }},
        { view: "button", id:'phrase-edit-btn', disabled:true, type: "iconButton", icon: "pencil", label: "Редактировать", width: 150, click: function(){
            var grid = $$('grid-phrase'), selId = grid.getSelectedId(), that=this;
            if (selId) {
                var id = grid.getItem(selId)['phrase_id'];
                record.load('/admin/index.php/part_phrases/act_load?id='+id, function(data){
                    var ui = that.$scope.ui(phraseform.$ui);
                    phraseform.setData(data);
                    ui.show();
                });
            }
        }},{ view: "button", id:'phrase-del-btn', disabled:true, type: "iconButton", icon: "trash", label: "Удалить", width: 120, click: function(){
            var gridItem = $$('grid-phrase'), selId = gridItem.getSelectedId(), that=this;
            if (selId) {
                var id = gridItem.getItem(selId)['phrase_id'];
                record.remove("/admin/index.php/part_phrases/act_destroy", {id:id}, function(data){
                    grid.refresh($$('grid-phrase'), '/admin/index.php/part_phrases/act_get');
                });
            }
        }},
        {},
        { view: "button",  id:'exportBtn', type: "iconButton", icon: "file-excel-o", label: "Экспорт", width: 120, click: function(){
            window.open('/admin/index.php/part_phrases/sect_export');
        }},
        { view: "button", type:"uploader", id:'importBtn', type: "iconButton", icon: "file-excel-o", label: "Импорт", width: 120, click: function(){
            $$("uploadAPI").fileDialog();
        }},
        { view: "icon", icon: "refresh",width: 40 , click: function(){
            grid.refresh($$('grid-phrase'), '/admin/index.php/part_phrases/act_get');
        }}
    ];

    webix.ui({
        id:"uploadAPI",
        view:"uploader",
        upload:"/admin/index.php/part_phrases/sect_import",
        on:{
            onBeforeFileAdd:function(item){
                var type = item.type.toLowerCase();
                if (type != "csv"){
                    webix.message("Для импорта используется csv файл");
                    return false;
                }
            },
            onFileUpload:function(item, response){
                webix.message(response.message);
            },
            onFileUploadError:function(item, response){
                if (response && response.errors)
                    webix.alert(response.errors);
                else
                    webix.alert("Error during file upload");
            }
        },
        apiOnly:true
    });

    var gridphrase = {
        margin:10,
        rows:[
            {
                id:"grid-phrase",
                view:"datatable",
                columns:[
                    {id:"phrase_id", header:"ID", width:60, sort:"server" },
                    {id:"alias",	header:["Alias", {content:"serverFilter"}], width:500, sort:"server"},
                    {id:"def_phrase", header:["Фраза по умолчанию", {content:"serverFilter"}], width:500, sort:"server"}
                ],
                select:"row",
                pager:"pagerA",
                on:{
                    onSelectChange: function () {
                        var sel = this.getSelectedId(true);
                        if (sel.length > 0) {
                            $$('phrase-edit-btn').enable();
                            $$('phrase-del-btn').enable();
                        } else {
                            $$('phrase-edit-btn').disable();
                            $$('phrase-del-btn').disable();
                        }
                    }
                },
                url:'/admin/index.php/part_phrases/act_get'
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
                    gridphrase,
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