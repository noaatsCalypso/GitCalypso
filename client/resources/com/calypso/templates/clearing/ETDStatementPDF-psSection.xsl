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

  <!-- PURCHASES and SALES SECTION -->

  <xsl:key
    name="liquidationRowKey"
    match="stmt:section[@id='purchasesAndSales']/stmt:section/stmt:row"
    use="concat(@account, @exchange, @contractDescription, ../@id)" />

  <xsl:template match="stmt:section[@id='purchasesAndSales']">
    <fo:block xsl:use-attribute-sets="section-block-style">

      <xsl:call-template name="sectionTitle">
        <xsl:with-param
          name="title"
          select="'Purchases And Sales'" />
      </xsl:call-template>

      <xsl:apply-templates select="stmt:section">
        <xsl:sort select="@order" />
      </xsl:apply-templates>

    </fo:block>

    <xsl:call-template name="emptySectionComment">
      <xsl:with-param
        name="content"
        select="stmt:section" />
    </xsl:call-template>

  </xsl:template>

  <xsl:template match="stmt:section[@id='purchasesAndSales']/stmt:section">

    <xsl:call-template name="sectionSubtitle">
      <xsl:with-param
        name="subtitle"
        select="concat(@id, ' Offsets')" />
    </xsl:call-template>

    <fo:table xsl:use-attribute-sets="debug-table-format-style content-table-style">

			<xsl:if test="$statementType = 'PARENT'">
	          <!-- Account column -->
	          <fo:table-column column-width="6%" />
		    </xsl:if>
      <!-- 1st ID column -->
      <fo:table-column column-width="5.5%" />
      <!-- 1st date column -->
      <fo:table-column column-width="6%" />
      <!-- 2nd ID column -->
      <fo:table-column column-width="6%" />
      <!-- 2nd date column -->
      <fo:table-column column-width="6%" />
      <!-- Origin column -->
      <fo:table-column column-width="4%" />
      <!-- Quantity column -->
      <fo:table-column column-width="4%" />
      <!-- Type column -->
      <fo:table-column column-width="5%" />
      <!-- Symbol column -->
      <fo:table-column column-width="5%" />
      <!-- Strike column -->
      <fo:table-column column-width="6%" />
      <!-- Prompt column -->
      <fo:table-column column-width="4%" />
      <!-- Expiry Date column -->
      <fo:table-column column-width="7%" />
      <!-- Exchange -->
      <fo:table-column />
      <fo:table-column column-width="8%" />
      <!-- 2nd price column -->
      <fo:table-column column-width="8%" />
      <!-- Currency column -->
      <fo:table-column column-width="5.5%" />
      <!-- Realize PL column -->
      <fo:table-column column-width="10%" />

      <fo:table-header>
        <fo:table-row xsl:use-attribute-sets="content-table-header-row-style">
          	<xsl:choose>
		  		<xsl:when test="$statementType = 'PARENT'">
		      		<fo:table-cell xsl:use-attribute-sets="first-column-cell-style">
		              <fo:block>Account</fo:block>
		            </fo:table-cell>
		            <fo:table-cell>
		              <fo:block>Buy Trade ID</fo:block>
		            </fo:table-cell>
		      	</xsl:when>
		      	<xsl:otherwise>
		      		<fo:table-cell xsl:use-attribute-sets="first-column-cell-style">
		              <fo:block>Buy Trade ID</fo:block>
		            </fo:table-cell>	
		      	</xsl:otherwise>
			</xsl:choose>
          
          <fo:table-cell>
            <fo:block>Buy Trade Date</fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block>Sell Trade ID</fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block>Sell Trade Date</fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block>Origin</fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block xsl:use-attribute-sets="quantity-block-style">Quantity</fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block xsl:use-attribute-sets="right-align-block-style">Type</fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="ticker-symbol-column-cell-style">
            <fo:block xsl:use-attribute-sets="ticker-symbol-block-style">Symbol</fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block>Strike</fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block>Delivery</fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="left-padded-column-cell-style">
            <fo:block>Expiry Date</fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="left-padded-column-cell-style">
            <fo:block>Exchange</fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block xsl:use-attribute-sets="quantity-block-style">Buy Price</fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block xsl:use-attribute-sets="quantity-block-style">Sell Price</fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="left-padded-column-cell-style">
            <fo:block>Ccy</fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="last-column-cell-style">
            <fo:block xsl:use-attribute-sets="quantity-block-style">Realized PL</fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-header>

      <fo:table-body>
        <xsl:apply-templates
          select="stmt:row[generate-id() = generate-id(key('liquidationRowKey', concat(@account, @exchange, @contractDescription, ../@id))[1])]"
          mode="liquidationGroup">
          <xsl:sort select="@account" />
          <xsl:sort select="@ticker" />
          <xsl:sort select="stmt:liqTrade[@order = 1]/@id" />
          <xsl:sort select="stmt:liqTrade[@order = 2]/@id" />          
        </xsl:apply-templates>
      </fo:table-body>

    </fo:table>

  </xsl:template>

  <xsl:template
    match="stmt:row"
    mode="liquidationGroup">

    <xsl:variable name="isEvenRow">
      <xsl:if test="(position() mod 2) = 0">
        <xsl:value-of select="'true'" />
      </xsl:if>
    </xsl:variable>

    <xsl:variable
      name="groupAccount"
      select="@account" />
    <xsl:variable
      name="groupExchange"
      select="@exchange" />
    <xsl:variable
      name="groupContract"
      select="@contractDescription" />
    <xsl:variable
      name="contractCurrency"
      select="@currency" />

    <xsl:apply-templates
      select="../stmt:row[@account = $groupAccount and @exchange = $groupExchange and @contractDescription = $groupContract]"
      mode="liquidation">
      <xsl:sort select="stmt:liqTrade[@order = 1]/@id" />
      <xsl:sort select="stmt:liqTrade[@order = 2]/@id" />
      <xsl:sort select="stmt:liqTrade[@order = 1]/@date" />
      <xsl:sort select="stmt:liqTrade[@order = 2]/@date" />
      <xsl:with-param
        name="isEvenRow"
        select="$isEvenRow" />
    </xsl:apply-templates>

    <xsl:variable name="totalQuantity">
      <!-- Longs and shorts should match -->
      <xsl:value-of
        select="sum(../stmt:row[@account = $groupAccount and @exchange = $groupExchange and @contractDescription = $groupContract]/stmt:liqTrade[@long > 0]/@long)" />
    </xsl:variable>

    <xsl:variable name="totalRealized">
      <xsl:value-of
        select="sum(../stmt:row[@account = $groupAccount and @exchange = $groupExchange and @contractDescription = $groupContract and boolean(@debitCredit)]/@debitCredit)" />
    </xsl:variable>

    <!-- Contract description and total row -->

    <fo:table-row>
      <xsl:call-template name="subtotalRowAttributes">
        <xsl:with-param
          name="isEvenRow"
          select="$isEvenRow" />
      </xsl:call-template>
      
	<xsl:if test="$statementType = 'PARENT'">
	      <fo:table-cell>
	         <fo:block />
	      </fo:table-cell>
    </xsl:if>

      <fo:table-cell number-columns-spanned="2">
        <fo:block />
      </fo:table-cell>

      <fo:table-cell number-columns-spanned="3">
        <fo:block xsl:use-attribute-sets="subtotal-label-block-style">
          Total Quantity
        </fo:block>
      </fo:table-cell>

      <fo:table-cell>
        <fo:block xsl:use-attribute-sets="quantity-block-style">
          <xsl:value-of select="stmtext:formatNumber($totalQuantity, 0)" />
        </fo:block>
      </fo:table-cell>

      <fo:table-cell>
        <fo:block />
      </fo:table-cell>

      <fo:table-cell
        number-columns-spanned="5"
        xsl:use-attribute-sets="left-padded-column-cell-style">
        <fo:block xsl:use-attribute-sets="contract-description-block-style">
          <xsl:value-of select="$groupContract" />
        </fo:block>
      </fo:table-cell>

      <xsl:choose>
        <xsl:when
          test="boolean(../stmt:row[@account = $groupAccount and @exchange = $groupExchange and @contractDescription = $groupContract]/@debitCredit)">
          <fo:table-cell number-columns-spanned="2">
            <fo:block xsl:use-attribute-sets="subtotal-label-block-style">
              Total Realized PL
            </fo:block>
          </fo:table-cell>

          <fo:table-cell xsl:use-attribute-sets="left-padded-column-cell-style">
            <fo:block>
              <xsl:value-of select="$contractCurrency" />
            </fo:block>
          </fo:table-cell>

          <fo:table-cell xsl:use-attribute-sets="last-column-cell-style">
            <fo:block xsl:use-attribute-sets="quantity-block-style">
              <xsl:value-of select="stmtext:formatNumber($totalRealized, $contractCurrency)" />
            </fo:block>
          </fo:table-cell>

        </xsl:when>
        <xsl:otherwise>
          <fo:table-cell number-columns-spanned="4">
            <fo:block />
          </fo:table-cell>
        </xsl:otherwise>
      </xsl:choose>

    </fo:table-row>

  </xsl:template>

  <xsl:template
    match="stmt:row"
    mode="liquidation">
    <xsl:param name="isEvenRow" />

    <!-- Should match the 2nd trade -->
    <xsl:variable name="quantity">
      <xsl:choose>
        <xsl:when test="boolean(stmt:liqTrade[@order = 1]/@long)">
          <xsl:value-of select="stmt:liqTrade[@order = 1]/@long" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="stmt:liqTrade[@order = 1]/@short" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="firstPrice">
      <xsl:value-of
        select="stmtext:formatNumberWithQuoteType(stmt:liqTrade[@order = 1]/@price, number(stmt:liqTrade[@order = 1]/@contractDecimals), stmt:liqTrade[@order = 1]/@quoteType, $useExtendedFuture32)" />
    </xsl:variable>
    <xsl:variable name="secondPrice">
      <xsl:value-of
        select="stmtext:formatNumberWithQuoteType(stmt:liqTrade[@order = 2]/@price, number(stmt:liqTrade[@order = 2]/@contractDecimals), stmt:liqTrade[@order = 2]/@quoteType, $useExtendedFuture32)" />
    </xsl:variable>

    <fo:table-row>
      <xsl:call-template name="contentRowAttributes">
        <xsl:with-param
          name="isEvenRow"
          select="$isEvenRow" />
      </xsl:call-template>

          	<xsl:choose>
		  		<xsl:when test="$statementType = 'PARENT'">
		      		      <fo:table-cell xsl:use-attribute-sets="first-column-cell-style">
					        <fo:block>
					          <xsl:value-of select="@account" />
					        </fo:block>
					      </fo:table-cell>
					      <fo:table-cell>
					        <fo:block>
					          <xsl:value-of select="stmt:liqTrade[@order = 1]/@id" />
					        </fo:block>
					      </fo:table-cell>
		      	</xsl:when>
		      	<xsl:otherwise>
		      			<fo:table-cell xsl:use-attribute-sets="first-column-cell-style">
					        <fo:block>
					          <xsl:value-of select="stmt:liqTrade[@order = 1]/@id" />
					        </fo:block>
					    </fo:table-cell>
		      	</xsl:otherwise>
			</xsl:choose>

      <fo:table-cell>
        <fo:block>
          <xsl:value-of select="stmt:liqTrade[@order = 1]/@date" />
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block>
          <xsl:value-of select="stmt:liqTrade[@order = 2]/@id" />
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block>
          <xsl:value-of select="stmt:liqTrade[@order = 2]/@date" />
        </fo:block>
      </fo:table-cell>

      <fo:table-cell>
        <fo:block>
          <xsl:value-of select="@accountType" />
        </fo:block>
      </fo:table-cell>
      
      <fo:table-cell>
        <fo:block xsl:use-attribute-sets="quantity-block-style">
          <xsl:value-of select="stmtext:formatNumber($quantity, 0)" />
        </fo:block>
      </fo:table-cell>

      <fo:table-cell xsl:use-attribute-sets="right-align-block-style">
        <fo:block>
          <xsl:value-of select="@productType" />
        </fo:block>
      </fo:table-cell>

      <xsl:call-template name="tickerSymbolCell">
        <xsl:with-param
          name="ticker"
          select="@ticker" />
      </xsl:call-template>

      <fo:table-cell>
        <fo:block>
          <xsl:value-of select="@strike" />
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block>
          <xsl:value-of select="@deliveryDate" />
        </fo:block>
      </fo:table-cell>
      <fo:table-cell xsl:use-attribute-sets="left-padded-column-cell-style">
        <fo:block>
          <xsl:value-of select="@expirationDate" />
        </fo:block>
      </fo:table-cell>
      <fo:table-cell xsl:use-attribute-sets="left-padded-column-cell-style">
        <fo:block>
          <xsl:value-of select="@exchange" />
        </fo:block>
      </fo:table-cell>

      <fo:table-cell>
        <fo:block xsl:use-attribute-sets="quantity-block-style">
          <xsl:value-of select="$firstPrice" />
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block xsl:use-attribute-sets="quantity-block-style">
          <xsl:value-of select="$secondPrice" />
        </fo:block>
      </fo:table-cell>

      <fo:table-cell xsl:use-attribute-sets="left-padded-column-cell-style">
        <fo:block>
          <xsl:value-of select="@currency" />
        </fo:block>
      </fo:table-cell>

      <fo:table-cell xsl:use-attribute-sets="last-column-cell-style">
        <fo:block xsl:use-attribute-sets="quantity-block-style">
            <xsl:value-of select="stmtext:formatNumber(@debitCredit, @currency)" />
        </fo:block>
      </fo:table-cell>

    </fo:table-row>

  </xsl:template>

</xsl:stylesheet>