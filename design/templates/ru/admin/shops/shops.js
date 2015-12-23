webix.ready(function(){
    grida = webix.ui({
        container:"shops",
        view:"datatable",
        columns:[
            { id:"shop_id",	header:"id", 			width:60 },
            { id:"title",	header:"Название",		width:300 },
            { id:"timezone",	header:"Timezone" , 		width:250  },
            { id:"cdate",	header:"Дата создания", 	width:160, format:webix.Date.dateToStr("%d/%m/%y %H:%i")  }
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
            }
        },
        url:"/admin/index.php/part_shops/act_get"
    });
});