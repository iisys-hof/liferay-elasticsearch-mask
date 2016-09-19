<%@ include file="/html/init.jsp" %>
<%@ taglib uri="http://liferay.com/tld/portlet" prefix="liferay-portlet" %>

<%
	String searchUrl = "http://127.0.0.1:9200/elasticsearch/";
	String searchIndices = "imapriverdata_new,liferay-indexer,nuxeo,shindig";
%>

<%-- <liferay-portlet:resourceURL id="userFullName" var="userFullNameURL" /> --%>

<div id="top_lane" style="margin-top:1em; margin-bottom:2em;">
	<form class="form-search" onsubmit="<portlet:namespace/>Controller.handlerSearch(); return false;">
		
		<div class="row">
			<div class="left-col col-sm-1 col-md-4 col-lg-3"></div>
			<div class="main-col col-sm-10 col-md-7 col-lg-7">
				<div class="input-group">
			      <div class="input-group-btn">
			        <button type="button" id="<portlet:namespace/>systemButton" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">All Systems <span class="caret"></span></button>
			        <ul id="<portlet:namespace/>systemToSearch" class="dropdown-menu">
			          <li><a href="#"><liferay-ui:message key="de.iisys.esearch_AllSystems"/></a></li>
			          <li><a href="#"><liferay-ui:message key="de.iisys.esearch_AllSystemsInclActivities"/></a></li>
			          <li role="separator" class="divider"></li>
			          <li><a href="#"><liferay-ui:message key="de.iisys.esearch_Portal"/></a></li>
			          <li><a href="#"><liferay-ui:message key="de.iisys.esearch_Documents"/></a></li>
			          <li><a href="#"><liferay-ui:message key="de.iisys.esearch_Emails"/></a></li>
			          <li><a href="#"><liferay-ui:message key="de.iisys.esearch_Persons"/></a></li>
			          <li><a href="#"><liferay-ui:message key="de.iisys.esearch_Messages"/></a></li>
			          <li><a href="#"><liferay-ui:message key="de.iisys.esearch_Activities"/></a></li>
			          <li role="separator" class="divider"></li>
			          <li><a href="#">No Filter Search</a></li>
			        </ul>
			      </div><!-- /btn-group -->
			      <input type="text" id="searchfield" class="form-control"  placeholder="e.g. calculation" aria-label="search..." value="" />
			      <span class="input-group-btn">
	        		<button class="btn btn-default" type="button" onclick="<portlet:namespace/>Controller.handlerSearch();"><span class="glyphicon glyphicon-search"></span></button>
	      		  </span>
			    </div><!-- /input-group -->
			</div><!-- /.col-lg-6 -->
			  
			<div class="col-sm-1 col-md-1 col-lg-2"></div>
		</div><!-- /row -->
		
	</form>
</div><!-- /top_lane -->

<div id="result_lane" class="row" style="display:none;">
	
	<div class="facet-sidebar col-sm-3 col-md-4 col-lg-3"><div class="row"><!-- facets col -->
		<div class="hidden-sm col-md-3 col-lg-2"></div>
		<div class="col-sm-12 col-md-9 col-lg-10">
			<h6><liferay-ui:message key="de.iisys.esearch_FileTypes"/></h6>

			<div id="filetype-tab">
				<ul class="nav nav-tabs">
					<li class="active"><a>
						<span id="facet_docs" class="icon-file-alt facet-filetype-icon"></span>
					</a></li>
					<li><a>
						<span id="facet_images" class="icon-picture facet-filetype-icon"></span>
					</a></li>
					<li><a>
						<span id="facet_sounds" class="icon-music facet-filetype-icon"></span>
					</a></li>
					<li><a>
						<span id="facet_videos" class="icon-facetime-video facet-filetype-icon"></span>
					</a></li>
				</ul>
			</div>

			<div id="facet_filetype-icons" class="row"  style="margin-bottom:10px;"></div>


			<a id="<portlet:namespace/>filetype-toggler" href="#" style="margin-left:12px;">
				<span class="icon-caret-right facet-available" style="margin-top:1em;"></span> <small><liferay-ui:message key="de.iisys.esearch_AllFileTypes"/></small>
			</a>
			
			<div id="facet_all-filetypes" class="row" style="margin-top:-5px;">
			</div><!-- /file type checkboxes -->
			
			<hr style="margin-bottom:0;" />
			<h6><liferay-ui:message key="de.iisys.esearch_CreatedDate"/></h6>
			<select id="facet_created" class="form-control">
				<option><liferay-ui:message key="de.iisys.esearch_AnyTime"/></option>
		        <option><liferay-ui:message key="de.iisys.esearch_PastHour"/></option>
		        <option><liferay-ui:message key="de.iisys.esearch_Past24Hours"/></option>
		        <option><liferay-ui:message key="de.iisys.esearch_PastWeek"/></option>
		        <option><liferay-ui:message key="de.iisys.esearch_PastMonth"/></option>
		        <option><liferay-ui:message key="de.iisys.esearch_PastQuarter"/></option>
		        <option><liferay-ui:message key="de.iisys.esearch_PastYear"/></option>
		        <option class="select-dash" disabled="disabled">----</option>
		        <option><liferay-ui:message key="de.iisys.esearch_CustomRange"/>...</option>
		    </select>
		    
		    <hr style="margin-bottom:0;" />
		    <h6><liferay-ui:message key="de.iisys.esearch_Authors"/></h6>
		    <div id="facet_authors" class="form-group clearfix">
			</div>
			
			<hr style="margin-bottom:0;" />
			<h6><liferay-ui:message key="de.iisys.esearch_Systems"/></h6>
			<div id="facet_systems">
			</div><!-- /facet_systems -->
		</div>
	</div></div><!-- /.facets col -->
	
	<div class="col-sm-9 col-md-7 col-lg-7" style="padding:2em; padding-top:1em; background-color:#f5f7f8;">
		<div class="row">
			<div class="col-md-6" style="padding-left:0;">
				<p id="<portlet:namespace/>filteredOfAll">
					<liferay-ui:message key="de.iisys.esearch_Filtered-x-of-x-results" />
				</p>
			</div>
			<div class="col-md-6" style="padding-right:0;">
				<div class="btn-group pull-right">
					<button id="<portlet:namespace/>sortBy" type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
					Sorted by score <span class="caret"></span>
					</button>
					<ul id="<portlet:namespace/>sortByDropdown" class="dropdown-menu">
						<li><a href="#">Sorted by score</a></li>
						<li><a href="#">Sorted by create date</a></li>
						<li><a href="#">Sorted by title</a></li>
						<li><a href="#">Not sorted (most efficient)</a></li>
					</ul>
				</div>
			</div>
		</div><!-- /row -->
		
		
		<div id="<portlet:namespace/>searchresults" style="padding-top:2em;">
			<!-- SEARCH RESULTS -->
		</div>
		
		
		<div id="<portlet:namespace/>pagination" class="pagination-bar" style="margin-top:1em;"><!-- pagination: -->
			<div class="dropdown pagination-items-per-page">
			    <a class="dropdown-toggle" data-toggle="dropdown" href="#1" type="button">
			    	<span class="per-page"></span> <liferay-ui:message key="de.iisys.esearch_perPage" /> <span class="icon-sort"></span>
			    </a>
			    <ul class="dropdown-menu">
			        <li><a href="#1">10</a></li>
			        <li><a href="#1">25</a></li>
			        <li><a href="#1">50</a></li>
			        <li><a href="#1">100</a></li>
			    </ul>
			</div>
			
			<div id="<portlet:namespace/>pagination-results" class="pagination-results">
				<!-- <liferay-ui:message key="de.iisys.esearch_Showing-x-to-x-of-x-results" /> -->
			</div>
			
			<ul class="pagination">
			    <li class="disabled"><a href="#1"><span class="icon-caret-left"></span></a></li>
			    <li class="active"><a href="#1">1</a></li>
			    <li><a href="#1">2</a></li>
			    <li class="dropdown">
			        <a class="dropdown-toggle" data-toggle="dropdown" href="#1">...</a>
			        <div class="dropdown-menu dropdown-menu-top-center">
			            <ul class="inline-scroller link-list">
			                <li><a href="#1">3</a></li>
			                <li><a href="#1">4</a></li>
			                <li><a href="#1">5</a></li>
			                <li><a href="#1">6</a></li>
			                <li><a href="#1">7</a></li>
			                <li><a href="#1">8</a></li>
			                <li><a href="#1">9</a></li>
			                <li><a href="#1">10</a></li>
			                <li><a href="#1">11</a></li>
			                <li><a href="#1">12</a></li>
			                <li><a href="#1">13</a></li>
			                <li><a href="#1">14</a></li>
			                <li><a href="#1">15</a></li>
			            </ul>
			        </div>
			    </li>
			    <li><a href="#1">16</a></li>
			    <li><a href="#1"><span class="icon-caret-right"></span></a></li>
			</ul>
		</div><!-- /pagination -->
		
	</div>
	<div class="hidden-sm col-md-1 col-lg-2"></div>
</div>


<%-- 
<liferay-ui:user-display userId="20960" showUserName="false" showUserDetails="false" />
--%>





<%-- 
**********************************************************************************************************
**********************************************************************************************************
handlebars.js templates: --%>

