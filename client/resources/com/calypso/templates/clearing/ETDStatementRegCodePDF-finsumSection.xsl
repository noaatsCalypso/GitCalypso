<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:stmt="urn:com:calypso:clearing:statement:etd"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:stmtext="xalan://com.calypso.tk.bo.StatementDataTypeFormatter"
	extension-element-prefixes="stmtext"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	exclude-result-prefixes="xs fo stmtext">

	<xsl:variable name="hasDiscountedPositions"
		select="boolean(//stmt:section[@id='openPositions']/stmt:row[@disc = 'true'])" />


  <!-- FINANCIAL SUMMARY SECTION -->

	<xsl:attribute-set name="finsum-table-style"
		use-attribute-sets="content-table-style">
		<xsl:attribute name="font-size">0.8em</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="finsum-cell-style">
		<xsl:attribute name="padding-left">2px</xsl:attribute>
		<xsl:attribute name="padding-right">2px</xsl:attribute>
		<xsl:attribute name="padding-before">1px</xsl:attribute>
		<xsl:attribute name="padding-after">1px</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="finsum-cell-evenRow-style">
		<xsl:attribute name="padding-left">2px</xsl:attribute>
		<xsl:attribute name="padding-right">2px</xsl:attribute>
		<xsl:attribute name="padding-before">1px</xsl:attribute>
		<xsl:attribute name="padding-after">1px</xsl:attribute>
		<xsl:attribute name="background-color"><xsl:value-of select="$INDIGO050" /></xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:template name="template-finsum-cell-evenRow-style">
		<xsl:attribute name="padding-left">2px</xsl:attribute>
		<xsl:attribute name="padding-right">2px</xsl:attribute>
		<xsl:attribute name="padding-before">1px</xsl:attribute>
		<xsl:attribute name="padding-after">1px</xsl:attribute>
		<xsl:attribute name="background-color"><xsl:value-of select="$INDIGO050" /></xsl:attribute>
	</xsl:template>
	
	<xsl:template name="template-finsum-cell-style">
		<xsl:attribute name="padding-left">2px</xsl:attribute>
		<xsl:attribute name="padding-right">2px</xsl:attribute>
		<xsl:attribute name="padding-before">1px</xsl:attribute>
		<xsl:attribute name="padding-after">1px</xsl:attribute>
	</xsl:template>
	
	<xsl:key name="financialSummaryKey"
		match="stmt:section[@id='financialSummary']/stmt:row" use="concat(@currency,'+',@RegCode)" />

	<xsl:template name="financialSummaryCurrencyHeader">
		<xsl:param name="currency" />
		<fo:table-cell
			xsl:use-attribute-sets="finsum-cell-style">
			<fo:block xsl:use-attribute-sets="quantity-block-style">
				<xsl:value-of select="$currency" />
			</fo:block>
		</fo:table-cell>
	</xsl:template>

	<xsl:template name="financialSummarySeparatorRow">
		<fo:table-row>
			<fo:table-cell>
				<fo:block>&#160;</fo:block>
			</fo:table-cell>
		</fo:table-row>
	</xsl:template>

	<xsl:template match="stmt:section[@id='financialSummary']">

		<xsl:variable name="isOTE"
			select="boolean(//stmt:section[@id = 'metadata']/@marginMode = 'OTE')" />
		<xsl:variable name="isRealized"
			select="boolean(//stmt:section[@id = 'metadata']/@marginMode = 'RealizedVM')" />
		<xsl:variable name="isDailyFrequency"
			select="boolean(//stmt:section[@id = 'metadata']/@statementFrequency = 'DAILY')" />
    <!-- pageSize represents the number of currencies per page -->
		<xsl:variable name="pageSize" select="$finsumPageSize" />

		<xsl:variable name="numCurrencies"
			select="count(stmt:row[generate-id() = generate-id(key('financialSummaryKey', concat(@currency,'+',@RegCode)))])" />

		<xsl:variable name="numPages"
			select="ceiling($numCurrencies div $pageSize)" />


	    <!-- Uncomment when debugging pagination issues -->
	     
	    <!-- <fo:block>
	      <xsl:value-of select="concat('PAGE SIZE: ', $pageSize)"></xsl:value-of>
	    </fo:block>
	    <fo:block>
	      <xsl:value-of select="concat('NUM CURRENCIES : ', $numCurrencies)"></xsl:value-of>
	    </fo:block>
	    <fo:block>
	      <xsl:value-of select="concat('NUM PAGES: ', $numPages)"></xsl:value-of>
	    </fo:block> -->
     

		<fo:block xsl:use-attribute-sets="section-block-style">

			<xsl:call-template name="sectionTitle">
				<xsl:with-param name="title"
					select="'Financial Summary'" />
			</xsl:call-template>

      <!-- At least one page of currencies -->
			<xsl:call-template name="financialSummaryPageTable">
				<xsl:with-param name="isRealized"
					select="$isRealized" />
				<xsl:with-param name="isOTE" select="$isOTE" />
				<xsl:with-param name="pageSize" select="$pageSize" />
				<xsl:with-param name="page" select="1" />
			</xsl:call-template>

			<xsl:if test="$numPages &gt; 1">
				<xsl:call-template
					name="financialSummaryPageTable">
					<xsl:with-param name="isRealized"
						select="$isRealized" />
					<xsl:with-param name="isOTE" select="$isOTE" />
					<xsl:with-param name="pageSize" select="$pageSize" />
					<xsl:with-param name="page" select="2" />
				</xsl:call-template>
			</xsl:if>

			<xsl:if test="$numPages &gt; 2">
				<xsl:call-template
					name="financialSummaryPageTable">
					<xsl:with-param name="isRealized"
						select="$isRealized" />
					<xsl:with-param name="isOTE" select="$isOTE" />
					<xsl:with-param name="pageSize" select="$pageSize" />
					<xsl:with-param name="page" select="3" />
				</xsl:call-template>
			</xsl:if>

			<xsl:if test="$numPages &gt; 3">
				<xsl:call-template
					name="financialSummaryPageTable">
					<xsl:with-param name="isRealized"
						select="$isRealized" />
					<xsl:with-param name="isOTE" select="$isOTE" />
					<xsl:with-param name="pageSize" select="$pageSize" />
					<xsl:with-param name="page" select="4" />
				</xsl:call-template>
			</xsl:if>

		</fo:block>

	</xsl:template>

	<xsl:template name="financialSummaryPageTable">

		<xsl:param name="page" />
		<xsl:param name="pageSize" />
		<xsl:param name="isRealized" />
		<xsl:param name="isOTE" />

		<xsl:variable name="minPosition"
			select="(($page - 1) * $pageSize) + 1" />
		<xsl:variable name="maxPosition"
			select="(($page - 1) * $pageSize) + $pageSize" />


    <!-- Uncomment when debugging pagination issues -->
    <!-- 
    <fo:block>
      <xsl:value-of select="concat('PAGE: ', $page)"></xsl:value-of>
    </fo:block>
    <fo:block>
      <xsl:value-of select="concat('PAGE SIZE: ', $pageSize)"></xsl:value-of>
    </fo:block>
    <fo:block>
      <xsl:value-of select="concat('MIN: ', $minPosition)"></xsl:value-of>
    </fo:block>
    <fo:block>
      <xsl:value-of select="concat('MAX: ', $maxPosition)"></xsl:value-of>
    </fo:block>
    -->

		<fo:table
			xsl:use-attribute-sets="debug-table-format-style finsum-table-style">

			<xsl:if test="$page > 1">
				<xsl:attribute name="page-break-before">always</xsl:attribute>
			</xsl:if>

      <!-- Concepts column -->
			<fo:table-column column-width="25%" />

      <!-- Currencies in current page -->
			<xsl:for-each
				select="stmt:row[generate-id() = generate-id(key('financialSummaryKey', concat(@currency,'+',@RegCode))[1])]">
        <!-- Hacky: sort first by currency name length, leaving base currency last -->
				<xsl:sort select="string-length(@currency)"
					data-type="number" />
				<xsl:sort select="@currency" />
				<xsl:if
					test="position() &gt;= $minPosition and position() &lt;= $maxPosition">
					<fo:table-column />
				</xsl:if>
			</xsl:for-each>

			<fo:table-header
				xsl:use-attribute-sets="content-table-header-style">
				<fo:table-row>
					<fo:table-cell>
						<fo:block />
					</fo:table-cell>

					<xsl:for-each
						select="stmt:row[generate-id() = generate-id(key('financialSummaryKey', concat(@currency,'+',@RegCode))[1])]">
						<xsl:sort select="string-length(@currency)"
							data-type="number" />
						<xsl:sort select="@currency" />
						<xsl:if
							test="position() &gt;= $minPosition and position() &lt;= $maxPosition">
							<xsl:call-template
								name="financialSummaryCurrencyHeader">
								<xsl:with-param name="currency"
									select="@currency" />
							</xsl:call-template>
						</xsl:if>
					</xsl:for-each>

				</fo:table-row>
			</fo:table-header>

			<fo:table-body>
				
				<xsl:call-template name="financialSummaryRow">
					<xsl:with-param name="title"
						select="'Regulatory Code'" />
					<xsl:with-param name="isSubtotalRow" select="'true'" />
					<xsl:with-param name="minPosition"
						select="$minPosition" />
					<xsl:with-param name="maxPosition"
						select="$maxPosition" />
				</xsl:call-template>
				
				<xsl:call-template name="financialSummaryRow">
					<xsl:with-param name="title"
						select="'Opening Balance'" />
					<xsl:with-param name="isSubtotalRow" select="'true'" />
					<xsl:with-param name="minPosition"
						select="$minPosition" />
					<xsl:with-param name="maxPosition"
						select="$maxPosition" />
				</xsl:call-template>

				<xsl:call-template name="financialSummaryRow">
					<xsl:with-param name="title" select="'Commissions'" />
					<xsl:with-param name="minPosition"
						select="$minPosition" />
					<xsl:with-param name="maxPosition"
						select="$maxPosition" />
				</xsl:call-template>

				<xsl:call-template name="financialSummaryRow">
					<xsl:with-param name="title" select="'Exchange Fees'" />
					<xsl:with-param name="isEvenRow" select="'true'" />
					<xsl:with-param name="minPosition"
						select="$minPosition" />
					<xsl:with-param name="maxPosition"
						select="$maxPosition" />
				</xsl:call-template>
				
				<xsl:choose>
					<xsl:when test="stmt:row[@id='Brokerage' and @value!=0] and stmt:row[@id='NFA']">
						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title" select="'Brokerage'" />
							<xsl:with-param name="minPosition"
								select="$minPosition" />
							<xsl:with-param name="maxPosition"
								select="$maxPosition" />
						</xsl:call-template>
						
						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title" select="'NFA'" />
							<xsl:with-param name="isEvenRow" select="'true'" />
							<xsl:with-param name="minPosition"
								select="$minPosition" />
							<xsl:with-param name="maxPosition"
								select="$maxPosition" />
						</xsl:call-template>
						
						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title" select="'Realized PL'" />
							<xsl:with-param name="minPosition"
								select="$minPosition" />
							<xsl:with-param name="maxPosition"
								select="$maxPosition" />
						</xsl:call-template>
						
						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title" select="'Premium'" />
							<xsl:with-param name="isEvenRow" select="'true'" />
							<xsl:with-param name="minPosition"
								select="$minPosition" />
							<xsl:with-param name="maxPosition"
								select="$maxPosition" />
						</xsl:call-template>

						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title"
								select="'Option Cash Settlement'" />
							<xsl:with-param name="minPosition"
								select="$minPosition" />
							<xsl:with-param name="maxPosition"
								select="$maxPosition" />
						</xsl:call-template>

						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title"
								select="'Cash Movements'" />
							<xsl:with-param name="minPosition"
								select="$minPosition" />
							<xsl:with-param name="maxPosition"
								select="$maxPosition" />
							<xsl:with-param name="isEvenRow" select="'true'" />
						</xsl:call-template>
					
						<xsl:if test="$isRealized">
							<xsl:call-template name="financialSummaryRow">
								<xsl:with-param name="idToMatch"
									select="'Variation Margin'" />
								<xsl:with-param name="title"
									select="'Variation Margin'" />
								<xsl:with-param name="minPosition"
									select="$minPosition" />
								<xsl:with-param name="maxPosition"
									select="$maxPosition" />
							</xsl:call-template> 
		
							<xsl:if test="$hasDiscountedPositions">
								<xsl:call-template name="financialSummaryRow">
									<xsl:with-param name="idToMatch"
										select="'Variation Margin Change (Discounted)'" />
									<xsl:with-param name="title"
										select="'Discounted VM'" />
									<xsl:with-param name="minPosition"
										select="$minPosition" />
									<xsl:with-param name="maxPosition"
										select="$maxPosition" />
									<xsl:with-param name="isEvenRow" select="'true'" />
								</xsl:call-template>
							</xsl:if>
						</xsl:if>
					</xsl:when>
					<xsl:when test="stmt:row[@id='Brokerage' and @value!=0]">
						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title" select="'Brokerage'" />
							<xsl:with-param name="minPosition"
								select="$minPosition" />
							<xsl:with-param name="maxPosition"
								select="$maxPosition" />
						</xsl:call-template>
						
						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title" select="'Realized PL'" />
							<xsl:with-param name="isEvenRow" select="'true'" />
							<xsl:with-param name="minPosition"
								select="$minPosition" />
							<xsl:with-param name="maxPosition"
								select="$maxPosition" />
						</xsl:call-template>
						
						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title" select="'Premium'" />
							<xsl:with-param name="minPosition"
								select="$minPosition" />
							<xsl:with-param name="maxPosition"
								select="$maxPosition" />
						</xsl:call-template>

						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title"
								select="'Option Cash Settlement'" />
							<xsl:with-param name="isEvenRow" select="'true'" />
							<xsl:with-param name="minPosition"
								select="$minPosition" />
							<xsl:with-param name="maxPosition"
								select="$maxPosition" />
						</xsl:call-template>

						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title"
								select="'Cash Movements'" />
							<xsl:with-param name="minPosition"
								select="$minPosition" />
							<xsl:with-param name="maxPosition"
								select="$maxPosition" />
						</xsl:call-template>
					
						<xsl:if test="$isRealized">
							<xsl:call-template name="financialSummaryRow">
								<xsl:with-param name="idToMatch"
									select="'Variation Margin'" />
								<xsl:with-param name="isEvenRow" select="'true'" />
								<xsl:with-param name="title"
									select="'Variation Margin'" />
								<xsl:with-param name="minPosition"
									select="$minPosition" />
								<xsl:with-param name="maxPosition"
									select="$maxPosition" />
							</xsl:call-template>
		
							<xsl:if test="$hasDiscountedPositions">
								<xsl:call-template name="financialSummaryRow">
									<xsl:with-param name="idToMatch"
										select="'Variation Margin Change (Discounted)'" />
									<xsl:with-param name="title"
										select="'Discounted VM'" />
									<xsl:with-param name="minPosition"
										select="$minPosition" />
									<xsl:with-param name="maxPosition"
										select="$maxPosition" />
								</xsl:call-template>
							</xsl:if>
						</xsl:if>
					</xsl:when>
					<xsl:when test="stmt:row[@id='NFA']">
						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title" select="'NFA'" />
							<xsl:with-param name="minPosition"
								select="$minPosition" />
							<xsl:with-param name="maxPosition"
								select="$maxPosition" />
						</xsl:call-template>
						
						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title" select="'Realized PL'" />
							<xsl:with-param name="isEvenRow" select="'true'" />
							<xsl:with-param name="minPosition"
								select="$minPosition" />
							<xsl:with-param name="maxPosition"
								select="$maxPosition" />
						</xsl:call-template>
						
						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title" select="'Premium'" />
							<xsl:with-param name="minPosition"
								select="$minPosition" />
							<xsl:with-param name="maxPosition"
								select="$maxPosition" />
						</xsl:call-template>

						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title"
								select="'Option Cash Settlement'" />
							<xsl:with-param name="isEvenRow" select="'true'" />
							<xsl:with-param name="minPosition"
								select="$minPosition" />
							<xsl:with-param name="maxPosition"
								select="$maxPosition" />
						</xsl:call-template>

						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title"
								select="'Cash Movements'" />
							<xsl:with-param name="minPosition"
								select="$minPosition" />
							<xsl:with-param name="maxPosition"
								select="$maxPosition" />
						</xsl:call-template>
					
						<xsl:if test="$isRealized">
							<xsl:call-template name="financialSummaryRow">
								<xsl:with-param name="idToMatch"
									select="'Variation Margin'" />
								<xsl:with-param name="isEvenRow" select="'true'" />
								<xsl:with-param name="title"
									select="'Variation Margin'" />
								<xsl:with-param name="minPosition"
									select="$minPosition" />
								<xsl:with-param name="maxPosition"
									select="$maxPosition" />
							</xsl:call-template>
		
							<xsl:if test="$hasDiscountedPositions">
								<xsl:call-template name="financialSummaryRow">
									<xsl:with-param name="idToMatch"
										select="'Variation Margin Change (Discounted)'" />
									<xsl:with-param name="title"
										select="'Discounted VM'" />
									<xsl:with-param name="minPosition"
										select="$minPosition" />
									<xsl:with-param name="maxPosition"
										select="$maxPosition" />
								</xsl:call-template>
							</xsl:if>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title" select="'Realized PL'" />
							<xsl:with-param name="minPosition"
								select="$minPosition" />
							<xsl:with-param name="maxPosition"
								select="$maxPosition" />
						</xsl:call-template>
		
						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title" select="'Premium'" />
							<xsl:with-param name="isEvenRow" select="'true'" />
							<xsl:with-param name="minPosition"
								select="$minPosition" />
							<xsl:with-param name="maxPosition"
								select="$maxPosition" />
						</xsl:call-template>
		
						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title"
								select="'Option Cash Settlement'" />
							<xsl:with-param name="minPosition"
								select="$minPosition" />
							<xsl:with-param name="maxPosition"
								select="$maxPosition" />
						</xsl:call-template>
		
						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title"
								select="'Cash Movements'" />
							<xsl:with-param name="isEvenRow" select="'true'" />
							<xsl:with-param name="minPosition"
								select="$minPosition" />
							<xsl:with-param name="maxPosition"
								select="$maxPosition" />
						</xsl:call-template>
		
						<xsl:if test="$isRealized">
							<xsl:call-template name="financialSummaryRow">
								<xsl:with-param name="idToMatch"
									select="'Variation Margin'" />
								<xsl:with-param name="title"
									select="'Variation Margin'" />
								<xsl:with-param name="minPosition"
									select="$minPosition" />
								<xsl:with-param name="maxPosition"
									select="$maxPosition" />
							</xsl:call-template> 
		
							<xsl:if test="$hasDiscountedPositions">
								<xsl:call-template name="financialSummaryRow">
									<xsl:with-param name="idToMatch"
										select="'Variation Margin Change (Discounted)'" />
									<xsl:with-param name="title"
										select="'Discounted VM'" />
									<xsl:with-param name="minPosition"
										select="$minPosition" />
									<xsl:with-param name="maxPosition"
										select="$maxPosition" />
								</xsl:call-template>
							</xsl:if>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>

				<xsl:call-template name="financialSummaryRow">
					<xsl:with-param name="title"
						select="'Closing Balance'" />
					<xsl:with-param name="isSubtotalRow" select="'true'" />
					<xsl:with-param name="minPosition"
						select="$minPosition" />
					<xsl:with-param name="maxPosition"
						select="$maxPosition" />
				</xsl:call-template>

				<!-- xsl:call-template name="financialSummarySeparatorRow" /  -->

        <!-- Zebra striping affected by OTE vs Realized and Discounted OTE presence -->

				<xsl:if test="$isOTE">
					<xsl:call-template name="financialSummaryRow">
						<xsl:with-param name="title"
							select="'Open Trade Equity'" />
						<xsl:with-param name="idToMatch"
							select="'Open Trade Equity'" />
						<xsl:with-param name="isEvenRow">
							<xsl:if test="$hasDiscountedPositions">
								<xsl:value-of select="'true'" />
							</xsl:if>
						</xsl:with-param>
						<xsl:with-param name="minPosition"
							select="$minPosition" />
						<xsl:with-param name="maxPosition"
							select="$maxPosition" />
					</xsl:call-template>

					<xsl:if test="$hasDiscountedPositions">
						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title"
								select="'Discounted Open Trade Equity'" />
							<xsl:with-param name="idToMatch"
								select="'Open Trade Equity (Discounted)'" />
							<xsl:with-param name="isEvenRow" select="'true'" />
							<xsl:with-param name="minPosition"
								select="$minPosition" />
							<xsl:with-param name="maxPosition"
								select="$maxPosition" />
						</xsl:call-template>
					</xsl:if>

				</xsl:if>

				<xsl:call-template name="financialSummaryRow">
					<xsl:with-param name="title"
						select="'Net Option Value'" />
					<xsl:with-param name="isEvenRow">
							<xsl:if test="$isOTE and not($hasDiscountedPositions)">
								<xsl:value-of select="'true'" />
							</xsl:if>
					</xsl:with-param>
					<xsl:with-param name="minPosition"
						select="$minPosition" />
					<xsl:with-param name="maxPosition"
						select="$maxPosition" />
				</xsl:call-template>

				<xsl:call-template name="financialSummaryRow">
					<xsl:with-param name="title">
						<xsl:choose>
							<xsl:when test="$isDailyFrequency">
								<xsl:value-of select="'Account Liquidating Value'" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="'Net Liquidating Value'" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
					<xsl:with-param name="idToMatch"
								select="'Account Liquidating Value'" />
					<xsl:with-param name="isSubtotalRow" select="'true'" />
					<xsl:with-param name="minPosition"
						select="$minPosition" />
					<xsl:with-param name="maxPosition"
						select="$maxPosition" />
				</xsl:call-template>

				<!-- xsl:call-template name="financialSummarySeparatorRow" /  -->

		        <xsl:call-template name="financialSummaryRow">
		          <xsl:with-param name="title"
		            select="'Securities on Deposit'" />
		          <xsl:with-param name="minPosition"
		            select="$minPosition" />
		          <xsl:with-param name="maxPosition"
		            select="$maxPosition" />
		        </xsl:call-template>
			    
			    <xsl:call-template name="financialSummaryRow">
		          <xsl:with-param name="title"
		            select="'Margin Equity'" />
		          <xsl:with-param name="isEvenRow" select="'true'" />
		          <xsl:with-param name="minPosition"
		            select="$minPosition" />
		          <xsl:with-param name="maxPosition"
		            select="$maxPosition" />
		        </xsl:call-template>
		        
				<xsl:call-template
					name="financialSummaryMarginSubsection">
					<xsl:with-param name="isRealized"
						select="$isRealized" />
					<xsl:with-param name="isOTE" select="$isOTE" />
					<xsl:with-param name="minPosition"
						select="$minPosition" />
					<xsl:with-param name="maxPosition"
						select="$maxPosition" />
				</xsl:call-template>

				<!-- xsl:call-template name="financialSummarySeparatorRow" /  -->

				<fo:table-row>

					<fo:table-cell>
						<xsl:choose>
							<xsl:when test="$isOTE">
								<xsl:call-template name="template-finsum-cell-evenRow-style"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="template-finsum-cell-style"/>
							</xsl:otherwise>
						</xsl:choose>
						<fo:block>
							<xsl:value-of
								select="concat('FX Conversion to ', $statementCurrency)" />
						</fo:block>
					</fo:table-cell>
					<xsl:for-each
						select="stmt:row[generate-id() = generate-id(key('financialSummaryKey', concat(@currency,'+',@RegCode))[1])]">
						<xsl:sort select="string-length(@currency)"
							data-type="number" />
						<xsl:sort select="@currency" />
						<xsl:if
							test="position() &gt;= $minPosition and position() &lt;= $maxPosition">
							<xsl:variable name="ccy" select="@currency" />
							<fo:table-cell>
								<xsl:choose>
									<xsl:when test="$isOTE">
										<xsl:call-template name="template-finsum-cell-evenRow-style"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="template-finsum-cell-style"/>
									</xsl:otherwise>
								</xsl:choose>
								<fo:block xsl:use-attribute-sets="quantity-block-style">
									<xsl:if test="not(contains(@currency, 'Base'))">
										<xsl:value-of
											select="stmtext:formatFXRate(../stmt:row[@currency=$ccy and @id='FX Rate']/@value, $statementCurrency, $ccy)" />
									</xsl:if>
								</fo:block>
							</fo:table-cell>
						</xsl:if>
					</xsl:for-each>

				</fo:table-row>

				<xsl:call-template name="financialSummaryRow">
					<xsl:with-param name="title"
						select="'Converted Net Liquidating Value'" />
					<xsl:with-param name="isSubtotalRow" select="'true'" />
					<xsl:with-param name="minPosition"
						select="$minPosition" />
					<xsl:with-param name="maxPosition"
						select="$maxPosition" />
				</xsl:call-template>

			</fo:table-body>

		</fo:table>
	</xsl:template>

	<xsl:template name="financialSummaryMarginSubsection">
		<xsl:param name="isRealized" />
		<xsl:param name="isOTE" />
		<xsl:param name="minPosition" />
		<xsl:param name="maxPosition" />

		<xsl:call-template name="financialSummaryRow">
			<xsl:with-param name="idToMatch"
				select="'Total Margin Requirement'" />
			<xsl:with-param name="title" select="'Initial Margin'" />
			<xsl:with-param name="minPosition"
				select="$minPosition" />
			<xsl:with-param name="maxPosition"
				select="$maxPosition" />
		</xsl:call-template>

        <xsl:call-template name="financialSummaryRow">
          <xsl:with-param name="title"
            select="'Maintenance Margin'" />
          <xsl:with-param name="isEvenRow" select="'true'" />
          <xsl:with-param name="minPosition"
            select="$minPosition" />
          <xsl:with-param name="maxPosition"
            select="$maxPosition" />
        </xsl:call-template>

		<!-- <xsl:call-template name="financialSummaryRow">
			<xsl:with-param name="idToMatch"
				select="'Total Margin Requirement Change'" />
			<xsl:with-param name="title"
				select="'Initial Margin Change'" />
			<xsl:with-param name="minPosition"
				select="$minPosition" />
			<xsl:with-param name="maxPosition"
				select="$maxPosition" />
			</xsl:call-template> 
		-->

		<xsl:if test="$isRealized">
			<xsl:call-template name="financialSummaryRow">
				<xsl:with-param name="idToMatch"
					select="'Variation Margin Balance'" />
				<xsl:with-param name="title"
					select="'Open Trade Equity'" />
				<xsl:with-param name="minPosition"
					select="$minPosition" />
				<xsl:with-param name="maxPosition"
					select="$maxPosition" />
			</xsl:call-template>

			<xsl:if test="$hasDiscountedPositions">
				<xsl:call-template name="financialSummaryRow">
					<xsl:with-param name="title"
						select="'Discounted Variation Margin (OTE)'" />
					<xsl:with-param name="idToMatch"
						select="'Variation Margin (Discounted)'" />
					<xsl:with-param name="minPosition"
						select="$minPosition" />
					<xsl:with-param name="maxPosition"
						select="$maxPosition" />
				</xsl:call-template>
			</xsl:if>
		</xsl:if>

		<xsl:if test="$isOTE">
			<!-- 
				<xsl:call-template name="financialSummaryRow">
				<xsl:with-param name="idToMatch"
					select="'Open Trade Equity Change'" />
				<xsl:with-param name="title"
					select="'Variation Margin Change'" />
				<xsl:with-param name="isEvenRow" select="'true'" />	
				<xsl:with-param name="minPosition"
					select="$minPosition" />
				<xsl:with-param name="maxPosition"
					select="$maxPosition" />
				</xsl:call-template>
			-->

			<xsl:if test="$hasDiscountedPositions">
				<xsl:call-template name="financialSummaryRow">
					<xsl:with-param name="idToMatch"
						select="'Open Trade Equity Change (Discounted)'" />
					<xsl:with-param name="title"
						select="'Discounted VM Change'" />
					<xsl:with-param name="minPosition"
						select="$minPosition" />
					<xsl:with-param name="maxPosition"
						select="$maxPosition" />
				</xsl:call-template>
			</xsl:if>
		</xsl:if>

		<xsl:if test="$isRealized">
	        <xsl:call-template name="financialSummaryRow">
	          <xsl:with-param name="title"
	            select="'Margin Excess/Deficit'" />
	          <xsl:with-param name="isEvenRow"
	            select="$hasDiscountedPositions" />
	          <xsl:with-param name="minPosition"
	            select="$minPosition" />
	          <xsl:with-param name="maxPosition"
	            select="$maxPosition" />
	       	 <xsl:with-param name="isEvenRow" select="'true'" />	
	        </xsl:call-template>
		</xsl:if>
		
		<xsl:if test="$isRealized != 'true'">
	        <xsl:call-template name="financialSummaryRow">
	          <xsl:with-param name="title"
	            select="'Margin Excess/Deficit'" />
	          <xsl:with-param name="isEvenRow"
	            select="$hasDiscountedPositions" />
	          <xsl:with-param name="minPosition"
	            select="$minPosition" />
	          <xsl:with-param name="maxPosition"
	            select="$maxPosition" />
	        </xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="financialSummaryRow">
		<xsl:param name="title" />
		<xsl:param name="regcode"/>
		<xsl:param name="isSubtotalRow" />
		<xsl:param name="isEvenRow" />
		<xsl:param name="idToMatch" select="$title" />
		<xsl:param name="minPosition" />
		<xsl:param name="maxPosition" />

		<fo:table-row>
			<xsl:choose>
				<xsl:when test="$isSubtotalRow = 'true'">
					<xsl:call-template
						name="finsumSubtotalRowAttributes" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="contentRowAttributes">
						<xsl:with-param name="isEvenRow"
							select="$isEvenRow" />
						<xsl:with-param name="evenRowColor"
							select="$INDIGO050" />
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>

			<fo:table-cell
				xsl:use-attribute-sets="finsum-cell-style">
				<fo:block>
					<xsl:value-of select="$title" />
				</fo:block>
			</fo:table-cell>

			<xsl:for-each
				select="stmt:row[generate-id() = generate-id(key('financialSummaryKey', concat(@currency,'+',@RegCode))[1])]">

				<xsl:sort select="string-length(@currency)"
					data-type="number" />
				<xsl:sort select="@currency" />
				
				<xsl:if
					test="position() &gt;= $minPosition and position() &lt;= $maxPosition">

					<xsl:variable name="ccy" select="@currency" />
					<xsl:variable name="regID" select="'Regulatory Code'" />
					<xsl:variable name="regcode" select= "@RegCode" />
					<xsl:choose>
						<xsl:when test="$idToMatch = $regID">
							<fo:table-cell
								xsl:use-attribute-sets="finsum-cell-style">
								<fo:block xsl:use-attribute-sets="quantity-block-style">
									<xsl:value-of select="@RegCode" />
								</fo:block>
							</fo:table-cell>
						</xsl:when>
						<xsl:otherwise>
							<fo:table-cell
								xsl:use-attribute-sets="finsum-cell-style">
								<fo:block xsl:use-attribute-sets="quantity-block-style">
									<xsl:if test= "$regcode = '30.7 SECURED'">
										<xsl:value-of
											select="stmtext:formatNumber(../stmt:row[@currency=$ccy and @RegCode='30.7 SECURED' and @id=$idToMatch]/@value, $ccy)" />
									</xsl:if>
									<xsl:if test= "$regcode = 'SEG'">
										<xsl:value-of
											select="stmtext:formatNumber(../stmt:row[@currency=$ccy and @RegCode='SEG' and @id=$idToMatch]/@value, $ccy)" />
									</xsl:if>
									<xsl:if test= "$regcode = 'Total'">
										<xsl:value-of
											select="stmtext:formatNumber(../stmt:row[@currency=$ccy and @RegCode='Total' and @id=$idToMatch]/@value, $ccy)" />
									</xsl:if>
								</fo:block>
							</fo:table-cell>
						</xsl:otherwise>			
					</xsl:choose>

				</xsl:if>
			</xsl:for-each>

		</fo:table-row>

	</xsl:template>


</xsl:stylesheet>

