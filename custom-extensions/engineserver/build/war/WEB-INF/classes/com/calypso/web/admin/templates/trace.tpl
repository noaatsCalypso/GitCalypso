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
    <td align="center" nowrap><input type="submit" name="traceclear" value="Clear" onClick="document.admin.adminAction.value='traceclear'; return true;">&nbsp;
<input type="checkbox" name="traceshow" value="" onClick="document.admin.adminAction.value='traceshow'; document.admin.submit();" |SHOW_TRACE|>Show trace&nbsp;<input type="submit" name="tracerefresh" value="Refresh" onClick="document.admin.adminAction.value='tracerefresh'; return true;"></td>
</tr>
<tr>
    <td align="center" nowrap><textarea cols="90" rows="20" name="tracearea" wrap="off">|TRACE_AREA|</textarea></td>
</tr>
</table>
