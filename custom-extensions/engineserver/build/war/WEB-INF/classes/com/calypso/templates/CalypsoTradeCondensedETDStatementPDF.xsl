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

  <xsl:import href="classpath:com/calypso/templates/clearing/ETDStatementPDF-lastPage.xsl" />
  <xsl:import href="classpath:com/calypso/templates/clearing/ETDStatementPDF-header.xsl" />
  <xsl:import href="classpath:com/calypso/templates/clearing/ETDStatementPDF-footer.xsl" />
  <xsl:import href="classpath:com/calypso/templates/clearing/ETDStatementPDF-common.xsl" />

  <xsl:include href="classpath:com/calypso/templates/clearing/ETDStatementPDF-accountSection.xsl" />
  <xsl:include href="classpath:com/calypso/templates/clearing/ETDStatementPDF-tcSection.xsl" />

  <xsl:attribute-set name="section-block-style">
    <!-- Prevent the page break between account info and trade confirmations -->
    <xsl:attribute name="page-break-before">auto</xsl:attribute>
    <xsl:attribute name="margin-top">7mm</xsl:attribute>
  </xsl:attribute-set>

</xsl:stylesheet>