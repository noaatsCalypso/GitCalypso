<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  version="1.0"
  xmlns:stmt="urn:com:calypso:clearing:statement:etd"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:stmtext="xalan://com.calypso.tk.bo.StatementDataTypeFormatter"
  extension-element-prefixes="stmtext"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  exclude-result-prefixes="xs fo stmtext">
  
  <xsl:variable name="textSeparator" select="' &#8212; '" />

  <xsl:attribute-set name="subheader-block-container-style">
    <xsl:attribute name="margin-top">3mm</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="subheader-block-style">
    <xsl:attribute name="display-align">center</xsl:attribute>
    <xsl:attribute name="text-align">right</xsl:attribute>
    <xsl:attribute name="font-size">0.9em</xsl:attribute>    
  </xsl:attribute-set>

  <xsl:template name="subheader">

    <xsl:variable name="receiver">
      <xsl:call-template name="leReceiverName" />
    </xsl:variable>
    <xsl:variable name="accountName">
      <xsl:value-of select="//stmt:section[@id = 'metadata']/@accountName" />
    </xsl:variable>
    <xsl:variable name="date">
      <xsl:value-of select="//stmt:section[@id = 'metadata']/@statementDate" />
    </xsl:variable>

    <!-- fo:block-container xsl:use-attribute-sets="subheader-block-container-style" -->
	<fo:table-row>
		<fo:table-cell xsl:use-attribute-sets="header-table-cell-style"
		number-columns-spanned="4">
	      <fo:block xsl:use-attribute-sets="subheader-block-style">
	        <xsl:value-of select="concat($receiver, $textSeparator, $accountName, $textSeparator, $date)" />
	   	  </fo:block>
	   </fo:table-cell>
	</fo:table-row>
    <!-- /fo:block-container -->

  </xsl:template>

</xsl:stylesheet>