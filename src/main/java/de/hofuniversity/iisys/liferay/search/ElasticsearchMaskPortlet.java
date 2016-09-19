package de.hofuniversity.iisys.liferay.search;

import java.io.IOException;
import java.io.PrintWriter;

import javax.portlet.Portlet;
import javax.portlet.PortletException;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;

import org.osgi.service.component.annotations.Component;

import com.liferay.portal.kernel.exception.NoSuchUserException;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;
import com.liferay.portal.kernel.security.auth.CompanyThreadLocal;
import com.liferay.portal.kernel.service.UserLocalServiceUtil;
import com.liferay.portal.kernel.util.ParamUtil;

@Component(
	immediate = true,
	property = {
		"com.liferay.portlet.display-category=category.sample",
		"com.liferay.portlet.instanceable=true",
		"com.liferay.portlet.footer-portlet-javascript=/js/elasticsearch.jquery.js",
		"com.liferay.portlet.header-portlet-css=/css/main.css",
		"com.liferay.portlet.css-class-wrapper=elasticsearchmaskwrapper",
		"javax.portlet.display-name=Enterprise Search",
		"javax.portlet.security-role-ref=power-user,user",
		"javax.portlet.init-param.template-path=/",
		"javax.portlet.init-param.view-template=/html/view.jsp",
		"javax.portlet.resource-bundle=content.Language"
	},
	service = Portlet.class
)
public class ElasticsearchMaskPortlet extends MVCPortlet {
	@Override
	public void serveResource(ResourceRequest resourceRequest, ResourceResponse resourceResponse)
			throws IOException, PortletException {
		String resourceID = resourceRequest.getResourceID();
		if(resourceID.equals("autocomplete")) {
//			getUsersForAutocomplete(resourceRequest, resourceResponse);
		} else if(resourceID.equals("userFullName")) {
			getFullNameByScreenName(resourceRequest, resourceResponse);
		} else {
			super.serveResource(resourceRequest, resourceResponse);
		}
	}
	
	private void getFullNameByScreenName(ResourceRequest resourceRequest, ResourceResponse resourceResponse)
			throws IOException,	PortletException {
		String screenName = ParamUtil.getString(resourceRequest, "screenName");
		
//		User user = null;
		String fullName = null;
		
		// PROBLEM: Unresolved requirement: Import-Package: com.liferay.portal.kernel.model; version="[7.0.0,8.0.0)"

		/*
		try {
//			user = UserLocalServiceUtil.getUserByScreenName(CompanyThreadLocal.getCompanyId(), screenName);
			fullName = UserLocalServiceUtil.getUserByScreenName(CompanyThreadLocal.getCompanyId(), screenName).getFullName();
		} catch (NoSuchUserException nsuE) {
			System.out.println("com.liferay.portal.NoSuchUserException | screenName="+screenName);
		} catch (PortalException | SystemException e) {
			e.printStackTrace();
		}
		*/
		
		resourceResponse.setContentType("text/html");
		PrintWriter writer = resourceResponse.getWriter();
		if(fullName==null)
			writer.print(screenName);
		else
			writer.print(fullName);
		
		writer.flush();
		writer.close();
		super.serveResource(resourceRequest, resourceResponse);
	}
}