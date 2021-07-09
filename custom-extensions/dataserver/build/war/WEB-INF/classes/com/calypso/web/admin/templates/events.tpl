<table align="center">
<tr>
<td>
<img src="/e-calypso/html/admin/tab2.gif" border="0" align="top" alt="" usemap="#tabs">
</td>
</tr>
</table>


<table cellspacing="2" cellpadding="2" border="1" align="center">
<tr>
    <td>
	
<table cellspacing="2" cellpadding="2" border="0">
<tr>
    <td colspan=2><strong><font size="+1">Event Class:</font></strong></td>
</tr>
<tr>
    <td colspan=2><select name="eventClass" size="15" multiple>
|EVENT_CLASS|
</select></td>
</tr>
<tr>
    <td><input type="submit" name="subscribe" value="Subscribe" onClick="document.admin.adminAction.value='eventsSubscribe'; return true;"></td>
    <td><input type="submit" name="unsubscribe" value="UnSubscribe" onClick="document.admin.adminAction.value='eventsUnSubscribe'; return true;"></td>
</tr>
</table>

	
	</td>
	
	
	
    <td valign="top">
<table cellspacing="2" cellpadding="2" border="0">
<tr>
    <td colspan=2><strong><font size="+1">Events:</font></strong></td>
</tr>
<tr>
    <td colspan=2><textarea cols="60" rows="20" name="events" wrap="off">|EVENTS|</textarea></td>
</tr>
<tr>
    <td><input type="submit" name="clear" value="Clear" onClick="document.admin.events.value=''; return false;"></td>
	<td align="right"><input type="submit" name="refresh" value="Refresh"onClick="document.admin.adminAction.value='eventsRefresh'; return true;"></td>
</tr>
</table>
	
	
	
	</td>
</tr>
</table>

