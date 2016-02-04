define([],function(){

    function _getAll(cb) {

    }

    function _load(id, cb) {
        webix.ajax("/admin/index.php/part_shops/act_load?id="+id, function(text, data){
            data = data.json();
            if (data.error) {
                webix.message({type:"error", text:data.error});
            }
            if (cb) cb(data);
        });
    }

return {
	getAll:_getAll,
	load:_load
};

});