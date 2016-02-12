define([
    "views/forms/seller2",
    "helpers/grid",
    "helpers/record",
    'views/forms/slotgen2'
], function(accountform, grid, record, slotgen){

    var data = {};
    function _setData(item, setfields) {
        data = item;
        if (setfields) {
            $$('listAllBrands').define('url', "/admin/index.php/part_brands/act_get/suggest_1/count_1000/?sort[title]=asc&shopOut=" + data.shop_id);
            $$('listShopBrands').define('url', "/admin/index.php/part_brands/act_get/suggest_1/count_1000/?sort[title]=asc&shopIn=" + data.shop_id);
        }
    }


    var layout = {
        type: "space",
                rows:[
                    {cols:[
                        {rows:[
                            {
                                height: 35,
                                view:"toolbar",
                                elements:[
                                    {view:"text", id:"listAllBrandsFilter",label:"Нет в магазине",css:"fltr", labelWidth:130
                                        ,
                                        on: {
                                            onTimedKeyPress:function(){
                                                var value = this.getValue().toLowerCase();
                                                $$("listAllBrands").filter(function(obj){
                                                    return obj.value.toLowerCase().indexOf(value)!=-1;
                                                });
                                            }
                                        }}
                                ]
                            },
                            {

                                view:"list",
                                id:"listAllBrands",
                                template:"#value#",
                                select:"multiselect",
                                multiselect:true,
                                // url: options.urls.brandsOut,
                                drag:true,
                                on: {
                                    onBeforeDrop: function(context, ev){
                                        webix.ajax().post("/admin/index.php/part_brands/act_brand2shop/remove_1", {id:context.source.join(','), shop_id:data.shop_id}, {
                                            success: function(text, data){
                                                data = data.json()
                                                if (data.error && data.error!="")
                                                    webix.message({type: "error", text: data.error});
                                                else
                                                    webix.message("Бренды успешно удалены из магазина");
                                            }
                                        });
                                        return true;
                                    }
                                }
                            }
                        ]}
                        ,
                        {rows:[
                            {
                                height: 35,
                                view:"toolbar",
                                elements:[
                                    {view:"text", id:"listShopBrandsFilter",label:"Бренды магазина",css:"fltr", labelWidth:130
                                        ,
                                        on: {
                                            onTimedKeyPress:function(){
                                                var value = this.getValue().toLowerCase();
                                                $$("listShopBrands").filter(function(obj){
                                                    return obj.value.toLowerCase().indexOf(value)!=-1;
                                                });
                                            }
                                        }}
                                ]
                            },
                            {

                                view:"list",
                                id:"listShopBrands",
                                template:"#value#",
                                select:"multiselect",
                                multiselect:true,
                                // url: options.urls.brandsIn,
                                drag:true,
                                on: {
                                    onBeforeDrop: function(context, ev){
                                        webix.ajax().post("/admin/index.php/part_brands/act_brand2shop/add_1", {id:context.source.join(','), shop_id:data.shop_id}, {
                                            success: function(text, data){
                                                data = data.json()
                                                if (data.error && data.error!="")
                                                    webix.message({type: "error", text: data.error});
                                                else
                                                    webix.message("Бренды успешно добавлены в магазин");
                                            }
                                        });
                                        return true;
                                    }
                                }
                            }
                        ]}
                    ]}
                ]
    };

    return {
        $ui: layout,
        $oninit:function(app, config){
            var id = window.location.hash.substr(1).match(/shopbrands\/([0-9]+)/)[1];
            if (!id) {document.location = "/adminw/";return;}
            record.load('/admin/index.php/part_shops/act_load?id='+id, function(data) {
                $$('title').data = {title: data.title[1], details: "Бренды магазина"};
                $$('title').refresh();
                _setData(data, true);
            });
        }
    };

});