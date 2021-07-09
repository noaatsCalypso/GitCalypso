<%@page import="java.util.Set"%>
<%@page import="java.util.HashSet"%>
<%@page import="com.calypso.tk.bo.TaskStats"%>
<%@page import="com.calypso.tk.refdata.AccessUtil"%>
<%@page import="com.calypso.tk.service.DSConnection"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<t:header/>

<t:access permission="<%=AccessUtil.ADMSERVER %>"/>

<fmt:bundle basename="com.calypso.web.admin.server"
			prefix="com.calypso.web.admin.tasks.">

<fmt:message key="nodata" var="noData"/>
<%

StringBuilder taskStatsData = new StringBuilder();

TaskStats stats = DSConnection.getDefault().getRemoteAccess().getTaskStats(); 

if(stats != null) {
	Set<String> types = new HashSet<String>();
	Integer value = null;
	types.addAll(stats.getCompletedStats().keySet());
	types.addAll(stats.getNewStats().keySet());
	types.addAll(stats.getNewKickOffStats().keySet());
	types.addAll(stats.getUnderProcessingStats().keySet());
	types.addAll(stats.getPassedOverStats().keySet());
	
	for(String type: types) {
		taskStatsData.append("<tr>\n");
		taskStatsData.append("<td>" + type + "</td>\n");
		
		value = (Integer)stats.getCompletedStats().get(type);
		taskStatsData.append("<td>" + ((value != null)?value:Integer.valueOf(0)) + "</td>\n");
		
		value = (Integer)stats.getNewStats().get(type);
		taskStatsData.append("<td>" + ((value != null)?value:Integer.valueOf(0)) + "</td>\n");
		
		value = (Integer)stats.getNewKickOffStats().get(type);
		taskStatsData.append("<td>" + ((value != null)?value:Integer.valueOf(0)) + "</td>\n");
		
		value = (Integer)stats.getUnderProcessingStats().get(type);
		taskStatsData.append("<td>" + ((value != null)?value:Integer.valueOf(0)) + "</td>\n");
		
		value = (Integer)stats.getPassedOverStats().get(type);
		taskStatsData.append("<td>" + ((value != null)?value:Integer.valueOf(0)) + "</td>\n");
		
		taskStatsData.append("</tr>\n");
		
	}
} else {
	taskStatsData.append("<tr>\n");
	taskStatsData.append("<td colspan=\"6\">" + pageContext.getAttribute("noData") + "</td>\n");
	taskStatsData.append("</tr>\n");
}

%>

<div class="mainContent">
	<h3><fmt:message key="title"/></h3>
	<table class="strippedTable">
		<tr>
			<th><fmt:message key="type"/></th>
			<th><fmt:message key="completed"/></th>
			<th><fmt:message key="new"/></th>
			<th><fmt:message key="kickoff"/></th>
			<th><fmt:message key="processing"/></th>
			<th><fmt:message key="passed"/></th>
		</tr>
		<%=taskStatsData %>
		
	</table>
</div>
</fmt:bundle>
<t:footer/>