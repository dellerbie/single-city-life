GalleryIndexView = Ext.extend(Ext.DataView, {
    id: 'gallery-data-view',
    autoHeight: true,
    singleSelect: true,
    overClass: 'photo-over',
    itemSelector: 'li.photo',
    emptyText: '<span class="emptyText">You have not uploaded any photos yet.  Single people REALLY dig photos. You should get to uploading.</span>',
    
    initComponent: function() {
        GalleryIndexView.superclass.initComponent.apply(this, arguments);
        this.on('selectionchange', this.onSelectionChange, this);
    },
    
    onSelectionChange: function(view, selections) {
	    var selectedIndex = view.getSelectedIndexes()[0];
		if(!this.photoBrowser) {
			this.photoBrowser = new PhotoBrowser({
                tbar: [{
                    text: 'Delete Photo',
                    handler: function() {
                        Ext.Msg.confirm('Delete Photo?', "Are you sure want to delete this photo?", function(btnId) {
                            if(btnId == 'yes') {
                                var records = this.getSelectedRecords();
                                if(records) {
                                    var record = records[0];
                                    Ext.Ajax.request({
                                        url: '/users/' + this.userId + '/photos/' + record.data.id + ".json",
                                        method: 'POST',
                                        params: {
                                            "_method": "delete",
                                            authenticity_token: this.authenticity_token
                                        },
                                        success: function(response) {
                                            this.store.remove(record);
                                            if(this.store.getCount() > 0) {
                                                this.select(0);
                                            }
                                        },
                                        failure: function(response) {
                                            Ext.Msg.alert('Error Deleting Photo', 
                                                'Could not delete your photo at this time.  Please try again later');
                                        },
                                        scope: this
                                    });
                                }
                            }
                        }, this);
                    },
                    scope: view
                },{
                    text: 'Set as Default',
                    handler: function() {
                    }
                }],
                store: this.store,
                thumbTemplate: this.tpl
            });
        }
        this.photoBrowser.show();
        this.photoBrowser.imagesView.select(selectedIndex);
	}
});