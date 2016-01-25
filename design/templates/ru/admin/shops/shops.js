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
                $$('doclist').clearAll();
                $$('promo_head').setValues({src:null});
                $$('open_time0').setValue('');
                $$('open_time1').setValue('');
                $$('open_time2').setValue('');
                $$('open_time3').setValue('');
                $$('open_time4').setValue('');
                $$('open_time5').setValue('');
                $$('open_time6').setValue('');
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
                editNode($$('gridItem').getSelectedId(true)[0], $$("editBtn").$view, $$('gridItem'), options, function(item){
                    $$('doclist').clearAll();
                    $$('promo_head').setValues({src:item.promo_head && item.promo_head!=""?('/images/shop/'+item.promo_head):null});
                    $$('open_time0').setValue(item.open_time && item.open_time[0] ? item.open_time[0] : '');
                    $$('open_time1').setValue(item.open_time && item.open_time[1] ? item.open_time[1] : '');
                    $$('open_time2').setValue(item.open_time && item.open_time[2] ? item.open_time[2] : '');
                    $$('open_time3').setValue(item.open_time && item.open_time[3] ? item.open_time[3] : '');
                    $$('open_time4').setValue(item.open_time && item.open_time[4] ? item.open_time[4] : '');
                    $$('open_time5').setValue(item.open_time && item.open_time[5] ? item.open_time[5] : '');
                    $$('open_time6').setValue(item.open_time && item.open_time[6] ? item.open_time[6] : '');
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
        container:"shops",
        rows:[
            buttons, grid
        ]
    });

    var form = {
        id: "form",
        view:"form",
        width:870,
        borderless:true,
        elements: [ {rows : [
            {cols:[
                {template:'Картинка:', width:100,borderless:true},
                {template:function (obj) {
                    // obj is a data record object
                    if (obj.src)
                        return '<a href="'+obj.src+'" target="_blank"><img src="'+obj.src+'" height="30"/></a>';
                    else
                        return 'нет';
                }, id:'promo_head', width:100,borderless:true},
                { view:"list", scroll:false, id:"doclist", type:"uploader", borderless:true },{
                view:"uploader", upload:"/admin/index.php/part_shops/act_upload",
                id:"files", name:"files",
                value:"Выбрать",
                link:"doclist",
                autosend:false, //!important
                sync: false, width:100, multiple:false,borderless:true
            }]},
            {cols:[
                {template:'Расписание:<br><small>10:00-19:00</small>', width:100, height:43, borderless:true},
                {view:"text", name:"open_time[0]", id:"open_time0", placeholder:"Пн" },
                {view:"text", name:"open_time[1]", id:"open_time1", placeholder:"Вт" },
                {view:"text", name:"open_time[2]", id:"open_time2", placeholder:"Ср" },
                {view:"text", name:"open_time[3]", id:"open_time3", placeholder:"Чт"},
                {view:"text", name:"open_time[4]", id:"open_time4", placeholder:"Пт" },
                {view:"text", name:"open_time[5]", id:"open_time5", placeholder:"Сб" },
                {view:"text", name:"open_time[6]", id:"open_time6", placeholder:"Вс" }
            ]},
            {template:'<div style="border-top:1px solid #ddd"></div>',borderless:true,height:10},
            { translated:true, view:"text", label:'Название', name:"title",required:true, invalidMessage: "Поле обязательное", id:"title" },
            { translated:true, view:"textarea", label:'Описание', height:100, name:"description", id:"description" },
            { translated:true, view:"textarea", label:'Описание брендов', height:100, name:"brand_desc", id:"brand_desc" },
            { margin:5, cols:[
                {},
                { view:"button", type:"form", value: "Сохранить", click:function(){
                    var that = this;
                    $$("files").send(function(){ //sending files
                        var images = [];
                        $$("files").files.data.each(function(obj){
                            var status = obj.status;
                            if(status=='server' && obj.id!="0") {
                                images.push(obj.id);
                            }
                        });
                        options.images = images.join(',');
                        saveItem.apply(that, [options]);
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
        width:870,
        head:false,
        body:form
    });


});