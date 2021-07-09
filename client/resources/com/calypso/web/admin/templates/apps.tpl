<table align="center">
<tr>
<td>
<img src="/e-calypso/html/admin/tab1.gif" border="0" align="top" alt="" usemap="#tabs">
</td>
</tr>
</table>


<table cellspacing="2" cellpadding="2" border="1" align="center">
<tr>
    <td>
<table cellspacing="2" cellpadding="2" border="0">
<tr>

<!--                            DATA SERVER BEGIN -->
    <td>
	<table cellspacing="2" cellpadding="2" border="0">
<tr>
    <td colspan="3"><strong><font size="+1">Data Server:</font></strong></td>
</tr>
<tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
    <td><input type="checkbox" name="dsrunning" |DS_RUNNING|>Running</td>
    <td>&nbsp;&nbsp;<input type="submit" name="dsreconnect" value="Reconnect" |DS_RECONNECT| onClick="document.admin.adminAction.value='dsreconnect'; return true;"></td>
</tr>
<tr>
    <td colspan="3">&nbsp;</td>
</tr>
<tr>
    <td></td>
    <td><input type="checkbox" name="dsaudit" |DS_AUDIT|>Audit</td>
    <td>&nbsp;&nbsp;<input type="checkbox" name="dsworkflow" |DS_WF|>Workflow</td>
</tr>
<tr>
    <td></td>
    <td><input type="checkbox" name="dsaccessperm" |DS_ACCPERM|>Access Perm</td>
    <td>&nbsp;&nbsp;<input type="checkbox" name="dsauth" |DS_AUTH|>Authorization</td>
</tr>
<tr>
    <td></td>
    <td><input type="checkbox" name="dssqltrace" |DS_TRACE|>SQL Trace</td>
    <td></td>
</tr>
<tr>
    <td></td>
    <td></td>
    <td>&nbsp;&nbsp;<input type="submit" name="dsrefresh" value="Refresh" onClick="document.admin.adminAction.value='dsrefresh'; return true;">
	    &nbsp;&nbsp;<input type="submit" name="dsapply" value="Apply" value="Refresh" onClick="document.admin.adminAction.value='dsapply'; return true;"></td>
</tr>
</table>
	</td>
<!--                               DATA SERVER END -->

</tr>
<tr>

<!--                                  MESSAGE BEGIN -->
    <td>
	<table cellspacing="2" cellpadding="2" border="0">
<tr>
    <td colspan=2><strong><font size="+1">Message:</font></strong></td>
</tr>
<tr>
    <td colspan=2><textarea cols="45" rows="8" name="message" wrap="off">|MESSAGE|</textarea></td>
</tr>
<tr>
    <td><input type="submit" name="send" value="Send Message" onClick="document.admin.adminAction.value='message'; return true;"></td>
    <td align="right"><input type="submit" name="stopall" value="Stop All" onClick="document.admin.adminAction.value='stopall'; return true;"></td>
</tr>
</table>

	</td>
<!--                                   MESSAGE END -->
</tr>
</table>
	</td>
	
    <td valign=top>
<table cellspacing="2" cellpadding="2" border="0">
<tr>
<!--                                   EVENT SERVER BEGIN -->
    <td>
		<table cellspacing="2" cellpadding="2" border="0">
<tr>
    <td colspan="3"><strong><font size="+1">Event Server:</font></strong></td>
</tr>
<tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
    <td><input type="checkbox" name="esrunning" |ES_RUNNING|>Running</td>
    <td>&nbsp;&nbsp;<input type="submit" name="esreconnect" value="Reconnect" |ES_RECONNECT| onClick="document.admin.adminAction.value='esreconnect'; return true;"></td>
</tr>

<tr>
    <td></td>
    <td></td>
    <td>&nbsp;&nbsp;<input type="submit" name="esstats" value="Stats..." onClick="document.admin.adminAction.value='esstats'; return true;"></td>
</tr>
<tr><td colspan=3>&nbsp;</td></tr>
<tr><td colspan=3>&nbsp;</td></tr>
</table>
	
	
	</td>
<!--                                   EVENT SERVER END -->
</tr>
<tr>
<!--                                   ENGINE BEGIN -->
    <td>
	
		<table cellspacing="2" cellpadding="2" border="0">
<tr>
    <td colspan=2><strong><font size="+1">Running Engines:</font></strong></td>
</tr>
<tr>
    <td colspan=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<select name="engines" size="12" width="200">
|ENGINES|
</select></td>
</tr>
<tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="submit" name="stopengine" value="Stop Engine" onClick="document.admin.adminAction.value='stopengine'; return true;"></td>
    <td align="right"><input type="submit" name="refreshengine" value="Refresh" onClick="document.admin.adminAction.value='refreshengine'; return true;"></td>
</tr>
</table>
	</td>
<!--                                   ENGINE END -->
</tr>
</table>	
	</td>
</tr>
</table>


