Ext.onReady(function() {
	var msgs = Ext.get('messages');
	if(!msgs) return;
	msgs.on('click', function(e, t) {
		var deleteBtn = e.getTarget('.delete');
		if(deleteBtn) {
			deleteBtn = Ext.get(deleteBtn);
			Ext.Msg.confirm('Delete Message?', 'Are you sure you want to delete this message?', function(btnId) {
				if(btnId == 'yes') {
					messageLI = deleteBtn.findParent('li');
					
					Ext.Ajax.request({
						url: '/users/' + USER_ID + '/messages/' + messageLI.id,
						method: 'POST',
						params: {
							"_method": "delete",
							authenticity_token: AUTH_TOKEN
						},
						success: function() {
							Ext.fly(messageLI).remove();
							if(msgs.select('li').getCount() == 0) {
								msgs.update('You have no messages.');
							}
						}
					});

				}
			});
		}
	});
});