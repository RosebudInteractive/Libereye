define(['helpers/progress', 'helpers/record'], function(p, r){
    var shop = {};

    function saveItemForm(form, grid, options, cb) {
        if (form.validate()){
            var postdata = form.getValues();
            if (options.images)
                postdata.images = options.images;
            var that = this;
            webix.ajax().post("/admin/index.php/part_shops/act_createseller/id_"+shop.shop_id, postdata, {
                success: function(text, data){
                    data = data.json()
                    if (data.error && data.error.length>0) {
                        webix.message({ type:"error", text:Array.isArray(data.error)?data.error.join("<br>"):data.error });
                    } else {
                        webix.message("Изменения сохранены");
                        if ( that.getTopParentView() )
                            that.getTopParentView().hide(); //hide window
                        if (grid) {
                            grid.clearSelection();
                            grid.clearAll();
                            grid.load("/admin/index.php/part_shops/act_getsellers/id_"+shop.shop_id);
                        }
                    }
                    if (cb) cb(data);
                }
            });
        }
    }

	return {
        setData: function(d){shop = d;},
		$ui:{
            id: "formSeller",
            view:"form",
            width:800, borderless:true,
            //borderless:true,
            elements: [ {rows : [
                {view:"text", label:"Имя", name:"fname", id:"fname", required:true, invalidMessage: "Поле обязательное" },
                {view:"text", label:"Email", name:"email", id:"email", required:true, validate:webix.rules.isEmail, invalidMessage: "Проверьте email" },
                {view:"text", type:"password", label:"Пароль", name:"pass", id:"pass", required:true, invalidMessage: "Поле обязательное" },
                {view:"text", type:"password", label:"Пароль еще раз", name:"pass_confirm", id:"pass_confirm", required:true, invalidMessage: "Поле обязательное" },
                {cols:[
                    {template:'Иконка:', width:100,borderless:true},
                    {template:function (obj) {
                        // obj is a data record object
                        if (obj.src)
                            return '<a href="'+obj.src+'" target="_blank"><img src="'+obj.src+'" height="30"/></a>';
                        else
                            return 'нет';
                    }, id:'image', width:100,borderless:true},
                    { view:"list", scroll:false, id:"doclist", type:"uploader", borderless:true },{
                        view:"uploader", upload:"/admin/index.php/part_shops/act_upload/type_account",
                        id:"sellerfiles", name:"files",
                        value:"Выбрать",
                        link:"doclist",
                        autosend:false, //!important
                        sync: false, width:100, multiple:false,borderless:true
                    }]},

                { margin:5, cols:[
                    {},
                    { view:"button", width:100, type:"form", value: "Сохранить", click:function(){
                        var that = this;
                        $$("sellerfiles").send(function(){ //sending files
                            var images = [];
                            $$("sellerfiles").files.data.each(function(obj){
                                var status = obj.status;
                                if(status=='server' && obj.id!="0") {
                                    images.push(obj.id);
                                }
                            });
                            var options = {};
                            options.images = images.join(',');
                            saveItemForm.apply(that, [$$('formSeller'), $$('sellerGrid'), options, function(data){
                               // if (data.sellers) setSellers(data.sellers);
                            }]);
                        });
                    }},
                    { view:"button", width:100,  value:"Отмена", click:function(){
                        this.getTopParentView().hide(); //hide window
                    }}
                ]}
            ]}
            ],
            elementsConfig:{
                labelWidth:140
            }
        }
	};

});