<script id="result-default-template" type="text/x-handlebars-template">
	<div class="row result">
		<div class="card-horizontal">
			<div class="card-row {{#if isSmall}}card-row-small{{/if}}">
				<div class="card-col-11 result-main-part">
					<p class="result-title">
						{{#if deleted}}
							<span class="icon-trash"></span>
						{{else}}
							{{#unless isSmall}}<a href="{{url}}">{{/unless}}
						{{/if}}
						{{{title}}}
						{{#if deleted}} 
						{{else}}
							{{#unless isSmall}}</a>{{/unless}}
						{{/if}}
					</p>
					<p class="author userid-{{author.id}}">{{{authorDisplay}}}</p>
					<p class="metadata">
						<small>{{{metadata}}}</small>
					</p>
					<p class="content-preview">
						{{#if contentPreview}}
							{{contentPreview}}
						{{else}}
							{{description}}
						{{/if}}
					</p>
				</div>
				<div class="card-col-1 result-icon-part">
					{{> systemSticker}}
				</div>
			</div>
		</div>
	</div>
</script>

<script id="result-image-template" type="text/x-handlebars-template">
	<div class="row result">
		<div class="card-horizontal">
			<div class="card-row">
				<div class="card-col-5 result-image-part">
					<div class="image-wrapper">
						<img src="{{imageUrl}}" alt="{{title}}" class="img-responsive" />
					</div>
				</div>
				<div class="card-col-6 result-main-part">
					<p class="result-title">
						<a href="{{url}}">{{title}}</a>
					</p>
					<p class="author userid-{{author.id}}">{{{authorDisplay}}}</p>
					<p class="metadata">
						<small>{{{metadata}}}</small>
					</p>
					{{#if description}}
						<p>{{description}}</p>
					{{/if}}
				</div>
				<div class="card-col-1 result-icon-part">
					{{> systemSticker}}
				</div>
			</div>
		</div>
	</div>
</script>

<script id="result-person-template" type="text/x-handlebars-template">
	<div class="row result">
		<div class="card-horizontal">
			<div class="card-row">
				<div class="card-col-2">
					<div class="image-wrapper">
						<img src="{{thumbUrl}}" alt="{{title}}" class="img-responsive img-person" />
					</div>
				</div>
				<div class="card-col-9 result-main-part">
					<p class="result-title">
						<a href="{{profileUrl}}">{{title}}</a>
					</p>
					<p class="metadata">
						<small>{{{metadata}}}</small>
					</p>
					{{#if description}}
						<p class="description">{{{description}}}</p>
					{{/if}}
				</div>
				<div class="card-col-1 result-icon-part">
					{{> systemSticker}}
				</div>
			</div>
		</div>
	</div>
</script>

<script id="sticker-filetype" type="text/x-handlebars-template">
	<span class="sticker filetype-sticker {{filetypeClass}}" data-toggle="tooltip" data-placement="right"
			title="<liferay-ui:message key='de.iisys.esearch_FileType'/>: {{filetype}}">
		{{filetypeShort}}
	</span>
</script>

<script id="sticker-system" type="text/x-handlebars-template">
	<span class="system-sticker {{systemIcon}}" data-toggle="tooltip" data-placement="right"
			title="<liferay-ui:message key='de.iisys.esearch_System'/>: {{system}}">
	</span>
</script>

<script id="sticker-author" type="text/x-handlebars-template">
	<a href="{{author.profileUrl}}">
		<div class="{{author.id}}-thumbnail user-icon user-icon-default usericon-sticker"
				data-toggle="tooltip" data-placement="right"
				title="<liferay-ui:message key='de.iisys.esearch_Author'/>: {{author.fullname}}">
			{{#if author.thumbUrl}}
				<img alt="thumbnail" class="img-responsive" src="{{author.thumbUrl}}" />
			{{else}}
				{{author.initials}}
			{{/if}}
		</div>
	</a>
</script>

<script id="facet-system-template" type="text/x-handlebars-template">
	<div class="col-md-3">
		<span class="{{systemIcon}} icon-lg {{#if active}}facet-active{{else}}facet-default{{/if}}"></span>
	</div>
</script>

<script id="facet-author-template" type="text/x-handlebars-template">
	<div class="nameplate-label nameplate-label-default">
		<div class="nameplate-field">
			<div class="user-icon user-icon-default">
				{{#if author.thumbUrl}}
					<img alt="thumbnail" class="img-responsive" src="{{author.thumbUrl}}" />
				{{else}}
					author.initials
				{{/if}}
			</div>
			<div class="nameplate-content">{{author.id}}</div>
		</div>
	</div>
</script>


<aui:script>
/******************************************
 * Modules (a la Revealing Module Pattern):
 *  - Helper
 *  - Model
 *  - Facets
 *  - View
 *  - Extractor
 *  - Controller
 ******************************************/

/***********************************************************************************************************/
var <portlet:namespace/>Helper = function() {

	var REL_TIME = {
		anyTime: 'anyTime',
		pastHour: 'pastHour',
		past24Hours: 'past24Hours',
		pastWeek: 'pastWeek',
		pastMonth: 'pastMonth',
		pastQuarter: 'pastQuarter',
		pastYear: 'pastYear'
	};

	var MIMETYPE = {
		'application/msword': 'doc',
		'application/vnd.openxmlformats-officedocument.wordprocessingml.document': 'docx',
		'image/bmp': 'bmp',
		'image/gif': 'gif',
		'image/jpeg': 'jpg',
		'audio/mpeg3': 'mp3',
		'video/mpeg': 'mpg',
		'application/pdf': 'pdf',
		'image/png': 'png',
		'application/vnd.ms-powerpoint': 'ppt',
		'application/vnd.openxmlformats-officedocument.presentationml.presentation': 'pptx',
		'text/plain': 'txt',
		'text/html': 'html',
		'audio/wav': 'wav',
		'audio/x-wav': 'wav',
		'application/vnd.ms-excel': 'xls',
		'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet': 'xlsx'
	};

	

	function updateUsersByIdCallback(data, userPubSub) {
		var userList = [];

		if(data.list) {
			userList = data.list;
		} else if(data.entry) {
			userList.push(data.entry);
		}

		for(var i=0, j=userList.length; i < j; i++) {
			var id = userList[i].id;
			userPubSub.publish(id, userList[i]);
		}
	}

	/* various: */

	function getDateFormatted(dateString) {
		if(!dateString || dateString===undefined)
			return null;

		var d;

		if(dateString instanceof Date)
			d = dateString;
		else {
			d = new Date(dateString);
		}

		if( isNaN(d.getTime()) ) {
			return dateString;
		}

		var month = d.getMonth()+1;
		if(month<10)
			month = '0'+month;
		
		var days = d.getDate();
		if(days<10)
			days = '0'+days;

		var hours = d.getHours();
		if(hours<10)
			hours = '0'+hours;

		var minutes = d.getMinutes();
		if(minutes<10)
			minutes = '0'+minutes;
			
		return d.getFullYear()+'-'+month+'-'+days+' '+hours+':'+minutes;
	}

	function getDateRelative(dateString) {
		if(!dateString || dateString===undefined)
			return null;

		var d = new Date(dateString),
			elapsed = new Date() - d,

			msPerMinute = 60 * 1000,
		    msPerHour = msPerMinute * 60,
		    msPerDay = msPerHour * 24,
		    msPerMonth = msPerDay * 30,
		    msPerYear = msPerDay * 365;

	    if (elapsed < msPerHour) {
	    	return REL_TIME.pastHour;   
	    } else if (elapsed < msPerDay ) {
	    	return REL_TIME.past24Hours;
	    } else if (elapsed < msPerDay*7) {
	    	return REL_TIME.pastWeek;
	    } else if (elapsed < msPerMonth) {
	        return REL_TIME.pastMonth; 
	    } else if (elapsed < msPerMonth*3) {
	    	return REL_TIME.pastQuarter;
	    } else if (elapsed < msPerYear) {
	        return REL_TIME.pastYear;   
	    } else {
	        return REL_TIME.anyTime;   
	    }
	}

	function getFileSizeAsText(sizeInByte) {
		if(!sizeInByte || sizeInByte===undefined)
			return null;

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

	function getFiletypeByMimetype(mimeType) {
		var filetype = MIMETYPE[mimeType];

		if(filetype)
			return filetype;
		else
			return null;
	}

	function stripHTML(dirtyString) {
		/*
		var container, text;
		container = document.createElement('div');
		text = document.createTextNode(dirtyString);
		container.appendChild(text);
		return container.innerHTML; // innerHTML will be a xss safe string
		*/
		return $('<div>').html(dirtyString).text();
	}

	function loadTooltips() {
		$('[data-toggle="tooltip"]').tooltip();
	}

	
	function sendAsyncRequest(method, url, successCallback, errorCallback, payload, callbackValue) {
		AUI().use('aui-io-request', function(A)
		{
			
			if(payload && payload!=='') {
			  A.io.request(url, {
//				  dataType: 'json',
				  method : method,
				  xhrFields: {
				      withCredentials: true
				   },
				  headers: {
//						'Content-Type': 'application/json; charset=utf-8'
						'Content-Type': 'text/plain'
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
//				  dataType: 'json',
				  method : method,
				  xhrFields: {
				      withCredentials: true
				   },
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
	

	function sendRequest(method, url, callback, errorCallback, payload) {
        var xhr = new XMLHttpRequest();

        xhr.open(method, url, true);
//        xhr.responseType = 'json';       
        xhr.withCredentials = true;

        xhr.onreadystatechange = function() {
        	if(xhr.readyState === 4) {
	            if(xhr.status === 200) {
	            	if(callback) {
	            		try {
							callback(JSON.parse(xhr.response));
						} catch(err) {
							errorCallback(err.message);
						}
					}
//					console.log(xhr.response);
	            } else {
	              var message = xhr.status + ': ' + xhr.statusText;
	              if(callback)
	              	errorCallback(message, xhr);
	            }
        	}
        }

        if(payload) {
//	        xhr.setRequestHeader('Content-Type', 'application/json');
			xhr.setRequestHeader('Content-Type', 'text/plain');
        	xhr.send(JSON.stringify(payload));
        } else {
          xhr.send();
        }
    }

	return {
		REL_TIME: REL_TIME,
		updateUsersByIdCallback: updateUsersByIdCallback,
		getDateFormatted: getDateFormatted,
		getDateRelative: getDateRelative,
		getFileSizeAsText: getFileSizeAsText,
		getFiletypeByMimetype: getFiletypeByMimetype,
		stripHTML: stripHTML,
		loadTooltips: loadTooltips,
		sendAsyncRequest: sendAsyncRequest,
		sendRequest: sendRequest
	};
}();
/* END Helper module */


/***********************************************************************************************************/
var <portlet:namespace/>Model = function(Helper) {

	var Result = function(title, content, url, author, createDate) {
		this.title = title || '';
		this.content = content || '';
		this.url = url || '';
		this.author = author;
		this.createDate = createDate || null;
	};

	var DocumentResult = function(title, content, url, author, createDate, editedDate, fileSize) {
		Result.call(this, title, content, url, author, createDate);

		this.createDate = createDate || null;
		this.editedDate = editedDate || null;
		this.fileSize = fileSize || 0;	
	};
	DocumentResult.prototype = new Result;

		var ImageResult = function(title, imageUrl, url, author, createDate, editedDate, fileSize) {
			DocumentResult.call(this, title, '', url, author, createDate, editedDate, fileSize);

			this.imageUrl = imageUrl || '';
		};
		ImageResult.prototype = new DocumentResult;

		var LiferayResult = function(title, content, url, author, createDate, editedDate, primKey, type) {
			DocumentResult.call(this, title, content, url, author, createDate, editedDate);

			this.primKey = primKey || 0;
			this.type = type;
		};
		LiferayResult.prototype = new DocumentResult;

	var MailResult = function(title, content, url, author, timeSent, folder) {
		Result.call(this, title, content, url, author, timeSent);

		this.timeSent = timeSent;
		this.folder = folder;
		this.filetype = '';
		this.recipients = [];
	};
	MailResult.prototype = new Result;

	var MessageResult = function(title, content, url, author, timeSent, type, msgId) {
		Result.call(this, title, content, url, author, timeSent);

		this.sender = author;
		this.msgId = msgId || null;
		this.timeSent = timeSent || 0;
		this.type = type || '';

		this.filetype = '';
		this.recipients = [];		
	};
	MessageResult.prototype = new Result;

	var ActivityResult = function(title, content, actor, timeSent, verb, object, target) {
		Result.call(this, title, content, '', actor, timeSent);

		this.timeSent = timeSent || 0;

		this.object = object || {};
		this.target = target || {};
		this.verb = verb || '';
		this.isSmall = true;
	};
	ActivityResult.prototype = new Result;


	var User = function(id) {
		this.id = id || '';
		this.givenName = '';
		this.lastname = '';
		this.fullname;
		this.initials;
		this.mail;
		this.profileUrl = '';
		this.thumbUrl;
	};

	var UserResult = function(id, displayName, mail, profileUrl, thumbUrl) {
		User.call(this, id);

		this.fullname = displayName;
		this.mail = mail;
		this.profileUrl = profileUrl;
		this.thumbUrl = thumbUrl;

		this.author = this;
	};
	UserResult.prototype = new User;


	function createUser(id, fullname, givenName, lastname, mail, config) {
		var user = new User(id);

		if(mail)
			user.mail = mail;

		if(id && config) {
			user.profileUrl = config.URL.system.liferay + config.URL.liferay.userProfile + id;
			user.thumbUrl = config.URL.system.liferay
							+ config.URL.liferay.userThumbUrl_pre
							+ id
							+ config.URL.liferay.userThumbUrl_after;
		}

		if(givenName)
			user.givenName = givenName;

		if(lastname)
			user.lastname = lastname;

		if(fullname) {
			user.fullname = fullname;
			if(!givenName || !lastname) {
				var names = fullname.split(' ');
				user.givenName = names[0];
				user.lastname = names[1];
			}
		} else if(givenName && lastname) {
			user.fullname = givenName + ' ' + lastname;
		}
		
		if(user.givenName && user.lastname)	
			user.initials = user.givenName.substring(0,1).toUpperCase() + user.lastname.substring(0,1).toUpperCase();
		else if(user.id)
			user.initials = user.id.substring(0,1).toUpperCase();

		return user;
	}

	return {
		DocumentResult: DocumentResult,
		ImageResult: ImageResult,
		LiferayResult: LiferayResult,
		MailResult: MailResult,
		MessageResult: MessageResult,
		ActivityResult: ActivityResult,
		UserResult: UserResult,
		User: User,

		createUser: createUser
	};
}(<portlet:namespace/>Helper);
/* END Model module */


/***********************************************************************************************************/
var <portlet:namespace/>UserHelper = function(Helper, Model) {
	var allUserObjects = [],
		CONFIG,
		function_consolidateAuthorFacets,
		isPagination;

	function getAllUserObjects() {
		return allUserObjects;
	}

	function getUserObject(userId, liferayUserId, mail, fullname, config) {
		var pos = -1,
			user;

		if(userId) {
			pos = _getUserPosById(userId);
		} 
		if(pos===-1 && liferayUserId) {
			pos = _getUserPosByLiferayUserId(liferayUserId);
		}
		if(pos===-1 && mail) {
			pos = _getUserPosByMail(mail);
		}
		if(pos===-1 && fullname) {
			pos = _getUserPosByFullname(fullname);
		}

		if(pos > -1) { // if user found, return her object:
			user = allUserObjects[pos];
			// if we have more infos than the found user, forward the infos:
			if(userId && (!user.id || user.id===''))
				user.id = userId;
			if(fullname && (!user.fullname || user.fullname===''))
				user.fullname = fullname;

		} else { // if user not found, create a new user object for him:
			user = Model.createUser(userId, fullname, null, null, null, config);
			// prepare observer arrays:
			user.observer_fullname_text = [];
			user.observer_AuthorSticker = [];
			user.observer_thumb = [];

			allUserObjects.push( user );
		}
		// if we have more infos than the found user, forward the infos:
		if(mail && (!user.mail || user.mail===''))
			user.mail = mail;
		if(liferayUserId && (!user.liferayUserId || user.liferayUserId===''))
			user.liferayUserId = liferayUserId;


		return user;
	}
	function _getUserPosById(userId) {
		return allUserObjects.map(function(obj) { return obj.id; }).indexOf( userId );
	}
	function _getUserPosByFullname(fullname) {
		return allUserObjects.map(function(obj) { return obj.fullname; }).indexOf( fullname );
	}
	function _getUserPosByMail(mail) {
		return allUserObjects.map(function(obj) { return obj.mail; }).indexOf( mail );
	}
	function _getUserPosByLiferayUserId(liferayUserId) {
		return allUserObjects.map(function(obj) { return obj.liferayUserId; }).indexOf( liferayUserId );
	}

	function user_setFullname(userId, fullname) {
		user.fullname = fullname;
		var observers = user.observerFullname;
		for(var i=0, j=observers.length; i < j; i++) {
			observers[i](fullname);
		}
	}


	function updateUserObjects(config, consolidateAuthorFacets, isPaginationSearch) {
		CONFIG = config;
		function_consolidateAuthorFacets = consolidateAuthorFacets;
		isPagination = isPaginationSearch;
		_getUsersFromShindig(config);
	}

	function _consolidateUsers() {
		var obj, 
			pos = -1,
			indicesToRemove = [],
			foundUser;

		for(var i=0, j=allUserObjects.length; i < j; i++) {
			obj = allUserObjects[i];

			if(!obj.id || obj.id==='') {
				if(obj.fullname && obj.fullname!=='')
					pos = _getUserPosByFullname(obj.fullname);
				if(pos===-1 && obj.mail && obj.mail!=='')
					pos = _getUserPosByMail(obj.mail);
				if(pos===-1 && obj.liferayUserId && obj.liferayUserId!=='')
					pos = _getUserPosByLiferayUserId(obj.liferayUserId);

				if(pos > -1 && pos!==i) { // if the same user was found:
					// move observers to found user:
					allUserObjects[pos].observer_fullname_text = (allUserObjects[pos].observer_fullname_text).concat(obj.observer_fullname_text);
					allUserObjects[pos].observer_AuthorSticker = (allUserObjects[pos].observer_AuthorSticker).concat(obj.observer_AuthorSticker);
					allUserObjects[pos].observer_thumb = (allUserObjects[pos].observer_thumb).concat(obj.observer_thumb);
					// found user might not have liferayUserId:
					if(obj.liferayUserId)
						allUserObjects[pos].liferayUserId = obj.liferayUserId;

					// keep index to remove old user:
					indicesToRemove.push( i );
				}
			}

			obj = null;
		}

		// remove old users:
		for(var i=0, j=indicesToRemove.length; i < j; i++) {
			allUserObjects.splice(indicesToRemove[i], 1);
		}

		_updateObservers();
		if(!isPagination)
			function_consolidateAuthorFacets();
	}

	/* requests: */

	function _getUsersFromShindig(config) {
		var userIds = '',
			fullnames = [],
			name,
			id,
			length = allUserObjects.length,
			first = length;

		for(var i=0; i < length ; i++) {
			id = allUserObjects[i].id;
			if(id==='Administrator')
				continue;

			if(id && id!== '') {
				userIds += id;
				first = i;
				break;
			} else {
				name = allUserObjects[i].fullname;
				if(name && name!=='')
					fullnames.push(name);
			}
		}

		if(first+1 < length) {
			for(var i = first+1; i < length ; i++) {
				id = allUserObjects[i].id;
				if(id==='Administrator')
					continue;

				if(id && id!== '') {
					userIds += ',' + id;
				} else {
					name = allUserObjects[i].fullname;
					if(name && name!=='')
						fullnames.push(name);
				}
			}
		}

		// get users by id:
		if(userIds !== '') {
			var url = config.URL.system.shindig + config.URL.shindig.api + config.URL.shindig.people_pre + userIds + config.URL.shindig.people_after;
			Helper.sendAsyncRequest('GET', url, _callbackUsersFromShindig);
		}

		// get each user by fullname/displayName
		if(fullnames.length > 0) {
			var url;
			for(var i=0, j=fullnames.length; i < j; i++) {
				url = config.URL.system.shindig + config.URL.shindig.api + config.URL.shindig.user_pre + fullnames[i] + config.URL.shindig.user_after;
				Helper.sendAsyncRequest('GET', url, _callbackFullnameUsersFromShindig);
			}
		}
	}

	/* callbacks: */

	function _callbackUsersFromShindig(response) {
		var user, obj,
			response = JSON.parse(response);

		//console.log(response);

		if(!response.list) {
			response.list = [];
			if(response.entry)
				response.list.push(response.entry);
		}

		for(var i=0, j=response.list.length; i < j; i++) {
			obj = response.list[i];
			user = getUserObject(obj.id);

			user.fullname = obj.displayName;
			user.lastname = obj.name.familyName;
			user.givenName = obj.name.givenName;
			user.initials = user.givenName.substring(0,1) + user.lastname.substring(0,1);
			if(obj.emails && obj.emails.length > 0)
				user.mail =  obj.emails[0].value;
		}

		_consolidateUsers();

	}

	function _callbackFullnameUsersFromShindig(response) {
		var obj, pos, oldUser
			response = JSON.parse(response);
		if(response.list.length===1) {
			obj = response.list[0];
			pos = _getUserPosById(obj.id);
			if(pos > -1)
				return;

			pos = _getUserPosByFullname(obj.displayName);
			oldUser = allUserObjects[pos];
			allUserObjects[pos] = Model.createUser(obj.id, obj.displayName,  obj.name.givenName, obj.name.familyName, obj.emails[0].value, CONFIG);
			allUserObjects[pos].observer_fullname_text = oldUser.observer_fullname_text;
			allUserObjects[pos].observer_AuthorSticker = oldUser.observer_AuthorSticker;
			allUserObjects[pos].observer_thumb = oldUser.observer_thumb;

			_updateObserverForPos(pos);
		}
	}

	/* observer: */

	function _updateObservers() {
		var obj, observers,
			el;

		for(var i=0, j=allUserObjects.length; i < j; i++) {
			
			_updateObserverForPos(i);

		}
	}

	function _updateObserverForPos(pos) {
		var obj, observers,
			el;

		obj = allUserObjects[pos];
		// fullname observers:
		if(obj.fullname) {
			observers = obj.observer_fullname_text;
			for(var x=0, z=observers.length; x < z; x++) {
				$(observers[x]).text( obj.fullname );
			}
		}

		// author sticker observers:
		observers = obj.observer_AuthorSticker;
		for(var x=0, z=observers.length; x < z; x++) {
			el = $(observers[x]);
			/*
			if(obj.profileUrl)
				el.attr('href', obj.profileUrl);
			if(obj.fullname)
				el = el.children().attr('data-original-title', '<liferay-ui:message key="de.iisys.esearch_Author"/>: ' + obj.fullname);
			if(obj.thumbUrl) {
				if(el.children().length === 0) {
					el.empty().append(
						$('<img>').addClass('img-responsive').attr('src', obj.thumbUrl).attr('alt', obj.initials)
					);
				}
			}
			*/
			if(obj.profileUrl) {
				el.wrap('<a href="'+obj.profileUrl+'" class="author-link"></a>');
				if(obj.thumbUrl) {
					el.parent().prepend(
						$('<div class="popup-user">').append(
							$('<div class="popup-user-inner">').append(
								$('<img src="'+obj.thumbUrl+'" style="width:100%;" />')
							)
						)
					);
				}
			}
			if(obj.fullname)
				el.text(obj.fullname);
		}

		// thumb observers / nameplates:
		observers = obj.observer_thumb;
		for(var x=0, z=observers.length; x < z; x++) {
			el =  $(observers[x]);
			if(obj.thumbUrl) {
				el.empty().append(
					$('<img>').addClass('img-responsive').attr('src', obj.thumbUrl).attr('alt', obj.initials)
				);
			}
		}
	}

	function addObserver_fullname_text(element, userId) {
		var user = getUserObject(userId);
		if(!user.observer_fullname_text)
			user.observer_fullname_text = [];

		user.observer_fullname_text.push(element);
	}

	function addObserver_fullname_title(element, userId) {
		getUserObject(userId).observer_fullname_title.push(element);
	}

	function addObserver_AuthorSticker(element, userId, fullname) {
		if(userId) {
			getUserObject(userId).observer_AuthorSticker.push(element);
		} else if(fullname) {
			getUserObject(null, null, null, fullname).observer_AuthorSticker.push(element);
		}
	}

	function addObserver_thumb(element, fullname) {
		getUserObject(null, null, null, fullname).observer_thumb.push(element);
	}


	return {
		getAllUserObjects: getAllUserObjects,
		getUserObject: getUserObject,
		updateUserObjects: updateUserObjects,
		addObserver_fullname_text: addObserver_fullname_text,
		addObserver_AuthorSticker: addObserver_AuthorSticker,
		addObserver_thumb: addObserver_thumb
	};
}(<portlet:namespace/>Helper, <portlet:namespace/>Model);
/* END UserHelper module */


/***********************************************************************************************************/
var <portlet:namespace/>Facets = function() {
	var filetypeGroups = {
		text: [
//			'doc', 'docx', 'pdf', 'ppt', 'pptx', 'txt', 'xls', 'xlsx'
			'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
			'application/pdf', 'text/plain',
			'application/vnd.ms-powerpoint', 'application/vnd.openxmlformats-officedocument.presentationml.presentation',
			'application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
		],
		image: [
//			'bmp', 'gif', 'jpg', 'jpeg', 'png',
			'image/bmp', 'image/gif', 'image/jpeg', 'image/png'
		],
		sound: [
//			'm4a', 'mp3', 'wav'
			'audio/mpeg3', 'audio/wav', 'audio/x-wav'
		],
		video: [
//			'mkv', 'mp4', 'mpeg',
			'video/mpeg'
		]
	}

	var GROUP_FILETYPE = 'filetype',
		GROUP_FILETYPE_GROUP = 'filetypeGroup',
		GROUP_CREATED = 'created',
		GROUP_AUTHOR = 'author',
		GROUP_SYSTEM = 'system',

		initialFacets,
		availableFacets,
		chosenFacets,
		excludedFacets;

	function init() {
		console.log('Init Facet Module.');

		resetFacets();
	}

	function resetFacets() {
		initialFacets = [];
		availableFacets = {};
		availableFacets[GROUP_FILETYPE_GROUP] = [];
		chosenFacets = {};
		chosenFacets[GROUP_FILETYPE_GROUP] = [];
		excludedFacets = {};
	}

	function softReset() {
		if(initialFacets.length === 0)
			initialFacets = availableFacets;

		availableFacets = {};
		availableFacets[GROUP_FILETYPE_GROUP] = [];
	}

	function addFacet(group, facet) {
		var pos;
		
		if(availableFacets[group]) {
			// author facets:
			if(group===GROUP_AUTHOR)
				return _addFacetAuthor(facet);

			// standard facets:
//			pos = availableFacets[group].indexOf(facet)
			pos = availableFacets[group].map(function(obj) { return obj.facet; }).indexOf(facet);
			if(pos > -1) {
				availableFacets[group][pos].count = availableFacets[group][pos].count + 1;
				return;
			}
		} else {
			availableFacets[group] = [];
		}

		// additional: filetype groups:
		if(group===GROUP_FILETYPE) {
			_addFacetFiletypeGroups(facet);
		}

		availableFacets[group].push({facet: facet, count: 1});
	}

	function _addFacetAuthor(facet) {
		var pos = -1;

		if(facet.id==='' && facet.fullname)
			pos = availableFacets[GROUP_AUTHOR].map(function(obj) { return obj.facet.fullname; }).indexOf(facet.fullname);
		else
			pos = availableFacets[GROUP_AUTHOR].map(function(obj) { return obj.facet.id; }).indexOf(facet.id);
		
		if(pos > -1) {
			availableFacets[GROUP_AUTHOR][pos].count++;
			return;
		}

		availableFacets[GROUP_AUTHOR].push({facet: facet, count: 1});
	}

	function _addFacetFiletypeGroups(facet) {
		if(filetypeGroups.text.indexOf(facet) > -1) {
			if(availableFacets[GROUP_FILETYPE_GROUP].indexOf('text') === -1)
				availableFacets[GROUP_FILETYPE_GROUP].push('text');

		} else if(filetypeGroups.image.indexOf(facet) > -1) {
			if(availableFacets[GROUP_FILETYPE_GROUP].indexOf('image') === -1)
				availableFacets[GROUP_FILETYPE_GROUP].push('image');

		} else if(filetypeGroups.sound.indexOf(facet) > -1) {
			if(availableFacets[GROUP_FILETYPE_GROUP].indexOf('sound') === -1)
				availableFacets[GROUP_FILETYPE_GROUP].push('sound');

		} else if(filetypeGroups.video.indexOf(facet) > -1) {
			if(availableFacets[GROUP_FILETYPE_GROUP].indexOf('video') === -1)
				availableFacets[GROUP_FILETYPE_GROUP].push('video');
		}
	}

	function chooseFacet(group, facet) {
		_updateFacets(chosenFacets, group, facet);
	}

	function excludeFacet(group, facet) {
		_updateFacets(excludedFacets, group, facet);
	}

	function consolidateAuthorFacets() {
		var obj, 
			pos = -1,
			indicesToRemove = [],
			foundUser;

		if(availableFacets[GROUP_AUTHOR]) {
			for(var i=0, j=availableFacets[GROUP_AUTHOR].length; i < j; i++) {
				obj = availableFacets[GROUP_AUTHOR][i];

				if(!obj.facet.id || obj.facet.id==='') {
					pos = availableFacets[GROUP_AUTHOR].map(function(object) { return object.facet.fullname; }).indexOf( obj.facet.fullname );

					if(pos > -1 && pos!==i) { // if the same user was found:
						// move count to found author:
						availableFacets[GROUP_AUTHOR][pos].count += obj.count;

						// keep index to remove old user:
						indicesToRemove.push( i );
					}
				}
				obj = null;
			}

			// remove double authors:
			for(var i=0, j=indicesToRemove.length; i < j; i++) {
				availableFacets[GROUP_AUTHOR].splice(indicesToRemove[i], 1);
			}
		}
	}

	function _updateFacets(facetsList, group, facet) {
		if(facetsList[group]) {
			if(group===GROUP_AUTHOR) {
				var index = facetsList[GROUP_AUTHOR].map(function(obj) { return obj.id; }).indexOf(facet.id);
				if(index > -1) {
					if(facetsList[GROUP_AUTHOR].length===1)
						delete facetsList[GROUP_AUTHOR];
					else
						facetsList[GROUP_AUTHOR].splice(index, 1);
					return;
				}
			} else {
				var index = facetsList[group].indexOf(facet);
				if(index > -1) {					
					if(facetsList[group].length===1)
						delete facetsList[group];
					else
						facetsList[group].splice(index, 1);
					return;
				}
			}					
		} else {
			facetsList[group] = [];
		}

		facetsList[group].push(facet);
	}

	function getFacets() {
		var facets = {
			chosen: chosenFacets,
			available: availableFacets,
			initial: initialFacets,
			excluded: excludedFacets,
			consolidateAuthorFacets: consolidateAuthorFacets
		};

		return facets;
	}

	function getChosenFacetsOrNull() {
		if(Object.keys(chosenFacets).length < 2 && chosenFacets[GROUP_FILETYPE_GROUP].length < 1)
			return null;
		else
			return chosenFacets;
	}

	function getExcludedFacetsOrNull() {
		if(Object.keys(excludedFacets).length > 0)
			return excludedFacets;
		else
			return null;
	}

	return {
		GROUP_FILETYPE: GROUP_FILETYPE,
		GROUP_FILETYPE_GROUP: GROUP_FILETYPE_GROUP,
		GROUP_CREATED: GROUP_CREATED,
		GROUP_AUTHOR: GROUP_AUTHOR,
		GROUP_SYSTEM: GROUP_SYSTEM,
		filetypeGroups: filetypeGroups,
		init: init,
		resetFacets: resetFacets,
		softReset: softReset,
		addFacet: addFacet,
		chooseFacet: chooseFacet,
		excludeFacet: excludeFacet,
		getFacets: getFacets,
		getChosenFacetsOrNull: getChosenFacetsOrNull,
		getExcludedFacetsOrNull: getExcludedFacetsOrNull,
		consolidateAuthorFacets: consolidateAuthorFacets
	};
}();	
/* END Facets module */


/***********************************************************************************************************/
var <portlet:namespace/>View = function(Helper, UserHelper, Facets) {
	var config = {
			contentLength: 250
		},
	
		CSS = {
			classes: {
				filetypeSticker: {
					doc: 'filetype-doc',
					docx: 'filetype-doc',
					pdf: 'filetype-pdf',
					ppt: 'filetype-ppt',
					pptx: 'filetype-ppt',
					xls: 'filetype-xls',
					xlsx: 'filetype-xls',
					gif: 'filetype-image',
					jpg: 'filetype-image',
					jpeg: 'filetype-image',
					png: 'filetype-image',
					activity: 'filetype-activity',
					image: 'filetype-image',
					liferay: 'filetype-liferay',
					mail: 'filetype-mail',
					message: 'filetype-message',
					person: 'filetype-person',
					Workspace: 'filetype-person'
				},
				facet: {
					facetActive: 'facet-active',
					facetAvailable: 'facet-available',
					facetDefault: 'facet-default',
					facetActiveBorder: 'facet-active-border'
				},
				perPage: 'per-page'
			},
			ids: {
				searchField: 'searchfield',
				searchResults: '<portlet:namespace/>searchresults',
				systemButton: '<portlet:namespace/>systemButton',
				systemToSearchDropdown: '<portlet:namespace/>systemToSearch',
				sortBy: '<portlet:namespace/>sortBy',
				sortByDropdown: '<portlet:namespace/>sortByDropdown',
				facetDocs: 'facet_docs',
				facetImages: 'facet_images',
				facetSounds: 'facet_sounds',
				facetVideos: 'facet_videos',
				facetAllFiletypes: 'facet_all-filetypes',
				facetAuthors: 'facet_authors',
				facetCreated: 'facet_created',
				facetSystems: 'facet_systems',
				filetypeToggler: '<portlet:namespace/>filetype-toggler',
				filteredOfAll: '<portlet:namespace/>filteredOfAll',
				pagination: '<portlet:namespace/>pagination',
				tabsId: 'filetype-tab'
			}
		},

		ICON = {
			caretDown: 'icon-caret-down',
			caretRight: 'icon-caret-right',			
			fileSize: 'icon-file',
			mail: 'icon-envelope',
			mailFolder: 'icon-folder-open-alt',
			paginationLeft: 'icon-caret-left',
			paginationRight: 'icon-caret-right',
			phone: 'icon-phone',
			publicMsg: 'icon-globe',
			sentTo: 'icon-long-arrow-right',
			system: {
				liferay: 'icon-desktop',
				shindigMessage: 'icon-comments',
				shindigPerson: 'icon-user',
				nuxeo: 'icon-folder-open',
				mail: 'icon-envelope-alt',
				user: 'icon-user'
			},
			tags: 'icon-tags'
		},

		RESULTS_PER_PAGE = [
			10, 25, 50
		];

		SRC = {
			image: {
				doc: '<%=request.getContextPath()%>/images/word.svg',
				pdf: '<%=request.getContextPath()%>/images/pdf.svg',
				ppt: '<%=request.getContextPath()%>/images/ppt.svg',
				xls: '<%=request.getContextPath()%>/images/excel.svg'
			}
		};

	var templateDefault = null,
		templateImage = null,
		templatePerson = null,
		templateFacetSystem = null;


	function init(SYSTEM) {
		console.log('Init View Module.');

		AUI().use('handlebars', function(A) {			
			
			_initHandelbarsPartials(A);

			/* template creation: */
		    var source = $('#result-default-template').html();
			templateDefault = A.Handlebars.compile(source);
			source = null;

			source = $('#result-image-template').html();
			templateImage = A.Handlebars.compile(source);

			source = $('#result-person-template').html();
			templatePerson = A.Handlebars.compile(source);

			source = $('#facet-system-template').html();
			templateFacetSystem = A.Handlebars.compile(source);
		});

		$('#'+CSS.ids.filetypeToggler).click(CSS.ids.facetAllFiletypes, _toggle);
	}

	function _initHandelbarsPartials(A) {
		A.Handlebars.registerPartial('filetypeSticker', $('#sticker-filetype').html());
	    A.Handlebars.registerPartial('systemSticker', $('#sticker-system').html());
	    A.Handlebars.registerPartial('userIcon', $('#sticker-author').html());
	}


	/* getHtml: */

	function getHtml_ResultDocument(result) {
		var html = '';

		if(templateDefault!==null) {
			if(typeof templateDefault === 'function') {
				if(result) {
					
					result.systemIcon = ICON.system.nuxeo;
					result.system = 'Nuxeo';
					result.metadata = _getHtml_MetadataDocument(result);

					var content = result.content;
					if(content) {
						if(content.length > 260)
							result.contentPreview = content.substring(0,257)+'...';
						else
							result.contentPreview = content;
					}

					if(result.state && result.state==='deleted') {
						result.deleted = true;
					}

					if(result.author) {
						if(result.author.fullname)
							result.authorDisplay = result.author.fullname;
						else if(result.author.id) {
							result.authorDisplay = $('<span>').text(result.author.id);
							UserHelper.addObserver_fullname_text(result.authorDisplay, result.author.id);
						}
					}		
				}

				html = templateDefault( result );
			} else {
				console.log('Error: templateDefault is not a function!');
			}			
		} else {
			console.log('Error: templateDefault is null!');
		}

		return html;
	}

	function _getHtml_MetadataDocument(result) {
		var createDate = Helper.getDateFormatted( result.createDate ),
			editedDate = Helper.getDateFormatted( result.editedDate ),
			size = Helper.getFileSizeAsText( result.fileSize );

		var metadata = '<liferay-ui:message key="de.iisys.esearch_Created"/>: '+createDate;
		if(editedDate && createDate!==editedDate)
			metadata += ' | <liferay-ui:message key="de.iisys.esearch_LastEdited"/>: '+editedDate;
		if(size!==null)
			metadata += ' | <i class="' + ICON.fileSize + '"></i> '+size;
		if(result.filetype) {
			result.filetypeClass = CSS.classes.filetypeSticker[result.filetype];
			if(!result.filetypeClass)
				result.filetypeClass = '';

			metadata += ' | <span class="filetype-bonbon '+result.filetypeClass+'">' + result.filetype.toUpperCase() + '</span>';
		}

		return metadata;
	}

	function getHtml_ResultImage(result) {
		var html = '';

		if(templateImage!==null && typeof templateImage === 'function') {
			if(result) {
				
				result.systemIcon = ICON.system.nuxeo;
				result.system = 'Nuxeo';
				result.metadata = _getHtml_MetadataImage(result);

				if(result.author) {
					if(result.author.fullname)
						result.authorDisplay = result.author.fullname;
					else if(result.author.id) {
						result.authorDisplay = $('<span>').text(result.author.id);
						UserHelper.addObserver_fullname_text(result.authorDisplay, result.author.id);
					}
				}	

				html = templateImage( result );
			}		
		} else {
			console.log('Error: templateImage is null or not a function!');	
		}

		return html;
	}

	function getHtml_ResultLiferay(result) {
		var html = '';

		if(templateDefault!==null && typeof templateDefault === 'function') {
			if(result) {
				if(result.filetype) {
					result.filetypeClass = CSS.classes.filetypeSticker[result.filetype];
					result.filetypeShort = result.filetype.substring(0,3).toUpperCase();
				} else if(result.type) {
					result.filetype = result.type;
					result.filetypeClass = CSS.classes.filetypeSticker.liferay;
					result.filetypeShort = result.type.substring(0,1).toUpperCase();
				}
				result.systemIcon = ICON.system.liferay;
				result.system = 'Liferay';				

				var content = result.content;
				if(content) {
					if(content.length > 260)
						result.contentPreview = content.substring(0,257)+'...';
					else
						result.contentPreview = content;
				}

				if(result.imageUrl) {
					result.metadata = _getHtml_MetadataImage(result);
					html = templateImage( result );
				} else {
					result.metadata = _getHtml_MetadataDocument(result);
					html = templateDefault( result );
				}
			}
		} else {
			console.log('Error: templateDefault is null or not a function!');	
		}
		return html;
	}

	function _getHtml_MetadataImage(result) {
		var createDate = Helper.getDateFormatted( result.createDate ),
			editedDate = Helper.getDateFormatted( result.editedDate ),
			size = Helper.getFileSizeAsText( result.fileSize );

		var metadata = '<liferay-ui:message key="de.iisys.esearch_Created"/>: '+createDate;
		if(editedDate && createDate!==editedDate)
			metadata += '<br /><liferay-ui:message key="de.iisys.esearch_LastEdited"/>: '+editedDate;
		if(size!==null)
			metadata += '<br /><i class="' + ICON.fileSize + '"></i> '+size;
		if(result.filetype) {
			result.filetypeClass = CSS.classes.filetypeSticker[result.filetype];

			metadata += ' | <span class="filetype-bonbon '+result.filetypeClass+'">' + result.filetype.toUpperCase() + '</span>';
		}

		return metadata;
	}

	function getHtml_ResultMail(result) {
		var html = '';

		if(templateDefault!==null && typeof templateDefault === 'function') {
			if(result) {
				// prepare result for template:
				result.filetypeClass = CSS.classes.filetypeSticker.mail;
				result.filetypeShort = result.filetype.substring(0,1);
				result.systemIcon = ICON.system.mail;
				result.system = '<liferay-ui:message key="de.iisys.esearch_Mail"/>';
				result.metadata = _getHtml_MetadataMail(result);

				var content = result.content;
				if(content.length > 260)
					result.contentPreview = content.substring(0,257)+'...';
				else
					result.contentPreview = content;
			}

			html = templateDefault(result);
		} else {
			console.log('Error: templateDefault is null or not a function!');	
		}

		return html;
	}

	function _getHtml_MetadataMail(result) {
		var timeSent = Helper.getDateFormatted( result.timeSent ),
			author = result.author.fullname,
			authorMail = result.author.mail,
			recipients,
			folder = result.folder.toUpperCase();

		var metadata = '<liferay-ui:message key="de.iisys.esearch_Sent"/>: '+timeSent
			+ ' | <liferay-ui:message key="de.iisys.esearch_From"/>: '
				+ '<a href="mailto:'+authorMail+'" title="'+authorMail+'">'+author+'</a>'
			+ ' | <i class="'+ ICON.mailFolder +'"></i> '+folder;

		return metadata;
	}

	function getHtml_ResultMessage(result, userPubSub) {
		var html = '';
		if(templateDefault!==null && typeof templateDefault === 'function') {
			if(result) {
				// prepare result for template:
				result.filetypeClass = CSS.classes.filetypeSticker.message;
				result.filetypeShort = result.filetype.substring(0,1);
				result.systemIcon = ICON.system.shindigMessage;
				result.system = '<liferay-ui:message key="de.iisys.esearch_Message"/>';
				result.metadata = _getHtml_MetadataMessage(result);

				var content = result.content;
				if(content.length > 260)
					result.contentPreview = content.substring(0,257)+'...';
				else
					result.contentPreview = content;
			}

			html = templateDefault( result );		
		} else {
			console.log('Error: templateDefault is null or not a function!');
		}

		return html;
	}

	function _getHtml_MetadataMessage(result) {
		var timeSent = Helper.getDateFormatted( result.timeSent ),
			recipients = '',
			sender,
			tempRec,
			type;

		for(var i=0, j=result.recipients.length; i < j; i++) {
			tempRec = result.recipients[i];

			if(i > 0)
				recipients += ', ';

			recipients += '<a href="'+tempRec.profileUrl+'">'
							+ '<span class="'+tempRec.id+'">'+tempRec.id+'</span></a>';

			tempRec = null;
		}

		type = '<i class="'+ ICON.publicMsg +'"></i> <liferay-ui:message key="de.iisys.esearch_Public"/>';

		sender = $('<span>').text(result.sender.id);
//		userPubSub.subscribe(result.sender.id, sender, _updateUserName);

		var metadata = '<liferay-ui:message key="de.iisys.esearch_Sent"/>: '+timeSent
			+ ' | '	+ '<liferay-ui:message key="de.iisys.esearch_From"/>: <a href="'+result.sender.profileUrl+'">'
				+ sender.html() + '</a>'
			+ ' <i class="' + ICON.sentTo + '"></i> <liferay-ui:message key="de.iisys.esearch_To"/>: ' + recipients
			+ ' | ' +type;

		return metadata;
	}

	function getHtml_ResultActivity(result) {
		var html = '';
		if(templateDefault!==null && typeof templateDefault === 'function') {
			if(result) {
				// prepare result for template:
				result.filetypeClass = CSS.classes.filetypeSticker.activity;
				result.filetypeShort = result.filetype.substring(0,1);
				result.systemIcon = ICON.system.shindigActivity;
				result.system = '<liferay-ui:message key="de.iisys.esearch_Activities"/>';

				if(!result.title) {
					result.title = '<liferay-ui:message key="de.iisys.esearch_Activity"/>: '
							+ result.author.fullname + ' | ' + result.verb;
				}

				result.metadata = _getHtml_MetadataActivity(result);

				var content = result.content;
				if(content.length > 260)
					result.contentPreview = content.substring(0,257)+'...';
				else
					result.contentPreview = content;
			}

			html = templateDefault( result );		
		} else {
			console.log('Error: templateDefault is null or not a function!');
		}

		return html;
	}

	function _getHtml_MetadataActivity(result) {
		var html = '',
			timeSent = Helper.getDateFormatted( result.timeSent ),
			generator = result.generator.displayName;

		html = timeSent;
		if(generator)
			html += ' | in ' + generator;

		return html;
	}

	function getHtml_ResultPerson(result, configUrl) {
		var html = '';
		if(templateDefault!==null && typeof templateDefault === 'function') {
			if(result) {
				// prepare result for template:
				result.filetype = '<liferay-ui:message key="de.iisys.esearch_Persons"/>';
				result.filetypeClass = CSS.classes.filetypeSticker.person;
				result.filetypeShort = result.filetype.substring(0,1);
				result.systemIcon = ICON.system.shindigPerson;
				result.system = '<liferay-ui:message key="de.iisys.esearch_Persons"/>';

				result.title = result.fullname;

				result.metadata = _getHtml_MetadataPerson(result);
				result.description = _getHtml_DescriptionPerson(result, configUrl);

				result.imageUrl = result.thumbUrl;
			}

			html = templatePerson( result );	
		} else {
			console.log('Error: templatePerson is null or not a function!');
		}

		return html;
	}

	function _getHtml_MetadataPerson(result) {
		var orga = result.organization, 
			meta = '';

		if(orga) {
			meta = orga.title;
			if(orga.subField)
				meta += ' | ' + orga.subField;
			if(orga.field)
				meta += ' | ' + orga.field;
		}
		return meta;
	}

	function _getHtml_DescriptionPerson(result, configUrl) {
		var desc = '<i class="'+ICON.phone+'" /> '+result.phone
				 + '<br /><i class="'+ICON.mail+'" /> <a href="mailto:'+result.mail+'">'+result.mail+'</a>';

		if(result.tags && result.tags.length>0) {
			var tags = '';
			for(var i=0, j=result.tags.length; i < j; i++) {
				if(i>0)
					tags += ', ';
				tags += '<a href="' + configUrl.system.liferay + configUrl.liferay.hashtagUrl + result.tags[i] +'">'
					+result.tags[i]+'</a>';

				if(i>=4) {
					tags += ',...';
					break;
				}
			}
			desc += '<br /><i class="'+ICON.tags+'" /> '+tags;
		}
		return desc;
	}

	/* getHtml Facets: */

	function getHtml_FacetFiletypes(chosen, available, chosenGroups, availableGroups, callback, callbackGroups) {
		_prepareFacetFiletypeGroups(chosenGroups, availableGroups, callbackGroups);
		_prepareFacetFiletypeIcons(chosen, available);

		var allFiletypes = [],
			input;

		if(available) {
			for(var i=0, j=available.length; i < j; i++) {
				if(available[i] && available[i].facet) {
					var filetypeName = Helper.getFiletypeByMimetype(available[i].facet);

					if(filetypeName!==null) {
						allFiletypes.push(
							$(_createColumn(6)).append(
								$('<div>').addClass('checkbox').css('margin-bottom','0')
								.append($('<label>')
									.append(
										input = $('<input type="checkbox">')
											.click(available[i].facet, callback)
	//										.attr('checked','checked')
										, filetypeName
									)
								)
							)
						);
					}
				}

				if(chosen && chosen.indexOf(available[i].facet) > -1)
					input.attr('checked','checked');
			}
		}

		return allFiletypes;
	}

	function getHtml_FacetCreated(chosen, available, callback) {
		var optionOne = $('<option>')
							.text('<liferay-ui:message key="de.iisys.esearch_AnyTime"/>')
							.attr('value', Helper.REL_TIME.anyTime),
			options = [optionOne],
			opt, pos;

		if(available) {
			for(var i=0, j=available.length; i < j; i++) {
				if(available[i]) {
					opt = $('<option>').attr('value', available[i].facet);
					pos = null;

					switch(available[i].facet) {
						case Helper.REL_TIME.pastHour:
							opt.text('<liferay-ui:message key="de.iisys.esearch_PastHour"/>');
							pos = 1;
							break;
						case Helper.REL_TIME.past24Hours:
							opt.text('<liferay-ui:message key="de.iisys.esearch_Past24Hours"/>');
							pos = 2;
							break;
						case Helper.REL_TIME.pastWeek:
							opt.text('<liferay-ui:message key="de.iisys.esearch_PastWeek"/>');
							pos = 3;
							break;
						case Helper.REL_TIME.pastMonth:
							opt.text('<liferay-ui:message key="de.iisys.esearch_PastMonth"/>');
							pos = 4;
							break;
						case Helper.REL_TIME.pastQuarter:
							opt.text('<liferay-ui:message key="de.iisys.esearch_PastQuarter"/>');
							pos = 5;
							break;
						case Helper.REL_TIME.pastYear:
							opt.text('<liferay-ui:message key="de.iisys.esearch_PastYear"/>');
							pos = 6;
							break;
					}

					if(chosen && chosen.indexOf(available[i].facet) > -1)
						opt.attr('selected', 'selected');

					if(pos!==null)
						options[pos] = opt;
				}
			}
		}

		if(!chosen)
			$(options[0]).attr('selected', 'selected');

		return options;
	}

	function getHtml_FacetAuthors(chosen, available, callback) {
		var curCount, plate, pos,
			authorPlates = [],
			authorCounts = [];

		if(available) {
			for(var i=0, j=available.length; i < j; i++) {
				plate = null; pos = null; plateElement = null;

				if(available[i]) {
					curCount = available[i].count;

					plateElement = $('<a href="#">').append(
							plate = _createAuthorNameplate(available[i].facet, curCount)
						).click(available[i].facet, callback);

					// order new array by author counts:
					if(authorCounts.length<1 || curCount <= authorCounts[authorCounts.length-1]) {
						// put at the end
						authorPlates.push(plateElement);
						authorCounts.push(curCount);
					} else if(curCount >= authorCounts[0]) {
						// put at the beginning
						authorPlates.splice(0, 0, plateElement);
						authorCounts.splice(0, 0, curCount);
					} else {
						for(var x=0, y=authorCounts.length-1; x < y; x++) {
							if(curCount <= authorCounts[x] && curCount >= authorCounts[x+1]){
								// put between
								authorPlates.splice(x+1, 0, plateElement);
								authorCounts.splice(x+1, 0, curCount);
								break;
							}
						}
					}
				}

				if(chosen) {
					pos = chosen.map(function(obj) { return obj.id; }).indexOf(available[i].facet.id);
					if(pos > -1)
						plate.addClass(CSS.classes.facet.facetActiveBorder + ' ' + CSS.classes.facet.facetActive);
				}
			}
		}

		return authorPlates;
	}

	function getHtml_FacetSystems(chosenSystems, availableSystems, initialSystems, excluded, activitySystem, activityType, callback, callbackExclude) {
		var row,
			html = [],
			activityRow,
			showActivityRow = false,
			icons = 0,
			isActive, isActiveActivities = false,
			system,
			span,
			shownSystems = [];

		if(chosenSystems && initialSystems)
			shownSystems = initialSystems;
		else if(availableSystems)
			shownSystems = availableSystems;

		for(var i=0, j=shownSystems.length; i < j; i++) {
			isActive = false;
			system = null;
			system = shownSystems[i].facet;
			span = null;

			if(chosenSystems && chosenSystems.indexOf(system) > -1)
				isActive = true;
	
			if(system === activitySystem) {
				showActivityRow = true;
				if(!excluded || excluded.indexOf(activityType) === -1)
					isActiveActivities = true;
			} else {
				if(icons%4 === 0)
					html.push(row = $('<div>').addClass('row').css('margin-top','15px'));

				row.append(
					$(_createColumn(3)).append(
						$('<a href="#">').click(system, callback).append(
							span = $('<span>').addClass(ICON.system[system] + ' icon-lg')
						)
					)
					
				);

				if(isActive)
					span.addClass(CSS.classes.facet.facetActive);
				else
					span.addClass(CSS.classes.facet.facetAvailable);

				icons++;
			}
		}

		if(showActivityRow===true || (excluded && excluded.indexOf(activityType) > -1)) {
			activityRow = $('<div>').addClass('row').append(
				$(_createColumn(12)).append(
					$(_getHtml_ShowActivitiesCB(isActiveActivities, activityType, callbackExclude))
				)
			);
			html.push(activityRow);
		}		

		return html;
	}

	function _getHtml_ShowActivitiesCB(checked, type, callback) {
		var input,
			html = $('<div>').addClass('checkbox').append(
				$('<label>').append(
					input = $('<input>').attr('type','checkbox').click(type, callback),
					' <liferay-ui:message key="de.iisys.esearch_ShowActivities"/>'
				)
			);

		if(checked && checked!==false)
			input.attr('checked','checked');

		return html;
	}

	function _createAuthorNameplate(user, count) {
		var observer,
			displayName = user.fullname || user.id,
			circle;

			if(!user.fullname) {
				displayName = $('<span>').text(user.id);
				UserHelper.addObserver_fullname_text(displayName, user.id);
			}

			div = $('<div>').addClass('nameplate-label nameplate-label-default').append(
				$('<div>').addClass('nameplate-field').append(
					circle = $('<div>').addClass('user-icon user-icon-default')
				),
				observer = $('<div>').addClass('nameplate-content').append( displayName, ' ('+count+')' )
			);

		if(user.thumbUrl) {
			circle.append(
				$('<img alt="thumbnail">').addClass('img-responsive').attr('src', user.thumbUrl)
			);
		} else {
			UserHelper.addObserver_thumb(circle, user.fullname);
			if(user.initials)
				circle.text(user.initials);
		}



		return div;
	}

	/* helper DOM: */

	function _createColumn(colWidth) {
		var col = $('<div>').addClass('col-md-'+colWidth);
		return col;
	}

	function _toggle(e) {
		e.preventDefault();
		var el = $('#'+e.data);

		if(el.css('display') === 'none')
			el.css('display', 'block');
		else
			el.css('display', 'none');

		$(e.currentTarget).children('span').toggleClass(ICON.caretDown+' '+ICON.caretRight);
	}


	/* get DOM element: */

	function getEl_searchQuery() {
		return $('#'+CSS.ids.searchField).val();
	}


	/* manipulate DOM: */

	function prepareResultsView() {
		$('#top_lane .left-col')
			.removeClass('col-md-2')
			.addClass('col-md-3');
			
		$('#top_lane .main-col')
			.removeClass('col-md-8')
			.addClass('col-md-7');
			
		$('#result_lane').css('display','block');
	}

	function prepareSystemToSearch(chosenSystem, possibleSystem, callback) {
		var text, system, pre, after,
			btn = $('#'+CSS.ids.systemButton).empty(),
			systemDropdown = $('#'+CSS.ids.systemToSearchDropdown).empty();

		for(var key in possibleSystem) {
			pre = null; after = null;
			system = possibleSystem[key];
			switch(system) {
				case possibleSystem.allSystems:
					text = '<liferay-ui:message key="de.iisys.esearch_AllSystems"/>'; break;
				case possibleSystem.allSystemsWithActivities:
					text = '<liferay-ui:message key="de.iisys.esearch_AllSystemsInclActivities"/>';
					after = $('<li>').addClass('divider').attr('role', 'separator');
					break;
				case possibleSystem.liferay:
					text = '<liferay-ui:message key="de.iisys.esearch_Portal"/>'; break;
				case possibleSystem.nuxeo:
					text = '<liferay-ui:message key="de.iisys.esearch_Documents"/>'; break;
				case possibleSystem.mail:
					text = '<liferay-ui:message key="de.iisys.esearch_Emails"/>'; break;
				case possibleSystem.shindigPerson:
					text = '<liferay-ui:message key="de.iisys.esearch_Persons"/>'; break;
				case possibleSystem.shindigMessage:
					text = '<liferay-ui:message key="de.iisys.esearch_Messages"/>'; break;
				case possibleSystem.shindigActivity:
					text = '<liferay-ui:message key="de.iisys.esearch_Activities"/>'; break;
				case possibleSystem.noFilterSearch:
					text = 'No Filter Search';
					pre = $('<li>').addClass('divider').attr('role', 'separator');
					break;
			}

			if(chosenSystem===system) {
				btn.append(
					text + ' ',
					$('<span>').addClass('caret')
				);
			} else {
				if(pre)
					systemDropdown.append(pre);
				systemDropdown.append(
					$('<li>').append(
						$('<a href="#">').text(text).click(system, callback)
					)
				);
				if(after)
					systemDropdown.append(after);
			}
		}
	}

	function prepareSortOrder(sortBy, possibleSort, callback) {
		var text, sort,
			elSortBy = $('#'+CSS.ids.sortBy).empty(),
			elSortByDropdown = $('#'+CSS.ids.sortByDropdown).empty();

		for(var key in possibleSort) {
			sort = possibleSort[key];
			switch(sort) {
				case possibleSort.createDate:
					text = 'Sorted by Create Date'; break;
				case possibleSort.score:
					text = 'Sorted by Score'; break;
				case possibleSort.title:
					text = 'Sorted by Title'; break;
				case possibleSort.notSorted:
					text = 'Not sorted (most efficient)'; break;
			}

			if(sortBy===sort) {
				elSortBy.append(
					text + ' ',
					$('<span>').addClass('caret')
				);
			} else {
				elSortByDropdown.append(
					$('<li>').append(
						$('<a href="#">').text(text).click(sort, callback)
					)
				);
			}
		}
	}

	function preparePagination(resultsCount, resultsPerPage, curPage, handlerResultsPerPage, handlerPage) {
		var pagination = $('#'+CSS.ids.pagination),
			perPage = pagination.children('.pagination-items-per-page'),
			perPageDropdown = [],
			pagesList = [],
			pagesCount = Math.ceil(resultsCount/resultsPerPage),
			page;
		
		perPage.find('.'+CSS.classes.perPage).text(resultsPerPage);
		for(var i=0, j=RESULTS_PER_PAGE.length; i < j; i++) {
			perPageDropdown.push($('<li>').append(
				$('<a href="#">').text(RESULTS_PER_PAGE[i]).click(RESULTS_PER_PAGE[i], handlerResultsPerPage)
			));
		}
		perPage.children('.dropdown-menu').empty().append(perPageDropdown);

		pagesList = _getPagesList(curPage, pagesCount, handlerPage);
		pagination.children('.pagination').empty().append(pagesList);
	}

	function _getPagesList(curPage, pagesCount, handlerPage) {
		var pagesList = [],
			page;

		// left icon:
		page = $('<li>').append(
			$('<a href="#">')
				.click(curPage-1, handlerPage)
				.append($('<span>').addClass(ICON.paginationLeft))
		);
		if(curPage===0)
			page.addClass('disabled');
		pagesList.push(page);
		// pages:
		for(var i=0; i < pagesCount; i++) {
			page = $('<li>').append(
				$('<a href="#">').text(i+1).click(i, handlerPage)
			);
			if(i===curPage)
				page.addClass('active');

			pagesList.push(page);
		}
		// right icon:
		page = $('<li>').append(
			$('<a href="#">')
				.click(curPage+1, handlerPage)
				.append($('<span>').addClass(ICON.paginationRight))
		);
		if(curPage===pagesCount-1)
			page.addClass('disabled');
		pagesList.push(page);

		return pagesList;
	}

	function showResultsCount(initialCount, resultsCount) {
		var el = $('#'+CSS.ids.filteredOfAll);
		el.children('.filtered').text(resultsCount);
		el.children('.all').text(initialCount);
	}

	function showResultsLoading() {
		console.log('showResultsLoading()');
		$('#'+CSS.ids.searchResults).prepend(
			$('<p>').css('text-align', 'center').append(
				$('<i>').addClass('icon-spinner icon-spin')
					.css('font-size', '2.5em')
					.css('color', '#008cff')
			)
		);
	}

	function showResultsError(errorMessage) {
		$('#'+CSS.ids.searchResults).empty().append(
			$('<p class="text-danger">').css('text-align', 'center').css('margin', '2em 0 4em 0').append(
				$('<strong>').text('Error: '),
				$('<span>').text(errorMessage)
			)
		);
	}

	function _prepareFacetFiletypeGroups(chosenGroups, availableGroups, callback) {
		var group,
			facetClass,
			el;

		// reset icons: (should be in one loop and check if available/chosen)
		el = $('#'+CSS.ids.facetDocs).removeClass(CSS.classes.facet.facetAvailable + ' '
												+ CSS.classes.facet.facetActive);
		el.parent('a').removeAttr('href').off().unbind();
		el = $('#'+CSS.ids.facetImages).removeClass(CSS.classes.facet.facetAvailable + ' '
												+ CSS.classes.facet.facetActive);
		el.parent('a').removeAttr('href').off().unbind();
		el = $('#'+CSS.ids.facetSounds).removeClass(CSS.classes.facet.facetAvailable + ' '
												+ CSS.classes.facet.facetActive);
		el.parent('a').removeAttr('href').off().unbind();
		el = $('#'+CSS.ids.facetVideos).removeClass(CSS.classes.facet.facetAvailable + ' '
												+ CSS.classes.facet.facetActive);
		el.parent('a').removeAttr('href').off().unbind();

		if(availableGroups) {
			for(var i=0, j=availableGroups.length; i < j; i++) {
				el = null;
				facetClass = CSS.classes.facet.facetAvailable;
				group = null;
				group = availableGroups[i];

				switch(group) {
					case 'text':
					default:
						el = $('#'+CSS.ids.facetDocs);
						break;
					case 'image':
						el = $('#'+CSS.ids.facetImages);
						break;
					case 'sound':
						el = $('#'+CSS.ids.facetSounds);
						break;
					case 'video':
						el = $('#'+CSS.ids.facetVideos);
						break;
				}


				if(chosenGroups && chosenGroups.indexOf(group) > -1) {
					facetClass = CSS.classes.facet.facetActive;
					el.parent().parent('li').addClass('active');
				} else if(j===1 && group!=='text') {
					// if only one group is available, show active tab:
					$(el).parent().parent('li').parent().children('.active').removeClass('active');
					el.parent().parent('li').addClass('active');
				} else {
					el.parent().parent('li').removeClass('active');
				}					

				el.addClass(facetClass)
					.parent('a')
						.attr('href', '#')
						.off()
						.unbind()
						.click(group, callback);
//						.attr('onclick', '<portlet:namespace/>Facets.handlerFiletypeGroup(\''+facetClass+'\');');
			}
		}
	}

	function _prepareFacetFiletypeIcons(chosen, available, chosenGroups) {
		var group = 'text';

		if(chosenGroups && chosenGroups.length > 0) {
			group = chosenGroups[0];
		}

		switch(group) {
			case 'text':
			default:

				break;
			case 'image':
			case 'sound':
			case 'video':
		}
	}

	function appendTo_searchResults(element) {
		$('#'+CSS.ids.searchResults)
			.empty()
			.append(element);
	}	

	function appendTo_facetAllFiletypes(html) {
		var el = $('#'+CSS.ids.facetAllFiletypes).empty();
		el.append(html);
	}

	function appendTo_facetCreated(options, callback) {
		var sel = $('#'+CSS.ids.facetCreated).empty();
		sel.append(options)
			.off().unbind()
			.change(sel, callback);
	}

	function appendTo_facetAuthors(html) {
		var el = $('#'+CSS.ids.facetAuthors).empty();
		el.append(html);
	}

	function appendTo_facetSystems(html) {
		var el = $('#'+CSS.ids.facetSystems).empty();
		el.append(html);
	}

	function _updateUserName(id, user, element) {
		var name = user.displayName;

		$(element).text(name);
	}


	/* return: */
	return {
		init: init,

		getHtml_ResultDocument: getHtml_ResultDocument,
		getHtml_ResultImage: getHtml_ResultImage,
		getHtml_ResultLiferay: getHtml_ResultLiferay,
		getHtml_ResultMail: getHtml_ResultMail,
		getHtml_ResultMessage: getHtml_ResultMessage,
		getHtml_ResultActivity: getHtml_ResultActivity,
		getHtml_ResultPerson: getHtml_ResultPerson,

		getHtml_FacetFiletypes: getHtml_FacetFiletypes,
		getHtml_FacetCreated: getHtml_FacetCreated,
		getHtml_FacetAuthors: getHtml_FacetAuthors,
		getHtml_FacetSystems: getHtml_FacetSystems,

		getEl_searchQuery: getEl_searchQuery,

		prepareResultsView: prepareResultsView,
		prepareSystemToSearch: prepareSystemToSearch,
		prepareSortOrder: prepareSortOrder,
		preparePagination: preparePagination,
		showResultsCount: showResultsCount,
		showResultsLoading: showResultsLoading,
		showResultsError: showResultsError,
		appendTo_searchResults: appendTo_searchResults,
		appendTo_facetCreated: appendTo_facetCreated,
		appendTo_facetAllFiletypes: appendTo_facetAllFiletypes,
		appendTo_facetAuthors: appendTo_facetAuthors,
		appendTo_facetSystems: appendTo_facetSystems
	};
}(<portlet:namespace/>Helper, <portlet:namespace/>UserHelper, <portlet:namespace/>Facets);
/* END View module */


/***********************************************************************************************************/
/* Takes elasticsearch results and extracts results for the View */
var <portlet:namespace/>Extractor = function(Helper, UserHelper, Facets, Model, View) {
	
	var INDEX = {
		index: {
			/*
			emails: 'imapriverdata_new',
			liferay: 'liferay-indexer',
			nuxeo: 'nuxeo',
			shindig: 'shindig'
			*/
			/*
			emails: 'emails',
			liferay: '20202',
			nuxeo: 'nuxeo',
			shindig: 'shindig'
			*/
			
			emails: 'emails',
			liferay: '20202',
			nuxeo: 'nuxeo-new',
			shindig: 'shindig'
			
		},
		emails:{
			resultType:{
				mail: 'mail'
			},
			source:{
				author: 'from',
				content: 'textContent',
				folder: 'folderFullName',
				id: 'uid',
//				timeSent: 'sentDate',
				timeSent: 'createDate',
//				title: 'subject',
				title: 'title',
				recipients: 'to',
				userId: 'userId'
			},
			author:{
				id: 'id',
				mail: 'email',
				fullname: 'personal'
			}
		},
		liferay:{
			className:{
				file: 'com.liferay.portlet.documentlibrary.model.DLFileEntry',
				forum: 'com.liferay.portlet.messageboards.model.MBMessage',
				wiki: 'com.liferay.wiki.model.WikiPage'
			},
			resultType:{
				liferayDocumentType: 'LiferayDocumentType'
			},
			source:{
				id: 'ldapUserId',
				className: 'entryClassName',
				content: 'content',
				createDate: 'createDate_sortable',
				editedDate: 'modifiedDate_sortable',
				extension: 'extension',
				folderId: 'folderId',
				groupId: 'groupId',
				mimeType: 'mimeType',
				path: 'path',
				primKey: 'primaryKey',
				resourcePrimKey: 'entryClassPK',
				size: 'size',
				title: 'title',
				userLiferayId: 'userId',
				userName: 'userName'
			},
			readableType:{
				document: 'Document',
				forum: 'Forum',
				image: 'Image',
				wiki: 'Wiki'
			}
		},
		nuxeo:{
			resultType:{
				doc: 'doc'
			},
			source:{
				author: 'dc:creator',
				content: 'ecm:binarytext',
				createDate: 'dc:created',
				description: 'dc:description',
				editedDate: 'dc:modified',
				fileContent: 'file:content',
				fileSize: 'common:size',
				icon: 'common:icon',
				isVersion: 'ecm:isVersion',
				noteFulltext: 'note:note',
				noteMimeType: 'note:mime_type',
				path: 'ecm:path',
				primaryType: 'ecm:primaryType',
				repository: 'ecm:repository',
				state: 'ecm:currentLifeCycleState',
				title: 'dc:title',
				uuid: 'ecm:uuid'
			},
			primaryType:{
				file: 'File',
				note: 'Note',
				picture: 'Picture',
				workspace: 'Workspace'
			},
			imageSize:{
				small: 'Small'
			},
			fileContent:{
				mimeType: 'mime-type'
			},
			state:{
				deleted: 'deleted'
			}
		},
		shindig:{
			resultType:{
				activity: 'activity',
				message: 'message',
				person: 'person'
			},
			activity: {
				source:{
					actor: 'actor',
					object: 'object',
					published: 'published',
					target: 'target',
					title: 'title',
					verb: 'verb'
				}
			},
			message: {
				source:{
					content: 'body',
					msgId: 'id',
					recipients: 'recipients',
					sender: 'senderId',
					title: 'title',
					type: 'type',
					timeSent: 'timeSent'
				}
			},
			person: {
				source:{
					id: 'id',
					displayName: 'displayName',
					emails: 'emails',
					name: 'name',
					organizations: 'organizations',
					phone: 'phoneNumbers',
					tags: 'tags',
					thumbUrl: 'thumbnailUrl'
				},
				name:{
					givenName: 'givenName',
					lastname: 'familyName'
				}
			}
		},
		sort:{
			createDate: 'createDate',
			title: 'title'
		}
	};

	var FILETYPE = {
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

		image: 'Image',
		mail: 'Mail',
		message: '<liferay-ui:message key="de.iisys.esearch_Message"/>',
		activity: '<liferay-ui:message key="de.iisys.esearch_Activity"/>'
	};

	var RESULTTYPE = {
		activity: 	'activity',
		doc: 		'doc',
		mail: 		'mail',
		message: 	'message',
		person: 	'person'
	};

	var SYSTEM = {
		allSystems: 'allSystems',
		allSystemsWithActivities: 'allSystemsWithActivities',

		liferay: 'liferay',
		nuxeo: 'nuxeo',
		mail: 'mail',
		shindigMessage: 'shindigMessage',
		shindigPerson: 'shindigPerson',
		shindigActivity: 'shindigActivity',

		noFilterSearch: 'noFilterSearch'
	};

	var SORTBY = {
		createDate: 'createDate',
		score: 'score',
		title: 'title',
		notSorted: 'notSorted'
	};

	var userLookup = {
		id: [],
		mail: []
	};


	function createResult(elasticResult, config) {
		var esIndex = elasticResult._index,
			resultType = elasticResult._type,
			source = elasticResult._source,
			system,
			newResult;

		switch(esIndex) {
			case INDEX.index.emails:
				newResult = _createResult_Emails(source, resultType, config);
				system = SYSTEM.mail;
				break;
			case INDEX.index.liferay:
				newResult = _createResult_Liferay(source, resultType, config);
				system = SYSTEM.liferay;
				break;
			case INDEX.index.nuxeo:
				newResult = _createResult_Nuxeo(source, resultType, config);
				system = SYSTEM.nuxeo;
				break;
			case INDEX.index.shindig:
				newResult = _createResult_Shindig(source, resultType, config);
				break;
		}

		if(newResult) {
			if(system) {
				Facets.addFacet(
					Facets.GROUP_SYSTEM,
					system
				);
			}
			Facets.addFacet(
				Facets.GROUP_CREATED,
				Helper.getDateRelative(newResult.createDate)
			);
			Facets.addFacet(
				Facets.GROUP_AUTHOR,
				newResult.author
			);
		} else
			console.log('no result:' + JSON.stringify(source));

		return newResult;
	}

	function _createResult_Emails(source, resultType, config) {
		if(resultType === RESULTTYPE.mail) {
			var newResult,
				title = source[INDEX.emails.source.title],
				content = source[INDEX.emails.source.content],
				author = source[INDEX.emails.source.author],
				authorId = author[INDEX.emails.author.id],
				authorFullname = author[INDEX.emails.author.fullname],
				authorMail = author[INDEX.emails.author.mail],
				id = source[INDEX.emails.source.id],
				timeSent = source[INDEX.emails.source.timeSent],
				folder = source[INDEX.emails.source.folder],
				filetype = FILETYPE.mail;
				url = '',
				userId = source[INDEX.emails.source.userId];

			console.log('EMAILS:');
			console.log('authorId: '+authorId);
			console.log(author);

			if(!title || title==='') {
				title = source[INDEX.nuxeo.source.title];
				if(!title || title==='')
					title = 'No Subject';
			}

			if(!timeSent || timeSent==='') {
				timeSent = source[INDEX.nuxeo.source.createDate];
			}

			if(!timeSent || timeSent==='' || timeSent.length < 19)
				timeSent = ' - ';
			else {
				if(timeSent.substring) {
					timeSent = timeSent.substring(0,4)	// yyyy
						+'-'+timeSent.substring(4,6) 	// MM
						+'-'+timeSent.substring(6,11)	// ddThh
						+':'+timeSent.substring(11,13)	// mm
						+':'+timeSent.substring(13,15)	// ss
						+ timeSent.substring(19, timeSent.length);	// timezone: +0100
				} else {
					// use timeSent number. might hopefully be a unix timestamp.
				}
			}


			url = config.URL.system.appsuite + config.URL.appsuite.mails_1st + folder + config.URL.appsuite.mails_2nd + id;

									// id, fullname, givenName, lastname, mail, config
			author = Model.createUser(authorId, authorFullname, '', '', authorMail, config);

			newResult = new Model.MailResult(title, content, url, author, timeSent, folder);
			newResult.filetype = filetype;

			return newResult;
		} else {
			return null;
		}
	}

	function _createResult_Liferay(source, resultType, config) {
		var newResult,
			type = source[ INDEX.liferay.source.className ];

		switch(resultType) {
			case INDEX.liferay.resultType.liferayDocumentType:
				newResult = _createResult_LiferayDocumentType(source, config);
				break;
		}

		return newResult;
	}

	function _createResult_LiferayDocumentType(source, config) {
		var newResult,
			isImage = false,		
			author,
			authorId = source[ INDEX.liferay.source.id ],
			authorLiferayId = source[ INDEX.liferay.source.userLiferayId ],
			authorFullname = source[ INDEX.liferay.source.userName ],
			content = source[INDEX.liferay.source.content],
			createDate = source[ INDEX.liferay.source.createDate ],
			editedDate = source[ INDEX.liferay.source.editedDate ],
			fileSize,
			filetype,
			mimeType = source[INDEX.liferay.source.mimeType],
			primKey = source[INDEX.liferay.source.primKey],
			readableType,
			resourcePrimKey = source[INDEX.liferay.source.resourcePrimKey],
			thumbUrl,
			title = Helper.stripHTML( source[INDEX.liferay.source.title] ),
			type = source[ INDEX.liferay.source.className ],			
			url;

		authorFullname = authorFullname.split(' ');
		if(authorFullname.length>1) {
			var first = authorFullname[0].substring(0,1).toUpperCase() + authorFullname[0].substring(1, authorFullname[0].length);
			var last = authorFullname[1].substring(0,1).toUpperCase() + authorFullname[1].substring(1, authorFullname[1].length);

			authorFullname = first + ' ' +last;
		}
		/*
		author = Model.createUser('', authorFullname, '', '', '', config);
		author.liferayUserId = authorLiferayId;	
		*/

		// 	(userId, liferayUserId, mail, fullname, config)
		var author = UserHelper.getUserObject(authorId, authorLiferayId, null, authorFullname, config);

		switch(type) {
			case INDEX.liferay.className.file:
				readableType = 'Document';
				url = config.URL.system.liferay + config.URL.liferay.findDocument + resourcePrimKey;
				filetype = source[INDEX.liferay.source.extension];

				if(mimeType) {
					var i = mimeType.indexOf('_');
					if(i !== -1)
						mimeType = mimeType.replace('_', '/');
					Facets.addFacet(Facets.GROUP_FILETYPE, mimeType);
				}
				// if image:
				if(filetype===FILETYPE.jpg || filetype===FILETYPE.png || filetype===FILETYPE.gif) {
					isImage = true;
					var groupId = source[INDEX.liferay.source.groupId],
						folderId = source[INDEX.liferay.source.folderId],
						path =  source[INDEX.liferay.source.path];
					fileSize = source[INDEX.liferay.source.size];
					thumbUrl = config.URL.system.liferay + '/documents/' 
							+ groupId + '/' + folderId + '/' + path
							+ config.URL.liferay.thumbnail_after;
				} else if(filetype===FILETYPE.ppt || filetype===FILETYPE.pptx) {
					content = '';
				}
				break;
			case INDEX.liferay.className.forum:
				readableType = 'Forum';
				url = config.URL.system.liferay + config.URL.liferay.findForumMessage + resourcePrimKey;
				break;
			case INDEX.liferay.className.wiki:
				readableType = 'Wiki';
				url = config.URL.system.liferay + config.URL.liferay.findWikiPage + resourcePrimKey;
				break;
		}
				

		newResult = new Model.LiferayResult(title, content, url, author, createDate, editedDate, primKey, readableType);
		if(filetype)
			newResult.filetype = filetype;
		if(isImage) {
			newResult.imageUrl = thumbUrl;
			newResult.fileSize = fileSize;
		}
		return newResult;
	}

	function _createResult_Nuxeo(source, resultType, config) {
		var newResult,
			isVersion = source[ INDEX.nuxeo.source.isVersion ];

		if(isVersion!==false)
			return null;

		var author = source[ INDEX.nuxeo.source.author ] || '',
			content = source[ INDEX.nuxeo.source.content ] || '',
			createDate = source[ INDEX.nuxeo.source.createDate ] || 0,
			editedDate = source[ INDEX.nuxeo.source.editedDate ] || 0,
			fileSize = source[ INDEX.nuxeo.source.fileSize ] || '',
			filetype,
			mimeType = source[INDEX.nuxeo.source.fileContent],
			path = source[ INDEX.nuxeo.source.path ] || '',
			primaryType = source[ INDEX.nuxeo.source.primaryType ] || '',
			title = source[ INDEX.nuxeo.source.title ] || '';

		var url = config.URL.system.nuxeo + config.URL.nuxeo.docPath_pre + path + config.URL.nuxeo.docPath_after;
		/*
			author = new Model.User(author);
		author.profileUrl = config.URL.system.liferay + config.URL.liferay.userProfile + author.id;
		author.thumbUrl = config.URL.system.liferay
						+ config.URL.liferay.userThumbUrl_pre
						+ author.id
						+ config.URL.liferay.userThumbUrl_after;
		*/

		// 	(userId, liferayUserId, mail, fullname, config, fullnameCallback)
		var author = UserHelper.getUserObject(author, null, null, null, config, null);


		if(mimeType)
			mimeType = mimeType[INDEX.nuxeo.fileContent.mimeType];
		else
			mimeType = null;

		switch(primaryType) {
			case INDEX.nuxeo.primaryType.file:
				newResult = new Model.DocumentResult(title, content, url, author, createDate, editedDate, fileSize);
//				filetype = _getNuxeoDocFiletype(source, newResult);
				_removeUnreadableContent(newResult);
				break;
			case INDEX.nuxeo.primaryType.note:
				content = source[ INDEX.nuxeo.source.noteFulltext ];

				content = $('<div>'+content+'</div>').text();

				newResult = new Model.DocumentResult(title, content, url, author, createDate, editedDate);
				mimeType = source[ INDEX.nuxeo.source.noteMimeType ];
				break;
			case INDEX.nuxeo.primaryType.picture:
				var imageSize = config.NUXEO.imageSizeForThumb,
					fileContentName = source[INDEX.nuxeo.source.fileContent].name;
					repository = source[INDEX.nuxeo.source.repository],
					uuid = source[INDEX.nuxeo.source.uuid];
				var imageUrl = config.URL.system.nuxeo + config.URL.nuxeo.imagePath_pre + '/' + repository
						+'/'+uuid+'/'+imageSize+':content/'+imageSize+'_'+fileContentName;

				newResult = new Model.ImageResult(title, imageUrl, url, author, createDate, editedDate, fileSize);
//				filetype = _getNuxeoImageFiletype(source, newResult);
				break;
			case INDEX.nuxeo.primaryType.workspace:
				newResult = new Model.DocumentResult(title, content, url, author, createDate, editedDate);
				newResult.filetype = INDEX.nuxeo.primaryType.workspace;
				break;
		}

		if(newResult) {
			if(!newResult.filetype)
				newResult.filetype = Helper.getFiletypeByMimetype(mimeType);
			Facets.addFacet(Facets.GROUP_FILETYPE, mimeType);

			newResult.description = source[INDEX.nuxeo.source.description];
			newResult.state = source[INDEX.nuxeo.source.state];
		}

		return newResult;
	}

	function _createResult_Shindig(source, resultType, config) {
		var newResult, system;

		switch(resultType) {
			case INDEX.shindig.resultType.activity:
				system = SYSTEM.shindigActivity;
				newResult = _createResult_ShindigActivity(source, config);
				break;
			case INDEX.shindig.resultType.message:
				system = SYSTEM.shindigMessage;
				newResult = _createResult_ShindigMessage(source, config);
				break;
			case INDEX.shindig.resultType.person:
				system = SYSTEM.shindigPerson;
				newResult = _createResult_ShindigPerson(source, config);
				break;
		}

		if(system!==null)
			Facets.addFacet(Facets.GROUP_SYSTEM, system);

		return newResult;
	}

	function _createResult_ShindigActivity(source, config) {
		var newResult,
			filetype = FILETYPE.activity,
			timeSent = source[INDEX.shindig.activity.source.published],
			content = source[INDEX.shindig.activity.source.title],
			verb = source[INDEX.shindig.activity.source.verb],
			object = source[INDEX.shindig.activity.source.object],
			target = source['target'],
			generator = source['generator'],
			title = '';

		var actor = new Model.User( source[INDEX.shindig.activity.source.actor].id );
		actor.fullname = source[INDEX.shindig.activity.source.actor].displayName;
		actor.profileUrl = config.URL.system.liferay + config.URL.liferay.userProfile + actor.id;
		actor.thumbUrl = config.URL.system.liferay
						+ config.URL.liferay.userThumbUrl_pre
						+ actor.id
						+ config.URL.liferay.userThumbUrl_after;

		var entry = {};
		entry.actor = actor;
		entry.object = object;
		entry.target = target;
		entry.generator = generator;
		entry.verb = verb;
		title = _getActivityTitle(entry);

		newResult = new Model.ActivityResult(title, content, actor, timeSent, verb, object);
		newResult.filetype = filetype;

		newResult.generator = generator;

		return newResult;
	}

	function _createResult_ShindigMessage(source, config) {
		var newResult,
			filetype = FILETYPE.message,
			msgId = source[ INDEX.shindig.message.source.msgId ] || '',
			content = source[ INDEX.shindig.message.source.content ],
			recipients = [],
			recipientsTemp = source[ INDEX.shindig.message.source.recipients ] || [],
			recTemp,
			senderId = source[ INDEX.shindig.message.source.sender ],
			title = source[ INDEX.shindig.message.source.title ],
			timeSent  = source[ INDEX.shindig.message.source.timeSent ],
			type = source[ INDEX.shindig.message.source.type ];
		/*
			sender = new Model.User( source[ INDEX.shindig.message.source.sender ] );
		sender.profileUrl = config.URL.system.liferay + config.URL.liferay.userProfile + sender.id;
		sender.thumbUrl = config.URL.system.liferay
						+ config.URL.liferay.userThumbUrl_pre
						+ sender.id
						+ config.URL.liferay.userThumbUrl_after;
		*/

		sender = UserHelper.getUserObject(senderId, null, null, null, config, null);
		
		for(var i=0, j=recipientsTemp.length; i < j; i++) {
			recTemp = new Model.User(recipientsTemp[i]);
			recTemp.profileUrl = config.URL.system.liferay + config.URL.liferay.userProfile + recTemp.id;
			recipients.push( recTemp );
		}

		var url = config.URL.system.liferay + config.URL.liferay.userProfile + recipients[0];
		if(msgId!=='')
			url += config.URL.liferay.userProfileMsgId + msgId;

		newResult = new Model.MessageResult(title, content, url, sender, timeSent, type, msgId);
		newResult.filetype = filetype;
		newResult.recipients = recipients;

		return newResult;
	}

	function _createResult_ShindigPerson(source, config) {
		var id = source[INDEX.shindig.person.source.id],
			fullname = source[INDEX.shindig.person.source.displayName],
			mail = source[INDEX.shindig.person.source.emails],
			givenName = source[INDEX.shindig.person.source.name][INDEX.shindig.person.name.givenName],
			lastname = source[INDEX.shindig.person.source.name][INDEX.shindig.person.name.lastname],
			tags = source[INDEX.shindig.person.source.tags],
			phone = source[INDEX.shindig.person.source.phone],
			organizations = source[INDEX.shindig.person.source.organizations],
			newResult;
			
		if(mail.length>0)
			mail = mail[0].value;

		newResult = Model.createUser(id, fullname, givenName, lastname, mail, config);

		newResult.author = newResult;
		newResult.tags = tags;
		if(phone.length>0)
			newResult.phone = phone[0].value;
		if(organizations.length>0)
			newResult.organization = organizations[0];


		return newResult;
	}


	/* ElasticSearch */

	function getSort(sortBy) {
		var sort;

		switch(sortBy) {
			case SORTBY.notSorted:
			default:
				sort = ['_doc'];
				break;
			case SORTBY.createDate:
				sort = [{}];
/*				sort[0][INDEX.nuxeo.source.createDate] = { 
					order: 'desc',
					unmapped_type : 'long' };
				sort[0][INDEX.shindig.message.source.timeSent] = { 
					order: 'desc',
					unmapped_type : 'long' };
				sort[0][INDEX.emails.source.timeSent] = { 
					order: 'desc',
					unmapped_type : 'long' };
				sort[0][INDEX.liferay.source.createDate] = { 
					order: 'desc',
					unmapped_type : 'long' }; */
				sort[0][INDEX.sort.createDate] = { 
					order: 'desc',
					unmapped_type : 'long' };
				break;
			case SORTBY.score:
				sort = ['_score'];
				break;
			case SORTBY.title:
				sort = [{}];
				sort[0][INDEX.nuxeo.source.title] = {
					order: 'desc',
					unmapped_type : 'long' };
				break;
		}

		return sort;
	}

	/*
	 * Filters older version of nuxeo document
	 */
	function getFilterVersion() {
		var filter = {
			not: { term: {} }
		};
		filter.not.term[INDEX.nuxeo.source.isVersion] = 'true';
		return filter;
	}

	function getFilterWikiVersion() {
		var filter = {
			not: { term: {} }
		};
		filter.not.term['head'] = 'false';
		return filter;
	}

	function getFilterNuxeoTrash() {
		var filter = {
			not: { term: {} }
		};
		filter.not.term[INDEX.nuxeo.source.state] = 'deleted';
		return filter;
	}

	function getFilterMailTrash() {
		var filter = {
			not: { term: {} }
		};
		filter.not.term[INDEX.emails.source.folder] = 'Trash';
		return filter;
	}

	function getFilterCreated(chosen) {
		var filter,
			fromTime = new Date(),

			msPerMinute = 60 * 1000,
		    msPerHour = msPerMinute * 60,
		    msPerDay = msPerHour * 24;

		switch(chosen[0]) {
			case Helper.REL_TIME.pastHour:
				fromTime = fromTime - msPerHour; break;
			case Helper.REL_TIME.past24Hours:
				fromTime = fromTime - msPerDay; break;
			case Helper.REL_TIME.pastWeek:
				fromTime = fromTime - (msPerDay * 7); break;
			case Helper.REL_TIME.pastMonth:
				fromTime = fromTime - (msPerDay * 30); break;
			case Helper.REL_TIME.pastQuarter:
				fromTime = fromTime - (msPerDay * 30 * 3); break;
			case Helper.REL_TIME.pastYear:
				fromTime = fromTime - (msPerDay * 365); break;
			default:
				fromTime = 0;
		}

		filter = { 
			or: [
				{ range: {} },
				{ range: {} },
				{ range: {} },
				{ range: {} }
			]
		};

		// nuxeo:
		filter.or[0].range[INDEX.nuxeo.source.createDate] = {
			gte: fromTime,
//			format: 'yyyy-MM-dd\'T\'HH:mm:ss.SSZ'
		};
		// shindig:
		filter.or[1].range[INDEX.shindig.message.source.timeSent] = { gte: fromTime };
		// imap:
		filter.or[2].range[INDEX.emails.source.timeSent] = { gte: fromTime };
		// liferay:
		filter.or[3].range[INDEX.liferay.source.createDate] = { gte: fromTime };

		return filter;
	}

	function getFilterAuthor(chosen) {
		var filter = {
				or: []
			},
			len, len2;

	/*
		var emailsFilter = {
			nested: {
				path: INDEX.emails.source.author,
				filter: {
					or: []
				}
			}
		};
		*/
		 

		for(var i=0, j=chosen.length; i < j; i++) {
			len = filter.or.length;
			filter.or[len] = { term: {} };
			filter.or[len++].term[INDEX.nuxeo.source.author] = chosen[i].id;
			filter.or[len] = { term: {} };
			filter.or[len++].term[INDEX.shindig.message.source.sender] = chosen[i].id;
			filter.or[len] = { term: {} };
			filter.or[len++].term[INDEX.liferay.source.id] = chosen[i].id;
			filter.or[len] = { term: {} };
			filter.or[len].term[INDEX.emails.source.userId] = chosen[i].id;
			filter.or[len] = { term: {} };
			filter.or[len].term[INDEX.emails.source.author] = chosen[i].mail;

/*
			if(chosen[i].mail) {
				len2 = emailsFilter.nested.filter.or.length;
				emailsFilter.nested.filter.or[len2] = { term: {} };
				emailsFilter.nested.filter.or[len2++].term[INDEX.emails.source.author+'.'+'email'] = chosen[i].mail;
			}
			*/
		}

		/*
		len = filter.or.length;
		filter.or[len] = emailsFilter;
		*/

		return filter;
	}

	function getFilterFiletype(chosen, group) {
		var filterNuxeo = {
			or: [
				{ nested: {
					path: INDEX.nuxeo.source.fileContent,
					filter: {
						or: []
					}
				}},
				{ or: [

				]}
			]
		},
		filterLiferay = {
			or: [
				{ not: { type: { value: INDEX.liferay.resultType.liferayDocumentType } } }
			]
		},
		filterEmails = {
			not: { type: { value: INDEX.emails.resultType.mail } }
		},
		len,
		types = Facets.filetypeGroups[group[0]];

		if(chosen) {
			for(var i=0, j=chosen.length; i < j; i++) {
				// this filter has to be removed in ES-Relay for the Liferay-index (ES 2.x)
				len = filterNuxeo.or[0].nested.filter.or.length;
				filterNuxeo.or[0].nested.filter.or[len] = { term: {} };
				filterNuxeo.or[0].nested.filter.or[len++].term[INDEX.nuxeo.source.fileContent+'.'+INDEX.nuxeo.fileContent.mimeType] = chosen[i];

				// nuxeo notes:
				len = filterNuxeo.or[1].or.length;
				filterNuxeo.or[1].or[len] = { term: {} };
				filterNuxeo.or[1].or[len++].term[INDEX.nuxeo.source.noteMimeType] = chosen[i];

				// Liferay:
				len = filterLiferay.or.length;
				filterLiferay.or[len] = { term: {} };
				filterLiferay.or[len++].term[INDEX.liferay.source.extension] = Helper.getFiletypeByMimetype(chosen[i]);
			}
		} else if(group) {
			for(var i=0, j=types.length; i < j; i++) {
				// this filter has to be removed in ES-Relay for the Liferay-index (ES 2.x)
				len = filterNuxeo.nested.filter.or.length;
				filterNuxeo.nested.filter.or[len] = { term: {} };
				filterNuxeo.nested.filter.or[len++].term[INDEX.nuxeo.source.fileContent+'.'+INDEX.nuxeo.fileContent.mimeType] = types[i];

				// Liferay:
				len = filterLiferay.or.length;
				filterLiferay.or[len] = { term: {} };
				filterLiferay.or[len++].term[INDEX.liferay.source.extension] = Helper.getFiletypeByMimetype(types[i]);
			}
		}
		
//		return filter;
		return [
				filterNuxeo,
				filterLiferay,
				filterEmails
			];
	}

	function getFilterTypes (types) {
		var filter = {
				or: []
			},
			len;

		for(var i=0, j=types.length; i < j; i++) {
			len = filter.or.length;
			filter.or[len] = { type: {} };
			filter.or[len].type['value'] = types[i];
		}
		return filter;
	}

	function getExcludedFilter(excluded) {
		var filter = {};

		if(excluded && excluded[Facets.GROUP_SYSTEM]) {
			var exclType = excluded[Facets.GROUP_SYSTEM][0];

			filter = {
				not: {
//					filter: {
						type: {
							value: exclType
						}
//					}
				}
			};
		}
		return filter;
	}


	/* Nuxeo methods: */

	/*
	function _getNuxeoDocFiletype(source, result) {
		var nuxeoIcon = source[INDEX.nuxeo.source.icon];

		if(nuxeoIcon.indexOf(FILETYPE.docx) > -1) {
			result.filetype = FILETYPE.docx;
		} else if(nuxeoIcon.indexOf(FILETYPE.doc) > -1) {
			result.filetype = FILETYPE.doc;
		} else if(nuxeoIcon.indexOf(FILETYPE.pdf) > -1) {
			result.filetype = FILETYPE.pdf;
		} else if(nuxeoIcon.indexOf(FILETYPE.xlsx) > -1) {
			result.filetype = FILETYPE.xlsx;
		} else if(nuxeoIcon.indexOf(FILETYPE.xls) > -1) {
			result.filetype = FILETYPE.xls;
		}

		return result.filetype;	
	}

	function _getNuxeoImageFiletype(source, result) {
		var mimeType = source[INDEX.nuxeo.source.fileContent][INDEX.nuxeo.fileContent.mimeType];

		if(mimeType.indexOf(FILETYPE.gif) > -1) {
			result.filetype = FILETYPE.gif;
		} else if(mimeType.indexOf(FILETYPE.jpg) > -1) {
			result.filetype = FILETYPE.jpg;
		} else if(mimeType.indexOf(FILETYPE.jpeg) > -1) {
			result.filetype = FILETYPE.jpg;
		} else if(mimeType.indexOf(FILETYPE.png) > -1) {
			result.filetype = FILETYPE.png;
		} else {
			result.filetype = FILETYPE.image;
		}

		return result.filetype;
	}
	*/

	function _removeUnreadableContent(result) {
		switch(result.filetype) {
			case FILETYPE.xls:
			case FILETYPE.xlsx:
				result.content = null;
		}
	}

	/* shindig methods: */

	// function from liferay-shindig-portlets (activities)
	// original name: <portlet:namespace/>displayEntry
	function _getActivityTitle(entry) {
		var html = '';
		  
		//supporting activity objects
		var actor = null;
		var object = null;
		var target = null;
		var generator = null;

		if(entry.actor)
			actor = _getActivityDisplay(entry.actor);
	  
		if(entry.object)
			object = _getActivityDisplay(entry.object);
	  
		if(entry.target)
			target = _getActivityDisplay(entry.target);
		  
		  //entries with no verb
		  if(!entry.verb) {
			  title = actor + ' ' + '<liferay-ui:message key="activitystreams-target-posted" />';
			  
			  if(object != null)
				  title += ' ' + object;
			  
			  if(target != null)
				  title += ' ' + '<liferay-ui:message key="activitystreams-target-to" />' + ' ' + target;
		  }
		  
		  //determine message through verb
		  else switch(entry.verb) {
		    case 'add':
		    	if(target == null)
		    		title = '<liferay-ui:message key="activitystreams-add" />';
		    	else
		    		title = '<liferay-ui:message key="activitystreams-add-wtarget" />';
		    	
		    	//special treatment for certain types
		    	if(entry.object != null
		    		&& entry.object.objectType != null)
		    	{
		    		//voting, i.e. adding ratings/votes
		    		if(entry.object.objectType.indexOf("vote") > -1)
		    		{
			    		//special message for added ratings
			    		if(entry.object.content != null)
			    		{
			    			var ratingString = entry.object.content;
			    			
			    			if(!isNaN(ratingString)
			    			  && parseInt(ratingString) > 1)
			    			{
			    				ratingString += ' <liferay-ui:message key="activitystreams-rate-stars" />';
			    			}
			    			
			    			title = actor + ' <liferay-ui:message key="activitystreams-rate-wrating-frag1" /> '
				    			+ target + ' <liferay-ui:message key="activitystreams-rate-wrating-frag2" /> '
				    			+ ratingString
				    			+ ' <liferay-ui:message key="activitystreams-rate-wrating-frag3" />';
			    		}
			    		else
			    		{
			    			title = '<liferay-ui:message key="activitystreams-rate" />';
			    		}
		    		}
		    		//adding skills to other people -> suggesting them
		    		else if(entry.object.objectType.indexOf("skill") > -1
		    			&& target != null)
		    		{
		    			title = '<liferay-ui:message key="activitystreams-add-skill-wtarget" />';
		    		}
		    	}
		    	
		    	break;

		    case 'access':
		    	if(target == null)
		    	{
		    		title = '<liferay-ui:message key="activitystreams-access" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-access-wtarget" />';
		    	}
		    	break;

		    case 'post':
		    	if(target == null)
		    	{
		    		title = '<liferay-ui:message key="activitystreams-post" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-post-wtarget" />';
		    	}
		    	break;

		    case 'append':
		    	if(target == null)
		    	{
		    		title = '<liferay-ui:message key="activitystreams-append" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-append-wtarget" />';
		    	}
		    	break;

		    case 'attach':
		    	if(target == null)
		    	{
		    		title = '<liferay-ui:message key="activitystreams-attach" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-attach-wtarget" />';
		    	}
		    	break;

		    case 'cancel':
		    	if(target == null)
		    	{
		    		title = '<liferay-ui:message key="activitystreams-cancel" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-cancel-wtarget" />';
		    	}
		    	break;

		    case 'create':
		    	if(object == null && target == null)
		    	{
		    		title = '<liferay-ui:message key="activitystreams-create-self" />';
		    	}
		    	else if(target == null)
		    	{
		    		title = '<liferay-ui:message key="activitystreams-create" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-create-wtarget" />';
		    	}
		    	break;

		    case 'delete':
		    	if(object == null && target == null)
		    	{
		    		title = '<liferay-ui:message key="activitystreams-delete-self" />';
		    	}
		    	else if(target == null)
		    	{
		    		title = '<liferay-ui:message key="activitystreams-delete" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-delete-wtarget" />';
		    	}
		    	break;

		    case 'follow':
		    	if(target == null && object != null
				    || target != null && object == null)
		    	{
		    		title = '<liferay-ui:message key="activitystreams-follow" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-follow-wtarget" />';
		    	}
		    	break;

		    case 'stop-following':
		    	if(target == null && object != null
			    	|| target != null && object == null)
		    	{
		    		title = '<liferay-ui:message key="activitystreams-unfollow" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-unfollow-wtarget" />';
		    	}
		    	break;

		    case 'make-friend':
		    	if(target == null && object != null
		    		|| target != null && object == null)
		    	{
		    		title = '<liferay-ui:message key="activitystreams-make-friend" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-make-friend-wtarget" />';
		    	}
		    	break;

		    case 'open':
		    	if(target == null)
		    	{
		    		title = '<liferay-ui:message key="activitystreams-open" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-open-wtarget" />';
		    	}
		    	break;

		    case 'remove':
		    	if(target == null)
		    	{
		    		title = '<liferay-ui:message key="activitystreams-remove" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-remove-wtarget" />';
		    	}
		    	break;

		    case 'save':
		    	if(target == null)
		    	{
		    		title = '<liferay-ui:message key="activitystreams-save" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-save-wtarget" />';
		    	}
		    	break;

		    case 'share':
		    	if(target == null)
		    	{
		    		title = '<liferay-ui:message key="activitystreams-share" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-share-wtarget" />';
		    	}
		    	break;

		    case 'submit':
		    	if(target == null)
		    	{
		    		title = '<liferay-ui:message key="activitystreams-submit" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-submit-wtarget" />';
		    	}
		    	break;

		    case 'tag':
		    	if(target == null && object != null
			    	|| target != null && object == null)
		    	{
		    		title = '<liferay-ui:message key="activitystreams-tag" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-tag-wtarget" />';
		    	}
		    	break;

		    case 'update':
		    	if(entry.object != null
			    	&& entry.object.objectType == "shindig-status-message"
			    	&& entry.object.content != null)
			    {
		    		//special message for status messages
		    		//TODO: shortening?
		    		title = '<liferay-ui:message key="activitystreams-update" />'
		    			+ ': ' + entry.object.content;
			    }
			    else if(target == null && object != null
		    		|| target != null && object == null)
		    	{
		    		title = '<liferay-ui:message key="activitystreams-update" />';
		    	}
		    	else if(target != null)
		    	{
		    		title = '<liferay-ui:message key="activitystreams-update-wtarget" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-update-self" />';
		    	}
		    	break;

		    case 'invite':
		    	if(target == null)
		    	{
		    		title = '<liferay-ui:message key="activitystreams-invite" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-invite-wtarget" />';
		    	}
	        	break;

		    case 'complete':
		    	if(target == null)
		    	{
		    		title = '<liferay-ui:message key="activitystreams-complete" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-complete-wtarget" />';
		    	}
	       		break;

		    case 'join':
		    	if(target == null)
		    	{
		    		title = '<liferay-ui:message key="activitystreams-join" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-join-wtarget" />';
		    	}
	        	break;

		    case 'leave':
		    	if(target == null)
		    	{
		    		title = '<liferay-ui:message key="activitystreams-leave" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-leave-wtarget-frag1" />';
		    	}
	        	break;
	      
	      	case 'assign':
		    	if(target == null)
		    	{
		    		title = '<liferay-ui:message key="activitystreams-assign" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-assign-wtarget" />';
		    	}
	        	break;
	      
	      	case 'authorize':
		    	if(target == null)
		    	{
		    		title = '<liferay-ui:message key="activitystreams-authorize" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-authorize-wtarget" />';
		    	}
	        	break;
	      
	      	case 'request':
		    	if(target == null)
		    	{
		    		title = '<liferay-ui:message key="activitystreams-request" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-request-wtarget" />';
		    	}
	        	break;
	        	
	      	case 'accept':
	      		if(target == null)
		    	{
	      			title = '<liferay-ui:message key="activitystreams-accept" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-accept-wtarget" />';
		    	}
	      		break;
	        	
	      	case 'approve':
	      		if(target == null)
		    	{
	      			title = '<liferay-ui:message key="activitystreams-approve" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-approve-wtarget" />';
		    	}
	      		break;
	        	
	      	case 'deny':
	      		if(target == null)
		    	{
	      			title = '<liferay-ui:message key="activitystreams-deny" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-deny-wtarget" />';
		    	}
	      		break;
	        	
	      	case 'favorite':
	      		if(target == null)
		    	{
	      			title = '<liferay-ui:message key="activitystreams-favorite" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-favorite-wtarget" />';
		    	}
	      		break;
	        	
	      	case 'give':
	      		if(target == null)
		    	{
	      			title = '<liferay-ui:message key="activitystreams-give" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-give-wtarget" />';
		    	}
	      		break;
	        	
	      	case 'ignore':
	      		if(target == null)
		    	{
	      			title = '<liferay-ui:message key="activitystreams-ignore" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-ignore-wtarget" />';
		    	}
	      		break;
	        	
	      	case 'qualify':
	      		if(target == null)
		    	{
	      			title = '<liferay-ui:message key="activitystreams-qualify" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-qualify-wtarget" />';
		    	}
	      		break;
	        	
	      	case 'reject':
	      		if(target == null)
		    	{
	      			title = '<liferay-ui:message key="activitystreams-reject" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-reject-wtarget" /> ';
		    	}
	      		break;
	        	
	      	case 'remove-friend':
	      		if(target == null)
		    	{
	      			title = '<liferay-ui:message key="activitystreams-remove-friend" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-remove-friend-wtarget" />';
		    	}
	      		break;
	        	
	      	case 'request-friend':
	      		if(target == null)
		    	{
	      			title = '<liferay-ui:message key="activitystreams-request-friend" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-request-friend-wtarget" />';
		    	}
	      		break;
	        	
	      	case 'retract':
	      		if(target == null)
		    	{
	      			title = '<liferay-ui:message key="activitystreams-retract" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-retract-wtarget" />';
		    	}
	      		break;
	        	
	      	case 'rsvp-maybe':
	      		if(target == null)
		    	{
	      			title = '<liferay-ui:message key="activitystreams-rsvp-maybe" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-rsvp-maybe-wtarget" />';
		    	}
	      		break;
	        	
	      	case 'rsvp-no':
	      		if(target == null)
		    	{
	      			title = '<liferay-ui:message key="activitystreams-rsvp-no" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-rsvp-no-wtarget" />';
		    	}
	      		break;
	        	
	      	case 'rsvp-no':
	      		if(target == null)
		    	{
	      			title = '<liferay-ui:message key="activitystreams-rsvp-no" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-rsvp-no-wtarget" />';
		    	}
	      		break;
	        	
	      	case 'rsvp-yes':
	      		if(target == null)
		    	{
	      			title = '<liferay-ui:message key="activitystreams-rsvp-yes" /> ';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-rsvp-yes-wtarget" />';
		    	}
	      		break;
	        	
	      	case 'start':
	      		if(target == null)
		    	{
	      			title = '<liferay-ui:message key="activitystreams-start" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-start-wtarget" />';
		    	}
	      		break;
	        	
	      	case 'unfavorite':
	      		if(target == null)
		    	{
	      			title = '<liferay-ui:message key="activitystreams-unfavorite" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-unfavorite-wtarget" />';
		    	}
	      		break;
	        	
	      	case 'unshare':
	      		if(target == null)
		    	{
	      			title = '<liferay-ui:message key="activitystreams-unshare" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-unshare-wtarget" />';
		    	}
	      		break;
	      		
	      	//unofficial verbs
	      	case 'copy':
	      		if(target == null)
		    	{
	      			title = '<liferay-ui:message key="activitystreams-copy" /> ';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-copy-wtarget" />';
		    	}
	      		break;
	      		
	      	case 'move':
	      		if(target == null)
		    	{
	      			title = '<liferay-ui:message key="activitystreams-move" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-move-wtarget" />';
		    	}
	      		break;
	      		
	      	case 'restore':
	      		if(target == null)
		    	{
	      			title = '<liferay-ui:message key="activitystreams-restore" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-restore-wtarget" />';
		    	}
	      		break;
	      		
	      	case 'update-metadata':
	      		if(target == null)
		    	{
		    		title = '<liferay-ui:message key="activitystreams-update-metadata" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-update-metadata-wtarget" />';
		    	}
	      		break;

	      	case 'send':
	      		if(target == null)
		    	{
		    		title = '<liferay-ui:message key="activitystreams-send" />';
		    	}
		    	else
		    	{
		    		title = '<liferay-ui:message key="activitystreams-send-wtarget" />';
		    	}
	      		break;
		  
		  	//undefined verbs
		  	default:
		  		title = actor + ' ' + entry.verb + 'ed';
			  
			    if(object != null)
			    {
			    	title += ' ' + object;
				}
				  
				if(target != null)
				{
					title += ' ' + '<liferay-ui:message key="activitystreams-target-to" />' + ' ' + target;
				}
		  		break;
		  }
		  
		  //replace variables and set title
		  title = title.replace('$ACTOR', actor);
		  title = title.replace('$OBJECT', object);
		  title = title.replace('$OBJECT', target);
		  title = title.replace('$TARGET', target);
		  html += title;
		  
		  return html;
	}

	// function from liferay-shindig-portlets (activities)
	// original name: <portlet:namespace/>getDisplay
	function _getActivityDisplay(object) {
	    var display = '';
	    
	    if(object.objectType == 'person') // not set/used in this app
	    {
	      display += '<a href="/web/guest/profile?userId='
	          + object.id + '" target="_blank">';
	    }
	    else if(object.url)
	    {
	      display += '<a href="' + object.url + '" target="_blank">';
	    }
	  
	    if(object.displayName)  {
	    	if(object.displayName.length <= 30)
		    	display += object.displayName;
		    else {
		    	var shortName = object.displayName.substring(0, 27);
		    	shortName += '...';
		    	display += shortName;
		    }
	    } else if(object.fullname) {
	    	display += object.fullname;
	    } else {
	      display += '<liferay-ui:message key="activitystreams-noname" />';
	    }
	    
	    if(object.url || object.objectType == 'person')
	    	display += '</a>';
	    
	    return display;
	}


	/* return */

	return {
		INDEX: INDEX,
		RESULTTYPE: RESULTTYPE,
		SORTBY: SORTBY,
		SYSTEM: SYSTEM,
		createResult: createResult,
		getSort: getSort,
		getFilterVersion: getFilterVersion,
		getFilterWikiVersion: getFilterWikiVersion,
		getFilterNuxeoTrash: getFilterNuxeoTrash,
		getFilterMailTrash: getFilterMailTrash,
		getFilterCreated: getFilterCreated,
		getFilterAuthor: getFilterAuthor,
		getFilterFiletype: getFilterFiletype,
		getFilterTypes: getFilterTypes,
		getExcludedFilter: getExcludedFilter
	};
}(<portlet:namespace/>Helper, <portlet:namespace/>UserHelper, <portlet:namespace/>Facets, <portlet:namespace/>Model, <portlet:namespace/>View);
/* END Extractor module */


/***********************************************************************************************************/
var <portlet:namespace/>Controller = function(Extractor, Facets, Helper, UserHelper, Model, View){
	var config = {
		DEFAULT: {
			resultsPerPage: 25,
			sortBy: Extractor.SORTBY.score,
			useOwnPagination: true
		},
		INDEX: Extractor.INDEX.index,
		URL: {
			system:{
				elasticsearch: 'http://127.0.0.1:8080/es-relay/',
				appsuite: 'http://127.0.0.1/appsuite',
				liferay: 'http://127.0.0.1:8080',
				nuxeo: 'http://127.0.0.1:8080/nuxeo',
				shindig: 'http://127.0.0.1:8080/shindig'
				
			},
			appsuite:{
				mails_1st: '/#!&app=io.ox/mail/detail&folder=default0/',
				mails_2nd: '&id='
			},
			liferay:{
				findDocument: '/c/document_library/find_file_entry?fileEntryId=',
				findForumMessage: '/c/message_boards/find_message?messageId=',
				findWikiPage: '/c/wiki/find_page?pageResourcePrimKey=',
				hashtagUrl: '/web/guest/hashtag/-/wiki/Main/',
				thumbnail_after: '?imageThumbnail=1',
				userProfile: '/web/guest/profile?userId=',
				userProfileMsgId: '&_ShindigMessaging_WAR_ShindigMessagingportlet_highlightedMsg=',
				userThumbUrl_pre: '/pictures/',
				userThumbUrl_after: '.png',
			},
			nuxeo:{
				docPath_pre: '/nxpath/default',
				docPath_after: '/@view_documents',
				imagePath_pre: '/nxpicsfile',
			},
			shindig:{
				api: '/social/rest',
				people_pre: '/people/',
				people_after: '?sortBy=id&sortOrder=ascending',
				user_pre: '/user?filterBy=displayName&filterOp=contains&filterValue=',
				user_after: '&sortBy=id&sortOrder=ascending&fields=id,displayName,name,emails'
			}
		},
		userId: '',
		NUXEO: {
			imageSizeForThumb: Extractor.INDEX.nuxeo.imageSize.small
		}
	};


	var countInitialResults,
		esClient,
		query,
		htmlResults = [],
		curPage = 0,
		isPagination = false,
		resultsPerPage = config.DEFAULT.resultsPerPage,
		sortBy = config.DEFAULT.sortBy,
		systemToSearch,
		usedIndices,
		userIdPubSub;

	function init() {
		console.log('Init Controller Module.');
		/*
		esClient = new $.es.Client({
			hosts: config.URL.system.elasticsearch,
			connectionClass: 'xhr'
		});

		esClient = new $.es.Client({
			connectionClass: 'xhr',
			hosts: [
				{
					protocol: 'http',
					host: '127.0.0.1',
					port: '9200'
				},
				{
					protocol: 'http',
					host: '127.0.0.1',
					port: '9201'
				}
			]
		}); */

		View.init(Extractor.SYSTEM);
		resetSearch();
		Facets.init();
//		userIdPubSub = new Helper.UserPubSub();

		systemToSearch = Extractor.SYSTEM.allSystems;
		View.prepareSystemToSearch(systemToSearch, Extractor.SYSTEM, handlerSystemToSearch);

		// to prevent first fail-lodaing:
		search(true);
	}

	function search(isInitSearch) {
		if(query || isInitSearch) {
			if(!isInitSearch)
				View.showResultsLoading();
			htmlResults = [];

			if(systemToSearch === Extractor.SYSTEM.allSystemsWithActivities) {
				Facets.excludeFacet(Facets.GROUP_SYSTEM, Extractor.RESULTTYPE.activity);
			} else if(systemToSearch !== Extractor.SYSTEM.allSystems) {
				Facets.chooseFacet(Facets.GROUP_SYSTEM, systemToSearch);
			}

			var from = curPage*resultsPerPage,
				url = _createQueryUrl(query),
				body = _createESQuery(query, from);

			console.log('Sending request to '+url);
			console.log('with query:\n'+JSON.stringify(body));
//			console.log('usedIndices:'+usedIndices);
//			Helper.sendAsyncRequest('GET', url, searchCallback, searchErrorCallback);
			if(isInitSearch)
				Helper.sendRequest('POST', url, null, null, body);
			else
				Helper.sendRequest('POST', url, searchCallback, searchErrorCallback, body);	// WORKING with es-relay

/*
			var from = curPage*resultsPerPage;

			esClient.search({
				index: usedIndices,
				size: resultsPerPage,
				from: from,
				body: body
			}).then(function (body) {
				searchCallback(body);
			}, function (error) {
				searchErrorCallback(error.message);
			});
*/
		}
	}

	function _createESQuery(query, from) {
		var chosen = Facets.getChosenFacetsOrNull(),
			excluded = Facets.getExcludedFacetsOrNull(),
			types = [],
			andFilters = [], len,
			filterCreated = {},
			filterAuthor = {},
			filterFiletype = {},
			filterVersion = Extractor.getFilterVersion(),
			filterWikiVersion = Extractor.getFilterWikiVersion(),
			filterNuxeoTrash = Extractor.getFilterNuxeoTrash(),
			filterMailTrash = Extractor.getFilterMailTrash(),
			filterExclude = {},
			body;

		var i=0;
		andFilters[i++] = filterVersion;
		andFilters[i++] = filterWikiVersion;
		andFilters[i++] = filterNuxeoTrash;
		andFilters[i++] = filterMailTrash;

		if(chosen) {
			if(chosen[Facets.GROUP_FILETYPE_GROUP].length > 0 || chosen[Facets.GROUP_FILETYPE]) {
				filterFiletype = Extractor.getFilterFiletype(
												chosen[Facets.GROUP_FILETYPE],
												chosen[Facets.GROUP_FILETYPE_GROUP]
								);
				andFilters[ andFilters.length ] = filterFiletype[0];
				andFilters[ andFilters.length ] = filterFiletype[1];
				andFilters[ andFilters.length ] = filterFiletype[2];
			}
			if(chosen[Facets.GROUP_SYSTEM]) {
				types = _createQuerySystems(chosen[Facets.GROUP_SYSTEM]);
				if(types.length && types.length > 0)
					andFilters[ andFilters.length ] = Extractor.getFilterTypes( types );
			}
			if(chosen[Facets.GROUP_CREATED]) {
				filterCreated = Extractor.getFilterCreated(chosen[Facets.GROUP_CREATED]);
				andFilters[ andFilters.length ] = filterCreated;
			}
			if(chosen[Facets.GROUP_AUTHOR]) {
				filterAuthor = Extractor.getFilterAuthor(chosen[Facets.GROUP_AUTHOR]);
				andFilters[ andFilters.length ] = filterAuthor;
			}
		}

		if(excluded) {
			filterExclude = Extractor.getExcludedFilter(excluded);
			andFilters[ andFilters.length ] = filterExclude;
		}

		var size = resultsPerPage;
		if(config.DEFAULT.useOwnPagination)
			size = 100;

		// ES 1.5:
		body = {
			query: {
				filtered: {
					query: {						
						bool: { 
							must: {
								query_string: { 
									default_field: "_all",
									query: query,
									default_operator: 'AND'
								}
							}
/*							,should: [
								{
									nested: {
										path: 'file:content',
										query: {
											term: {
												"file:content.mime-type": 'application/pdf'
											}
										}
									}
								},
								{
									term: {
										extension: 'pdf'
									}
								}
							] */
						}
					},
					filter: {
						and: andFilters
					}
				}
			},
			_source: [
				// emails:
				Extractor.INDEX.emails.source.author,
				Extractor.INDEX.emails.source.content,
				Extractor.INDEX.emails.source.folder,
				Extractor.INDEX.emails.source.id,
				Extractor.INDEX.emails.source.timeSent,
				Extractor.INDEX.emails.source.title,
				Extractor.INDEX.emails.source.recipients,
				// liferay:
				Extractor.INDEX.liferay.source.id,
				Extractor.INDEX.liferay.source.className,
				Extractor.INDEX.liferay.source.content,
				Extractor.INDEX.liferay.source.createDate,
				Extractor.INDEX.liferay.source.editedDate,
				Extractor.INDEX.liferay.source.extension,
				Extractor.INDEX.liferay.source.folderId,
				Extractor.INDEX.liferay.source.groupId,
				Extractor.INDEX.liferay.source.mimeType,
				Extractor.INDEX.liferay.source.path,
				Extractor.INDEX.liferay.source.primKey,
				Extractor.INDEX.liferay.source.resourcePrimKey,
				Extractor.INDEX.liferay.source.size,
				Extractor.INDEX.liferay.source.title,
				Extractor.INDEX.liferay.source.userLiferayId,
				Extractor.INDEX.liferay.source.userName,
				// nuxeo:
				Extractor.INDEX.nuxeo.source.author,
				Extractor.INDEX.nuxeo.source.content,
				Extractor.INDEX.nuxeo.source.createDate,
				Extractor.INDEX.nuxeo.source.description,
				Extractor.INDEX.nuxeo.source.editedDate,
				Extractor.INDEX.nuxeo.source.fileContent,
				Extractor.INDEX.nuxeo.source.fileSize,
				Extractor.INDEX.nuxeo.source.noteFulltext,
				Extractor.INDEX.nuxeo.source.noteMimeType,
				Extractor.INDEX.nuxeo.source.icon,
				Extractor.INDEX.nuxeo.source.isVersion,
				Extractor.INDEX.nuxeo.source.path,
				Extractor.INDEX.nuxeo.source.primaryType,
				Extractor.INDEX.nuxeo.source.repository,
				Extractor.INDEX.nuxeo.source.state,
				Extractor.INDEX.nuxeo.source.title,
				Extractor.INDEX.nuxeo.source.uuid,
				// shindig:
				Extractor.INDEX.shindig.activity.source.actor,
				Extractor.INDEX.shindig.activity.source.object,
				Extractor.INDEX.shindig.activity.source.published,
				Extractor.INDEX.shindig.activity.source.target,
				Extractor.INDEX.shindig.activity.source.title,
				Extractor.INDEX.shindig.activity.source.verb,

				Extractor.INDEX.shindig.message.source.content,
				Extractor.INDEX.shindig.message.source.msgId,
				Extractor.INDEX.shindig.message.source.recipients,
				Extractor.INDEX.shindig.message.source.sender,
				Extractor.INDEX.shindig.message.source.title,
				Extractor.INDEX.shindig.message.source.type,
				Extractor.INDEX.shindig.message.source.timeSent,

				Extractor.INDEX.shindig.person.source.id,
				Extractor.INDEX.shindig.person.source.displayName,
				Extractor.INDEX.shindig.person.source.emails,
				Extractor.INDEX.shindig.person.source.name,
				Extractor.INDEX.shindig.person.source.organizations,
				Extractor.INDEX.shindig.person.source.phone,
				Extractor.INDEX.shindig.person.source.tags,
				Extractor.INDEX.shindig.person.source.thumbUrl
			],
			from: from,
			size: size,
			sort: Extractor.getSort(sortBy)
		};
	
		// ES 2.x
		/*
		body = {
			query: { 
				bool: { 
					must: {
						query_string: { 
							default_field: "_all",
							query: query,
							default_operator: 'AND'
						}
					},
					filter: { 
						and: [
							filterVersion,
							filterWikiVersion,
							filterCreated,
							filterAuthor,
							filterFiletype,
							filterExclude
						]
					}
				}
			},
			from: from,
			size: resultsPerPage,
			sort: Extractor.getSort(sortBy)
		}; */

		return body;
	}


	function _createQuerySystems(chosenSystems) {
		var count = 0,
			types = [];

		if(chosenSystems.length===1 && chosenSystems[0]===Extractor.SYSTEM.shindigActivity) {

		} else {
			usedIndices = '';
			for(var i=0, j=chosenSystems.length; i < j; i++) {
				switch(chosenSystems[i]) {
					case Extractor.SYSTEM.liferay:
						if(count++ > 0) usedIndices += ',';
						usedIndices += config.INDEX.liferay;
						break;
					case Extractor.SYSTEM.nuxeo:
						if(count++ > 0) usedIndices += ',';
						usedIndices +=  config.INDEX.nuxeo;
						types.push(Extractor.RESULTTYPE.doc);
						break;
					case Extractor.SYSTEM.mail:
						if(count++ > 0) usedIndices += ',';
						usedIndices +=  config.INDEX.emails;
						types.push(Extractor.RESULTTYPE.mail);
						break;
					case Extractor.SYSTEM.shindigActivity:
						if(usedIndices.indexOf(config.INDEX.shindig) === -1) {
							if(count++ > 0) usedIndices += ',';
							usedIndices += config.INDEX.shindig;
						}
						types.push(Extractor.RESULTTYPE.activity);
						break;
					case Extractor.SYSTEM.shindigMessage:
						if(usedIndices.indexOf(config.INDEX.shindig) === -1) {
							if(count++ > 0) usedIndices += ',';
							usedIndices += config.INDEX.shindig;
						}
						types.push(Extractor.RESULTTYPE.message);
						break;
					case Extractor.SYSTEM.shindigPerson:
						if(usedIndices.indexOf(config.INDEX.shindig) === -1) {
							if(count++ > 0) usedIndices += ',';
							usedIndices += config.INDEX.shindig;
						}
						types.push(Extractor.RESULTTYPE.person);
						break;
				}
			}
		}

		return types;
	}

	
	function _createQueryUrl(query) {
		var typeString,
			url,
			chosen = Facets.getFacets().chosen;

		if(chosen) {
			if(chosen[Facets.GROUP_SYSTEM]) {
				typeString = _createQuerySystems(chosen[Facets.GROUP_SYSTEM]);
			}
		}

		url = config.URL.system.elasticsearch + usedIndices
				+ '/_search'
//				+ '?q=' + query
//				+ '&_source=true'
//				+ '?from=' + curPage*resultsPerPage
//				+ '&size=' + resultsPerPage;

//		if(typeString)
//			url += '&type=' + typeString;	

		return url;
	}


	/* callbacks: */

	function searchCallback(results) {
		console.log(results);

		if(results.hits) {
			var hits = results.hits.hits,
				total = results.hits.total,
				element,
				html,
				result;
			
			if(total===0) {
				htmlResults = '<p style="padding:3em 0; text-align: center;">'
					+ '<liferay-ui:message key="de.iisys.esearch_NoResultsFor-x"/>'+' <strong>'+query+'</strong>.'
					+ '</p>';
			} else {
				for(var i=0, j=hits.length; i < j; i++) {
					html = null;
					result = Extractor.createResult(hits[i], config);
					
					// inheritance: from bottom to upper classes
					if(result instanceof Model.ImageResult) {
						html = View.getHtml_ResultImage(result);
					} else if(result instanceof Model.LiferayResult) {
						html = View.getHtml_ResultLiferay(result);
					} else if(result instanceof Model.DocumentResult) {
						html = View.getHtml_ResultDocument(result);
					} else if(result instanceof Model.MailResult) {
						html = View.getHtml_ResultMail(result);
					} else if(result instanceof Model.MessageResult) {
						html = View.getHtml_ResultMessage(result);
					} else if(result instanceof Model.ActivityResult) {
						html = View.getHtml_ResultActivity(result);
					} else if(result instanceof Model.User) {
						html = View.getHtml_ResultPerson(result, config.URL);
					}
					
					
					if(html!==null) {
						html = $(html);

//						element = $(html).find('.user-icon').parent();
						element = $(html).find('.author');
						UserHelper.addObserver_AuthorSticker(element, result.author.id, result.author.fullname);

						htmlResults.push(html);
					}
				}
			}

			if(config.DEFAULT.useOwnPagination && htmlResults.length > resultsPerPage)
				htmlResults = htmlResults.slice(0, resultsPerPage);

			_showSearchMetaData(total);
			View.appendTo_searchResults(htmlResults);
//			_updateUsersById(userIdPubSub);
			if(!isPagination)
				_showFacets();
			
			UserHelper.updateUserObjects(config, callbackUsersDone, isPagination);

			isPagination = false;

			Helper.loadTooltips();			
		} else {
			searchErrorCallback('Sorry... no results to show.');
		}
	}

	function searchErrorCallback(message, data) {
		console.log('Error: '+message);

		if(data) {
			console.log(data);

			if(data.status && data.status === 500)
				message = '<liferay-ui:message key="de.iisys.esearch_error_InternalServerError"/>';
			else if(!message && data.error)
				message = data.error;

		} else if(message && message.indexOf) {
			if(message.indexOf('Unexpected token < in JSON') > -1)
				message = '<liferay-ui:message key="de.iisys.esearch_error_CASLoggedOut"/>';
			if(message.indexOf('Internal Server Error') > -1)
				message = '<liferay-ui:message key="de.iisys.esearch_error_InternalServerError"/>';
		}

		View.showResultsError(message);
	}

	function _showSearchMetaData(resultsCount) {
		if(!countInitialResults)
			countInitialResults = resultsCount;

		View.showResultsCount(countInitialResults, resultsCount);
		View.prepareSortOrder(sortBy, Extractor.SORTBY, handlerSort);
		View.preparePagination(resultsCount, resultsPerPage, curPage, handlerResultsPerPage, handlerPage);
	}

	function callbackUsersDone() {
		Facets.consolidateAuthorFacets();

		var facets = Facets.getFacets(),
			chosen = facets.chosen,
			available = facets.available,
			initial = facets.initial,
			excluded = facets.excluded,

			authorsHtml;

		authorsHtml = View.getHtml_FacetAuthors(
			chosen[Facets.GROUP_AUTHOR], 
			available[Facets.GROUP_AUTHOR], 
			handlerAuthor);
		View.appendTo_facetAuthors(authorsHtml);
	}

	/* facets: */

	function resetSearch() {
		usedIndices = 
			config.INDEX.emails
			+ ',' + config.INDEX.liferay
			+ ',' + config.INDEX.nuxeo
			+ ',' + config.INDEX.shindig;


		// ES 2.x:
		
//		usedIndices = config.INDEX.liferay;
		

		curPage = 0;
		countInitialResults = null;

		Facets.resetFacets();
		Facets.excludeFacet(Facets.GROUP_SYSTEM, Extractor.RESULTTYPE.activity);
	}

	function _showFacets() {
		var facets = Facets.getFacets(),
			chosen = facets.chosen,
			available = facets.available,
			initial = facets.initial,
			excluded = facets.excluded,

			filetypesHtml,
			createdHtml,
			authorsHtml,
			systemsHtml;

		console.log('facets:'); console.log(facets);

		// filetypes:
		filetypesHtml = View.getHtml_FacetFiletypes(
			chosen[Facets.GROUP_FILETYPE], 
			available[Facets.GROUP_FILETYPE], 
			chosen[Facets.GROUP_FILETYPE_GROUP],
			available[Facets.GROUP_FILETYPE_GROUP],
			handlerFiletype,
			handlerFiletypeGroup);
		View.appendTo_facetAllFiletypes(filetypesHtml);
		// created:
		createdHtml = View.getHtml_FacetCreated(
			chosen[Facets.GROUP_CREATED], 
			available[Facets.GROUP_CREATED]);
		View.appendTo_facetCreated(createdHtml, handlerCreated);
		// authors:
		authorsHtml = View.getHtml_FacetAuthors(
			chosen[Facets.GROUP_AUTHOR], 
			available[Facets.GROUP_AUTHOR], 
			handlerAuthor);
		View.appendTo_facetAuthors(authorsHtml);
		// system:
		systemsHtml = View.getHtml_FacetSystems(
			chosen[Facets.GROUP_SYSTEM],
			available[Facets.GROUP_SYSTEM],
			initial[Facets.GROUP_SYSTEM],
			excluded[Facets.GROUP_SYSTEM],
			Extractor.SYSTEM.shindigActivity,
			Extractor.RESULTTYPE.activity,
			handlerSystem,
			handlerSystemExclude);
		View.appendTo_facetSystems(systemsHtml);
	}

	/* handler: */

	function handlerSearch() {
		query = View.getEl_searchQuery();
		resetSearch();
		View.prepareResultsView();
		search();
	}

	function handlerFiletypeGroup(e) {
		e.preventDefault();
		Facets.chooseFacet(Facets.GROUP_FILETYPE_GROUP, e.data);

		curPage = 0;
		Facets.softReset();
		search();
	}

	function handlerFiletype(e) {
		e.preventDefault();
		Facets.chooseFacet(Facets.GROUP_FILETYPE, e.data);

		curPage = 0;
		Facets.softReset();
		search();
	}

	function handlerCreated(e) {
		e.preventDefault();
		Facets.chooseFacet(Facets.GROUP_CREATED, $(e.data).val());

		curPage = 0;
		Facets.softReset();
		search();
	}

	function handlerAuthor(e) {
		e.preventDefault();
		Facets.chooseFacet(Facets.GROUP_AUTHOR, e.data);

		curPage = 0;
		Facets.softReset();
		search();
	}

	function handlerSystem(e) {
		e.preventDefault();
		Facets.chooseFacet(Facets.GROUP_SYSTEM, e.data);

		curPage = 0;
		Facets.softReset();
		search();
	}

	function handlerSystemExclude(e) {
		e.preventDefault();
		Facets.excludeFacet(Facets.GROUP_SYSTEM, e.data);

		curPage = 0;
		Facets.softReset();
		search();
	}

	function handlerSort(e) {
		e.preventDefault();
		sortBy = e.data;

		curPage = 0;
		Facets.softReset();
		search();
	}

	function handlerSystemToSearch(e) {
		e.preventDefault();
		systemToSearch = e.data;

		View.prepareSystemToSearch(systemToSearch, Extractor.SYSTEM, handlerSystemToSearch);
	}

	function handlerResultsPerPage(e) {
		e.preventDefault();
		resultsPerPage = e.data;

		curPage = 0;
		Facets.softReset();
		search();
	}

	function handlerPage(e) {
		e.preventDefault();
		if(e.data!==curPage) {
			switch(e.data) {
				default:
					curPage = e.data;
			}

//			Facets.softReset();
			isPagination = true;
			search();
		}
	}

	/* users: */

	function _updateUsersById(userPubSub) {
		var users = '',
			userIds = userPubSub.getUserIds(),
			i = 0;

		for(var id in userIds) {
			if(i > 0)
				users += ',';

			users += userIds[key];
			i++;
		}

		var url = config.URL.system.shindig + config.URL.shindig.people_pre + userIds + config.URL.shindig.people_after;

		Helper.sendAsyncRequest('GET', url, Helper.updateUsersByIdCallback);
	}


	/* return */

	return {
		init:init,
		handlerSearch: handlerSearch
	};
}(
	<portlet:namespace/>Extractor,
	<portlet:namespace/>Facets, 
	<portlet:namespace/>Helper,
	<portlet:namespace/>UserHelper,
	<portlet:namespace/>Model, 
	<portlet:namespace/>View
);
/* END Controller module */


<portlet:namespace/>Controller.init();

</aui:script>