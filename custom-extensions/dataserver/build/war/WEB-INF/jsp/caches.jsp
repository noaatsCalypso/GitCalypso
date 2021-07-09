<%@page import="com.calypso.tk.event.PSEventAdmin"%>
<%@page import="com.calypso.tk.event.PSEvent"%>
<%@page import="com.calypso.tk.service.DSConnection"%>
<%@page import="com.calypso.tk.event.publisher.EventPublisherBean"%>
<%@page import="com.calypso.tk.core.Trade"%>
<%@page import="com.calypso.tk.core.JDatetime"%>
<%@page import="com.calypso.tk.core.AuditValue"%>
<%@page import="com.calypso.tk.core.FieldModification"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Vector"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.lang.Double"%>
<%@page import="com.calypso.tk.core.CacheUtil"%>
<%@page import="com.calypso.tk.core.Util"%>
<%@page import="com.calypso.tk.core.CacheLimit"%>
<%@page import="com.calypso.tk.util.cache.CacheMetric"%>
<%@page import="com.calypso.tk.util.cache.CacheMetrics"%>
<%@page import="com.calypso.web.admin.util.PermissionUtil"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<t:header/>
<fmt:bundle basename="com.calypso.web.admin.server"
            prefix="com.calypso.web.admin.caches.server.">
<%
	String configStatus = "";
	String clearStatus = "";
	
	String[] limitNames = ((request.getParameter("limitName")  != null) ? request.getParameter("limitName").split(";") : null);
	
	boolean clearCache = !Util.isEmpty(request.getParameter("clearCaches"));
	boolean clearClientCaches = !Util.isEmpty(request.getParameter("clearClientCaches"));
	boolean changeCacheSettings = !Util.isEmpty(request.getParameter("changeCacheSetting"));
	boolean removeTradeFromCache = !Util.isEmpty(request.getParameter("removeTradeFromCache"));
	
	if ( removeTradeFromCache ){
		
		Long tradeId = null;
		String tradeIdStr = request.getParameter("tradeID");
		
		if (Util.isEmpty(tradeIdStr)){
			clearStatus += "Need to specify a trade ID" ;
		} else {
		
		    try {
			    tradeId = Long.parseLong(tradeIdStr);
			    try {
			        Trade queryTrade = new Trade();
			        queryTrade.setLongId(tradeId);
			        DSConnection.getDefault()
			                    .getRemoteTrade()
			                    .removeFromCache(queryTrade);
				
			    } catch (Exception e){
	       	 	    clearStatus += "Failed to remove "+tradeIdStr +" from server cache. "; 
	       	 	    if (e.getMessage() != null){
	       	 	        clearStatus += e.getMessage();
	       	 	    }
			    }

		    } catch (Exception e){
       	 	    clearStatus += "Invalid trade ID "+tradeIdStr +" specified. ";
       	 	    if (e.getMessage() != null){
       	 	        clearStatus += e.getMessage();
       	 	    }
		    }
		}
	}
	
	if (clearClientCaches) {
		 PSEventAdmin ev = new PSEventAdmin();
	     ev.setType(PSEventAdmin.CLEAR_CACHE);
	     ev.setMessage("Clear Cache");
	     
	     EventPublisherBean epBean = DSConnection.getDefault().getLocalService(EventPublisherBean.class);
	     List<PSEvent> events = new ArrayList<PSEvent>();
	     events.add(ev);
	     epBean.publishEvents(events);
	     
	     String entityName = "Clear Cache";
         String fieldName = "ClearClientsCache";
         String oldValue = "";
         String newValue = "Cache Cleared";
         
         Vector avs = new Vector();
         String userName = DSConnection.getDefault().getUser();
         JDatetime curTime = new JDatetime();
         AuditValue av = new AuditValue("Admin",
                                        0,
                                        new FieldModification(fieldName,
                                                              entityName,
                                                              oldValue,
                                                              newValue),
                                        userName,
                                        curTime);

         av.setEntityName(entityName);
         avs.add(av);
         try {
             DSConnection.getDefault().getRemoteTrade().saveAudits(avs);
         } catch (Exception e) {
        	 clearStatus += "Unable to save audit for clearing client caches: ";
    	 	 if (e.getMessage() != null){
      	 	      clearStatus += e.getMessage();
       	 	 }
        }	     
	}
	
	
	if(clearCache) {
		
		Map<String, CacheMetrics> tmpMetrics = CacheUtil.getCacheMetrics();
	    String entityName = "Clear Cache";

		try {
			int count = 0;
			for(count=0; limitNames != null && count < limitNames.length; count++) {
				String limitName = limitNames[count];
				DSConnection.getDefault().getRemoteAccess().clearCache(limitName);
				
		        Vector avs = new Vector();
		        String userName = DSConnection.getDefault().getUser();
		        JDatetime curTime = new JDatetime();
		        
		        CacheMetrics metric = tmpMetrics.get(limitName);
		        
		        Double oldValue = metric.getReadMetric().getHits();
		        
		        AuditValue av = new AuditValue("Admin",
		                                       0,
		                                       new FieldModification(limitName,
		                                                             "Cache",
		                                                             oldValue.toString(),
		                                                             "0"),
		                                       userName,
		                                       curTime);

		        av.setEntityName(entityName);
		        avs.add(av);
		        try {
		             DSConnection.getDefault().getRemoteTrade().saveAudits(avs);
		        } catch (Exception e) {
		        	 clearStatus += "Unable to save audit for clearing server cache for "+ limitName + " : ";
		    	 	 if (e.getMessage() != null){
		      	 	      clearStatus += e.getMessage();
		       	 	 }
		        }
			}
			
			clearStatus = count+" caches cleared";
		}
		catch(Exception e) {
			clearStatus += "Unable to clear caches: ";
 	 	    if (e.getMessage() != null){
 	 	      clearStatus += e.getMessage();
  	 	    }
		}
	}
	
	if(changeCacheSettings) {
		try {
			CacheLimit limit = CacheUtil.getServerCacheLimit(limitNames[0]);
			limit.setMaxSize(Integer.parseInt(request.getParameter("serverMax")));
			DSConnection.getDefault().getRemoteAccess().save(limit);
			
			limit = CacheUtil.getClientCacheLimit(limitNames[0]);
			limit.setMaxSize(Integer.parseInt(request.getParameter("clientMax")));
			DSConnection.getDefault().getRemoteAccess().save(limit);
			
			configStatus += "Client/Server configuration updated, restart is required";
		} catch (Exception e) {
			configStatus += "Unable to update configuration: ";
 	 	    if (e.getMessage() != null){
 	 	 	      clearStatus += e.getMessage();
 	  	 	}
		}
	}
	pageContext.setAttribute("clearStatus",clearStatus);
