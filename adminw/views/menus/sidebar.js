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
					//hidden: true,
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
                            var item = this.getItem(id), params='';
                           /* if (item.params) {
                                params = '/'+item.params.replace(/^[\/]+/g, '');
                            } else {
                                  var re = new RegExp('\!\/app\/'+id+'(.*)'), match = window.location.hash.substr(1).match(re);

                                    if (match)
                                        params = match[1];
                                $$('app:menu').getItem('schedule').params = params;
                                $$('app:menu').getItem('sellers').params = params;
                                $$('app:menu').getItem('slots').params = params;
                                $$('app:menu').getItem('shopbrands').params = params;
                            }*/

							this.$scope.show("./"+id+params);
                            if (params == '')
							    webix.$$("title").parse({title: item.value, details: item.details});
						}
					},
					data:[
						//{id: "main", value: "Объекты", open: true, data:[
							{ id: "shops", value: "Магазины", icon: "home",   $css: "dashboard", details:"Управление магазинами"},
							{ id: "accounts", value: "Пользователи", icon: "male",  $css: "dashboard", details:"Управление пользователями"},
							{ id: "brands", value: "Бренды", icon: "folder-open-o",  $css: "brands", details:"Управление брендами"},
                            { id: "phrases", value: "Переводы", icon: "check-square-o",  $css: "phrases", details:"Перевод фраз"},
                            { id: "countries", value: "Страны", icon: "list-alt",  $css: "countries", details:"Управление странами"},
                            { id: "currencies", value: "Валюты", icon: "bar-chart-o",  $css: "countries", details:"Управление валютами"},
                            { id: "timezones", value: "Временные зоны", icon: "calendar",  $css: "timezones", details:"Управление временными зонами"},
                            { id: "news", value: "Новости", icon: "pencil-square-o",  $css: "news", details:"Управление новостями"},
                            { id: "settings", value: "Настройки", icon: "tasks",  $css: "settings", details:"Управление настройками"},
							{ id: "boxes", value: "Коробки", icon: "cube",  details:"Управление коробками доставки товаров"},
							{ id: "regions", value: "Регионы", icon: "map-marker",  $css: "orders", details:"Регионы"},
							{ id: "carriers", value: "Перевозчики", icon: "sliders",  $css: "sliders", details:"Перевозчики"},
							{ id: "templates", value: "Шаблоны", icon: "file-text-o",  $css: "templates", details:"Шаблоны"}/*,
							{ id: "products", value: "Products", icon: "cube",  $css: "products", details:"all products"},
							{ id: "product_edit", value: "Product Edit", icon: "pencil-square-o", details: "changing product data"}*/
                      //  ]},
						//{id: "shopmenu", value: "Управление магазином", open: true, data:[
							/*{ id: "schedule", hidden:true, value: "Расписание", icon: "calendar",  $css: "calendar", details:"Управление расписанием", shop:true},
							{ id: "sellers", value: "Шопперы", icon: "male",  $css: "male", details:"Управление шопперами", shop:true},
							{ id: "slots", value: "Слоты", icon: "list-alt",  $css: "list-alt", details:"Управление слотами", shop:true},
							{ id: "shopbrands", value: "Бренды", icon: "cube",  $css: "cube", details:"Управление брендами", shop:true}*/
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
