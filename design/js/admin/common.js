
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


function editNode(node, grid, options, cb){
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
        if (cb) cb(data);
    });

    return false;
};

function loadItem(url, postData, cb){
    webix.ajax().post(url, postData, {
        success: function(text, data) {
            data = data.json();
            if (data.error && data.error!="")
                webix.message({type: "error", text: data.error});
            if (cb) cb(data);
        },
        error: function(text, data) {
            data = data.json();
            if (data.error && data.error!="")
                webix.message({type: "error", text: data.error});
            if (cb) cb(data);
        }
    });
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
                        data = data.json()
                        if (data.error && data.error!="")
                            webix.message({type: "error", text: data.error});
                        else
                            webix.message("Объект успешно удален");
                        grid.clearSelection();
                        grid.clearAll();
                        grid.load(options.urls.get);
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
        if (options.images)
            data.images = options.images;
        var that = this;
        webix.ajax().post(options.urls.create, data, {
            success: function(text, data){
                data = data.json()
                if (data.error && data.error.length>0) {
                    webix.message({ type:"error", text:Array.isArray(data.error)?data.error.join("\n"):data.error });
                } else {
                    webix.message("Изменения сохранены");
                    $$('gridItem').clearSelection();
                    $$('gridItem').clearAll();
                    $$('gridItem').load(options.urls.get);
                    that.getTopParentView().hide(); //hide window
                }
            }
        });
    }
}

function saveItemForm(form, grid, options, cb) {
    if (form.validate()){
        var data = form.getValues();
        if (options.images)
            data.images = options.images;
        var that = this;
        webix.ajax().post(options.urls.create, data, {
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
                        grid.load(options.urls.get);
                    }
                }
                if (cb) cb(data);
            }
        });
    }
}

function showProgress(id){
    $$(id).disable();
    $$(id).showProgress({
        type:"icon",
        delay:3000
    });
}
function hideProgress(id){
    $$(id).enable();
    $$(id).hideProgress();
}

function getSelField(grid, id, index) {
    index = index?index:0;
    var item = grid.getItem(grid.getSelectedId(true)[index]);
    if (item) return item[id];
    return false;
}