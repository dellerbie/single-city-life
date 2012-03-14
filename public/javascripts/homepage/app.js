Ext.BLANK_IMAGE_URL = '/javascripts/ext-2.2/resources/images/default/s.gif';

Ext.onReady(function() {	
	var usersStore = new Ext.data.JsonStore({
		url: '/.json',
		root: 'users',
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
	usersStore.load();
	
	var userTpl = new Ext.XTemplate(
		'<tpl for=".">',
		'<li class="profile">',
			'<div class="img">',
				'<a href="#" onclick="javascript:void(0);">',
					'<img class="articleImage" src="{default_photo}">',
				'</a>',
				'<tpl if="has_photos == true">',
					'<a class="more" href="#" onclick="javascript:void(0);">View Photos ({n_photos})</a>',
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
		renderTo: Ext.get('profiles'),
		itemSelector: '',
		singleSelect: true,
		emptyText: 'Loading users...'
	});
});