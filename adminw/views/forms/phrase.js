define(['helpers/record', 'helpers/grid'], function(record, grid){

    var data = "";

    function _setData(item) {
        data = item;
        $$('phrase-form').setValues({id:item.phrase_id}, true);
        $$('phrase-win').getHead().setHTML(item.phrase_id==0?'Добавить фразу':'Редактирование фразы');
        $$('save-phrase-btn').setValue(item.phrase_id==0?'Добавить':'Сохранить');$$('save-phrase-btn').refresh();
        $$('phrase-form').clearValidation();

        $$('alias').setValue(data.alias?data.alias:'');
        $$('def_phrase').setValue(data.def_phrase?data.def_phrase:'');
        for(var i in LANGUAGES) {
            $$('lang'+LANGUAGES[i].language_id).setValue(data.phrase && data.phrase[LANGUAGES[i].language_id]?data.phrase[LANGUAGES[i].language_id]:'');
        }
    }

    var form = {
        view:"window", modal:true, id:"phrase-win", position:"center", width:600,
        head:"Добавить фразу",
        body:{
            paddingY:20, paddingX:30, elementsConfig:{labelWidth: 140}, view:"form", id:"phrase-form", elements:[
                {
                    "rows": [{
            id: "phrase-form",
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

    for(var i in LANGUAGES) {
        form.body.elements[0].rows[0].elements[0].rows.push({ view:"textarea", label:LANGUAGES[i].title, height:80, name:'aLang['+LANGUAGES[i].language_id+']', id:'lang'+LANGUAGES[i].language_id })
    }
    form.body.elements[0].rows[0].elements[0].rows.push({
        "margin": 5,
        "cols": [
            {},
            { view:"button", id:"save-phrase-btn", type:"form", value: "Сохранить", click:function(){
                var that = this;
                if ($$("phrase-form").validate()) {
                    record.save("/admin/index.php/part_phrases/act_create", $$('phrase-form').getValues(), function(data){
                        if (!data.error || data.error.length==0) {
                            that.getTopParentView().hide();
                            grid.refresh($$('grid-phrase'), '/admin/index.php/part_phrases/act_get');
                        }
                    });
                }
            }},
            { view:"button", value:"Отмена", click:function(){
                this.getTopParentView().hide(); //hide window
            }}
        ]
    });

	return {
        setData:_setData,
		$ui:form
	};

});