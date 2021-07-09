<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:stmt="urn:com:calypso:clearing:statement" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:stmtext="xalan://com.calypso.tk.bo.StatementDataTypeFormatter" xmlns:exslt="http://exslt.org/common" 
	xmlns:func="http://exslt.org/functions"	xmlns:my="http://example.org/my" xmlns:fo="http://www.w3.org/1999/XSL/Format" extension-element-prefixes="stmtext exslt func" exclude-result-prefixes="xs fo stmtext my">

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

	<xsl:attribute-set name="subtotal-filler-row-style">
		<xsl:attribute name="height">0.14in</xsl:attribute>
		<xsl:attribute name="background-color">#E3F4FE</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="total-filler-row-style">
		<xsl:attribute name="height">0.14in</xsl:attribute>
		<xsl:attribute name="background-color">#B2DCF9</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="row-style">
		<xsl:attribute name="height">0.17in</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="subtotal-row-style">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="background-color">#E3F4FE</xsl:attribute>
		<xsl:attribute name="height">0.17in</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="total-row-style">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="background-color">#B2DCF9</xsl:attribute>
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

	<xsl:attribute-set name="left-aligned-bold-cell-style">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="border-style">solid</xsl:attribute>
		<xsl:attribute name="padding-left">2px</xsl:attribute>
		<xsl:attribute name="padding-right">2px</xsl:attribute>
		<xsl:attribute name="padding-bottom">2px</xsl:attribute>
		<xsl:attribute name="padding-top">2px</xsl:attribute>
		<xsl:attribute name="font-family">Tahoma, Geneva, sans-serif</xsl:attribute>
		<xsl:attribute name="font-size">6px</xsl:attribute>
		<xsl:attribute name="text-align">left</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="table-style">
		<xsl:attribute name="table-layout">fixed</xsl:attribute>
		<xsl:attribute name="width">100%</xsl:attribute>
		<xsl:attribute name="inline-progression-dimension">auto</xsl:attribute>
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

	<xsl:key name="marginCallActivity" match="stmt:sectionElement[@id='marginCallActivity']/stmt:row/stmt:metaData/stmt:entry[@key='ccp']" use="." />
	<xsl:key name="pendingMarginCallActivity" match="stmt:sectionElement[@id='pendingMarginCallActivity']/stmt:row/stmt:metaData/stmt:entry[@key='ccp']" use="." />
	<xsl:key name="ccpKey" match="stmt:sectionElement[@id='initialMarginTable']/stmt:metaData" use="stmt:entry[@key='ccp']" />
	<xsl:key name="clearingServiceKey" match="stmt:sectionElement[@id='initialMarginTable']/stmt:metaData" use="concat(stmt:entry[@key='ccp'], '|', stmt:entry[@key='product'])" />
	<xsl:key name="vmFlowsKey" match="stmt:sectionElement[@id='separateSettlementTables']/stmt:metaData" use="stmt:entry[@key='INCLUDED_VM_FLOWS']" />

	<xsl:variable name="baseCurrency">
		<xsl:value-of select="//stmt:ClearingStatement/stmt:metaData/stmt:entry[@key='baseCurrency']" />
	</xsl:variable>
	
	<xsl:variable name="sumMTA">
		<xsl:value-of select="sum(//stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='initialMarginSummaryTables']/stmt:sectionElement[@id='initialMarginTable']/stmt:row[@id = 'MTA']/stmt:cell[@id = 'total']/stmt:value[. &gt; 0]) -
                              sum(//stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='initialMarginSummaryTables']/stmt:sectionElement[@id='initialMarginTable']/stmt:row[@id = 'MTA']/stmt:cell[@id = 'total']/stmt:value[. &lt; 0])" />
	</xsl:variable>
	
	<xsl:variable name="sumFXHaircut">
		<xsl:value-of select="sum(//stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='initialMarginSummaryTables']/stmt:sectionElement[@id='initialMarginTable']/stmt:metaData/stmt:entry[@key='PO Haircut']) +
                              sum(//stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='initialMarginSummaryTables']/stmt:sectionElement[@id='initialMarginTable']/stmt:metaData/stmt:entry[@key='CP Haircut'])" />
	</xsl:variable>

	<xsl:variable name="rawDate">
		<xsl:value-of select="//stmt:ClearingStatement/stmt:metaData/stmt:entry[@key='statementDate']" />
	</xsl:variable>

	<xsl:variable name="pricingEnv">
		<xsl:value-of select="//stmt:ClearingStatement/stmt:metaData/stmt:entry[@key='pricingEnv']" />
	</xsl:variable>
	
	<xsl:variable name="statementCashBreakDown">
		<xsl:value-of select="//stmt:ClearingStatement/stmt:metaData/stmt:entry[@key='StatementCashBreakDown']" />
	</xsl:variable>

	<xsl:variable name="headers"
		select="//stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:header/stmt:headerName" />

	<xsl:variable name="subtotalRows"
		select="'|Previous Days Ending Cash Balance|SOD Beginning Cash Balance|Ending Cash Balance|Total NPV|Net Fees &amp; Interest|Net VM|Total Requirement|Total Collateral Balance|FX Rates|'" />

	<xsl:variable name="totalRows" select="'|Net VM Excess/Deficit (Incl Pending)|Net IM Excess/Deficit (Excl Pending)|Net IM Excess/Deficit (Incl Pending)|Net Excess/Deficit|MTA|Net IM Excess/Deficit (Incl Pending) Including MTA|'" />

	<xsl:variable name="fillerRows" select="'|Net VM|Net IM Excess/Deficit (Incl Pending)|Net Fees &amp; Interest|Net Excess/Deficit Separate Settlement'" />

	<xsl:template match="/stmt:ClearingStatement">
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
			<fo:layout-master-set>
				<fo:simple-page-master master-name="LandscapeLetter" page-height="8.5in" page-width="11.0in" margin-top="0.5in" margin-bottom="0.5in" margin-left="0.3in"
					margin-right="0.3in">
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
					<fo:block font-size="16pt" font-weight="bold" text-align="center" padding-before='5px' padding-after='5px' font-family="Courier New">
						<xsl:choose>
							<xsl:when test="string(stmt:metaData/stmt:entry[@key='clientCCPOriginCode']) = 'House' and string(stmt:metaData/stmt:entry[@key='clientCCPAccountStructure']) = ''">
								<xsl:value-of select="stmt:metaData/stmt:entry[@key='statementFrequency']" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="stmt:metaData/stmt:entry[@key='mode']" />
							</xsl:otherwise>
						</xsl:choose>	
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
			<xsl:apply-templates select="stmt:sectionElement[@id='newTradesFX']" />
			<xsl:apply-templates select="stmt:sectionElement[@id='openTradesIRS']" />
			<xsl:apply-templates select="stmt:sectionElement[@id='openTradesNDF']" />
			<xsl:apply-templates select="stmt:sectionElement[@id='openTradesCreditDerivatives']" />
			<xsl:apply-templates select="stmt:sectionElement[@id='openTradesFX']" />
			<xsl:apply-templates select="stmt:sectionElement[@id='terminatedTradesIRS']" />
			<xsl:apply-templates select="stmt:sectionElement[@id='terminatedTradesNDF']" />
			<xsl:apply-templates select="stmt:sectionElement[@id='terminatedTradesCreditDerivatives']" />
			<xsl:apply-templates select="stmt:sectionElement[@id='terminatedTradesFX']" />
			<xsl:apply-templates select="stmt:sectionElement[@id='maturedTradesIRS']" />
			<xsl:apply-templates select="stmt:sectionElement[@id='maturedTradesNDF']" />
			<xsl:apply-templates select="stmt:sectionElement[@id='maturedTradesCreditDerivatives']" />
			<xsl:apply-templates select="stmt:sectionElement[@id='maturedTradesFX']" />
			<xsl:apply-templates select="stmt:sectionElement[@id='accountActivity']" />
			<xsl:apply-templates select="stmt:sectionElement[@id='marginCallActivity']" />
			<xsl:apply-templates select="stmt:sectionElement[@id='pendingMarginCallActivity']" />
			<xsl:apply-templates select="stmt:sectionElement[@id='marginsOnDeposit']" />
	</xsl:template>

	<xsl:template match="stmt:sectionElement[@id='clearingCashFlowsSummaryTable']">
		<xsl:variable name="inactiveCashFlowCurrencies" select="stmt:metaData/stmt:entry[@key='empty']" />
		<xsl:variable name="inactiveSeparateSettlementCurrencies" select="../stmt:sectionElement[@id = 'separateSettlementSummaryTable']/stmt:metaData/stmt:entry[@key='empty']" />
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
					<xsl:with-param name="inactiveCurrencies" select="exslt:node-set($finalInActiveCurrencies)/Currency" />
				</xsl:call-template>
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:variable name="finalInActiveCurrencies">
					<xsl:call-template name="constructInactiveCurrencies">
						<xsl:with-param name="inactiveCashFlowCurrencies" select="$inactiveCashFlowCurrencies[text() = $inactiveSeparateSettlementCurrencies]"/>
						<xsl:with-param name="imCurrencies" select="$imCurrenciesTmp"/>
					</xsl:call-template>
				</xsl:variable>
			
				<xsl:call-template name="buildFinancialSummary">
					<xsl:with-param name="inactiveCurrencies" select="exslt:node-set($finalInActiveCurrencies)/Currency" />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

 	<xsl:template name="constructInactiveCurrencies">
 		<xsl:param name="inactiveCashFlowCurrencies"/>
 		<xsl:param name="imCurrencies"/>

		<xsl:variable name="finalInActiveCurrencies">
			<xsl:for-each select="$inactiveCashFlowCurrencies">
				<Currency>
				<xsl:variable name="inActive" select="text()" />
				<xsl:if test="($imCurrencies and not($imCurrencies[contains(text(), $inActive)])) or not($imCurrencies)">
					<xsl:copy-of select="exslt:node-set(text())"/>
		    	</xsl:if>
				</Currency>
			</xsl:for-each>
		</xsl:variable>
 		
 		<xsl:copy-of select="$finalInActiveCurrencies" />
 	</xsl:template>
	


	<xsl:template name="buildFinancialSummary">
		<xsl:param name="inactiveCurrencies" />
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
							<!--xsl:with-param name="inlineTitle" select="'Summary of Payments'" /-->
						</xsl:apply-templates>
						<fo:table-body>
							<xsl:call-template name="buildSummaryOfPayments">
								<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
								<xsl:with-param name="translationsVar" select="'summary'" />
							</xsl:call-template>
							<xsl:call-template name="buildCashFlowsSummary">
								<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
							</xsl:call-template>
							<xsl:call-template name="buildSeparateSettlementsSection">
								<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
							</xsl:call-template>
							<xsl:call-template name="buildVMExcessDeficitSummary">
								<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
							</xsl:call-template> 
							<xsl:call-template name="buildAccrualsSection">
								<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
							</xsl:call-template>
							<xsl:call-template name="buildImSection">
								<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
							</xsl:call-template> 
						</fo:table-body>
					</fo:table>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="appendFillerRow">
		<xsl:param name="inactiveCurrencies" />
		<xsl:param name="inlineTitle" />
		<xsl:param name="rowStyle" />
		
		<xsl:variable name="inactiveSeparateSettlementCurrencies" select="//stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id = 'separateSettlementSummaryTable']/stmt:metaData/stmt:entry[@key='empty']" />
		<xsl:variable name="numberOfColSpan">
			<xsl:choose>
				<xsl:when test="not($inactiveSeparateSettlementCurrencies)">
					<xsl:value-of select="count($headers) - count($inactiveCurrencies) "/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="count($headers) - count($inactiveCurrencies) + 1"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$rowStyle = 'SUB_TOTAL'">
				<fo:table-row xsl:use-attribute-sets="subtotal-filler-row-style">
					<fo:table-cell xsl:use-attribute-sets="bold-cell-style">
						<xsl:attribute name="number-columns-spanned">
							
							<xsl:value-of select="number($numberOfColSpan)" />
						</xsl:attribute>
						<xsl:choose>
							<xsl:when test="$inlineTitle">
								<fo:block color="#357D22" text-align="left">
									<xsl:value-of select="$inlineTitle" />
								</fo:block>
							</xsl:when>
							<xsl:otherwise>
								<fo:block />
							</xsl:otherwise>
						</xsl:choose>
					</fo:table-cell>
				</fo:table-row>
			</xsl:when>
			<xsl:when test="$rowStyle = 'TOTAL'">
				<fo:table-row xsl:use-attribute-sets="total-filler-row-style">
					<fo:table-cell xsl:use-attribute-sets="bold-cell-style">
						<xsl:attribute name="number-columns-spanned">
							<xsl:value-of select="number($numberOfColSpan)" />
						</xsl:attribute>
						<xsl:choose>
							<xsl:when test="$inlineTitle">
								<fo:block color="#357D22" text-align="left">
									<xsl:value-of select="$inlineTitle" />
								</fo:block>
							</xsl:when>
							<xsl:otherwise>
								<fo:block />
							</xsl:otherwise>
						</xsl:choose>
					</fo:table-cell>
				</fo:table-row>
			</xsl:when>
			<xsl:otherwise>
				<fo:table-row xsl:use-attribute-sets="filler-row-style">
					<fo:table-cell xsl:use-attribute-sets="filler-cell-style">
						<xsl:attribute name="number-columns-spanned">
								<xsl:value-of select="number($numberOfColSpan) " />
							</xsl:attribute>
						<fo:block />
					</fo:table-cell>
				</fo:table-row>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="buildSummaryOfPayments">
		<xsl:param name="inactiveCurrencies" />
		<xsl:param name="translationsVar" select="'summary'" />
		<!-- FX Rates -->
		<fo:table-row xsl:use-attribute-sets="subtotal-row-style">
			<xsl:for-each select="$headers">
				<xsl:variable name="header" select="text()" />
				<xsl:if test="($inactiveCurrencies and not($inactiveCurrencies[contains(text(), $header)])) or not($inactiveCurrencies)">
					<xsl:choose>
						<xsl:when test="$header = 'Row Id'">
							<fo:table-cell xsl:use-attribute-sets="bold-cell-style">
								<fo:block text-align="right">
									<xsl:value-of select="'FX Rates'" />
								</fo:block>
							</fo:table-cell>
						</xsl:when>
						<xsl:otherwise>
							<fo:table-cell xsl:use-attribute-sets="cell-style">
								<fo:block text-align="right">
									<xsl:value-of select="../../stmt:row[@id = 'FX Rates']/stmt:cell[@id = $header]/stmt:value" />
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
		<xsl:call-template name="appendFillerRow">
			<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
			<xsl:with-param name="inlineTitle" select="'Summary of Payments'" />
			<xsl:with-param name="rowStyle" select="'SUB_TOTAL'" />
		</xsl:call-template>
		<!-- Net VM Excess/Deficit (Incl Pending) -->
		<fo:table-row xsl:use-attribute-sets="total-row-style">
			<xsl:for-each select="$headers">
				<xsl:variable name="header" select="." />
				<xsl:if test="($inactiveCurrencies and not($inactiveCurrencies[contains(., $header)])) or not($inactiveCurrencies)">
					<xsl:choose>
						<xsl:when test="$header = 'Row Id'">
							<fo:table-cell xsl:use-attribute-sets="bold-cell-style">
								<fo:block text-align="left">
									<xsl:value-of select="'Net VM Excess/Deficit (Incl Pending)'" />
								</fo:block>
							</fo:table-cell>
						</xsl:when>
						<xsl:when test="contains($header, 'Total')">
							<xsl:variable name="value" select="../../stmt:row[@id = 'Net VM Excess/Deficit (Incl Pending)']/stmt:cell[@id = 'total']/stmt:value" />
							<fo:table-cell xsl:use-attribute-sets="bold-cell-style">
								<fo:block text-align="right">
									<xsl:value-of select="stmtext:formatNumber($value, $baseCurrency)" />
								</fo:block>
							</fo:table-cell>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="value" select="../../stmt:row[@id = 'Net VM Excess/Deficit (Incl Pending)']/stmt:cell[@id = $header]/stmt:value" />
							<fo:table-cell xsl:use-attribute-sets="bold-cell-style">
								<fo:block text-align="right">
									<xsl:value-of select="stmtext:formatNumber($value, $header)" />
								</fo:block>
							</fo:table-cell>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:for-each>
		</fo:table-row>
		<!-- Aggregate Net IM Excess/Deficit (Incl Pending) -->
		<fo:table-row xsl:use-attribute-sets="total-row-style">
			<xsl:for-each select="$headers">
				<xsl:variable name="header" select="." />
				<xsl:if test="($inactiveCurrencies and not($inactiveCurrencies[contains(., $header)])) or not($inactiveCurrencies)">
					<xsl:choose>
						<xsl:when test="$header = 'Row Id'">
							<fo:table-cell xsl:use-attribute-sets="bold-cell-style">
								<fo:block text-align="left">
									<xsl:choose>
										<xsl:when test="$sumMTA != 0">
											<xsl:if test="($statementCashBreakDown and $statementCashBreakDown = 'true')">
												<xsl:value-of select="concat('Aggregate Net ', my:resolveHaircutHeader('IM Excess/Deficit (Incl Pending &amp; MTA) Cash', $sumFXHaircut))" />
											</xsl:if>
											<xsl:if test="not($statementCashBreakDown) or $statementCashBreakDown = 'false'">
												<!--Aggregate Net IM Excess/Deficit (Incl Pending) including MTA -->
												<xsl:value-of select="concat('Aggregate ', my:resolveHaircutHeader('Net IM Excess/Deficit (Incl Pending) including MTA', $sumFXHaircut))" />
											</xsl:if>
										</xsl:when>
										<xsl:otherwise>
											<xsl:if test="($statementCashBreakDown and $statementCashBreakDown = 'true')">
												<!--Aggregate Net IM Excess/Deficit (Incl Pending) Cash -->
												<xsl:value-of select="concat('Aggregate Net ', my:resolveHaircutHeader('IM Excess/Deficit (Incl Pending) Cash', $sumFXHaircut))" />
											</xsl:if>
											<xsl:if test="not($statementCashBreakDown) or $statementCashBreakDown = 'false'">
												<!--Aggregate Net IM Excess/Deficit (Incl Pending) -->
												<xsl:value-of select="concat('Aggregate ', my:resolveHaircutHeader('Net IM Excess/Deficit (Incl Pending)', $sumFXHaircut))" />
											</xsl:if>
										</xsl:otherwise>
									</xsl:choose>
								</fo:block>
							</fo:table-cell>
						</xsl:when>
						<xsl:when test="contains($header, 'Total')">
							<xsl:variable name="aggregateAmount">
									<xsl:for-each select="//stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='initialMarginSummaryTables']/stmt:sectionElement[@id='initialMarginTable']">
										<xsl:variable name="titleHeader">
											<xsl:choose>
												<xsl:when test="$sumMTA != 0">
													<xsl:value-of select="'Net IM Excess/Deficit (Incl Pending) Including MTA'"/>
												</xsl:when>
												<xsl:otherwise>	
													<xsl:value-of select="'Net IM Excess/Deficit (Incl Pending)'"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>
										
										<xsl:variable name="netIMExOrDef" select="./stmt:row[@id = $titleHeader]/stmt:cell[@id = 'total']/stmt:value" />
										<xsl:variable name="netAmt">	
											<xsl:choose>
												<xsl:when test="($netIMExOrDef &gt; 0)">
													<xsl:value-of select="stmtext:getNumber(my:getHaircutAmount($netIMExOrDef , my:getHaircutGrp(., ./stmt:row[@id = $titleHeader]/stmt:cell[@id = 'total']/stmt:value)))" />
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="stmtext:getNumber(my:getHaircutAmount($netIMExOrDef , my:getHaircutGrp(., ./stmt:row[@id = $titleHeader]/stmt:cell[@id = 'total']/stmt:value)))"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>
										<total>
											<xsl:value-of select="stmtext:getNumber($netAmt)" />
										</total>
									</xsl:for-each>
								</xsl:variable>
							<xsl:variable name="value" select="sum(exslt:node-set($aggregateAmount)/total)" />
							<fo:table-cell xsl:use-attribute-sets="bold-cell-style">
								<fo:block text-align="right">
									<xsl:value-of select="stmtext:formatNumber($value, $baseCurrency)" />
								</fo:block>
							</fo:table-cell>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="aggregateAmount">
								<xsl:for-each select="//stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='initialMarginSummaryTables']/stmt:sectionElement[@id='initialMarginTable']">
									<xsl:variable name="imSectionMTA">
										<xsl:value-of select="sum(//stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='initialMarginSummaryTables']/stmt:sectionElement[@id='initialMarginTable']/stmt:row[@id = 'MTA']/stmt:cell[@id = $header]/stmt:value[. &gt; 0]) -
																sum(//stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='initialMarginSummaryTables']/stmt:sectionElement[@id='initialMarginTable']/stmt:row[@id = 'MTA']/stmt:cell[@id = $header]/stmt:value[. &lt; 0])" />
									</xsl:variable>
									<xsl:variable name="titleHeader">
										<xsl:choose>
											<xsl:when test="$imSectionMTA != 0">
												<xsl:value-of select="'Net IM Excess/Deficit (Incl Pending) Including MTA'"/>
											</xsl:when>
											<xsl:otherwise>	
												<xsl:value-of select="'Net IM Excess/Deficit (Incl Pending)'"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									
									<xsl:variable name="netIMExOrDef" select="./stmt:row[@id = $titleHeader]/stmt:cell[@id = $header]/stmt:value" />
									<xsl:variable name="netAmt">	
										<xsl:choose>
											<xsl:when test="($netIMExOrDef &gt; 0)">
												<xsl:value-of select="stmtext:getNumber(my:getHaircutAmount($netIMExOrDef , my:getHaircutGrp(., ./stmt:row[@id = $titleHeader]/stmt:cell[@id = 'total']/stmt:value)))" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="stmtext:getNumber(my:getHaircutAmount($netIMExOrDef , my:getHaircutGrp(., ./stmt:row[@id = $titleHeader]/stmt:cell[@id = $header]/stmt:value)))"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<total>
										<xsl:value-of select="stmtext:getNumber($netAmt)" />
									</total>
								</xsl:for-each>
							</xsl:variable>
							<xsl:variable name="value" select="sum(exslt:node-set($aggregateAmount)/total)" />
							<fo:table-cell xsl:use-attribute-sets="bold-cell-style">
								<fo:block text-align="right">
									<xsl:value-of select="stmtext:formatNumber($value, $header)" />
								</fo:block>
							</fo:table-cell>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:for-each>
		</fo:table-row>
		<!-- Aggregate Net Excess/Deficit (Incl Pending) -->
		<fo:table-row xsl:use-attribute-sets="total-row-style">
			<xsl:for-each select="$headers">
				<xsl:variable name="header" select="." />
				<xsl:if test="($inactiveCurrencies and not($inactiveCurrencies[contains(., $header)])) or not($inactiveCurrencies)">
					<xsl:choose>
						<xsl:when test="$header = 'Row Id'">
							<fo:table-cell xsl:use-attribute-sets="bold-cell-style">
								<fo:block text-align="left">
									<xsl:value-of select="'Aggregate Net Excess/Deficit (Incl Pending)'" />
								</fo:block>
							</fo:table-cell>
						</xsl:when>
						<xsl:when test="contains($header, 'Total')">
							<xsl:variable name="aggregateAmount">
									<xsl:for-each select="//stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='initialMarginSummaryTables']/stmt:sectionElement[@id='initialMarginTable']">
										<xsl:variable name="titleHeader">
											<xsl:choose>
												<xsl:when test="$sumMTA != 0">
													<xsl:value-of select="'Net IM Excess/Deficit (Incl Pending) Including MTA'"/>
												</xsl:when>
												<xsl:otherwise>	
													<xsl:value-of select="'Net IM Excess/Deficit (Incl Pending)'"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>
										
										<xsl:variable name="netIMExOrDef" select="stmtext:getNumber(./stmt:row[@id = $titleHeader]/stmt:cell[@id = 'total']/stmt:value)" />
										<xsl:variable name="netAmt">	
											<xsl:choose>
												<xsl:when test="($netIMExOrDef &gt; 0)">
													<xsl:value-of select="stmtext:getNumber(my:getHaircutAmount($netIMExOrDef , my:getHaircutGrp(., ./stmt:row[@id = $titleHeader]/stmt:cell[@id = 'total']/stmt:value)))" />
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="stmtext:getNumber(my:getHaircutAmount($netIMExOrDef , my:getHaircutGrp(., ./stmt:row[@id = $titleHeader]/stmt:cell[@id = 'total']/stmt:value)))"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>
										<total>
											<xsl:value-of select="stmtext:getNumber($netAmt)" />
										</total>
									</xsl:for-each>
								</xsl:variable>
								<xsl:variable name="totalImExcessDeficit" select="sum(exslt:node-set($aggregateAmount)/total)" />
								<xsl:variable name="totalVmExcessDeficit" select="stmtext:getNumber(../../stmt:row[@id = 'Net VM Excess/Deficit (Incl Pending)']/stmt:cell[@id = 'total']/stmt:value)" />
							<fo:table-cell xsl:use-attribute-sets="bold-cell-style">
								<fo:block text-align="right">
									<xsl:value-of select="stmtext:formatNumber($totalImExcessDeficit + $totalVmExcessDeficit, $baseCurrency)" />
								</fo:block>
							</fo:table-cell>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="aggregateAmount">
								<xsl:for-each select="//stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='initialMarginSummaryTables']/stmt:sectionElement[@id='initialMarginTable']">
									<xsl:variable name="imSectionMTA">
											<xsl:value-of select="sum(//stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='initialMarginSummaryTables']/stmt:sectionElement[@id='initialMarginTable']/stmt:row[@id = 'MTA']/stmt:cell[@id = $header]/stmt:value[. &gt; 0]) -
																	sum(//stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='initialMarginSummaryTables']/stmt:sectionElement[@id='initialMarginTable']/stmt:row[@id = 'MTA']/stmt:cell[@id = $header]/stmt:value[. &lt; 0])" />
									</xsl:variable>
									<total>
										<xsl:choose>
											<xsl:when test="$imSectionMTA != 0">
												<xsl:value-of select="stmtext:getNumber(my:getHaircutAmount(./stmt:row[@id = 'Net IM Excess/Deficit (Incl Pending) Including MTA']/stmt:cell[@id = $header]/stmt:value, my:getHaircutGrp(., ./stmt:row[@id = 'Net IM Excess/Deficit (Incl Pending) Including MTA']/stmt:cell[@id = $header]/stmt:value)))"/>
											</xsl:when>
											<xsl:otherwise>	
												<xsl:value-of select="stmtext:getNumber(my:getHaircutAmount(./stmt:row[@id = 'Net IM Excess/Deficit (Incl Pending)']/stmt:cell[@id = $header]/stmt:value, my:getHaircutGrp(., ./stmt:row[@id = 'Net IM Excess/Deficit (Incl Pending)']/stmt:cell[@id = $header]/stmt:value)))"/>
											</xsl:otherwise>
										</xsl:choose>
									</total>
								</xsl:for-each>
							</xsl:variable>
							<xsl:variable name="imExcessDeficit" select="sum(exslt:node-set($aggregateAmount)/total)" />
							<xsl:variable name="vmExcessDeficit" select="../../stmt:row[@id = 'Net VM Excess/Deficit (Incl Pending)']/stmt:cell[@id = $header]/stmt:value" />
							<fo:table-cell xsl:use-attribute-sets="bold-cell-style">
								<fo:block text-align="right">
									<xsl:value-of select="stmtext:formatNumber($imExcessDeficit + $vmExcessDeficit, $header)" />
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

	<xsl:template name="buildCashFlowsSummary">
		<xsl:param name="inactiveCurrencies" />
		<xsl:variable name="translationsVar" select="'summary'" />
		<xsl:call-template name="appendFillerRow">
			<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
			<xsl:with-param name="inlineTitle" select="'Daily Statement'" />
			<xsl:with-param name="rowStyle" select="'SUB_TOTAL'" />
		</xsl:call-template>
		<xsl:for-each select="//stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:row">
			<xsl:variable name="rowId" select="./@id" />
			<xsl:if
				test="($rowId != 'FX Rates' and $rowId != 'Net VM Excess/Deficit (Incl Pending)' and $rowId != 'Pending Settlements') and (not(stmt:metaData/stmt:entry[@key = 'empty']) or stmt:metaData/stmt:entry[@key = 'empty'] != 'true')">
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
						<xsl:if test="contains($subtotalRows, $rowId) or contains($totalRows, $rowId)">bold</xsl:if>
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
								<xsl:if test="$rowId = 'Net VM Excess/Deficit (Incl Pending)' and $cellId != 'rowId' and ($value &lt; 0)">
									<xsl:attribute name="color">red</xsl:attribute>
								</xsl:if>
								<fo:block text-align="right">
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
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="buildSeparateSettlementsSection">
		<xsl:param name="inactiveCurrencies" />
		<xsl:variable name="ssTables"
			select="//stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id = 'separateSettlementSummaryTable']/stmt:sectionElement[@id = 'separateSettlementTables']" />
		<xsl:if test="$ssTables">
			<xsl:call-template name="appendFillerRow">
				<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
				<xsl:with-param name="inlineTitle" select="'Separate Settlements'" />
				<xsl:with-param name="rowStyle" select="'SUB_TOTAL'" />
			</xsl:call-template>
			<xsl:for-each select="$ssTables/stmt:metaData[generate-id() = generate-id(key('vmFlowsKey', stmt:entry[@key = 'INCLUDED_VM_FLOWS'])[1])]">
				<xsl:variable name="flowType" select="stmt:entry[@key = 'INCLUDED_VM_FLOWS']" />
				<fo:table-row xsl:use-attribute-sets="row-style">
					<xsl:for-each select="$headers">
						<xsl:variable name="header" select="." />
						<xsl:if test="($inactiveCurrencies and not($inactiveCurrencies[contains(., $header)])) or not($inactiveCurrencies)">
							<fo:table-cell xsl:use-attribute-sets="cell-style">
								<fo:block>
									<xsl:attribute name="text-align">right</xsl:attribute>
									<xsl:choose>
										<xsl:when test="$header = 'Row Id'">
											<xsl:value-of select="$flowType" />
										</xsl:when>
										<xsl:when test="contains($header, 'Total')">
											<xsl:variable name="summedTotal" select="sum($ssTables[stmt:metaData/stmt:entry[@key = 'INCLUDED_VM_FLOWS']/. = $flowType]/stmt:row[1]/stmt:cell[@id = 'total']/stmt:value)" />
											<xsl:value-of select="stmtext:formatNumber($summedTotal, $baseCurrency)" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:variable name="sum" select="sum($ssTables[stmt:metaData/stmt:entry[@key = 'INCLUDED_VM_FLOWS']/. = $flowType]/stmt:row[1]/stmt:cell[@id = $header]/stmt:value)" />
											<xsl:value-of select="stmtext:formatNumber($sum, $header)" />
										</xsl:otherwise>
									</xsl:choose>
								</fo:block>
							</fo:table-cell>
						</xsl:if>
					</xsl:for-each>
				</fo:table-row>
			</xsl:for-each>
			<fo:table-row xsl:use-attribute-sets="total-row-style">
				<xsl:for-each select="$headers">
					<xsl:variable name="header" select="." />
					<xsl:if test="($inactiveCurrencies and not($inactiveCurrencies[contains(., $header)])) or not($inactiveCurrencies)">
						<fo:table-cell xsl:use-attribute-sets="bold-cell-style">
							<fo:block>
								<xsl:choose>
									<xsl:when test="$header = 'Row Id'">
										<xsl:value-of select="'Net Excess/Deficit Separate Settlement'" />
									</xsl:when>
									<xsl:when test="contains($header, 'Total')">
										<xsl:attribute name="text-align">right</xsl:attribute>
										<xsl:variable name="summedTotal" select="sum($ssTables/stmt:row[1]/stmt:cell[@id = 'total']/stmt:value)" />
										<xsl:value-of select="stmtext:formatNumber($summedTotal, $baseCurrency)" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="text-align">right</xsl:attribute>
										<xsl:variable name="sum" select="sum($ssTables/stmt:row[1]/stmt:cell[@id = $header]/stmt:value)" />
										<xsl:value-of select="stmtext:formatNumber($sum, $header)" />
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</xsl:if>
				</xsl:for-each>
			</fo:table-row>
			<xsl:call-template name="appendFillerRow">
				<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="buildVMExcessDeficitSummary">
		<xsl:param name="inactiveCurrencies" />
		<xsl:variable name="vmCount"> 
			<xsl:value-of select="count(//stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:row[@id = 'Net VM']/stmt:cell)"/>
		</xsl:variable>
		<xsl:if test="($vmCount &gt; 0)">
			<fo:table-row xsl:use-attribute-sets="row-style">
				<xsl:for-each select="//stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:row[@id = 'Net VM']/stmt:cell">
					<xsl:variable name="header" select="@id" />
					<xsl:if test="($inactiveCurrencies and not($inactiveCurrencies[contains(., $header)])) or not($inactiveCurrencies)">
						<xsl:variable name="value">
							<xsl:choose>
								<xsl:when test="$header = 'total'">
									<xsl:value-of select="stmtext:formatNumber(stmt:value, $baseCurrency)" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="stmtext:formatNumber(stmt:value, $header)" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<fo:table-cell xsl:use-attribute-sets="cell-style">
							<fo:block>
								<xsl:choose>
									<xsl:when test="$header = 'rowId'">
										<xsl:value-of select="'Net VM Excess/Deficit (Excl Pending)'" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="text-align">right</xsl:attribute>
										<xsl:value-of select="$value" />
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</xsl:if>
				</xsl:for-each>
			</fo:table-row>
		</xsl:if>	
		<xsl:variable name="pendCount"> 
			<xsl:value-of select="count(//stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:row[@id = 'Pending Settlements']/stmt:cell)"/>
		</xsl:variable>
		<xsl:if test="($pendCount &gt; 0)">
			<fo:table-row xsl:use-attribute-sets="subtotal-row-style">
				<xsl:for-each
					select="//stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:row[@id = 'Pending Settlements']/stmt:cell">
					<xsl:variable name="header" select="@id" />
					<xsl:if test="($inactiveCurrencies and not($inactiveCurrencies[contains(., $header)])) or not($inactiveCurrencies)">
						<xsl:variable name="value">
							<xsl:choose>
								<xsl:when test="$header = 'total'">
									<xsl:value-of select="stmtext:formatNumber(stmt:value, $baseCurrency)" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="stmtext:formatNumber(stmt:value, $header)" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<fo:table-cell xsl:use-attribute-sets="cell-style">
							<fo:block>
								<xsl:choose>
									<xsl:when test="$header = 'rowId'">
										<xsl:value-of select="'Pending Settlements'" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="text-align">right</xsl:attribute>
										<xsl:value-of select="$value" />
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</xsl:if>
				</xsl:for-each>
			</fo:table-row>
		</xsl:if>
		<xsl:variable name="excessCount"> 
			<xsl:value-of select="count(//stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:row[@id = 'Net VM Excess/Deficit (Incl Pending)']/stmt:cell)"/>
		</xsl:variable>
		<xsl:if test="($excessCount &gt; 0)">
			<fo:table-row xsl:use-attribute-sets="total-row-style">
				<xsl:for-each
					select="//stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:row[@id = 'Net VM Excess/Deficit (Incl Pending)']/stmt:cell">
					<xsl:variable name="header" select="@id" />
					<xsl:if test="($inactiveCurrencies and not($inactiveCurrencies[contains(., $header)])) or not($inactiveCurrencies)">
						<xsl:variable name="value">
							<xsl:choose>
								<xsl:when test="$header = 'total'">
									<xsl:value-of select="stmtext:formatNumber(stmt:value, $baseCurrency)" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="stmtext:formatNumber(stmt:value, $header)" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<fo:table-cell xsl:use-attribute-sets="bold-cell-style">
							<fo:block>
								<xsl:choose>
									<xsl:when test="$header = 'rowId'">
										<xsl:value-of select="'Net VM Excess/Deficit (Incl Pending)'" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="text-align">right</xsl:attribute>
										<xsl:value-of select="$value" />
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</xsl:if>
				</xsl:for-each>
			</fo:table-row>
		</xsl:if>
		<xsl:call-template name="appendFillerRow">
			<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="buildAccrualsSection">
		<xsl:param name="inactiveCurrencies" />
		<xsl:variable name="accrualsTableSection" select="//stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='accrualsSummaryTable']" />
		<xsl:if test="count($accrualsTableSection/stmt:row) != count($accrualsTableSection/stmt:row/stmt:metaData/stmt:entry[@key = 'empty' and text() = 'true'])">
			<xsl:call-template name="appendFillerRow">
				<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
				<xsl:with-param name="inlineTitle" select="'Accruals'" />
				<xsl:with-param name="rowStyle" select="'SUB_TOTAL'" />
			</xsl:call-template>
			<xsl:for-each select="//stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='accrualsSummaryTable']/stmt:row">
				<xsl:variable name="row" select="." />
				<fo:table-row xsl:use-attribute-sets="row-style">
					<xsl:if test="@id = 'Net Fees &amp; Interest'">
						<xsl:attribute name="font-weight">bold</xsl:attribute>
						<xsl:attribute name="background-color">#E3F4FE</xsl:attribute>
						<xsl:attribute name="height">0.17in</xsl:attribute>
					</xsl:if>
					<xsl:for-each select="$headers">
						<xsl:variable name="header" select="." />
						<xsl:if test="($inactiveCurrencies and not($inactiveCurrencies[contains(., $header)])) or not($inactiveCurrencies)">
							<fo:table-cell xsl:use-attribute-sets="cell-style">
								<fo:block text-align="right">
									<xsl:variable name="value">
										<xsl:choose>
											<xsl:when test="$header = 'Row Id'">
												<xsl:value-of select="$row/stmt:cell/stmt:value" />
											</xsl:when>
											<xsl:when test="contains($header, 'Total')">
												<xsl:value-of select="stmtext:formatNumber($row/stmt:cell[@id = 'total']/stmt:value, $baseCurrency)" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:variable name="amount" select="$row/stmt:cell[@id = $header]/stmt:value" />
												<xsl:choose>
													<xsl:when test="$amount = 0 or not($amount)">
														<xsl:value-of select="stmtext:formatNumber(0.0, $header)" />
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="stmtext:formatNumber($amount, $header)" />
													</xsl:otherwise>
												</xsl:choose>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:value-of select="$value" />
								</fo:block>
							</fo:table-cell>
						</xsl:if>
					</xsl:for-each>
				</fo:table-row>
			</xsl:for-each>
			<xsl:call-template name="appendFillerRow">
				<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="buildPendingToCMSection">
		<xsl:param name="inactiveCurrencies" />
		<xsl:variable name="financialSummary" select="//stmt:ClearingStatement/stmt:section[@id='financialSummary']" />
		<xsl:variable name="imTables" select="$financialSummary/stmt:sectionElement[@id = 'initialMarginSummaryTables']/stmt:sectionElement[@id = 'initialMarginTable']" />
		
		<fo:table-row xsl:use-attribute-sets="row-style">
			<xsl:for-each select="$headers">
				<xsl:variable name="header" select="." />
				<xsl:if test="($inactiveCurrencies and not($inactiveCurrencies[contains(., $header)])) or not($inactiveCurrencies)">
					<fo:table-cell xsl:use-attribute-sets="cell-style">
						<fo:block text-align="right">
							<xsl:choose>
								<xsl:when test="$header = 'Row Id'">
									<xsl:value-of select="'Total Pending to CM'" />
								</xsl:when>
								<xsl:when test="contains($header, 'Total')">
									<xsl:variable name="amount" select="sum($imTables/stmt:row[@id = 'Net IM Excess/Deficit (Excl Pending)']/stmt:cell[@id = 'total']/stmt:value)" />
									<xsl:value-of select="stmtext:formatNumber($amount, $baseCurrency)" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:variable name="amount" select="sum($imTables/stmt:row[@id = 'Net IM Excess/Deficit (Excl Pending)']/stmt:cell[@id = $header]/stmt:value)" />
									<xsl:value-of select="stmtext:formatNumber($amount, $header)" />
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:table-cell>
				</xsl:if>
			</xsl:for-each>
		</fo:table-row>
		
		<fo:table-row xsl:use-attribute-sets="total-row-style">
			<xsl:for-each select="$headers">
				<xsl:variable name="header" select="." />
				<xsl:if test="($inactiveCurrencies and not($inactiveCurrencies[contains(., $header)])) or not($inactiveCurrencies)">
					<fo:table-cell xsl:use-attribute-sets="cell-style">
						<fo:block text-align="right">
							<xsl:variable name="cellValue">
								<xsl:choose>
									<xsl:when test="$header = 'Row Id'">
										<xsl:attribute name="class">TOTAL</xsl:attribute>
										<xsl:value-of select="concat('Aggregate ', my:resolveHaircutHeader('Net IM Excess/Deficit (Incl Pending)', $sumFXHaircut))" />
									</xsl:when>
									<xsl:when test="contains($header, 'Total')">
										<xsl:variable name="aggregateAmount">
											<xsl:for-each select="$imTables">
												<total>
													<xsl:value-of select="stmtext:getNumber(my:getHaircutAmount(./stmt:row[@id = 'Net IM Excess/Deficit (Incl Pending)']/stmt:cell[@id = 'total']/stmt:value, my:getHaircutGrp(., ./stmt:row[@id = 'Net IM Excess/Deficit (Incl Pending)']/stmt:cell[@id = 'total']/stmt:value)))"/>
												</total>
											</xsl:for-each>
										</xsl:variable>
										<xsl:variable name="value" select="sum(exslt:node-set($aggregateAmount)/total)" />
										<xsl:value-of select="stmtext:formatNumber($value, $baseCurrency)" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:variable name="aggregateAmount">
											<xsl:for-each select="$imTables">
												<total>
													<xsl:value-of select="stmtext:getNumber(my:getHaircutAmount(./stmt:row[@id = 'Net IM Excess/Deficit (Incl Pending)']/stmt:cell[@id = $header]/stmt:value, my:getHaircutGrp(., ./stmt:row[@id = 'Net IM Excess/Deficit (Incl Pending)']/stmt:cell[@id = $header]/stmt:value)))"/>
												</total>
											</xsl:for-each>
										</xsl:variable>
										<xsl:variable name="value" select="sum(exslt:node-set($aggregateAmount)/total)" />
										<xsl:value-of select="stmtext:formatNumber($value, $header)" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:value-of select="$cellValue" />
						</fo:block>
					</fo:table-cell>
				</xsl:if>
			</xsl:for-each>
		</fo:table-row>
		
		<fo:table-row xsl:use-attribute-sets="total-row-style">
			<xsl:for-each select="$headers">
				<xsl:variable name="header" select="." />
				<xsl:if test="($inactiveCurrencies and not($inactiveCurrencies[contains(., $header)])) or not($inactiveCurrencies)">
					<fo:table-cell xsl:use-attribute-sets="cell-style">
						<fo:block text-align="right">
							<xsl:variable name="cellValue">
								<xsl:choose>
									<xsl:when test="$header = 'Row Id'">
										<xsl:attribute name="class">TOTAL</xsl:attribute>
										<xsl:value-of select="concat('Aggregate ', my:resolveHaircutHeader('Net IM Excess/Deficit (Incl Pending) Including MTA', $sumFXHaircut))" />
									</xsl:when>
									<xsl:when test="contains($header, 'Total')">
										<xsl:variable name="aggregateAmount">
											<xsl:for-each select="$imTables">
												<total>
													<xsl:value-of select="stmtext:getNumber(my:getHaircutAmount(./stmt:row[@id = 'Net IM Excess/Deficit (Incl Pending) Including MTA']/stmt:cell[@id = 'total']/stmt:value, my:getHaircutGrp(., ./stmt:row[@id = 'Net IM Excess/Deficit (Incl Pending) Including MTA']/stmt:cell[@id = 'total']/stmt:value)))"/>
												</total>
											</xsl:for-each>
										</xsl:variable>
										<xsl:variable name="value" select="sum(exslt:node-set($aggregateAmount)/total)" />
										<xsl:value-of select="stmtext:formatNumber($value, $baseCurrency)" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:variable name="aggregateAmount">
											<xsl:for-each select="$imTables">
												<total>
													<xsl:value-of select="stmtext:getNumber(my:getHaircutAmount(./stmt:row[@id = 'Net IM Excess/Deficit (Incl Pending) Including MTA']/stmt:cell[@id = $header]/stmt:value, my:getHaircutGrp(., ./stmt:row[@id = 'Net IM Excess/Deficit (Incl Pending) Including MTA']/stmt:cell[@id = $header]/stmt:value)))"/>
												</total>
											</xsl:for-each>
										</xsl:variable>
										<xsl:variable name="value" select="sum(exslt:node-set($aggregateAmount)/total)" />
										<xsl:value-of select="stmtext:formatNumber($value, $header)" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:value-of select="$cellValue" />
						</fo:block>
					</fo:table-cell>
				</xsl:if>
			</xsl:for-each>
		</fo:table-row>
	</xsl:template>

	<xsl:template name="buildNetOfCashSection">
		<xsl:param name="inactiveCurrencies" />
		<xsl:param name="imCcpList" />
		<xsl:param name="aggregate" />
		<xsl:param name="hairCut" />

		<xsl:if test="($statementCashBreakDown and $statementCashBreakDown = 'true')">
			<fo:table-row xsl:use-attribute-sets="total-row-style">
				<xsl:for-each select="$headers">
					<xsl:variable name="header" select="." />
					<xsl:if test="($inactiveCurrencies and not($inactiveCurrencies[contains(., $header)])) or not($inactiveCurrencies)">
						<fo:table-cell xsl:use-attribute-sets="cell-style">
							<fo:block text-align="right">
								<xsl:variable name="cellValue">
									<xsl:choose>
										<xsl:when test="$header = 'Row Id'">
											<xsl:attribute name="class">TOTAL</xsl:attribute>
											<xsl:variable name="aggregateMTA">
												<xsl:for-each select="$imCcpList">
													<total >
														<xsl:value-of select="stmtext:getNumber(./stmt:row[@id = 'MTA']/stmt:cell[@id != 'rowId']/stmt:value)"/>
													</total>
												</xsl:for-each>
											</xsl:variable>
											<xsl:variable name="aggregateIM">
												<xsl:for-each select="$imCcpList">
													<total >
														<xsl:value-of select="stmtext:getNumber(./stmt:row[@id = 'Net IM Excess/Deficit (Incl Pending)']/stmt:cell[@id != 'rowId']/stmt:value)"/>
													</total>
												</xsl:for-each>
											</xsl:variable>
											<xsl:choose>
												<xsl:when test="sum(exslt:node-set($aggregateIM)/total) &lt; 0" >
													<xsl:choose>
														<xsl:when test="$imCcpList/stmt:row[@id = 'MTA'] and sum(exslt:node-set($aggregateMTA)/total) != 0" >
															<xsl:value-of select="concat($aggregate, my:resolveHaircutHeader('IM Excess/Deficit (Incl Pending &amp; MTA) Cash', $hairCut))" />
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="concat($aggregate, my:resolveHaircutHeader('IM Excess/Deficit (Incl Pending) Cash', $hairCut))" />
														</xsl:otherwise>
													</xsl:choose>
												</xsl:when>
												<xsl:otherwise>
													<xsl:choose>
														<xsl:when test="$imCcpList/stmt:row[@id = 'MTA'] and sum(exslt:node-set($aggregateMTA)/total) != 0" >
															<xsl:value-of select="concat($aggregate, 'IM Excess/Deficit (Incl Pending &amp; MTA) Cash')" />
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="concat($aggregate, 'IM Excess/Deficit (Incl Pending) Cash')" />
														</xsl:otherwise>
													</xsl:choose>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:when>

										<xsl:when test="contains($header, 'Total')">
											<xsl:variable name="aggregateAmount">
												<xsl:for-each select="$imCcpList">
													<total >
														<xsl:choose>
															<xsl:when test="stmtext:getNumber(./stmt:row[@id = 'Net IM Excess/Deficit (Incl Pending) Including MTA']/stmt:cell[@id = 'total']/stmt:value) &lt; 0" >
																<xsl:value-of select="stmtext:getNumber(my:getHaircutAmount(./stmt:row[@id = 'Net IM Excess/Deficit (Incl Pending) Including MTA']/stmt:cell[@id = 'total']/stmt:value, my:getHaircutGrp(., ./stmt:row[@id = 'Net IM Excess/Deficit (Incl Pending) Including MTA']/stmt:cell[@id = 'total']/stmt:value)))"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="stmtext:getNumber(./stmt:row[@id = 'Net IM Excess/Deficit (Incl Pending) Including MTA']/stmt:cell[@id = 'total']/stmt:value)" />
															</xsl:otherwise>
														</xsl:choose>													
													</total>
												</xsl:for-each>
											</xsl:variable>
											<xsl:variable name="aggregateCash">
												<xsl:for-each select="$imCcpList">
													<total >
														<xsl:value-of select="./stmt:row[@id = 'Cash Balance']/stmt:cell[@id = 'total']/stmt:value + ./stmt:row[@id = 'Pending Cash Collateral']/stmt:cell[@id = 'total']/stmt:value"/>
													</total>
												</xsl:for-each>
											</xsl:variable>
											<xsl:variable name="netIMExcessOrDeficitInclMtaAmount" select="sum(exslt:node-set($aggregateAmount)/total)" />
											<!--xsl:variable name="totalCash" select="sum($imCcpList/stmt:row[@id = 'Cash Balance']/stmt:cell[@id = 'total']/stmt:value) + sum($imCcpList/stmt:row[@id = 'Pending Cash Collateral']/stmt:cell[@id = 'total']/stmt:value)" /-->
											<xsl:variable name="totalCash" select="sum(exslt:node-set($aggregateCash)/total)" />
											<xsl:variable name="currency" select="$baseCurrency"/>
											<xsl:call-template name="buildCashSectionCondition">
												<xsl:with-param name="currency" select="$currency" />
												<xsl:with-param name="netIMExcessOrDeficit" select="$netIMExcessOrDeficitInclMtaAmount" />
												<xsl:with-param name="totalCash" select="$totalCash" />
											</xsl:call-template>
										</xsl:when>

										<xsl:when test="not(contains($header, 'Total')) and not($header = 'Row Id')">
											<xsl:variable name="aggregateAmount">
												<xsl:for-each select="$imCcpList">
													<total>
														<xsl:choose>
															<xsl:when test="stmtext:getNumber(./stmt:row[@id = 'Net IM Excess/Deficit (Incl Pending) Including MTA']/stmt:cell[@id = $header]/stmt:value) &lt; 0" >
																<xsl:value-of select="stmtext:getNumber(my:getHaircutAmount(./stmt:row[@id = 'Net IM Excess/Deficit (Incl Pending) Including MTA']/stmt:cell[@id = $header]/stmt:value, my:getHaircutGrp(., ./stmt:row[@id = 'Net IM Excess/Deficit (Incl Pending) Including MTA']/stmt:cell[@id = $header]/stmt:value)))"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="stmtext:getNumber(./stmt:row[@id = 'Net IM Excess/Deficit (Incl Pending) Including MTA']/stmt:cell[@id = $header]/stmt:value)" />
															</xsl:otherwise>
														</xsl:choose>
													</total>
												</xsl:for-each>
											</xsl:variable>
											<xsl:variable name="aggregateCash">
												<xsl:for-each select="$imCcpList">
													<total >
														<xsl:value-of select="./stmt:row[@id = 'Cash Balance']/stmt:cell[@id = $header]/stmt:value + ./stmt:row[@id = 'Pending Cash Collateral']/stmt:cell[@id = $header]/stmt:value"/>
													</total>
												</xsl:for-each>
											</xsl:variable>
											<xsl:variable name="netIMExcessOrDeficitInclMtaAmount" select="sum(exslt:node-set($aggregateAmount)/total)" />
											<!--xsl:variable name="totalCash" select="sum($imCcpList/stmt:row[@id = 'Cash Balance']/stmt:cell[@id = $header]/stmt:value) + sum($imCcpList/stmt:row[@id = 'Pending Cash Collateral']/stmt:cell[@id = $header]/stmt:value)" /-->
											<xsl:variable name="totalCash" select="sum(exslt:node-set($aggregateCash)/total)" />
											<xsl:variable name="currency" select="$header"/>
											<xsl:call-template name="buildCashSectionCondition">
												<xsl:with-param name="currency" select="$currency" />
												<xsl:with-param name="netIMExcessOrDeficit" select="$netIMExcessOrDeficitInclMtaAmount" />
												<xsl:with-param name="totalCash" select="$totalCash" />
											</xsl:call-template>
										</xsl:when>
									</xsl:choose>
								</xsl:variable>
								<xsl:value-of select="$cellValue" />
							</fo:block>
						</fo:table-cell>
					</xsl:if>
				</xsl:for-each>
			</fo:table-row>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="buildCashSectionCondition">
		<xsl:param name="currency" />
		<xsl:param name="netIMExcessOrDeficit" />
		<xsl:param name="totalCash" />
		<xsl:value-of select="stmtext:formatNumber($netIMExcessOrDeficit, $currency)" />
	</xsl:template>

	<xsl:template name="buildIMFXHaircutSection">
		<xsl:param name="inactiveCurrencies" />
		<xsl:param name="ccp" />
		<xsl:param name="ccy" />
		<xsl:param name="hairCutGrp" />
		
		<fo:table-row xsl:use-attribute-sets="total-row-style">
			<xsl:for-each select="//stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:header/stmt:headerName">
				<xsl:variable name="header" select="." />
				<xsl:if test="($inactiveCurrencies and not($inactiveCurrencies[contains(., $header)])) or not($inactiveCurrencies)">
					<fo:table-cell xsl:use-attribute-sets="cell-style">
						<fo:block text-align="right">
							<xsl:variable name="cellValue">
								<xsl:choose>
									<xsl:when test="$header = 'Row Id'">
										<xsl:attribute name="class">TOTAL</xsl:attribute>
										<xsl:value-of select="concat($ccp, ' FX Haircut % Rates')" />
									</xsl:when>
									<xsl:when test="not(contains($header, 'Total')) and not($header = 'Row Id')">
										<xsl:choose>
											<xsl:when test="$header = $ccy and count($hairCutGrp/hairCut)&gt;0 and stmtext:getNumber(sum($hairCutGrp/hairCut)) != 0 ">
												<xsl:value-of select="stmtext:formatNumber($hairCutGrp/hairCut, $ccy)" /> 
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="stmtext:formatNumber(0.00, $ccy)" /> 
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:otherwise>
										<p>    </p>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:value-of select="$cellValue" />
						</fo:block>
					</fo:table-cell>
				</xsl:if> 
			</xsl:for-each>
		</fo:table-row>
	</xsl:template>
	
	<xsl:template name="buildIMSectionRows">
		<xsl:param name="imTables" />
		<xsl:param name="inactiveCurrencies" />
		<xsl:param name="ccp" />
		<xsl:param name="product" />
		<xsl:param name="rowId" />
		<xsl:param name="rowNode" />
		<xsl:param name="useHairCut" />
		<xsl:param name="hairCutGrp" />

		<xsl:variable name="applyHaircut">
			<xsl:choose>
				<xsl:when test="$rowId = 'Net IM Excess/Deficit (Incl Pending) Including MTA'">
					2
				</xsl:when>
				<xsl:when test="$useHairCut = 2 ">
					2
				</xsl:when>
				<xsl:otherwise>
					1
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="imCCPServiceTable" select="$imTables[stmt:metaData/stmt:entry[@key = 'ccp'] = $ccp and stmt:metaData/stmt:entry[@key = 'product'] = $product]" />
		<xsl:variable name="imAmount" select="sum($imCCPServiceTable/stmt:row[@id = 'Net IM Excess/Deficit (Incl Pending)']/stmt:cell[@id = 'total']/stmt:value)" />
		<xsl:variable name="currency" select="." />
		<xsl:if test="($inactiveCurrencies and not($inactiveCurrencies[contains(., $currency)])) or not($inactiveCurrencies)">
			<fo:table-cell xsl:use-attribute-sets="cell-style">
				<fo:block text-align="right">
					<xsl:variable name="cellValue">
						<xsl:choose>
							<xsl:when test="contains($currency, 'Row Id')">
								<xsl:choose>
									<xsl:when test="contains($subtotalRows, $rowNode/@id)">
										<xsl:attribute name="height">0.14in</xsl:attribute>
										<xsl:attribute name="font-weight">bold</xsl:attribute>
										<xsl:attribute name="background-color">#E3F4FE</xsl:attribute>
									</xsl:when>
									<xsl:when test="contains($totalRows, $rowNode/@id)">
										<xsl:attribute name="height">0.14in</xsl:attribute>
										<xsl:attribute name="font-weight">bold</xsl:attribute>
										<xsl:attribute name="background-color">#B2DCF9</xsl:attribute>
									</xsl:when>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="$rowId = 'Net IM Excess/Deficit (Incl Pending)' and $applyHaircut = 1">
										<xsl:value-of select="$rowNode/stmt:cell[@id = 'rowId']/stmt:value" /> 
									</xsl:when>
									<xsl:when test="$rowId = 'Net IM Excess/Deficit (Incl Pending) Including MTA' and $imAmount &gt; 0">
										<xsl:value-of select="$rowNode/stmt:cell[@id = 'rowId']/stmt:value" /> 
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="my:resolveHaircutHeader($rowNode/stmt:cell[@id = 'rowId']/stmt:value, $hairCutGrp/hairCut)" /> 
									</xsl:otherwise> 
								</xsl:choose>
							</xsl:when>
							<xsl:when test="contains($currency, 'Total')">
								<xsl:variable name="amount" select="sum($imCCPServiceTable/stmt:row[@id = $rowNode/@id]/stmt:cell[@id = 'total']/stmt:value)" />
								<xsl:if test="($rowId = 'Net IM Excess/Deficit (Incl Pending)' or $rowId = 'Net IM Excess/Deficit (Incl Pending) Post FX Haircut') and ($amount &lt; 0)">
									<xsl:attribute name="color">red</xsl:attribute>
								</xsl:if>
								<xsl:choose>
									<xsl:when test="$applyHaircut = 2">
										<xsl:value-of select="stmtext:formatNumber(my:getHaircutAmount($amount, $hairCutGrp), $baseCurrency)" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="stmtext:formatNumber($amount, $baseCurrency)" /> 
									</xsl:otherwise> 
								</xsl:choose>  
							</xsl:when> 
							<xsl:otherwise>
								<xsl:variable name="amount"	select="sum($imCCPServiceTable/stmt:row[@id = $rowNode/@id]/stmt:cell[@id = $currency]/stmt:value)" />
								<xsl:if test="$rowId = 'Net Excess/Deficit' and ($amount &lt; 0)">
									<xsl:attribute name="color">red</xsl:attribute>
								</xsl:if>
								<xsl:choose>
									<xsl:when test="$applyHaircut = 2">
										<xsl:value-of select="stmtext:formatNumber(my:getHaircutAmount($amount, $hairCutGrp), $baseCurrency)" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="stmtext:formatNumber($amount, $baseCurrency)" /> 
									</xsl:otherwise> 
								</xsl:choose>
							</xsl:otherwise>  
						</xsl:choose>
					</xsl:variable>
					<xsl:value-of select="$cellValue" />
				</fo:block>
			</fo:table-cell>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="buildImSection">
		<xsl:param name="inactiveCurrencies" />
		<xsl:variable name="financialSummary" select="//stmt:ClearingStatement/stmt:section[@id='financialSummary']" />
		<xsl:variable name="imTables" select="$financialSummary/stmt:sectionElement[@id = 'initialMarginSummaryTables']/stmt:sectionElement[@id = 'initialMarginTable']" />
		
		<xsl:apply-templates select="$financialSummary/stmt:sectionElement[@id='initialMarginSummaryTables']">
			<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
		</xsl:apply-templates>
		
		<xsl:call-template name="buildPendingToCMSection">
			<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
		</xsl:call-template>
		
		<xsl:call-template name="buildNetOfCashSection">
			<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
			<xsl:with-param name="imCcpList" select="exslt:node-set($imTables)" />
			<xsl:with-param name="aggregate" select="'Aggregate Net '" />
			<xsl:with-param name="hairCut" select="$sumFXHaircut" />
		</xsl:call-template>
		
	</xsl:template>

	<xsl:template match="stmt:sectionElement[@id = 'initialMarginSummaryTables']">
		<xsl:param name="imTables" select="stmt:sectionElement[@id = 'initialMarginTable']" />
		<xsl:param name="inactiveCurrencies" />
		<xsl:for-each select="$imTables/stmt:metaData[generate-id() = generate-id(key('clearingServiceKey', concat(stmt:entry[@key='ccp'], '|', stmt:entry[@key='product']))[1])]">
			<xsl:variable name="currPos" select="position()"/>
			<xsl:variable name="imNode" select="$imTables[$currPos]" />
			<xsl:variable name="ccp" select="stmt:entry[@key = 'ccp']" />
			<xsl:variable name="ccy" select="stmt:entry[@key = 'ccy']" />
			<xsl:variable name="product" select="stmt:entry[@key = 'product']" />
			<xsl:variable name="imCcpList" select="$imTables[concat(stmt:metaData/stmt:entry[@key='ccp'], stmt:metaData/stmt:entry[@key='product']) = concat($ccp, $product)]"/>
			
			<xsl:if test="$imTables[stmt:metaData/stmt:entry[@key = 'ccp'] = $ccp]/stmt:row/stmt:cell[@id != 'rowId']/stmt:value != 0.0">
				<xsl:call-template name="appendFillerRow">
					<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
					<xsl:with-param name="inlineTitle" select="concat($ccp, ' Initial Margin - ', $product)" />
					<xsl:with-param name="rowStyle" select="'SUB_TOTAL'" />
				</xsl:call-template>
				
				<xsl:variable name="vConcept" select="'Net IM Excess/Deficit (Incl Pending)'"/>
				<xsl:variable name="sumTotalValue">
					<xsl:value-of select="sum($imCcpList/stmt:row[@id='Net IM Excess/Deficit (Incl Pending)']/stmt:cell[@id != 'rowId']/stmt:value)" />
				</xsl:variable>
				<xsl:variable name="hairCutGrp" select="my:getHaircutGrp($imNode, $sumTotalValue)" />

				<xsl:variable name="sumIMTableMTA">
					<xsl:value-of select="sum($imCcpList/stmt:row[@id='MTA']/stmt:cell[@id != 'rowId']/stmt:value[. &gt; 0]) -
                              sum($imCcpList/stmt:row[@id='MTA']/stmt:cell[@id != 'rowId']/stmt:value[. &lt; 0])" />
				</xsl:variable>
				
				<xsl:for-each select="$imTables[1]/stmt:row">
					<xsl:variable name="rowId" select="@id" />
					<xsl:variable name="rowNode" select="." />

					
					<xsl:choose>
						<xsl:when test="$rowId = 'Margin Requirement'">
								<fo:table-row xsl:use-attribute-sets="row-style">
									<xsl:for-each select="//stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:header/stmt:headerName">
										<xsl:variable name="header" select="." />
										<xsl:if test="($inactiveCurrencies and not($inactiveCurrencies[contains(., $header)])) or not($inactiveCurrencies)">
											<fo:table-cell xsl:use-attribute-sets="cell-style">
												<fo:block text-align="right">
													<xsl:choose>
														<xsl:when test="contains($header, 'Row Id')">
															<xsl:value-of select="concat($product, ' Requirement')" />
														</xsl:when>
														<xsl:otherwise>
															<xsl:variable name="amount"
															select="sum($imTables[stmt:metaData/stmt:entry[@key = 'ccp'] = $ccp and stmt:metaData/stmt:entry[@key = 'product'] = $product]/stmt:row[@id = $rowNode/@id]/stmt:cell[@id = $header or (contains($header, 'Total') and @id = 'total')]/stmt:value)" />
															<xsl:choose>
																<xsl:when test="not($amount) or $amount = 0">
																	<xsl:value-of select="stmtext:formatNumber(0.0, $header)" />
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="stmtext:formatNumber($amount, $header)" />
																</xsl:otherwise>
															</xsl:choose>
														</xsl:otherwise>
													</xsl:choose>
												</fo:block>
											</fo:table-cell>
										</xsl:if>
									</xsl:for-each>
								</fo:table-row>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="displayRow">
								<xsl:choose>
									<xsl:when test="($rowId = 'MTA' or contains($rowId, 'Including MTA')) and $sumIMTableMTA = 0">
										<xsl:value-of select="'false'" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="'true'" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
						
 							<xsl:if test="contains($displayRow, 'true')">
								<fo:table-row xsl:use-attribute-sets="total-row-style">
									<xsl:choose>
										<xsl:when test="contains($subtotalRows, $rowId) and $rowId != 'Cash Balance'">
											<xsl:attribute name="height">0.14in</xsl:attribute>
											<xsl:attribute name="font-weight">bold</xsl:attribute>
											<xsl:attribute name="background-color">#e0f4ff</xsl:attribute>
										</xsl:when>
										<xsl:when test="contains($totalRows, $rowNode/@id)">
											<xsl:attribute name="height">0.14in</xsl:attribute>
											<xsl:attribute name="font-weight">bold</xsl:attribute>
											<xsl:attribute name="background-color">#B2DCF9</xsl:attribute>
										</xsl:when>
										<xsl:otherwise>
											<xsl:attribute name="height">0.17in</xsl:attribute>
											<xsl:attribute name="background-color">#ffffff</xsl:attribute>
											<xsl:attribute name="font-weight">normal</xsl:attribute>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:for-each select="//stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:header/stmt:headerName">
										<xsl:call-template name="buildIMSectionRows">
											<xsl:with-param name="imTables" select="$imTables" />
											<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
											<xsl:with-param name="ccp" select="$ccp" />
											<xsl:with-param name="product" select="$product" />
											<xsl:with-param name="rowId" select="$rowId" />
											<xsl:with-param name="rowNode" select="$rowNode" />
											<xsl:with-param name="useHairCut" select="1" />
											<xsl:with-param name="hairCutGrp" select="$hairCutGrp" />
										</xsl:call-template>
									</xsl:for-each>
								</fo:table-row>
								
								
								<xsl:if test="stmtext:getNumber(sum($hairCutGrp/hairCut)) != 0">
									<xsl:if test="$rowId = 'Net IM Excess/Deficit (Incl Pending)'">
										<xsl:call-template name="buildIMFXHaircutSection">
											<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
											<xsl:with-param name="ccp" select="$ccp" />
											<xsl:with-param name="ccy" select="$ccy" />
											<xsl:with-param name="hairCutGrp" select="$hairCutGrp" />
										</xsl:call-template>

										<fo:table-row xsl:use-attribute-sets="total-row-style">
											<xsl:for-each select="//stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:header/stmt:headerName">
												<xsl:call-template name="buildIMSectionRows">
													<xsl:with-param name="imTables" select="$imTables" />
													<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
													<xsl:with-param name="ccp" select="$ccp" />
													<xsl:with-param name="product" select="$product" />
													<xsl:with-param name="rowId" select="$rowId" />
													<xsl:with-param name="rowNode" select="$rowNode" />
													<xsl:with-param name="useHairCut" select="2" />
													<xsl:with-param name="hairCutGrp" select="$hairCutGrp" />
												</xsl:call-template>
											</xsl:for-each>
										</fo:table-row>
									</xsl:if>
								</xsl:if>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				<xsl:call-template name="buildNetOfCashSection">
					<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
					<xsl:with-param name="imCcpList" select="exslt:node-set($imCcpList)" />
					<xsl:with-param name="aggregate" select="'Net '" />
					<xsl:with-param name="hairCut" select="$hairCutGrp/hairCut" />
				</xsl:call-template>
				<xsl:call-template name="appendFillerRow">
					<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
				</xsl:call-template>
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
		match="stmt:sectionElement[@id='newTradesIRS' or @id='newTradesNDF' or @id='newTradesCreditDerivatives' or @id='newTradesFX' 
      			or @id='openTradesIRS' or @id='openTradesNDF' or @id='openTradesCreditDerivatives' or @id='openTradesFX' 
      			or @id='terminatedTradesIRS' or @id='terminatedTradesNDF' or @id='terminatedTradesCreditDerivatives' or @id='terminatedTradesFX' 
      			or @id='maturedTradesIRS' or @id='maturedTradesNDF' or @id='maturedTradesCreditDerivatives' or @id='maturedTradesFX']">
		<xsl:variable name="product" select="stmt:metaData/stmt:entry[@key='product']" />
		<xsl:variable name="productAvailable" select="../../stmt:metaData/stmt:entry[@key=$product]" />
		<xsl:if test="count(stmt:row) &gt; 0">
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
				<xsl:variable name="ccps" select="$sectionElement/stmt:row/stmt:metaData/stmt:entry[@key='ccp'][generate-id() = generate-id(key($key, text())[1])]" />
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
		<xsl:param name="inlineTitle" />

		<!-- Adding table columns -->
		<xsl:apply-templates select="stmt:headerName" mode="fo-table-column">
			<xsl:with-param name="translationsVar" select="$translationsVar" />
			<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
			<xsl:with-param name="inlineTitle" select="$inlineTitle" />
		</xsl:apply-templates>
		
		<fo:table-header border-style='solid' background-color='#E3F4FE'>
			<fo:table-row>
				<xsl:attribute name="font-weight">bold</xsl:attribute>
				<xsl:apply-templates select="stmt:headerName">
					<xsl:with-param name="translationsVar" select="$translationsVar" />
					<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
					<xsl:with-param name="inlineTitle" select="$inlineTitle" />
				</xsl:apply-templates>
			</fo:table-row>
		</fo:table-header>
	</xsl:template>

	<!-- A template to specify different width for columns for a particular table (via input param: tablenameVar) -->
	<xsl:template match="stmt:headerName" mode="fo-table-column">
		<xsl:param name="translationsVar" />
		<xsl:param name="inactiveCurrencies" />
		<xsl:param name="inlineTitle" />
		<xsl:param name="tablenameVar" />
		
		<xsl:variable name="column" select="text()" />
		<xsl:variable name="translation" select="stmtext:getTranslation($translationsVar, $column)" />
		<xsl:variable name="value">
			<xsl:choose>
				<xsl:when test="$translation = 'Total (__BASE_CURRENCY__)'">
					<!-- Ugly hack for non-EXSLT workaround: the document()// approach selects from the source XSL document, so there can be no evaluations inside the translations vars. So far 
						the only one is the base currency translation for total headers -->
					<xsl:value-of select="concat('Total (' , $baseCurrency , ')')" />
				</xsl:when>
				<xsl:when test="$translation">
					<xsl:value-of select="$translation" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="text()" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="text()='Row Id'">
				<fo:table-column column-width="proportional-column-width(2)" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="($inactiveCurrencies and not($inactiveCurrencies[contains(text(), $column)])) or not($inactiveCurrencies)">
					<xsl:choose>
						<xsl:when test="($tablenameVar='accountActivity' and $value='Type')
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
		<xsl:param name="inlineTitle" />
		<xsl:variable name="column" select="text()" />
		<xsl:variable name="translation" select="stmtext:getTranslation($translationsVar, $column)" />
		<xsl:variable name="value">
			<xsl:choose>
				<xsl:when test="$translation = 'Total (__BASE_CURRENCY__)'">
					<!-- Ugly hack for non-EXSLT workaround: the document()// approach selects from the source XSL document, so there can be no evaluations inside the translations vars. So far 
						the only one is the base currency translation for total headers -->
					<xsl:value-of select="concat('Total (' , $baseCurrency , ')')" />
				</xsl:when>
				<xsl:when test="$translation">
					<xsl:value-of select="$translation" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="text()" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="text()='Row Id' and $inlineTitle">
				<fo:table-cell xsl:use-attribute-sets="cell-style">
					<fo:block color="#357D22">
						<xsl:value-of select="$inlineTitle" />
					</fo:block>
				</fo:table-cell>
			</xsl:when>
			<xsl:when test="text()='Row Id'">
				<fo:table-cell xsl:use-attribute-sets="cell-style">
					<fo:block color="#357D22">
						
					</fo:block>
				</fo:table-cell>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="($inactiveCurrencies and not($inactiveCurrencies[contains(text(), $column)])) or not($inactiveCurrencies)">
					<fo:table-cell xsl:use-attribute-sets="cell-style">
						<fo:block text-align="center" color="black">
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
				<xsl:when test="$sectionId = 'financialSummary' and string(number($value)) != 'NaN' and $cellId = 'total' and $rowId != 'FX Rates'">
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
	
	<func:function name="my:getHaircutGrp">
		<xsl:param name="imTable"/>
		<xsl:param name="amount"/>
		
		<xsl:variable name="hairCutGrp">
			<xsl:choose>
				<xsl:when test="$amount &gt; 0">
					<hairCut>
						<xsl:choose>
							<xsl:when test="$imTable/stmt:metaData/stmt:entry[@key='CP Haircut'] &lt; 0">
								<xsl:value-of select="$imTable/stmt:metaData/stmt:entry[@key='CP Haircut'] * -1"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$imTable/stmt:metaData/stmt:entry[@key='CP Haircut']"/>
							</xsl:otherwise>
						</xsl:choose>
					</hairCut>
					<hairCutType>
						<xsl:value-of select="$imTable/stmt:metaData/stmt:entry[@key='CP Haircut Type']"/>
					</hairCutType>
				</xsl:when>
				<xsl:otherwise>
					<hairCut>
						<xsl:choose>
							<xsl:when test="$imTable/stmt:metaData/stmt:entry[@key='PO Haircut'] &lt; 0">
								<xsl:value-of select="$imTable/stmt:metaData/stmt:entry[@key='PO Haircut'] * -1"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$imTable/stmt:metaData/stmt:entry[@key='PO Haircut']"/>
							</xsl:otherwise>
						</xsl:choose>
					</hairCut>
					<hairCutType>
						<xsl:value-of select="$imTable/stmt:metaData/stmt:entry[@key='PO Haircut Type']"/>
					</hairCutType>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<func:result select="exslt:node-set($hairCutGrp)" />
	</func:function>
		
	
	<func:function name="my:getHaircutAmount">
		<xsl:param name="amount"/>
		<xsl:param name="hairCutGrp"/>
		
		<xsl:choose>
			<xsl:when test="$amount = 0">
				<func:result select="0.0" /> 
			</xsl:when>
			<xsl:when test="string(number($hairCutGrp/hairCut)) = 'NaN' or $hairCutGrp/hairCut = 0">
				<func:result select="$amount" /> 
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="string($hairCutGrp/hairCutType) = 'Inverse'">
						<func:result select="$amount * (1 + $hairCutGrp/hairCut div 100)" />
					</xsl:when>
					<xsl:otherwise>
						<func:result select="$amount div (1 - $hairCutGrp/hairCut div 100)" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</func:function>
	
	<func:function name="my:getHaircutPercentage">
		<xsl:param name="amount"/>
		<xsl:param name="hairCutGrp"/>
		
		<xsl:choose>
			<xsl:when test="$amount = 0">
				<func:result select="0.0" /> 
			</xsl:when>
			<xsl:when test="string(number($hairCutGrp/hairCut)) = 'NaN' or $hairCutGrp/hairCut = 0 or $amount &gt; 0">
				<func:result select="0.0" /> 
			</xsl:when>
			<xsl:otherwise>
				<func:result select="$hairCutGrp/hairCut" />
			</xsl:otherwise>
		</xsl:choose>
	</func:function>
	
	
	<func:function name="my:resolveHaircutHeader">
		<xsl:param name="header"/>
		<xsl:param name="hairCut"/>

		<xsl:choose>
			<xsl:when test="string(number($hairCut)) = 'NaN' or $hairCut = 0">
				<func:result select="$header" /> 
			</xsl:when>
			<xsl:when test="$header = 'Net IM Excess/Deficit (Incl Pending) Including MTA'">
				<func:result select="string('Net IM Excess/Deficit (Incl Pending and FX Haircut) Including MTA')" /> 
			</xsl:when>
			<xsl:when test="$header = 'Net IM Excess/Deficit (Incl Pending)'">
				<func:result select="string('Net IM Excess/Deficit (Incl Pending and FX Haircut)')" /> 
			</xsl:when>
			<xsl:when test="$header = 'IM Excess/Deficit (Incl Pending &amp; MTA) Cash'">
				<func:result select="string('IM Excess/Deficit (Incl Pending &amp; FX Haircut) Cash including MTA')" /> 
			</xsl:when>
			<xsl:when test="$header = 'IM Excess/Deficit (Incl Pending) Cash'">
				<func:result select="string('IM Excess/Deficit (Incl Pending &amp; FX Haircut) Cash')" /> 
			</xsl:when>
			<xsl:otherwise>
				<func:result select="$header" /> 
			</xsl:otherwise>
		</xsl:choose>	
	</func:function>
</xsl:stylesheet>