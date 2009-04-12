Ext.onReady(function() {
	
	function doCountdown(field, counter, maxlength) {
		if(field.value.length > maxlength) {
		    field.value = field.value.substring(0, maxlength);
		} else {
		    var charsLeft = maxlength - field.value.length;
		    counter.update(charsLeft);
		}
	}

	var fieldNames = ['profile_loves_when', 'profile_hates_when', 'profile_turn_ons', 
						'profile_turn_offs', 'profile_msg_me_if'];

	var collection = new Ext.util.MixedCollection();
	collection.addAll(fieldNames);
	collection.each(function(item, index, length) {
	    var field = Ext.get(item);

	    var counter = field.next('.fieldCounter');
	    counter.update(150 - field.dom.value.length);
 
	    field.on('keydown', function() {
	        doCountdown(field.dom, counter, 150);
	    });
 
	    field.on('keyup', function() {
	        doCountdown(field.dom, counter, 150);
	    });			
	});   
});