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

  <!-- This is a copy of CalypsoCondensedETDStatementPDF.xsl, intended to showcase the customization of header, 
    last page, and other elements. It is not intended to be used in production -->

  <xsl:import href="classpath:com/calypso/templates/clearing/sample/ETDStatementPDF-lastPage-sample.xsl" />
  <xsl:import href="classpath:com/calypso/templates/clearing/sample/ETDStatementPDF-header-sample.xsl" />
  <xsl:import href="classpath:com/calypso/templates/clearing/sample/ETDStatementPDF-footer-sample.xsl" />

  <xsl:import href="classpath:com/calypso/templates/clearing/ETDStatementPDF-common.xsl" />

  <xsl:include href="classpath:com/calypso/templates/clearing/ETDStatementPDF-accountSection.xsl" />
  <xsl:include href="classpath:com/calypso/templates/clearing/ETDStatementPDF-tcSection.xsl" />
  <xsl:include href="classpath:com/calypso/templates/clearing/ETDStatementPDF-fcaSection.xsl" />
  <xsl:include href="classpath:com/calypso/templates/clearing/ETDStatementPDF-psSection.xsl" />
  <xsl:include href="classpath:com/calypso/templates/clearing/ETDStatementPDF-laSection.xsl" />
  <xsl:include href="classpath:com/calypso/templates/clearing/ETDStatementPDF-opSection.xsl" />
  <xsl:include href="classpath:com/calypso/templates/clearing/ETDStatementPDF-cpSection.xsl" />
  <xsl:include href="classpath:com/calypso/templates/clearing/ETDStatementPDF-dwSection.xsl" />
  
  <!-- Hide a section by commenting it out -->
  <!-- <xsl:include href="classpath:com/calypso/templates/clearing/ETDStatementPDF-sdSection.xsl" /> -->

  <xsl:include href="classpath:com/calypso/templates/clearing/ETDStatementPDF-finsumSection.xsl" />


  <!-- Reduce the amount of space before the page body, to bring it closer to the header -->
  <xsl:attribute-set name="region-body-style">
    <xsl:attribute name="space-before">35mm</xsl:attribute>
    <xsl:attribute name="space-after">5mm</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="subheader-block-container-style">
    <xsl:attribute name="margin-top">7mm</xsl:attribute>
  </xsl:attribute-set>
  
  <!-- Reduce the number of finsum currency columns per page (default is 6, including the base one) -->
  <xsl:variable name="finsumPageSize">
    <xsl:value-of select="number(5)" />
  </xsl:variable>
  
  <xsl:variable
    name="useExtendedFuture32"
    select="true()" />

</xsl:stylesheet>