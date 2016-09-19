/* Arranged via the Revealing Module Pattern  */


var schubModule_controller = function(){
	var config = {
		DEFAULT: {
			resultsPerPage: 25
		},
		INDEX: {
			emails: 'imapriverdata_new',
			liferay: 'liferay-indexer',
			nuxeo: 'nuxeo',
			shindig: 'shindig'
		},
		URL: {
			system:{
				elasticsearch: '<%= searchUrl %>',
				liferay: 'http://127.0.0.1:8080',
				nuxeo: 'http://127.0.0.1:8080/nuxeo',
				shindig: 'http://127.0.0.1:8080/shindig/social/rest'
			},
			liferay:{
				userProfile: '/web/guest/profile?userId=',
				userProfileMsgId: '&_ShindigMessaging_WAR_ShindigMessagingportlet_highlightedMsg='
			}
		},
		userId: ''
	};

	var resultsStart = 1,
		resultsPerPage = config.DEFAULT.resultsPerPage,
		usedIndices;

	function init() {
		resetFacets();
		schubModule_facets.init();
	}

	function search() {
		var query = schubModule_view.getSearchQuery();
		var url = createQueryUrl(query);

		schubModule_helper.sendAsyncRequest('GET', url, searchCallback, errorCallback);
	}

	function createQueryUrl(query) {
		var typeString = '';
		// get result types from facets module

		var url = config.URL.system.elasticsearch + usedIndices
				+ '/_search'
				+ '?q=' + query
				+ '&_source=true&from=' + resultsStart
				+ '&size=' + resultsPerPage
				+ '&type=' + typeString;

		return url;
	}

	function resetFacets() {
		usedIndices = config.INDEX.emails
			+ ',' + config.INDEX.liferay
			+ ',' + config.INDEX.nuxeo
			+ ',' + config.INDEX.shindig;

		schubModule_facets.resetFacets();
	}

	/* callbacks: */

	function searchCallback(results) {
		console.log(JSON.stringify(results));
	}


	return {
		init:init
	}
}();

schubModule_controller.init();


var schubModule_model = function() {
	var RESULTTYPE: {
		activity: 'activity',
		doc: 'doc',
		mail: 'mail',
		message: 'message'
	};

	var SYSTEM: {
		liferay: 'Liferay',
		nuxeo: 'Nuxeo',
		oxMail: 'Open-Xchange Mail',
		socialMessage: 'Social Message',
		user: 'User'
	};


	var Result = function(title, content, filetype, system, author) {
		this.title = title || '';
		this.content = content || '';
		this.filetype = filetype || '';
		this.system = system || '';
		this.author =  author || null;

		var createDate;
		var editedDate;
		var fileSize;


		/* public methods: */

		function setCreateDate(newCreateDate) {
			createDate = newCreateDate;
		}
		function getCreateDate() {
			return schubModule_helper.getDateFormatted(createDate);
		}

		function setEditedDate(newEditedDate) {
			editedDate = newEditedDate;
		}
		function getEditedDate() {
			return schubModule_helper.getDateFormatted(editedDate);
		}

		function setFileSize(newFileSize) {
			fileSize = newFileSize;
		}
		function getFileSize() {
			return schubModule_helper.getFileSizeAsText(fileSize);
		}

		return {
			setCreateDate: setCreateDate,
			getCreateDate: getCreateDate,
			setEditedDate: setEditedDate,
			getEditedDate: getEditedDate,
			setFileSize: setFileSize,
			getFileSize: getFileSize
		}
	};

	var ImageResult = function(title, imageUrl, filetype, system, author) {
		this.base = Result;
		this.base(title, '', filetype, system, author);

		this.imageUrl = imageUrl || '';
	};
	ImageResult.prototype = new Result;


	var User = function(id, surname, lastname, thumbUrl) {
		this.userId = id || '';
		this.surname = surname || '';
		this.lastname = lastname || '';
		this.thumbUrl = thumbUrl || '';
	};

	return {

	}
}();

