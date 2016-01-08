


webix.ui({
    view:"popup",
    id:"win2",
    width:600,
    head:false,
    body:form2
});

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



$$('form2').setValues({ 'aProduct[brand_id]':"0"}, true);


$$('brandtitle').attachEvent("onValueSuggest", function(obj){
    alert("Suggested "+obj.id);
})