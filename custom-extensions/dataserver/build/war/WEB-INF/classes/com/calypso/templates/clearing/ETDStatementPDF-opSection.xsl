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

  <!-- OPEN POSITIONS SECTION -->

  <xsl:key
    name="openPositionKey"
    match="stmt:section[@id='openPositions']/stmt:row"
    use="concat(@account, @exchange, @contractDescription)" />

  <xsl:template match="stmt:section[@id='openPositions']">
    <fo:block xsl:use-attribute-sets="section-block-style">

      <xsl:call-template name="sectionTitle">
        <xsl:with-param
          name="title"
          select="'Open Positions'" />
      </xsl:call-template>

      <xsl:if test="boolean(stmt:row)">

        <fo:table xsl:use-attribute-sets="debug-table-format-style content-table-style">

		<xsl:choose>
	  		<xsl:when test="$statementType = 'PARENT'">
	      		<!-- Account column -->
		        <fo:table-column column-width="6%" />
				<!-- ID column -->
		        <fo:table-column column-width="6%" />
	      	</xsl:when>
	      	<xsl:otherwise>
	      		<!-- ID column -->
		        <fo:table-column column-width="6%" />
	      	</xsl:otherwise>
		</xsl:choose>
          
          <!-- Trade Date column -->
          <fo:table-column column-width="6%" />
          <!-- Origin column -->
          <fo:table-column column-width="4%" />
          <!-- Long column -->
          <fo:table-column column-width="4%" />
          <!-- Short column -->
          <fo:table-column column-width="4%" />
          <!-- Type column -->
          <fo:table-column column-width="5%" />
          <!-- Symbol column -->
          <fo:table-column column-width="5%" />
          <!-- Strike column -->
          <fo:table-column column-width="5%" />
          <!-- Prompt Month column -->
          <fo:table-column column-width="4%" />
          <!-- Expiry Date column -->
          <fo:table-column column-width="7%" />
          <!-- Exchange column -->
          <fo:table-column />
          <!-- Trade Price column -->
          <fo:table-column column-width="8%" />
          <!-- Close Price column -->
          <fo:table-column column-width="8%" />
          <!-- Currency column -->
          <fo:table-column column-width="5.5%" />
          <!-- Debit/Credit column -->
          <fo:table-column column-width="15%" />

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
                <fo:block>Origin</fo:block>
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
              <fo:table-cell>
                <fo:block xsl:use-attribute-sets="quantity-block-style">Close Price</fo:block>
              </fo:table-cell>
              <fo:table-cell xsl:use-attribute-sets="left-padded-column-cell-style">
                <fo:block>Ccy</fo:block>
              </fo:table-cell>
              <fo:table-cell xsl:use-attribute-sets="last-column-cell-style">
                <fo:block xsl:use-attribute-sets="quantity-block-style">Open Trade Equity</fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-header>

          <fo:table-body>
            <xsl:apply-templates
              mode="openPositionsGroup"
              select="stmt:row[generate-id() = generate-id(key('openPositionKey', concat(@account, @exchange, @contractDescription))[1])]">
              <xsl:sort select="@account" />
              <xsl:sort select="@ticker" />
              <xsl:sort select="@id" />
            </xsl:apply-templates>
          </fo:table-body>

        </fo:table>
      </xsl:if>

    </fo:block>

    <xsl:call-template name="emptySectionComment">
      <xsl:with-param
        name="content"
        select="stmt:row" />
    </xsl:call-template>

  </xsl:template>

  <xsl:template
    match="stmt:row"
    mode="openPositionsGroup">

    <xsl:variable name="isEvenRow">
      <xsl:if test="(position() mod 2) = 0">
        <xsl:value-of select="'true'" />
      </xsl:if>
    </xsl:variable>

    <xsl:variable name="groupExchange">
      <xsl:value-of select="@exchange" />
    </xsl:variable>
    <xsl:variable name="groupContractDescription">
      <xsl:value-of select="@contractDescription" />
    </xsl:variable>
    <xsl:variable name="groupAccount">
      <xsl:value-of select="@account" />
    </xsl:variable>

    <xsl:apply-templates
      mode="openPositionsRow"
      select="../stmt:row[@account = $groupAccount and @exchange = $groupExchange and @contractDescription = $groupContractDescription]">
      <xsl:sort select="@ticker" />
      <xsl:sort select="@id" />
      <xsl:with-param
        name="isEvenRow"
        select="$isEvenRow" />
    </xsl:apply-templates>

    <xsl:variable
      name="totalLong"
      select="sum(../stmt:row[@account = $groupAccount and @exchange = $groupExchange and @contractDescription = $groupContractDescription and boolean(@long)]/@long)" />
    <xsl:variable
      name="totalShort"
      select="sum(../stmt:row[@account = $groupAccount and @exchange = $groupExchange and @contractDescription = $groupContractDescription and boolean(@short)]/@short)" />

    <xsl:variable
      name="totalValue"
      select="stmtext:formatNumber(sum(../stmt:row[@account = $groupAccount and @exchange=$groupExchange and @contractDescription = $groupContractDescription and boolean(@debitCredit)]/@debitCredit), @currency)" />

    <xsl:variable
      name="totalMarketValue"
      select="stmtext:formatNumber(sum(../stmt:row[@account = $groupAccount and @exchange=$groupExchange and @contractDescription = $groupContractDescription and boolean(@marketValue)]/@marketValue), @currency)" />

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

      <fo:table-cell
        xsl:use-attribute-sets="subtotal-label-block-style"
        number-columns-spanned="3">
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
          <xsl:value-of select="$groupContractDescription" />
        </fo:block>
      </fo:table-cell>

      <fo:table-cell number-columns-spanned="2">
        <fo:block />
      </fo:table-cell>

      <fo:table-cell xsl:use-attribute-sets="left-padded-column-cell-style">
        <fo:block>
          <xsl:value-of select="@currency" />
        </fo:block>
      </fo:table-cell>

      <fo:table-cell xsl:use-attribute-sets="last-column-cell-style">
        <fo:block xsl:use-attribute-sets="quantity-block-style">
          <xsl:if test="not(boolean(@disc)) or @disc = 'false'">
            <xsl:value-of select="$totalValue" />
          </xsl:if>
        </fo:block>
      </fo:table-cell>

    </fo:table-row>

    <xsl:if test="@disc = 'true'">

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
        
        <fo:table-cell number-columns-spanned="8">
          <fo:block />
        </fo:table-cell>
        
        <fo:table-cell
          xsl:use-attribute-sets="subtotal-label-block-style"
          number-columns-spanned="2">
          <fo:block>Discount Factor</fo:block>
        </fo:table-cell>
        
        <fo:table-cell>
          <fo:block xsl:use-attribute-sets="quantity-block-style">
            <xsl:value-of select="stmtext:formatNumber(@df, 6)" />
          </fo:block>
        </fo:table-cell>
        
        <fo:table-cell
          xsl:use-attribute-sets="subtotal-label-block-style"
          number-columns-spanned="2">
          <fo:block>Discounted Variation Margin</fo:block>
        </fo:table-cell>

        <fo:table-cell xsl:use-attribute-sets="left-padded-column-cell-style">
          <fo:block>
            <xsl:value-of select="@currency" />
          </fo:block>
        </fo:table-cell>

        <fo:table-cell xsl:use-attribute-sets="last-column-cell-style">
          <fo:block xsl:use-attribute-sets="quantity-block-style">
            <xsl:value-of select="$totalValue" />
          </fo:block>
        </fo:table-cell>

      </fo:table-row>
      
    </xsl:if>

  </xsl:template>

  <xsl:template
    match="stmt:row"
    mode="openPositionsRow">
    <xsl:param name="isEvenRow" />

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
          <xsl:value-of select="@accountType" />
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
      <fo:table-cell>
        <fo:block xsl:use-attribute-sets="quantity-block-style">
          <xsl:value-of select="stmtext:formatNumberWithQuoteType(@close, number(@productContractDecimals), @quoteType, $useExtendedFuture32)" />
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