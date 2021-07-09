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

  <!-- FEES AND COMMISSIONS ADJUSTEMENTS SECTION -->

  <xsl:key
    name="commissionsAdjustmentsKey"
    match="//stmt:section[@id='commissionsAdjustments']/stmt:section/stmt:row"
    use="concat(../@id, ../@currency, @transferType)" />

  <xsl:template match="stmt:section[@id='commissionsAdjustments']">

    <fo:block xsl:use-attribute-sets="section-block-style">

      <xsl:call-template name="sectionTitle">
        <xsl:with-param
          name="title"
          select="'Fees And Commissions Adjustments'" />
        <xsl:with-param
          name="comment"
          select="'Net impact of changes to previously booked charges which are not captured in the Trade Confirmation section'" />
      </xsl:call-template>

      <xsl:if test="boolean(stmt:section)">

        <fo:table xsl:use-attribute-sets="debug-table-format-style content-table-style">
			
			<xsl:if test="$statementType = 'PARENT'">
	          <!-- Account column -->
	          <fo:table-column />
		    </xsl:if>
           <!-- ID column -->
          <fo:table-column />
          <!-- Type column -->
          <fo:table-column />
          <!-- Comment column -->
          <fo:table-column column-width="40%" />
          <!-- Currency column -->
          <fo:table-column column-width="5.5%" />
          <!-- Debit/Credit column -->
          <fo:table-column column-width="10%" />

          <fo:table-header>
            <fo:table-row xsl:use-attribute-sets="content-table-header-row-style">
				<xsl:choose>
			  		<xsl:when test="$statementType = 'PARENT'">
			  			<fo:table-cell xsl:use-attribute-sets="first-column-cell-style">
			               <fo:block>Account</fo:block>
			            </fo:table-cell>
			            <fo:table-cell>
			               <fo:block>Cleared Transaction ID</fo:block>
			            </fo:table-cell>
			      	</xsl:when>
			      	<xsl:otherwise>
			      		<fo:table-cell xsl:use-attribute-sets="first-column-cell-style">
			               <fo:block>Cleared Transaction ID</fo:block>
			            </fo:table-cell>	
			      	</xsl:otherwise>
				</xsl:choose>
              
              <fo:table-cell>
                <fo:block>Charge Type</fo:block>
              </fo:table-cell>
              <fo:table-cell>
                <fo:block>Comment</fo:block>
              </fo:table-cell>
              <fo:table-cell xsl:use-attribute-sets="left-padded-column-cell-style">
                <fo:block>Ccy</fo:block>
              </fo:table-cell>
              <fo:table-cell xsl:use-attribute-sets="last-column-cell-style">
                <fo:block xsl:use-attribute-sets="quantity-block-style">Debit/Credit</fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-header>

          <fo:table-body>
            <xsl:apply-templates select="stmt:section">
              <xsl:sort select="@id" />
              <xsl:sort select="@currency" />
            </xsl:apply-templates>
          </fo:table-body>

        </fo:table>

      </xsl:if>

      <xsl:call-template name="emptySectionComment">
        <xsl:with-param
          name="content"
          select="stmt:section" />
      </xsl:call-template>

    </fo:block>

  </xsl:template>

  <xsl:template match="stmt:section[@id='commissionsAdjustments']/stmt:section">
    <xsl:variable name="isEvenRow">
      <xsl:if test="(position() mod 2) = 0">
        <xsl:value-of select="'true'" />
      </xsl:if>
    </xsl:variable>

    <!-- Transfer rows -->
    <xsl:apply-templates
      select="stmt:row"
      mode="commissionsAdjustments">
      <xsl:sort select="@id" />
      <xsl:sort select="@transferType" />
      <xsl:with-param
        name="isEvenRow"
        select="$isEvenRow" />
    </xsl:apply-templates>

    <!-- Grand total -->
    <xsl:call-template name="commissionsAdjustmentsTotal">
      <xsl:with-param
        name="isEvenRow"
        select="$isEvenRow" />
      <xsl:with-param
        name="type"
        select="'Total Charges'" />
      <xsl:with-param
        name="currency"
        select="@currency" />
      <xsl:with-param name="total">
        <xsl:value-of select="sum(stmt:row/@debitCredit)" />
      </xsl:with-param>
    </xsl:call-template>

  </xsl:template>

  <xsl:template
    match="stmt:row"
    mode="commissionsAdjustments">
    <xsl:param name="isEvenRow" />
    <xsl:variable
      name="currency"
      select="../@currency" />

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
          <xsl:value-of select="@transferType" />
        </fo:block>
      </fo:table-cell>
      <fo:table-cell>
        <fo:block>
          <xsl:value-of select="@comment" />
        </fo:block>
      </fo:table-cell>
      <fo:table-cell xsl:use-attribute-sets="left-padded-column-cell-style">
        <fo:block>
          <xsl:value-of select="$currency" />
        </fo:block>
      </fo:table-cell>
      <fo:table-cell xsl:use-attribute-sets="last-column-cell-style">
        <fo:block xsl:use-attribute-sets="quantity-block-style">
          <xsl:value-of select="stmtext:formatNumber(@debitCredit, $currency)" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
  </xsl:template>

  <xsl:template name="commissionsAdjustmentsTotal">
    <xsl:param name="isEvenRow" />
    <xsl:param name="type" />
    <xsl:param name="total" />
    <xsl:param name="currency" />

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
      
      <fo:table-cell number-columns-spanned="3">
        <fo:block xsl:use-attribute-sets="subtotal-label-block-style">
          <xsl:value-of select="$type" />
        </fo:block>
      </fo:table-cell>

      <fo:table-cell xsl:use-attribute-sets="left-padded-column-cell-style">
        <fo:block>
          <xsl:value-of select="$currency" />
        </fo:block>
      </fo:table-cell>

      <fo:table-cell xsl:use-attribute-sets="last-column-cell-style">
        <fo:block xsl:use-attribute-sets="quantity-block-style">
          <xsl:value-of select="stmtext:formatNumber($total, $currency)" />
        </fo:block>
      </fo:table-cell>

    </fo:table-row>

  </xsl:template>


</xsl:stylesheet>