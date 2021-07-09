<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:stmt="urn:com:calypso:clearing:statement:etd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:stmtext="xalan://com.calypso.tk.bo.StatementDataTypeFormatter"
	extension-element-prefixes="stmtext" xmlns:fo="http://www.w3.org/1999/XSL/Format"
	exclude-result-prefixes="xs fo stmtext">

	<!-- CASH POSTINGS SECTION -->

	<xsl:variable name="isDailyFrequency"
		select="boolean(//stmt:section[@id = 'metadata']/@statementFrequency = 'DAILY')" />

	<xsl:template match="stmt:section[@id='cashPostings']">
		<xsl:choose>
			<xsl:when test="$isDailyFrequency">
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="section-block-style">

					<xsl:call-template name="sectionTitle">
						<xsl:with-param name="title" select="'Cash Postings'" />
					</xsl:call-template>

					<xsl:if test="boolean(stmt:row)">

						<fo:table xsl:use-attribute-sets="debug-table-format-style content-table-style">

							<xsl:if test="$statementType = 'PARENT'">
								<!-- Account column -->
								<fo:table-column />
							</xsl:if>
							<!-- Trade Date column -->
							<fo:table-column />
							<!-- Origin column -->
							<fo:table-column />
							<!-- Currency column -->
							<fo:table-column column-width="5.5%" />
							<!-- Type column -->
							<fo:table-column column-width="40%" />
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
												<fo:block>Trade Date</fo:block>
											</fo:table-cell>
										</xsl:when>
										<xsl:otherwise>
											<fo:table-cell xsl:use-attribute-sets="first-column-cell-style">
												<fo:block>Trade Date</fo:block>
											</fo:table-cell>
										</xsl:otherwise>
									</xsl:choose>
									<fo:table-cell>
										<fo:block>Origin</fo:block>
									</fo:table-cell>
									<fo:table-cell xsl:use-attribute-sets="left-padded-column-cell-style">
										<fo:block>Ccy</fo:block>
									</fo:table-cell>
									<fo:table-cell>
										<fo:block>Transaction Type</fo:block>
									</fo:table-cell>
									<fo:table-cell xsl:use-attribute-sets="last-column-cell-style">
										<fo:block xsl:use-attribute-sets="quantity-block-style">Debit/Credit
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</fo:table-header>

							<fo:table-body>
								<xsl:apply-templates select="stmt:row" mode="cashPostings" />
							</fo:table-body>
						</fo:table>
					</xsl:if>

					<xsl:call-template name="emptySectionComment">
						<xsl:with-param name="content" select="stmt:row" />
					</xsl:call-template>

				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="stmt:row" mode="cashPostings">
		<xsl:variable name="currency" select="../@currency" />
		<xsl:variable name="isEvenRow">
			<xsl:if test="(position() mod 2) = 0">
				<xsl:value-of select="'true'" />
			</xsl:if>
		</xsl:variable>
		<fo:table-row>
			<xsl:call-template name="contentRowAttributes">
				<xsl:with-param name="isEvenRow" select="$isEvenRow" />
			</xsl:call-template>
			<xsl:choose>
				<xsl:when test="$statementType = 'PARENT'">
					<fo:table-cell xsl:use-attribute-sets="first-column-cell-style">
						<xsl:choose>
							<xsl:when test="@transferType = 'Opening Balance' or @transferType = 'Closing Balance'">
								<fo:block xsl:use-attribute-sets="bold-block-style">
									<xsl:value-of select="@account" />
								</fo:block>
							</xsl:when>
							<xsl:otherwise>
								<fo:block>
									<xsl:value-of select="@account" />
								</fo:block>
							</xsl:otherwise>
						</xsl:choose>
					</fo:table-cell>
					<fo:table-cell>
						<xsl:choose>
							<xsl:when test="@transferType = 'Opening Balance' or @transferType = 'Closing Balance'">
								<fo:block xsl:use-attribute-sets="bold-block-style">
									<xsl:value-of select="@date" />
								</fo:block>
							</xsl:when>
							<xsl:otherwise>
								<fo:block>
									<xsl:value-of select="@date" />
								</fo:block>
							</xsl:otherwise>
						</xsl:choose>
					</fo:table-cell>
				</xsl:when>
				<xsl:otherwise>
					<fo:table-cell xsl:use-attribute-sets="first-column-cell-style">
						<xsl:choose>
							<xsl:when test="@transferType = 'Opening Balance' or @transferType = 'Closing Balance'">
								<fo:block xsl:use-attribute-sets="bold-block-style">
									<xsl:value-of select="@date" />
								</fo:block>
							</xsl:when>
							<xsl:otherwise>
								<fo:block>
									<xsl:value-of select="@date" />
								</fo:block>
							</xsl:otherwise>
						</xsl:choose>
					</fo:table-cell>
				</xsl:otherwise>
			</xsl:choose>

			<fo:table-cell>
				<xsl:choose>
					<xsl:when test="@transferType = 'Opening Balance' or @transferType = 'Closing Balance'">
						<fo:block xsl:use-attribute-sets="bold-block-style">
							<xsl:value-of select="@accountType" />
						</fo:block>
					</xsl:when>
					<xsl:otherwise>
						<fo:block>
							<xsl:value-of select="@accountType" />
						</fo:block>
					</xsl:otherwise>
				</xsl:choose>
			</fo:table-cell>
			<fo:table-cell xsl:use-attribute-sets="left-padded-column-cell-style">
				<xsl:choose>
					<xsl:when test="@transferType = 'Opening Balance' or @transferType = 'Closing Balance'">
						<fo:block xsl:use-attribute-sets="bold-block-style">
							<xsl:value-of select="@currency" />
						</fo:block>
					</xsl:when>
					<xsl:otherwise>
						<fo:block>
							<xsl:value-of select="@currency" />
						</fo:block>
					</xsl:otherwise>
				</xsl:choose>		
			</fo:table-cell>
			<fo:table-cell>
				<xsl:choose>
					<xsl:when test="@transferType = 'Opening Balance' or @transferType = 'Closing Balance'">
						<fo:block xsl:use-attribute-sets="bold-block-style">
							<xsl:value-of select="@transferType" />
						</fo:block>
					</xsl:when>
					<xsl:otherwise>
						<fo:block>
							<xsl:value-of select="concat('&#160;','&#160;',@transferType)" />
						</fo:block>
					</xsl:otherwise>
				</xsl:choose>
			</fo:table-cell>
			<fo:table-cell xsl:use-attribute-sets="last-column-cell-style">
				<xsl:choose>
					<xsl:when test="@transferType = 'Opening Balance' or @transferType = 'Closing Balance'">
						<fo:block xsl:use-attribute-sets="quantity-bold-block-style">
							<xsl:value-of select="stmtext:formatNumber(@debitCredit, $currency)" />
						</fo:block>
					</xsl:when>
					<xsl:otherwise>
						<fo:block xsl:use-attribute-sets="quantity-block-style">
							<xsl:value-of select="stmtext:formatNumber(@debitCredit, $currency)" />
						</fo:block>
					</xsl:otherwise>
				</xsl:choose>		
			</fo:table-cell>
		</fo:table-row>
	</xsl:template>

</xsl:stylesheet>