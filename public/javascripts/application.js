Ext.onReady(function() {
	Ext.Ajax.on('requestexception', function() {
		Ext.Msg.alert('We suck', 'Sorry there was an error processing your request.  Please try again later.');
	})
});
