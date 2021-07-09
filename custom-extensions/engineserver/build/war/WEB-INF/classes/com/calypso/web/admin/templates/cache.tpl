<table align="center">
<tr>
<td>
<img src="/e-calypso/html/admin/tab4.gif" border="0" align="top" alt="" usemap="#tabs">
</td>
</tr>
</table>

<table cellspacing="2" cellpadding="2" border="1" align="center">

<tr>
<td>

<table cellspacing="2" cellpadding="2" border="0" align="center">
<tr>
    <td align="center" nowrap><input type="submit" name="clearcache" value="Clear Clients Cache" onClick="document.admin.adminAction.value='cccache'; return true;">
&nbsp;<input type="checkbox" name="cleartimer" onClick="document.admin.adminAction.value='cleartimer'; document.admin.submit();" |CLEAR_TIMER|>Clear Timer&nbsp;
<input type="text" name="timer" value="|TIMER_DELAY|" size="5" |TIMER_ENABLE|>&nbsp;Sec.
</td>
</tr>
<tr>
    <td align="center">|LIMIT_TABLE|</td>
</tr>
<tr>
    <td align="center">Limit:&nbsp;<select name="setlimit">|LIMIT_SELECT|</select>&nbsp;<input type="text" name="limittext" size="5">&nbsp;<input type="submit" name="applylimit" value="Apply" onClick="document.admin.adminAction.value='applylimit'; return true;"></td>
</tr>
<tr>
    <td align="center" nowrap><input type="submit" name="savelimits" value="Save Limits" onClick="document.admin.adminAction.value='savelimits'; return true;">&nbsp;
<input type="submit" name="refreshlimits" value="Refresh Limits" onClick="document.admin.adminAction.value='refreshlimits'; return true;"></td>
</tr>
</table>

</td>
</tr>

</table>