%>
<div class="mainContent">
			<c:choose>
				<c:when test ="<%=PermissionUtil.hasAdminPermission(session)%>">
				</c:when>
				<c:when test ="<%=PermissionUtil.hasPermission(session, PermissionUtil.ISNONADMIN)%>">
				<p class="a">User does not have permission to configure server cache. Displaying in read-only mode.</p>
				</c:when>
			</c:choose>
<h3><fmt:message key="configure.title"/></h3>
<i><font size="2" color="red"><%= configStatus %></font></i>
<div class="myform">
	<form id="configureCacheForm">
		<table>
			<tr>
				<td><fmt:message key="configure.name"/></td>
				<td>
					<select id="limitName" name="limitName">
						<%
							for(String limitName : CacheUtil.getCacheMetrics().keySet()) {
								out.write("<option value=\""+limitName+"\">"+limitName+"\n");
							}
						%>
					</select>
				</td>
				<td><fmt:message key="configure.client"/></td><td><input type="number" id="clientMax" name="clientMax" value="<%= CacheLimit.DEFAULT_CLIENT_MAX_SIZE %>"/></td>
				<td><fmt:message key="configure.server"/></td><td><input type="number" id="serverMax" name="serverMax" value="<%= CacheLimit.DEFAULT_SERVER_MAX_SIZE %>"/></td>
				<c:choose>
				<c:when test ="<%=PermissionUtil.hasAdminPermission(session)%>">
					<td><input type="submit" id="changeCacheSetting" name="changeCacheSetting" value=<fmt:message key="configure.submit"/> /></td>
				</c:when>
				<c:when test ="<%=PermissionUtil.hasPermission(session, PermissionUtil.ISNONADMIN)%>">
					<td><input type="submit" id="changeCacheSetting" name="changeCacheSetting" value=<fmt:message key="configure.submit"/> disabled="disabled"/></td>
				</c:when>
				</c:choose>
			</tr>
		</table>
	</form>
</div>

<h3><fmt:message key="display.title"/></h3>
<i><font size="2" color="red"><c:out value="${clearStatus}"/></font></i>
<form id="serverCachesForm">
<table class="strippedTable">
	<tr>
		<th><input type="checkbox" id="checkAllCache" value="ALL" /></th>
		<th><fmt:message key="display.name"/></th>
		<th><fmt:message key="display.hit"/></th>
		<th><fmt:message key="display.current"/></th>
		<th><fmt:message key="display.max"/></th>
	</tr>
	<%
	    Map<String, CacheMetrics> metrics = CacheUtil.getCacheMetrics();
		for (String limitName : metrics.keySet()) {
			CacheMetrics metric = metrics.get(limitName);
			if (metric != null) {
				out.write("<tr>\n");
				out.write("    <td><input type=checkbox name=\"limitName\" value=\"" + limitName + "\"/></td>\n");
				out.write("    <td>" + limitName + "</td>\n");
				out.write("    <td>" + metric.getHitRatioAsString() + "</td>\n");
				out.write("    <td>" + NumberFormat.getInstance(request.getLocale()).format(metric.getPopulation()) + "</td>\n");
				out.write("    <td>" + NumberFormat.getInstance(request.getLocale()).format(metric.getMaxSize()) + "</td>\n");
				out.write("</tr>\n");
			}
		}
	%>
	<tr>
		<td colspan="5">
			<input type="button" id="clearCaches" value="<fmt:message key='clear.server'/>"/>
			<input type="button" id="clearClientCaches" value="<fmt:message key='clear.client'/>"/>
			Trade ID: <input type="text" id="tradeID" value=""/>
			<input type="button" id="removeTradeFromCache" value="<fmt:message key='clear.trade'/>"/>
		</td>
	</tr>
</table>
</form>
</div>
</fmt:bundle>
<t:footer/>