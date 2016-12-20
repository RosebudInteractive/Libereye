define(['helpers/record', 'helpers/grid'], function(record, grid){

    var data = "";

    function _setData(item) {
        data = item;
        $$('news-win').getHead().setHTML(item.news_id==0?'Добавить новость':'Редактирование новости');
        $$('save-news-btn').setValue(item.news_id==0?'Добавить':'Сохранить');$$('save-news-btn').refresh();
        $$('news-form').clearValidation();
        $$('doclist').clearAll();
        $$('image').setValues({src:item.image && item.image!=""?('/images/news/'+item.image):null});
        $$('news-form').setValues({id:item.news_id}, true);

        var translated = ['title', 'annotation', 'full_news'];
        for(var i in LANGUAGES) {
            for(var j in translated) {
                var value = data[translated[j]] && data[translated[j]][LANGUAGES[i].language_id] ? data[translated[j]][LANGUAGES[i].language_id] : '';
                $$(translated[j]+LANGUAGES[i].language_id).setValue(value);
            }
        }
    }

    var form = {
        view:"window", modal:true, id:"news-win", position:"center", width:600,
        head:"Добавить новость",
        body:{
            paddingY:20, paddingX:30, elementsConfig:{labelWidth: 140}, view:"form", id:"news-form", elements:[
                {
                    "rows": [
                        {cols:[
                            {template:'Картинка:', width:100,borderless:true},
                            {template:function (obj) {
                                // obj is a data record object
                                if (obj.src)
                                    return '<a href="'+obj.src+'" target="_blank"><img src="'+obj.src+'" height="30"/></a>';
                                else
                                    return 'нет';
                            }, id:'image', width:100,borderless:true},
                            { view:"list", scroll:false, id:"doclist", type:"uploader", borderless:true },{
                                view:"uploader", upload:"/admin/index.php/part_shops/act_upload/type_news/",
                                id:"files", name:"files",
                                value:"Выбрать",
                                link:"doclist",
                                autosend:false, //!important
                                sync: false, width:100, multiple:false,borderless:true
                            }]},
                        {
                            "template": "<div style=\"border-top:1px solid #ddd\"></div>",
                            "borderless": true,
                            "height": 10
                        },
                        {
                            "id": "tabbar",
                            "view": "tabbar",
                            "multiview": true,
                            "animate": {
                                "type": "flip",
                                "subtype": "vertical"
                            },
                            "options": [
                            ]
                        },
                        {
                            "cells": [
                            ]
                        },
                        {
                            "margin": 5,
                            "cols": [
                                {},
                                { view:"button", id:"save-news-btn", type:"form", value: "Сохранить", click:function(){
                                    var that = this;
                                    $$("files").send(function(){ //sending files
                                        var images = [];
                                        $$("files").files.data.each(function(obj){
                                            var status = obj.status;
                                            if(status=='server' && obj.id!="0") {
                                                images.push(obj.id);
                                            }
                                        });
                                        var data = $$('news-form').getValues();
                                        data.images = images.join(',');
                                        if ($$("news-form").validate()) {
                                            record.save("/admin/index.php/part_news/act_create", data, function(data){
                                                that.getTopParentView().hide();
                                                grid.refresh($$('grid-news'), '/admin/index.php/part_news/act_get');
                                            });
                                        }
                                    });
                                }},
                                { view:"button", value:"Отмена", click:function(){
                                    this.getTopParentView().hide(); //hide window
                                }}
                            ]
                        }
                    ]
                }

            ]
        }
    }

    for(var i in LANGUAGES) {
        form.body.elements[0].rows[2].options.push({
            "id": "tab"+LANGUAGES[i].language_id,
            "value": LANGUAGES[i].title
        });
        form.body.elements[0].rows[3].cells.push({
            "id": "tab"+LANGUAGES[i].language_id,
            "rows": [
                {
                    "view": "text",
                    "label": "Название",
                    "name": "aNews[title]["+LANGUAGES[i].language_id+"]",
                    "required": true,
                    "invalidMessage": "Поле обязательное",
                    "id": "title"+LANGUAGES[i].language_id
                },
                {
                    "view": "textarea",
                    "label": "Аннотация",
                    "name": "aNews[annotation]["+LANGUAGES[i].language_id+"]",
                    "id": "annotation"+LANGUAGES[i].language_id
                },
                {
                    "view": "textarea",
                    "label": "Новость",
                    "name": "aNews[full_news]["+LANGUAGES[i].language_id+"]",
                    "id": "full_news"+LANGUAGES[i].language_id
                }
            ],
            "show": LANGUAGES[i].is_default ? true : false
        });
    }

	return {
        setData:_setData,
		$ui:form
	};

});