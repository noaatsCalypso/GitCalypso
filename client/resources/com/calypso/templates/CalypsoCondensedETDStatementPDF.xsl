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
  <xsl:include href="classpath:com/calypso/templates/clearing/ETDStatementPDF-fcaSection.xsl" />
  <xsl:include href="classpath:com/calypso/templates/clearing/ETDStatementPDF-psSection.xsl" />
  <xsl:include href="classpath:com/calypso/templates/clearing/ETDStatementPDF-laSection.xsl" />
  <xsl:include href="classpath:com/calypso/templates/clearing/ETDStatementPDF-opSection.xsl" />
  <xsl:include href="classpath:com/calypso/templates/clearing/ETDStatementPDF-cpSection.xsl" />
  <xsl:include href="classpath:com/calypso/templates/clearing/ETDStatementPDF-dwSection.xsl" />
  <xsl:include href="classpath:com/calypso/templates/clearing/ETDStatementPDF-sdSection.xsl" />
  <xsl:include href="classpath:com/calypso/templates/clearing/ETDStatementPDF-finsumSection.xsl" />

</xsl:stylesheet>