function fileQueueError(file, errorCode, message) {
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
}

function fileDialogComplete(numFilesSelected, numFilesQueued) {
	if (numFilesQueued > 0) {
		this.startUpload();
	}
}

function uploadProgress(file, bytesLoaded) {
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
}

function uploadSuccess(file, serverData) {
	
	var json = eval('(' + serverData + ')');
	
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
		Ext.Msg.alert('Error uploading your photo', serverData.msg);
	}
}

function uploadComplete(file) {
	if (this.getStats().files_queued > 0) {
		this.startUpload();
	} else {
		var progress = new FileProgress(file,  this.customSettings.upload_target);
		progress.setComplete();
		progress.setStatus("All images received.");
		progress.toggleCancel(false);
	}
}

function uploadError(file, errorCode, message) {
	var progress;
	
	switch (errorCode) {
		case SWFUpload.UPLOAD_ERROR.FILE_CANCELLED:
			progress = new FileProgress(file,  this.customSettings.upload_target);
			progress.setCancelled();
			progress.setStatus("Cancelled");
			progress.toggleCancel(false);
			break;
		case SWFUpload.UPLOAD_ERROR.UPLOAD_STOPPED:
				progress = new FileProgress(file,  this.customSettings.upload_target);
				progress.setCancelled();
				progress.setStatus("Stopped");
				progress.toggleCancel(true);
		case SWFUpload.UPLOAD_ERROR.UPLOAD_LIMIT_EXCEEDED:
			Ext.Msg.alert('Error Uploading Photo', "Your upload limit has been exceeded");
			break;
		default:
			break;
	}
}


/* ******************************************
 *	FileProgress Object
 *	Control object for displaying file info
 * ****************************************** */

function FileProgress(file, targetID) {
	this.fileProgressID = "divFileProgress";

	this.fileProgressWrapper = document.getElementById(this.fileProgressID);
	if (!this.fileProgressWrapper) {
		this.fileProgressWrapper = document.createElement("div");
		this.fileProgressWrapper.className = "progressWrapper";
		this.fileProgressWrapper.id = this.fileProgressID;

		this.fileProgressElement = document.createElement("div");
		this.fileProgressElement.className = "progressContainer";

		var progressCancel = document.createElement("a");
		progressCancel.className = "progressCancel";
		progressCancel.href = "#";
		progressCancel.style.visibility = "hidden";
		progressCancel.appendChild(document.createTextNode(" "));

		var progressText = document.createElement("div");
		progressText.className = "progressName";
		progressText.appendChild(document.createTextNode(file.name));

		var progressBar = document.createElement("div");
		progressBar.className = "progressBarInProgress";

		var progressStatus = document.createElement("div");
		progressStatus.className = "progressBarStatus";
		progressStatus.innerHTML = "&nbsp;";

		this.fileProgressElement.appendChild(progressCancel);
		this.fileProgressElement.appendChild(progressText);
		this.fileProgressElement.appendChild(progressStatus);
		this.fileProgressElement.appendChild(progressBar);

		this.fileProgressWrapper.appendChild(this.fileProgressElement);

		document.getElementById(targetID).appendChild(this.fileProgressWrapper);
		//fadeIn(this.fileProgressWrapper, 0);

	} else {
		this.fileProgressElement = this.fileProgressWrapper.firstChild;
		this.fileProgressElement.childNodes[1].firstChild.nodeValue = file.name;
	}

	this.height = this.fileProgressWrapper.offsetHeight;

}
FileProgress.prototype.setProgress = function (percentage) {
	this.fileProgressElement.className = "progressContainer green";
	this.fileProgressElement.childNodes[3].className = "progressBarInProgress";
	this.fileProgressElement.childNodes[3].style.width = percentage + "%";
};
FileProgress.prototype.setComplete = function () {
	this.fileProgressElement.className = "progressContainer blue";
	this.fileProgressElement.childNodes[3].className = "progressBarComplete";
	this.fileProgressElement.childNodes[3].style.width = "";

};
FileProgress.prototype.setError = function () {
	this.fileProgressElement.className = "progressContainer red";
	this.fileProgressElement.childNodes[3].className = "progressBarError";
	this.fileProgressElement.childNodes[3].style.width = "";

};
FileProgress.prototype.setCancelled = function () {
	this.fileProgressElement.className = "progressContainer";
	this.fileProgressElement.childNodes[3].className = "progressBarError";
	this.fileProgressElement.childNodes[3].style.width = "";

};
FileProgress.prototype.setStatus = function (status) {
	this.fileProgressElement.childNodes[2].innerHTML = status;
};

FileProgress.prototype.toggleCancel = function (show, swfuploadInstance) {
	this.fileProgressElement.childNodes[0].style.visibility = show ? "visible" : "hidden";
	if (swfuploadInstance) {
		var fileID = this.fileProgressID;
		this.fileProgressElement.childNodes[0].onclick = function () {
			swfuploadInstance.cancelUpload(fileID);
			return false;
		};
	}
};
