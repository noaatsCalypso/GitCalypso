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
  
  <xsl:import href="classpath:com/calypso/templates/clearing/ETDStatementPDF-subheader.xsl" />

  <xsl:attribute-set name="header-font-style">
    <xsl:attribute name="font-family">Helvetica, sans-serif</xsl:attribute>
    <xsl:attribute name="font-size">small</xsl:attribute>
    <xsl:attribute name="text-align">justify</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="header-table-cell-style">
    <!-- Custom paddings -->
    <xsl:attribute name="padding-left">5px</xsl:attribute>
    <xsl:attribute name="padding-right">5px</xsl:attribute>
    <xsl:attribute name="padding-top">1px</xsl:attribute>
    
    <!-- Uncomment this attribute to debug positioning and margin issues -->
<!--     <xsl:attribute name="border">1px red solid</xsl:attribute> -->
  </xsl:attribute-set>

  <xsl:template name="headerContent">
  
    <xsl:param name="withSubheader" select="'true'" />

    <fo:static-content flow-name="header">

      <fo:table xsl:use-attribute-sets="header-font-style debug-table-format-style">
        <fo:table-body>
          <fo:table-row>
            <!-- cell display-align and text-align control block positioning -->
            <fo:table-cell
              xsl:use-attribute-sets="header-table-cell-style"
              display-align="center"
              text-align="center"
              border-right-style="solid"
              border-right-width="2px"
              border-right-color="#1A237E">
              <fo:block>
                <fo:external-graphic
                  width="80%"
                  content-height="80%"
                  content-width="scale-to-fit"
                  scaling="uniform"
                  src="url('classpath:com/calypso/templates/clearing/sample/calypso-logo.png')" />
              </fo:block>
            </fo:table-cell>

            <!-- font attributes to control the size, weight, and family -->
            <!-- font family can be overriden per cell/block -->
            <fo:table-cell
              xsl:use-attribute-sets="header-table-cell-style"
              display-align="after"
              font-size="1.25em"
              font-weight="bold"
              font-family="Times, serif">
              <fo:block>Calypso Technology</fo:block>
              <fo:block>Clearing</fo:block>
            </fo:table-cell>

            <fo:table-cell xsl:use-attribute-sets="header-table-cell-style">
              <!-- font attributes on selected blocks -->
              <fo:block>595 Market Street, Suite 1800</fo:block>
              <fo:block>San Francisco, CA 94105</fo:block>
              <fo:block>USA</fo:block>
              <fo:block
                font-style="italic"
                font-weight="bold">T +1 415 530 4000</fo:block>
              <fo:block
                font-style="italic"
                font-weight="bold">F +1 415 284 1222</fo:block>
            </fo:table-cell>

            <fo:table-cell xsl:use-attribute-sets="header-table-cell-style">
              <fo:block>One New Change, Level 6</fo:block>
              <fo:block>London EC4M 9AF</fo:block>
              <fo:block>United Kingdom</fo:block>
              <fo:block
                font-style="italic"
                font-weight="bold">T +44 20 3743 1000</fo:block>
            </fo:table-cell>
            
          </fo:table-row>
          
        </fo:table-body>
        
      </fo:table>
      
      <xsl:if test="$withSubheader = 'true'">
        <xsl:call-template name="subheader" />
      </xsl:if>

    </fo:static-content>

  </xsl:template>

</xsl:stylesheet>