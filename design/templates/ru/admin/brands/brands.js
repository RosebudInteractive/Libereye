webix.ready(function(){

    var translated = ['title', 'description'];

    var edit = function(e, node, el){
        var id  = $$('brands').getItem(node.row).brand_id;
        webix.ajax("/admin/index.php/part_brands/act_load?id="+id, function(text, data){
            data = data.json();
            $$("tabbar").setValue('tab'+getDefaultLang().language_id.toString());
            $$('form').setValues({id:data.brand_id}, true);
            for(var i in LANGUAGES) {
                for(var j in translated) {
                    var value = data[translated[j]] && data[translated[j]][LANGUAGES[i].language_id] ? data[translated[j]][LANGUAGES[i].language_id] : '';
                    $$(translated[j]+LANGUAGES[i].language_id).setValue(value);
                }
            }
            showForm("win1", el);
        });

        return false;
    };

    var remove = function(e, node, el){
        webix.confirm({
            text:"Вы уверены?", ok:"Да", cancel:"Отмена",
            callback:function(res){
                if(res) {
                    var id  = $$('brands').getItem(node.row).brand_id;
                    var data = {id:id};
                    webix.ajax().post("/admin/index.php/part_brands/act_destroy", data, {
                        success: function(text, data){
                            $$('brands').clearSelection();
                            $$('brands').load("/admin/index.php/part_brands/act_get");
                            webix.message("Бренд успешно удален");
                        }
                    });
                    return false;
                }
            }
        });
        return false;
    };

    var grid = {
        id:"brands",
        view:"datatable",
        editable:true,
        columns:[
            { id:"brand_id",	header:"ID", 			width:60, sort:"server" },
            { id:"title",	header:["Название", {content:"serverFilter"}], width:300, sort:"server"},
            { id:"description",	header:["Описание", {content:"serverFilter"}], 	width:500, sort:"server"  }
        ],

        select:"row",
        navigation:true,
        autowidth:true, autoheight:true,
        pager:{
            container:"paging_here",
            size:10
        },
        on:{
            onBeforeLoad:function(){
                this.showOverlay("Загрузка...");
            },
            onAfterLoad:function(){
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
        url:"/admin/index.php/part_brands/act_get",
        save:{
            updateFromResponse:true,
            "insert":"/admin/index.php/part_brands/act_create",
            "update":"/admin/index.php/part_brands/act_update",
            "delete":"/admin/index.php/part_brands/act_destroy"
        },
        onClick:{
            "fa-pencil":edit,
            "fa-trash-o":remove
        }
    };

    var buttons = {
        view:"toolbar", elements:[
            { view:"button", width:100, value:"Добавить",  click:function(){
                $$("tabbar").setValue('tab'+getDefaultLang().language_id.toString());
                $$('form').setValues({id:0}, true);
                for(var i in LANGUAGES) {
                    for(var j in translated) {
                        $$(translated[j]+LANGUAGES[i].language_id).setValue('');
                    }
                }
                showForm("win1", this.$view);
            }},
            { view:"button", width:100, disabled:true, value:"Изменить", id:"editBtn", click:function(){
                    edit(null, $$('brands').getSelectedId(true)[0], $$("editBtn").$view);
                }}, { view:"button", width:100, disabled:true, value:"Удалить", id:"delBtn",  click:function(){
                    remove(null, $$('brands').getSelectedId(true)[0], $$("delBtn").$view);
                }},
            {},
            { view:"button", width:150, value:"Пример формы",  click:function(){
                showForm("win2", this.$view);
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
                    if ($$("form").validate()){ //validate form
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
                    /*else
                        webix.message({ type:"error", text:"Заполните поля" });*/
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


    var form2 = {
        id: "form2",
        view:"form",
        width:700,
        borderless:true,
        elements: [ {rows : [
            { view:"text", label:'Бренд', name:"aProduct[brand]", required:true, invalidMessage: "Поле обязательное", id:"brandtitle", suggest:"/admin/index.php/part_brands/act_get/suggest_1"/*, onValueSuggest:function(obj){
                    $$('form2').setValue('aProduct[brand_id]', obj.id);
                }*/},
            { view:"text", label:'Тип продукта', name:"aProduct[ptype_id]", required:true, invalidMessage: "Поле обязательное", id:"ptype_id", suggest:"/admin/index.php/part_brands/act_get/suggest_1"},
            { view:"text", label:'Артикул', name:"aProduct[article]", required:true, invalidMessage: "Поле обязательное", id:"article"},
            { translated:true, view:"text", label:'Название', name:"title",required:true, invalidMessage: "Поле обязательное", id:"title" },
            { translated:true, view:"textarea", label:'Описание', height:100, name:"description", id:"description" },
            { margin:5, cols:[
                {},
                { view:"button", type:"form", value: "Сохранить", click:function(){
                    if ($$("form2").validate()){ //validate form
                        //webix.message("All is correct");
                        var data = $$('form2').getValues();
                        webix.ajax().post("/admin/index.php/part_brands/act_create", data, {
                            success: function(text, data){
                                //  $$('brands').clearAll();
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
                    /*else
                     webix.message({ type:"error", text:"Заполните поля" });*/
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

   // form2.elements[0].rows = translateForm(form2.elements[0].rows, 'aProduct');

    webix.ui({
        view:"popup",
        id:"win1",
        width:600,
        head:false,
        body:form
    });

    webix.ui({
        view:"popup",
        id:"win2",
        width:600,
        head:false,
        body:form2
    });

    $$('form2').setValues({ 'aProduct[brand_id]':"0"}, true);
    $$('brandtitle').attachEvent("onValueSuggest", function(obj){
        alert("Suggested "+obj.id);
    })

    function showForm(winId, node){
        //$$(winId).getBody().clear();
        $$(winId).show(node);
        $$(winId).getBody().focus();
    }

});