define(function(){
	
	return {
		$ui:{
			width: 200,

			rows:[
				{
					view: "tree",
					id: "app:menu",
					type: "menuTree2",
					css: "menu",
					activeTitle: true,
					select: true,
					tooltip: {
						template: function(obj){
							return obj.$count?"":obj.details;
						}
					},
					on:{
						onBeforeSelect:function(id){
							if(this.getItem(id).$count){
								debugger;
								return false;
							}
							
						},
						onAfterSelect:function(id){
							this.$scope.show("./"+id);
							var item = this.getItem(id);
							webix.$$("title").parse({title: item.value, details: item.details});
						}
					},
					data:[
						//{id: "main", value: "Объекты", open: true, data:[
							{ id: "shops", value: "Магазины", icon: "home", $css: "dashboard", details:"Управление магазинами"},
						//	{ id: "shopmanage/:id", value: "Управление магазинином", icon: "shopmanage", $css: "shopmanage", details:"Управление магазинами"},
							{ id: "brands", value: "Бренды", icon: "cube", $css: "brands", details:"Управление брендами"},
                            { id: "phrases", value: "Переводы", icon: "check-square-o", $css: "phrases", details:"Перевод фраз"},
                            { id: "countries", value: "Страны", icon: "list-alt", $css: "countries", details:"Управление странами"},
                            { id: "currencies", value: "Валюты", icon: "bar-chart-o", $css: "countries", details:"Управление валютами"},
                            { id: "timezones", value: "Временные зоны", icon: "calendar", $css: "timezones", details:"Управление временными зонами"},
                            { id: "news", value: "Новости", icon: "pencil-square-o", $css: "news", details:"Управление новостями"},
                            { id: "settings", value: "Настройки", icon: "tasks", $css: "settings", details:"Управление настройками"}/*,
							{ id: "dashboard", value: "Dashboard", icon: "home", $css: "dashboard", details:"reports and statistics"},
							{ id: "orders", value: "Orders", icon: "check-square-o", $css: "orders", details:"order reports and editing"},
							{ id: "products", value: "Products", icon: "cube", $css: "products", details:"all products"},
							{ id: "product_edit", value: "Product Edit", icon: "pencil-square-o", details: "changing product data"}*/
                        /*]},
						{id: "components", open: true, value:"Components", data:[
							{ id: "datatables", value: "Datatables", icon: "table", details: "datatable examples" },
							{ id: "charts", value: "Charts", icon: "bar-chart-o", details: "charts examples"},
							{ id: "forms", value: "Forms", icon: "list-alt", details: "forms examples"}

						]},
						{id: "uis", value:"UI Examples", open:1, data:[
							{ id: "calendar", value: "My Calendar", icon: "calendar", details: "calendar example" },
							{ id: "files", value: "File Manager", icon: "folder-open-o", details: "file manager example" }

						]}*/
					]
				}
			]
		}
	};

});
