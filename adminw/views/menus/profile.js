define(function(){

return {
	$ui:{
		view: "submenu",
		id: "profilePopup",
		width: 200,
		padding:0,
        click:function(id){
            switch(id) {
                case "2":
                    document.location = '/admin/logout.php';
                    break;
            }
            console.log(arguments);
        },
		data: [
			/*{id: 1, icon: "user", value: "My Profile"},
			{id: 2, icon: "cog", value: "My Account"},
			{id: 3, icon: "calendar", value: "My Calendar"},*/
			//{id: 1, icon: "tasks", value: "Админка", hidden:USER.status != 'admin'},
            //{ $template:"Separator" },
			{id: 2, icon: "sign-out", value: "Выход"}
		],
		type:{
			template: function(obj){
				if(obj.type)
					return "<div class='separator'></div>";
				return "<span class='webix_icon alerts fa-"+obj.icon+"'></span><span>"+obj.value+"</span>";
			}
		}

	}
};

});