Ext.BLANK_IMAGE_URL = '/javascripts/ext-2.2/resources/images/default/s.gif';

Ext.onReady(function() {
	var swfu = new SWFUpload({
		upload_url : UPLOAD_URL,
		post_params : {
			authenticity_token : AUTH_TOKEN
		},
		flash_url : '/flash/swfupload_f9.swf',
		file_size_limit : '3 MB',
		file_types : '*.jpg',
		file_types_description : 'JPG Images',
		file_upload_limit : '10',
		file_queue_error_handler : SWFUploadHandlers.fileQueueError,
		file_dialog_complete_handler : SWFUploadHandlers.fileDialogComplete,
		upload_progress_handler : SWFUploadHandlers.uploadProgress,
		upload_error_handler : SWFUploadHandlers.uploadError,
		upload_success_handler : SWFUploadHandlers.uploadSuccess,
		upload_complete_handler : SWFUploadHandlers.uploadComplete,
		custom_settings : { 
			upload_target : "fileProgressContainer"
		},
		debug: false
	});
	
	Ext.get('addPhotosBtn').on('click', function() {
		swfu.selectFiles();
	});
	
	var store = new Ext.data.JsonStore({
	    url: '/users/' + USER_ID + '/photos.json',
	    root: 'photos',
	    fields: ['thumb', 'title','full', 'tiny', 'id']
	});
	
	function disableAddBtnIfMaxed() {
		if(store.getCount() >= MAX_PHOTOS) {
			Ext.get('addPhotosBtn').dom.disabled = true;
		}
	}
	
	function updatePhotoCounter() {
		Ext.fly('photoCounter').update(store.getCount() + '/' + MAX_PHOTOS);
	}
	
	store.on('load', function(store, records, opts) {
		disableAddBtnIfMaxed();
		updatePhotoCounter();
	});
	
	store.on('add', function(store, records, index) {
		disableAddBtnIfMaxed();
		updatePhotoCounter();
	});
	
	store.on('remove', function(store, record, index) {
		if(store.getCount() < MAX_PHOTOS) {
			Ext.get('addPhotosBtn').dom.disabled = false;
		}
		updatePhotoCounter();
	});
	
	store.load();

	var tpl = new Ext.XTemplate(
	    '<tpl for=".">',
			'<li class="photo">',
				'<img src="{thumb}" alt="{title}"/>',
			'</li>',
	    '</tpl>'
	);
	
	var galleryIndexView = new GalleryIndexView({
	    renderTo: Ext.select('.gallery').first(),
	    store: store,
	    tpl: tpl,
		authenticity_token: AUTH_TOKEN,
		userId: USER_ID,
		listeners: {
			deletedlastphoto: function() {
				
			}
		}
	});
});