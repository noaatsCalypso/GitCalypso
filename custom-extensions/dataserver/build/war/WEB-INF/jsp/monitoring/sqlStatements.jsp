<%@page import="com.calypso.tk.service.interceptor.ProfilingInterceptor"%>
<%@page import="com.calypso.tk.core.AuditValue" %>
<%@page import="com.calypso.tk.core.FieldModification" %>
<%@page import="com.calypso.tk.core.JDatetime"%>
<%@page import="com.calypso.tk.core.Log" %>
<%@page import="com.calypso.tk.core.SystemSettings"%>
<%@page import="com.calypso.tk.core.Util"%>
<%@page import="com.calypso.tk.refdata.AccessUtil"%>
<%@page import="com.calypso.tk.service.DSConnection"%>
<%@page import="com.calypso.tk.service.LocalCache"%>
<%@page import="com.calypso.web.admin.util.PermissionUtil"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="java.util.Collection"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Vector"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<t:header/>
<fmt:bundle basename="com.calypso.web.admin.server"
		prefix="com.calypso.web.admin.monitoring.sql.">

<%!private void checkAndSaveAudits(String entityName, String fieldName, String oldValue, String newValue, String userName) {
	try {
		if (LocalCache.getDomainValues(DSConnection.getDefault(),
				"classAuditMode").contains("Admin")) {
			if (DSConnection
					.getDefault()
					.getRemoteAccess()
					.getAllowAuth(new SystemSettings().getClass().getName())) {
				Vector avs = new Vector();
				JDatetime curTime = new JDatetime();
				AuditValue av = new AuditValue("Admin", 0,
						new FieldModification(fieldName, entityName,
								oldValue, newValue), userName, curTime);
					av.setEntityName(entityName);
				avs.add(av);
				DSConnection.getDefault().getRemoteTrade().saveAudits(avs);
			}
		}
	} catch (Exception e) {
		Log.error(this, e);
	}
}

private static final Pattern OUTPUT_PATTERN = Pattern.compile("[A-Za-z0-9\\s.'-/:=,\\[\\]]+");

private String validatePreviousOutput(String previousOutput) {
	if (!Util.isEmpty(previousOutput)) {
		if (!OUTPUT_PATTERN.matcher(previousOutput).matches()) {
			Log.error("ConnectionStatementWebAdmin", "Invalid value specified for 'output': " + previousOutput);
			return null;
		}
	}
	return previousOutput;
}
%>

<%

//Validate previous output
String previousText = validatePreviousOutput(request.getParameter("output"));

StringBuilder textAreaOutput = new StringBuilder((previousText!=null)?previousText:"");
StringBuilder sqlConnectionText = new StringBuilder();

StringBuilder hostOptions = new StringBuilder();
StringBuilder connectionOptions = new StringBuilder();

String capture = request.getParameter("capture");
String clear = request.getParameter("clear");
String release = request.getParameter("release");
String selectedHost = request.getParameter("host");
String selectedConnection = request.getParameter("connection");
String update = request.getParameter("update");

boolean isProfiled = ProfilingInterceptor.getClientRequestEnabled();

if(!Util.isEmpty(capture)) {
	
	Vector<?> capturedStatements = DSConnection.getDefault().getRemoteAccess().getConnectionStatementLog(selectedHost, 0);
	
	Collection<String> hosts = (Collection<String>)capturedStatements.elementAt(1);
	Iterator<?> connectionIterator = null;
	
	// First get the summary String
	sqlConnectionText.append(new JDatetime());
	sqlConnectionText.append("\n");
	sqlConnectionText.append(capturedStatements.elementAt(0).toString());
	
	// Next populate current hosts
	for(String host : hosts) {
		hostOptions.append("<option value=\"");
		hostOptions.append(host);
		hostOptions.append("\">");
		hostOptions.append(host);
		hostOptions.append("</option>\n");
	}
	// Remove the first two elements, remaining elements are connection ids
	capturedStatements.removeElementAt(0);
	capturedStatements.removeElementAt(0);
	
	// Get list of connections
	connectionIterator = capturedStatements.iterator();
	while(connectionIterator.hasNext()) {
		Long connectionId = (Long)connectionIterator.next();
		
		connectionOptions.append("<option value=\"");
		connectionOptions.append(connectionId.toString());
		connectionOptions.append("\">");
		connectionOptions.append(connectionId.toString());
		connectionOptions.append("</option>\n");
	}
} else if(!Util.isEmpty(release)) {
	sqlConnectionText.append(new JDatetime());
	sqlConnectionText.append("\n");
	if(selectedConnection.equals("ALL")) {
		String result = DSConnection.getDefault().getRemoteAccess().killHostConnections( selectedHost );
		sqlConnectionText.append(result);
		sqlConnectionText.append(" DB connection(s) stopped [host: ");
		sqlConnectionText.append(selectedHost);
		sqlConnectionText.append("].\n");
		
		checkAndSaveAudits("ReleaseAllConnection", "ALL", result, "0", request.getRemoteUser());
	} else {
		boolean result = DSConnection.getDefault().getRemoteAccess().killConnection(selectedConnection);
		if(result) {
			sqlConnectionText.append("Connection ");
			sqlConnectionText.append(selectedConnection);
			sqlConnectionText.append(" released...\n");
			
			checkAndSaveAudits("ReleaseConnection", selectedConnection, "Connected", "Disconnected", request.getRemoteUser());
		} else {
			sqlConnectionText.append("Can't release the connection ");
			sqlConnectionText.append(selectedConnection);
			sqlConnectionText.append(", may have already been released.\n");
		}
	}
	sqlConnectionText.append("\n");
} else if (!Util.isEmpty(update)) {
	isProfiled = Boolean.parseBoolean(update);
	ProfilingInterceptor.setClientRequestEnabled(isProfiled);
}

