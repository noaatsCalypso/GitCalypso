<%@page import="com.calypso.tk.core.logging.Monitor"%>
<%@page import="com.calypso.tk.core.logging.MonitoringCategories"%>
<%@page import="com.calypso.tk.refdata.AccessUtil"%>
<%@page import="com.calypso.web.admin.util.PermissionUtil"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<fmt:bundle basename="com.calypso.web.admin.server"
            prefix="com.calypso.web.admin.menu.">

<ul>
	<li><a><fmt:message key="server.title"/></a>
		<ul>
			<li><a href="<%= request.getContextPath() %>/admin/server/serverInfo"><fmt:message key="server.info"/></a></li>
			<li><a href="<%= request.getContextPath() %>/admin/server/environmentProperties"><fmt:message key="server.env"/></a></li>
			<li><a href="<%= request.getContextPath() %>/admin/server/systemProperties"><fmt:message key="server.system"/></a></li>
			<c:if test="<%=PermissionUtil.hasPermission(session, AccessUtil.ADMLOGINATTEMPTS)%>">
				<li><a href="<%= request.getContextPath() %>/admin/loginAttempt"><fmt:message key="server.attempts"/></a></li>
			</c:if>
			<c:if test="<%=PermissionUtil.hasAdminPermission(session)%>">
				<li><a href="<%= request.getContextPath() %>/admin/allowLogin"><fmt:message key="server.restricted"/></a></li>
			</c:if>
			<li><a href="<%= request.getContextPath() %>/admin/messenger"><fmt:message key="server.messenger"/></a></li>
			<li><a href="<%= request.getContextPath() %>/admin/server/patcherAuditInformation"><fmt:message key="server.audit"/></a></li>
		</ul>
	</li>
	<li><a><fmt:message key="metrics.title"/></a>
		<ul>
			<li><a href="<%= request.getContextPath() %>/admin/caches"><fmt:message key="metrics.caches"/></a></li>
			<li><a href="<%= request.getContextPath() %>/admin/metrics/tasks"><fmt:message key="metrics.tasks"/></a></li>
			<li><a href="<%= request.getContextPath() %>/admin/metrics/pendingEvents"><fmt:message key="metrics.events"/></a></li>
			<li><a href="<%= request.getContextPath() %>/admin/metrics/publishStats"><fmt:message key="metrics.publishstats"/></a></li>
		</ul>
	</li>
	<li><a><fmt:message key="manage.title"/></a>
		<ul>
			<li><a href="<%= request.getContextPath() %>/admin/manage/engineManager"><fmt:message key="manage.engines"/></a></li>
		</ul>
		<ul>
			<c:if test="<%=PermissionUtil.hasAdminPermission(session)%>">
				<li><a href="#"><fmt:message key="properties"/></a>
				<ul>
                   <li><a href="<%= request.getContextPath() %>/admin/manage/configureSensorProperties"><fmt:message key="properties.sensor"/></a></li>
                   <li><a href="<%= request.getContextPath() %>/admin/manage/configureSubsystemProperties"><fmt:message key="properties.subsystem"/></a></li>
                 </ul>
				</li>
			</c:if>
		</ul>
	</li>
	<li><a><fmt:message key="profiler.title"/></a>
		<ul>
			<c:if test="<%= Monitor.isMonitoringEnabled(MonitoringCategories.MONITORING_SERVERREQUEST) %>">
				<li><a href="<%= request.getContextPath() %>/admin/profiler/serverProfiler"><fmt:message key="profiler.request"/></a></li>
			</c:if>
			<li><a href="<%= request.getContextPath() %>/admin/profiler/sqlProfiler"><fmt:message key="profiler.sql"/></a></li>
		</ul>
	</li>
	<li><a><fmt:message key="monitoring.title"/></a>
		<ul>
			<li><a href="<%= request.getContextPath() %>/admin/monitoring/alerts"><fmt:message key="monitoring.alerts"/></a></li>
			<li><a href="<%= request.getContextPath() %>/admin/connectedClients"><fmt:message key="monitoring.clients"/></a></li>
			<li><a href="<%= request.getContextPath() %>/admin/monitoring/registeredServers"><fmt:message key="monitoring.servers"/></a></li>
			<li><a href="<%= request.getContextPath() %>/admin/monitoring/sqlStatements"><fmt:message key="monitoring.sql"/></a></li>
		</ul>
	</li>
	<li><a href="<%= request.getContextPath() %>/admin/log"><fmt:message key="logs"/></a></li>
</ul>

</fmt:bundle>
