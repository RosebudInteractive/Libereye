webix.ready(function(){

    var options = {
        translated: ['title', 'description'],
        urls: {
            get: "/admin/index.php/part_brands/act_get",
            load: "/admin/index.php/part_brands/act_load",
            destroy: "/admin/index.php/part_brands/act_destroy",
            update: "/admin/index.php/part_brands/act_create",
            create: "/admin/index.php/part_brands/act_create"
        }
    };

    var grid = {
        id:"brands",
        view:"datatable",
        columns:[
            {id:"brand_id", header:"ID", width:60, sort:"server" },
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
                $$("tabbar").setValue('tab'+getDefaultLang().language_id.toString());
                $$('form').setValues({id:0}, true);
                for(var i in LANGUAGES) {
                    for(var j in options.translated) {
                        $$(options.translated[j]+LANGUAGES[i].language_id).setValue('');
                    }
                }
                showForm("win1", this.$view);
            }},
            { view:"button", width:100, disabled:true, value:"Изменить", id:"editBtn", click:function(){
                    editNode($$('brands').getSelectedId(true)[0], $$("editBtn").$view, options);
                }}, { view:"button", width:100, disabled:true, value:"Удалить", id:"delBtn",  click:function(){
                    removeNode($$('brands').getSelectedId(true)[0], options);
                }}
        ]
    };

    var grida = webix.ui({
        container:"brands",
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
            { translated:true, view:"text", label:'Название', name:"title",required:true, invalidMessage: "Поле обязательное", id:"title" },
            { translated:true, view:"textarea", label:'Описание', height:100, name:"description", id:"description" },
            { margin:5, cols:[
                {},
                { view:"button", type:"form", value: "Сохранить", click:function(){
                    if ($$("form").validate()){
                        var data = $$('form').getValues();
                        webix.ajax().post("/admin/index.php/part_brands/act_create", data, {
                            success: function(text, data){
                                data = data.json()
                                if (data.error && data.error.length>0) {
                                    webix.message({ type:"error", text:Array.isArray(data.error)?data.error.join("\n"):data.error });
                                } else {
                                    webix.message("Изменения сохранены");
                                }
                                $$('brands').clearSelection();
                                $$('brands').load("/admin/index.php/part_brands/act_get");
                            }
                        });
                        this.getTopParentView().hide(); //hide window
                    }
                }},
                { view:"button", value:"Отмена", click:function(){
                        this.getTopParentView().hide(); //hide window
                }}
            ]}
        ]}
        ],

        elementsConfig:{
            labelWidth:110
        }
    };

    form.elements[0].rows = translateForm(form.elements[0].rows, 'aBrand');
    webix.ui({
        view:"popup",
        id:"win1",
        width:600,
        head:false,
        body:form
    });
});