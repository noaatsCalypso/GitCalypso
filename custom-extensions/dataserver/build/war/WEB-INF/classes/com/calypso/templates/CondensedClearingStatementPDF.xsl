<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:stmt="urn:com:calypso:clearing:statement" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:stmtext="xalan://com.calypso.tk.bo.StatementDataTypeFormatter" xmlns:exslt="http://exslt.org/common"
	extension-element-prefixes="stmtext  exslt" xmlns:fo="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="xs fo stmtext">

	<xsl:param name="versionParam" select="'1.0'" />
	<xsl:output method="xml" version="1.0" omit-xml-declaration="no" />

	<!-- "CSS" for xsl -->
	<xsl:attribute-set name="cell-style">
		<xsl:attribute name="border-style">solid</xsl:attribute>
		<xsl:attribute name="padding-left">2px</xsl:attribute>
		<xsl:attribute name="padding-right">2px</xsl:attribute>
		<xsl:attribute name="padding-bottom">2px</xsl:attribute>
		<xsl:attribute name="padding-top">2px</xsl:attribute>
		<xsl:attribute name="font-family">Tahoma, Geneva, sans-serif</xsl:attribute>
		<xsl:attribute name="font-size">6px</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="filler-row-style">
		<xsl:attribute name="height">0.14in</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="row-style">
		<xsl:attribute name="height">0.17in</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="subtotal-row-style">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="background-color">#e0f4ff</xsl:attribute>
		<xsl:attribute name="height">0.17in</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="total-row-style">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="background-color">#FFF500</xsl:attribute>
		<xsl:attribute name="height">0.17in</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="filler-cell-style">
		<xsl:attribute name="border-style">none</xsl:attribute>
		<xsl:attribute name="padding-before">3px</xsl:attribute>
		<xsl:attribute name="padding-after">3px</xsl:attribute>
		<xsl:attribute name="padding-end">1px</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="bold-cell-style">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="border-style">solid</xsl:attribute>
		<xsl:attribute name="padding-left">2px</xsl:attribute>
		<xsl:attribute name="padding-right">2px</xsl:attribute>
		<xsl:attribute name="padding-bottom">2px</xsl:attribute>
		<xsl:attribute name="padding-top">2px</xsl:attribute>
		<xsl:attribute name="font-family">Tahoma, Geneva, sans-serif</xsl:attribute>
		<xsl:attribute name="font-size">6px</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="table-style">
		<xsl:attribute name="table-layout">fixed</xsl:attribute>
		<xsl:attribute name="width">100%</xsl:attribute>
		<xsl:attribute name="border-collapse">collapse</xsl:attribute>
		<xsl:attribute name="border-style">solid</xsl:attribute>
		<xsl:attribute name="border-width">1px</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="subtotal-row-style">
		<xsl:attribute name="background-color">#e0f4ff</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="block-style">
		<xsl:attribute name="font-size">7pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="title-style">
		<xsl:attribute name="font-size">12pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="space-before">5mm</xsl:attribute>
		<xsl:attribute name="space-after">3mm</xsl:attribute>
		<xsl:attribute name="font-family">Tahoma, Geneva, sans-serif</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="sub-title-style">
		<xsl:attribute name="font-size">9pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="space-before">5mm</xsl:attribute>
		<xsl:attribute name="space-after">3mm</xsl:attribute>
		<xsl:attribute name="font-family">Tahoma, Geneva, sans-serif</xsl:attribute>
	</xsl:attribute-set>

	<xsl:key name="marginCallActivity" match="stmt:sectionElement[@id='marginCallActivity']/stmt:row/stmt:metaData/stmt:entry[@key='ccp']"
		use="text()" />
	<xsl:key name="pendingMarginCallActivity"
		match="stmt:sectionElement[@id='pendingMarginCallActivity']/stmt:row/stmt:metaData/stmt:entry[@key='ccp']" use="text()" />
	<xsl:key name="clearingServicesKey" match="stmt:sectionElement[@id='initialMarginTable']/stmt:metaData" use="concat(stmt:entry[@key='ccp'], '|', stmt:entry[@key='product'])" />

	<xsl:variable name="baseCurrency">
		<xsl:value-of select="//stmt:ClearingStatement/stmt:metaData/stmt:entry[@key='baseCurrency']" />
	</xsl:variable>

	<xsl:variable name="rawDate">
		<xsl:value-of select="//stmt:ClearingStatement/stmt:metaData/stmt:entry[@key='statementDate']" />
	</xsl:variable>

	<xsl:variable name="pricingEnv">
		<xsl:value-of select="//stmt:ClearingStatement/stmt:metaData/stmt:entry[@key='pricingEnv']" />
	</xsl:variable>

	<xsl:variable name="subtotalRows"
		select="'|Beginning Cash Balance|Ending Cash Balance|Net VM Excess/Deficit|Total IM Requirement|Total Collateral|Total IM Collateral (Pending)|'" />

	<xsl:variable name="totalRows"
		select="'|Net VM Excess/Deficit (Incl. Pending)|Net IM Excess/Deficit|Net IM Excess/Deficit (Incl. Pending)|Net Excess/Deficit'" />

	<xsl:variable name="fillerRows"
		select="'|Intraday Funding Amount|Ending Cash Balance|Net VM Excess/Deficit|Net VM Excess/Deficit (Incl. Pending)|Net Excess/Deficit|Total IM Requirement|Total IM Collateral (Pending)|Total Collateral|Net IM Excess/Deficit|Net IM Excess/Deficit (Incl. Pending)|Net Excess/Deficit|'" />

	<xsl:template match="/stmt:ClearingStatement">
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
			<fo:layout-master-set>
				<fo:simple-page-master master-name="LandscapeLetter" page-height="8.5in" page-width="11.0in"
					margin-top="0.5in" margin-bottom="0.5in" margin-left="0.3in" margin-right="0.3in">
					<fo:region-body />
					<fo:region-after region-name="footer" extent="0.0in" />
				</fo:simple-page-master>
			</fo:layout-master-set>
			<fo:page-sequence master-reference="LandscapeLetter">

				<!-- ================================================= -->
				<!-- PAGE NUMBER -->
				<!-- ================================================= -->
				<fo:static-content flow-name="footer">
					<fo:block text-align="center" font-size="8pt">
						Page
						<fo:page-number />
						of
						<fo:page-number-citation ref-id="last-page" />
					</fo:block>
				</fo:static-content>

				<fo:flow flow-name="xsl-region-body">

					<fo:block>
						<fo:external-graphic src="url('classpath:com/calypso/templates/sample/calypso-logo.png')" content-height="60%" content-width="60%" />
					</fo:block>

					<!-- ================================================= -->
					<!-- TITLE -->
					<!-- ================================================= -->
					<fo:block font-size="16pt" font-weight="bold" text-align="center" padding-before='5px' padding-after='5px'
						font-family="Courier New">
						<xsl:value-of select="stmt:metaData/stmt:entry[@key='mode']" />
						Statement on
						<xsl:value-of select="stmt:metaData/stmt:entry[@key='statementDate']" />
						for
						<xsl:value-of select="stmt:metaData/stmt:entry[@key='receiver']" />
					</fo:block>

					<fo:block xsl:use-attribute-sets="block-style">
						<xsl:value-of select="stmt:metaData/stmt:entry[@key='receiver']" />
					</fo:block>
					<fo:block xsl:use-attribute-sets="block-style">
						<xsl:value-of select="stmt:metaData/stmt:entry[@key='receiverAddress']" />
					</fo:block>
					<fo:block xsl:use-attribute-sets="block-style">
						<xsl:value-of select="stmt:metaData/stmt:entry[@key='receiverCity']" />
						,
						<xsl:value-of select="stmt:metaData/stmt:entry[@key='receiverState']" />
						,
						<xsl:value-of select="stmt:metaData/stmt:entry[@key='receiverZip']" />
					</fo:block>

					<xsl:apply-templates select="stmt:section" />

					<fo:block font-size="8pt" font-weight="bold" space-before="100px" text-align="center">
						Statement generated by Calypso Technology
						<xsl:value-of select="concat(', ', substring(string(stmt:metaData/stmt:entry[@key='statementDate']), 0, 5), '.')" />
					</fo:block>

					<fo:block id="last-page" />
				</fo:flow>
			</fo:page-sequence>
		</fo:root>
	</xsl:template>

	<xsl:template match="stmt:section">
		<xsl:variable name="section" select="." />
		<xsl:variable name="title" select="@id" />
		<xsl:value-of select="stmtext:getTranslation('title', $title)" />

		<xsl:apply-templates select="stmt:sectionElement[@id='clearingCashFlowsSummaryTable']" />
		<xsl:apply-templates select="stmt:sectionElement[@id='newTradesIRS']" />
		<xsl:apply-templates select="stmt:sectionElement[@id='newTradesNDF']" />
		<xsl:apply-templates select="stmt:sectionElement[@id='newTradesCreditDerivatives']" />
		<xsl:apply-templates select="stmt:sectionElement[@id='openTradesIRS']" />
		<xsl:apply-templates select="stmt:sectionElement[@id='openTradesNDF']" />
		<xsl:apply-templates select="stmt:sectionElement[@id='openTradesCreditDerivatives']" />
		<xsl:apply-templates select="stmt:sectionElement[@id='terminatedTradesIRS']" />
		<xsl:apply-templates select="stmt:sectionElement[@id='terminatedTradesNDF']" />
		<xsl:apply-templates select="stmt:sectionElement[@id='terminatedTradesCreditDerivatives']" />
		<xsl:apply-templates select="stmt:sectionElement[@id='maturedTradesIRS']" />
		<xsl:apply-templates select="stmt:sectionElement[@id='maturedTradesNDF']" />
		<xsl:apply-templates select="stmt:sectionElement[@id='maturedTradesCreditDerivatives']" />
		<xsl:apply-templates select="stmt:sectionElement[@id='accountActivity']" />
		<xsl:apply-templates select="stmt:sectionElement[@id='marginCallActivity']" />
		<xsl:apply-templates select="stmt:sectionElement[@id='pendingMarginCallActivity']" />
		<xsl:apply-templates select="stmt:sectionElement[@id='marginsOnDeposit']" />
	</xsl:template>

	<xsl:template match="stmt:sectionElement[@id='clearingCashFlowsSummaryTable']">
		<xsl:variable name="inactiveCashFlowCurrencies" select="stmt:metaData/stmt:entry[@key='empty']" />
		<xsl:variable name="inactiveSeparateSettlementCurrencies"
			select="../stmt:sectionElement[@id = 'separateSettlementSummaryTable']/stmt:metaData/stmt:entry[@key='empty']" />
		<xsl:variable name="imCurrenciesTmp"  select="../stmt:sectionElement[@id = 'initialMarginSummaryTables']/stmt:metaData/stmt:entry[@key='imCcys']" />

		<xsl:choose>
			<xsl:when test="not($inactiveSeparateSettlementCurrencies)">

				<xsl:variable name="finalInActiveCurrencies">
					<xsl:call-template name="constructInactiveCurrencies">
						<xsl:with-param name="inactiveCashFlowCurrencies" select="$inactiveCashFlowCurrencies"/>
						<xsl:with-param name="imCurrencies" select="$imCurrenciesTmp"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:call-template name="buildFinancialSummary">
					<xsl:with-param name="inactiveCurrencies" select="exslt:node-set($finalInActiveCurrencies)" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="finalInActiveCurrencies">
					<xsl:call-template name="constructInactiveCurrencies">
						<xsl:with-param name="inactiveCashFlowCurrencies" select="$inactiveCashFlowCurrencies[. = $inactiveSeparateSettlementCurrencies]"/>
						<xsl:with-param name="imCurrencies" select="$imCurrenciesTmp"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:call-template name="buildFinancialSummary">
					<xsl:with-param name="inactiveCurrencies" select="exslt:node-set($finalInActiveCurrencies)" />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

 	<xsl:template name="constructInactiveCurrencies">
 		<xsl:param name="inactiveCashFlowCurrencies"/>
 		<xsl:param name="imCurrencies"/>

		<xsl:variable name="finalInActiveCurrencies">
			<xsl:for-each select="$inactiveCashFlowCurrencies">
				<xsl:variable name="inActive" select="." />
				<xsl:variable name="pos" select="position()"/>
				<xsl:if test="($imCurrencies and not($imCurrencies[contains(., $inActive)]) or not($imCurrencies))">
					<xsl:copy-of select="exslt:node-set(.)/text()"/>
		    	</xsl:if>
			</xsl:for-each>
		</xsl:variable>
 		
 		<xsl:copy-of select="$finalInActiveCurrencies" />
 	</xsl:template>

	<xsl:template name="buildFinancialSummary">
		<xsl:param name="inactiveCurrencies" />
		<xsl:variable name="separateSettlementsSection"
			select="../stmt:sectionElement[@id = 'separateSettlementSummaryTable']/stmt:sectionElement[@id = 'separateSettlementTables']" />
		<xsl:variable name="title" select="@id" />
		<fo:block xsl:use-attribute-sets="title-style">
			<xsl:value-of select="stmtext:getTranslation('title', $title)" />
		</fo:block>
		<xsl:choose>
			<xsl:when test="count(child::stmt:row)=0">
				<fo:block xsl:use-attribute-sets="block-style">No Activity.</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="block-style">
					<fo:table xsl:use-attribute-sets="table-style">
						<xsl:apply-templates select="stmt:header">
							<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
							<xsl:with-param name="translationsVar" select="'summary'" />
							<xsl:with-param name="tablenameVar" select="@id" />
						</xsl:apply-templates>
						<fo:table-body>
							<xsl:call-template name="appendCashFlowRows">
								<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
							</xsl:call-template>
							<xsl:call-template name="appendImRows">
								<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
							</xsl:call-template>
							<xsl:apply-templates select="$separateSettlementsSection">
								<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
							</xsl:apply-templates>
							<xsl:if test="boolean($separateSettlementsSection)">
								<fo:table-row xsl:use-attribute-sets="subtotal-row-style">
									<fo:table-cell xsl:use-attribute-sets="bold-cell-style">
										<fo:block text-align="end">Net Excess/Deficit Separate Settlement</fo:block>
									</fo:table-cell>
									<xsl:for-each select="$separateSettlementsSection[1]/stmt:header/stmt:headerName">
										<xsl:variable name="header" select="text()" />
										<xsl:if test="$header != 'Row Id' and $header != 'Total' and not(boolean($inactiveCurrencies[text() = $header]))">
											<fo:table-cell xsl:use-attribute-sets="cell-style">
												<fo:block text-align="end">
													<xsl:value-of
														select="stmtext:formatNumber(sum(../../../stmt:sectionElement[@id = 'separateSettlementTables']/stmt:row/stmt:cell[@id = $header]/stmt:value/text()), $header)" />
												</fo:block>
											</fo:table-cell>
										</xsl:if>
										<xsl:if test="$header = 'Total'">
											<fo:table-cell xsl:use-attribute-sets="cell-style">
												<fo:block text-align="end">
													<xsl:value-of
														select="stmtext:formatNumber(sum(../../../stmt:sectionElement[@id = 'separateSettlementTables']/stmt:row/stmt:cell[@id = 'total']/stmt:value/text()), $baseCurrency)" />
												</fo:block>
											</fo:table-cell>
										</xsl:if>
									</xsl:for-each>
								</fo:table-row>
								<xsl:call-template name="appendFillerRow">
									<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
								</xsl:call-template>
							</xsl:if>
						</fo:table-body>
					</fo:table>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="appendFillerRow">
		<xsl:param name="inactiveCurrencies" />
		<fo:table-row xsl:use-attribute-sets="filler-row-style">
			<fo:table-cell xsl:use-attribute-sets="filler-cell-style">
				<xsl:attribute name="number-columns-spanned">
					<xsl:value-of
					select="count(//stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:header/stmt:headerName) - count($inactiveCurrencies)" />
				</xsl:attribute>
				<fo:block />
			</fo:table-cell>
		</fo:table-row>
	</xsl:template>

	<xsl:template
		match="stmt:sectionElement[@id = 'separateSettlementSummaryTable']/stmt:sectionElement[@id = 'separateSettlementTables']">
		<xsl:param name="inactiveCurrencies" />
		<xsl:variable name="ssFlows" select="stmt:metaData/stmt:entry[@key = 'INCLUDED_VM_FLOWS']" />
		<fo:table-row xsl:use-attribute-sets="row-style">
			<fo:table-cell xsl:use-attribute-sets="cell-style">
				<fo:block text-align="end">
					Separate Settlement -
					<xsl:call-template name="tokenize">
						<xsl:with-param name="text" select="$ssFlows" />
					</xsl:call-template>
				</fo:block>
			</fo:table-cell>
			<xsl:for-each select="stmt:header/stmt:headerName">
				<xsl:variable name="header" select="text()" />
				<xsl:if
					test="$header != 'Row Id' and $header != 'Total' and (($inactiveCurrencies and not($inactiveCurrencies[contains(text(), $header)])) or not($inactiveCurrencies))">
					<fo:table-cell xsl:use-attribute-sets="cell-style">
						<fo:block text-align="end">
							<xsl:value-of select="stmtext:formatNumber(../../stmt:row/stmt:cell[@id = $header]/stmt:value/text(), $header)" />
						</fo:block>
					</fo:table-cell>
				</xsl:if>
				<xsl:if test="$header = 'Total'">
					<fo:table-cell xsl:use-attribute-sets="cell-style">
						<fo:block text-align="end">
							<xsl:value-of select="stmtext:formatNumber(../../stmt:row/stmt:cell[@id = 'total']/stmt:value/text(), $baseCurrency)" />
						</fo:block>
					</fo:table-cell>
				</xsl:if>
			</xsl:for-each>
		</fo:table-row>
	</xsl:template>

	<xsl:template name="tokenize">
		<xsl:param name="text" />
		<xsl:param name="sep" select="','" />
		<xsl:choose>
			<xsl:when test="contains($text, $sep)">
				<xsl:value-of select="concat(substring-before($text, $sep), ', ')" />
				<!-- recursive call -->
				<xsl:call-template name="tokenize">
					<xsl:with-param name="text" select="substring-after($text, $sep)" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="appendImRows">
		<xsl:param name="inactiveCurrencies" />
		<xsl:variable name="financialSummary" select="//stmt:ClearingStatement/stmt:section[@id='financialSummary']" />

		<xsl:apply-templates
			select="$financialSummary/stmt:sectionElement[@id='initialMarginSummaryTables']/stmt:sectionElement[@id='initialMarginTable']">
			<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
		</xsl:apply-templates>

		<xsl:apply-templates select="$financialSummary/stmt:sectionElement[@id='initialMarginSummaryTables']">
			<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
		</xsl:apply-templates>

		<xsl:call-template name="appendNetExcessDeficitRow">
			<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="appendCashFlowRows">
		<xsl:param name="inactiveCurrencies" />
		<xsl:variable name="translationsVar" select="'summary'" />
		<xsl:for-each
			select="//stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:row">
			<xsl:variable name="rowId" select="./@id" />
			<fo:table-row xsl:use-attribute-sets="row-style">
				<xsl:attribute name="background-color">
					<xsl:choose>
						<xsl:when test="contains($subtotalRows, ./@id)">
							#e0f4ff
						</xsl:when>
						<xsl:when test="contains($totalRows, ./@id)">
							#FFF500
						</xsl:when>
						<xsl:otherwise>
							#FFFFFF
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:attribute name="font-weight">
					<xsl:choose>
						<xsl:when test="contains($subtotalRows, $rowId) or contains($totalRows, $rowId)">bold</xsl:when>
					</xsl:choose>
				</xsl:attribute>

				<xsl:for-each select="./stmt:cell">
					<xsl:variable name="cellId" select="./@id" />
					<xsl:variable name="translation" select="stmtext:getTranslation($translationsVar, ./stmt:value)" />
					<xsl:variable name="value">
						<xsl:choose>
							<xsl:when test="$translation">
								<xsl:value-of select="$translation" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="stmt:value" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:if test="($inactiveCurrencies and not($inactiveCurrencies[contains(text(), $cellId)])) or not($inactiveCurrencies)">
						<fo:table-cell xsl:use-attribute-sets="cell-style">
							<xsl:if test="$rowId = 'Net VM Excess/Deficit (Incl. Pending)' and $cellId != 'rowId' and ($value &lt; 0)">
								<xsl:attribute name="color">red</xsl:attribute>
							</xsl:if>
							<fo:block>
								<xsl:if test="not(contains($totalRows, $value))">
									<xsl:attribute name="text-align">end</xsl:attribute>
								</xsl:if>
								<xsl:choose>
									<xsl:when
										test="$cellId = 'rowId' and $rowId = 'Intraday Funding Amount' and //stmt:ClearingStatement/stmt:metaData/stmt:entry[@key='statementStartDate'] != //stmt:ClearingStatement/stmt:metaData/stmt:entry[@key='statementDate']">
										Monthly Funding Amount
									</xsl:when>
									<xsl:when test="string(number($value)) != 'NaN' and $cellId = 'total' and $rowId != 'FX Rates'">
										<xsl:value-of select="stmtext:formatNumber($value, $baseCurrency)" />
									</xsl:when>
									<xsl:when test="string(number($value)) != 'NaN' and $rowId != 'FX Rates'">
										<xsl:value-of select="stmtext:formatNumber($value, $cellId)" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$value" />
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</xsl:if>
				</xsl:for-each>
			</fo:table-row>
			<xsl:if test="contains($fillerRows, $rowId)">
				<xsl:call-template name="appendFillerRow">
					<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
				</xsl:call-template>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="appendNetExcessDeficitRow">
		<xsl:param name="inactiveCurrencies" />
		<fo:table-row xsl:use-attribute-sets="total-row-style">
			<xsl:for-each
				select="//stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:header/stmt:headerName">
				<xsl:variable name="currency" select="text()" />
				<xsl:if
					test="($inactiveCurrencies and not($inactiveCurrencies[contains(text(), $currency)])) or not($inactiveCurrencies)">
					<xsl:choose>
						<xsl:when test="contains($currency, 'Row Id')">
							<fo:table-cell xsl:use-attribute-sets="bold-cell-style">
								<fo:block>Net Excess/Deficit</fo:block>
							</fo:table-cell>
						</xsl:when>
						<xsl:when test="contains($currency, 'Total')">
							<xsl:variable name="vmAmount"
								select="../../stmt:row[@id = 'Net VM Excess/Deficit (Incl. Pending)']/stmt:cell[@id = 'total']/stmt:value" />
							<xsl:variable name="imAmount"
								select="sum(../../../stmt:sectionElement[@id = 'initialMarginSummaryTables']/stmt:sectionElement[@id='initialMarginTable']/stmt:row[@id = 'Net IM Excess/Deficit (Incl. Pending)']/stmt:cell[@id = 'total']/stmt:value)" />
							<xsl:variable name="amount" select="$vmAmount + $imAmount" />
							<fo:table-cell xsl:use-attribute-sets="cell-style">
								<xsl:if test="$amount &lt; 0">
									<xsl:attribute name="color">red</xsl:attribute>
								</xsl:if>
								<fo:block text-align="end">
									<xsl:value-of select="stmtext:formatNumber($amount, $baseCurrency)" />
								</fo:block>
							</fo:table-cell>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="vmAmount"
								select="../../stmt:row[@id = 'Net VM Excess/Deficit (Incl. Pending)']/stmt:cell[@id = $currency]/stmt:value" />
							<xsl:variable name="imAmount"
								select="sum(../../../stmt:sectionElement[@id = 'initialMarginSummaryTables']/stmt:sectionElement[@id='initialMarginTable']/stmt:row[@id = 'Net IM Excess/Deficit (Incl. Pending)']/stmt:cell[@id = $currency]/stmt:value)" />
							<xsl:variable name="amount" select="$vmAmount + $imAmount" />
							<fo:table-cell xsl:use-attribute-sets="cell-style">
								<xsl:if test="$amount &lt; 0">
									<xsl:attribute name="color">red</xsl:attribute>
								</xsl:if>
								<fo:block text-align="end">
									<xsl:value-of select="stmtext:formatNumber($amount, $currency)" />
								</fo:block>
							</fo:table-cell>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:for-each>
		</fo:table-row>
		<xsl:call-template name="appendFillerRow">
			<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="stmt:sectionElement[@id = 'initialMarginSummaryTables']">
		<xsl:param name="imTables" select="./stmt:sectionElement[@id = 'initialMarginTable']" />
		<xsl:param name="inactiveCurrencies" />
		<xsl:for-each select="stmt:sectionElement[@id = 'initialMarginTable'][1]/stmt:row">
			<xsl:if test="@id != 'Margin Requirement'">
				<xsl:variable name="rowNode" select="." />
				<xsl:variable name="imCurrency" select="stmt:metaData/stmt:entry[@key = 'ccy']/text()" />
				<xsl:variable name="contractId" select="stmt:metaData/stmt:entry[@key = 'contractId']/text()" />
				<fo:table-row xsl:use-attribute-sets="row-style">
					<xsl:attribute name="background-color">
						<xsl:choose>
							<xsl:when test="contains($subtotalRows, $rowNode/@id)">
								#e0f4ff
							</xsl:when>
							<xsl:when test="contains($totalRows, $rowNode/@id)">
								#FFF500
							</xsl:when>
							<xsl:otherwise>#FFFFFF</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>

					<xsl:attribute name="font-weight">
						<xsl:choose>
							<xsl:when test="contains($subtotalRows, $rowNode/@id) or contains($totalRows, $rowNode/@id)">bold</xsl:when>
						</xsl:choose>
					</xsl:attribute>

					<xsl:for-each
						select="//stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:header/stmt:headerName">
						<xsl:variable name="currency" select="text()" />
						<xsl:if
							test="($inactiveCurrencies and not($inactiveCurrencies[contains(text(), $currency)])) or not($inactiveCurrencies)">
							<fo:table-cell xsl:use-attribute-sets="cell-style">
								<xsl:choose>
									<xsl:when test="contains($currency, 'Row Id')">
										<xsl:variable name="value" select="$rowNode/stmt:cell[@id = 'rowId']/stmt:value/text()" />
										<xsl:choose>
											<xsl:when test="contains($subtotalRows, $rowNode/@id)">
												<fo:block text-align="end">
													<xsl:value-of select="$value" />
												</fo:block>
											</xsl:when>
											<xsl:when test="contains($totalRows, $rowNode/@id)">
												<fo:block>
													<xsl:value-of select="$value" />
												</fo:block>
											</xsl:when>
											<xsl:otherwise>
												<fo:block text-align="end">
													<xsl:value-of select="$value" />
												</fo:block>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:when test="contains($currency, 'Total')">
										<xsl:variable name="amount"
											select="sum($imTables/stmt:row[@id = $rowNode/@id]/stmt:cell[@id = 'total']/stmt:value/text())" />
										<fo:block text-align="end">
											<xsl:choose>
												<xsl:when test="$amount = 0">
													<xsl:value-of select="stmtext:formatNumber(0.0, $baseCurrency)" />
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="stmtext:formatNumber($amount, $baseCurrency)" />
												</xsl:otherwise>
											</xsl:choose>
										</fo:block>
									</xsl:when>
									<xsl:otherwise>
										<xsl:variable name="amount"
											select="sum($imTables/stmt:row[@id = $rowNode/@id]/stmt:cell[@id = $currency]/stmt:value/text())" />
										<fo:block text-align="end">
											<xsl:choose>
												<xsl:when test="$amount = 0">
													<xsl:value-of select="stmtext:formatNumber(0.0, $currency)" />
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="stmtext:formatNumber($amount, $currency)" />
												</xsl:otherwise>
											</xsl:choose>
										</fo:block>
									</xsl:otherwise>
								</xsl:choose>
							</fo:table-cell>
						</xsl:if>
					</xsl:for-each>
				</fo:table-row>

				<xsl:if test="contains($fillerRows, $rowNode/@id)">
					<xsl:call-template name="appendFillerRow">
						<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
					</xsl:call-template>
				</xsl:if>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="stmt:sectionElement[@id='initialMarginTable']">
		<xsl:param name="inactiveCurrencies" />
		<xsl:variable name="imTable" select="." />

		<xsl:for-each
			select="stmt:metaData[generate-id() = generate-id(key('clearingServicesKey', concat(stmt:entry[@key = 'ccp'], '|', stmt:entry[@key = 'product']))[1])]">
			<xsl:variable name="marginRequirementRow" select="../stmt:row[@id = 'Margin Requirement']" />
			<xsl:variable name="ccp" select="stmt:entry[@key = 'ccp']" />
			<xsl:variable name="service" select="stmt:entry[@key = 'product']" />
			<xsl:if
				test="boolean($marginRequirementRow/stmt:metaData/stmt:entry[@key = 'empty']) = false() and translate($ccp, 'unallocated', 'UNALLOCATED') != 'UNALLOCATED'">
				<fo:table-row xsl:use-attribute-sets="row-style">
					<xsl:for-each
						select="//stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:header/stmt:headerName">
						<xsl:variable name="currency" select="text()" />
						<xsl:variable name="imTableNodes"
							select="$imTable/../stmt:sectionElement[stmt:metaData/stmt:entry[@key = 'ccp'] = $ccp and stmt:metaData/stmt:entry[@key = 'product'] = $service]" />
						<xsl:variable name="requirement"
							select="sum($imTableNodes/stmt:row[@id = 'Margin Requirement']/stmt:cell[@id = $currency]/stmt:value)" />
						<xsl:if
							test="($inactiveCurrencies and not($inactiveCurrencies[contains(text(), $currency)])) or not($inactiveCurrencies)">
							<fo:table-cell xsl:use-attribute-sets="cell-style">
								<fo:block text-align="end">
									<xsl:choose>
										<xsl:when test="contains($currency, 'Row Id')">
											<xsl:value-of
												select="concat($ccp, ' - ', $service, ' ', $marginRequirementRow/stmt:cell[@id = 'rowId']/stmt:value/text())" />
										</xsl:when>
										<xsl:when test="contains($currency, 'Total')">
											<xsl:variable name="imAmount"
												select="sum($imTableNodes/stmt:row[@id = 'Margin Requirement']/stmt:cell[@id = 'total']/stmt:value)" />
											<xsl:value-of select="stmtext:formatNumber($imAmount, $baseCurrency)" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:choose>
												<xsl:when test="$requirement != ''">
													<xsl:value-of select="stmtext:formatNumber($requirement, $currency)" />
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="stmtext:formatNumber(0.0, $currency)" />
												</xsl:otherwise>
											</xsl:choose>
										</xsl:otherwise>
									</xsl:choose>
								</fo:block>
							</fo:table-cell>
						</xsl:if>
					</xsl:for-each>
				</fo:table-row>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="stmt:sectionElement[@id='accountActivity']">
		<xsl:variable name="title" select="@id" />
		<fo:block xsl:use-attribute-sets="title-style" page-break-before="always">
			<xsl:value-of select="stmtext:getTranslation('title', $title)" />
		</fo:block>
		<xsl:choose>
			<xsl:when test="count(child::stmt:row)=0">
				<fo:block xsl:use-attribute-sets="block-style">
					No Activities
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="block-style">
					<fo:table xsl:use-attribute-sets="table-style">
						<xsl:apply-templates select="stmt:header">
							<xsl:with-param name="tablenameVar" select="@id" />
						</xsl:apply-templates>
						<fo:table-body>
							<xsl:apply-templates select="stmt:row" />
						</fo:table-body>
					</fo:table>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="stmt:sectionElement[@id='marginsOnDeposit']">
		<xsl:variable name="title" select="@id" />
		<fo:block xsl:use-attribute-sets="title-style" page-break-before="always">
			<xsl:value-of select="stmtext:getTranslation('title', $title)" />
		</fo:block>
		<xsl:choose>
			<xsl:when test="count(child::stmt:row)=0">
				<fo:block xsl:use-attribute-sets="block-style">No Activity.</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="block-style">
					<fo:table xsl:use-attribute-sets="table-style">
						<xsl:apply-templates select="stmt:header" />
						<fo:table-body>
							<xsl:apply-templates select="stmt:row" />
						</fo:table-body>
					</fo:table>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template
		match="stmt:sectionElement[@id='newTradesIRS' or @id='newTradesNDF' or @id='newTradesCreditDerivatives' 
      			or @id='openTradesIRS' or @id='openTradesNDF' or @id='openTradesCreditDerivatives' 
      			or @id='terminatedTradesIRS' or @id='terminatedTradesNDF' or @id='terminatedTradesCreditDerivatives' 
      			or @id='maturedTradesIRS' or @id='maturedTradesNDF' or @id='maturedTradesCreditDerivatives']">
		<xsl:variable name="product" select="stmt:metaData/stmt:entry[@key='product']" />
		<xsl:variable name="productAvailable" select="../../stmt:metaData/stmt:entry[@key=$product]" />
		<xsl:if test="not($productAvailable) or $productAvailable='true'">
			<xsl:variable name="title" select="@id" />
			<fo:block xsl:use-attribute-sets="title-style" page-break-before="always">
				<xsl:value-of select="stmtext:getTranslation('title', $title)" />
			</fo:block>
			<xsl:choose>
				<xsl:when test="count(child::stmt:row)=0">
					<fo:block xsl:use-attribute-sets="block-style">
						No trades for
						<xsl:value-of select="stmtext:getTranslation('title', $title)" />
					</fo:block>
				</xsl:when>
				<xsl:otherwise>
					<fo:block xsl:use-attribute-sets="block-style">
						<fo:table xsl:use-attribute-sets="table-style">
							<xsl:apply-templates select="stmt:header">
								<xsl:with-param name="tablenameVar" select="@id" />
							</xsl:apply-templates>
							<fo:table-body>
								<xsl:apply-templates select="stmt:row" />
							</fo:table-body>
						</fo:table>
					</fo:block>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<xsl:template match="stmt:sectionElement[@id='marginCallActivity' or @id='pendingMarginCallActivity']">
		<xsl:variable name="title" select="@id" />
		<fo:block xsl:use-attribute-sets="title-style" page-break-before="always">
			<xsl:value-of select="stmtext:getTranslation('title', $title)" />
		</fo:block>

		<xsl:choose>
			<xsl:when test="count(child::stmt:row)=0">
				<fo:block xsl:use-attribute-sets="block-style">No Activity</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="sectionElement" select="." />
				<xsl:variable name="key" select="@id" />
				<xsl:variable name="ccps"
					select="$sectionElement/stmt:row/stmt:metaData/stmt:entry[@key='ccp'][generate-id() = generate-id(key($key, text())[1])]" />
				<xsl:for-each select="$ccps">
					<xsl:variable name="ccp" select="." />
					<xsl:if test="$ccp!='VARIATION MARGIN'">
						<fo:block xsl:use-attribute-sets="sub-title-style">
							<xsl:value-of select="$ccp" />
						</fo:block>
						<fo:block xsl:use-attribute-sets="block-style">
							<fo:table xsl:use-attribute-sets="table-style">
								<xsl:apply-templates select="$sectionElement/stmt:header" />
								<fo:table-body>
									<xsl:apply-templates select="$sectionElement/stmt:row[stmt:metaData/stmt:entry[@key='ccp'] = $ccp]" />
								</fo:table-body>
							</fo:table>
						</fo:block>
						<xsl:if test="$ccp!='VARIATION MARGIN' and $ccp!='Unallocated'">
							<fo:block font-size="8pt" font-weight="bold" padding-before='5px'>
								Total
								<xsl:value-of select="$ccp" />
								:
								<xsl:value-of select="$sectionElement/stmt:metaData/stmt:entry[@key=concat('Total ',$ccp)]/text()" />
							</fo:block>
						</xsl:if>
					</xsl:if>
					<fo:block font-size="8pt" padding-before='10px'></fo:block> <!-- add a spacer -->
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="stmt:header">
		<xsl:param name="inactiveCurrencies" />
		<xsl:param name="translationsVar" />
		<xsl:param name="tablenameVar" />

		<!-- Adding table columns -->
		<xsl:apply-templates select="stmt:headerName" mode="fo-table-column">
			<xsl:with-param name="translationsVar" select="$translationsVar" />
			<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
			<xsl:with-param name="tablenameVar" select="$tablenameVar" />
		</xsl:apply-templates>

		<fo:table-header border-style='solid' background-color='#5577B6'>
			<fo:table-row>
				<xsl:attribute name="font-weight">bold</xsl:attribute>
				<xsl:apply-templates select="stmt:headerName">
					<xsl:with-param name="translationsVar" select="$translationsVar" />
					<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
				</xsl:apply-templates>
			</fo:table-row>
		</fo:table-header>
	</xsl:template>

	<!-- A template to specify different width for columns for a particular table (via input param: tablenameVar) -->
	<xsl:template match="stmt:headerName" mode="fo-table-column">
		<xsl:param name="translationsVar" />
		<xsl:param name="inactiveCurrencies" />
		<xsl:param name="tablenameVar" />
		<xsl:variable name="column" select="." />
		<xsl:variable name="translation" select="stmtext:getTranslation($translationsVar, $column)" />
		<xsl:variable name="value">
			<xsl:choose>
				<xsl:when test="$translation = 'Total (__BASE_CURRENCY__)'">
					<xsl:value-of select="concat('Total (' , $baseCurrency , ')')" />
				</xsl:when>
				<xsl:when test="$translation">
					<xsl:value-of select="$translation" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="." />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="text()='Row Id'">
				<fo:table-column column-width="1.0in" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="($inactiveCurrencies and not($inactiveCurrencies[contains(text(), $column)])) or not($inactiveCurrencies)">
					<xsl:choose>
						<xsl:when
							test="($tablenameVar='accountActivity' and $value='Type')
                            or contains($value, 'Description')">
							<fo:table-column column-width="2.0in" />
						</xsl:when>
						<xsl:when test="($value='Description')">
							<fo:table-column column-width="1.0in" />
						</xsl:when>
						<xsl:otherwise>
							<fo:table-column column-width="proportional-column-width(1)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- A template that does NOT specify column width -->
	<xsl:template match="stmt:headerName">
		<xsl:param name="translationsVar" />
		<xsl:param name="inactiveCurrencies" />
		<xsl:variable name="column" select="." />
		<xsl:variable name="translation" select="stmtext:getTranslation($translationsVar, $column)" />
		<xsl:variable name="value">
			<xsl:choose>
				<xsl:when test="$translation = 'Total (__BASE_CURRENCY__)'">
					<!-- Ugly hack for non-EXSLT workaround: the document()// approach selects from the source XSL document, so there can 
						be no evaluations inside the translations vars. So far the only one is the base currency translation for total headers -->
					<xsl:value-of select="concat('Total (' , $baseCurrency , ')')" />
				</xsl:when>
				<xsl:when test="$translation">
					<xsl:value-of select="$translation" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="." />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="text()='Row Id'">
				<fo:table-cell xsl:use-attribute-sets="cell-style">
					<fo:block />
				</fo:table-cell>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="($inactiveCurrencies and not($inactiveCurrencies[contains(text(), $column)])) or not($inactiveCurrencies)">
					<fo:table-cell xsl:use-attribute-sets="cell-style">
						<fo:block text-align="center" color="white">
							<xsl:value-of select="$value" />
						</fo:block>
					</fo:table-cell>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="stmt:row">
		<xsl:param name="translationsVar" />
		<xsl:param name="inactiveCurrencies" />
		<xsl:if test="count(stmt:metaData/stmt:entry[@key='empty' and text()='true']) &lt; 1">
			<xsl:choose>
				<xsl:when test="contains($subtotalRows, ./@id)">
					<fo:table-row xsl:use-attribute-sets="subtotal-row-style">
						<xsl:apply-templates select="stmt:cell">
							<xsl:with-param name="translationsVar" select="$translationsVar" />
							<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
						</xsl:apply-templates>
					</fo:table-row>
				</xsl:when>
				<xsl:when test="contains($totalRows, ./@id)">
					<fo:table-row xsl:use-attribute-sets="total-row-style">
						<xsl:apply-templates select="stmt:cell">
							<xsl:with-param name="translationsVar" select="$translationsVar" />
							<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
						</xsl:apply-templates>
					</fo:table-row>
				</xsl:when>
				<xsl:otherwise>
					<fo:table-row xsl:use-attribute-sets="row-style">
						<xsl:apply-templates select="stmt:cell">
							<xsl:with-param name="translationsVar" select="$translationsVar" />
							<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
						</xsl:apply-templates>
					</fo:table-row>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="contains($fillerRows, ./@id)">
				<fo:table-row xsl:use-attribute-sets="filler-row-style">
					<xsl:apply-templates select="stmt:cell">
						<xsl:with-param name="translationsVar" select="$translationsVar" />
						<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
						<xsl:with-param name="fillerRow" select="true()" />
					</xsl:apply-templates>
				</fo:table-row>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="stmt:cell">
		<xsl:param name="translationsVar" />
		<xsl:param name="fillerRow" />
		<xsl:variable name="sectionId" select="../../../@id" />
		<xsl:variable name="tableId" select="../../@id" />
		<xsl:variable name="rowId" select="../@id" />
		<xsl:variable name="cellId" select="@id" />
		<xsl:variable name="currentValue" select="stmt:value" />
		<xsl:variable name="translation" select="stmtext:getTranslation($translationsVar, $currentValue)" />
		<xsl:variable name="value">
			<xsl:choose>
				<xsl:when test="$translation">
					<xsl:value-of select="$translation" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="stmt:value" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="cellValue">
			<xsl:choose>
				<xsl:when
					test="$cellId = 'rowId' and $rowId = 'Intraday Funding Amount' and //stmt:ClearingStatement/stmt:metaData/stmt:entry[@key='statementStartDate'] != //stmt:ClearingStatement/stmt:metaData/stmt:entry[@key='statementDate']">
					Monthly Funding Amount
				</xsl:when>
				<xsl:when
					test="$sectionId = 'financialSummary' and string(number($value)) != 'NaN' and $cellId = 'total' and $rowId != 'FX Rates'">
					<xsl:value-of select="stmtext:formatNumber($value, $baseCurrency)" />
				</xsl:when>
				<xsl:when test="$sectionId = 'financialSummary' and string(number($value)) != 'NaN' and $rowId != 'FX Rates'">
					<xsl:value-of select="stmtext:formatNumber($value, $cellId)" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$value" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$fillerRow = 'true' ">
				<fo:table-cell xsl:use-attribute-sets="filler-cell-style">
					<fo:block />
				</fo:table-cell>
			</xsl:when>
			<xsl:otherwise>
				<fo:table-cell xsl:use-attribute-sets="cell-style">
					<xsl:if test="$rowId = 'Net VM Excess/Deficit (Incl. Pending)' and $cellId != 'rowId' and ($value &lt; 0)">
						<xsl:attribute name="color">red</xsl:attribute>
					</xsl:if>
					<fo:block>
						<xsl:if test="not(contains($totalRows, $value))">
							<xsl:attribute name="text-align">end</xsl:attribute>
						</xsl:if>
						<xsl:if test="count(child::stmt:value) != 0">
							<xsl:value-of select="$cellValue" />
						</xsl:if>
					</fo:block>
				</fo:table-cell>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>