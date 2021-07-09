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

  <!-- SECURITIES ON DEPOSIT SECTION -->

  <xsl:key
    name="securitiesOnDepositKey"
    match="stmt:section[@id='securitiesOnDeposit']/stmt:row"
    use="@productId" />

  <xsl:template match="stmt:section[@id='securitiesOnDeposit']">
    <fo:block xsl:use-attribute-sets="section-block-style">

      <xsl:call-template name="sectionTitle">
        <xsl:with-param
          name="title"
          select="'Securities On Deposit'" />
      </xsl:call-template>

      <xsl:if test="boolean(stmt:row)">

        <fo:table xsl:use-attribute-sets="debug-table-format-style content-table-style">

          <!-- Description column -->
          <fo:table-column column-width="25%" />
          <!-- Origin column -->
          <fo:table-column />
          <!-- Nominal column -->
          <fo:table-column />
          <!-- Price column -->
          <fo:table-column  />
          <!-- Haircut column -->
          <fo:table-column column-width="5%" />
          <!-- Fair Market Value column -->
          <fo:table-column  />
          <!-- All-In Value column -->
          <fo:table-column  />
          <!-- Currency column -->
          <fo:table-column column-width="7%" />
          <!-- FX column -->
          <fo:table-column column-width="8%" />
          <!-- Base CCY Value column -->
          <fo:table-column column-width="10%" />
          
          <fo:table-header>
            <fo:table-row xsl:use-attribute-sets="content-table-header-row-style">
              <fo:table-cell xsl:use-attribute-sets="first-column-cell-style">
                <fo:block>Description</fo:block>
              </fo:table-cell>
              <fo:table-cell>
                <fo:block xsl:use-attribute-sets="quantity-block-style">Origin</fo:block>
              </fo:table-cell>
              <fo:table-cell>
                <fo:block xsl:use-attribute-sets="quantity-block-style">Nominal</fo:block>
              </fo:table-cell>
              <fo:table-cell>
                <fo:block xsl:use-attribute-sets="quantity-block-style">Price</fo:block>
              </fo:table-cell>
              <fo:table-cell>
                <fo:block xsl:use-attribute-sets="quantity-block-style">Haircut</fo:block>
              </fo:table-cell>
              <fo:table-cell>
                <fo:block xsl:use-attribute-sets="quantity-block-style">Fair Market Value</fo:block>
              </fo:table-cell>
              <fo:table-cell>
                <fo:block xsl:use-attribute-sets="quantity-block-style">All-In Value</fo:block>
              </fo:table-cell>
              <fo:table-cell xsl:use-attribute-sets="left-padded-column-cell-style">
                <fo:block>Ccy</fo:block>
              </fo:table-cell>
              <fo:table-cell >
                <fo:block>FX</fo:block>
              </fo:table-cell>
              <fo:table-cell>
                <fo:block xsl:use-attribute-sets="quantity-block-style">Base CCY Value</fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-header>

          <fo:table-body>
            <xsl:apply-templates
              select="stmt:row[generate-id() = generate-id(key('securitiesOnDepositKey', @productId)[1])]"
              mode="securitiesOnDeposit">
              <xsl:sort select="@description" />
              <xsl:sort select="@securityCurrency" />
              <xsl:sort select="@nominal" />
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
    mode="securitiesOnDeposit">

    <xsl:variable name="isEvenRow">
      <xsl:if test="(position() mod 2) = 0">
        <xsl:value-of select="'true'" />
      </xsl:if>
    </xsl:variable>

    <xsl:variable
      name="currentProductId"
      select="@productId" />

    <fo:table-row>
      <xsl:call-template name="contentRowAttributes">
        <xsl:with-param
          name="isEvenRow"
          select="$isEvenRow" />
      </xsl:call-template>
      <fo:table-cell xsl:use-attribute-sets="first-column-cell-style">
        <fo:block>
          <xsl:value-of select="@description" />
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block xsl:use-attribute-sets="quantity-block-style">
          <xsl:value-of select="@accountType" />
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block xsl:use-attribute-sets="quantity-block-style">
          <xsl:value-of
            select="stmtext:formatNumber(sum(../stmt:row[@productId = $currentProductId]/@nominal), @securityCurrency)" />
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block xsl:use-attribute-sets="quantity-block-style">
          <!-- Preformatted -->
          <xsl:value-of select="@price" />
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block xsl:use-attribute-sets="quantity-block-style">
          <!-- Preformatted -->
          <xsl:value-of select="concat(@haircut, '%')" />
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block xsl:use-attribute-sets="quantity-block-style">
          <xsl:value-of
            select="stmtext:formatNumber(sum(../stmt:row[@productId = $currentProductId]/@fairMarketValue), @securityCurrency)" />
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block xsl:use-attribute-sets="quantity-block-style">
          <xsl:value-of
            select="stmtext:formatNumber(sum(../stmt:row[@productId = $currentProductId]/@allInValue), @securityCurrency)" />
        </fo:block>
      </fo:table-cell>
      <fo:table-cell xsl:use-attribute-sets="left-padded-column-cell-style">
        <fo:block>
          <xsl:value-of select="@securityCurrency" />
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block>
          <xsl:value-of select="stmtext:formatFXRate(@fxRate, $statementCurrency, @securityCurrency)" />
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block xsl:use-attribute-sets="quantity-block-style">
          <xsl:value-of
            select="stmtext:formatNumber(sum(../stmt:row[@productId = $currentProductId]/@statementCurrencyValue), $statementCurrency)" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>

  </xsl:template>


</xsl:stylesheet>