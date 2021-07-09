<%@page import="com.calypso.tk.refdata.AccessUtil"%>
<%@page import="com.calypso.tk.refdata.User" %>
<%@page import="com.calypso.infra.admin.RemoteUserSession"%>
<%@page import="com.calypso.infra.authentication.userdetails.CalypsoUserDetails"%>
<%@page import="com.calypso.tk.core.Util"%>
<%@page import="com.calypso.tk.service.DSConnection"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Comparator"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Vector"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%
String sortBy = request.getParameter("sortBy");
String order = request.getParameter("order");
java.util.HashMap<String,Integer> orders = new java.util.HashMap<String,Integer>();

if(Util.isEmpty(sortBy)) {
	// Try to get session attribute
	sortBy = (String)session.getAttribute("sortBy");
	if(Util.isEmpty(sortBy)) {
		sortBy="Application";
	}
}

session.setAttribute("sortBy",sortBy);

if(Util.isEmpty(order)) {
	// Try to get session attribute
	order = (String)session.getAttribute("order");
	if(Util.isEmpty(order)) {
		order="-1";
	}
}

session.setAttribute("order",order);

orders.put("Application", -1);
orders.put("InstanceName", -1);
orders.put("HostName", -1);

orders.put(sortBy,(order.equals("-1"))?1:-1);

DSConnection ds = DSConnection.getDefault();
RemoteUserSession sessionService = ds.getRemoteUserSession();
List<CalypsoUserDetails> connectedClients = sessionService.getConnectedClients();

User currentUser = (User)session.getAttribute("calypsoUser");
boolean isAdmin = AccessUtil.isAdmin(currentUser);
%>


<t:header/>
<fmt:bundle basename="com.calypso.web.admin.server"
	prefix="com.calypso.web.admin.clients.">
<div class="mainContent">
	<h3><fmt:message key="engines"/></h3>
		<!-- <input type="hidden" name="type" value="REQUEST"/> -->
		<table class="propertyTable">
			<tr>
				<th><fmt:message key="application"/></th>
				<th><fmt:message key="hostname"/></th>
				<th><fmt:message key="instance"/></th>
			</tr>
			<%
				String stopAllDisabled = "disabled=\"disabled\"";
			
				final String s = sortBy;
				final java.util.HashMap<String,Integer> o = orders;
				Collections.sort(connectedClients, new Comparator<CalypsoUserDetails>() {
		    		public int compare(CalypsoUserDetails o1, CalypsoUserDetails o2) {
		    			if ("Application".equals(s)) {
		    				String o1Application = o1.getAppName()==null?"":o1.getAppName();
		    				String o2Application = o2.getAppName()==null?"":o2.getAppName();
		    				return o.get("Application") * o1Application.compareTo(o2Application);
		    			} else if ("HostName".equals(s)) {
		    				String o1HostName = o1.getHostName()==null?"":o1.getHostName();
		    				String o2HostName = o2.getHostName()==null?"":o2.getHostName();
		    				return o.get("HostName") * o1HostName.compareTo(o2HostName);
		    			} else if ("InstanceName".equals(s)) {
		    				String o1InstanceName = o1.getInstanceName()==null?"":o1.getInstanceName();
		    				String o2InstanceName = o2.getInstanceName()==null?"":o2.getInstanceName();
		    				return o.get("InstanceName") * o1InstanceName.compareTo(o2InstanceName);
		    			} else {
		    				String o1Application = o1.getAppName()==null?"":o1.getAppName();
		    				String o2Application = o2.getAppName()==null?"":o2.getAppName();
		    				return o.get("Application") * o1Application.compareTo(o2Application);
		    			}
		    		}
		    	});
			
			
				for (Iterator<CalypsoUserDetails> ite = connectedClients.iterator();ite.hasNext();) {
					CalypsoUserDetails userDetails = ite.next();
					
					// Only display engine clients
					if (!userDetails.getAppName().contains("Engine")) {
						continue;
					}
					stopAllDisabled = "";
					
					String appName = userDetails.getAppName();
					String cId = Long.toString(userDetails.getClientId());
					
					%>
					
					<tr>
						<td><c:out value="<%= appName %>"/></td>
						<td><c:out value="<%= userDetails.getHostName() %>"/></td>
						<td><c:out value="<%= userDetails.getInstanceName() %>"/></td>
					</tr>
					<%
				}
				%>
		</table>
	<br />
</div>
</fmt:bundle>
<t:footer/>