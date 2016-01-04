
function translateForm(rows, groupName) {
    var items = [];
    var tabview = {id:"tabbar", view:"tabbar", multiview:true, animate:{type:"flip", subtype:"vertical"}, options:[]};
    var cells = {cells:[]};

    var rowsTmp  = rows.slice(), rowsTmp2 = [];
    var index = false;
    for (var i in rowsTmp) {
        if ("translated" in rows[i] && rows[i].translated) {
            items.push(rowsTmp[i]);
            if (!index) index = i;
        } else {
            rowsTmp2.push(rowsTmp[i]);
        }
    }
    rows = rowsTmp2;

    for(var i in LANGUAGES) {
        var itemLang = jQuery.extend(true, {}, items);
        var r = {id:'tab'+LANGUAGES[i].language_id.toString(), rows : []};
        for (var j in itemLang) {
            itemLang[j].name = groupName+'[' + itemLang[j].name + '][' + LANGUAGES[i].language_id + ']';
            itemLang[j].id = itemLang[j].id + LANGUAGES[i].language_id.toString();
            r.rows.push(itemLang[j]);
        }
        r.show = LANGUAGES[i].is_default == 1;
        cells.cells.push(r);
        tabview.options.push({id:'tab'+LANGUAGES[i].language_id.toString(), value:LANGUAGES[i].title});
    }

    if (index) {
        rows.splice(index, 0, cells);
        rows.splice(index, 0, tabview);
    }

    return rows;
}

function getDefaultLang() {
    for(var i in LANGUAGES)
        if (LANGUAGES[i].is_default == 1)
            return LANGUAGES[i];
}


function showForm(winId, node){
    //$$(winId).getBody().clear();
    $$(winId).show(node);
    $$(winId).getBody().focus();
}


function editNode(node, el, grid, options){
    var id  = grid.getItem(node.row)[options.id], translated = options.translated;
    webix.ajax(options.urls.load+"?id="+id, function(text, data){
        data = data.json();
        if (data.error) {
            webix.message({type:"error", text:data.error});
            return false;
        }
        if ($$("tabbar"))
            $$("tabbar").setValue('tab'+getDefaultLang().language_id.toString());
        $$('form').setValues({id:id}, true);
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

function removeNode(node, grid, options){
    webix.confirm({
        text:"Вы уверены?", ok:"Да", cancel:"Отмена",
        callback:function(res){
            if(res) {
                var id  = grid.getItem(node.row)[options.id];
                var data = {id:id};
                webix.ajax().post(options.urls.destroy, data, {
                    success: function(text, data){
                        grid.clearSelection();
                        grid.load(options.urls.get);
                        webix.message("Бренд успешно удален");
                    }
                });
                return false;
            }
        }
    });
    return false;
};

function saveItem(options) {
    if ($$("form").validate()){
        var data = $$('form').getValues();
        webix.ajax().post(options.urls.create, data, {
            success: function(text, data){
                data = data.json()
                if (data.error && data.error.length>0) {
                    webix.message({ type:"error", text:Array.isArray(data.error)?data.error.join("\n"):data.error });
                } else {
                    webix.message("Изменения сохранены");
                }
                $$('gridItem').clearSelection();
                $$('gridItem').load(options.urls.get);
            }
        });
        this.getTopParentView().hide(); //hide window
    }
}
