webix.ready(function(){

    var options = {
        urls: {
            get: "/admin/index.php/part_phrases/act_get",
            load: "/admin/index.php/part_phrases/act_load",
            destroy: "/admin/index.php/part_phrases/act_destroy",
            update: "/admin/index.php/part_phrases/act_create",
            create: "/admin/index.php/part_phrases/act_create"
        },
        id: 'phrase_id'
    };

    var grid = {
        id:"gridItem",
        view:"datatable",
        columns:[
            {id:"phrase_id", header:"ID", width:60, sort:"server" },
            {id:"alias",	header:["Alias", {content:"serverFilter"}], width:500, sort:"server"},
            {id:"def_phrase", header:["Фраза по умолчанию", {content:"serverFilter"}], width:500, sort:"server"}
        ],
        select:"row", navigation:true, autowidth:true, autoheight:true,
        pager:{container:"paging_here", size:10},
        on:{
            onBeforeLoad:function(){
                this.showOverlay("Загрузка...");
            },
            onAfterLoad:function(){
                if (!this.count())
                    this.showOverlay("Нет данных");
                else
                    this.hideOverlay();
            },
            onSelectChange: function () {
                var sel = this.getSelectedId(true);
                if (sel.length > 0) {
                    $$('editBtn').enable();
                    $$('delBtn').enable();
                } else {
                    $$('editBtn').disable();
                    $$('delBtn').disable();
                }
            }
        },
        url:options.urls.get
    };


    var buttons = {
        view:"toolbar", elements:[
            { view:"button", width:100, value:"Добавить",  click:function(){
                $$('form').setValues({id:0}, true);
                $$('alias').setValue('');
                $$('def_phrase').setValue('');
                for(var i in LANGUAGES) {
                    $$('lang'+LANGUAGES[i].language_id).setValue('');
                }
                showForm("win1", this.$view);
            }},
            { view:"button", width:100, disabled:true, value:"Изменить", id:"editBtn", click:function(){
                editNode($$('gridItem').getSelectedId(true)[0], $$("editBtn").$view, $$('gridItem'), options, function(item){
                    $$('alias').setValue(item.alias ? item.alias : '');
                    $$('def_phrase').setValue(item.def_phrase ? item.def_phrase : '');
                    for(var i in LANGUAGES) {
                        $$('lang'+LANGUAGES[i].language_id).setValue(item.phrase[LANGUAGES[i].language_id]);
                    }
                });
            }}, { view:"button", width:100, disabled:true, value:"Удалить", id:"delBtn",  click:function(){
                removeNode($$('gridItem').getSelectedId(true)[0], $$('gridItem'), options);
            }},
            {},
            { view:"button", width:80, value:"Обновить", click:function(){
                var griItem = $$('gridItem');
                griItem.clearSelection();
                griItem.clearAll();
                griItem.load(options.urls.get);
            }}
        ]
    };


    var grida = webix.ui({
        container:"phrases",
        rows:[
            buttons, grid
        ]
    });

    var form = {
        id: "form",
        view:"form",
        width:600,
        borderless:true,
        elements: [ {rows : [
            { view:"text", label:'Alias', name:"aPhrase[alias]",required:true, invalidMessage: "Поле обязательное", id:"alias" },
            { view:"text", label:'По умолчанию', name:"aPhrase[def_phrase]", id:"def_phrase" }
        ]}
        ],

        elementsConfig:{
            labelWidth:110
        }
    };
    for(var i in LANGUAGES) {
        form.elements[0].rows.push({ view:"textarea", label:LANGUAGES[i].title, height:80, name:'aLang['+LANGUAGES[i].language_id+']', id:'lang'+LANGUAGES[i].language_id })
    }
    form.elements[0].rows.push({ margin:5, cols:[
        {},
        { view:"button", type:"form", value: "Сохранить", click:function(){ saveItem.apply(this, [options]); }},
        { view:"button", value:"Отмена", click:function(){
            this.getTopParentView().hide(); //hide window
        }}
    ]});

    webix.ui({
        view:"popup",
        id:"win1",
        width:600,
        head:false,
        body:form
    });


});