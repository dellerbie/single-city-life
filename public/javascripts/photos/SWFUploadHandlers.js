var SWFUploadHandlers = {};

Ext.apply(SWFUploadHandlers, {
	fileQueueError: function (file, errorCode, message) {
		switch (errorCode) {
			case SWFUpload.QUEUE_ERROR.FILE_EXCEEDS_SIZE_LIMIT:
				message = "You're photo is too large.  The size limit is 3MB.";
				break;
			case SWFUpload.errorCode_QUEUE_LIMIT_EXCEEDED: 
				message = "You have attempted to upload too many files at once.";
				break;
			default:
				message = "The file you're uploading is invalid.  JPG's only please."
				break;
		}
	
		Ext.Msg.alert('Error Uploading Photo', message);
	},
	
	fileDialogComplete: function (numFilesSelected, numFilesQueued) {
		if (numFilesQueued > 0) {
			this.startUpload();
		}
	},
	
	uploadProgress: function (file, bytesLoaded) {
		var percent = Math.ceil((bytesLoaded / file.size) * 100);

		var progress = new FileProgress(file,  this.customSettings.upload_target);
		progress.setProgress(percent);
		if (percent === 100) {
			progress.setStatus("Creating thumbnail...");
			progress.toggleCancel(false, this);
		} else {
			progress.setStatus("Uploading...");
			progress.toggleCancel(true, this);
		}
	},

	uploadSuccess: function (file, serverData) {
		var json = Ext.decode(serverData);
		if(json.success === true) {
			var store = Ext.getCmp('gallery-data-view').store;
		
			var TopicRecord = Ext.data.Record.create([
			    {name: 'id'},
			    {name: 'full'},
				{name: 'thumb'},
				{name: 'tiny'}
			]);

			var myNewRecord = new TopicRecord({
				id: json.id,
				thumb: json.thumb,
				full: json.full,
				tiny: json.tiny
			});
			store.addSorted(myNewRecord);
		
			var progress = new FileProgress(file,  this.customSettings.upload_target);
			progress.setComplete();
			progress.setStatus("Complete.");
			progress.toggleCancel(false);
		} else {
			Ext.Msg.alert('Error uploading your photo', json.msg);
		}
	},

	uploadComplete: function (file) {
		if (this.getStats().files_queued > 0) {
			this.startUpload();
		} else {
			var progress = new FileProgress(file,  this.customSettings.upload_target);
			progress.setComplete();
			progress.setStatus("All images received.");
			progress.toggleCancel(false);
			SWFUploadHandlers.fadeOutFileProgressContainer.defer(1000);
		}
	},

	uploadError: function(file, errorCode, message) {
		var progress;
		switch (errorCode) {
			case SWFUpload.UPLOAD_ERROR.FILE_CANCELLED:
				progress = new FileProgress(file,  this.customSettings.upload_target);
				progress.setCancelled();
				progress.setStatus("Cancelled");
				progress.toggleCancel(false);
				this.fadeOutFileProgressContainer();
				break;
			case SWFUpload.UPLOAD_ERROR.UPLOAD_STOPPED:
					progress = new FileProgress(file,  this.customSettings.upload_target);
					progress.setCancelled();
					progress.setStatus("Stopped");
					progress.toggleCancel(true);
					SWFUploadHandlers.fadeOutFileProgressContainer.defer(1000);
			case SWFUpload.UPLOAD_ERROR.UPLOAD_LIMIT_EXCEEDED:
				Ext.Msg.alert('Error Uploading Photo', "Your upload limit has been exceeded");
				break;
			default:
				break;
		}
	},
	
	fadeOutFileProgressContainer: function() {
		Ext.fly('fileProgressContainer').fadeOut({duration: 1, useDisplay: true});
	}
});