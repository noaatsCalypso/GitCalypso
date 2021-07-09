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

  <!-- LIFECYCLE ACTIVITY SECTION -->

  <xsl:attribute-set
    name="lifecycle-activity-content-table-style"
    use-attribute-sets="content-table-style">
    <!-- Longer flow names columns to fit -->
    <xsl:attribute name="font-size">0.5em</xsl:attribute>
  </xsl:attribute-set>

  <!-- Add all flow types in all subsections -->
  <xsl:key
    name="lifecycleActivityNonTotalFlowsKey"
    match="stmt:section[@id='lifecycleActivity']//stmt:bucket"
    use="@name" />

  <xsl:key
    name="lifecycleActivityFlowCurrencyKey"
    match="stmt:section[@id='lifecycleActivity']/stmt:section/stmt:row/stmt:bucket"
    use="concat(../@account, ../@exchange, ../@contractDescription, ../../@id, @currency)" />

  <xsl:key
    name="lifecycleActivityKey"
    match="stmt:section[@id='lifecycleActivity']/stmt:section/stmt:row"
    use="concat(@account, @exchange, @contractDescription, ../@id)" />

  <xsl:key
    name="lifecycleActivityTransferBucketKey"
    match="stmt:section[@id='lifecycleActivity']/stmt:section/stmt:row/stmt:bucket"
    use="concat(@name, @currency, ../@account, ../@exchange, ../@contractDescription, ../../@id)" />

  <xsl:template match="stmt:section[@id='lifecycleActivity']">
    <fo:block xsl:use-attribute-sets="section-block-style">

      <xsl:call-template name="sectionTitle">
        <xsl:with-param
          name="title"
          select="'Lifecycle Activity'" />
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

  <!-- Variable number of flow columns -->
  <xsl:template
    mode="lifecycleActivityNonTotalColumnHeader"
    match="stmt:bucket[not(contains(@name, 'Total'))]">
    <fo:table-cell>

      <xsl:if test="contains(@name, 'Realized')">
        <!-- This is to push most of the text to the second wrapped line of the header -->
        <xsl:attribute name="padding-left">3px</xsl:attribute>
      </xsl:if>

      <fo:block xsl:use-attribute-sets="long-header-block-style quantity-block-style">
        <xsl:value-of select="@name" />
      </fo:block>
    </fo:table-cell>

  </xsl:template>

  <xsl:template
    mode="lifecycleActivityNonTotalColumnColumnDefinition"
    match="stmt:bucket[not(contains(@name, 'Total'))]">
    <fo:table-column>
      <xsl:attribute name="column-width">
      <xsl:choose>
          <xsl:when test="@name = 'Commissions' or @name = 'Fees'">
            <xsl:value-of select="'5%'" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="'7%'" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </fo:table-column>
  </xsl:template>

  <xsl:template match="stmt:section[@id='lifecycleActivity']/stmt:section">

    <xsl:call-template name="sectionSubtitle">
      <xsl:with-param
        name="subtitle"
        select="concat(@id, ' Lifecycle Activity')" />
    </xsl:call-template>

    <fo:table xsl:use-attribute-sets="debug-table-format-style lifecycle-activity-content-table-style">

	  <xsl:if test="$statementType = 'PARENT'">
		  <!-- Account column -->
	      <fo:table-column column-width="5.75%" />
      </xsl:if>
      
	  <!-- ID column -->
      <fo:table-column column-width="5.5%" />
      <!-- Trade Date column -->
      <fo:table-column column-width="6%" />
      <!-- Execution Type column -->
      <fo:table-column column-width="8%" />
      <!-- Long column -->
      <fo:table-column column-width="4%" />
      <!-- Short column -->
      <fo:table-column column-width="4%" />
      <!-- Type column -->
      <fo:table-column column-width="4.5%" />
      <!-- Symbol column -->
      <fo:table-column column-width="5%" />
      <!-- Strike column -->
      <fo:table-column column-width="5.5%" />
      <!-- Prompt Month column -->
      <fo:table-column column-width="4%" />
      <!-- Expiry Date column -->
      <fo:table-column column-width="6%" />
      <!-- Exchange column -->
      <fo:table-column column-width="5.5%" />
      <!-- Trade Price column -->
      <fo:table-column />
      <!-- Currency column -->
      <fo:table-column column-width="3.25%" />
      <!-- Flow columns -->
      <xsl:apply-templates
        mode="lifecycleActivityNonTotalColumnColumnDefinition"
        select="..//stmt:row/stmt:bucket[generate-id() = generate-id(key('lifecycleActivityNonTotalFlowsKey', @name)[1])]">
        <xsl:sort select="@name" />
      </xsl:apply-templates>
      <!-- Debit/Credit column -->
      <fo:table-column column-width="8.5%" />

      <fo:table-header>
        <fo:table-row xsl:use-attribute-sets="content-table-header-row-style">
              	<xsl:choose>
			  		<xsl:when test="$statementType = 'PARENT'">
			      		  <fo:table-cell xsl:use-attribute-sets="first-column-cell-style">
			                <fo:block>Account</fo:block>
			              </fo:table-cell>
						  <fo:table-cell>
			                <fo:block>ID</fo:block>
			              </fo:table-cell>
			      	</xsl:when>
			      	<xsl:otherwise>
			      		 <fo:table-cell xsl:use-attribute-sets="first-column-cell-style">
			                <fo:block>ID</fo:block>
			              </fo:table-cell>
			      	</xsl:otherwise>
				</xsl:choose>
		  <fo:table-cell>
            <fo:block>Trade Date</fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block>Execution Type</fo:block>
          </fo:table-cell>
          <fo:table-cell>
            <fo:block xsl:use-attribute-sets="quantity-block-style">Long</fo:block>
          </fo:table-cell>
          <fo:table-cell>
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
            mode="lifecycleActivityNonTotalColumnHeader"
            select="..//stmt:row/stmt:bucket[generate-id() = generate-id(key('lifecycleActivityNonTotalFlowsKey', @name)[1])]">
            <xsl:sort select="@name" />
          </xsl:apply-templates>

          <fo:table-cell xsl:use-attribute-sets="last-column-cell-style">
            <fo:block xsl:use-attribute-sets="quantity-block-style">Debit/Credit</fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-header>

      <fo:table-body>
        <xsl:apply-templates
          mode="lifecycleActivityRowGroup"
          select="stmt:row[generate-id() = generate-id(key('lifecycleActivityKey', concat(@account, @exchange, @contractDescription, ../@id))[1])]">
          <xsl:sort select="@account" />
          <xsl:sort select="@ticker" />
          <xsl:sort select="@id" />
        </xsl:apply-templates>
      </fo:table-body>

    </fo:table>

  </xsl:template>

  <xsl:template
    match="stmt:row"
    mode="lifecycleActivityRowGroup">

    <xsl:variable
      name="subsection"
      select="../@id" />
    <xsl:variable
      name="groupAccount"
      select="@account" />
    <xsl:variable
      name="groupExchange"
      select="@exchange" />
    <xsl:variable
      name="groupContractDescription"
      select="@contractDescription" />

    <xsl:variable name="isEvenRow">
      <xsl:if test="(position() mod 2) = 0">
        <xsl:value-of select="'true'" />
      </xsl:if>
    </xsl:variable>

    <xsl:apply-templates
      mode="lifecycleActivityRow"
      select="../stmt:row[@account = $groupAccount and @exchange = $groupExchange and @contractDescription = $groupContractDescription]">
      <xsl:sort select="@id" />
      <xsl:with-param
        name="isEvenRow"
        select="$isEvenRow" />
    </xsl:apply-templates>

    <xsl:apply-templates
      mode="lifecycleActivityTransferBucketRow"
      select="../stmt:row[@account = $groupAccount and @exchange = $groupExchange and @contractDescription = $groupContractDescription]/stmt:bucket[generate-id() = generate-id(key('lifecycleActivityTransferBucketKey', concat(@name, @currency, $groupAccount, $groupExchange, $groupContractDescription, $subsection))[1])]">
      <xsl:sort select="@order" />
      <xsl:sort select="@name" />
      <xsl:sort select="@currency" />
      <xsl:with-param
        name="isEvenRow"
        select="$isEvenRow" />
    </xsl:apply-templates>

  </xsl:template>

  <xsl:template
    match="stmt:row"
    mode="lifecycleActivityRow">
    <xsl:param name="isEvenRow" />
    <xsl:variable
      name="isCancelled"
      select="boolean(../@id = 'cancelled')" />

    <xsl:variable name="subsection">
      <xsl:value-of select="../@id" />
    </xsl:variable>

    <xsl:variable name="tradeId">
      <xsl:value-of select="@closeOutId" />
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
		          <xsl:value-of select="@id" />
		        </fo:block>
		      </fo:table-cell>
      	</xsl:when>
      	<xsl:otherwise>
      		<fo:table-cell xsl:use-attribute-sets="first-column-cell-style">
		        <fo:block>
		          <xsl:value-of select="@id" />
		        </fo:block>
		      </fo:table-cell>	
      	</xsl:otherwise>
	  </xsl:choose>
	  
	  <fo:table-cell>
        <fo:block>
          <xsl:value-of select="@date" />
        </fo:block>
      </fo:table-cell>

      <fo:table-cell>
        <fo:block>
          <xsl:value-of select="@executionType" />
          <xsl:if test="$isCancelled and boolean(@executionType)">
            <xsl:value-of select="' REVERSAL'" />
          </xsl:if>
        </fo:block>
      </fo:table-cell>

      <fo:table-cell>
        <fo:block xsl:use-attribute-sets="quantity-block-style">
          <xsl:value-of select="stmtext:formatNumber(@long, 0)" />
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
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
      <!-- Careful: this iterates over all subsections, finding all bucket names (full union) -->
      <xsl:for-each
        select="../../..//stmt:row/stmt:bucket[not(contains(@name, 'Total')) and generate-id() = generate-id(key('lifecycleActivityNonTotalFlowsKey', @name)[1])]">
        <xsl:sort select="@name" />
        <xsl:variable
          name="flowName"
          select="@name" />
        <xsl:variable name="flowAmount">
          <xsl:value-of
            select="../../..//stmt:section[@id = $subsection]/stmt:row[@closeOutId = $tradeId]/stmt:bucket[@name = $flowName]/@amount" />
        </xsl:variable>
        <xsl:variable name="flowCurrency">
          <xsl:value-of
            select="../../..//stmt:section[@id = $subsection]/stmt:row[@closeOutId = $tradeId]/stmt:bucket[@name = $flowName]/@currency" />
        </xsl:variable>

        <fo:table-cell xsl:use-attribute-sets="last-column-cell-style">
          <fo:block xsl:use-attribute-sets="quantity-block-style">
            <xsl:if test="boolean($flowAmount) and boolean($flowCurrency)">
              <xsl:value-of select="stmtext:formatNumber($flowAmount, $flowCurrency)" />
            </xsl:if>
          </fo:block>
        </fo:table-cell>
      </xsl:for-each>

      <fo:table-cell xsl:use-attribute-sets="last-column-cell-style">
        <fo:block xsl:use-attribute-sets="quantity-block-style">
          <xsl:if test="boolean(@debitCredit)">
            <xsl:value-of select="stmtext:formatNumber(@debitCredit, @currency)" />
          </xsl:if>
        </fo:block>
      </fo:table-cell>

    </fo:table-row>

  </xsl:template>

  <xsl:template
    match="stmt:bucket[@name = 'Total Charges']"
    mode="lifecycleActivityTransferBucketRow">

    <!-- This assumes single currency flows, so we can reuse it for the contract description too -->

    <xsl:param name="isEvenRow" />
    <xsl:param
      name="exchange"
      select="../@exchange" />
    <xsl:param
      name="contractDescription"
      select="../@contractDescription" />
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
        select="sum(../../stmt:row[@account = $account and @exchange = $exchange and @contractDescription = $contractDescription]/stmt:bucket[@name = $name and @currency = $currency]/@amount)" />
    </xsl:param>

    <xsl:variable
      name="totalLong"
      select="sum(../../stmt:row[@account = $account and @exchange = $exchange and @contractDescription = $contractDescription and boolean(@long)]/@long)" />
    <xsl:variable
      name="totalShort"
      select="sum(../../stmt:row[@account = $account and @exchange = $exchange and @contractDescription = $contractDescription and boolean(@short)]/@short)" />

    <xsl:variable
      name="subsection"
      select="../../@id" />

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
	  <!-- ID column -->
	  <fo:table-cell>
        <fo:block />
      </fo:table-cell>

      <fo:table-cell
        xsl:use-attribute-sets="subtotal-label-block-style"
        number-columns-spanned="2">
        <fo:block>Total Quantity</fo:block>
      </fo:table-cell>

      <fo:table-cell>
        <fo:block xsl:use-attribute-sets="quantity-block-style">
          <xsl:if test="boolean($totalLong) and $totalLong != 0">
            <xsl:value-of select="stmtext:formatNumber($totalLong, 0)" />
          </xsl:if>
        </fo:block>
      </fo:table-cell>

      <fo:table-cell>
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

      <fo:table-cell>
        <fo:block xsl:use-attribute-sets="quantity-block-style">
          <xsl:value-of select="$name" />
        </fo:block>
      </fo:table-cell>

      <fo:table-cell xsl:use-attribute-sets="left-padded-column-cell-style">
        <fo:block>
          <xsl:value-of select="$currency" />
        </fo:block>
      </fo:table-cell>

      <xsl:for-each
        select="../../..//stmt:row/stmt:bucket[not(contains(@name, 'Total')) and generate-id() = generate-id(key('lifecycleActivityNonTotalFlowsKey', @name)[1])]">
        <xsl:sort select="@name" />
        <xsl:variable
          name="flowName"
          select="@name" />

        <xsl:variable name="flowAmount">
          <xsl:value-of
            select="sum(../../..//stmt:row[../@id = $subsection and @account = $account and @exchange = $exchange and @contractDescription = $contractDescription]/stmt:bucket[@name = $flowName and @currency = $currency]/@amount)" />
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

</xsl:stylesheet>