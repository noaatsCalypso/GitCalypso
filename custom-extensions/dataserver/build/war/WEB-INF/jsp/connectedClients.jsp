
<%@page import="com.calypso.tk.service.RemoteEngineManagerService" %>
<%@page import="com.calypso.infra.admin.RemoteUserSession"%>
<%@page import="com.calypso.infra.authentication.userdetails.CalypsoUserDetails"%>
<%@page import="com.calypso.tk.core.Util"%>
<%@page import="com.calypso.tk.service.DSConnection"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Comparator"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Vector"%>
<%@page import="com.calypso.web.admin.util.PermissionUtil"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%
String clientId = request.getParameter("clientId");
String sortBy = request.getParameter("sortBy");
String order = request.getParameter("order");
String stopAll = request.getParameter("stopAll");
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

orders.put("HostName", -1);
orders.put("User", -1);
orders.put("Application", -1);
orders.put("InstanceName", -1);
orders.put("ClientId", -1);

orders.put(sortBy,(order.equals("-1"))?1:-1);

DSConnection ds = DSConnection.getDefault();
RemoteUserSession sessionService = ds.getRemoteUserSession();
Set<String> engineManagers = ds.getService(RemoteEngineManagerService.class).getEngineManagerTypes();
List<CalypsoUserDetails> connectedClients = sessionService.getConnectedClients();
if (! Util.isEmpty(stopAll)) {
	Iterator<CalypsoUserDetails> connectedClientItr = (Iterator<CalypsoUserDetails>) connectedClients.iterator();
    while(connectedClientItr.hasNext()) {
    	CalypsoUserDetails userDetails = connectedClientItr.next();
    	// we cannot kill engines since engine is not standalone clients anymore
    	if (! userDetails.getAppName().contains("Engine")) {
    		sessionService.sendKill(String.valueOf(userDetails.getClientId()));
    	}
    }
    
	response.sendRedirect(request.getContextPath() + "/admin/connectedClients");
	return;
}

if (! Util.isEmpty(clientId)) {
	sessionService.sendKill(clientId);
	response.sendRedirect(request.getContextPath() + "/admin/connectedClients");
	return;
}

%>


<t:header/>
<fmt:bundle basename="com.calypso.web.admin.server"
	prefix="com.calypso.web.admin.clients.">
<div class="mainContent">
			<c:choose>
			<c:when test ="<%=PermissionUtil.hasAdminPermission(session)%>">
			</c:when>
			<c:when test ="<%=PermissionUtil.hasPermission(session, PermissionUtil.ISNONADMIN)%>">
			<p class="a">User does not have permission to stop connected clients. Displaying in read-only mode.</p>
			</c:when>
			</c:choose>
	<h3><fmt:message key="title"/></h3>
		<!-- <input type="hidden" name="type" value="REQUEST"/> -->
		<table class="propertyTable">
			<tr>
				<th><fmt:message key="hostname"/></th>
				<th><fmt:message key="user"/></th>
				<th><fmt:message key="application"/></th>
				<th><fmt:message key="instance"/></th>
				<th><fmt:message key="id"/></th>
				<th>Action</th>
			</tr>
			<%
				String stopAllDisabled = "disabled=\"disabled\"";
			
				final String s = sortBy;
				final java.util.HashMap<String,Integer> o = orders;
				Collections.sort(connectedClients, new Comparator<CalypsoUserDetails>() {
		    		public int compare(CalypsoUserDetails o1, CalypsoUserDetails o2) {
		    			if ("HostName".equals(s)) {
		    				String o1HostName = o1.getHostName()==null?"":o1.getHostName();
		    				String o2HostName = o2.getHostName()==null?"":o2.getHostName();
		    				return o.get("HostName") * o1HostName.compareTo(o2HostName);
		    			} else if ("User".equals(s)) {
		    				String o1User = o1.getUsername()==null?"":o1.getUsername();
		    				String o2User = o2.getUsername()==null?"":o2.getUsername();
		    				return o.get("User") * o1User.compareTo(o2User);
		    			} else if ("Application".equals(s)) {
		    				String o1Application = o1.getAppName()==null?"":o1.getAppName();
		    				String o2Application = o2.getAppName()==null?"":o2.getAppName();
		    				return o.get("Application") * o1Application.compareTo(o2Application);
		    			} else if ("InstanceName".equals(s)) {
		    				String o1InstanceName = o1.getInstanceName()==null?"":o1.getInstanceName();
		    				String o2InstanceName = o2.getInstanceName()==null?"":o2.getInstanceName();
		    				return o.get("InstanceName") * o1InstanceName.compareTo(o2InstanceName);
		    			} else if ("ClientId".equals(s)) {
		    				return o.get("ClientId") * Long.valueOf(o1.getClientId()).compareTo(Long.valueOf(o2.getClientId()));
		    			} else {
		    				String o1Application = o1.getAppName()==null?"":o1.getAppName();
		    				String o2Application = o2.getAppName()==null?"":o2.getAppName();
		    				return o.get("Application") * o1Application.compareTo(o2Application);
		    			}
		    		}
		    	});
			
			
				for (Iterator<CalypsoUserDetails> ite = connectedClients.iterator();ite.hasNext();) {
					CalypsoUserDetails userDetails = ite.next();
					
					// Do not display engine clients
					if (userDetails.getAppName().contains("Engine") || engineManagers.contains(userDetails.getAppName())) {
						continue;
					}
					stopAllDisabled = "";
					
					String appName = userDetails.getAppName();
					String cId = Long.toString(userDetails.getClientId());
					
					%>
					
					<form mthod="post">
					<tr>
						<td><c:out value="<%= userDetails.getHostName() %>"/></td>
						<td><c:out value="<%= userDetails.getUsername() %>"/></td>
						<td><c:out value="<%= appName %>"/></td>
						<td><c:out value="<%= userDetails.getInstanceName() %>"/></td>
						<td><c:out value="<%= cId %>"/></td>
						<td><input type="hidden" name="clientId" value="<%= cId %>"/>
						<c:choose>
						<c:when test ="<%=PermissionUtil.hasAdminPermission(session)%>">
							<input type="submit" name="stop" value="<fmt:message key="stop"/>"/>
						</c:when>
						<c:when test ="<%=PermissionUtil.hasPermission(session, PermissionUtil.ISNONADMIN)%>">
							<input type="submit" name="stop" value="<fmt:message key="stop"/>"  disabled="disabled"/>
						</c:when>
						</c:choose>
						</td>
					</tr>
					</form>
					<%
				}
				
			%>
			<form>
				<tr>
				<c:choose>
				<c:when test ="<%=PermissionUtil.hasAdminPermission(session)%>">
					<td><input type="button" id="stopAll" name="stopAll" value="<fmt:message key="stopAll"/>" <%= stopAllDisabled %>/></td>
				</c:when>
				<c:when test ="<%=PermissionUtil.hasPermission(session, PermissionUtil.ISNONADMIN)%>">
					<td><input type="button" id="stopAll" name="stopAll" value="<fmt:message key="stopAll"/>" <%= stopAllDisabled %> disabled="disabled"/></td>
				</c:when>
				</c:choose>
				<td colspan="5"/>	
				</tr>
			</form>
		</table>
	<br />
</div>
</fmt:bundle>

<t:footer/>
