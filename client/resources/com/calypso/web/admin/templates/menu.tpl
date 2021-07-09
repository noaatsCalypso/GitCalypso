<html>
<head>
<meta http-equiv='Expires' content='-10'>
<meta http-equiv='Pragma'  content='No-cache'>
<meta http-equiv='Cache-Control', 'private'>
<title>Admin</title>
<style>
TEXTAREA {
  FONT-FAMILY: Arial, Helvetica, sans-serif; FONT-SIZE: 8pt;
}
</style>

<script language="javascript" src="/e-calypso/html/util/menu.js"></script>
<script LANGUAGE="JavaScript" TYPE="text/javascript">
Layer[1] = new LayerSpecs(335,15,65,'' ,
      '<A onClick=document.admin.action.value="aperm" HREF=javascript:eval("document.admin.submit();")><B>Access&nbsp;Permission...</B></A>',
      '<A onClick=document.admin.action.value="logout" HREF=javascript:eval("document.admin.submit();")><B>Log&nbsp;out</B></A>');
Layer[2] = new LayerSpecs(415,15,65,'' ,
      '<A onClick=document.admin.action.value="mem" HREF=javascript:eval("document.admin.submit();")><B>Memory</B></A>',
      '<A onClick=document.admin.action.value="gc" HREF=javascript:eval("document.admin.submit();")><B>Call&nbsp;GC</B></A>',
      '<A onClick=document.admin.action.value="ti" HREF=javascript:eval("document.admin.submit();")><B>Server&nbsp;Time</B></A>',
      '<A onClick=document.admin.action.value="lo" HREF=javascript:eval("document.admin.submit();")><B>Display&nbsp;Log</B></A>',
      '<A onClick=document.admin.action.value="db" HREF=javascript:eval("document.admin.submit();")><B>DB&nbsp;Connections&nbsp;Count</B></A>',
      '<A onClick=document.admin.action.value="cc" HREF=javascript:eval("document.admin.submit();")><B>Show&nbsp;Connected&nbsp;Clients</B></A>',
      '<A onClick=document.admin.action.value="rs" HREF=javascript:eval("document.admin.submit();")><B>Restart&nbsp;Log</B></A>',
      '<A onClick=document.admin.action.value="op" HREF=javascript:eval("document.admin.submit();")><B>Display&nbsp;Options...</B></A>',
      '<A onClick=document.admin.action.value="ts" HREF=javascript:eval("document.admin.submit();")><B>Task&nbsp;Stats...</B></A>',
	'<A onClick=document.admin.action.value="conflogds" HREF=javascript:eval("document.admin.submit();")><B>Configure&nbsp;DSLog</B></A>',
	'<A onClick=document.admin.action.value="confloges" HREF=javascript:eval("document.admin.submit();")><B>Configure&nbsp;ESLog</B></A>');
Layer[3] = new LayerSpecs(335,30,65,'',
      '<A onClick=document.admin.action.value="pdb" HREF=javascript:eval("document.admin.submit();")><B>Purge&nbsp;DB&nbsp;Connections</B></A>',
      '<A onClick=document.admin.action.value="pct" HREF=javascript:eval("document.admin.submit();")><B>Purge&nbsp;Completed&nbsp;Tasks</B></A>',
      '<A onClick=document.admin.action.value="pce" HREF=javascript:eval("document.admin.submit();")><B>Purge&nbsp;Consumed&nbsp;Events</B></A>',
      '<A onClick=document.admin.action.value="pmd" HREF=javascript:eval("document.admin.submit();")><B>Purge&nbsp;Market&nbsp;Data</B></A>',
      '<A onClick=document.admin.action.value="plf" HREF=javascript:eval("document.admin.submit();")><B>Purge&nbsp;Log&nbsp;Files</B></A>');
Layer[4] = new LayerSpecs(415,30,65,'' ,
      '<A onClick=document.admin.action.value="emem" HREF=javascript:eval("document.admin.submit();")><B>Memory</B></A>' ,
      '<A onClick=document.admin.action.value="elog" HREF=javascript:eval("document.admin.submit();")><B>Display&nbsp;Log</B></A>' ,
      '<A onClick=document.admin.action.value="erlog" HREF=javascript:eval("document.admin.submit();")><B>Restart&nbsp;Log</B></A>' ,
      '<A onClick=document.admin.action.value="conelog" HREF=javascript:eval("document.admin.submit();")><B>Configure&nbsp;Log</B></A>' ,
      '<A onClick=document.admin.action.value="erst" HREF=javascript:eval("document.admin.submit();")><B>Restart</B></A>' ,
      '<A onClick=document.admin.action.value="east" HREF=javascript:eval("document.admin.submit();")><B>All&nbsp;Engines&nbsp;Stats</B></A>' ,
      '<A onClick=document.admin.action.value="estop" HREF=javascript:eval("document.admin.submit();")><B>Stop</B></A>');
