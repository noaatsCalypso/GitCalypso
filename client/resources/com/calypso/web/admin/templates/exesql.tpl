<table align="center">
<tr>
<td>
<img src="/e-calypso/html/admin/tab7.gif" border="0" align="top" alt="" usemap="#tabs">
</td>
</tr>
</table>

<table cellspacing="2" cellpadding="2" border="1" align="center">

<tr>
<td>

<table cellspacing="2" cellpadding="2" border="0">
<tr>
    <td align="left" nowrap>
<table cellspacing="2" cellpadding="2" border="0">
<tr>
  <td>Templates:</td>
  <td><select name="exesqltmpl">|SQL_EXECUTE_TEMPLATES|</select></td>
  <td><input type="submit" name="exesqlselect" value="Load" onClick="document.admin.adminAction.value='exesqlselect'; return true;">
  <input type="submit" name="exesqlremove" value="Remove" onClick="document.admin.adminAction.value='exesqlremove'; return true;"></td>
  </td>
</tr>
<tr>
  <td></td>
  <td><input type="text" name="exesqltmplvalue" size="25" value="|SQL_EXECUTE_TMPLT|"></td>
  <td><input type="submit" name="exesqlsave" value="Save" onClick="document.admin.adminAction.value='exesqlsave'; return true;"></td>
</tr>
</table>
</td>
</tr>
<tr>
    <td align="left" nowrap><textarea cols="70" rows="5" name="exesqlcmd" wrap="off">|SQL_EXECUTE_COMMAND|</textarea></td>
</tr>
<tr>
    <td align="left" nowrap><input type="submit" name="exesqlclear" value="Clear" onClick="document.admin.adminAction.value='exesqlclear'; return true;">
	<input type="submit" name="exesqlexecute" value="Execute" onClick="document.admin.adminAction.value='exesqlexecute'; return true;">
	&nbsp;&nbsp;Count:&nbsp;|SQL_EXECUTE_COUNT|
	</td>
</tr>
<tr>
    <td align="center" nowrap>|SQL_EXECUTE_RESULT|</td>
</tr>
</table>
