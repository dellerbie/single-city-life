// Rails notes

// This is the handlers.js file from swfupload's application demo

// All image paths are changed from relative to absolute

// Example:
//   AddImage("images/" + image_name);  ->  AddImage("/images/" + image_name);

// Images from the swfupload demo are saved in #{RAILS_ROOT}/public/images

// uploadSuccess was changed
// The line: AddImage("thumbnail.php?id=" + server_data);
// was changed to: AddImage(server_data);
// The rails photo controller should return a text string
// containing the full URL to the thumbnail

function fileQueueError(fileObj, error_code, message) {
	try {
		var error_name = "";
		switch(error_code) {
			case SWFUpload.ERROR_CODE_QUEUE_LIMIT_EXCEEDED:
				error_name = "You have attempted to queue too many files.";
			break;
		}

		if (error_name !== "") {
			alert(error_name);
			return;
		}

		switch(error_code) {
			case SWFUpload.QUEUE_ERROR.ZERO_BYTE_FILE:
				image_name = "zerobyte.gif";
			break;
			case SWFUpload.QUEUE_ERROR.FILE_EXCEEDS_SIZE_LIMIT:
				image_name = "toobig.gif";
			break;
			case SWFUpload.QUEUE_ERROR.ZERO_BYTE_FILE:
			case SWFUpload.QUEUE_ERROR.INVALID_FILETYPE:
			default:
				alert(message);
				image_name = "error.gif";
			break;
		}

		AddImage("/images/" + image_name);

	} catch (ex) { this.debug(ex); }

}

// function fileDialogComplete(num_files_queued) {
// 	try {
// 		if (num_files_queued > 0) {
// 			this.startUpload();
// 		}
// 	} catch (ex) { this.debug(ex); }
// }

function fileDialogComplete(numFilesSelected, numFilesQueued) {
	try {
		if (numFilesSelected > 0) {
			document.getElementById(this.customSettings.cancelButtonId).disabled = false;
		}
		
		/* I want auto start the upload and I can do that here */
		this.startUpload();
	} catch (ex)  {
        this.debug(ex);
	}
}

function uploadStart(file) {
	try {
		/* I don't want to do any file validation or anything,  I'll just update the UI and
		return true to indicate that the upload should start.
		It's important to update the UI here because in Linux no uploadProgress events are called. The best
		we can do is say we are uploading.
		 */
		var progress = new FileProgress(file, this.customSettings.progressTarget);
		progress.setStatus("Uploading...");
		progress.toggleCancel(true, this);
	}
	catch (ex) {}
	
	return true;
}

function uploadProgress(file, bytesLoaded, bytesTotal) {
	try {
		var percent = Math.ceil((bytesLoaded / bytesTotal) * 100);

		var progress = new FileProgress(file, this.customSettings.progressTarget);
		progress.setProgress(percent);
		progress.setStatus("Uploading...");
	} catch (ex) {
		this.debug(ex);
	}
}

function uploadSuccess(fileObj, server_data) {
	try {
		AddImage(server_data);

		var progress = new FileProgress(fileObj,  this.customSettings.progressTarget);
		progress.setComplete();
		progress.setStatus("Complete.");
		progress.toggleCancel(false);

	} catch (ex) { this.debug(ex); }
}

function uploadComplete(fileObj) {
	try {
		/*  I want the next upload to continue automatically so I'll call startUpload here */
		if (this.getStats().files_queued > 0) {
			this.startUpload();
		} else {
			var progress = new FileProgress(fileObj,  this.customSettings.progressTarget);
			progress.setComplete();
			progress.setStatus("All images received.");
			progress.toggleCancel(false);
		}
	} catch (ex) { this.debug(ex); }
}

