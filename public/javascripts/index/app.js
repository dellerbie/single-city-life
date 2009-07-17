Ext.BLANK_IMAGE_URL = '/javascripts/ext-2.2/resources/images/default/s.gif';

Ext.onReady(function() {	
	Ext.History.init();
	var tokenDelimeter = ':';
	
	var FIND_BY_LOGIN_URL = '/find_by_login';
	var FILTER_URL = '/filter';
	
	var usersStore = new Ext.data.JsonStore({
		url: '/.json',
		root: 'users',
		totalProperty: 'totalCount',
		fields: [
			{name: 'login'},
			{name: 'age'},
			{name: 'best_feature'},
			{name: 'loves_when'},
			{name: 'hates_when'},
			{name: 'turn_ons'},
			{name: 'turn_offs'},
			{name: 'msg_me_if'},
			{name: 'default_photo'},
			{name: 'has_photos', type: 'boolean'},
			{name: 'n_photos', type: 'int'}
		]
	});
	
	usersStore.load({
		params: {
			page: 1,
			limit: 10, 
			authenticity_token: AUTH_TOKEN,
			start: 0	
		}
	});
	
	var paginator = new Ext.PagingToolbar({
		pageSize: 10,
		store: usersStore,
		listeners: {
			beforechange: function(paginator, params) {
				params['authenticity_token'] = AUTH_TOKEN;
				params['page'] = Math.floor(params.start / params.limit) + 1;
				paginator.store.load({params:params});
				return false;
			}
		}
	});
	
	var userTpl = new Ext.XTemplate(
		'<tpl for=".">',
		'<li class="profile">',
			'<div class="img">',
				'<tpl if="has_photos == true">',
					'<a class="show-pics" href="#">',
						'<img src="{default_photo}">',
					'</a>',
					'<div class="actions">',
						'<a href="#" class="show-pics">Pics ({n_photos})</a>',
						'<span class="separator">|</span>',
						'<a href="#" class="send-msg">Msg</a>',
					'</div>',
				'</tpl>',
				'<tpl if="has_photos == false">',
					'<img src="{default_photo}">',
				'</tpl>',
			'</div>',
			'<div class="summary">',
				'<div class="info">',
					'<span class="name">{login}</span>,',
					'<span class="age">{age}</span>',
				'</div>',			
				'<ul class="facts">',
					'<li>Best feature is {best_feature}</li>',
					'<li>Loves when {loves_when}</li>',
					'<li>Hates when {hates_when}</li>',
				'</ul>',
			'</div>',
			'<div class="moreInfo">',
				'<div class="info">',
					'<h3>Turn Ons:</h3>',
					'<p>{turn_ons}</p>',
				'</div>',
				'<div class="info">',
					'<h3>Turn Offs:</h3>',
					'<p>{turn_offs}</p>',
				'</div>',
				'<div class="info">',
					'<h3>Msg Me If:</h3>',
					'<p>{msg_me_if}</p>',
				'</div>',
			'</div>',
		'</li>',
		'</tpl>'
	);
	
	var dataView = new Ext.DataView({
		store: usersStore,
		tpl: userTpl,
		itemSelector: 'li.profile',
		overClass: 'profile-view-over',
		singleSelect: true,
		emptyText: 'No users to show you.'
	});
	
	var panel = new Ext.Panel({
		border: false,
		items: [dataView],
		bbar: paginator,
		renderTo: Ext.get('profiles')
	});
	
	/// REFACTOR to reuse same code in profile/show.js ///
	var photoBrowser;
	var photoBrowserStore = new Ext.data.JsonStore({
	    root: 'photos',
	    fields: ['thumb', 'title', 'full', 'tiny', 'id']
	});
	
	var sendMsgWindow;
	var sendMsgForm = new Ext.form.FormPanel({
		frame: true,
		autoHeight: true,
	 	labelAlign: 'right',
		url: '',
		bodyStyle: 'text-align: left',
		buttonAlign: 'right',
		items:[{
			xtype: 'fieldset',
			title: 'Compose Message',
			autoHeight: true,
			defaultType: 'textfield',
			defaults: {
				anchor: '100%'
			},
		    items: [{
				fieldLabel: 'Subject',
				name: 'subject',
				fieldClass: 'mediumFont'
			},{
				xtype: 'textarea',
				fieldLabel: 'Message',
				name: 'message'
			}]
		}],
		buttons: [{
		    text: 'Send',
			handler: function() {
				sendMsgWindow.close();
			}
	    },{
		    text: 'Cancel',
			handler: function() {
				sendMsgWindow.close();
			}
	    }]	
	});
	
	var profiles = Ext.get('profiles');
	profiles.on('click', function(e, t) {
		if(e.getTarget('a.show-pics')) {
			var profile = e.getTarget('.profile', 10, true);
			var login = profile.select('.summary .info .name').first();
			var userId = login.dom.innerHTML;
			photoBrowserStore.proxy.conn.url = "/users/" + userId + "/photos.json";
			photoBrowserStore.load();
			
			if(!photoBrowser) {
				photoBrowser = new PhotoBrowser({
					title: userId + ' Photos',
					store: photoBrowserStore
				});
			}
			photoBrowser.show();
			
			photoBrowserStore.on('load', function() {
				photoBrowser.imagesView.select(0);
			});
		} else if(e.getTarget('a.send-msg')) {
			if(!sendMsgWindow) {
				sendMsgWindow = new Ext.Window({
					title: 'Send A Message',
				    closable: true,
					closeAction: 'hide',
					resizable: false,
					draggable: false,
				    layout: 'fit',
					width: 450,
				    modal: true,
				    items: sendMsgForm
				});
			}
			sendMsgWindow.show();
		}
	});
	
	Ext.get('filtersForm').on('submit', function(e) {
		e.preventDefault();
		var params = Ext.Ajax.serializeForm('filtersForm');
		
		Ext.History.add(FILTER_URL + tokenDelimeter + params);
	
		params = Ext.urlDecode(params);
		Ext.apply(params, {
			page: 1,
			start: 0,
			limit: 10,
			authenticity_token: AUTH_TOKEN
		});
		usersStore.proxy.conn.url = FILTER_URL;
		usersStore.load({
			params: params
		});
	});
	
	Ext.get('usernameForm').on('submit', function(e) {
		e.preventDefault();
		var params = Ext.Ajax.serializeForm('usernameForm');
		
		Ext.History.add(FIND_BY_LOGIN_URL + tokenDelimeter + params);
		
		params = Ext.urlDecode(params);
		Ext.apply(params, {
			page: 1,
			start: 0,
			limit: 10,
			authenticity_token: AUTH_TOKEN
		});
		usersStore.proxy.conn.url = FIND_BY_LOGIN_URL;
		usersStore.load({
			params: params
		});
	});
	
	Ext.History.on('change', function(token) {
		if(token) {
			var parts = token.split(tokenDelimeter);
			var url = parts[0];
			var params = Ext.urlDecode(parts[1]);
			Ext.apply(params, {
				page: 1,
				start: 0,
				limit: 10,
				authenticity_token: AUTH_TOKEN
			});
			usersStore.proxy.conn.url = url;
			usersStore.load({
				params: params
			});
		} else {
			usersStore.load({
				params: {
					page: 1,
					limit: 10, 
					authenticity_token: AUTH_TOKEN,
					start: 0	
				}
			});
		}
	});
	
});