<html>

<!-- 
   Keywords are:
     USER
     PASSWORD
     ENV_NAME
     MESSAGE
-->

<head>
<title></title>
</head>
<body bgcolor="#ffffff" onload='document.forms[0].CalypsoUserName.focus()'>
<form action="/servlet/com.calypso.web.admin.Logon" method=get>
<table border="0" cellspacing="2" cellpadding="2">
<tr><td>
<IMG alt="" border=0 src="/e-calypso/html/util/images/logo.gif">
</td></tr></table>
<br>
<br>
<table border="0" cellspacing="0" cellpadding="2" bgcolor="#ffffcc" align="center">
<tr bgcolor="#ffffff">
<td colspan=4>
   <font face="arial,helvetica" size="5"><b>
<font color="#6666cc">Calypso&nbsp;</font> 
<font color="#99cc00">Log On</font>
</b></font>
</td>
</tr>
<tr bgcolor="#ffffff">
<td colspan=4>&nbsp;</td>
</tr>
<tr>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
</tr>
<tr>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
</tr>
  <TR>
 
    <TD colSpan=4></TD></TR>
  <TR>
    <TD><FONT FACE="Arial,Helvetica" size=2><b>Calypso Name:</b></FONT></TD>
    <TD colSpan=3><FONT FACE="Arial,Helvetica" size=2><b>Calypso Password:</b></FONT></TD></TR>
  <TR>
    <TD><input name=CalypsoUserName value="|USER|" SIZE=15></TD>
    <TD colSpan=3><input type=password name=CalypsoPassword value="|PASSWORD|" SIZE=15></TD></TR>
<tr>
<td><FONT FACE="Arial,Helvetica" size=2><b>Environment Name:</b></FONT></td>
<td colspan=3>&nbsp;</td>
</tr>
<tr>
<td colspan=2>
<select name=EnvName size=1 onChange='submit();'>
|ENV_NAME|
</select>
</td>
<td colspan=2><input type="image" name="Logon" src="/e-calypso/html/util/images/logon.gif" border="0"></td>
<tr>
<td colspan=4><FONT FACE="Arial,Helvetica" size=2><b><font color="#ee1111">|MESSAGE|<font></b></FONT></td>
</tr>
</table>
</form>
</body>
</html>