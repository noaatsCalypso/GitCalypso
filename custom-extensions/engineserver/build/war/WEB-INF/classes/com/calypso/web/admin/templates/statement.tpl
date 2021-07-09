<table align="center">
<tr>
<td>
<img src="/e-calypso/html/admin/tab6.gif" border="0" align="top" alt="" usemap="#tabs">
</td>
</tr>
</table>

<table cellspacing="2" cellpadding="2" border="1" align="center">

<tr>
<td>

<table cellspacing="2" cellpadding="2" border="0">
<tr>
    <td align="center" nowrap><input type="submit" name="capture" value="Capture" onClick="document.admin.adminAction.value='capture'; return true;">&nbsp;
<input type="submit" name="statementclear" value="Clear" onClick="document.admin.adminAction.value='statementclear'; return true;">&nbsp;&nbsp;&nbsp;Connections:&nbsp;
<select name="statcon">|SQL_STATEMENTS_CONNECTION|</select><input type="submit" name="statementrelease" value="Release Connection" onClick="document.admin.adminAction.value='statementrelease'; return true;"></td>
</tr>
<tr>
    <td align="center" nowrap><textarea cols="90" rows="20" name="statementarea" wrap="off">|SQL_STATEMENTS|</textarea></td>
</tr>
</table>
