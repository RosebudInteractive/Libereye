define(function(){

return {
	$ui:{
		view: "submenu",
		id: "profilePopup",
		width: 200,
		padding:0,
        click:function(id){
            switch(id) {
                case "1":
                    document.location = '/adminw/#!/app/shops';
                    break;
                case "2":
                    document.location = '/admin/logout.php';
                    break;
            }
        },
		data: [
			{id: 1, icon: "tasks", value: "Админка", hidden:USER.status == 'admin'},
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