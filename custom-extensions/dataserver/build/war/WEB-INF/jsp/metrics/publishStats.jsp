<%@page import="java.util.Set"%>
<%@page import="java.util.HashSet"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="com.calypso.tk.bo.TaskStats"%>
<%@page import="com.calypso.tk.refdata.AccessUtil"%>
<%@page import="com.calypso.tk.service.DSConnection"%>
<%@page import="com.calypso.tk.event.publisher.EventPublishingStatisticsBean"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<t:header />

<%
String lookupMessage = "";
try {
	String name = "java:module/com.calypso.tk.event.publisher.EventPublishingStatisticsBean";
    InitialContext ctx = new InitialContext();
	EventPublishingStatisticsBean eventStats = 
	        (EventPublishingStatisticsBean)ctx.lookup(name);
	
	pageContext.setAttribute("publishstats", eventStats);
}
catch (Exception e) {
 		lookupMessage = e.getMessage();
}
%>

<fmt:bundle basename="com.calypso.web.admin.server" prefix="com.calypso.web.admin.publishstats.">
	<fmt:message key="nodata" var="noData" />
	<div class="mainContent">
		<h3>
			<fmt:message key="title" />
		</h3>
				<%= lookupMessage %>
				<p>
					<fmt:message key="pending" />
					<fmt:formatNumber minFractionDigits="0" maxFractionDigits="1" value="${publishstats.pendingEventsToPublishCount}" /><br/>
					<fmt:message key="pending.description" />
				</p>
				<p>
					<fmt:message key="published" />
					<fmt:formatNumber minFractionDigits="0" maxFractionDigits="1" value="${publishstats.publishedEventsCount}" /><br/>
					<fmt:message key="published.description" />
				</p>
				<p>
					<fmt:message key="dropped" />
					<fmt:formatNumber minFractionDigits="0" maxFractionDigits="1" value="${publishstats.droppedEventCount}" /><br/>
					<fmt:message key="dropped.description" />
				</p>
				<p>
					<fmt:message key="failed" />
					<fmt:formatNumber minFractionDigits="0" maxFractionDigits="1" value="${publishstats.failedEventCount}" /><br/>
					<fmt:message key="failed.description" />
				</p>
				<p>
					<fmt:message key="max" />
					<fmt:formatNumber minFractionDigits="0" maxFractionDigits="1" value="${publishstats.maxEventQueueSize}" /><br/>
					<fmt:message key="max.description" />
				</p>
	</div>
</fmt:bundle>
<t:footer />