<?xml version="1.0"?>
<%@page contentType="text/html"
	import="java.net.*,java.util.*,java.io.*"%>
<%@page import="com.calypso.tk.core.*,com.calypso.tk.event.*,com.calypso.tk.service.*"%>
<%@page import="com.calypso.engine.util.*"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Hashtable"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%
	String resetStats = request.getParameter("resetEventStats");
	if (resetStats != null) {
		DSConnection.getDefault().getRemoteAccess().resetEventStats();
		response.sendRedirect(request.getContextPath() + "/admin/metrics/eventStats");
		return;
	}


%>

<t:header/>
<link rel="stylesheet" href="engineStyle.css" type="text/css"></link>
<fmt:bundle basename="com.calypso.web.admin.server"
            prefix="com.calypso.web.admin.engine.event.stats.">

<div class="mainContent">
	<div>
		<h3><fmt:message key="title"/></h3>
		<table class="strippedTable">
			<tr>
				<th><fmt:message key="name"/></th>
				<th><fmt:message key="unconsumed"/></th>
				<th><fmt:message key="start"/></th>
				<th><fmt:message key="end"/></th>
				<th><fmt:message key="milliseconds"/></th>
				<th><fmt:message key="consumed"/></th>
				<th><fmt:message key="total"/></th>
			</tr>

			<%
				EventStats estats = DSConnection.getDefault().getRemoteAccess().getEventStats();
			
				JDatetime totalSDT = estats.getStartDatetime();
				JDatetime totalEDT = estats.getEndDatetime();
				
				String totalStartTime = totalSDT!=null?totalSDT.toString():"";
				String totalEndTime = totalEDT!=null?totalEDT.toString():"";
				
				long totalMilliseconds = 0;
				if (totalSDT != null && totalEDT != null) {
					totalMilliseconds = totalEDT.getTime() - totalSDT.getTime();
				}
				
				out.println("<tr>");
				out.println("<td>Current Total</td>");
				out.println("<td>" + estats.getCurrent() + "</td>");
				out.println("<td>" + totalStartTime + "</td>");
				out.println("<td>" + totalEndTime + "</td>");
				out.println("<td>" + totalMilliseconds + "</td>");
				out.println("<td/>");
				out.println("<td/>");
				out.println("</tr>");
			
				
				List<String> engineNames = estats.getEngineNames();
				
				for (String engineName: engineNames) {
					
					JDatetime startDt = estats.getStartDatetime();
					JDatetime endDt = estats.getEngineEndDatetime(engineName);
					long milliseconds = 0;
					if (startDt != null && endDt != null) {
						milliseconds = endDt.getTime() - startDt.getTime();
	                }
					
					String startTime = "";
					if (startDt != null) {
						startTime = startDt.toString();
					}
					String endTime = "";
					if (endDt != null) {
						endTime = endDt.toString();
					}
					
					out.println("<tr>");
					out.println("<td>" + engineName + "</td>");
					out.println("<td>" + estats.getCurrent(engineName) + "</td>");
					out.println("<td>" + startTime + "</td>");
					out.println("<td>" + endTime + "</td>");
					out.println("<td>" + milliseconds + "</td>");
					out.println("<td>" + estats.getConsumed(engineName) + "</td>");
					out.println("<td>" + estats.getTotalConsumed(engineName) + "</td>");
					out.println("</tr>");
				}
			%>
		</table>
		<form method="post">
			<input type="submit" name="resetEventStats" value="<fmt:message key="reset"/>"/>
		</form>
	</div>
</div>

</fmt:bundle>

<t:footer/>
