<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
	<title>|TITLE|</title>
</head>

<body>
<SCRIPT LANGUAGE="javascript">
function setOpener(){
	window.opener.document.log.category.value = window.document.selCategory.oldselcategory.value;
	window.close();
	}
</SCRIPT>
<TABLE>
<form name = "selCategory" action="/servlet/com.calypso.web.admin.|SERVLET|">
<TR>
	<TD><SELECT NAME="allcategory" size="10" multiple>
	|ALLCATEGORIES|
	</SELECT></TD>
	<TD align="center"><TABLE>
	<TR>
		<TD><INPUT TYPE="submit" name="submit" value = ">>"></TD>
	</TR>
	<TR>
		<TD><INPUT TYPE="submit" name="submit" value = "<<"></TD>
	</TR>
	</TABLE></TD>	
	<TD><SELECT NAME="selcategory" size="10" multiple>
	|SELCATEGORIES|
	</SELECT></TD>
</TR>
<TR>
	<TD COLSPAN="3" ALIGN="center"><INPUT TYPE="button" name = "button" value =  "Close"  onClick='setOpener();'></TD>
</TR>
</TABLE>
<INPUT TYPE="HIDDEN" name="oldallcategory" value = "|JUSTALLCATS|">
<INPUT TYPE="HIDDEN" name="oldselcategory" value = "|JUSTSELCATS|">
<INPUT TYPE="HIDDEN" name="appl" value = "|APP|">
</form>
</body>
</html>