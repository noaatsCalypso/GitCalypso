<%@page import="java.util.TimeZone"%>
<%@page import="com.calypso.tk.core.JDatetime"%>
<%@page import="com.calypso.tk.core.Util"%>
<%@page import="com.calypso.tk.refdata.AccessUtil"%>
<%@page import="com.calypso.tk.refdata.UserLoginAttempt"%>
<%@page import="com.calypso.tk.service.DSConnection"%>
<%@page import="java.text.ParseException"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Comparator"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="org.owasp.encoder.Encode"%>
<%@page import="com.calypso.web.admin.util.PathUtil"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%

	String fromDate = request.getParameter("fromDate");
	String fromTimeHour = request.getParameter("fromTimeHour");
	String fromTimeMinute = request.getParameter("fromTimeMinute");
	String fromTimeSecond = request.getParameter("fromTimeSecond");
	String fromTimePeriod = request.getParameter("fromTimePeriod");
	String toDate = request.getParameter("toDate");
	String toTimeHour = request.getParameter("toTimeHour");
	String toTimeMinute = request.getParameter("toTimeMinute");
	String toTimeSecond = request.getParameter("toTimeSecond");
	String toTimePeriod = request.getParameter("toTimePeriod");
	
	List<UserLoginAttempt> loginAttempts = null;
	String message = null;
	
	String load = request.getParameter("load");
	String delete = request.getParameter("delete");
	String purge = request.getParameter("purge");
	
	if (load != null || delete != null || purge != null) {
		String fromTime = fromTimeHour + ":" + fromTimeMinute + ":" + fromTimeSecond + " " + fromTimePeriod;	
		String toTime = toTimeHour + ":" + toTimeMinute + ":" + toTimeSecond + " " + toTimePeriod;

		JDatetime fromDt = null;
		JDatetime toDt = null;
		
		try {
			fromDt = new JDatetime((new SimpleDateFormat("MM/dd/yyyy h:m:s a")).parse(fromDate + " " + fromTime));
			
			// Ensure we have a valid date
			if (fromDt == null) {
				message = "message.error.fromDate";
			} 
		} catch(ParseException ex) {
			message = "message.error.fromDate";
		}
		
		// Do not proceed if we don't have a properly entered from date
		if(message == null) {
			try {
				toDt = new JDatetime((new SimpleDateFormat("MM/dd/yyyy h:m:s a")).parse(toDate + " " + toTime));
				
				// Ensure we have a valid date
				if (toDt == null) {
					message = "message.error.toDate";
				}
			} catch(ParseException ex) {
				message = "message.error.toDate";
			}
		}
		
		String where = null;
		
		if (message == null) {
			if (load != null) {
				// we will load login attempts for load, delete, purge action later, so do nothing here
			} else if (delete != null) {
				DSConnection.getDefault().getRemoteAccess().deleteLoginAttempts(fromDt, toDt, where, null);
			} else if (purge != null) {
				DSConnection.getDefault().getRemoteAccess().purgeLoginAttempts(fromDt, toDt, where, null);
			}
			loginAttempts = DSConnection.getDefault().getRemoteAccess().getLoginAttempts(fromDt, toDt, where, null);
			if (loginAttempts.isEmpty()) {
				message = "message.noAttempts";
			}
		}
	}
		
%>

<t:header/>

<t:access permission="<%=AccessUtil.ADMLOGINATTEMPTS %>"/>

<fmt:bundle basename="com.calypso.web.admin.server"
	prefix="com.calypso.web.admin.login.attempts.">
