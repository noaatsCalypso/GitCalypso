<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>Connected Clients</title>
</head>

<body>
<form name="list" action="/servlet/com.calypso.web.admin.DSClients">
<table cellspacing="2" cellpadding="2" border="0">
<tr>
    <td colspan="2" nowrap><strong><font size="+1">Connected Clients to |ENV_NAME|</font></strong></td>
</tr>
<tr>
    <td colspan="2"><select name="clients" size="10" width="270">|LIST|</select></td>
</tr>
<tr>
    <td><input type="button" name="Stop" value="Stop" onClick='document.all.list.submit();'></td>
    <td align="right"><input type="button" name="Close"  value="Close" onClick='window.close();'></td>
</tr>
</table>
</form>



</body>
</html>