function uploadError(fileObj, error_code, message) {
	var image_name =  "error.gif";
	try {
		switch(error_code) {
			case SWFUpload.UPLOAD_ERROR.UPLOAD_STOPPED:
				try {
					var progress = new FileProgress(fileObj,  this.customSettings.progressTarget);
					progress.etCancelled();
					progress.setStatus("Stopped");
					progress.toggleCancel(true, this, fileObj.id);
				}
				catch (ex) { this.debug(ex); }
			case SWFUpload.UPLOAD_ERROR.UPLOAD_LIMIT_EXCEEDED:
				image_name = "uploadlimit.gif";
			break;
			default:
				alert(message);
			break;
		}

		AddImage("/images/" + image_name);

	} catch (ex) { this.debug(ex); }

}

function AddImage(src) {
	var new_img = document.createElement("img");
	new_img.style.margin = "5px";

	document.getElementById("thumbnails").appendChild(new_img);
	if (new_img.filters) {
		try {
			new_img.filters.item("DXImageTransform.Microsoft.Alpha").opacity = 0;
		} catch (e) {
			// If it is not set initially, the browser will throw an error.  This will set it if it is not set yet.
			new_img.style.filter = 'progid:DXImageTransform.Microsoft.Alpha(opacity=' + 0 + ')';
		}
	} else {
		new_img.style.opacity = 0;
	}

	new_img.onload = function () { FadeIn(new_img, 0); };
	new_img.src = src;
}

function FadeIn(element, opacity) {
	var reduce_opacity_by = 15;
	var rate = 30;	// 15 fps


	if (opacity < 100) {
		opacity += reduce_opacity_by;
		if (opacity > 100) opacity = 100;

		if (element.filters) {
			try {
				element.filters.item("DXImageTransform.Microsoft.Alpha").opacity = opacity;
			} catch (e) {
				// If it is not set initially, the browser will throw an error.  This will set it if it is not set yet.
				element.style.filter = 'progid:DXImageTransform.Microsoft.Alpha(opacity=' + opacity + ')';
			}
		} else {
			element.style.opacity = opacity / 100;
		}
	}

	if (opacity < 100) {
		setTimeout(function() { FadeIn(element, opacity); }, rate);
	}
}

function fileQueued(file) {
	try {
		var progress = new FileProgress(file, this.customSettings.progressTarget);
		progress.setStatus("Pending...");
		progress.toggleCancel(true, this);
	} catch (ex) {
		this.debug(ex);
	}

}

function fileQueueError(file, errorCode, message) {
	try {
		if (errorCode === SWFUpload.QUEUE_ERROR.QUEUE_LIMIT_EXCEEDED) {
			alert("You have attempted to queue too many files.\n" + (message === 0 ? "You have reached the upload limit." : "You may select " + (message > 1 ? "up to " + message + " files." : "one file.")));
			return;
		}

		var progress = new FileProgress(file, this.customSettings.progressTarget);
		progress.setError();
		progress.toggleCancel(false);

		switch (errorCode) {
		case SWFUpload.QUEUE_ERROR.FILE_EXCEEDS_SIZE_LIMIT:
			progress.setStatus("File is too big.");
			this.debug("Error Code: File too big, File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
			break;
		case SWFUpload.QUEUE_ERROR.ZERO_BYTE_FILE:
			progress.setStatus("Cannot upload Zero Byte files.");
			this.debug("Error Code: Zero byte file, File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
			break;
		case SWFUpload.QUEUE_ERROR.INVALID_FILETYPE:
			progress.setStatus("Invalid File Type.");
			this.debug("Error Code: Invalid File Type, File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
			break;
		default:
			if (file !== null) {
				progress.setStatus("Unhandled Error");
			}
			this.debug("Error Code: " + errorCode + ", File name: " + file.name + ", File size: " + file.size + ", Message: " + message);
			break;
		}
	} catch (ex) {
        this.debug(ex);
    }
}

function queueComplete(numFilesUploaded) {
	var status = document.getElementById("status");
	status.innerHTML = numFilesUploaded + " file" + (numFilesUploaded === 1 ? "" : "s") + " uploaded.";
}

