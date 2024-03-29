define([], function(){

	function select_menu(menu_id, id){
		var menu = $$(menu_id);
		if (menu.setValue)
			menu.setValue(id);
		else if (menu.select && menu.exists(id))
			menu.select(id);
	}

	function get_menu(scope){
		if (scope.parent)
			return scope.parent.module.$menu || get_menu(scope.parent);
	}

	return {
		$onurlchange:function(ui, name, url, scope){
			//menu handling
			if (ui.$menuid){
				var id = ui.$menuid.call ? ui.$menuid.call(ui, ui, name, url) : ui.$menuid;
				var menu = get_menu(scope);
				if (menu && id)
					select_menu(menu, id);
			}

            // меню магазина
            /*if ($$('app:menu')) {
             var m = $$('app:menu');
             if (name.page=='schedule' || name.page=='sellers' || name.page=='slots' || name.page=='shopbrands') {

             //                    $$('app:menu').getItem('schedule').p

             m.data.each(function(obj){
             if(obj.id && m.getItemNode(obj.id))
             m.getItemNode(obj.id).parentNode.style.display =  obj.shop?'':'none';
             });
             } else {
             m.data.each(function(obj){
             if(obj.id && m.getItemNode(obj.id))
             m.getItemNode(obj.id).parentNode.style.display =  obj.shop?'none':'';
             });
             }

             }*/

		},

		$onui:function(ui, name, url, scope){
			//menu handling
			if (ui.$menu && url.length)
				select_menu(ui.$menu, url[0].page)
		}
	}
});