var schubModule_facets = function() {
	var GROUP_FILETYPE = 'filetype';
	var GROUP_CREATED = 'created';
	var GROUP_AUTHOR = 'author';
	var GROUP_SYSTEM = 'system';

	var availableFacets = [];
	var chosenFacets = {};

	function init() {
		availableFacets.push(GROUP_FILETYPE : {});
		availableFacets.push(GROUP_CREATED : {});
		availableFacets.push(GROUP_AUTHOR : {});
		availableFacets.push(GROUP_SYSTEM : {});
		
	}

	function resetFacets() {
		chosenFacets = {};
	}

	return {
		init: init
	}
}();	


var schubModule_view = function() {
	var config = {
		CSS: {
			classes: {

			},
			ids: {
				searchField: 'searchfield'
			}
		},
		ICON: {
			fileSize: 'icon-file',
			mailFolder: 'icon-folder-open-alt',
			publicMsg: 'icon-globe',
			sentTo: 'icon-long-arrow-right',
			system: {
				message: 'icon-comments',
				nuxeo: 'icon-folder-open',
				oxMail: 'icon-envelope-alt'
			}
		}
	};

	var FILETYPE: {
		doc: 'doc',
		docx: 'docx',
		gif: 'gif',
		jpg: 'jpg',
		jpeg: 'jpeg',
		pdf: 'pdf',
		png: 'png',
		ppt: 'ppt',
		pptx: 'pptx',
		xls: 'xls',
		xlsx: 'xlsx',

		mail: 'Mail',
		message: '<liferay-ui:message key="de.iisys.esearch_Message"/>'
	};


	function getSearchQuery() {
		return $('#'+config.CSS.ids.searchField);
	}

	return {

	}
}();

var schubModule_helper = function() {

	function getDateFormatted(dateString) {
		var d = new Date(dateString);
		var month = d.getMonth()+1;
		if(month<10)
			month = '0'+month;
		
		var days = d.getDate();
		if(days<10)
			days = '0'+days;
			
		return d.getFullYear()+'-'+month+'-'+days+' '+d.getHours()+':'+d.getMinutes();
	}

	function getFileSizeAsText(sizeInByte) {
		var text;
		
		if(sizeInByte > 1000000) {
			text = Math.round(sizeInByte/1000000) + ' MB';
		} else if(sizeInByte > 1000) {
			text = Math.round(sizeInByte/1000) + ' KB';
		} else {
			text = sizeInByte + ' Byte';
		}
		
		return text;
	}

	function sendAsyncRequest(method, url, successCallback, errorCallback, payload, callbackValue) {
		AUI().use('aui-io-request', function(A)
		{
			
			if(payload && payload!=='') {
			  A.io.request(url, {
				  dataType: 'json',
				  method : method,
				  headers: {
					  'Content-Type': 'application/json; charset=utf-8'
				  },
				  data : JSON.stringify(payload),
				  on: {
					success: function() {
						if(callbackValue)
							successCallback(this.get('responseData'),callbackValue);
						else
					  		successCallback(this.get('responseData'));
					},
					failure: function() {
						if(callbackValue)
							errorCallback(this.get('responseData'),callbackValue);
						else
					  		errorCallback(this.get('responseData'));
					}
				  }
			  });
			} else {
				A.io.request(url, {
				  dataType: 'json',
				  method : method,
				  on: {
					success: function() {
						if(callbackValue)
							successCallback(this.get('responseData'),callbackValue);
						else
					  		successCallback(this.get('responseData'));
					},
					failure: function() {
						if(callbackValue)
							errorCallback(this.get('responseData'),callbackValue);
						else
					  		errorCallback(this.get('responseData'));
					}
				  }
				});
			}
		});
	}

	return {
		getDateFormatted: getDateFormatted,
		getFileSizeAsText: getFileSizeAsText,
		sendAsyncRequest: sendAsyncRequest
	}
}();