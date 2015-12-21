Ext.require([
	'Ext.selection.CellModel',
    'Ext.form.*',
    'Ext.data.*',
    'Ext.grid.*',
    'Ext.util.*'
]);

Ext.onReady(function() {
	
	if (!Ext.ModelManager.isRegistered('Items')){
		Ext.define('Items', {
	        extend: 'Ext.data.Model',
	        idProperty: 'news_id',
	        fields: [
	            {name: 'news_id', type: 'int'},
	            {name: 'title', type: 'string'},
	            {name: 'cdate', type: 'date'}
	        ]    
	    });
	}
	
	var sm = new Ext.selection.CheckboxModel( {
        listeners:{
            selectionchange: function(selectionModel, selected, options){
                // Bunch of code to update store
            }
        }
    });

	
	// create the Data Store
	var extraParams = {field:'', query:'', subact:'search'};
    var store = Ext.create('Ext.data.Store', {
        model: 'Items',
        id: 'taskStore',
        autoLoad: true,
        autoSync: true,
        proxy: {
            type: 'ajax',
            api: {
                read: '/admin/index.php/part_news/act_get',
                create: '/admin/index.php/part_news/act_create',
                update: '/admin/index.php/part_news/act_update',
                destroy: '/admin/index.php/part_news/act_destroy'
            },
            reader: {
                type: 'json',
                root: 'data',
                idProperty: 'news_id',
                totalProperty: 'total'
            },
            writer: {
                type: 'json',
                writeAllFields: false,
                root: 'data'
            },
        	extraParams: extraParams
        },
        listeners: {
            write: function(proxy, operation){
            	for(var i in operation.records) {
            		operation.records[i].commit();
            	}
            }
        },
        remoteSort: true,
        sorters: [{
            property: 'news_id',
            direction: 'DESC'
        }],
        pageSize: 100
    });
    
    var cellEditing = new Ext.grid.plugin.CellEditing({
            clicksToEdit: 1
        });


	// create the Grid
    var gridItems = Ext.create('Ext.grid.Panel', {
    	title: 'Новости',
        store: store,
        id:'brandsGrid',
        selModel: sm,
        columnLines: true,
        markDity: false,
       // plugins: aLoginUserData.status!='manager'?[cellEditing]:[],
        columns: [
            {
            	width    : 60,
                text     : '№',
                dataIndex: 'news_id'
            },
            {
                text     : 'Заголовок',
                width    : 400,
                flex:  1,
                dataIndex: 'title',
                editor: {
                    allowBlank: false
                }
            }
        ],
       
        width: '100%',
        height: $(window).height()-165,
        frame: true,
        renderTo: 'news',
        dockedItems: [
        	{
	            dock: 'top',
	            xtype: 'toolbar',
	            items: [{
	                xtype: 'label',
	                text: '»',
	                margins: '0 10 0 8'
	                
	            },{
	                xtype: 'button',
	                text: 'Удалить',
	                handler: function(){
	                	if (confirm('Точно удалить?')) {
		                	var records = sm.getSelection();
		                	var ids = [];
				            Ext.each(records, function (record) {
				                ids[ids.length] = record.get('news_id');
				            });
				            store.load({params:{'subact':'del', 'ids':ids.join(',')}});
	                	}
	                },
	                hidden: aLoginUserData.status=='manager'
	            }, {
	                xtype: 'combobox',
	                id:'searchField',
	                queryMode: 'local',
	                margins: '0 0 0 20',
	               	store: Ext.create('Ext.data.Store', {
					    fields: ['abbr', 'name'],
					    data : [
					         {"abbr":"n.title","name":"Заголовок"},
					         {"abbr":"с.title","name":"Город"}
					    ]
					}),
					displayField: 'name',
    				valueField: 'abbr',
	                fieldLabel: 'Поиск',
	                width:170,
	                labelWidth:40,
	                editable:false,
	                value:'p.title'
	            },{
	                xtype: 'textfield',
	                width:370,
	                id:'searchQuery',
                            listeners: {
					            specialkey: function(f,e){
					                if(e.getKey() == e.ENTER){
					                    Ext.getCmp('searchButton').handler.call();
					            }
					            }
					        }
	            },{
	                xtype: 'button',
	                text: 'Найти',
	                handler: function(){
	                	store.getProxy().extraParams = {'subact':'search', 'field':Ext.getCmp('searchField').getValue(), 'query':Ext.getCmp('searchQuery').getValue()};
	                	//extraParams = {'subact':'search', 'field':Ext.getCmp('searchField').getValue(), 'query':Ext.getCmp('searchQuery').getValue()};
			            store.load();
	                },
	                id:'searchButton'
	            },{
	                xtype: 'button',
	                text: 'Смотреть все',
	                handler: function(){
	                	Ext.getCmp('searchQuery').setValue(''); 
	                	store.getProxy().extraParams = {'subact':'search', 'field':Ext.getCmp('searchField').getValue(), 'query':Ext.getCmp('searchQuery').getValue()};
			            store.load();
	                },
	                id:'searchAllButton'
	            }, {
	                xtype: 'label',
	                text: ' ',
	                margins: '0 20 0 20'
	                
	            },'->',{
	                xtype: 'combobox',
	                queryMode: 'local',
	               	store: Ext.create('Ext.data.Store', {
					    fields: ['abbr', 'name'],
					    data : [
					         {"abbr":"100","name":"100"},
					         {"abbr":"200","name":"200"},
					         {"abbr":"500","name":"500"},
					         {"abbr":"1000","name":"1000"}
					    ]
					}),
					listeners:{
					  change:function(combo, ewVal, oldVal) {
					  		Ext.getCmp('brandsGrid').getStore().pageSize = ewVal;
					  		store.load();
					  }
					},
					displayField: 'name',
    				valueField: 'abbr',
	                fieldLabel: 'Показать',
	                width:140,
	                labelWidth:55,
	                editable:false,
	                value:'100'
	            }]
        	}, 
            Ext.create('Ext.toolbar.Paging', {
            dock: 'bottom',
            displayInfo: true,
            store: store
        }), 
            Ext.create('Ext.toolbar.Paging', {
            dock: 'top',
            displayInfo: true,
            store: store
        })],
        listeners : {
		    itemdblclick: function(dv, record, item, index, e) {
		    	document.location = '/admin/index.php/part_news/sect_news_edit/id_'+record.raw.news_id;
		    }
		}
    });
});

function findPrice(id){
	Ext.getCmp('searchField').setValue('r.rubric_id'); 
	Ext.getCmp('searchQuery').setValue(id); 
	Ext.getCmp('searchButton').handler.call();
}