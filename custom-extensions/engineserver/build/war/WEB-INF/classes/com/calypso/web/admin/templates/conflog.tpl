<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
	<title>|TITLE|</title>
</head>

<body>
<form name="log" action="/servlet/com.calypso.web.admin.|SERVLET|">
<table cellspacing="2" cellpadding="0" border="0" BGCOLOR="#000000"  WIDTH ="100%"><tr><td>
<table cellspacing="2" cellpadding="2" border="0" BGCOLOR="#FFFFFF" WIDTH ="100%">
<tr>
    	<td>Level to be logged</td>
    	<td><INPUT TYPE="checkbox" name = "debug" |DEBUGCHECK|>Debug</td>
	<td><INPUT TYPE="checkbox" name = "info" |INFOCHECK|>Info</td>
	<td><INPUT TYPE="checkbox" name = "warning" |WARNINGCHECK|>Warning</td>
	<td><INPUT TYPE="checkbox" name = "error" CHECKED DISABLED>Error</td>
	<td><INPUT TYPE="checkbox" name = "Fatal" CHECKED DISABLED>Fatal</td>
</tr>
<tr>
    <td colspan="6" ALIGN=LEFT VALIGN="BOTTOM">Category to be logged:</td>
</tr>
<tr>
    <td colspan="5" ALIGN=LEFT><INPUT TYPE="TEXT" name ="category" value="|CATEGORIES|" SIZE ="65"></td><td><input type="button" name="button" value = "Select" onClick = 'window.open("com.calypso.web.admin.SelLogCategory?appl=|APP| ", "SelLogCategory", "resizable=1; width=400; height=400")'></td>
</tr>
<tr>
    <td COLSPAN="6" ALIGN=RIGHT><input type="submit" name="submit" value="Save"> &nbsp;
    <input type="button" name="Close"  value="Close" onClick='window.close();'></td>
</tr>
</table>
</td></tr>
</table>
<INPUT TYPE="HIDDEN" name="app" value="|TITLE|">
<INPUT TYPE="HIDDEN" name="application" value="|APP|">

</form>

</body>
</html>
