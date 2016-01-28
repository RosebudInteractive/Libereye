webix.ready(function(){

    var options = {
        translated: [],
        urls: {
            get: "/admin/index.php/part_shops/act_getslots/id_"+aShopJson.shop_id,
            getsellers: "/admin/index.php/part_shops/act_getsellers/id_"+aShopJson.shop_id,
            load: "/admin/index.php/part_shops/act_loadslot",
            destroy: "/admin/index.php/part_shops/act_destroyslot/id_"+aShopJson.shop_id,
            update: "/admin/index.php/part_shops/act_createslot/id_"+aShopJson.shop_id,
            create: "/admin/index.php/part_shops/act_createslot/id_"+aShopJson.shop_id
        },
        id: 'shop_slot_id'
    };

    var optionsSeller = {
        translated: [],
        urls: {
            get: "/admin/index.php/part_shops/act_getsellers/id_"+aShopJson.shop_id,
            load: "/admin/index.php/part_shops/act_loadseller",
            destroy: "/admin/index.php/part_shops/act_destroyseller/id_"+aShopJson.shop_id,
            update: "/admin/index.php/part_shops/act_createseller/id_"+aShopJson.shop_id,
            create: "/admin/index.php/part_shops/act_createseller/id_"+aShopJson.shop_id
        },
        id: 'account_id'
    };

    function getSellers() {
        var sellers = [];
        for(var i in aSellersJson)
            sellers.push({id:i, value:aSellersJson[i]});
        return sellers;
    }
    function setSellers(data) {
        aSellersJson = data;
        return getSellers();
    }

    var buttons = {
        view:"toolbar", elements:[
            { view:"button", width:100, value:"Добавить",  click:function(){
                $$('formSlot').setValues({shop_slot_id:0}, true);
                $$('time_from_slot').setValue('');
                $$('time_to_slot').setValue('');
                $$('seller_id_slot').define("options", getSellers());
                $$('seller_id_slot').setValue(0);
                $$('status_slot').setValue('free');
                showForm("win1", this.$view);
            }},
            { view:"button", width:100, disabled:true, value:"Изменить", id:"editBtn", click:function(){
                editNode(slotGrid.getSelectedId(true)[0], slotGrid, options, function(item){
                    $$('formSlot').setValues({shop_slot_id:getSelField(slotGrid, 'shop_slot_id')}, true);
                    $$('time_from_slot').setValue(item.time_from ? item.time_from : '');
                    $$('time_to_slot').setValue(item.time_to ? item.time_to : '');
                    $$('seller_id_slot').define("options", getSellers());
                    $$('seller_id_slot').setValue(item.seller_id);
                    $$('status_slot').setValue(item.status);
                    showForm("win1", el);
                });

            }}, { view:"button", width:100, disabled:true, value:"Удалить", id:"delBtn",  click:function(){
                removeNode(slotGrid.getSelectedId(true)[0], slotGrid, options);
            }},
            {},
            { view:"button", width:80, value:"Обновить", click:function(){
                var griItem = slotGrid;
                griItem.clearSelection();
                griItem.clearAll();
                griItem.load(options.urls.get);
            }}
        ]
    };
    var buttonsS = {
        view:"toolbar", elements:[
            { view:"button", width:100, value:"Добавить",  click:function(){
                $$('formSeller').setValues({account_id:0}, true);
                $$('formSeller').clearValidation();
                $$('doclist').clearAll();
                $$('image').setValues({src:null});
                $$('doclist').clearAll();
                $$('fname').setValue('');
                $$('email').setValue('');
                $$('pass').setValue(null);
                $$('pass_confirm').setValue(null);
                $$('pass').define("required", true);
                $$('pass_confirm').define("required", true);
                showForm("winSeller", this.$view);
            }},
            { view:"button", width:100, disabled:true, value:"Изменить", id:"editBtnS", click:function(){
                editNode(sellerGrid.getSelectedId(true)[0], sellerGrid, optionsSeller, function(item){
                    $$('formSeller').setValues({account_id:getSelField(sellerGrid, 'account_id')}, true);
                    $$('formSeller').clearValidation();
                    $$('doclist').clearAll();
                    $$('image').setValues({src:item.image && item.image!=""?('/images/account/'+item.image):null});
                    $$('fname').setValue(item.fname);
                    $$('email').setValue(item.email);
                    $$('pass').setValue(null);
                    $$('pass_confirm').setValue(null);
                    $$('pass').define("required", false);
                    $$('pass_confirm').define("required", false);
                    showForm("winSeller", $$("editBtnS").$view);
                });

            }}, { view:"button", width:100, disabled:true, value:"Удалить", id:"delBtnS",  click:function(){
                removeNode(sellerGrid.getSelectedId(true)[0], sellerGrid, optionsSeller);
            }}, { view:"button", width:150, /*disabled:true,*/ value:"Генерация слотов", id:"genBtnS",  click:function(){
                var id  = getSelField(sellerGrid, 'account_id');
                $$('seller_id_gen').define("options", getSellers());
                $$('seller_id_gen').setValue(id);
                showForm("winGen", this.$view);
            }},
            {},
            { view:"button", width:80, value:"Обновить", click:function(){
                var griItem = $$('sellerGrid');
                griItem.clearSelection();
                griItem.clearAll();
                griItem.load(optionsSeller.urls.get);
            }}
        ]
    };
    var form = {
        id: "form",
        view:"form",
        width:970,
        //borderless:true,
        elements: [ {rows : [
            {cols:[
                {template:'Расписание:<br><small>10:00-19:00</small>', width:100, height:43, borderless:true},
                {view:"text", name:"open_time[0]", id:"open_time0", placeholder:"Пн" },
                {view:"text", name:"open_time[1]", id:"open_time1", placeholder:"Вт" },
                {view:"text", name:"open_time[2]", id:"open_time2", placeholder:"Ср" },
                {view:"text", name:"open_time[3]", id:"open_time3", placeholder:"Чт"},
                {view:"text", name:"open_time[4]", id:"open_time4", placeholder:"Пт" },
                {view:"text", name:"open_time[5]", id:"open_time5", placeholder:"Сб" },
                {view:"text", name:"open_time[6]", id:"open_time6", placeholder:"Вс" },
                { view:"button", width:100, type:"form", value: "Сохранить", click:function(){
                    $$('form').setValues({id:aShopJson.shop_id}, true);
                    saveItemForm($$('form'), null, {urls:{create:'/admin/index.php/part_shops/act_create'}});
                }}
            ]},
            {height:10, borderless:true},
            {cols:[
                {template:'Шопперы:', width:100, height:43, borderless:true},
                {rows:[buttonsS,{
                    id: "sellerGrid",
                    view:"datatable",
                    columns:[
                        { id:"fname",	sort:"text", header:"Имя", width:300},
                        { id:"email",	sort:"text", header:"Email", width:200},
                        { id:"phone",	sort:"text", header:"Phone", width:210}
                    ],
                    select:"row",
                    height:150,
                    width:'100%',
                    on:{
                        onSelectChange:function(){
                            var sel = this.getSelectedId(true);
                            if (sel.length > 0) {
                                $$('editBtnS').enable();
                                $$('delBtnS').enable();
                              //  $$('genBtnS').enable();
                            } else {
                                $$('editBtnS').disable();
                                $$('delBtnS').disable();
                               // $$('genBtnS').disable();
                            }
                        }
                    },
                    url:options.urls.getsellers
                }]}

            ]},
            {height:10, borderless:true},
            {cols:[
                {template:'Слоты:', width:100, height:43, borderless:true},
                {rows:[buttons,{
                    id: "slotsGrid",
                    view:"datatable",
                    scheme:{
                        $init:function(obj){
                            obj.time_from = new Date(obj.time_from);
                            obj.time_to = new Date(obj.time_to);
                        }
                    },
                    columns:[
                        //{ id:"id",	header:"", css:"id", width:50},
                        { id:"ch1", header:{ content:"masterCheckbox" }, template:"{common.checkbox()}", width:40},
                        { id:"seller",	sort:"text", header:["Шоппер", {content:"selectFilter"}], width:250},
                        { id:"time_from", sort:"int",	header:["Дата начала", {content:"datepickerFilter"}] , width:150, format:webix.Date.dateToStr("%d.%m.%y %H:%i")},
                        { id:"time_to", sort:"int",	header:["Дата конца", {content:"datepickerFilter"}], 	width:150, format:webix.Date.dateToStr("%d.%m.%y %H:%i")},
                        { id:"status",	sort:"text",	header:["Статус", {content:"selectFilter"}], 	width:100}
                    ],
                    select:"row",
                    multiselect:true,
                    checkboxRefresh:true,
                    height:300,
                    width:'100%',
                    on:{
                        onSelectChange:function(){
                            var sel = this.getSelectedId(true);
                            if (sel.length > 0) {
                                $$('editBtn').enable();
                                $$('delBtn').enable();
                            } else {
                                $$('editBtn').disable();
                                $$('delBtn').disable();
                            }


                            for(var i in sel) {

                            }
                        },
                        onCheck: function(row, column, state){
                            if (state == 1)
                                this.select(row, true);
                            else
                                this.unselect(row, true);
                        },
                        onItemClick:function(id){
                            if (this.getItem(id.row).ch1 != 1) {
                                this.getItem(id.row).ch1 = 1;
                                this.refresh(id.row);
                            }
                        }
                    },
                    url:options.urls.get
                }]}

            ]}
        ]}
        ],

        elementsConfig:{
            labelWidth:140
        }
    };

    var formSlot = {
        id: "formSlot",
        view:"form",
        width:600, borderless:true,
        //borderless:true,
        elements: [ {rows : [
            {view:"select", label:"Шоппер", name:"seller_id", id:"seller_id_slot", placeholder:"Шоппер", value:0, options:[] },
            {view:"select", label:"Статус", name:"status", id:"status_slot", placeholder:"Статус", value:'free', options:['draft', 'free', 'booked'] },
            {cols:[
                //{template:':', width:100, borderless:true},
                {view:"datepicker", timepicker:true, name:"time_from", id:"time_from_slot", placeholder:"Начало" },
                {view:"datepicker", timepicker:true, name:"time_to", id:"time_to_slot", placeholder:"Конец" }
            ]},
            { margin:5, cols:[
                {},
                { view:"button", width:100, type:"form", value: "Сохранить", click:function(){
                    var that = this;
                    saveItemForm.apply(that, [$$('formSlot'), slotGrid, options]);
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
    };
    var formSeller = {
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
                    id:"files", name:"files",
                    value:"Выбрать",
                    link:"doclist",
                    autosend:false, //!important
                    sync: false, width:100, multiple:false,borderless:true
                }]},

            { margin:5, cols:[
                {},
                { view:"button", width:100, type:"form", value: "Сохранить", click:function(){
                    var that = this;
                    $$("files").send(function(){ //sending files
                        var images = [];
                        $$("files").files.data.each(function(obj){
                            var status = obj.status;
                            if(status=='server' && obj.id!="0") {
                                images.push(obj.id);
                            }
                        });
                        optionsSeller.images = images.join(',');
                        saveItemForm.apply(that, [$$('formSeller'), sellerGrid, optionsSeller, function(data){
                            if (data.sellers) setSellers(data.sellers);
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
    };

    var formGen = {
        id: "formGen",
        view:"form",
        width:600, borderless:true,
        //borderless:true,
        elements: [ {rows : [
            {view:"select", label:"Шоппер", name:"seller_id", id:"seller_id_gen", placeholder:"Шоппер", value:0, options:getSellers() },
            {cols:[
                {view:"datepicker", name:"time_from", id:"time_from_gen", placeholder:"Начало", value:new Date() },
                {view:"datepicker", name:"time_to", id:"time_to_gen", placeholder:"Конец", value:new Date(((new Date()).setDate((new Date()).getDate()+1))) }
            ]},
            {view:"checkbox", name:"publish", label:"Опубликовать"},
            { margin:5, cols:[
                {},
                { view:"button", width:130, type:"form", value: "Генерировать", click:function(){
                    var that = this;
                    showProgress('formGen');
                    loadItem("/admin/index.php/part_shops/act_genslots?id="+aShopJson.shop_id, $$('formGen').getValues(), function(item){
                        hideProgress('formGen');
                        if (!item.error) {
                            slotGrid.clearSelection();
                            slotGrid.clearAll();
                            slotGrid.load(options.urls.get);
                            that.getTopParentView().hide(); //hide window
                        }
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
    };
    var formObj = webix.ui({
        container:"shop_edit_form",
        rows:[
           form
        ]
    });
    var slotGrid = $$('slotsGrid'), sellerGrid = $$('sellerGrid'), parentFilterByAll = slotGrid.filterByAll;
    $$('slotsGrid').filterByAll=function(){
        //gets filter values
        var seller = this.getFilter("seller").value;
        var time_from = this.getFilter("time_from").getValue();
        var time_to = this.getFilter("time_to").getValue();
        var status = this.getFilter("status").value;

        //unfilter if values was not selected
        if (!seller && !status && !time_from && !time_to) return this.filter();

        //filter using or logic
        this.filter(function(obj){
            var state = true;
            if (seller && seller!=obj.seller) state=false;
            if (status && status!=obj.status) state=false;
            if (time_from && time_to) {
                    if (obj.time_from.getFullYear()+''+obj.time_from.getMonth()+''+obj.time_from.getDate() != time_from.getFullYear()+''+time_from.getMonth()+''+time_from.getDate() ||
                        obj.time_to.getFullYear()+''+obj.time_to.getMonth()+''+obj.time_to.getDate() != time_to.getFullYear()+''+time_to.getMonth()+''+time_to.getDate()) state=false;
            } else if (time_from) {
                if (obj.time_from.getFullYear()+''+obj.time_from.getMonth()+''+obj.time_from.getDate() != time_from.getFullYear()+''+time_from.getMonth()+''+time_from.getDate()) state=false;
            } else if (time_to) {
                if (obj.time_to.getFullYear()+''+obj.time_to.getMonth()+''+obj.time_to.getDate() != time_to.getFullYear()+''+time_to.getMonth()+''+time_to.getDate()) state=false;
            }
            return state;
        });


    };

    webix.ui({
        view:"popup",
        id:"win1",
        width:500,
        head:false,
        body:formSlot
    });

    webix.ui({
        view:"popup",
        id:"winGen",
        width:400,
        head:false,
        body:formGen
    });

    webix.ui({
        view:"popup",
        id:"winSeller",
        width:600,
        head:false,
        body:formSeller
    });

    loadItem("/admin/index.php/part_shops/act_load?id="+aShopJson.shop_id, {}, function(item){
        $$('open_time0').setValue(item.open_time && item.open_time[0] ? item.open_time[0] : '');
        $$('open_time1').setValue(item.open_time && item.open_time[1] ? item.open_time[1] : '');
        $$('open_time2').setValue(item.open_time && item.open_time[2] ? item.open_time[2] : '');
        $$('open_time3').setValue(item.open_time && item.open_time[3] ? item.open_time[3] : '');
        $$('open_time4').setValue(item.open_time && item.open_time[4] ? item.open_time[4] : '');
        $$('open_time5').setValue(item.open_time && item.open_time[5] ? item.open_time[5] : '');
        $$('open_time6').setValue(item.open_time && item.open_time[6] ? item.open_time[6] : '');
    });

    //adding progress bar functionality to it
    webix.extend($$("formGen"), webix.ProgressBar);


});