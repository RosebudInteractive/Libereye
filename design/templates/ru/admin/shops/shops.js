webix.ready(function(){

    var options = {
        translated: ['title', 'description', 'brand_desc'],
        urls: {
            get: "/admin/index.php/part_shops/act_get",
            load: "/admin/index.php/part_shops/act_load",
            destroy: "/admin/index.php/part_shops/act_destroy",
            update: "/admin/index.php/part_shops/act_create",
            create: "/admin/index.php/part_shops/act_create"
        },
        id: 'shop_id'
    };

    var grid = {
        id:"gridItem",
        view:"datatable",
        columns:[
            {id:"shop_id", header:"ID", width:60, sort:"server" },
            {id:"title", header:["Название", {content:"serverFilter"}], width:300, sort:"server"},
            {id:"description",	header:["Описание", {content:"serverFilter"}], width:500, sort:"server"}
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
                if ($$("tabbar")) {
                    $$("tabbar").setValue('tab'+getDefaultLang().language_id.toString());
                    for(var i in LANGUAGES) {
                        for(var j in options.translated) {
                            $$(options.translated[j]+LANGUAGES[i].language_id).setValue('');
                        }
                    }
                }
                showForm("win1", this.$view);
            }},
            { view:"button", width:100, disabled:true, value:"Изменить", id:"editBtn", click:function(){
                editNode($$('gridItem').getSelectedId(true)[0], $$("editBtn").$view, $$('gridItem'), options);
            }}, { view:"button", width:100, disabled:true, value:"Удалить", id:"delBtn",  click:function(){
                removeNode($$('gridItem').getSelectedId(true)[0], $$('gridItem'), options);
            }},
            {},
            { view:"button", width:80, value:"Обновить", click:function(){
                $$('gridItem').clearSelection();
                $$('gridItem').load(options.urls.get);
            }}
        ]
    };


    var grida = webix.ui({
        container:"shops",
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
            {cols:[
                {template:'Картинка:', width:100,borderless:true},
                {template:'<img src="/images/shop/shop_logo.jpg" height="30">', id:'promo_head', width:100,borderless:true},
                { view:"list", scroll:false, id:"doclist", type:"uploader", borderless:true },{
                view:"uploader", upload:"/admin/index.php/part_shops/act_upload",
                id:"files", name:"files",
                value:"Выбрать",
                link:"doclist",
                autosend:false, //!important
                sync: false, width:100, multiple:false,borderless:true
            }]},
            {template:'<div style="border-top:1px solid #ddd"></div>',borderless:true,height:10},
            { translated:true, view:"text", label:'Название', name:"title",required:true, invalidMessage: "Поле обязательное", id:"title" },
            { translated:true, view:"textarea", label:'Описание', height:100, name:"description", id:"description" },
            { translated:true, view:"textarea", label:'Описание брендов', height:100, name:"brand_desc", id:"brand_desc" },
            { margin:5, cols:[
                {},
                { view:"button", type:"form", value: "Сохранить", click:function(){
                    $$("files").send(function(){ //sending files
                        saveItem.apply(this, [options]);
                    });
                }},
                { view:"button", value:"Отмена", click:function(){
                    this.getTopParentView().hide(); //hide window
                }}
            ]}
        ]}
        ],

        elementsConfig:{
            labelWidth:140
        }
    };

    form.elements[0].rows = translateForm(form.elements[0].rows, 'aShop');
    webix.ui({
        view:"popup",
        id:"win1",
        width:600,
        head:false,
        body:form
    });


});