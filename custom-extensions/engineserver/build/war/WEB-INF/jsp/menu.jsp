<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<fmt:bundle basename="com.calypso.web.admin.server"
            prefix="com.calypso.web.admin.menu.">

<ul>
	<li>
		<a><fmt:message key="server.title"/></a>
		<ul>
			<li><a href="<%= request.getContextPath() %>/admin/server/serverInfo"><fmt:message key="server.info"/></a></li>
			<li><a href="<%= request.getContextPath() %>/admin/server/environmentProperties"><fmt:message key="server.env"/></a></li>
			<li><a href="<%= request.getContextPath() %>/admin/server/systemProperties"><fmt:message key="server.system"/></a></li>
			<li><a href="<%= request.getContextPath() %>/admin/messenger"><fmt:message key="server.messenger"/></a></li>
			<li><a href="<%= request.getContextPath() %>/admin/server/patcherAuditInformation"><fmt:message key="server.audit"/></a></li>
		</ul>
	</li>
	<li><a><fmt:message key="metrics.title"/></a>
		<ul>
			<li><a href="<%= request.getContextPath() %>/admin/metrics/localCaches"><fmt:message key="metrics.caches"/></a></li>
			<li><a href="<%= request.getContextPath() %>/admin/metrics/pendingEvents"><fmt:message key="metrics.events"/></a></li>			
		</ul>
	</li>
	<li><a><fmt:message key="profiler.title"/></a>
		<ul>
			<li><a href="<%= request.getContextPath() %>/admin/profiler/serverProfiler"><fmt:message key="profiler.server.request"/></a></li>
			<li><a href="<%= request.getContextPath() %>/admin/profiler/clientProfiler"><fmt:message key="profiler.client.request"/></a></li>
		</ul>
	</li>
	<li><a><fmt:message key="manage.title"/></a>
		<ul>
			<li><a href="<%= request.getContextPath() %>/admin/manage/engineManager"><fmt:message key="manage.engines"/></a></li>
		</ul>
	</li>
	<li><a><fmt:message key="monitoring.title"/></a>
		<ul>
			<li><a href="<%= request.getContextPath() %>/admin/monitoring/alerts"><fmt:message key="monitoring.alerts"/></a></li>
		</ul>
	</li>
	<li>
		<a href="<%= request.getContextPath() %>/admin/log"><fmt:message key="logs"/></a>
	</li>
</ul>

</fmt:bundle>
