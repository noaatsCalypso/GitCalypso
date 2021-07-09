<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:stmt="urn:com:calypso:clearing:statement" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:stmtext="xalan://com.calypso.tk.bo.StatementDataTypeFormatter"
	extension-element-prefixes="stmtext" xmlns:fo="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="xs fo stmtext">

	<xsl:param name="versionParam" select="'1.0'" />
	<xsl:output method="xml" version="1.0" omit-xml-declaration="no" />

	<!-- "CSS" for xsl -->
	<xsl:attribute-set name="cell-style">
		<xsl:attribute name="border-style">solid</xsl:attribute>
		<xsl:attribute name="padding-before">3px</xsl:attribute>
		<xsl:attribute name="padding-after">3px</xsl:attribute>
		<xsl:attribute name="padding-end">1px</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="bold-cell-style">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="border-style">solid</xsl:attribute>
		<xsl:attribute name="padding-before">3px</xsl:attribute>
		<xsl:attribute name="padding-after">3px</xsl:attribute>
		<xsl:attribute name="padding-end">1px</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="table-style">
		<xsl:attribute name="table-layout">fixed</xsl:attribute>
		<xsl:attribute name="width">100%</xsl:attribute>
		<xsl:attribute name="border-collapse">collapse</xsl:attribute>
		<xsl:attribute name="border-style">solid</xsl:attribute>
		<xsl:attribute name="border-width">1px</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="block-style">
		<xsl:attribute name="font-size">7pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="title-style">
		<xsl:attribute name="font-size">12pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="space-before">5mm</xsl:attribute>
		<xsl:attribute name="space-after">3mm</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="sub-title-style">
		<xsl:attribute name="font-size">9pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="space-before">5mm</xsl:attribute>
		<xsl:attribute name="space-after">3mm</xsl:attribute>
	</xsl:attribute-set>

	<xsl:key name="marginsByCcy"
		match="stmt:sectionElement[@id='initialMarginSummaryTable']//stmt:row/stmt:metaData/stmt:entry[@key='ccy']" use="text()" />
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

	<!-- Columns to be skipped for each table. Specified by end user -->
	<xsl:variable name="accActivityColumnsToSkip">
		<columnsToSkip>
			<column>Balance</column>
		</columnsToSkip>
	</xsl:variable>
	<xsl:variable name="tradeColumnsToSkip">
		<columnsToSkip>
			<!-- <column>Mirror Trade Id</column> <column>Product Type</column> <column>Book</column> <column>CCP</column> <column>IS_CLIENT</column> 
				<column>Trade Date</column> <column>CCPTradeID</column> <column>CCPFirmReference</column> <column>NPV</column> <column>TradeStatus</column> 
				<column>CCPStatus</column> <column>CCPFCM</column> -->
		</columnsToSkip>
	</xsl:variable>

	<xsl:template match="/stmt:ClearingStatement">
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
			<fo:layout-master-set>
				<fo:simple-page-master master-name="LandscapeLetter" page-height="8.5in" page-width="11.0in"
					margin-top="1.0in" margin-bottom="0.5in" margin-left="0.3in" margin-right="0.3in">
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
					<fo:block font-size="16pt" font-weight="bold" text-align="center" padding-before='25px' padding-after='25px'>
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
		<xsl:apply-templates select="stmt:sectionElement[@id='separateSettlementSummaryTable']" />
		<xsl:apply-templates select="stmt:sectionElement[@id='vmtsLedgerSummaryTable']" />
		<xsl:apply-templates select="stmt:sectionElement[@id='initialMarginSummaryTables']" />
		<!-- Below line needed for backwards compatibility? -->
		<xsl:apply-templates select="stmt:sectionElement[@id='initialMarginSummaryTable']" />

		<!-- summaryOfPaymentsTable -->
		<xsl:choose>
			<xsl:when
				test="$title = 'financialSummary' and count(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='summaryOfPaymentsTable']) = 0">
				<fo:block xsl:use-attribute-sets="title-style" page-break-before="always">
					<xsl:value-of select="stmtext:getTranslation('title', 'summaryOfPaymentsTable')" />
				</fo:block>

				<fo:block xsl:use-attribute-sets="block-style">
					<fo:table xsl:use-attribute-sets="table-style">

						<!-- specifying column width -->
						<fo:table-column column-width="2.5in" />
						<xsl:for-each
							select="/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:header/stmt:headerName[text() != 'Row Id']">
							<xsl:variable name="Ccy" select="." />
							<xsl:if
								test="not(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:metaData/stmt:entry[@key='empty'] = $Ccy) or 
        	         count(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='separateSettlementSummaryTable']/stmt:sectionElement[@id='separateSettlementTables']/stmt:metaData/stmt:entry[@key='empty' and text()=$Ccy]) !=
        	         count(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='separateSettlementSummaryTable']/stmt:sectionElement[@id='separateSettlementTables']) or
                     boolean(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='initialMarginSummaryTable']/stmt:row[@id='Excess/Deficit Including Pending Collateral']/stmt:metaData/stmt:entry[@key='ccy'] = $Ccy) or
                     boolean(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='initialMarginSummaryTables']/stmt:metaData/stmt:entry[@key='imCcys'] = $Ccy)">
								<fo:table-column column-width="proportional-column-width(1)" />
							</xsl:if>
						</xsl:for-each>

						<fo:table-header border-style='solid' background-color='#f97777'>
							<xsl:attribute name="font-weight">bold</xsl:attribute>
							<fo:table-cell xsl:use-attribute-sets="cell-style">
								<fo:block text-align="end"></fo:block>
							</fo:table-cell>
							<xsl:for-each
								select="/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:header/stmt:headerName[text() != 'Row Id']">
								<xsl:variable name="Ccy" select="." />
								<xsl:if
									test="not(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:metaData/stmt:entry[@key='empty'] = $Ccy) or 
        	            count(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='separateSettlementSummaryTable']/stmt:sectionElement[@id='separateSettlementTables']/stmt:metaData/stmt:entry[@key='empty' and text()=$Ccy]) !=
        	            count(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='separateSettlementSummaryTable']/stmt:sectionElement[@id='separateSettlementTables']) or
                        boolean(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='initialMarginSummaryTable']/stmt:row[@id='Excess/Deficit Including Pending Collateral']/stmt:metaData/stmt:entry[@key='ccy'] = $Ccy) or
                        boolean(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='initialMarginSummaryTables']/stmt:metaData/stmt:entry[@key='imCcys'] = $Ccy)">
									<fo:table-cell xsl:use-attribute-sets="cell-style">
										<fo:block text-align="center">
											<xsl:choose>
												<xsl:when test="text() = 'Total'">
													<xsl:value-of select="concat(./text(), ' (', $baseCurrency, ')')" />
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="." />
												</xsl:otherwise>
											</xsl:choose>
										</fo:block>
									</fo:table-cell>
								</xsl:if>
							</xsl:for-each>
						</fo:table-header>

						<fo:table-body>

							<fo:table-row>
								<fo:table-cell xsl:use-attribute-sets="cell-style">
									<fo:block text-align="end">Clearing Cash Flows</fo:block>
								</fo:table-cell>
								<xsl:for-each
									select="/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:header/stmt:headerName[text() != 'Row Id']">
									<xsl:variable name="Ccy" select="." />
									<xsl:if
										test="not(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:metaData/stmt:entry[@key='empty'] = $Ccy) or 
        	              count(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='separateSettlementSummaryTable']/stmt:sectionElement[@id='separateSettlementTables']/stmt:metaData/stmt:entry[@key='empty' and text()=$Ccy]) !=
        	              count(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='separateSettlementSummaryTable']/stmt:sectionElement[@id='separateSettlementTables']) or
                          boolean(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='initialMarginSummaryTable']/stmt:row[@id='Excess/Deficit Including Pending Collateral']/stmt:metaData/stmt:entry[@key='ccy'] = $Ccy) or
                          boolean(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='initialMarginSummaryTables']/stmt:metaData/stmt:entry[@key='imCcys'] = $Ccy)">
										<xsl:choose>
											<xsl:when
												test="count(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:metaData/stmt:entry[text() = $Ccy]) = 0">
												<xsl:choose>
													<xsl:when test="$Ccy = 'Total'">
														<fo:table-cell xsl:use-attribute-sets="cell-style">
															<fo:block text-align="end">
																<xsl:value-of
																	select="stmtext:formatNumber(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:row[@id = 'Total Equity plus Pending Cash']/stmt:cell[@id = 'total']/stmt:value, $baseCurrency)" />
															</fo:block>
														</fo:table-cell>
													</xsl:when>
													<xsl:otherwise>
														<fo:table-cell xsl:use-attribute-sets="cell-style">
															<fo:block text-align="end">
																<xsl:value-of
																	select="stmtext:formatNumber(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:row[@id = 'Total Equity plus Pending Cash']/stmt:cell[@id = $Ccy]/stmt:value, $Ccy)" />
															</fo:block>
														</fo:table-cell>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:when>
											<xsl:otherwise>
												<fo:table-cell xsl:use-attribute-sets="cell-style">
													<fo:block text-align="end">0.0</fo:block>
												</fo:table-cell>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:if>
								</xsl:for-each>
							</fo:table-row>

							<fo:table-row>
								<fo:table-cell xsl:use-attribute-sets="cell-style">
									<fo:block text-align="end">Initial Margin</fo:block>
								</fo:table-cell>
								<xsl:for-each
									select="/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:header/stmt:headerName[text() != 'Row Id']">
									<xsl:variable name="Ccy" select="." />
									<xsl:if
										test="not(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:metaData/stmt:entry[@key='empty'] = $Ccy) or 
        	              count(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='separateSettlementSummaryTable']/stmt:sectionElement[@id='separateSettlementTables']/stmt:metaData/stmt:entry[@key='empty' and text()=$Ccy]) !=
        	              count(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='separateSettlementSummaryTable']/stmt:sectionElement[@id='separateSettlementTables']) or
                          boolean(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='initialMarginSummaryTable']/stmt:row[@id='Excess/Deficit Including Pending Collateral']/stmt:metaData/stmt:entry[@key='ccy'] = $Ccy) or
                          boolean(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='initialMarginSummaryTables']/stmt:metaData/stmt:entry[@key='imCcys'] = $Ccy)">
										<xsl:choose>
											<xsl:when test="$Ccy = 'Total'">
												<fo:table-cell xsl:use-attribute-sets="cell-style">
													<fo:block text-align="end">
														<xsl:value-of
															select="stmtext:formatNumber(sum(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='initialMarginSummaryTables']/stmt:sectionElement[@id='initialMarginTable']/stmt:row[@id='Excess/Deficit Including Pending Collateral']/stmt:cell[@id='total']/stmt:value), $baseCurrency)" />
													</fo:block>
												</fo:table-cell>
											</xsl:when>
											<xsl:otherwise>
												<xsl:choose>
													<xsl:when
														test="/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='initialMarginSummaryTables']/stmt:sectionElement[@id='initialMarginTable']/stmt:row[@id='Excess/Deficit Including Pending Collateral']/../stmt:metaData/stmt:entry[@key='ccy'] = $Ccy">
														<fo:table-cell xsl:use-attribute-sets="cell-style">
															<fo:block text-align="end">
																<xsl:value-of
																	select="stmtext:formatNumber(sum(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='initialMarginSummaryTables']/stmt:sectionElement[@id='initialMarginTable']/stmt:row[@id='Excess/Deficit Including Pending Collateral' and ../stmt:metaData/stmt:entry[@key='ccy'] = $Ccy]/stmt:cell[@id=$Ccy]/stmt:value), $Ccy)" />
															</fo:block>
														</fo:table-cell>
													</xsl:when>
													<xsl:otherwise>
														<fo:table-cell xsl:use-attribute-sets="cell-style">
															<fo:block text-align="end">0.0</fo:block>
														</fo:table-cell>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:if>
								</xsl:for-each>
							</fo:table-row>

							<fo:table-row>
								<fo:table-cell xsl:use-attribute-sets="bold-cell-style">
									<fo:block text-align="end">Net Excess/Deficit IM/VM</fo:block>
								</fo:table-cell>
								<xsl:for-each
									select="/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:header/stmt:headerName[text() != 'Row Id']">
									<xsl:variable name="Ccy" select="." />
									<xsl:if
										test="not(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:metaData/stmt:entry[@key='empty'] = $Ccy) or 
       	                  count(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='separateSettlementSummaryTable']/stmt:sectionElement[@id='separateSettlementTables']/stmt:metaData/stmt:entry[@key='empty' and text()=$Ccy]) !=
       	                  count(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='separateSettlementSummaryTable']/stmt:sectionElement[@id='separateSettlementTables']) or
                          boolean(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='initialMarginSummaryTable']/stmt:row[@id='Excess/Deficit Including Pending Collateral']/stmt:metaData/stmt:entry[@key='ccy'] = $Ccy) or
                          boolean(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='initialMarginSummaryTables']/stmt:metaData/stmt:entry[@key='imCcys'] = $Ccy)">
										<xsl:choose>
											<xsl:when test="$Ccy = 'Total'">
												<xsl:variable name="InitialMarginValue"
													select="sum(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='initialMarginSummaryTables']/stmt:sectionElement[@id='initialMarginTable']/stmt:row[@id='Excess/Deficit Including Pending Collateral']/stmt:cell[@id='total']/stmt:value)" />
												<xsl:variable name="ClearingCashFlowValue"
													select="/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:row[@id = 'Total Equity plus Pending Cash']/stmt:cell[@id = 'total']/stmt:value" />
												<fo:table-cell xsl:use-attribute-sets="bold-cell-style">
													<fo:block text-align="end">
														<xsl:choose>
															<xsl:when test="string(number($InitialMarginValue)) = 'NaN'">
																<xsl:value-of select="stmtext:formatNumber($ClearingCashFlowValue, $baseCurrency)" />
															</xsl:when>
															<xsl:when test="string(number($ClearingCashFlowValue)) = 'NaN'">
																<xsl:value-of select="stmtext:formatNumber($InitialMarginValue, $baseCurrency)" />
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="stmtext:formatNumber($ClearingCashFlowValue+$InitialMarginValue, $baseCurrency)" />
															</xsl:otherwise>
														</xsl:choose>
													</fo:block>
												</fo:table-cell>
											</xsl:when>
											<xsl:otherwise>
												<xsl:variable name="ClearingCashFlowValue"
													select="/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:row[@id = 'Total Equity plus Pending Cash']/stmt:cell[@id = $Ccy]/stmt:value" />
												<xsl:variable name="InitialMarginValue"
													select="sum(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='initialMarginSummaryTables']/stmt:sectionElement[@id='initialMarginTable']/stmt:row[@id='Excess/Deficit Including Pending Collateral' and ../stmt:metaData/stmt:entry[@key='ccy'] = $Ccy]/stmt:cell[@id=$Ccy]/stmt:value)" />
												<fo:table-cell xsl:use-attribute-sets="bold-cell-style">
													<fo:block text-align="end">
														<xsl:choose>
															<xsl:when test="string(number($InitialMarginValue)) = 'NaN'">
																<xsl:value-of select="stmtext:formatNumber($ClearingCashFlowValue, $Ccy)" />
															</xsl:when>
															<xsl:when test="string(number($ClearingCashFlowValue)) = 'NaN'">
																<xsl:value-of select="stmtext:formatNumber($InitialMarginValue, $Ccy)" />
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="stmtext:formatNumber($ClearingCashFlowValue+$InitialMarginValue, $Ccy)" />
															</xsl:otherwise>
														</xsl:choose>
													</fo:block>
												</fo:table-cell>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:if>
								</xsl:for-each>
							</fo:table-row>

							<xsl:for-each
								select="/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='separateSettlementSummaryTable' and @xsi:type='SectionElementListType']/stmt:sectionElement[@id='separateSettlementTables' and @xsi:type='TableType']/stmt:row[@id='Ending Balance plus Pending Separate Settlements']">
								<xsl:variable name="flowType" select="../stmt:metaData/stmt:entry[@key='INCLUDED_VM_FLOWS']" />
								<fo:table-row>
									<fo:table-cell xsl:use-attribute-sets="cell-style">
										<fo:block text-align="end">
											<xsl:call-template name="separateSettlementTitle">
												<xsl:with-param name="separateSettlement_ccp" select="../stmt:metaData/stmt:entry[@key='CCP']" />
												<xsl:with-param name="separateSettlement_product_type" select="../stmt:metaData/stmt:entry[@key='PRODUCT_TYPE']" />
												<xsl:with-param name="separateSettlement_included_vm_flows" select="$flowType" />
											</xsl:call-template>
										</fo:block>
									</fo:table-cell>
									<xsl:for-each select="../stmt:header/stmt:headerName[text() != 'Row Id']">
										<xsl:variable name="Ccy" select="." />
										<xsl:if
											test="not(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:metaData/stmt:entry[@key='empty'] = $Ccy) or 
	         	             count(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='separateSettlementSummaryTable']/stmt:sectionElement[@id='separateSettlementTables']/stmt:metaData/stmt:entry[@key='empty' and text()=$Ccy]) !=
	         	             count(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='separateSettlementSummaryTable']/stmt:sectionElement[@id='separateSettlementTables']) or
	                         boolean(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='initialMarginSummaryTable']/stmt:row[@id='Excess/Deficit Including Pending Collateral']/stmt:metaData/stmt:entry[@key='ccy'] = $Ccy) or
	                         boolean(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='initialMarginSummaryTables']/stmt:metaData/stmt:entry[@key='imCcys'] = $Ccy)">
											<xsl:choose>
												<xsl:when test="$Ccy='Total'">
													<fo:table-cell xsl:use-attribute-sets="cell-style">
														<fo:block text-align="end">
															<xsl:value-of
																select="stmtext:formatNumber(../../stmt:row[@id='Ending Balance plus Pending Separate Settlements']/stmt:cell[@id='total']/stmt:value, $baseCurrency)" />
														</fo:block>
													</fo:table-cell>
												</xsl:when>
												<xsl:otherwise>
													<fo:table-cell xsl:use-attribute-sets="cell-style">
														<fo:block text-align="end">
															<xsl:value-of
																select="stmtext:formatNumber(../../stmt:row[@id='Ending Balance plus Pending Separate Settlements']/stmt:cell[@id=$Ccy]/stmt:value, $Ccy)" />
														</fo:block>
													</fo:table-cell>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:if>
									</xsl:for-each>
								</fo:table-row>
							</xsl:for-each>

							<fo:table-row>
								<fo:table-cell xsl:use-attribute-sets="bold-cell-style">
									<fo:block text-align="end">Net Excess/Deficit Separate Settlement</fo:block>
								</fo:table-cell>
								<xsl:for-each
									select="/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:header/stmt:headerName[text() != 'Row Id']">
									<xsl:variable name="Ccy" select="." />
									<xsl:if
										test="not(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:metaData/stmt:entry[@key='empty'] = $Ccy) or 
         	              count(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='separateSettlementSummaryTable']/stmt:sectionElement[@id='separateSettlementTables']/stmt:metaData/stmt:entry[@key='empty' and text()=$Ccy]) !=
         	              count(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='separateSettlementSummaryTable']/stmt:sectionElement[@id='separateSettlementTables']) or
                          boolean(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='initialMarginSummaryTable']/stmt:row[@id='Excess/Deficit Including Pending Collateral']/stmt:metaData/stmt:entry[@key='ccy'] = $Ccy) or
                          boolean(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='initialMarginSummaryTables']/stmt:metaData/stmt:entry[@key='imCcys'] = $Ccy)">
										<xsl:choose>
											<xsl:when test="$Ccy='Total'">
												<fo:table-cell xsl:use-attribute-sets="bold-cell-style">
													<fo:block text-align="end">
														<xsl:value-of
															select="stmtext:formatNumber(sum(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='separateSettlementSummaryTable']/stmt:sectionElement[@id='separateSettlementTables']/stmt:row[@id='Ending Balance plus Pending Separate Settlements']/stmt:cell[@id='total']/stmt:value), $baseCurrency)" />
													</fo:block>
												</fo:table-cell>
											</xsl:when>
											<xsl:otherwise>
												<fo:table-cell xsl:use-attribute-sets="bold-cell-style">
													<fo:block text-align="end">
														<xsl:value-of
															select="stmtext:formatNumber(sum(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='separateSettlementSummaryTable']/stmt:sectionElement[@id='separateSettlementTables']/stmt:row[@id='Ending Balance plus Pending Separate Settlements']/stmt:cell[@id=$Ccy]/stmt:value), $Ccy)" />
													</fo:block>
												</fo:table-cell>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:if>
								</xsl:for-each>
							</fo:table-row>

							<fo:table-row>
								<fo:table-cell xsl:use-attribute-sets="bold-cell-style">
									<fo:block text-align="end">Net Excess/Deficit IM/VM/Cash Events</fo:block>
								</fo:table-cell>
								<xsl:for-each
									select="/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:header/stmt:headerName[text() != 'Row Id']">
									<xsl:variable name="Ccy" select="." />
									<xsl:if
										test="not(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:metaData/stmt:entry[@key='empty'] = $Ccy) or 
         	              count(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='separateSettlementSummaryTable']/stmt:sectionElement[@id='separateSettlementTables']/stmt:metaData/stmt:entry[@key='empty' and text()=$Ccy]) !=
         	              count(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='separateSettlementSummaryTable']/stmt:sectionElement[@id='separateSettlementTables']) or
                          boolean(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='initialMarginSummaryTable']/stmt:row[@id='Excess/Deficit Including Pending Collateral']/stmt:metaData/stmt:entry[@key='ccy'] = $Ccy) or
                          boolean(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='initialMarginSummaryTables']/stmt:metaData/stmt:entry[@key='imCcys'] = $Ccy)">
										<xsl:choose>
											<xsl:when test="$Ccy='Total'">
												<xsl:variable name="IMVMExcessDeficit"
													select="sum(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='initialMarginSummaryTables']/stmt:sectionElement[@id='initialMarginTable']/stmt:row[@id='Excess/Deficit Including Pending Collateral']/stmt:cell[@id='total']/stmt:value)" />
												<xsl:variable name="ClearingCashFlowValue"
													select="/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:row[@id = 'Total Equity plus Pending Cash']/stmt:cell[@id = 'total']/stmt:value" />
												<xsl:variable name="SeparateSettlementExcessDeficit"
													select="sum(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='separateSettlementSummaryTable']/stmt:sectionElement[@id='separateSettlementTables']/stmt:row[@id='Ending Balance plus Pending Separate Settlements']/stmt:cell[@id='total']/stmt:value)" />
												<fo:table-cell xsl:use-attribute-sets="bold-cell-style">
													<fo:block text-align="end">
														<xsl:choose>
															<xsl:when
																test="string(number($IMVMExcessDeficit)) ='NaN' and string(number($ClearingCashFlowValue)) ='NaN' and string(number($SeparateSettlementExcessDeficit)) ='NaN'">
																<xsl:value-of select="0.0" />
															</xsl:when>
															<xsl:when
																test="string(number($IMVMExcessDeficit)) ='NaN' and string(number($ClearingCashFlowValue)) ='NaN' and string(number($SeparateSettlementExcessDeficit)) !='NaN'">
																<xsl:value-of select="stmtext:formatNumber($SeparateSettlementExcessDeficit, $baseCurrency)" />
															</xsl:when>
															<xsl:when
																test="string(number($IMVMExcessDeficit)) ='NaN' and string(number($ClearingCashFlowValue)) !='NaN' and string(number($SeparateSettlementExcessDeficit)) ='NaN'">
																<xsl:value-of select="stmtext:formatNumber($ClearingCashFlowValue, $baseCurrency)" />
															</xsl:when>
															<xsl:when
																test="string(number($IMVMExcessDeficit)) ='NaN' and string(number($ClearingCashFlowValue)) !='NaN' and string(number($SeparateSettlementExcessDeficit)) !='NaN'">
																<xsl:value-of
																	select="stmtext:formatNumber($ClearingCashFlowValue+$SeparateSettlementExcessDeficit, $baseCurrency)" />
															</xsl:when>
															<xsl:when
																test="string(number($IMVMExcessDeficit)) !='NaN' and string(number($ClearingCashFlowValue)) ='NaN' and string(number($SeparateSettlementExcessDeficit)) ='NaN'">
																<xsl:value-of select="stmtext:formatNumber($IMVMExcessDeficit, $baseCurrency)" />
															</xsl:when>
															<xsl:when
																test="string(number($IMVMExcessDeficit)) !='NaN' and string(number($ClearingCashFlowValue)) ='NaN' and string(number($SeparateSettlementExcessDeficit)) !='NaN'">
																<xsl:value-of select="stmtext:formatNumber($IMVMExcessDeficit+$SeparateSettlementExcessDeficit, $baseCurrency)" />
															</xsl:when>
															<xsl:when
																test="string(number($IMVMExcessDeficit)) !='NaN' and string(number($ClearingCashFlowValue)) !='NaN' and string(number($SeparateSettlementExcessDeficit)) ='NaN'">
																<xsl:value-of select="stmtext:formatNumber($IMVMExcessDeficit+$ClearingCashFlowValue, $baseCurrency)" />
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of
																	select="stmtext:formatNumber($IMVMExcessDeficit+$ClearingCashFlowValue+$SeparateSettlementExcessDeficit, $baseCurrency)" />
															</xsl:otherwise>
														</xsl:choose>
													</fo:block>
												</fo:table-cell>
											</xsl:when>
											<xsl:otherwise>
												<xsl:variable name="IMVMExcessDeficit"
													select="sum(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='initialMarginSummaryTables']/stmt:sectionElement[@id='initialMarginTable']/stmt:row[@id='Excess/Deficit Including Pending Collateral' and ../stmt:metaData/stmt:entry[@key='ccy'] = $Ccy]/stmt:cell[@id=$Ccy]/stmt:value)" />
												<xsl:variable name="ClearingCashFlowValue"
													select="/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:row[@id = 'Total Equity plus Pending Cash']/stmt:cell[@id = $Ccy]/stmt:value" />
												<xsl:variable name="SeparateSettlementExcessDeficit"
													select="sum(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='separateSettlementSummaryTable']/stmt:sectionElement[@id='separateSettlementTables']/stmt:row[@id='Ending Balance plus Pending Separate Settlements']/stmt:cell[@id= $Ccy]/stmt:value)" />
												<fo:table-cell xsl:use-attribute-sets="bold-cell-style">
													<fo:block text-align="end">
														<xsl:choose>
															<xsl:when
																test="string(number($IMVMExcessDeficit)) ='NaN' and string(number($ClearingCashFlowValue)) ='NaN' and string(number($SeparateSettlementExcessDeficit)) ='NaN'">
																<xsl:value-of select="0.0" />
															</xsl:when>
															<xsl:when
																test="string(number($IMVMExcessDeficit)) ='NaN' and string(number($ClearingCashFlowValue)) ='NaN' and string(number($SeparateSettlementExcessDeficit)) !='NaN'">
																<xsl:value-of select="stmtext:formatNumber($SeparateSettlementExcessDeficit, $baseCurrency)" />
															</xsl:when>
															<xsl:when
																test="string(number($IMVMExcessDeficit)) ='NaN' and string(number($ClearingCashFlowValue)) !='NaN' and string(number($SeparateSettlementExcessDeficit)) ='NaN'">
																<xsl:value-of select="stmtext:formatNumber($ClearingCashFlowValue, $baseCurrency)" />
															</xsl:when>
															<xsl:when
																test="string(number($IMVMExcessDeficit)) ='NaN' and string(number($ClearingCashFlowValue)) !='NaN' and string(number($SeparateSettlementExcessDeficit)) !='NaN'">
																<xsl:value-of
																	select="stmtext:formatNumber($ClearingCashFlowValue+$SeparateSettlementExcessDeficit, $baseCurrency)" />
															</xsl:when>
															<xsl:when
																test="string(number($IMVMExcessDeficit)) !='NaN' and string(number($ClearingCashFlowValue)) ='NaN' and string(number($SeparateSettlementExcessDeficit)) ='NaN'">
																<xsl:value-of select="stmtext:formatNumber($IMVMExcessDeficit, $baseCurrency)" />
															</xsl:when>
															<xsl:when
																test="string(number($IMVMExcessDeficit)) !='NaN' and string(number($ClearingCashFlowValue)) ='NaN' and string(number($SeparateSettlementExcessDeficit)) !='NaN'">
																<xsl:value-of select="stmtext:formatNumber($IMVMExcessDeficit+$SeparateSettlementExcessDeficit, $baseCurrency)" />
															</xsl:when>
															<xsl:when
																test="string(number($IMVMExcessDeficit)) !='NaN' and string(number($ClearingCashFlowValue)) !='NaN' and string(number($SeparateSettlementExcessDeficit)) ='NaN'">
																<xsl:value-of select="stmtext:formatNumber($IMVMExcessDeficit+$ClearingCashFlowValue, $baseCurrency)" />
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of
																	select="stmtext:formatNumber($IMVMExcessDeficit+$ClearingCashFlowValue+$SeparateSettlementExcessDeficit, $baseCurrency)" />
															</xsl:otherwise>
														</xsl:choose>
													</fo:block>
												</fo:table-cell>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:if>
								</xsl:for-each>
							</fo:table-row>

							<fo:table-row>
								<fo:table-cell xsl:use-attribute-sets="cell-style">
									<fo:block text-align="end">FX Rates</fo:block>
								</fo:table-cell>
								<xsl:for-each
									select="/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:header/stmt:headerName[text() != 'Row Id']">
									<xsl:variable name="Ccy" select="." />
									<xsl:if
										test="not(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:metaData/stmt:entry[@key='empty'] = $Ccy) or 
         	              count(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='separateSettlementSummaryTable']/stmt:sectionElement[@id='separateSettlementTables']/stmt:metaData/stmt:entry[@key='empty' and text()=$Ccy]) !=
         	              count(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='separateSettlementSummaryTable']/stmt:sectionElement[@id='separateSettlementTables']) or
                          boolean(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='initialMarginSummaryTable']/stmt:row[@id='Excess/Deficit Including Pending Collateral']/stmt:metaData/stmt:entry[@key='ccy'] = $Ccy)">
										<xsl:choose>
											<xsl:when
												test="count(/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:metaData/stmt:entry[text() = $Ccy]) = 0">
												<xsl:choose>
													<xsl:when test="$Ccy = 'Total'">
														<fo:table-cell xsl:use-attribute-sets="cell-style">
															<fo:block text-align="end">
																<xsl:value-of
																	select="/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:row[@id = 'FX Rates']/stmt:cell[@id = 'total']/stmt:value" />
															</fo:block>
														</fo:table-cell>
													</xsl:when>
													<xsl:otherwise>
														<fo:table-cell xsl:use-attribute-sets="cell-style">
															<fo:block text-align="end">
																<xsl:value-of
																	select="/stmt:ClearingStatement/stmt:section[@id='financialSummary']/stmt:sectionElement[@id='clearingCashFlowsSummaryTable']/stmt:row[@id = 'FX Rates']/stmt:cell[@id = $Ccy]/stmt:value" />
															</fo:block>
														</fo:table-cell>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:when>
											<xsl:otherwise>
												<fo:table-cell xsl:use-attribute-sets="cell-style">
													<fo:block text-align="end">0.0</fo:block>
												</fo:table-cell>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:if>
								</xsl:for-each>
							</fo:table-row>

						</fo:table-body>

					</fo:table>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="stmt:sectionElement[@id='summaryOfPaymentsTable']" />
			</xsl:otherwise>
		</xsl:choose>

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
		<xsl:apply-templates select="stmt:sectionElement[@id='pendingAccountActivity']" />
		<xsl:apply-templates select="stmt:sectionElement[@id='marginCallActivity']" />
		<xsl:apply-templates select="stmt:sectionElement[@id='pendingMarginCallActivity']" />
		<xsl:apply-templates select="stmt:sectionElement[@id='marginsOnDeposit']" />
	</xsl:template>

	<xsl:template match="stmt:sectionElement[@id='separateSettlementSummaryTable']">
		<xsl:choose>
			<xsl:when test="count(child::stmt:sectionElement[@id='separateSettlementTables'])=0">
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="title" select="@id" />
				<fo:block xsl:use-attribute-sets="title-style" page-break-before="always">
					<xsl:value-of select="stmtext:getTranslation('title', $title)" />
				</fo:block>
				<xsl:apply-templates select="stmt:sectionElement[@id='separateSettlementTables']" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="separateSettlementTitle">
		<xsl:param name="separateSettlement_ccp" />
		<xsl:param name="separateSettlement_product_type" />
		<xsl:param name="separateSettlement_included_vm_flows" />
		Separate Settlement
		<xsl:if test="boolean($separateSettlement_ccp) and $separateSettlement_ccp != ''">
			-
			<xsl:value-of select="$separateSettlement_ccp" />
		</xsl:if>
		<xsl:if test="boolean($separateSettlement_product_type) and $separateSettlement_product_type != ''">
			-
			<xsl:value-of select="$separateSettlement_product_type" />
		</xsl:if>
		-
		<xsl:value-of select="$separateSettlement_included_vm_flows" />
	</xsl:template>

	<xsl:template match="stmt:sectionElement[@id='separateSettlementTables']">
		<xsl:variable name="metaDataNode" select="stmt:metaData" />
		<xsl:variable name="separateSettlement_ccp" select="stmt:metaData/stmt:entry[@key='CCP']" />
		<xsl:variable name="separateSettlement_product_type" select="stmt:metaData/stmt:entry[@key='PRODUCT_TYPE']" />
		<xsl:variable name="separateSettlement_included_vm_flows" select="stmt:metaData/stmt:entry[@key='INCLUDED_VM_FLOWS']" />
		<fo:block xsl:use-attribute-sets="sub-title-style">
			<xsl:call-template name="separateSettlementTitle">
				<xsl:with-param name="separateSettlement_ccp" select="stmt:metaData/stmt:entry[@key='CCP']" />
				<xsl:with-param name="separateSettlement_product_type" select="stmt:metaData/stmt:entry[@key='PRODUCT_TYPE']" />
				<xsl:with-param name="separateSettlement_included_vm_flows" select="stmt:metaData/stmt:entry[@key='INCLUDED_VM_FLOWS']" />
			</xsl:call-template>
		</fo:block>
		<xsl:choose>
			<xsl:when test="count(child::stmt:row)=0">
				<fo:block xsl:use-attribute-sets="block-style">
					No Activity.
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="block-style">
					<fo:table xsl:use-attribute-sets="table-style">
						<xsl:apply-templates select="stmt:header">
							<xsl:with-param name="translationsVar" select="summary" />
						</xsl:apply-templates>
						<fo:table-body>
							<xsl:apply-templates select="stmt:row" />
						</fo:table-body>
					</fo:table>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="stmt:sectionElement[@id='initialMarginSummaryTables']">
		<xsl:choose>
			<xsl:when test="count(child::stmt:sectionElement[@id='initialMarginTable'])=0">
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="title" select="@id" />
				<fo:block xsl:use-attribute-sets="title-style" page-break-before="always">
					<xsl:value-of select="stmtext:getTranslation('title', $title)" />
				</fo:block>
				<xsl:choose>
					<xsl:when test="count(child::stmt:sectionElement)=0">
						<fo:block xsl:use-attribute-sets="block-style">
							No Activity.
						</fo:block>
					</xsl:when>
					<xsl:otherwise>
						<fo:block xsl:use-attribute-sets="block-style">
							<xsl:for-each select="stmt:metaData/stmt:entry[@key='imCcys']">
								<xsl:variable name="imCurrency" select="current()" />
								<fo:block xsl:use-attribute-sets="sub-title-style">
									<xsl:value-of select="$imCurrency" />
								</fo:block>
								<fo:table xsl:use-attribute-sets="table-style">
									<fo:table-header border-style='solid' background-color='#f97777'>
										<fo:table-row>
											<xsl:attribute name="font-weight">bold</xsl:attribute>
											<fo:table-cell xsl:use-attribute-sets="cell-style">
												<fo:block />
											</fo:table-cell>
											<xsl:for-each
												select="../../stmt:sectionElement/stmt:metaData[generate-id() = generate-id(key('clearingServicesKey', concat(stmt:entry[@key = 'ccp'], '|', stmt:entry[@key = 'product']))[1])]">
												<xsl:variable name="ccp" select="stmt:entry[@key = 'ccp']" />
												<xsl:variable name="service" select="stmt:entry[@key = 'product']" />
												<xsl:if
													test="sum(../../stmt:sectionElement[@id = 'initialMarginTable' and (stmt:metaData/stmt:entry[@key = 'ccy'] = $imCurrency) and (stmt:metaData/stmt:entry[@key = 'ccp'] = $ccp) and (stmt:metaData/stmt:entry[@key = 'product'] = $service and (stmt:metaData/stmt:entry[@key = 'ccy'] = $imCurrency)) and (stmt:metaData/stmt:entry[@key = 'ccy'] = $imCurrency)]/stmt:row/stmt:cell[@id != 'rowId' and @id != 'total']/stmt:value) != 0.0">
													<fo:table-cell xsl:use-attribute-sets="cell-style">
														<fo:block text-align="center">
															<xsl:value-of select="concat($ccp, ' ', $service)" />
														</fo:block>
													</fo:table-cell>
												</xsl:if>
											</xsl:for-each>
											<fo:table-cell xsl:use-attribute-sets="cell-style">
												<fo:block text-align="center">
													Total (
													<xsl:value-of select="$imCurrency" />
													)
												</fo:block>
											</fo:table-cell>
										</fo:table-row>
									</fo:table-header>
									<fo:table-body>
										<xsl:for-each select="../../stmt:sectionElement[stmt:metaData/stmt:entry[@key='ccy' = $imCurrency]][1]/stmt:row/@id">
											<xsl:variable name="vConcept" select="current()" />
											<xsl:variable name="vIsTotalRow"
												select="$vConcept='Total Collateral Plus Pending Collateral' 
                                                                                             or $vConcept='Excess/Deficit' 
                                                                                             or $vConcept='Excess/Deficit Including Pending Collateral'
                                                                                             or $vConcept='Total Collateral' 
                                                                                             or $vConcept='Total Pending Collateral' 
                                                                                             or $vConcept='Net Excess/Deficit'" />

											<fo:table-row>
												<!-- Concept column -->
												<fo:table-cell xsl:use-attribute-sets="cell-style">
													<xsl:if test="$vIsTotalRow">
														<xsl:attribute name="font-weight">bold</xsl:attribute>
													</xsl:if>
													<fo:block text-align="end">
														<xsl:value-of select="$vConcept" />
													</fo:block>
												</fo:table-cell>

												<!-- Broken down services -->
												<xsl:for-each
													select="../../../stmt:sectionElement/stmt:metaData[generate-id() = generate-id(key('clearingServicesKey', concat(stmt:entry[@key = 'ccp'], '|', stmt:entry[@key = 'product']))[1])]">
													<xsl:variable name="ccp" select="stmt:entry[@key = 'ccp']" />
													<xsl:variable name="service" select="stmt:entry[@key = 'product']" />
													<xsl:variable name="rowSum"
														select="sum(../../stmt:sectionElement[stmt:metaData/stmt:entry[@key = 'ccp'] = $ccp and stmt:metaData/stmt:entry[@key = 'product'] = $service]/stmt:row[@id = $vConcept]/stmt:cell[@id = $imCurrency])" />
													<xsl:if
														test="sum(../../stmt:sectionElement[@id = 'initialMarginTable' and (stmt:metaData/stmt:entry[@key = 'ccy'] = $imCurrency) and (stmt:metaData/stmt:entry[@key = 'ccp'] = $ccp) and (stmt:metaData/stmt:entry[@key = 'product'] = $service and (stmt:metaData/stmt:entry[@key = 'ccy'] = $imCurrency)) and (stmt:metaData/stmt:entry[@key = 'ccy'] = $imCurrency)]/stmt:row/stmt:cell[@id != 'rowId' and @id != 'total']/stmt:value) != 0.0">
														<fo:table-cell xsl:use-attribute-sets="cell-style">
															<xsl:if test="boolean($vIsTotalRow)">
																<xsl:attribute name="font-weight">bold</xsl:attribute>
															</xsl:if>
															<fo:block text-align="end">
																<xsl:value-of select="stmtext:formatNumber($rowSum, $imCurrency)" />
															</fo:block>
														</fo:table-cell>
													</xsl:if>
												</xsl:for-each>
												<!-- Total column -->
												<fo:table-cell xsl:use-attribute-sets="cell-style">
													<xsl:if test="boolean($vIsTotalRow)">
														<xsl:attribute name="font-weight">bold</xsl:attribute>
													</xsl:if>
													<fo:block text-align="end">
														<xsl:value-of
															select="stmtext:formatNumber(sum(../../../stmt:sectionElement[stmt:metaData/stmt:entry[@key='ccy' = $imCurrency]]/stmt:row[@id=$vConcept]/stmt:cell[@id = $imCurrency]/stmt:value), $imCurrency)" />
													</fo:block>
												</fo:table-cell>
											</fo:table-row>
										</xsl:for-each>
									</fo:table-body>
								</fo:table>
							</xsl:for-each>
						</fo:block>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="stmt:sectionElement[@id='clearingCashFlowsSummaryTable' or @id='vmtsLedgerSummaryTable']">
		<xsl:variable name="title" select="@id" />
		<fo:block xsl:use-attribute-sets="title-style">
			<xsl:value-of select="stmtext:getTranslation('title', $title)" />
		</fo:block>
		<xsl:choose>
			<xsl:when test="count(child::stmt:row)=0">
				<fo:block xsl:use-attribute-sets="block-style">
					No Activity.
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="block-style">
					<fo:table xsl:use-attribute-sets="table-style">
						<xsl:apply-templates select="stmt:header">
							<xsl:with-param name="translationsVar" select="'summary'" />
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

	<xsl:template match="stmt:sectionElement[@id='accountActivity' or @id='pendingAccountActivity']">
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
							<xsl:with-param name="columnsToSkipVar" select="'accActivityColumnsToSkip'" />
							<xsl:with-param name="tablenameVar" select="@id" />
						</xsl:apply-templates>
						<fo:table-body>
							<xsl:apply-templates select="stmt:row">
								<xsl:with-param name="columnsToSkipVar" select="'accActivityColumnsToSkip'" />
								<xsl:with-param name="translationsVar" select="'accountActivity'" />
							</xsl:apply-templates>
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
								<xsl:with-param name="columnsToSkipVar" select="'tradeColumnsToSkip'" />
								<!-- NOTE: Use 'trades' to translate trades related columns -->
								<xsl:with-param name="translationsVar" select="'trades'" />
								<xsl:with-param name="tablenameVar" select="@id" />
							</xsl:apply-templates>
							<fo:table-body>
								<xsl:apply-templates select="stmt:row">
									<xsl:with-param name="columnsToSkipVar" select="'tradeColumnsToSkip'" />
								</xsl:apply-templates>
							</fo:table-body>
						</fo:table>
					</fo:block>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<xsl:template match="stmt:sectionElement[@id='initialMarginSummaryTable']">
		<xsl:variable name="title" select="@id" />
		<fo:block xsl:use-attribute-sets="title-style" page-break-before="always">
			<xsl:value-of select="stmtext:getTranslation('title', $title)" />
		</fo:block>

		<xsl:variable name="sectionElement" select="." />
		<xsl:variable name="key" select="stmtext:getTranslation('title', $title)" />
		<xsl:variable name="currencies"
			select="stmt:row/stmt:metaData/stmt:entry[@key='ccy'][generate-id() = generate-id(key('marginsByCcy', text())[1])]" />

		<fo:block xsl:use-attribute-sets="block-style">
			<xsl:for-each select="$currencies">
				<xsl:variable name="ccy" select="." />
				<xsl:value-of select="$ccy" />
				<fo:table xsl:use-attribute-sets="table-style">

					<xsl:apply-templates select="$sectionElement/stmt:header">
						<xsl:with-param name="translationsVar" select="'summary'" />
					</xsl:apply-templates>

					<fo:table-body>
						<xsl:apply-templates select="$sectionElement/stmt:row[stmt:metaData/stmt:entry[@key='ccy'] = $ccy]" />
					</fo:table-body>
				</fo:table>
			</xsl:for-each>
		</fo:block>
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

	<xsl:template match="stmt:sectionElement[@id='summaryOfPaymentsTable']">
		<xsl:variable name="title" select="@id" />
		<fo:block xsl:use-attribute-sets="title-style" page-break-before="always">
			<xsl:value-of select="stmtext:getTranslation('title', $title)" />
		</fo:block>

		<fo:block xsl:use-attribute-sets="block-style">
			<fo:table xsl:use-attribute-sets="table-style">
				<xsl:apply-templates select="stmt:header">
					<xsl:with-param name="translationsVar" select="'summary'" />
				</xsl:apply-templates>
				<fo:table-body>
					<xsl:apply-templates select="stmt:row" />
				</fo:table-body>
			</fo:table>
		</fo:block>
	</xsl:template>

	<xsl:template match="stmt:header">
		<xsl:param name="columnsToSkipVar" />
		<xsl:param name="translationsVar" />
		<xsl:param name="tablenameVar" />

		<!-- Adding table columns -->
		<xsl:apply-templates select="stmt:headerName" mode="fo-table-column">
			<xsl:with-param name="translationsVar" select="$translationsVar" />
			<xsl:with-param name="columnsToSkipVar" select="$columnsToSkipVar" />
			<xsl:with-param name="tablenameVar" select="$tablenameVar" />
		</xsl:apply-templates>

		<fo:table-header border-style='solid' background-color='#f97777'>
			<fo:table-row>
				<xsl:attribute name="font-weight">bold</xsl:attribute>
				<xsl:apply-templates select="stmt:headerName">
					<xsl:with-param name="translationsVar" select="$translationsVar" />
					<xsl:with-param name="columnsToSkipVar" select="$columnsToSkipVar" />
				</xsl:apply-templates>
			</fo:table-row>
		</fo:table-header>
	</xsl:template>

	<!-- A template to specify different width for columns for a particular table (via input param: tablenameVar) -->
	<xsl:template match="stmt:headerName" mode="fo-table-column">
		<xsl:param name="translationsVar" />
		<xsl:param name="columnsToSkipVar" />
		<xsl:param name="tablenameVar" />
		<xsl:variable name="emptyColumns" select="../../stmt:metaData/stmt:entry[@key='empty']" />
		<xsl:variable name="column" select="." />
		<xsl:variable name="translation" select="stmtext:getTranslation($translationsVar, $column)" />
		<xsl:variable name="skipColumn" select="//xsl:variable[@name=$columnsToSkipVar]/columnsToSkip/column[text()=$column]" />
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
				<fo:table-column column-width="1.3in" />
			</xsl:when>
			<xsl:when test="text()='Total'">
				<fo:table-column column-width=".8in" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="not(boolean($emptyColumns[text()=$column])) and not($skipColumn)">
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

	<!-- A template does NOT specify column width -->
	<xsl:template match="stmt:headerName">
		<xsl:param name="translationsVar" />
		<xsl:param name="columnsToSkipVar" />
		<xsl:variable name="emptyColumns" select="../../stmt:metaData/stmt:entry[@key='empty']" />
		<xsl:variable name="column" select="." />
		<xsl:variable name="translation" select="stmtext:getTranslation($translationsVar, $column)" />
		<xsl:variable name="skipColumn" select="//xsl:variable[@name=$columnsToSkipVar]/columnsToSkip/column[text()=$column]" />
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
				<xsl:if test="not(boolean($emptyColumns[text()=$column])) and not($skipColumn)">
					<fo:table-cell xsl:use-attribute-sets="cell-style">
						<fo:block text-align="center">
							<xsl:value-of select="$value" />
						</fo:block>
					</fo:table-cell>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="stmt:row">
		<xsl:param name="translationsVar" />
		<xsl:param name="columnsToSkipVar" />
		<xsl:if test="count(stmt:metaData/stmt:entry[@key='empty' and text()='true']) &lt; 1">
			<xsl:choose>
				<xsl:when
					test="@id='Ending Cash Balance' 
                           or @id='Total NPV' 
                           or @id='Beginning Cash Balance' 
                           or @id='Total Pending Cash'
                           or @id='Total Collateral' 
                           or @id='Total Pending Collateral' 
                           or @id='Total Collateral Plus Pending Cash' 
                           or @id='Excess/Deficit' 
                           or @id='Beginning Separate Settlements Balance'
                           or @id='Ending Separate Settlements Balance'
                           or @id='Total Collateral'
                           or @id='Total Pending Collateral'
                           or @id='Excess/Deficit Including Pending Collateral'
                           or @id='Net Excess/Deficit IM/VM'
                           or @id='Net Excess/Deficit Separate Settlement'
                           or @id='Net Excess/Deficit IM/VM/Cash Events'
                           or stmt:cell[@id='Type']/stmt:value='Closing Balance'">
					<fo:table-row font-weight="bold" height="0.15in">
						<xsl:apply-templates select="stmt:cell">
							<xsl:with-param name="translationsVar" select="$translationsVar" />
							<xsl:with-param name="columnsToSkipVar" select="$columnsToSkipVar" />
						</xsl:apply-templates>
					</fo:table-row>
				</xsl:when>
				<xsl:when
					test="@id='Total Equity plus Pending Cash' 
                           or @id='Total Equity' 
                           or @id='Excess/Deficit Including Pending Collateral' 
                           or @id='Ending Balance plus Pending Separate Settlements'
                           or @id='Net Excess/Deficit'">
					<fo:table-row font-weight="bold" height="0.15in">
						<xsl:apply-templates select="stmt:cell">
							<xsl:with-param name="translationsVar" select="$translationsVar" />
							<xsl:with-param name="columnsToSkipVar" select="$columnsToSkipVar" />
						</xsl:apply-templates>
					</fo:table-row>
				</xsl:when>
				<xsl:otherwise>
					<fo:table-row height="0.15in">
						<xsl:apply-templates select="stmt:cell">
							<xsl:with-param name="translationsVar" select="$translationsVar" />
							<xsl:with-param name="columnsToSkipVar" select="$columnsToSkipVar" />
						</xsl:apply-templates>
					</fo:table-row>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<xsl:template match="stmt:cell">
		<xsl:param name="translationsVar" />
		<xsl:param name="columnsToSkipVar" />
		<xsl:variable name="emptyColumns" select="../../stmt:metaData/stmt:entry[@key='empty']" />
		<xsl:variable name="sectionId" select="../../../@id" />
		<xsl:variable name="tableId" select="../../@id" />
		<xsl:variable name="rowId" select="../@id" />
		<xsl:variable name="cellId" select="@id" />
		<xsl:variable name="skipColumn" select="//xsl:variable[@name=$columnsToSkipVar]/columnsToSkip/column[text()=$cellId]" />
		<xsl:if test="not(boolean($emptyColumns[text()=$cellId])) and not($skipColumn)">
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
						test="($sectionId = 'financialSummary' or $sectionId='separateSettlementSummaryTable') and $tableId != 'initialMarginSummaryTable' and string(number($value)) != 'NaN' and $cellId = 'total' and $rowId != 'FX Rates'">
						<xsl:value-of select="stmtext:formatNumber($value, $baseCurrency)" />
					</xsl:when>
					<xsl:when
						test="($sectionId = 'financialSummary' or $sectionId='separateSettlementSummaryTable') and $tableId != 'initialMarginSummaryTable' and string(number($value)) != 'NaN' and $rowId != 'FX Rates'">
						<xsl:value-of select="stmtext:formatNumber($value, $cellId)" />
					</xsl:when>
					<xsl:when
						test="($sectionId = 'financialSummary' or $sectionId='separateSettlementSummaryTable') and $tableId = 'initialMarginSummaryTable' and string(number($value)) != 'NaN' and $rowId != 'FX Rates'">
						<xsl:value-of select="stmtext:formatNumber($value, ../stmt:metaData/stmt:entry[@key='ccy'])" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$value" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<fo:table-cell xsl:use-attribute-sets="cell-style">
				<fo:block text-align="end">
					<xsl:if test="count(child::stmt:value) != 0">
						<xsl:choose>
							<xsl:when
								test="$value='Total Equity' 
                              or $value='Total Equity plus Pending Cash'
                              or $value='Total Collateral Plus Pending Collateral' 
                              or $value='Excess/Deficit' 
                              or $value='Excess/Deficit Including Pending Collateral'
                              or $value='Ending Balance plus Pending Separate Settlements'">
								<fo:inline font-weight="bold">
									<xsl:value-of select="$cellValue" />
								</fo:inline>
							</xsl:when>
							<xsl:when
								test="$value='Beginning Cash Balance' 
                              or $value='Total NPV' 
                              or $value='Ending Cash Balance' 
                              or $value='Total Pending Cash' 
                              or $value='Total Collateral' 
                              or $value='Total Pending Collateral' 
                              or $value='Net Excess/Deficit'
                              or $value='Beginning Separate Settlements Balance'
                              or $value='Ending Separate Settlements Balance'">
								<fo:inline font-weight="bold">
									<xsl:value-of select="$cellValue" />
								</fo:inline>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$cellValue" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</fo:block>
			</fo:table-cell>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>