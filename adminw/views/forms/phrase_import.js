define([], function(){

    var form = {
        view:"window", modal:true, id:"phrase-win", position:"center", width:600,
        head:"Импорт фраз",
        body:{
            paddingY:20, paddingX:30, elementsConfig:{labelWidth: 140}, view:"form", id:"phrase-form", elements:[
                {
                    "rows": [{
            id: "phrase-import-form",
            view:"form",
            width:600,
            borderless:true,
            elements: [ {rows : [
                { view:"text", label:'Alias', name:"aPhrase[alias]",required:true, invalidMessage: "Поле обязательное", id:"alias" },
                { view:"text", label:'По умолчанию', name:"aPhrase[def_phrase]", id:"def_phrase" }
            ]}
            ],

            elementsConfig:{
                labelWidth:110
            }
        }

                    ]
                }

            ]
        }
    }



	return {
		$ui:form
	};

});