<div class="mainContent">
	<h3><fmt:message key="title"/></h3>
    <table>
		<tr>
			<td><fmt:message key="server.time"/></td>
			<td><%= new JDatetime() %></td>
		</tr>
		<tr>
			<td colspan="2">
			 <fmt:message key="timezone.message"> 
			     <fmt:param value="<%= TimeZone.getDefault().getDisplayName()%>"/> 
			 </fmt:message>
			</td>
		</tr>
	</table>
	<form>
		<input type="hidden" id="webadminPath" value="<%= PathUtil.getWebAdminPath(request) %>" />
		<table class="propertyTable">
			<tr>
				<td><fmt:message key="from"/></td>
				<td>
					<input type="text" id="fromDate" value="<%= (fromDate==null?"":Util.htmlEncode(fromDate)) %>" />&nbsp;(mm/dd/yyyy)&nbsp;&nbsp;
					<select id="fromTimeHour">
					<%
						boolean selectedSet = false;
						for(int i=1; i<=12; i++) {
							if (String.valueOf(i).equals(fromTimeHour) || (i==12 && ! selectedSet)) {
								out.write("<option value=\"" + i + "\" selected>" + i + "</option>\n");
								selectedSet = true;
							} else {
								out.write("<option value=\"" + i + "\">" + i + "</option>\n");
							}
						}
					%>
					</select>
					:
					<select id="fromTimeMinute">
					<%
						for(int i=0; i<=59; i++) {
							if (String.valueOf(i).equals(fromTimeMinute)) {
								out.write("<option value=\"" + i + "\" selected>" + i + "</option>\n");
							} else {
								out.write("<option value=\"" + i + "\">" + i + "</option>\n");
							}
						}
					%>
					</select>
					:
					<select id="fromTimeSecond">
					<%
						for(int i=0; i<=59; i++) {
							if (String.valueOf(i).equals(fromTimeSecond)) {
								out.write("<option value=\"" + i + "\" selected>" + i + "</option>\n");
							} else {
								out.write("<option value=\"" + i + "\">" + i + "</option>\n");
							}
						}
					%>
					</select>
					&nbsp;
					<select id="fromTimePeriod">
					<%
						if ("PM".equals(fromTimePeriod)) {
							out.write("<option value=\"AM\">AM</option>\n");
							out.write("<option value=\"PM\" selected>PM</option>\n");
						} else {
							out.write("<option value=\"AM\" selected>AM</option>\n");
							out.write("<option value=\"PM\">PM</option>\n");
						}
					%>
					</select>
				</td>
			</tr>
			<tr>
				<td><fmt:message key="to"/></td>
				<td>
					<input type="text" id="toDate" value="<%= (toDate==null?"":Util.htmlEncode(toDate)) %>" />&nbsp;(mm/dd/yyyy)&nbsp;&nbsp;
					<select id="toTimeHour">
					<%
						selectedSet = false;
						for(int i=1; i<=12; i++) {
							if (String.valueOf(i).equals(toTimeHour) || (i==12 && ! selectedSet)) {
								out.write("<option value=\"" + i + "\" selected>" + i + "</option>\n");
								selectedSet = true;
							} else {
								out.write("<option value=\"" + i + "\">" + i + "</option>\n");
							}
						}
					%>
					</select>
					:
					<select id="toTimeMinute">
					<%
						for(int i=0; i<=59; i++) {
							if (String.valueOf(i).equals(toTimeMinute)) {
								out.write("<option value=\"" + i + "\" selected>" + i + "</option>\n");
							} else {
								out.write("<option value=\"" + i + "\">" + i + "</option>\n");
							}
						}
					%>
					</select>
					:
					<select id="toTimeSecond">
					<%
						for(int i=0; i<=59; i++) {
							if (String.valueOf(i).equals(toTimeSecond)) {
								out.write("<option value=\"" + i + "\" selected>" + i + "</option>\n");
							} else {
								out.write("<option value=\"" + i + "\">" + i + "</option>\n");
							}
						}
					%>
					</select>
					&nbsp;
					<select id="toTimePeriod">
					<%
						if ("PM".equals(toTimePeriod)) {
							out.write("<option value=\"AM\">AM</option>\n");
							out.write("<option value=\"PM\" selected>PM</option>\n");
						} else {
							out.write("<option value=\"AM\" selected>AM</option>\n");
							out.write("<option value=\"PM\">PM</option>\n");
						}
					%>
					</select>
				</td>
			</tr>
		</table>
		<table class="propertyTable">
			<tr>
				<td><input type="button" id="load" value="<fmt:message key="load"/>" /></td>
				<td><input type="button" id="purge" value="<fmt:message key="purge"/>" /></td>
				<td><input type="button" id="delete" value="<fmt:message key="delete"/>" /></td>
			</tr>
		</table>
		<% 
			if (message != null) {
		%>
				<i><font size="2" color="red"><fmt:message key="<%= message %>"/></font></i>
		<%
			} else if (loginAttempts != null) {
		%>
				<br />
				<table class="strippedTable">
					<tr>
						<th><fmt:message key="date"/></th>
						<th><fmt:message key="type"/></th>
						<th><fmt:message key="username"/></th>
						<th><fmt:message key="application"/></th>
						<th><fmt:message key="hostname"/></th>
						<th><fmt:message key="success"/></th>
						<th><fmt:message key="dsname"/></th>
						<th><fmt:message key="dshost"/></th>
						<th><fmt:message key="env"/></th>
					</tr>
			<%	
				Collections.sort(loginAttempts, new Comparator<UserLoginAttempt>() {
				    public int compare(UserLoginAttempt o1, UserLoginAttempt o2) {
				    	JDatetime nullDatetime = new JDatetime(0L);
			    		JDatetime o1result = o1.getLoginDatetime()==null?nullDatetime:o1.getLoginDatetime();
			    		JDatetime o2result = o2.getLoginDatetime()==null?nullDatetime:o2.getLoginDatetime();
			    		return -1 * o1result.compareTo(o2result);
				    }
				});
						
				for (Iterator<UserLoginAttempt> ite = loginAttempts.iterator();ite.hasNext();) {
					UserLoginAttempt loginAttempt = ite.next();
					
					out.write("<tr>\n"
							+ "	<td>" + loginAttempt.getLoginDatetime() + "</td>\n"
							+ "	<td>" + Encode.forHtml(loginAttempt.getCode()) + "</td>\n" 
							+ "	<td>" + Encode.forHtml(loginAttempt.getUserName()) + "</td>\n" 
							+ "	<td>" + Encode.forHtml(loginAttempt.getAppName()) + "</td>\n"
							+ "	<td>" + Encode.forHtml(loginAttempt.getHostName()) + "</td>\n"
							+ " <td>" + loginAttempt.getSuccessB() + "</td>\n"
							+ " <td>" + (loginAttempt.getDataServerName()==null?"":Encode.forHtml(loginAttempt.getDataServerName())) + "</td>\n"
							+ " <td>" + (loginAttempt.getDataServerHostName()==null?"":Encode.forHtml(loginAttempt.getDataServerHostName())) + "</td>\n"
							+ " <td>" + (loginAttempt.getEnvName()==null?"":Encode.forHtml(loginAttempt.getEnvName())) + "</td>\n"
							+ "</tr>\n");
				}
			}
			%>
		</table>
	</form>
	<br />
</div>
</fmt:bundle>
<t:footer/>

