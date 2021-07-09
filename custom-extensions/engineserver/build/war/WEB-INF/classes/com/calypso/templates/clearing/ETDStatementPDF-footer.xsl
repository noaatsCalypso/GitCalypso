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

  <xsl:attribute-set name="footer-block-style">
    <xsl:attribute name="font-family">Helvetica, sans-serif</xsl:attribute>
    <xsl:attribute name="font-size">small</xsl:attribute>
    <xsl:attribute name="text-align">center</xsl:attribute>
  </xsl:attribute-set>

  <xsl:template name="footerContent">

    <fo:static-content flow-name="footer">
      <fo:block xsl:use-attribute-sets="footer-block-style">
        <fo:page-number />
        /
        <fo:page-number-citation-last ref-id="endMarker" />
      </fo:block>
    </fo:static-content>

  </xsl:template>

</xsl:stylesheet>