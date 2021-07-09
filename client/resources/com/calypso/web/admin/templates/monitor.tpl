<table align="center">
<tr>
<td>
<img src="/e-calypso/html/admin/tab8.gif" border="0" align="top" alt="" usemap="#tabs">
</td>
</tr>
</table>

<table cellspacing="2" cellpadding="2" border="1" align="center">

<tr>
<td>

<table cellspacing="2" cellpadding="2" border="0" align="center">
<tr>
    <td align="center" nowrap><input type="submit" name="monitrefresh" value="Refresh" onClick="document.admin.adminAction.value='monitrefresh'; return true;">
&nbsp;<input type="checkbox" name="monitauto" onClick="document.admin.adminAction.value='monitauto'; document.admin.submit();" |MONIT_AUTO|>Auto Refresh
</td>
</tr>
<tr>
    <td align="center">
	<TABLE align="center" BORDER=0>
	<TR>
		<TD align="center" VALIGN="TOP">|USER_CONNECTED_TABLE|</TD>
		<TD align="center" VALIGN="TOP">|DB_CONNECTION_TABLE|</TD>
	</TR>
	<TR>
		<TD align="center" COLSPAN=2>
		|MONIT_TABLE|
		</TD>
	</TR>
	</TABLE>
</td>	
</tr>
</table>

</td>
</tr>

</table>