Ext.BLANK_IMAGE_URL = '/javascripts/ext-2.2/resources/images/default/s.gif';

Ext.onReady(function() {	
	
	var photoBrowser;
	
	var store = new Ext.data.JsonStore({
	    url: '/users/' + USER_ID + '/photos.json',
	    root: 'photos',
	    fields: ['thumb', 'title','full', 'tiny', 'id']
	});
	store.load();
	
	var morePhotosLinks = Ext.select('.profile .img a');
	morePhotosLinks.each(function(el) {
		el.on('click', function() {
			if(!photoBrowser) {
				photoBrowser = new PhotoBrowser({
					title: USER_ID + ' Photos',
					store: store
				});
			}
			photoBrowser.show();
			photoBrowser.imagesView.select(0);
		});
	});
});