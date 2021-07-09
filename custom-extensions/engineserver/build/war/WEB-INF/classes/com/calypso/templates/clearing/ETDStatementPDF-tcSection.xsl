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

  <!-- TRADE CONFIRMATIONS SECTION -->

  <!-- Add all flow types in all subsections -->
  <xsl:key
    name="tradeConfirmationNonTotalFlowsKey"
    match="stmt:section[@id='tradeConfirmations']//stmt:bucket"
    use="@name" />

  <xsl:key
    name="tradeConfirmationFlowCurrencyKey"
    match="stmt:section[@id='tradeConfirmations']/stmt:section/stmt:row/stmt:bucket"
    use="concat(../@account, ../@exchange, ../@contractDescription, ../@date, ../../@id, @currency)" />

  <xsl:key
    name="tradeConfirmationKey"
    match="stmt:section[@id='tradeConfirmations']/stmt:section/stmt:row"
    use="concat(@account, @exchange, @contractDescription, @date, ../@id)" />

  <xsl:key
    name="tradeConfirmationTransferBucketKey"
    match="stmt:section[@id='tradeConfirmations']/stmt:section/stmt:row/stmt:bucket"
    use="concat(@name, @currency, ../@account, ../@exchange, ../@contractDescription, ../@date, ../../@id)" />

  <xsl:attribute-set name="short-column-cell-style">
    <xsl:attribute name="padding-left">3px</xsl:attribute>
  </xsl:attribute-set>

  <xsl:template match="stmt:section[@id='tradeConfirmations']">

    <fo:block xsl:use-attribute-sets="section-block-style">

      <xsl:call-template name="sectionTitle">
        <xsl:with-param
          name="title"
          select="'Trade Confirmations'" />
      </xsl:call-template>

      <xsl:apply-templates select="stmt:section">
        <xsl:sort select="@order" />
      </xsl:apply-templates>

      <xsl:call-template name="emptySectionComment">
        <xsl:with-param
          name="content"
          select="stmt:section" />
      </xsl:call-template>

    </fo:block>

  </xsl:template>

  <xsl:template
    mode="tradeConfirmationsNonTotalColumnHeader"
    match="stmt:bucket[not(contains(@name, 'Total'))]">
    <xsl:variable name="parentComm" select="'Comm'" />
    <xsl:variable name="colName">
      <xsl:choose>
  		<xsl:when test="@name = 'Commissions' and $statementType = 'PARENT'">
      		<xsl:value-of select="$parentComm" />
      	</xsl:when>
      	<xsl:otherwise>
      		<xsl:value-of select="@name" />	
      	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>	
    <fo:table-cell>
      <fo:block xsl:use-attribute-sets="quantity-block-style">
      	<xsl:value-of select="$colName" />
      </fo:block>
    </fo:table-cell>
  </xsl:template>

  <xsl:template
    mode="tradeConfirmationsNonTotalColumnColumnDefinition"
    match="stmt:bucket[not(contains(@name, 'Total'))]">
    <fo:table-column>
      <xsl:if test="@name = 'Premium'">
        <xsl:attribute name="column-width">9.0%</xsl:attribute>
      </xsl:if>
      <!-- >xsl:if test="@name != 'Premium'">
        <xsl:attribute name="column-width">4%</xsl:attribute>
      </xsl:if-->
    </fo:table-column>
  </xsl:template>

  <xsl:template match="stmt:section[@id='tradeConfirmations']/stmt:section">

    <xsl:call-template name="sectionSubtitle">
      <xsl:with-param
        name="subtitle"
        select="concat(@id, ' Trades')" />
    </xsl:call-template>

    <fo:table xsl:use-attribute-sets="debug-table-format-style content-table-style">

	  <!-- Account column -->
      
      <xsl:if test="$statementType = 'PARENT'">
      	<fo:table-column column-width="6%" />
      </xsl:if>
      <!-- ID column -->
      <fo:table-column column-width="4%" />
      <!-- Trade Date column -->
      <fo:table-column column-width="5.5%" />
      <!-- Origin column -->
      <fo:table-column column-width="4%" />
      <!-- Trade Type column -->
      <fo:table-column column-width="4%" />
      <!-- Execution Type column -->
      <fo:table-column column-width="4.5%" />
      <!-- Long column -->
      <fo:table-column column-width="3%" />
      <!-- Short column -->
      <fo:table-column column-width="3%" />
      <!-- Type column -->
      <fo:table-column column-width="4.5%" />
      <!-- Symbol column -->
      <fo:table-column column-width="4.5%" />
      <!-- Strike column -->
      <fo:table-column column-width="5%" />
      <!-- Delivery Month column -->
      <fo:table-column column-width="4%" />
      <!-- Expiry Date column -->
      <fo:table-column column-width="5.5%" />
      <!-- Exchange column -->
      <fo:table-column column-width="4%" />
      <!-- Trade Price column -->
      <fo:table-column column-width="7.0%" />
      <!-- Currency column -->
      <fo:table-column column-width="3%" />
      <!-- Flow columns -->
      <xsl:apply-templates
        mode="tradeConfirmationsNonTotalColumnColumnDefinition"
        select="..//stmt:row/stmt:bucket[generate-id() = generate-id(key('tradeConfirmationNonTotalFlowsKey', @name)[1])]">
        <xsl:sort select="@name" />
      </xsl:apply-templates>
      <!-- Debit/Credit column -->
      <fo:table-column column-width="9.0%" />

      <fo:table-header>
        <fo:table-row xsl:use-attribute-sets="content-table-header-row-style">
          
          <xsl:if test="$statementType = 'PARENT'">
      			<fo:table-cell xsl:use-attribute-sets="first-column-cell-style">
		            <fo:block>Account</fo:block>
		          </fo:table-cell>
				  <fo:table-cell>
		            <fo:block>ID</fo:block>
		          </fo:table-cell>
      	  </xsl:if>

          <xsl:if test="$statementType != 'PARENT'">
      			<fo:table-cell xsl:use-attribute-sets="first-column-cell-style">
		            <fo:block>ID</fo:block>
		        </fo:table-cell>
      	  </xsl:if>
          
          <fo:table-cell>
            <fo:block>Trade Date</fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block>Origin</fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block>Trade Type</fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block>Execution Type</fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block xsl:use-attribute-sets="quantity-block-style">Long</fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="short-column-cell-style">
            <fo:block xsl:use-attribute-sets="quantity-block-style">Short</fo:block>
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
            <fo:block xsl:use-attribute-sets="quantity-block-style">Trade Price</fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="left-padded-column-cell-style">
            <fo:block>Ccy</fo:block>
          </fo:table-cell>

          <!-- Variable number of flows -->
          <xsl:apply-templates
            mode="tradeConfirmationsNonTotalColumnHeader"
            select="..//stmt:row/stmt:bucket[generate-id() = generate-id(key('tradeConfirmationNonTotalFlowsKey', @name)[1])]">
            <xsl:sort select="@name" />
          </xsl:apply-templates>

          <fo:table-cell xsl:use-attribute-sets="last-column-cell-style">
            <fo:block xsl:use-attribute-sets="quantity-block-style">Debit/Credit</fo:block>
          </fo:table-cell>

        </fo:table-row>
      </fo:table-header>

      <fo:table-body>

        <xsl:apply-templates
          mode="tradeConfirmationsGroup"
          select="stmt:row[generate-id() = generate-id(key('tradeConfirmationKey', concat(@account, @exchange, @contractDescription, @date, ../@id))[1])]">
          <xsl:sort select="@account" />
          <xsl:sort select="@ticker" />
          <xsl:sort select="@id" />
        </xsl:apply-templates>

      </fo:table-body>
    </fo:table>

  </xsl:template>

  <xsl:template
    match="stmt:row"
    mode="tradeConfirmationsGroup">
    <xsl:variable name="groupExchange">
      <xsl:value-of select="@exchange" />
    </xsl:variable>
    <xsl:variable name="groupContract">
      <xsl:value-of select="@contractDescription" />
    </xsl:variable>
    <xsl:variable name="groupAccount">
      <xsl:value-of select="@account" />
    </xsl:variable>
    <xsl:variable name="groupDate">
      <xsl:value-of select="@date" />
    </xsl:variable>
    <xsl:variable name="currentSubsectionId">
      <xsl:value-of select="../@id" />
    </xsl:variable>
    <xsl:variable name="quoteType">
      <xsl:value-of
        select="../stmt:row[@account = $groupAccount and @exchange = $groupExchange and @contractDescription = $groupContract and @date = $groupDate][1]/@quoteType" />
    </xsl:variable>
    <xsl:variable name="contractCurrency">
      <xsl:value-of
        select="../stmt:row[@account = $groupAccount and @exchange = $groupExchange and @contractDescription = $groupContract and @date = $groupDate][1]/@currency" />
    </xsl:variable>

    <xsl:variable name="isEvenRow">
      <xsl:if test="(position() mod 2) = 0">
        <xsl:value-of select="'true'" />
      </xsl:if>
    </xsl:variable>

    <xsl:apply-templates
      mode="tradeConfirmationsRow"
      select="../stmt:row[@account = $groupAccount and @exchange = $groupExchange and @contractDescription = $groupContract and @date = $groupDate]">
      <xsl:sort select="@id" />
      <xsl:with-param
        name="isEvenRow"
        select="$isEvenRow" />
    </xsl:apply-templates>

    <xsl:variable
      name="totalLong"
      select="sum(../stmt:row[@account = $groupAccount and @exchange = $groupExchange and @contractDescription = $groupContract and @date = $groupDate and boolean(@long)]/@long)" />
    <xsl:variable
      name="totalShort"
      select="sum(../stmt:row[@account = $groupAccount and @exchange = $groupExchange and @contractDescription = $groupContract and @date = $groupDate and boolean(@short)]/@short)" />

    <!-- At least one mandatory subtotal row: the one for the flows in the contract currency -->
    <xsl:apply-templates
      mode="tradeConfirmationsGroup"
      select="../stmt:row[@account = $groupAccount and @exchange = $groupExchange and @contractDescription = $groupContract and @date = $groupDate]/stmt:bucket[@currency = $contractCurrency and generate-id() = generate-id(key('tradeConfirmationFlowCurrencyKey', concat($groupAccount, $groupExchange, $groupContract, $groupDate, $currentSubsectionId, @currency))[1])]">
      <xsl:with-param
        name="isEvenRow"
        select="$isEvenRow" />
      <xsl:with-param
        name="totalLong"
        select="$totalLong" />
      <xsl:with-param
        name="totalShort"
        select="$totalShort" />
    </xsl:apply-templates>

    <!-- Rest of subtotals for flows in different currencies -->
    <xsl:apply-templates
      mode="tradeConfirmationsGroup"
      select="../stmt:row[@account = $groupAccount and @exchange = $groupExchange and @contractDescription = $groupContract and @date = $groupDate]/stmt:bucket[@currency != $contractCurrency and generate-id() = generate-id(key('tradeConfirmationFlowCurrencyKey', concat($groupAccount, $groupExchange, $groupContract, $groupDate, $currentSubsectionId, @currency))[1])]">
      <xsl:with-param
        name="isEvenRow"
        select="$isEvenRow" />
    </xsl:apply-templates>

    <!-- Add row when no flows are present, to render the total quantity -->
    <xsl:if
      test="not(boolean(../stmt:row[@account = $groupAccount and @exchange = $groupExchange and @contractDescription = $groupContract and @date = $groupDate]/stmt:bucket))">

      <xsl:apply-templates
        mode="tradeConfirmationsNoFlowsTotalRow"
        select="../stmt:row[@account = $groupAccount and @exchange = $groupExchange and @contractDescription = $groupContract and @date = $groupDate][1]">
        <xsl:with-param
          name="isEvenRow"
          select="$isEvenRow" />
        <xsl:with-param
          name="totalLong"
          select="$totalLong" />
        <xsl:with-param
          name="totalShort"
          select="$totalShort" />
      </xsl:apply-templates>

    </xsl:if>

  </xsl:template>

  <xsl:template
    match="stmt:row"
    mode="tradeConfirmationsRow">
    <xsl:param name="isEvenRow" />

    <!-- Trade row template -->

    <xsl:variable name="tradeId">
      <xsl:value-of select="@id" />
    </xsl:variable>

    <fo:table-row>
      <xsl:call-template name="contentRowAttributes">
        <xsl:with-param
          name="isEvenRow"
          select="$isEvenRow" />
      </xsl:call-template>

	  <xsl:if test="$statementType = 'PARENT'">
		  <fo:table-cell xsl:use-attribute-sets="first-column-cell-style">
	        <fo:block>
	          <xsl:value-of select="@account" />
	        </fo:block>
	      </fo:table-cell>
	      <fo:table-cell>
	        <fo:block>
	          <xsl:value-of select="$tradeId" />
	        </fo:block>
	      </fo:table-cell>
      </xsl:if>
	  <xsl:if test="$statementType != 'PARENT'">
		  <fo:table-cell xsl:use-attribute-sets="first-column-cell-style">
	        <fo:block>
	          <xsl:value-of select="$tradeId" />
	        </fo:block>
	      </fo:table-cell>
      </xsl:if>
	  
	  <fo:table-cell>
        <fo:block>
          <xsl:value-of select="@date" />
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block>
          <xsl:value-of select="@accountType" />
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block>
          <xsl:value-of select="@tradeType" />
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block>
          <xsl:value-of select="@executionType" />
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block xsl:use-attribute-sets="quantity-block-style">
          <xsl:value-of select="stmtext:formatNumber(@long, 0)" />
        </fo:block>
      </fo:table-cell>
      <fo:table-cell xsl:use-attribute-sets="short-column-cell-style">
        <fo:block xsl:use-attribute-sets="quantity-block-style">
          <xsl:value-of select="stmtext:formatNumber(@short, 0)" />
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
          <xsl:value-of select="stmtext:formatNumberWithQuoteType(@price, number(@contractDecimals), @quoteType, $useExtendedFuture32)" />
        </fo:block>
      </fo:table-cell>
      <fo:table-cell xsl:use-attribute-sets="left-padded-column-cell-style">
        <fo:block>
          <xsl:value-of select="@currency" />
        </fo:block>
      </fo:table-cell>

      <!-- Variable number of flows -->
      <xsl:for-each
        select="../../..//stmt:row/stmt:bucket[not(contains(@name, 'Total')) and generate-id() = generate-id(key('tradeConfirmationNonTotalFlowsKey', @name)[1])]">
        <xsl:sort select="@name" />
        <xsl:variable
          name="flowName"
          select="@name" />
        <xsl:variable name="flowAmount">
          <xsl:value-of select="../../..//stmt:row[@id = $tradeId]/stmt:bucket[@name = $flowName]/@amount" />
        </xsl:variable>
        <xsl:variable name="flowCurrency">
          <xsl:value-of select="../../..//stmt:row[@id = $tradeId]/stmt:bucket[@name = $flowName]/@currency" />
        </xsl:variable>

        <fo:table-cell xsl:use-attribute-sets="last-column-cell-style">
          <fo:block xsl:use-attribute-sets="quantity-block-style">
            <xsl:if test="boolean($flowAmount) and boolean($flowCurrency)">
              <xsl:value-of select="stmtext:formatNumber($flowAmount, $flowCurrency)" />
            </xsl:if>
          </fo:block>
        </fo:table-cell>
      </xsl:for-each>

      <fo:table-cell>
        <fo:block />
      </fo:table-cell>

    </fo:table-row>

  </xsl:template>

  <xsl:template
    match="stmt:bucket[@name = 'Total Charges']"
    mode="tradeConfirmationsGroup"
    name="tradeConfirmationsTotalChargesSubtotal">

    <!-- Trade subtotals template -->

    <xsl:param name="isEvenRow" />
    <xsl:param
      name="exchange"
      select="../@exchange" />
    <xsl:param
      name="contractDescription"
      select="../@contractDescription" />
    <xsl:param
      name="date"
      select="../@date" />
    <xsl:param
      name="account"
      select="../@account" />
    <xsl:param
      name="name"
      select="@name" />
    <xsl:param
      name="currency"
      select="@currency" />
    <xsl:param name="amount">
      <xsl:value-of
        select="sum(../../stmt:row[@account = $account and @exchange = $exchange and @contractDescription = $contractDescription and @date = $date]/stmt:bucket[@name = $name and @currency = $currency]/@amount)" />
    </xsl:param>
    <xsl:param name="totalLong" />
    <xsl:param name="totalShort" />

    <xsl:variable
      name="subsection"
      select="../../@id" />

    <fo:table-row>

      <xsl:call-template name="subtotalRowAttributes">
        <xsl:with-param
          name="isEvenRow"
          select="$isEvenRow" />
      </xsl:call-template>

      <!-- ID column -->
      <fo:table-cell xsl:use-attribute-sets="first-column-cell-style">
        <fo:block />
      </fo:table-cell>
	  
	  <xsl:if test="$statementType = 'PARENT'">
	      <fo:table-cell>
	         <fo:block />
	      </fo:table-cell>
      </xsl:if>
      
      <fo:table-cell>
        <fo:block>
          <xsl:value-of select="$date" />
        </fo:block>
      </fo:table-cell>
      
      <fo:table-cell>
         <fo:block />
      </fo:table-cell>

      <xsl:choose>
        <xsl:when test="boolean($totalShort) or boolean($totalLong)">

          <fo:table-cell
		     number-columns-spanned="2"
            xsl:use-attribute-sets="subtotal-label-block-style">
            <fo:block>Total Quantity</fo:block>
          </fo:table-cell>

          <fo:table-cell>
            <fo:block xsl:use-attribute-sets="quantity-block-style">
              <xsl:if test="boolean($totalLong) and $totalLong != 0">
                <xsl:value-of select="stmtext:formatNumber($totalLong, 0)" />
              </xsl:if>
            </fo:block>
          </fo:table-cell>

          <fo:table-cell xsl:use-attribute-sets="short-column-cell-style">
            <fo:block xsl:use-attribute-sets="quantity-block-style">
              <xsl:if test="boolean($totalShort) and $totalShort != 0">
                <xsl:value-of select="stmtext:formatNumber($totalShort, 0)" />
              </xsl:if>
            </fo:block>
          </fo:table-cell>

          <fo:table-cell>
            <fo:block />
          </fo:table-cell>

          <fo:table-cell
            number-columns-spanned="5"
            xsl:use-attribute-sets="left-padded-column-cell-style">
            <fo:block xsl:use-attribute-sets="contract-description-block-style">
              <xsl:value-of select="$contractDescription" />
            </fo:block>
          </fo:table-cell>

        </xsl:when>
        <xsl:otherwise>

          <fo:table-cell number-columns-spanned="11">
            <fo:block />
          </fo:table-cell>

        </xsl:otherwise>
      </xsl:choose>

      <fo:table-cell>
        <fo:block xsl:use-attribute-sets="subtotal-label-block-style">
          <xsl:value-of select="'Total'" />
        </fo:block>
      </fo:table-cell>

      <fo:table-cell xsl:use-attribute-sets="left-padded-column-cell-style">
        <fo:block>
          <xsl:value-of select="$currency" />
        </fo:block>
      </fo:table-cell>

      <xsl:for-each
        select="../../..//stmt:row/stmt:bucket[not(contains(@name, 'Total')) and generate-id() = generate-id(key('tradeConfirmationNonTotalFlowsKey', @name)[1])]">
        <xsl:sort select="@name" />
        <xsl:variable
          name="flowName"
          select="@name" />

        <xsl:variable name="flowAmount">
          <xsl:value-of
            select="sum(../../..//stmt:row[../@id = $subsection and @account = $account and @exchange = $exchange and @contractDescription = $contractDescription and @date = $date]/stmt:bucket[@name = $flowName and @currency = $currency]/@amount)" />
        </xsl:variable>

        <fo:table-cell>
          <fo:block xsl:use-attribute-sets="quantity-block-style">
            <xsl:if test="boolean(number($flowAmount)) and $flowAmount != 0">
              <xsl:value-of select="stmtext:formatNumber($flowAmount, $currency)" />
            </xsl:if>
          </fo:block>
        </fo:table-cell>
      </xsl:for-each>

      <fo:table-cell xsl:use-attribute-sets="last-column-cell-style">
        <fo:block xsl:use-attribute-sets="quantity-block-style">
          <xsl:value-of select="stmtext:formatNumber($amount, $currency)" />
        </fo:block>
      </fo:table-cell>

    </fo:table-row>

  </xsl:template>

  <xsl:template
    match="stmt:row"
    mode="tradeConfirmationsNoFlowsTotalRow">

    <xsl:param name="isEvenRow" />
    <xsl:param
      name="contractDescription"
      select="@contractDescription" />
    <xsl:param name="totalLong" />
    <xsl:param name="totalShort" />

    <fo:table-row>

      <xsl:call-template name="subtotalRowAttributes">
        <xsl:with-param
          name="isEvenRow"
          select="$isEvenRow" />
      </xsl:call-template>

      <fo:table-cell xsl:use-attribute-sets="first-column-cell-style">
        <fo:block />
      </fo:table-cell>

	<xsl:if test="$statementType = 'PARENT'">
	      <fo:table-cell>
	         <fo:block />
	      </fo:table-cell>
      </xsl:if>
            
      <fo:table-cell>
        <fo:block>
          <xsl:value-of select="@date" />
        </fo:block>
      </fo:table-cell>

      <fo:table-cell>
         <fo:block />
      </fo:table-cell>

      <fo:table-cell>
         <fo:block />
      </fo:table-cell>
      
      <xsl:choose>
        <xsl:when test="boolean($totalShort) or boolean($totalLong)">

          <fo:table-cell
            xsl:use-attribute-sets="subtotal-label-block-style">
            <fo:block>Total Quantity</fo:block>
          </fo:table-cell>

          <fo:table-cell>
            <fo:block xsl:use-attribute-sets="quantity-block-style">
              <xsl:if test="boolean($totalLong) and $totalLong != 0">
                <xsl:value-of select="stmtext:formatNumber($totalLong, 0)" />
              </xsl:if>
            </fo:block>
          </fo:table-cell>

          <fo:table-cell xsl:use-attribute-sets="short-column-cell-style">
            <fo:block xsl:use-attribute-sets="quantity-block-style">
              <xsl:if test="boolean($totalShort) and $totalShort != 0">
                <xsl:value-of select="stmtext:formatNumber($totalShort, 0)" />
              </xsl:if>
            </fo:block>
          </fo:table-cell>

          <fo:table-cell>
            <fo:block />
          </fo:table-cell>

          <fo:table-cell
            number-columns-spanned="5"
            xsl:use-attribute-sets="left-padded-column-cell-style">
            <fo:block xsl:use-attribute-sets="contract-description-block-style">
              <xsl:value-of select="$contractDescription" />
            </fo:block>
          </fo:table-cell>

        </xsl:when>
        <xsl:otherwise>

          <fo:table-cell number-columns-spanned="9">
            <fo:block />
          </fo:table-cell>

        </xsl:otherwise>
      </xsl:choose>



    </fo:table-row>

  </xsl:template>

</xsl:stylesheet>
