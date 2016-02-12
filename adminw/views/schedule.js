define([
    "views/forms/brand",
    "helpers/grid",
    "helpers/record"
], function(brandform, grid, record){

    var data = {};

    function _setData(item, setfields) {
        data = item;
        if (setfields) {
            $$('open_time0').setValue(item.open_time && item.open_time[0] ? item.open_time[0] : '');
            $$('open_time1').setValue(item.open_time && item.open_time[1] ? item.open_time[1] : '');
            $$('open_time2').setValue(item.open_time && item.open_time[2] ? item.open_time[2] : '');
            $$('open_time3').setValue(item.open_time && item.open_time[3] ? item.open_time[3] : '');
            $$('open_time4').setValue(item.open_time && item.open_time[4] ? item.open_time[4] : '');
            $$('open_time5').setValue(item.open_time && item.open_time[5] ? item.open_time[5] : '');
            $$('open_time6').setValue(item.open_time && item.open_time[6] ? item.open_time[6] : '');
        }
    }

    var layout = {
        type: "space",
        rows:[
            {view:"form", id:"schedule-form", elements:[
                    {cols:[
                        {view:"text", name:"open_time[0]", id:"open_time0", placeholder:"Пн" },
                        {view:"text", name:"open_time[1]", id:"open_time1", placeholder:"Вт" },
                        {view:"text", name:"open_time[2]", id:"open_time2", placeholder:"Ср" },
                        {view:"text", name:"open_time[3]", id:"open_time3", placeholder:"Чт"},
                        {view:"text", name:"open_time[4]", id:"open_time4", placeholder:"Пт" },
                        {view:"text", name:"open_time[5]", id:"open_time5", placeholder:"Сб" },
                        {view:"text", name:"open_time[6]", id:"open_time6", placeholder:"Вс" },
                        { view:"button", width:100, type:"form", value: "Сохранить", click:function(){
                            $$('schedule-form').setValues({id:data.shop_id}, true);
                            record.save('/admin/index.php/part_shops/act_create', $$('schedule-form').getValues(), function(data){

                            });
                        }}
                    ]}
                ]}
            ]
    };

    return {
        $ui: layout,
        $oninit:function(app, config){
            var id = window.location.hash.substr(1).match(/schedule\/([0-9]+)/)[1];
            //var id = SHOPID;//window.location.hash.substr(1).match(/schedule\/([0-9]+)/)[1];
            if (!id) {document.location = "/adminw/";return;}
            record.load('/admin/index.php/part_shops/act_load?id='+id, function(data) {
                $$('title').data = {title: data.title[1], details: "Управление магазином"};
                $$('title').refresh();
                _setData(data, true);
            });
        }
    };

});