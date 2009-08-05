Ext.BLANK_IMAGE_URL = '/javascripts/ext-2.2/resources/images/default/s.gif';

Ext.onReady(function() {	
	
	var photoBrowser;
	
	var store = new Ext.data.JsonStore({
	    root: 'photos',
	    fields: ['thumb', 'title', 'full', 'tiny', 'id']
	});
	
	var morePhotosLinks = Ext.select('.profile .img a');
	morePhotosLinks.each(function(el) {
		el.on('click', function() {
			var userId = Ext.select('.summary .info .name').first().dom.innerHTML;
			store.proxy.conn.url = "/users/" + userId + "/photos/for_user.json";
			store.load();
			
			if(!photoBrowser) {
				photoBrowser = new PhotoBrowser({
					title: userId + ' Photos',
					store: store
				});
			}
			photoBrowser.show();
			
			store.on('load', function() {
				photoBrowser.imagesView.select(0);
			});
			
		});
	});
});