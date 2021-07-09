<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>Engine Processing</title>
<style>
TABLE {
	BORDER-BOTTOM-WIDTH: 0px; BORDER-LEFT-WIDTH: 0px; BORDER-RIGHT-WIDTH: 0px; BORDER-TOP-WIDTH: 0px; COLOR: #000000; FONT-FAMILY: Arial, Helvetica, sans-serif; FONT-SIZE: 10pt; MARGIN: 0px; PADDING-BOTTOM: 0px; PADDING-LEFT: 0px; PADDING-RIGHT: 0px; PADDING-TOP: 0px
;}
TD {
	COLOR: #000000; FONT-FAMILY: Arial, Helvetica, 
sans-serif; FONT-SIZE: 8pt
;}
TR {
	COLOR: #000000; FONT-FAMILY: Arial, Helvetica, sans-serif; FONT-SIZE: 8pt
;}
	</style>
<script LANGUAGE="JavaScript" TYPE="text/javascript">
function init() { 
|INIT_SCRIPT|
}
</script>
</head>

<body onload="init();">
<form name="stat" action="/servlet/com.calypso.web.admin.EngineProcessing">
<table cellspacing="2" cellpadding="2" border="0">
<tr>
    <td colspan="2" nowrap><strong><font size="+1">|TITLE|</font></strong></td>
</tr>
<tr>
    <td colspan="2">|TABLE|</td>
</tr>
<tr>
    <td><input type="button" name="refresh"  value="Refresh" onClick='document.stat.submit();'></td>
    <td align="right"><input type="button" name="Close"  value="Close" onClick='window.close();'></td>
</tr>
</table>
</form>



</body>
</html>