Layer[5] = new LayerSpecs(335,45,65,'' ,
      '<A onClick=document.admin.action.value="ctc" HREF=javascript:eval("document.admin.submit();")><B>Clear&nbsp;Trade&nbsp;Cache</B></A>',
      '<A onClick=document.admin.action.value="csdc" HREF=javascript:eval("document.admin.submit();")><B>Clear&nbsp;Static&nbsp;Data&nbsp;Cache</B></A>',
      '<A onClick=document.admin.action.value="cmc" HREF=javascript:eval("document.admin.submit();")><B>Clear&nbsp;MarketData&nbsp;Cache</B></A>',
      '<A onClick=document.admin.action.value="cboc" HREF=javascript:eval("document.admin.submit();")><B>Clear&nbsp;Back&nbsp;Office&nbsp;Cache</B></A>',
      '<A onClick=document.admin.action.value="ccc" HREF=javascript:eval("document.admin.submit();")><B>Clear&nbsp;Clients&nbsp;Cache</B></A>');	
Layer[6] = new LayerSpecs(400,30,65,'' ,'');

var jRefreshInterval = null;

function startRefreshCountdown() {  
   jRefreshInterval = window.setInterval("document.admin.submit();",10000);
   document.images['AutoRefresh'].src='/e-calypso/html/admin/auto_refresh.gif';
}

function cancelRefresh() {
  if (jRefreshInterval != null) {
     window.clearInterval(jRefreshInterval);
     document.images['Refresh'].src='/e-calypso/html/admin/refresh.gif';
     window.location.replace('/servlet/com.calypso.web.admin.Admin?autoRefresh=0');
  }
}

function init() { 
|AUTO_REFRESH|
|INIT_SCRIPT|
}
</script>

<!-- Arial, Helvetica, sans-serif; -->

<style type="text/css">
  td      { font : bold 12px Default; }
  A       { text-decoration: none; color : Black; }
  A:HOVER { text-decoration: none; color : Blue; }
</style>
</head>
<body background="/e-calypso/html/util/images/background.jpg" onload="init();">
<form name="admin" action="/servlet/com.calypso.web.admin.Admin" method='post'>
<table border="0" cellspacing="0" cellpadding="0">
<tr>
<td ><img src="/e-calypso/html/util/images/logoSmall.gif" border="0" alt=""></td>
<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
<td><a href='/servlet/com.calypso.web.admin.Admin|AUTO_OFF_ON|'><img name='AutoRefresh' src="/e-calypso/html/admin/refresh.gif" border="0" alt="" title='Page is refreshing every 10 seconds - click to stop.'></a></td>
<td>&nbsp;&nbsp;</td>

<td>
  <table cellspacing="0" cellpadding="0"  border="0">
  <tr><TD align="right">&nbsp;<a href="javascript:void(0);" onMouseOver='Show(1)' 
onMouseOut='Hide(1)'>Admin</a>&nbsp;</TD><td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
  <TD>&nbsp;<a href="javascript:void(0);" onMouseOver='Show(2)' 
onMouseOut='Hide(2)'>Data Server</a>&nbsp;</TD></TR>
  <TR><TD align="right">&nbsp;<a href="javascript:void(0);" onMouseOver='Show(3)' 
onMouseOut='Hide(3)'>Purge</a>&nbsp;</TD><td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
  <TD>&nbsp;<a href="javascript:void(0);" onMouseOver='Show(4)' 
onMouseOut='Hide(4)'>Engines</a>&nbsp;</TD></TR>
  <TR><TD align="right">&nbsp;<a href="javascript:void(0);" onMouseOver='Show(5)' 
onMouseOut='Hide(5)'>Clear Cache</a>&nbsp;</TD>
<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
  <TD >&nbsp;<a href="javascript:void(0);" onMouseOver='Show(6)' 
onMouseOut='Hide(6)'>Help</a>&nbsp;</TD></TR></TABLE>
</td>

</tr>
<tr><td colspan=5>&nbsp;</td>
</tr>	

<tr>
<td colspan=5 align="center"><em>&nbsp;|CALYPSO_INFO|&nbsp;<em></td>
</tr>

<tr><td colspan=5>&nbsp;</td>

</table>
<script LANGUAGE="JavaScript">
  writeMenu();
</script>

