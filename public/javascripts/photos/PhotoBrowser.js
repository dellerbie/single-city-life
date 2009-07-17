PhotoBrowser = Ext.extend(Ext.Window, {
    layout: 'border',
    width: 780,
    height: 700,
    plain: true,
    title: 'Photo Browser',
	closeAction: 'hide',
	modal: true,
	constrain: true,
   
    initComponent: function() {
        PhotoBrowser.superclass.initComponent.apply(this, arguments);
       
        this.initTemplates();
       
        this.imagesView = new Ext.DataView({
            store: this.store,
            tpl: this.thumbTemplate,
            overClass: 'photo-over',
            itemSelector: 'li.photo',
			selectedClass: 'photo-selected',
            singleSelect: true,
            emptyText: 'No photos uploaded.',
            listeners: {
                selectionchange: this.showImageDetails,
                scope: this
            }
        });
       
        this.imagesRegion = {
			id: 'images-region',
            region: 'south',
            split: true,
            height: 150,
            autoScroll: true,
            items: this.imagesView 
        };
       
        this.imageDetailPanel = {
            id: 'img-detail-panel',
            region: 'center',
            width: 300,
            height: 300 
        };
       
        this.add(this.imagesRegion);
        this.add(this.imageDetailPanel);
    },
   
    initTemplates: function() { 
		this.thumbTemplate = new Ext.XTemplate(
			'<ul class="gallery galleryForPhotoBrowser">',
			    '<tpl for=".">',
					'<li class="photo">',
						'<img src="{thumb}" alt="{title}"/>',
					'</li>',
			    '</tpl>',
			'</ul>'
		);
		
        this.detailsTemplate = new Ext.XTemplate(
            '<tpl for=".">',
                '<img src="{full}" />',
            '</tpl>'
        );
    },
   
    showImageDetails: function() {
        var selNode = this.imagesView.getSelectedNodes();
        var detailEl = Ext.getCmp('img-detail-panel').body;
        if(selNode && selNode.length > 0) {
            selNode = selNode[0];
            var data = this.imagesView.getRecord(selNode);
            detailEl.hide();
            this.detailsTemplate.overwrite(detailEl, data.data);
            detailEl.slideIn('l', {stopFx:true,duration:.3});
        } else {
            detailEl.update('');
        }
    }
}); 