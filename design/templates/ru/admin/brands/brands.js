webix.ready(function(){
    var grid = {
        id:"brands",
       // container:"brands",
        view:"datatable",
        editable:true,
        columns:[
            { id:"brand_id",	header:"ID", 			width:60, sort:"server" },
            { id:"title",	header:"Название",		width:300, sort:"server"/*, editor:"text"*/ },
            { id:"description",	header:"Описание", 	width:160, sort:"server"  },
            { id:"image",	header:"Картинка" , template:function(obj){return obj.image?"<img width='100' src='/images/news/"+obj.image+"'>":"";}, width:100, css:"noPadding", sort:"server"}
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
                var sel = this.getSelectedId(true), delBtn = $$('delBtn'), editBtn = $$('editBtn');
                if (sel.length==0) {
                    editBtn.disable();
                    delBtn.disable();
                } else {
                    editBtn.enable();
                    delBtn.enable();
                }
            }
        },
        url:"/admin/index.php/part_brands/act_get",
        save:{
            updateFromResponse:true,
            "insert":"/admin/index.php/part_brands/act_create",
            "update":"/admin/index.php/part_brands/act_update",
            "delete":"/admin/index.php/part_brands/act_destroy"
        }
    };

    var buttons = {
        view:"toolbar", elements:[
            { id:"editBtn", view:"button", disabled:true, value:"Редактировать", click:function(){
                /*$$('brands').add({
                    rank:99,
                    title:"",
                    year:"2012",
                    votes:"100"
                });*/
            }},{ view:"button", value:"Добавить", click:function(){
                    showForm("win1", this.$view);
            }},
            { id:"delBtn", disabled:true, view:"button", value:"Удалить", click:function(){
                /*var id = $$('dt1').getSelectedId();
                if (id)
                    $$('brands').remove(id);*/
            }},
            {}
        ]
    };

    var grida = webix.ui({
        container:"brands",
        rows:[
            buttons, grid
        ]
    });

    var dp = webix.dp('brands');
    dp.attachEvent('onAfterSaveError', function(id, status, obj){
        var operation = this.getItemState(id).operation; //operation that was performed
        console.log(operation);
    });


    var form = {
        view:"form",
        borderless:true,
        elements: [ {rows : [
            { view:"text", label:'Название (Русское)', name:"aBrand[title][1]" },
            { view:"text", label:'Название (English)', name:"aBrand[title][2]" },
            { view:"text", label:'Название (Fran?ais)', name:"aBrand[title][3]" },
            { view:"textarea", label:'Описание (Русское)', name:"aBrand[title][1]", width:200 },
            { view:"textarea", label:'Описание (English)', name:"aBrand[title][2]", width:200 },
            { view:"textarea", label:'Описание (Fran?ais)', name:"aBrand[title][3]", width:200 },
            { view:"text", label:'Email', name:"email" },
            { margin:5, cols:[
                { view:"button", type:"form", value: "Сохранить", click:function(){
                    if (this.getParentView().validate()){ //validate form
                        //webix.message("All is correct");
                        this.getTopParentView().hide(); //hide window
                    }
                    else
                        webix.message({ type:"error", text:"Заполните поля" });
                }},
                { view:"button", value:"Отмена", click:function(){
                        this.getTopParentView().hide(); //hide window
                }}
            ]}
        ]}
        ],
        rules:{
            "aBrand[title][1]":webix.rules.isNotEmpty,
            "aBrand[title][2]":webix.rules.isNotEmpty,
            "aBrand[title][3]":webix.rules.isNotEmpty
        },
        elementsConfig:{
            labelPosition:"top"
        }
    };

    webix.ui({
        view:"popup",
        id:"win1",
        width:300,
        head:false,
        body:webix.copy(form)
    });

    function showForm(winId, node){
        $$(winId).getBody().clear();
        $$(winId).show(node);
        $$(winId).getBody().focus();
    }

});