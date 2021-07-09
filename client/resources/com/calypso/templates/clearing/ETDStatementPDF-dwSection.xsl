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

  <!-- DEPOSITS and WITHDRAWALS SECTION -->


  <xsl:template match="stmt:section[@id='depositsAndWithdrawals']">
    <fo:block xsl:use-attribute-sets="section-block-style">

      <xsl:call-template name="sectionTitle">
        <xsl:with-param
          name="title"
          select="'Deposits And Withdrawals'" />
      </xsl:call-template>

      <xsl:if test="boolean(stmt:row)">

        <fo:table xsl:use-attribute-sets="debug-table-format-style content-table-style">

          <!-- Settlement Date column -->
          <fo:table-column />
          <!-- ID column -->
          <fo:table-column column-width="8%" />
          <!-- Origin column -->
          <fo:table-column />
          <!-- Transaction Type column -->
          <fo:table-column />
          <!-- Amount column -->
          <fo:table-column column-width="10%" />
          <!-- Currency column -->
          <fo:table-column column-width="7%" />
          <!-- Description column -->
          <fo:table-column column-width="20%" />
          <!-- Comment column -->
          <fo:table-column column-width="25%" />

          <fo:table-header>
            <fo:table-row xsl:use-attribute-sets="content-table-header-row-style">
              <fo:table-cell xsl:use-attribute-sets="first-column-cell-style">
                <fo:block>Settlement Date</fo:block>
              </fo:table-cell>
              <fo:table-cell>
                <fo:block>ID</fo:block>
              </fo:table-cell>
              <fo:table-cell>
                <fo:block>Origin</fo:block>
              </fo:table-cell>
              <fo:table-cell>
                <fo:block>Transaction Type</fo:block>
              </fo:table-cell>
              <fo:table-cell>
                <fo:block xsl:use-attribute-sets="quantity-block-style">Amount</fo:block>
              </fo:table-cell>
              <fo:table-cell xsl:use-attribute-sets="left-padded-column-cell-style">
                <fo:block>Ccy</fo:block>
              </fo:table-cell>
              <fo:table-cell>
                <fo:block>Description</fo:block>
              </fo:table-cell>
              <fo:table-cell xsl:use-attribute-sets="last-column-cell-style">
                <fo:block>Comment</fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-header>

          <fo:table-body>
            <xsl:apply-templates
              select="stmt:row"
              mode="depositsAndWithdrawalsRow">
              <xsl:sort select="@settlementDate" />
              <xsl:sort
                select="@cashOrSecurity"
                order="descending" />
              <xsl:sort select="@currency" />
              <xsl:sort select="@direction" />
              <xsl:sort select="@description" />
            </xsl:apply-templates>
          </fo:table-body>

        </fo:table>
      </xsl:if>

      <xsl:call-template name="emptySectionComment">
        <xsl:with-param
          name="content"
          select="stmt:row" />
      </xsl:call-template>

    </fo:block>

  </xsl:template>

  <xsl:template
    match="stmt:row"
    mode="depositsAndWithdrawalsRow">

    <xsl:variable name="isEvenRow">
      <xsl:if test="(position() mod 2) = 0">
        <xsl:value-of select="'true'" />
      </xsl:if>
    </xsl:variable>

    <fo:table-row>
      <xsl:call-template name="contentRowAttributes">
        <xsl:with-param
          name="isEvenRow"
          select="$isEvenRow" />
      </xsl:call-template>
      <fo:table-cell xsl:use-attribute-sets="first-column-cell-style">
        <fo:block>
          <xsl:value-of select="@settlementDate" />
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block>
          <xsl:value-of select="@id" />
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block>
          <xsl:value-of select="@accountType" />
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block>
          <xsl:value-of select="concat(@cashOrSecurity, ' ', @direction)" />
        </fo:block>
      </fo:table-cell>

      <fo:table-cell xsl:use-attribute-sets="right-align-block-style">
        <fo:block>
          <xsl:choose>
            <xsl:when test="@cashOrSecurity = 'SECURITY'">
              <xsl:value-of select="stmtext:formatNumber(@amount, 0)" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="stmtext:formatNumber(@amount, @currency)" />
            </xsl:otherwise>
          </xsl:choose>
        </fo:block>
      </fo:table-cell>

      <fo:table-cell xsl:use-attribute-sets="left-padded-column-cell-style">
        <fo:block>
          <xsl:value-of select="@currency" />
        </fo:block>
      </fo:table-cell>

      <fo:table-cell>
        <fo:block>
          <xsl:if test="@description != @currency">
            <xsl:value-of select="@description" />
          </xsl:if>
        </fo:block>
      </fo:table-cell>

      <fo:table-cell xsl:use-attribute-sets="last-column-cell-style">
        <fo:block>
          <xsl:value-of select="@comment" />
        </fo:block>
      </fo:table-cell>

    </fo:table-row>

  </xsl:template>


</xsl:stylesheet>