/**
 * Object for manage items
 */
define([], function(){

    function _save(url, data, cb) {
        var that = this;
        webix.ajax().post(url, data, {
            success: function(text, data){
                data = data.json();
                if (data.error && data.error.length>0) {
                    webix.message({ type:"error", text:Array.isArray(data.error)?data.error.join("<br>"):data.error });
                } else {
                    webix.message(data.message?data.message:"Изменения сохранены");
                }
                if (cb) cb(data);
            }
        });
    }

    function _load(url, cb) {
        var that = this;
        webix.ajax().get(url, {
            success: function(text, data){
                data = data.json();
                if (data.error && data.error.length>0) {
                    webix.message({ type:"error", text:Array.isArray(data.error)?data.error.join("<br>"):data.error });
                }
                if (cb) cb(data);
            }
        });
    }


    function _post(url, postData, cb){
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

    function _remove(url, data, cb){
        webix.confirm({
            text:"Вы уверены?", ok:"Да", cancel:"Отмена",
            callback:function(res){
                if(res) {
                    _save(url, data, cb);
                }
            }
        });
        return false;
    }

    return {
        save:_save,
        remove:_remove,
        load:_load,
        post:_post
    }
});