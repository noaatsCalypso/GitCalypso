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
    <xsl:attribute name="padding">5px</xsl:attribute>
  </xsl:attribute-set>

  <xsl:template name="headerContent">

    <xsl:param
      name="withSubheader"
      select="'true'" />

    <fo:static-content flow-name="header">

      <!-- Header is organized as 4 column table, with logo as first -->
      <fo:table
        display-align="center"
        xsl:use-attribute-sets="header-font-style debug-table-format-style">
        <fo:table-body>
          <fo:table-row>
            <fo:table-cell xsl:use-attribute-sets="header-table-cell-style">
              <fo:block>
                <fo:external-graphic
                  width="75%"
                  content-height="75%"
                  content-width="scale-to-fit"
                  scaling="uniform"
                  src="url('classpath:com/calypso/templates/clearing/sample-logo.png')" />
              </fo:block>
            </fo:table-cell>

            <fo:table-cell xsl:use-attribute-sets="header-table-cell-style">
              <fo:block>
                Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod
                tempor
                incididunt ut labore et dolore magna aliqua.
              </fo:block>
            </fo:table-cell>

            <fo:table-cell xsl:use-attribute-sets="header-table-cell-style">
              <fo:block>
                Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod
                tempor
                incididunt ut labore et dolore magna aliqua.
              </fo:block>
            </fo:table-cell>

            <fo:table-cell xsl:use-attribute-sets="header-table-cell-style">
              <fo:block>
                Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod
                tempor
                incididunt ut labore et dolore magna aliqua.
              </fo:block>
            </fo:table-cell>

          </fo:table-row>
	      <xsl:if test="$withSubheader = 'true'">
	        <xsl:call-template name="subheader" />
	      </xsl:if>
        </fo:table-body>

      </fo:table>



    </fo:static-content>



  </xsl:template>

</xsl:stylesheet>