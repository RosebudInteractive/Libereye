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
	        idProperty: 'booking_id',
	        fields: [
	            {name: 'booking_id', type: 'int'},
	            {name: 'fname', type: 'string'},
	            {name: 'email', type: 'string'},
	            {name: 'seller', type: 'string'},
	            {name: 'seller_email', type: 'string'},
	            {name: 'fromdate', type: 'string'},
	            {name: 'todate', type: 'string'},
	            {name: 'status', type: 'string'},
	            {name: 'cdate', type: 'string'},
	            {name: 'udate', type: 'string'}
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
                read: '/admin/index.php/part_bookings/act_get',
                create: '/admin/index.php/part_bookings/act_create',
                update: '/admin/index.php/part_bookings/act_update',
                destroy: '/admin/index.php/part_bookings/act_destroy'
            },
            reader: {
                type: 'json',
                root: 'data',
                idProperty: 'booking_id',
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
            property: 'booking_id',
            direction: 'DESC'
        }],
        pageSize: 100
    });
    
    var cellEditing = new Ext.grid.plugin.CellEditing({
            clicksToEdit: 1
        });


	// create the Grid
    var gridItems = Ext.create('Ext.grid.Panel', {
    	title: 'Бронирования',
        store: store,
        id:'bookingsGrid',
        selModel: sm,
        columnLines: true,
        markDity: false,
        columns: [
            {
            	width    : 60,
                text     : '№',
                dataIndex: 'booking_id'
            },
            {
                text     : 'Покупатель',
                width    : 150,
                dataIndex: 'fname'
            },
            {
                text     : 'Email покупателя',
                width    : 150,
                dataIndex: 'email'
            },
            {
                text     : 'Продавец',
                width    : 150,
                dataIndex: 'seller'
            },
            {
                text     : 'Email продавца',
                width    : 150,
                dataIndex: 'seller_email'
            },
            {
                text     : 'Начало митинга',
                width    : 150,
                dataIndex: 'fromdate'
            },
            {
                text     : 'Конец мининга',
                width    : 150,
                dataIndex: 'todate'
            },
            {
                text     : 'Дата создания',
                width    : 150,
                dataIndex: 'cdate'
            },
            {
                text     : 'Дата обновления',
                width    : 150,
                flex:  1,
                dataIndex: 'udate'
            }
        ],
       
        width: '100%',
        height: 600,
        frame: true,
        renderTo: 'bookings',
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
				                ids[ids.length] = record.get('booking_id');
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
					         {"abbr":"fname","name":"Имя"},
					         {"abbr":"email","name":"Email"},
					         {"abbr":"status","name":"Роль"}
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
		    /*itemdblclick: function(dv, record, item, index, e) {
		    	document.location = '/admin/index.php/part_bookings/sect_booking_edit/id_'+record.raw.booking_id;
		    }*/
		}
    });
});

function findPrice(id){
	Ext.getCmp('searchField').setValue('r.rubric_id'); 
	Ext.getCmp('searchQuery').setValue(id); 
	Ext.getCmp('searchButton').handler.call();
}