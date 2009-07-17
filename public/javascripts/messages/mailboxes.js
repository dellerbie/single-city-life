Ext.onReady(function() {
	var msgs = Ext.get('messages');
	msgs.on('click', function(e, t) {
		var deleteBtn = e.getTarget('.delete');
		if(deleteBtn) {
			
			Ext.Msg.confirm('Delete Message?', 'Are you sure you want to delete this message?', function(btnId) {
				if(btnId == 'yes') {
					deleteBtn = Ext.fly(deleteBtn);
					Ext.fly(deleteBtn.findParent('li')).remove();
					console.log(msgs.select('li').getCount());
					if(msgs.select('li').getCount() == 0) {
						msgs.update('You have no messages.');
					}
				}
			});
		}
	});
});