if(!Util.isEmpty(clear)) {
	textAreaOutput = new StringBuilder();
} 

//Log actions
String sqlConnectionString = sqlConnectionText.toString();
if(!Util.isEmpty(sqlConnectionString)) {
	Log.system("ConnectionStatement", sqlConnectionString.trim());
}

request.setAttribute("sqlConnectionText", textAreaOutput.append(sqlConnectionString).toString());

%>

<div class="mainContent">

<form id="sqlStatementsForm">
			<c:choose>
				<c:when test ="<%=PermissionUtil.hasAdminPermission(session)%>">
				</c:when>
				<c:when test ="<%=PermissionUtil.hasPermission(session, PermissionUtil.ISNONADMIN)%>">
				<p class="a">User does not have permission to modify settings. Displaying in read-only mode.</p>
				</c:when>
			</c:choose>
	<h3><fmt:message key="title"/></h3>
	<table>
		<tr>
			<td><fmt:message key="host"/></td>
			<td>
				<select id="host" name="host">
					<option value="ALL">ALL</option>
					<%= hostOptions %>
				</select>
			</td>
		</tr>
		<c:if test="<%=PermissionUtil.hasPermission(session, AccessUtil.ADMRELEASECONNECTION)%>">
			<tr>
				<td><fmt:message key="connection"/></td>
				<td>
					<select id="connection" name="connection">
						<option value="ALL">ALL</option>
						<%= connectionOptions %>
					</select>
				
					<input type="button" id="release" name="release" value="<fmt:message key="release"/>"/>
				
				</td>
			</tr>
		</c:if>
		<tr>
			<td>
			<c:choose>
				<c:when test ="<%=PermissionUtil.hasAdminPermission(session)%>">
				<input type="radio" id="updateOn" name="update" value="true"  <%=isProfiled ? "checked" : ""%> />
						<fmt:message key="enabled" /><br /> 
				<input type="radio" id="updateOff"  name="update" value="false"  <%=!isProfiled ? "checked" : ""%> /> 
						<fmt:message key="disabled" />
				</c:when>
				<c:when test ="<%=PermissionUtil.hasPermission(session, PermissionUtil.ISNONADMIN)%>">
				<input type="radio" id="updateOn" name="update"  value="true" <%=isProfiled ? "checked" : ""%> disabled="disabled"/>
						<fmt:message key="enabled" /><br /> 
				<input type="radio" id="updateOff"  name="update" id="updateOff" value="false"   <%=!isProfiled ? "checked" : ""%> disabled="disabled"/> 
						<fmt:message key="disabled" />
				</c:when>
			</c:choose>
			</td>
			<td>
			<c:choose>
				<c:when test ="<%=PermissionUtil.hasAdminPermission(session)%>">
				<input type="button" id="capture" name="capture" value="<fmt:message key="capture"/>"/>
				<input type="button" id="clear" name="clear" value="<fmt:message key="clear"/>"/>
				</c:when>
				<c:when test ="<%=PermissionUtil.hasPermission(session, PermissionUtil.ISNONADMIN)%>">
				<input type="button" id="capture" name="capture" value="<fmt:message key="capture"/>" disabled="disabled"/>
				<input type="button" id="clear" name="clear" value="<fmt:message key="clear"/>" disabled="disabled"/>
				</c:when>
			</c:choose>
				
			</td>
	</table>
	<textarea id="output" name="output" class="sqlStatements" readonly><c:out value="${sqlConnectionText}"/></textarea>
</form>

</div>

</fmt:bundle>

<t:footer/>