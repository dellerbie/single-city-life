Ext.BLANK_IMAGE_URL = '/javascripts/ext-2.2/resources/images/default/s.gif';

Ext.onReady(function() {	
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
	
	usersStore.load({params: {page: 1, limit: 10, authenticity_token: AUTH_TOKEN, start: 0}});
	
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
					'<a class="show-more-photos" href="#">',
						'<img class="articleImage" src="{default_photo}">',
					'</a>',
					'<a href="#" class="more show-more-photos">View Photos ({n_photos})</a>',
				'</tpl>',
				'<tpl if="has_photos == false">',
					'<img class="articleImage" src="{default_photo}">',
				'</tpl>',
			'</div>',
			'<div class="summary">',
				'<div class="info">',
					'<span class="name">{login},</span>',
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
		emptyText: 'Loading users...'
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
	
	var profiles = Ext.get('profiles');
	profiles.on('click', function(e, t) {
		var target = e.getTarget('a.show-more-photos');
		if(target) {
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
		}
	});
});