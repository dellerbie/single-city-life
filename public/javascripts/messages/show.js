Ext.onReady(function() {
	var replyForm = Ext.get('reply');
	replyForm.on('submit', function(e) {
		e.preventDefault();
		
		// disable the form
		var submitBtn = replyForm.query('input[type=submit]')[0];
		submitBtn.disabled = true;
		
		var textarea = replyForm.query('textarea')[0];
		textarea.disabled = true;
		
		Ext.get('messageStatus').update('Sending message...').replaceClass('red', 'green');
		
		// send ajax request 
		
		var tpl = new Ext.XTemplate(
			'<li>',
				'<div class="photo">',
					'<a href="#"><img class="articleImage" width="70" height="70" alt="" src="http://l.yimg.com/ds/orion/us/trend_hunter537/1216278000/1:trend_hunter537:8f4fb143c87d30ba65587aae253b2a3a/megan_fox.jpg"></a>',
				'</div>',
				'<div class="metadata">',
					'<a class="from" href="#">Nadia</a>',
					'<span class="sentOn">September 3 @ 5:50pm</span>',
				'</div>',
				'<div class="message">',
					'<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>',
				'</div>',
			'</li>'
		);
		
		var msgs = Ext.get('messages');
		tpl.append(msgs);
		
		Ext.get('messageStatus').update('').hide();
		submitBtn.disabled = false;
		textarea.disabled = false;
		
	});
});