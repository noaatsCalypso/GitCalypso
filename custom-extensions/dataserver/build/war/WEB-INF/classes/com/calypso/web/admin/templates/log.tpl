<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>Log Window</title>
</head>

<body>
<form name="log" action="/servlet/com.calypso.web.admin.|SERVLET|">
<table cellspacing="2" cellpadding="2" border="0">
<tr>
    <td colspan="2" nowrap><strong><font size="+1">|TITLE|:</font></strong></td>
</tr>
<tr>
    <td colspan="2"><textarea cols="80" rows="20" wrap="off">|LOG|</textarea></td>
</tr>
<tr>
    <td><input type="button" name="Refresh" value="Refresh" onClick='document.log.submit();' |DISABLED|></td>
    <td align="right"><input type="button" name="Close"  value="Close" onClick='window.close();'></td>
</tr>
</table>

<input type=hidden name=info value="|INFO|"> 
</form>



</body>
</html>
