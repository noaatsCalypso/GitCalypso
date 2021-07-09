<%@page import="com.calypso.tk.refdata.Group"%>
<%@page import="com.calypso.tk.refdata.User"%>
<%@page import="com.calypso.tk.service.DataServer"%>
<%@page import="com.calypso.tk.service.DSConnection"%>
<%@page import="com.calypso.web.admin.util.PermissionUtil"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Comparator"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.util.Hashtable"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Vector"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%!
	private boolean isAdmin(User user, Hashtable allGroups) {
		Vector groups = user.getGroups();
		for (int i = 0; i < groups.size(); i++) {
    		String group = (String) groups.get(i);
    		if (group.equalsIgnoreCase("admin")) {
				return true;
    		}
    		Group g = (Group)allGroups.get(group);
    		if (g.getIsAdminB()) {
				return true;
    		}
		}
		return false;
	}
%>

<%
	List<Group> groups = new Vector<Group>();
	Hashtable groupsH = DSConnection.getDefault().getRemoteAccess().getUserAccessPermission().getGroups();
	Enumeration eg = groupsH.elements();
	while(eg.hasMoreElements()) {
		Group g = (Group)eg.nextElement();
		if(!g.getIsAdminB() && !g.getName().toLowerCase().equals("admin")) {
			groups.add(g);
		}
	}
	Collections.sort(groups, new Comparator<Group>() {
		public int compare(Group o1, Group o2) {
			return o1.getName().compareTo(o2.getName());
		}
	});

	List<User> users = new Vector<User>();
	Hashtable usersH = DSConnection.getDefault().getRemoteAccess().getUserAccessPermission().getUsers();
	Enumeration eu = usersH.elements();
	while(eu.hasMoreElements()) {
		User user = (User)eu.nextElement();
		if (! isAdmin(user, groupsH)) {
			users.add(user);
		}
	}	
	Collections.sort(users, new Comparator<User>() {
		public int compare(User o1, User o2) {
			return o1.getName().compareTo(o2.getName());
		}
	});
	
	// action
	String groupEnable = request.getParameter("groupEnable");
	String groupDisable = request.getParameter("groupDisable");
	String groupSelected = request.getParameter("group");
	String userEnable = request.getParameter("userEnable");
	String userDisable = request.getParameter("userDisable");
	String userSelected = request.getParameter("user");
	
	if (groupEnable != null) {
		// group enable
		Vector<String> gs = new Vector<String>();
		gs.add(groupSelected);
		DataServer.setAllowLogin(gs, new Vector<String>());
		
		response.sendRedirect(request.getContextPath() + "/admin/allowLogin");
		return;
	} else if (groupDisable != null) {
		// group disable
		DataServer.removeAllowLogin(groupSelected, null);
		
		response.sendRedirect(request.getContextPath() + "/admin/allowLogin");
		return;
	} else if (userEnable != null) {
		// user enable
		Vector<String> us = new Vector<String>();
		us.add(userSelected);
		DataServer.setAllowLogin(new Vector<String>(), us);
		
		response.sendRedirect(request.getContextPath() + "/admin/allowLogin");
		return;
	} else if (userDisable != null) {
		// user disable
		DataServer.removeAllowLogin(null, userSelected);
		
		response.sendRedirect(request.getContextPath() + "/admin/allowLogin");
		return;
	}
%>

<t:header/>

<t:access permission="<%=PermissionUtil.ISADMIN %>"/>

<fmt:bundle basename="com.calypso.web.admin.server"
	prefix="com.calypso.web.admin.login.restricted.">
	
<c:set var="message"><fmt:message key="disabled"/></c:set>
<t:unavailable condition="<%= ! DataServer.getRestrictedMode() %>" message="${message}"/>

<div class="mainContent">	
	<h3><fmt:message key="manage.title"/></h3>
	<form>
		<table class="propertyTable">
			<tr>
				<td><fmt:message key="manage.group"/></td>
				<td>
					<select id="group" name="group">
						<%
							for(Group g : groups) {
								out.write("<option value=\""+g.getName()+"\">"+g.getName()+"</option>\n");
							}
						%>
					</select>
				</td>
				<td><input type="button" id="groupEnable" name="groupEnable" value="<fmt:message key="manage.enable"/>"/></td>
				<td><input type="button" id="groupDisable" name="groupDisable" value="<fmt:message key="manage.disable"/>"/></td>				
			</tr>
			<tr>
				<td><fmt:message key="manage.user"/></td>
				<td>
					<select id="user" name="user">
						<%
							for(User u : users) {
								out.write("<option value=\""+u.getName()+"\">"+u.getName()+"</option>\n");
							}
						%>
					</select>
				</td>
				<td><input type="button" id="userEnable" name="userEnable" value="<fmt:message key="manage.enable"/>"/></td>
				<td><input type="button" id="userDisable" name="userDisable" value="<fmt:message key="manage.disable"/>"/></td>
			</tr>
		</table>
		
		<h3><fmt:message key="current.title"/></h3>
		<table class="strippedTable">
			<%
				List<String> allowedUsers = new Vector<String>();
				Enumeration e = usersH.keys();
				while(e.hasMoreElements()) {
					String userName = (String)e.nextElement();
					User user = (User)usersH.get(userName);
					if (isAdmin(user, groupsH)) {
						allowedUsers.add(userName);
					} else if (DataServer.isAllowLogin(userName)) {
						allowedUsers.add(userName);
					}
				}
				Collections.sort(allowedUsers, new Comparator<String>() {
					public int compare(String o1, String o2) {
						return o1.compareTo(o2);
					}
				});
				
				for(String allowedUser : allowedUsers) {
					out.write("<tr><td>" + allowedUser + "</td></tr>\n");
				}
				
			%>
		</table>
	</form>
	<br />
</div>
</fmt:bundle>

<t:footer/>
