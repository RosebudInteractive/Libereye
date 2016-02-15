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
                            if (item.params) {
                                params = '/'+item.params.replace(/^[\/]+/g, '');
                            } else {
                                  var re = new RegExp('\!\/appshop\/'+id+'(.*)'), match = window.location.hash.substr(1).match(re);

                                    if (match)
                                        params = match[1];
                                $$('app:menu').getItem('schedule').params = params;
                                $$('app:menu').getItem('sellers').params = params;
                                $$('app:menu').getItem('slots').params = params;
                                $$('app:menu').getItem('shopbrands').params = params;
                            }

							this.$scope.show("./"+id+params);
                            if (params == '')
							    webix.$$("title").parse({title: item.value, details: item.details});
						}
					},
					data:[

							{ id: "schedule", hidden:true, value: "Расписание", icon: "calendar",  $css: "calendar", details:"Управление расписанием", shop:true},
							{ id: "sellers", value: "Шопперы", icon: "male",  $css: "male", details:"Управление шопперами", shop:true},
							{ id: "slots", value: "Слоты", icon: "list-alt",  $css: "list-alt", details:"Управление слотами", shop:true},
							{ id: "shopbrands", value: "Бренды", icon: "cube",  $css: "cube", details:"Управление брендами", shop:true}

					]
				}
			]
		}
	};

});
