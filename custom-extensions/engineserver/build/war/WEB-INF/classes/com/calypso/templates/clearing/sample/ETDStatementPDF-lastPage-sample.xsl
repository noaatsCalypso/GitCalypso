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

  <xsl:attribute-set name="disclaimer-text-style">
    <xsl:attribute name="font-family">Helvetica, sans-serif</xsl:attribute>
    <xsl:attribute name="font-style">italic</xsl:attribute>
    <xsl:attribute name="text-align">justify</xsl:attribute>
  </xsl:attribute-set>

  <xsl:template name="lastPageBodyContent">

    <fo:block
      xsl:use-attribute-sets="disclaimer-text-style"
      color="#1A237E"
      font-size="13pt"
      font-weight="bold"
      border-bottom-color="#1A237E"
      border-bottom-style="solid">
      DISCLAIMER
    </fo:block>

    <fo:block
      xsl:use-attribute-sets="disclaimer-text-style"
      space-before="9pt">
      This is a copy of the OOTB statement, intended to showcase some common customizations. It
      is not
      intended to be used in production as-is.
    </fo:block>

    <fo:block
      xsl:use-attribute-sets="disclaimer-text-style"
      space-before="9pt">
      The technology used to described the output format is XSL-FO. More information available in
      <fo:basic-link
        external-destination="url('https://www.w3.org/TR/xsl11/')"
        color="blue"
        text-decoration="underline">https://www.w3.org/TR/xsl11/</fo:basic-link>
    </fo:block>

  </xsl:template>

</xsl:stylesheet>