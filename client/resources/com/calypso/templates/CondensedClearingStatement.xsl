<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:stmt="urn:com:calypso:clearing:statement" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:stmtext="xalan://com.calypso.tk.bo.StatementDataTypeFormatter" xmlns:xalan="http://xml.apache.org/xalan" xmlns:exslt="http://exslt.org/common"   
	extension-element-prefixes="stmtext exslt" exclude-result-prefixes="xs stmtext">

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
		<html>
			<head>
				<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
				<title>Clearing Statement</title>
				<style type="text/css">

					body {
					text-align: justify;
					font-family: Tahoma,
					Geneva, sans-serif;
					}

					div.SECTION {
					margin-left: 1em;
					}

					div.SECTION_ELEMENT {
					margin-left:
					2em;
					}

					div.SUB_SECTION_ELEMENT {
					margin-left: 2em;
					}

					div.INNER_DIV {
					margin-left: 2em;
					}

					p.FOOTER {
					text-align: center;
					font-size: 8px;
					}

					p.TITLE {
					text-align: center;
					font-size:
					1.5em;
					text-decoration:
					underline;
					}

					p.SECTION_TITLE {
					text-align: justify;
					font-size: 1.25em;
					}

					p.SECTION_ELEMENT_TITLE {
					text-align: justify;
					font-size: 1.0em;
					}

					p.SECTION_ELEMENT_SUB_TITLE {
					text-align:
					justify;
					font-size: 0.8em;
					}

					p.DETAIL {
					margin-left: 1em;
					font-size: 0.8em;
					font-style: italic;
					}

					table {
					border: 1.0px solid
					black;
					border-collapse: collapse;
					font-size: 0.7em;
					}

					th {
					border: 1.0px
					solid black;
					background-color: #5577B6;
					white-space: nowrap;
					text-align: center;
					padding: 0.40em;
					color: WHITE;
					}

					tr.SUB_TOTAL {
					background-color: #e0f4ff;
					font-weight: bold;
					}

					tr.TOTAL {
					background-color: #FFF500;
					font-weight: bold;
					}

					td {
					border: 1.0px solid black;
					white-space: nowrap;
					text-align: right;
					padding: 0.54em;
					}

					td.FILLER-LEFT {
					border-left: 1.0px solid black;
					border-right: none;
					height: .22in;
					}

					td.FILLER-RIGHT {
					border-right:
					1.0px solid black;
					border-left: none;
					height: .22in;
					}

					td.FILLER {
					height: .22in;
					border-style: none;
					}

					td.SUB_TOTAL {
					font-weight:
					bold;
					}

					td.TOTAL {
					text-align: left;
					font-weight: bold;
					}

					td.DEFICIT_TOTAL_NUMBER {
					color: red;
					}

					td.PRINCIPAL_CCY {
					background-color: #BBFFCC;
					}

				</style>
			</head>
			<body>
				<p>
					<img src="https://www.calypso.com/images/logo.gif" alt="Logo" />
				</p>
				<p class="TITLE">
					<xsl:value-of select="stmt:metaData/stmt:entry[@key='mode']" />
					Statement on
					<xsl:value-of select="stmt:metaData/stmt:entry[@key='statementDate']" />
					for
					<xsl:value-of select="stmt:metaData/stmt:entry[@key='receiver']" />
				</p>
				<xsl:value-of select="stmt:metaData/stmt:entry[@key='receiver']" />
				<br />
				<xsl:value-of select="stmt:metaData/stmt:entry[@key='receiverAddress']" />
				<br />
				<xsl:value-of select="stmt:metaData/stmt:entry[@key='receiverCity']" />
				,
				<xsl:value-of select="stmt:metaData/stmt:entry[@key='receiverState']" />
				,
				<xsl:value-of select="stmt:metaData/stmt:entry[@key='receiverZip']" />
				<br />
				<p />
				<xsl:apply-templates select="stmt:section" />
				<p class="FOOTER">
					Statement generated by Calypso Technology
					<xsl:value-of select="concat(', ', substring(string(stmt:metaData/stmt:entry[@key='statementDate']), 0, 5), '.')" />
				</p>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="stmt:section">
		<xsl:variable name="section" select="." />
		<xsl:variable name="title" select="@id" />
		<div class="SECTION">
			<p class="SECTION_TITLE">
				<xsl:value-of select="stmtext:getTranslation('title', $title)" />
			</p>
			<div class="SECTION_ELEMENT">
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
			</div>
		</div>
		<br />
		<hr />
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
		<p class="SECTION_ELEMENT_TITLE">
			<xsl:value-of select="stmtext:getTranslation('title', $title)" />
		</p>
		
		<xsl:choose>
			<xsl:when test="count(child::stmt:row)=0">
				<p class="DETAIL">No Activity.</p>
			</xsl:when>
			<xsl:otherwise>
				<table>
					<xsl:apply-templates select="stmt:header">
						<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
						<xsl:with-param name="translationsVar" select="'summary'" />
					</xsl:apply-templates>
					<xsl:call-template name="appendCashFlowRows">
						<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
					</xsl:call-template>
					<!-- <xsl:apply-templates select="stmt:row" /> -->
					<xsl:call-template name="appendImRows">
						<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
					</xsl:call-template>
					<xsl:apply-templates select="$separateSettlementsSection">
						<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
					</xsl:apply-templates>
					<xsl:if test="boolean($separateSettlementsSection)">
						<tr class="SUB_TOTAL">
							<td class="SUB_TOTAL">Net Excess/Deficit Separate
								Settlement</td>
							<xsl:for-each select="$separateSettlementsSection[1]/stmt:header/stmt:headerName">
								<xsl:variable name="header" select="text()" />
								<xsl:if test="$header != 'Row Id' and $header != 'Total' and not(boolean($inactiveCurrencies[text() = $header]))">
									<td>
										<xsl:value-of
											select="stmtext:formatNumber(sum(../../../stmt:sectionElement[@id = 'separateSettlementTables']/stmt:row/stmt:cell[@id = $header]/stmt:value/text()), $header)" />
									</td>
								</xsl:if>
								<xsl:if test="$header = 'Total'">
									<td>
										<xsl:value-of
											select="stmtext:formatNumber(sum(../../../stmt:sectionElement[@id = 'separateSettlementTables']/stmt:row/stmt:cell[@id = 'total']/stmt:value/text()), $baseCurrency)" />
									</td>
								</xsl:if>
							</xsl:for-each>
						</tr>
						<xsl:call-template name="appendFillerRow">
							<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
						</xsl:call-template>
					</xsl:if>
				</table>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="appendFillerRow">
		<xsl:param name="inactiveCurrencies" />
		<tr>
			<xsl:for-each
				select="//stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:header/stmt:headerName">
				<xsl:variable name="currency" select="text()" />
				<xsl:if
					test="($inactiveCurrencies and not($inactiveCurrencies[contains(text(), $currency)])) or not($inactiveCurrencies)">
					<xsl:choose>
						<xsl:when test="contains($currency, 'Row Id')">
							<td>
								<xsl:attribute name="class">FILLER-LEFT</xsl:attribute>
							</td>
						</xsl:when>
						<xsl:when test="contains($currency, 'Total')">
							<td>
								<xsl:attribute name="class">FILLER-RIGHT</xsl:attribute>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:attribute name="class">FILLER</xsl:attribute>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:for-each>
		</tr>
	</xsl:template>

	<xsl:template
		match="stmt:sectionElement[@id = 'separateSettlementSummaryTable']/stmt:sectionElement[@id = 'separateSettlementTables']">
		<xsl:param name="inactiveCurrencies" />
		<xsl:variable name="ssFlows" select="stmt:metaData/stmt:entry[@key = 'INCLUDED_VM_FLOWS']" />
		<tr>
			<td>
				Separate Settlement -
				<xsl:value-of select="$ssFlows" />
			</td>
			<xsl:for-each select="stmt:header/stmt:headerName">
				<xsl:variable name="header" select="text()" />
				<xsl:if
					test="$header != 'Row Id' and $header != 'Total' and (($inactiveCurrencies and not($inactiveCurrencies[contains(text(), $header)])) or not($inactiveCurrencies))">
					<td>
						<xsl:value-of select="stmtext:formatNumber(../../stmt:row/stmt:cell[@id = $header]/stmt:value/text(), $header)" />
					</td>
				</xsl:if>
				<xsl:if test="$header = 'Total'">
					<td>
						<xsl:value-of select="stmtext:formatNumber(../../stmt:row/stmt:cell[@id = 'total']/stmt:value/text(), $baseCurrency)" />
					</td>
				</xsl:if>
			</xsl:for-each>
		</tr>
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
			<tr>
				<xsl:choose>
					<xsl:when test="contains($subtotalRows, ./@id)">
						<xsl:attribute name="class">SUB_TOTAL</xsl:attribute>
					</xsl:when>
					<xsl:when test="contains($totalRows, ./@id)">
						<xsl:attribute name="class">TOTAL</xsl:attribute>
					</xsl:when>
				</xsl:choose>
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
						<td>
							<xsl:choose>
								<xsl:when test="$rowId = 'Net VM Excess/Deficit (Incl. Pending)' and $cellId != 'rowId' and ($value &lt; 0)">
									<xsl:attribute name="class">DEFICIT_TOTAL_NUMBER</xsl:attribute>
								</xsl:when>
								<xsl:when test="contains($subtotalRows, $value)">
									<xsl:attribute name="class">SUB_TOTAL</xsl:attribute>
								</xsl:when>
								<xsl:when test="contains($totalRows, $value)">
									<xsl:attribute name="class">TOTAL</xsl:attribute>
								</xsl:when>
							</xsl:choose>
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
						</td>
					</xsl:if>
				</xsl:for-each>
			</tr>
			<xsl:if test="contains($fillerRows, $rowId)">
				<tr>
					<xsl:for-each select="./stmt:cell">
						<td>
							<xsl:choose>
								<xsl:when test="./@id = 'rowId'">
									<xsl:attribute name="class">FILLER-LEFT</xsl:attribute>
								</xsl:when>
								<xsl:when test="./@id = 'total'">
									<xsl:attribute name="class">FILLER-RIGHT</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="class">FILLER</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
						</td>
					</xsl:for-each>
				</tr>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="appendNetExcessDeficitRow">
		<xsl:param name="inactiveCurrencies" />
		<tr class="TOTAL">
			<xsl:for-each
				select="//stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:header/stmt:headerName">
				<xsl:variable name="currency" select="text()" />
				<xsl:if
					test="($inactiveCurrencies and not($inactiveCurrencies[contains(text(), $currency)])) or not($inactiveCurrencies)">
					<xsl:choose>
						<xsl:when test="contains($currency, 'Row Id')">
							<td class="TOTAL">Net Excess/Deficit</td>
						</xsl:when>
						<xsl:when test="contains($currency, 'Total')">
							<xsl:variable name="vmAmount"
								select="../../stmt:row[@id = 'Net VM Excess/Deficit (Incl. Pending)']/stmt:cell[@id = 'total']/stmt:value" />
							<xsl:variable name="imAmount"
								select="sum(../../../stmt:sectionElement[@id = 'initialMarginSummaryTables']/stmt:sectionElement[@id='initialMarginTable']/stmt:row[@id = 'Net IM Excess/Deficit (Incl. Pending)']/stmt:cell[@id = 'total']/stmt:value)" />
							<xsl:variable name="amount" select="$vmAmount + $imAmount" />
							<td>
								<xsl:if test="$amount &lt; 0">
									<xsl:attribute name="class">DEFICIT_TOTAL_NUMBER</xsl:attribute>
								</xsl:if>
								<xsl:value-of select="stmtext:formatNumber($amount, $baseCurrency)" />
							</td>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="vmAmount"
								select="../../stmt:row[@id = 'Net VM Excess/Deficit (Incl. Pending)']/stmt:cell[@id = $currency]/stmt:value" />
							<xsl:variable name="imAmount"
								select="sum(../../../stmt:sectionElement[@id = 'initialMarginSummaryTables']/stmt:sectionElement[@id='initialMarginTable']/stmt:row[@id = 'Net IM Excess/Deficit (Incl. Pending)']/stmt:cell[@id = $currency]/stmt:value)" />
							<xsl:variable name="amount" select="$vmAmount + $imAmount" />
							<td>
								<xsl:if test="$amount &lt; 0">
									<xsl:attribute name="class">DEFICIT_TOTAL_NUMBER</xsl:attribute>
								</xsl:if>
								<xsl:value-of select="stmtext:formatNumber($amount, $currency)" />
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:for-each>
		</tr>
		<xsl:call-template name="appendFillerRow">
			<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="stmt:sectionElement[@id = 'initialMarginSummaryTables']">
		<xsl:param name="imTables" select="./stmt:sectionElement[@id = 'initialMarginTable']" />
		<xsl:param name="inactiveCurrencies" />
		<xsl:for-each select="stmt:sectionElement[@id = 'initialMarginTable'][1]/stmt:row">
			<xsl:variable name="rowId" select="@id" />
			<xsl:if test="@id != 'Margin Requirement'">
				<xsl:variable name="rowNode" select="." />
				<tr>
					<xsl:if test="contains($subtotalRows, $rowNode/@id)">
						<xsl:attribute name="class">SUB_TOTAL</xsl:attribute>
					</xsl:if>
					<xsl:if test="contains($totalRows, $rowNode/@id)">
						<xsl:attribute name="class">TOTAL</xsl:attribute>
					</xsl:if>

					<xsl:for-each
						select="//stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:header/stmt:headerName">
						<xsl:variable name="currency" select="text()" />
						<xsl:if
							test="($inactiveCurrencies and not($inactiveCurrencies[contains(text(), $currency)])) or not($inactiveCurrencies)">
							<td>
								<xsl:choose>
									<xsl:when test="contains($currency, 'Row Id')">
										<xsl:choose>
											<xsl:when test="contains($subtotalRows, $rowNode/@id)">
												<xsl:attribute name="class">SUB_TOTAL</xsl:attribute>
											</xsl:when>
											<xsl:when test="contains($totalRows, $rowNode/@id)">
												<xsl:attribute name="class">TOTAL</xsl:attribute>
											</xsl:when>
										</xsl:choose>
										<xsl:value-of select="$rowNode/stmt:cell[@id = 'rowId']/stmt:value/text()" />
									</xsl:when>
									<xsl:when test="contains($currency, 'Total')">
										<xsl:variable name="amount"
											select="sum($imTables/stmt:row[@id = $rowNode/@id]/stmt:cell[@id = 'total']/stmt:value/text())" />
										<xsl:if test="$rowId = 'Net Excess/Deficit' and ($amount &lt; 0)">
											<xsl:attribute name="class">DEFICIT_TOTAL_NUMBER</xsl:attribute>
										</xsl:if>
										<xsl:choose>
											<xsl:when test="$amount = 0">
												<xsl:value-of select="stmtext:formatNumber(0.0, $baseCurrency)" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="stmtext:formatNumber($amount, $baseCurrency)" />
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:otherwise>
										<xsl:variable name="amount"
											select="sum($imTables/stmt:row[@id = $rowNode/@id]/stmt:cell[@id = $currency]/stmt:value/text())" />
										<xsl:if test="$rowId = 'Net Excess/Deficit' and ($amount &lt; 0)">
											<xsl:attribute name="class">DEFICIT_TOTAL_NUMBER</xsl:attribute>
										</xsl:if>
										<xsl:choose>
											<xsl:when test="$amount = 0">
												<xsl:value-of select="stmtext:formatNumber(0.0, $currency)" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="stmtext:formatNumber($amount, $currency)" />
											</xsl:otherwise>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>
							</td>
						</xsl:if>
					</xsl:for-each>
				</tr>

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
				<tr>
					<xsl:for-each
						select="//stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id = 'clearingCashFlowsSummaryTable']/stmt:header/stmt:headerName">
						<xsl:variable name="currency" select="text()" />
						<xsl:variable name="imTableNodes"
							select="$imTable/../stmt:sectionElement[stmt:metaData/stmt:entry[@key = 'ccp'] = $ccp and stmt:metaData/stmt:entry[@key = 'product'] = $service]" />
						<xsl:variable name="requirement"
							select="sum($imTableNodes/stmt:row[@id = 'Margin Requirement']/stmt:cell[@id = $currency]/stmt:value)" />
						<xsl:if
							test="($inactiveCurrencies and not($inactiveCurrencies[contains(text(), $currency)])) or not($inactiveCurrencies)">
							<td>
								<xsl:choose>
									<xsl:when test="contains($currency, 'Row Id')">
										<xsl:value-of select="concat($ccp, ' - ', $service, ' ', $marginRequirementRow/stmt:cell[@id = 'rowId']/stmt:value)" />
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
							</td>
						</xsl:if>
					</xsl:for-each>
				</tr>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="stmt:sectionElement[@id='accountActivity']">
		<xsl:variable name="title" select="@id" />
		<p class="SECTION_ELEMENT_TITLE">
			<xsl:value-of select="stmtext:getTranslation('title', $title)" />
		</p>
		<xsl:choose>
			<xsl:when test="count(child::stmt:row)=0">
				<p class="DETAIL">No Activity.</p>
			</xsl:when>
			<xsl:otherwise>
				<table>
					<xsl:apply-templates select="stmt:header" />
					<xsl:apply-templates select="stmt:row" />
				</table>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="stmt:sectionElement[@id='marginsOnDeposit']">
		<xsl:variable name="title" select="@id" />
		<p class="SECTION_ELEMENT_TITLE">
			<xsl:value-of select="stmtext:getTranslation('title', $title)" />
		</p>
		<xsl:choose>
			<xsl:when test="count(child::stmt:row)=0">
				<p class="DETAIL">No Activity.</p>
			</xsl:when>
			<xsl:otherwise>
				<table>
					<xsl:apply-templates select="stmt:header" />
					<xsl:apply-templates select="stmt:row" />
				</table>
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
			<p class="SECTION_ELEMENT_TITLE">
				<xsl:value-of select="stmtext:getTranslation('title', $title)" />
			</p>
			<table>
				<xsl:choose>
					<xsl:when test="count(child::stmt:row)=0">
						<p class="DETAIL">
							No trades for
							<xsl:value-of select="stmtext:getTranslation('title', $title)" />
						</p>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="stmt:header" />
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:otherwise>
						<xsl:apply-templates select="stmt:row" />
					</xsl:otherwise>
				</xsl:choose>
			</table>
		</xsl:if>
	</xsl:template>

	<xsl:template match="stmt:sectionElement[@id='marginCallActivity' or @id='pendingMarginCallActivity']">
		<br />
		<xsl:variable name="title" select="@id" />
		<p class="SECTION_ELEMENT_TITLE">
			<xsl:value-of select="stmtext:getTranslation('title', $title)" />
		</p>
		<xsl:choose>
			<xsl:when test="count(child::stmt:row)=0">
				<p class="DETAIL">No Activity.</p>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="sectionElement" select="." />
				<xsl:variable name="key" select="@id" />
				<xsl:variable name="ccps"
					select="$sectionElement/stmt:row/stmt:metaData/stmt:entry[@key='ccp'][generate-id() = generate-id(key($key, text())[1])]" />
				<xsl:for-each select="$ccps">
					<xsl:variable name="ccp" select="." />
					<xsl:if test="$ccp!='VARIATION MARGIN'">
						<div class="SUB_SECTION_ELEMENT">
							<p class="SECTION_ELEMENT_SUB_TITLE">
								<xsl:value-of select="$ccp" />
							</p>
							<table>
								<xsl:apply-templates select="$sectionElement/stmt:header" />
								<xsl:apply-templates select="$sectionElement/stmt:row[stmt:metaData/stmt:entry[@key='ccp'] = $ccp]" />
							</table>
							<xsl:if test="$ccp!='VARIATION MARGIN' and $ccp!='Unallocated'">
								<div class="INNER_DIV">
									<p class="SECTION_ELEMENT_SUB_TITLE">
										Total
										<xsl:value-of select="$ccp" />
										:
										<xsl:value-of select="$sectionElement/stmt:metaData/stmt:entry[@key=concat('Total ',$ccp)]/text()" />
									</p>
								</div>
							</xsl:if>
						</div>
					</xsl:if>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="stmt:header">
		<xsl:param name="inactiveCurrencies" />
		<xsl:param name="translationsVar" />
		<tr class="HEADER">
			<xsl:apply-templates select="stmt:headerName">
				<xsl:with-param name="translationsVar" select="$translationsVar" />
				<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
			</xsl:apply-templates>
		</tr>
	</xsl:template>

	<xsl:template match="stmt:headerName">
		<xsl:param name="translationsVar" />
		<xsl:param name="inactiveCurrencies" />
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
				<th></th>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="($inactiveCurrencies and not($inactiveCurrencies[contains(text(), $column)])) or not($inactiveCurrencies)">
					<th>
						<xsl:value-of select="$value" />
					</th>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="stmt:row">
		<xsl:param name="translationsVar" />
		<xsl:param name="inactiveCurrencies" />
		<xsl:if test="count(stmt:metaData/stmt:entry[@key='empty' and text()='true']) &lt; 1">
			<tr>
				<xsl:choose>
					<xsl:when test="contains($subtotalRows, ./@id)">
						<xsl:attribute name="class">SUB_TOTAL</xsl:attribute>
					</xsl:when>
					<xsl:when test="contains($totalRows, ./@id)">
						<xsl:attribute name="class">TOTAL</xsl:attribute>
					</xsl:when>
				</xsl:choose>
				<xsl:apply-templates select="stmt:cell">
					<xsl:with-param name="translationsVar" select="$translationsVar" />
					<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
				</xsl:apply-templates>
			</tr>
			<xsl:if test="contains($fillerRows, ./@id)">
				<tr>
					<xsl:apply-templates select="stmt:cell">
						<xsl:with-param name="translationsVar" select="$translationsVar" />
						<xsl:with-param name="inactiveCurrencies" select="$inactiveCurrencies" />
						<xsl:with-param name="fillerRow" select="true()" />
					</xsl:apply-templates>
				</tr>
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
		<td>
			<xsl:choose>
				<xsl:when test="$fillerRow = 'true'">
					<xsl:choose>
						<xsl:when test="$cellId = 'rowId'">
							<xsl:attribute name="class">FILLER-LEFT</xsl:attribute>
						</xsl:when>
						<xsl:when test="$cellId = 'total'">
							<xsl:attribute name="class">FILLER-RIGHT</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="class">FILLER</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="count(child::stmt:value) != 0">
						<xsl:choose>
							<xsl:when test="$rowId = 'Net VM Excess/Deficit (Incl. Pending)' and $cellId != 'rowId' and ($value &lt; 0)">
								<xsl:attribute name="class">DEFICIT_TOTAL_NUMBER</xsl:attribute>
							</xsl:when>
							<xsl:when test="contains($subtotalRows, $value)">
								<xsl:attribute name="class">SUB_TOTAL</xsl:attribute>
							</xsl:when>
							<xsl:when test="contains($totalRows, $value)">
								<xsl:attribute name="class">TOTAL</xsl:attribute>
							</xsl:when>
						</xsl:choose>
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
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</td>
	</xsl:template>

</xsl:stylesheet>