Ext.onReady(function() {
	var replyForm = Ext.get('reply');
	var submitBtn = replyForm.query('input[type=submit]')[0];
	submitBtn.disabled = false;
	
	var textarea = replyForm.query('textarea')[0];
	textarea.disabled = false;
	
	replyForm.on('submit', function(e) {
		e.preventDefault();

		var params = Ext.Ajax.serializeForm('reply');
		console.log(params);
		params = Ext.urlDecode(params);
		Ext.apply(params, {
			authenticity_token: AUTH_TOKEN
		});
		console.log(params);
		
		if(params.message.trim() == "") {
			Ext.Msg.alert("Failed to send message", "You must write a message in order to send.");
		} else {
			submitBtn.disabled = true;
			textarea.disabled = true;

			Ext.get('messageStatus').update('Sending message...').replaceClass('red', 'green');
		
			var tpl = new Ext.XTemplate(
				'<li>',
					'<div class="photo">',
						'<a href="/users/{sender}/profile"><img src="{sender_default_photo}"></a>',
					'</div>',
					'<div class="metadata">',
						'<a class="from" href="/users/{sender}/profile">{sender}</a>',
						'<span class="sentOn">{sent_on}</span>',
					'</div>',
					'<div class="message">',
						'<p>{message}</p>',
					'</div>',
				'</li>'
			);
			
			Ext.Ajax.request({
				url: '/users/' + USER_ID + '/messages/reply',
				method: 'POST',
				params: params,
				success: function(response) {
					var data = Ext.decode(response.responseText);
					if(data.success == true) {
						var msgs = Ext.get('messages');
					
						tpl.append(msgs, data);
						Ext.get('messageStatus').update('').hide();
						submitBtn.disabled = false;
						textarea.disabled = false;
						textarea.value = "";
					} else {
						Ext.get('messageStatus').update(data.msg).replaceClass('green', 'red');
					}
					submitBtn.disabled = false;
					textarea.disabled = false;
				}
			});
		}
		

		

		

	});
});