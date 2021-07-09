<xsl:stylesheet xmlns:stmt="urn:com:calypso:clearing:statement:etd"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:stmtext="xalan://com.calypso.tk.bo.StatementDataTypeFormatter"
	version="1.0" extension-element-prefixes="stmtext"
	exclude-result-prefixes="xs stmtext">

	<xsl:variable name="statementCurrency"
		select="//stmt:section[@id='metadata']/@statementCurrency" />

	<xsl:variable name="statementType"
		select="//stmt:section[@id='metadata']/@statementType" />
	
	<xsl:variable name="isDailyFrequency"
			select="boolean(//stmt:section[@id = 'metadata']/@statementFrequency = 'DAILY')" />

	<!-- Controls the formatting of Future32/64 quotes -->
	<xsl:variable name="useExtendedFuture32" select="boolean(false)" />

	<xsl:variable name="hasDiscountedPositions"
		select="boolean(//stmt:section[@id='openPositions']/stmt:row[@disc = 'true'])" />

	<xsl:template name="emptySectionComment">
		<!-- Add to every section table, passing the its content, to render a comment 
			row if empty -->
		<xsl:param name="content" />
		<xsl:if test="not(boolean($content))">
			<div class="EMPTY_SECTION_COMMENT">No activity</div>
		</xsl:if>
	</xsl:template>

	<xsl:template name="sectionTitle">
		<xsl:param name="title" />
		<xsl:param name="comment" />
		<table class="TITLE">
			<tr>
				<th class="TITLE TITLE_TEXT">
					<xsl:value-of select="$title" />
				</th>
				<th class="TITLE" />
			</tr>
			<xsl:if test="boolean($comment)">
				<tr>
					<td class="SECTION_COMMENT" colspan="2">
						<xsl:value-of select="$comment" />
					</td>
				</tr>
			</xsl:if>
		</table>
	</xsl:template>

	<xsl:template name="formatAveragePrice">
		<xsl:param name="quoteType" />
		<xsl:param name="amount" />
		<xsl:param name="quantity" />
		<xsl:choose>
			<xsl:when test="$quoteType = 'Future32' or $quoteType = 'Future64'">
				<xsl:value-of
					select="stmtext:formatNumber(($amount * 100.0) div $quantity, 4)" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="stmtext:formatNumber($amount div $quantity, 4)" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- TRADE CONFIRMATIONS SECTION ############################################### -->

	<!-- Trade confirmations customizations over the other customizations: add 
		extra flows as columns, instead of subtotal rows -->

	<xsl:key name="tradeConfirmationKey"
		match="stmt:section[@id='tradeConfirmations']/stmt:section/stmt:row"
		use="concat(@account, @exchange, @contractDescription, @date, ../@id)" />

	<xsl:key name="tradeConfirmationTransferBucketKey"
		match="stmt:section[@id='tradeConfirmations']/stmt:section/stmt:row/stmt:bucket"
		use="concat(@name, @currency, ../@account, ../@exchange, ../@contractDescription, ../@date, ../../@id)" />

	<!-- Add all flow types in all subsections -->
	<xsl:key name="tradeConfirmationNonTotalFlowsKey"
		match="stmt:section[@id='tradeConfirmations']//stmt:bucket" use="@name" />

	<xsl:key name="tradeConfirmationFlowCurrencyKey"
		match="stmt:section[@id='tradeConfirmations']/stmt:section/stmt:row/stmt:bucket"
		use="concat(../@account, ../@exchange, ../@contractDescription, ../@date, ../../@id, @currency)" />

	<xsl:template match="stmt:section[@id='tradeConfirmations']">
		<div class="SECTION">

			<xsl:call-template name="sectionTitle">
				<xsl:with-param name="title" select="'Trade Confirmations'" />
			</xsl:call-template>

			<table class="FULL_WIDTH">
				<xsl:apply-templates select="stmt:section">
					<xsl:sort select="@order" />
				</xsl:apply-templates>
			</table>

			<xsl:call-template name="emptySectionComment">
				<xsl:with-param name="content" select="stmt:section" />
			</xsl:call-template>

		</div>
	</xsl:template>


	<xsl:template name="tradeConfirmationsSubsectionTableHeader">
		<xsl:param name="titleSuffix" />
		<thead>
			<tr>
				<th class="SUB_SECTION_TITLE" colspan="13">
					<xsl:value-of select="concat(@id, ' ', $titleSuffix)" />
				</th>
			</tr>
			<xsl:call-template name="tradeConfirmationsHeaderRow" />
		</thead>
	</xsl:template>

	<xsl:template name="tradingActivityHeaderRow">
		<tr>
			<xsl:if test="$statementType = 'PARENT'">
				<th>Account</th>
			</xsl:if>
			<th>ID</th>
			<th>Trade Date</th>
			<th>Execution Type</th>
			<th class="ALIGN_RIGHT">Long</th>
			<th class="ALIGN_RIGHT">Short</th>
			<th class="ALIGN_RIGHT">Type</th>
			<th class="ALIGN_CENTER">Symbol</th>
			<th>Strike</th>
			<th>Delivery</th>
			<th>Expiry Date</th>
			<th>Exchange</th>
			<th class="ALIGN_RIGHT">Trade Price</th>
			<th class="CURRENCY">Ccy</th>
			<th class="ALIGN_RIGHT DEBIT_CREDIT">Debit/Credit</th>
		</tr>
	</xsl:template>

	<xsl:template match="stmt:section[@id='tradeConfirmations']/stmt:section">

		<xsl:call-template name="tradeConfirmationsSubsectionTableHeader">
			<xsl:with-param name="titleSuffix" select="'TRADES'" />
		</xsl:call-template>

		<tbody>
			<xsl:apply-templates mode="tradeConfirmationsGroup"
				select="stmt:row[generate-id() = generate-id(key('tradeConfirmationKey', concat(@account, @exchange, @contractDescription, @date, ../@id))[1])]">
				<xsl:sort select="@account" />
				<xsl:sort select="@ticker" />
				<xsl:sort select="@id" />
				<xsl:sort select="@date" />
			</xsl:apply-templates>
		</tbody>

	</xsl:template>

	<xsl:template mode="tradeConfirmationsNonTotalColumnHeader"
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
		<th class="ALIGN_RIGHT">
			<xsl:value-of select="$colName" />
		</th>
	</xsl:template>

	<xsl:template name="tradeConfirmationsHeaderRow">
		<tr>
			<xsl:if test="$statementType = 'PARENT'">
				<th>Account</th>
			</xsl:if>
			<th>ID</th>
			<th>Trade Date</th>
			<th>Origin</th>
			<th>Trade Type</th>
			<th>Execution Type</th>
			<th class="ALIGN_RIGHT">Long</th>
			<th class="ALIGN_RIGHT">Short</th>
			<th class="ALIGN_RIGHT">Type</th>
			<th class="ALIGN_CENTER">Symbol</th>
			<th>Strike</th>
			<th>Delivery</th>
			<th>Expiry Date</th>
			<th>Exchange</th>
			<th class="ALIGN_RIGHT">Trade Price</th>
			<th class="CURRENCY">Ccy</th>

			<xsl:apply-templates mode="tradeConfirmationsNonTotalColumnHeader"
				select="..//stmt:row/stmt:bucket[generate-id() = generate-id(key('tradeConfirmationNonTotalFlowsKey', @name)[1])]">
				<xsl:sort select="@name" />
			</xsl:apply-templates>

			<th class="ALIGN_RIGHT DEBIT_CREDIT">Debit/Credit</th>
		</tr>
	</xsl:template>

	<xsl:template match="stmt:row" mode="tradeConfirmationsGroup">
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

		<xsl:variable name="trClass">
			<xsl:if test="(position() mod 2) = 0">
				<xsl:value-of select="'EVEN_ROW'" />
			</xsl:if>
		</xsl:variable>

		<xsl:apply-templates mode="tradeConfirmationsRow"
			select="../stmt:row[@account = $groupAccount and @exchange = $groupExchange and @contractDescription = $groupContract and @date = $groupDate]">
			<xsl:sort select="@id" />
			<xsl:sort select="@date" />
			<xsl:with-param name="trClass" select="$trClass" />
		</xsl:apply-templates>

		<xsl:variable name="totalLong"
			select="sum(../stmt:row[@account = $groupAccount and @exchange = $groupExchange and @contractDescription = $groupContract and @date = $groupDate and boolean(@long)]/@long)" />
		<xsl:variable name="totalShort"
			select="sum(../stmt:row[@account = $groupAccount and @exchange = $groupExchange and @contractDescription = $groupContract and @date = $groupDate and boolean(@short)]/@short)" />

		<!-- At least one mandatory subtotal row: the one for the flows in the 
			contract currency -->
		<xsl:apply-templates mode="tradeConfirmationsGroup"
			select="../stmt:row[@account = $groupAccount and @exchange = $groupExchange and @contractDescription = $groupContract and @date = $groupDate]/stmt:bucket[@currency = $contractCurrency and generate-id() = generate-id(key('tradeConfirmationFlowCurrencyKey', concat($groupAccount, $groupExchange, $groupContract, $groupDate, $currentSubsectionId, @currency))[1])]">
			<xsl:with-param name="trClass" select="$trClass" />
			<xsl:with-param name="totalLong" select="$totalLong" />
			<xsl:with-param name="totalShort" select="$totalShort" />
		</xsl:apply-templates>

		<!-- Rest of subtotals for flows in different currencies -->
		<xsl:apply-templates mode="tradeConfirmationsGroup"
			select="../stmt:row[@account = $groupAccount and @exchange = $groupExchange and @contractDescription = $groupContract and @date = $groupDate]/stmt:bucket[@currency != $contractCurrency and generate-id() = generate-id(key('tradeConfirmationFlowCurrencyKey', concat($groupAccount, $groupExchange, $groupContract, $groupDate, $currentSubsectionId, @currency))[1])]">
			<xsl:with-param name="trClass" select="$trClass" />
		</xsl:apply-templates>

		<!-- Add row when no flows are present, to render the total quantity -->
		<xsl:if
			test="not(boolean(../stmt:row[@account = $groupAccount and @exchange = $groupExchange and @contractDescription = $groupContract and @date = $groupDate]/stmt:bucket))">

			<xsl:apply-templates mode="tradeConfirmationsNoFlowsTotalRow"
				select="../stmt:row[@account = $groupAccount and @exchange = $groupExchange and @contractDescription = $groupContract and @date = $groupDate][1]">
				<xsl:with-param name="trClass" select="$trClass" />
				<xsl:with-param name="totalLong" select="$totalLong" />
				<xsl:with-param name="totalShort" select="$totalShort" />
			</xsl:apply-templates>

		</xsl:if>

	</xsl:template>

	<xsl:template match="stmt:row" mode="tradeConfirmationsRow">
		<xsl:param name="trClass" />

		<xsl:variable name="tradeId">
			<xsl:value-of select="@id" />
		</xsl:variable>

		<tr class="{$trClass}">
			<xsl:if test="$statementType = 'PARENT'">
				<td>
					<xsl:value-of select="@account" />
				</td>
			</xsl:if>
			<td>
				<xsl:value-of select="$tradeId" />
			</td>
			<td>
				<xsl:value-of select="@date" />
			</td>
			<td>
				<xsl:value-of select="@accountType" />
			</td>
			<td>
				<xsl:value-of select="@tradeType" />
			</td>
			<td class="wrappable">
				<xsl:value-of select="@executionType" />
			</td>
			<td class="ALIGN_RIGHT">
				<xsl:value-of select="stmtext:formatNumber(@long, 0)" />
			</td>
			<td class="ALIGN_RIGHT">
				<xsl:value-of select="stmtext:formatNumber(@short, 0)" />
			</td>
			<td class="ALIGN_RIGHT">
				<xsl:value-of select="@productType" />
			</td>
			<td class="SYMBOL">
				<div class="BOXED">
					<xsl:value-of select="@ticker" />
				</div>
			</td>
			<td>
				<xsl:value-of select="@strike" />
			</td>
			<td>
				<xsl:value-of select="@deliveryDate" />
			</td>
			<td>
				<xsl:value-of select="@expirationDate" />
			</td>
			<td>
				<xsl:value-of select="@exchange" />
			</td>
			<td class="ALIGN_RIGHT">
				<xsl:value-of
					select="stmtext:formatNumberWithQuoteType(@price, number(@contractDecimals), @quoteType, $useExtendedFuture32)" />
			</td>
			<td class="CURRENCY">
				<xsl:value-of select="@currency" />
			</td>

			<xsl:for-each
				select="../../..//stmt:row/stmt:bucket[not(contains(@name, 'Total')) and generate-id() = generate-id(key('tradeConfirmationNonTotalFlowsKey', @name)[1])]">
				<xsl:sort select="@name" />
				<xsl:variable name="flowName" select="@name" />
				<xsl:variable name="flowAmount">
					<xsl:value-of
						select="../../..//stmt:row[@id = $tradeId]/stmt:bucket[@name = $flowName]/@amount" />
				</xsl:variable>
				<xsl:variable name="flowCurrency">
					<xsl:value-of
						select="../../..//stmt:row[@id = $tradeId]/stmt:bucket[@name = $flowName]/@currency" />
				</xsl:variable>
				<td class="ALIGN_RIGHT">
					<xsl:if test="boolean($flowAmount) and boolean($flowCurrency)">
						<xsl:value-of select="stmtext:formatNumber($flowAmount, $flowCurrency)" />
					</xsl:if>
				</td>
			</xsl:for-each>

			<td class="ALIGN_RIGHT" />
		</tr>

		<xsl:if test="boolean(@orderTaker)">
			<tr class="{$trClass}">
				<td colspan="2" />
				<td>
					<xsl:value-of select="@orderTaker" />
				</td>
				<td colspan="9" />
			</tr>
		</xsl:if>

	</xsl:template>

	<xsl:template match="stmt:bucket[@name = 'Total Charges']"
		mode="tradeConfirmationsGroup" name="tradeConfirmationsTotalChargesSubtotal">
		<xsl:param name="trClass" />
		<xsl:param name="exchange" select="../@exchange" />
		<xsl:param name="contractDescription" select="../@contractDescription" />
		<xsl:param name="date" select="../@date" />
		<xsl:param name="account" select="../@account" />
		<xsl:param name="name" select="@name" />
		<xsl:param name="currency" select="@currency" />
		<xsl:param name="amount">
			<xsl:value-of
				select="sum(../../stmt:row[@account = $account and @exchange = $exchange and @contractDescription = $contractDescription and @date = $date]/stmt:bucket[@name = $name and @currency = $currency]/@amount)" />
		</xsl:param>
		<xsl:param name="totalLong" />
		<xsl:param name="totalShort" />

		<xsl:variable name="subsection" select="../../@id" />

		<tr class="{$trClass}">

			<xsl:if test="$statementType = 'PARENT'">
				<td />
			</xsl:if>
			<td />

			<td class="SUB_TOTAL">
				<xsl:value-of select="$date" />
			</td>
			<td />
			<td />
			<xsl:choose>
				<xsl:when test="boolean($totalShort) or boolean($totalLong)">

					<td class="ALIGN_RIGHT SUB_TOTAL">Total Quantity</td>

					<td class="ALIGN_RIGHT SUB_TOTAL">
						<xsl:if test="boolean($totalLong) and $totalLong != 0">
							<xsl:value-of select="stmtext:formatNumber($totalLong, 0)" />
						</xsl:if>
					</td>
					<td class="ALIGN_RIGHT SUB_TOTAL">
						<xsl:if test="boolean($totalShort) and $totalShort != 0">
							<xsl:value-of select="stmtext:formatNumber($totalShort, 0)" />
						</xsl:if>
					</td>

					<td />

					<td class="wrappable CONTRACT_DESCRIPTION SUB_TOTAL" colspan="5">
						<xsl:value-of select="$contractDescription" />
					</td>

				</xsl:when>
				<xsl:otherwise>

					<td colspan="9" />

				</xsl:otherwise>
			</xsl:choose>

			<td class="SUB_TOTAL ALIGN_RIGHT">
				<xsl:value-of select="'Total'" />
			</td>
			<td class="CURRENCY SUB_TOTAL">
				<xsl:value-of select="$currency" />
			</td>

			<xsl:for-each
				select="../../..//stmt:row/stmt:bucket[not(contains(@name, 'Total')) and generate-id() = generate-id(key('tradeConfirmationNonTotalFlowsKey', @name)[1])]">
				<xsl:sort select="@name" />
				<xsl:variable name="flowName" select="@name" />

				<xsl:variable name="flowAmount">
					<xsl:value-of
						select="sum(../../..//stmt:row[../@id = $subsection and @account = $account and @exchange = $exchange and @contractDescription = $contractDescription and @date = $date]/stmt:bucket[@name = $flowName and @currency = $currency]/@amount)" />
				</xsl:variable>

				<td class="SUB_TOTAL ALIGN_RIGHT">
					<xsl:if test="boolean(number($flowAmount)) and $flowAmount != 0">
						<xsl:value-of select="stmtext:formatNumber($flowAmount, $currency)" />
					</xsl:if>
				</td>
			</xsl:for-each>


			<td class="SUB_TOTAL ALIGN_RIGHT">
				<xsl:value-of select="stmtext:formatNumber($amount, $currency)" />
			</td>
		</tr>

	</xsl:template>

	<xsl:template match="stmt:row" mode="tradeConfirmationsNoFlowsTotalRow">
		<xsl:param name="trClass" />
		<xsl:param name="totalLong" />
		<xsl:param name="totalShort" />

		<tr class="{$trClass}">

			<xsl:if test="$statementType = 'PARENT'">
				<td />
			</xsl:if>
			<td />

			<td class="SUB_TOTAL">
				<xsl:value-of select="@date" />
			</td>
			<td />
			<td />
			<xsl:choose>
				<xsl:when test="boolean($totalShort) or boolean($totalLong)">

					<td class="ALIGN_RIGHT SUB_TOTAL">Total Quantity</td>

					<td class="ALIGN_RIGHT SUB_TOTAL">
						<xsl:if test="boolean($totalLong) and $totalLong != 0">
							<xsl:value-of select="stmtext:formatNumber($totalLong, 0)" />
						</xsl:if>
					</td>
					<td class="ALIGN_RIGHT SUB_TOTAL">
						<xsl:if test="boolean($totalShort) and $totalShort != 0">
							<xsl:value-of select="stmtext:formatNumber($totalShort, 0)" />
						</xsl:if>
					</td>

					<td />

					<td class="wrappable CONTRACT_DESCRIPTION SUB_TOTAL" colspan="5">
						<xsl:value-of select="@contractDescription" />
					</td>

				</xsl:when>
				<xsl:otherwise>

					<td colspan="10" />

				</xsl:otherwise>
			</xsl:choose>

			<td colspan="9" />

		</tr>

	</xsl:template>



	<!-- COMMISSIONS AND FEES ADJUSTMENTS SECTION ############################################### -->

	<xsl:key name="commissionsAdjustmentsKey"
		match="//stmt:section[@id='commissionsAdjustments']/stmt:section/stmt:row"
		use="concat(../@id, ../@currency, @transferType)" />

	<xsl:template match="stmt:section[@id='commissionsAdjustments']">
		<div class="SECTION">

			<xsl:call-template name="sectionTitle">
				<xsl:with-param name="title"
					select="'Fees and Commissions Adjustments'" />
				<xsl:with-param name="comment"
					select="'Net impact of changes to previously booked charges which are not captured in the Trade Confirmation section'" />
			</xsl:call-template>

			<xsl:if test="boolean(stmt:section)">
				<table class="FULL_WIDTH">
					<xsl:call-template name="commissionsAdjustmentsHeaderRow" />

					<xsl:apply-templates select="stmt:section">
						<xsl:sort select="@id" />
						<xsl:sort select="@currency" />
					</xsl:apply-templates>
				</table>
			</xsl:if>

			<xsl:call-template name="emptySectionComment">
				<xsl:with-param name="content" select="stmt:section" />
			</xsl:call-template>

		</div>
	</xsl:template>


	<xsl:template match="stmt:section[@id='commissionsAdjustments']/stmt:section">
		<xsl:variable name="trClass">
			<xsl:if test="(position() mod 2) = 0">
				<xsl:value-of select="'EVEN_ROW'" />
			</xsl:if>
		</xsl:variable>

		<!-- Transfer rows -->
		<xsl:apply-templates select="stmt:row"
			mode="commissionsAdjustments">
			<xsl:sort select="@account" />
			<xsl:sort select="@id" />
			<xsl:sort select="@transferType" />
			<xsl:with-param name="trClass" select="$trClass" />
		</xsl:apply-templates>

		<!-- Grand total -->
		<xsl:call-template name="commissionsAdjustmentsTotal">
			<xsl:with-param name="trClass" select="$trClass" />
			<xsl:with-param name="type" select="'Total Charges'" />
			<xsl:with-param name="currency" select="@currency" />
			<xsl:with-param name="total">
				<xsl:value-of select="sum(stmt:row/@debitCredit)" />
			</xsl:with-param>
		</xsl:call-template>

	</xsl:template>

	<xsl:template name="commissionsAdjustmentsHeaderRow">
		<tr>
			<xsl:if test="$statementType = 'PARENT'">
				<th>Account</th>
			</xsl:if>
			<th>Cleared Transaction ID</th>
			<th>Charge Type</th>
			<th style="width: 40%;">Comment</th>
			<th class="CURRENCY">Ccy</th>
			<th class="ALIGN_RIGHT DEBIT_CREDIT">Debit/Credit</th>
		</tr>
	</xsl:template>

	<xsl:template name="commissionsAdjustmentsTotal">
		<xsl:param name="trClass" />
		<xsl:param name="type" />
		<xsl:param name="total" />
		<xsl:param name="currency" />
		<tr class="{$trClass}">
			<xsl:if test="$statementType = 'PARENT'">
				<td />
			</xsl:if>
			<td colspan="2" />
			<td class="SUB_TOTAL ALIGN_RIGHT">
				<xsl:value-of select="$type" />
			</td>
			<td class="CURRENCY">
				<xsl:value-of select="$currency" />
			</td>
			<td class="ALIGN_RIGHT SUB_TOTAL">
				<xsl:value-of select="stmtext:formatNumber($total, $currency)" />
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="stmt:row" mode="commissionsAdjustments">
		<xsl:param name="trClass" />
		<xsl:variable name="currency" select="../@currency" />

		<tr class="{$trClass}">
			<xsl:if test="$statementType = 'PARENT'">
				<td>
					<xsl:value-of select="@account" />
				</td>
			</xsl:if>
			<td>
				<xsl:value-of select="@id" />
			</td>
			<td>
				<xsl:value-of select="@transferType" />
			</td>
			<td class="wrappable">
				<xsl:value-of select="@comment" />
			</td>
			<td class="CURRENCY">
				<xsl:value-of select="$currency" />
			</td>
			<td class="ALIGN_RIGHT">
				<xsl:value-of select="stmtext:formatNumber(@debitCredit, $currency)" />
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="stmt:row" mode="commissionsAdjustmentsTotal">
		<xsl:param name="trClass" />
		<xsl:variable name="transferType" select="@transferType" />

		<xsl:call-template name="commissionsAdjustmentsTotal">
			<xsl:with-param name="trClass" select="$trClass" />
			<xsl:with-param name="type" select="$transferType" />
			<xsl:with-param name="currency" select="../@currency" />
			<xsl:with-param name="total">
				<xsl:value-of
					select="sum(../stmt:row[@transferType = $transferType]/@debitCredit)" />
			</xsl:with-param>
		</xsl:call-template>

	</xsl:template>

	<!-- CASH POSTINGS SECTION ############################################### -->

	<xsl:template match="stmt:section[@id='cashPostings']">
		<xsl:choose>
			<xsl:when test="$isDailyFrequency">
			</xsl:when>
			<xsl:otherwise>
				<div class="SECTION">
					<xsl:call-template name="sectionTitle">
						<xsl:with-param name="title"
							select="'Cash Postings'" />
					</xsl:call-template>
		
					<xsl:if test="boolean(stmt:row)">
						<table class="FULL_WIDTH">
							<xsl:call-template name="cashPostingsHeaderRow" />
							<!-- Transfer rows -->
							<xsl:apply-templates select="stmt:row" mode="cashPostings" />
						</table>
					</xsl:if>
		
					<xsl:call-template name="emptySectionComment">
						<xsl:with-param name="content" select="stmt:row" />
					</xsl:call-template>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="cashPostingsHeaderRow">
		<tr>
			<xsl:if test="$statementType = 'PARENT'">
				<th>Account</th>
			</xsl:if>
			<th>Trade Date</th>
			<th>Origin</th>
			<th class="CURRENCY">Ccy</th>
			<th style="width: 40%;">Transaction Type</th>
			<th class="ALIGN_RIGHT DEBIT_CREDIT">Debit/Credit</th>
		</tr>
	</xsl:template>

	<xsl:template match="stmt:row" mode="cashPostings">
		<xsl:variable name="trClass">
			<xsl:if test="(position() mod 2) = 0">
				<xsl:value-of select="'EVEN_ROW'" />
			</xsl:if>
		</xsl:variable>

		<tr class="{$trClass}">
			<xsl:if test="$statementType = 'PARENT'">
				<td>
					<xsl:value-of select="@account" />
				</td>
			</xsl:if>
			<td>
				<xsl:value-of select="@date" />
			</td>
			<td>
				<xsl:value-of select="@accountType" />
			</td>
			<td class="CURRENCY">
				<xsl:value-of select="@currency" />
			</td>
			<td class="wrappable">
				<xsl:value-of select="@transferType" />
			</td>
			<td class="ALIGN_RIGHT">
				<xsl:value-of select="stmtext:formatNumber(@debitCredit, @currency)" />
			</td>
		</tr>
	</xsl:template>
	
	<!-- PURCHASES AND SALES SECTION ############################################### -->

	<xsl:key name="liquidationRowKey"
		match="stmt:section[@id='purchasesAndSales']/stmt:section/stmt:row"
		use="concat(@account, @exchange, @contractDescription, ../@id)" />

	<xsl:template match="stmt:section[@id='purchasesAndSales']">
		<div class="SECTION">

			<xsl:call-template name="sectionTitle">
				<xsl:with-param name="title" select="'Purchases And Sales'" />
			</xsl:call-template>

			<table class="FULL_WIDTH">
				<xsl:apply-templates>
					<xsl:sort select="@order" />
				</xsl:apply-templates>
			</table>

			<xsl:call-template name="emptySectionComment">
				<xsl:with-param name="content" select="stmt:section" />
			</xsl:call-template>
		</div>
	</xsl:template>

	<xsl:template match="stmt:section[@id='purchasesAndSales']/stmt:section">

		<thead>
			<tr>
				<th class="SUB_SECTION_TITLE" colspan="13">
					<xsl:value-of select="concat(@id, ' OFFSETS')" />
				</th>
			</tr>
			<tr>
				<xsl:if test="$statementType = 'PARENT'">
					<th>Account</th>
				</xsl:if>
				<th>Buy Trade ID</th>
				<th>Buy Trade Date</th>
				<th>Sell Trade ID</th>
				<th>Sell Trade Date</th>
				<th>Origin</th>
				<th>Quantity</th>
				<th class="ALIGN_RIGHT">Type</th>
				<th class="ALIGN_CENTER">Symbol</th>
				<th>Strike</th>
				<th>Delivery</th>
				<th>Expiry Date</th>
				<th>Exchange</th>
				<th>Buy Price</th>
				<th>Sell Price</th>
				<th class="CURRENCY">Ccy</th>
				<th class="ALIGN_RIGHT DEBIT_CREDIT">Realized PL</th>
			</tr>
		</thead>

		<tbody>
			<xsl:apply-templates
				select="stmt:row[generate-id() = generate-id(key('liquidationRowKey', concat(@account, @exchange, @contractDescription, ../@id))[1])]"
				mode="liquidationGroup">
				<xsl:sort select="@account" />
				<xsl:sort select="stmt:liqTrade[@order = 1]/@ticker" />
				<xsl:sort select="stmt:liqTrade[@order = 1]/@id" />
				<xsl:sort select="stmt:liqTrade[@order = 2]/@id" />
			</xsl:apply-templates>
		</tbody>

	</xsl:template>

	<xsl:template match="stmt:row" mode="liquidationGroup">

		<xsl:variable name="trClass">
			<xsl:if test="(position() mod 2) = 0">
				<xsl:value-of select="'EVEN_ROW'" />
			</xsl:if>
		</xsl:variable>

		<xsl:variable name="groupAccount" select="@account" />
		<xsl:variable name="groupExchange" select="@exchange" />
		<xsl:variable name="groupContract" select="@contractDescription" />
		<xsl:variable name="contractCurrency" select="@currency" />

		<xsl:apply-templates
			select="../stmt:row[@account = $groupAccount and @exchange = $groupExchange and @contractDescription = $groupContract]"
			mode="liquidation">
			<xsl:sort select="stmt:liqTrade[@order = 1]/@id" />
			<xsl:sort select="stmt:liqTrade[@order = 2]/@id" />
			<xsl:sort select="stmt:liqTrade[@order = 1]/@date" />
			<xsl:sort select="stmt:liqTrade[@order = 2]/@date" />
			<xsl:with-param name="trClass" select="$trClass" />
		</xsl:apply-templates>

		<xsl:variable name="totalQuantity">
			<!-- Longs and shorts should match -->
			<xsl:value-of
				select="sum(../stmt:row[@account = $groupAccount and @exchange = $groupExchange and @contractDescription = $groupContract]/stmt:liqTrade[@long > 0]/@long)" />
		</xsl:variable>

		<xsl:variable name="totalRealized">
			<xsl:value-of
				select="sum(../stmt:row[@account = $groupAccount and @exchange = $groupExchange and @contractDescription = $groupContract and boolean(@debitCredit)]/@debitCredit)" />
		</xsl:variable>

		<!-- Contract description and total row -->
		<tr class="{$trClass}">
			<xsl:if test="$statementType = 'PARENT'">
				<td />
			</xsl:if>
			<td colspan="2" />
			<td class="ALIGN_RIGHT SUB_TOTAL" colspan="3">Total Quantity</td>
			<td class="ALIGN_RIGHT SUB_TOTAL">
				<xsl:value-of select="stmtext:formatNumber($totalQuantity, 0)" />
			</td>

			<td />

			<td class="wrappable CONTRACT_DESCRIPTION SUB_TOTAL" colspan="5">
				<xsl:value-of select="$groupContract" />
			</td>

			<xsl:choose>
				<xsl:when
					test="boolean(../stmt:row[@account = $groupAccount and @exchange = $groupExchange and @contractDescription = $groupContract]/@debitCredit)">

					<td class="SUB_TOTAL ALIGN_RIGHT" colspan="2">
						<xsl:value-of select="'Total Realized PL'" />
					</td>
					<td class="CURRENCY SUB_TOTAL">
						<xsl:value-of select="$contractCurrency" />
					</td>
					<td class="SUB_TOTAL ALIGN_RIGHT">
						<xsl:value-of
							select="stmtext:formatNumber($totalRealized, $contractCurrency)" />
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td colspan="4" />
				</xsl:otherwise>
			</xsl:choose>
		</tr>

	</xsl:template>

	<xsl:template match="stmt:row" mode="liquidation">
		<xsl:param name="trClass" />

		<!-- Should match the 2nd trade -->
		<xsl:variable name="quantity">
			<xsl:choose>
				<xsl:when test="boolean(stmt:liqTrade[@order = 1]/@long)">
					<xsl:value-of select="stmt:liqTrade[@order = 1]/@long" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="stmt:liqTrade[@order = 1]/@short" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="firstPrice">
			<xsl:value-of
				select="stmtext:formatNumberWithQuoteType(stmt:liqTrade[@order = 1]/@price, number(stmt:liqTrade[@order = 1]/@contractDecimals), stmt:liqTrade[@order = 1]/@quoteType, $useExtendedFuture32)" />
		</xsl:variable>
		<xsl:variable name="secondPrice">
			<xsl:value-of
				select="stmtext:formatNumberWithQuoteType(stmt:liqTrade[@order = 2]/@price, number(stmt:liqTrade[@order = 2]/@contractDecimals), stmt:liqTrade[@order = 2]/@quoteType, $useExtendedFuture32)" />
		</xsl:variable>

		<tr class="{$trClass}">
			<xsl:if test="$statementType = 'PARENT'">
				<td>
					<xsl:value-of select="@account" />
				</td>
			</xsl:if>
			<td>
				<xsl:value-of select="stmt:liqTrade[@order = 1]/@id" />
			</td>
			<td>
				<xsl:value-of select="stmt:liqTrade[@order = 1]/@date" />
			</td>
			<td>
				<xsl:value-of select="stmt:liqTrade[@order = 2]/@id" />
			</td>
			<td>
				<xsl:value-of select="stmt:liqTrade[@order = 2]/@date" />
			</td>
			<td>
				<xsl:value-of select="@accountType" />
			</td>
			<td class="ALIGN_RIGHT">
				<xsl:value-of select="stmtext:formatNumber($quantity, 0)" />
			</td>
			<td class="ALIGN_RIGHT">
				<xsl:value-of select="@productType" />
			</td>
			<td class="SYMBOL">
				<div class="BOXED">
					<xsl:value-of select="@ticker" />
				</div>
			</td>
			<td>
				<xsl:value-of select="@strike" />
			</td>
			<td>
				<xsl:value-of select="@deliveryDate" />
			</td>
			<td>
				<xsl:value-of select="@expirationDate" />
			</td>
			<td>
				<xsl:value-of select="@exchange" />
			</td>
			<td class="ALIGN_RIGHT">
				<xsl:value-of select="$firstPrice" />
			</td>
			<td class="ALIGN_RIGHT">
				<xsl:value-of select="$secondPrice" />
			</td>
			<td class="CURRENCY">
				<xsl:value-of select="@currency" />
			</td>
			<td class="SUB_TOTAL ALIGN_RIGHT">
				<xsl:if test="boolean(@debitCredit)">
					<xsl:value-of select="stmtext:formatNumber(@debitCredit, @currency)" />
				</xsl:if>
			</td>
		</tr>

	</xsl:template>

	<!-- LIFECYCLE ACTIVITY SECTION ############################################### -->

	<xsl:key name="lifecycleActivityNonTotalFlowsKey"
		match="stmt:section[@id='lifecycleActivity']//stmt:bucket" use="@name" />

	<xsl:key name="lifecycleActivityFlowCurrencyKey"
		match="stmt:section[@id='lifecycleActivity']/stmt:section/stmt:row/stmt:bucket"
		use="concat(../@account, ../@exchange, ../@contractDescription, ../../@id, @currency)" />

	<xsl:key name="lifecycleActivityKey"
		match="stmt:section[@id='lifecycleActivity']/stmt:section/stmt:row"
		use="concat(@account, @exchange, @contractDescription, ../@id)" />

	<xsl:key name="lifecycleActivityTransferBucketKey"
		match="stmt:section[@id='lifecycleActivity']/stmt:section/stmt:row/stmt:bucket"
		use="concat(@name, @currency, ../@account, ../@exchange, ../@contractDescription, ../../@id)" />

	<xsl:template match="stmt:section[@id='lifecycleActivity']">
		<div class="SECTION">
			<xsl:call-template name="sectionTitle">
				<xsl:with-param name="title" select="'Lifecycle Activity'" />
			</xsl:call-template>

			<table class="FULL_WIDTH">
				<xsl:apply-templates select="stmt:section">
					<xsl:sort select="@order" />
				</xsl:apply-templates>
			</table>

			<xsl:call-template name="emptySectionComment">
				<xsl:with-param name="content" select="stmt:section" />
			</xsl:call-template>
		</div>
	</xsl:template>

	<xsl:template name="lifecycleActivitySubsectionTableHeader">
		<xsl:param name="titleSuffix" />
		<thead>
			<tr>
				<th class="SUB_SECTION_TITLE" colspan="13">
					<xsl:value-of select="concat(@id, ' ', $titleSuffix)" />
				</th>
			</tr>
			<tr>
				<xsl:if test="$statementType = 'PARENT'">
					<th>Account</th>
				</xsl:if>
				<th>ID</th>
				<th>Trade Date</th>
				<th>Execution Type</th>
				<th class="ALIGN_RIGHT">Long</th>
				<th class="ALIGN_RIGHT">Short</th>
				<th class="ALIGN_RIGHT">Type</th>
				<th class="ALIGN_CENTER">Symbol</th>
				<th>Strike</th>
				<th>Prompt</th>
				<th>Expiry Date</th>
				<th>Exchange</th>
				<th class="ALIGN_RIGHT">Trade Price</th>
				<th class="CURRENCY">Ccy</th>
				<!-- Variable number of flows -->
				<xsl:apply-templates mode="lifecycleActivityNonTotalColumnHeader"
					select="..//stmt:row/stmt:bucket[generate-id() = generate-id(key('lifecycleActivityNonTotalFlowsKey', @name)[1])]">
					<xsl:sort select="@name" />
				</xsl:apply-templates>
				<th class="ALIGN_RIGHT DEBIT_CREDIT">Debit/Credit</th>
			</tr>
		</thead>
	</xsl:template>

	<!-- Variable number of flow columns -->
	<xsl:template mode="lifecycleActivityNonTotalColumnHeader"
		match="stmt:bucket[not(contains(@name, 'Total'))]">
		<th class="wrappable ALIGN_RIGHT">
			<xsl:value-of select="@name" />
		</th>

	</xsl:template>

	<xsl:template match="stmt:section[@id='lifecycleActivity']/stmt:section">

		<xsl:call-template name="lifecycleActivitySubsectionTableHeader">
			<xsl:with-param name="titleSuffix" select="'LIFECYCLE ACTIVITY'" />
		</xsl:call-template>

		<tbody>
			<xsl:apply-templates mode="lifecycleActivityRowGroup"
				select="stmt:row[generate-id() = generate-id(key('lifecycleActivityKey', concat(@account, @exchange, @contractDescription, ../@id))[1])]">
				<xsl:sort select="@account" />
				<xsl:sort select="@ticker" />
				<xsl:sort select="@id" />
			</xsl:apply-templates>
		</tbody>
	</xsl:template>

	<xsl:template match="stmt:row" mode="lifecycleActivityRowGroup">
		<xsl:variable name="subsection" select="../@id" />
		<xsl:variable name="groupAccount" select="@account" />
		<xsl:variable name="groupExchange" select="@exchange" />
		<xsl:variable name="groupContractDescription" select="@contractDescription" />

		<xsl:variable name="trClass">
			<xsl:if test="(position() mod 2) = 0">
				<xsl:value-of select="'EVEN_ROW'" />
			</xsl:if>
		</xsl:variable>

		<xsl:apply-templates mode="lifecycleActivityRow"
			select="../stmt:row[@account = $groupAccount and @exchange = $groupExchange and @contractDescription = $groupContractDescription]">
			<xsl:sort select="@id" />
			<xsl:sort select="@date" />
			<xsl:with-param name="trClass" select="$trClass" />
		</xsl:apply-templates>

		<xsl:apply-templates mode="lifecycleActivityTransferBucketRow"
			select="../stmt:row[@account = $groupAccount and @exchange = $groupExchange and @contractDescription = $groupContractDescription]/stmt:bucket[generate-id() = generate-id(key('lifecycleActivityTransferBucketKey', concat(@name, @currency, $groupAccount, $groupExchange, $groupContractDescription, $subsection))[1])]">
			<xsl:sort select="@order" />
			<xsl:sort select="@name" />
			<xsl:sort select="@currency" />
			<xsl:with-param name="trClass" select="$trClass" />
		</xsl:apply-templates>

	</xsl:template>

	<xsl:template match="stmt:row" mode="lifecycleActivityRow">
		<xsl:param name="trClass" />
		<xsl:variable name="isCancelled" select="boolean(../@id = 'cancelled')" />

		<xsl:variable name="subsection">
			<xsl:value-of select="../@id" />
		</xsl:variable>

		<xsl:variable name="tradeId">
			<xsl:value-of select="@closeOutId" />
		</xsl:variable>

		<tr class="{$trClass}">
			<xsl:if test="$statementType = 'PARENT'">
				<td>
					<xsl:value-of select="@account" />
				</td>
			</xsl:if>
			<td>
				<xsl:value-of select="@id" />
			</td>
			<td>
				<xsl:value-of select="@date" />
			</td>
			<td class="wrappable">
				<xsl:value-of select="@executionType" />
				<xsl:if test="$isCancelled and boolean(@executionType)">
					<xsl:value-of select="' REVERSAL'" />
				</xsl:if>
			</td>
			<td class="ALIGN_RIGHT">
				<xsl:value-of select="stmtext:formatNumber(@long, 0)" />
			</td>
			<td class="ALIGN_RIGHT">
				<xsl:value-of select="stmtext:formatNumber(@short, 0)" />
			</td>
			<td class="ALIGN_RIGHT">
				<xsl:value-of select="@productType" />
			</td>
			<td class="SYMBOL">
				<div class="BOXED">
					<xsl:value-of select="@ticker" />
				</div>
			</td>
			<td>
				<xsl:value-of select="@strike" />
			</td>
			<td>
				<xsl:value-of select="@deliveryDate" />
			</td>
			<td>
				<xsl:value-of select="@expirationDate" />
			</td>
			<td>
				<xsl:value-of select="@exchange" />
			</td>
			<td class="ALIGN_RIGHT">
				<xsl:value-of
					select="stmtext:formatNumberWithQuoteType(@price, number(@contractDecimals), @quoteType, $useExtendedFuture32)" />
			</td>
			<td class="CURRENCY">
				<xsl:value-of select="@currency" />
			</td>

			<!-- Variable number of flows -->
			<!-- Careful: this iterates over all subsections, finding all bucket names 
				(full union) -->
			<xsl:for-each
				select="../../..//stmt:row/stmt:bucket[not(contains(@name, 'Total')) and generate-id() = generate-id(key('lifecycleActivityNonTotalFlowsKey', @name)[1])]">
				<xsl:sort select="@name" />
				<xsl:variable name="flowName" select="@name" />
				<xsl:variable name="flowAmount">
					<xsl:value-of
						select="../../..//stmt:section[@id = $subsection]/stmt:row[@closeOutId = $tradeId]/stmt:bucket[@name = $flowName]/@amount" />
				</xsl:variable>
				<xsl:variable name="flowCurrency">
					<xsl:value-of
						select="../../..//stmt:section[@id = $subsection]/stmt:row[@closeOutId = $tradeId]/stmt:bucket[@name = $flowName]/@currency" />
				</xsl:variable>

				<td class="ALIGN_RIGHT">
					<xsl:if test="boolean($flowAmount) and boolean($flowCurrency)">
						<xsl:value-of select="stmtext:formatNumber($flowAmount, $flowCurrency)" />
					</xsl:if>
				</td>
			</xsl:for-each>

			<td class="ALIGN_RIGHT">
				<xsl:if test="boolean(@debitCredit)">
					<xsl:value-of select="stmtext:formatNumber(@debitCredit, @currency)" />
				</xsl:if>
			</td>
		</tr>

	</xsl:template>

	<xsl:template match="stmt:bucket[@name = 'Total Charges']"
		mode="lifecycleActivityTransferBucketRow">

		<!-- This assumes single currency flows, so we can reuse it for the contract 
			description too -->

		<xsl:param name="trClass" />
		<xsl:param name="exchange" select="../@exchange" />
		<xsl:param name="contractDescription" select="../@contractDescription" />
		<xsl:param name="account" select="../@account" />
		<xsl:param name="name" select="@name" />
		<xsl:param name="currency" select="@currency" />
		<xsl:param name="amount">
			<xsl:value-of
				select="sum(../../stmt:row[@account = $account and @exchange = $exchange and @contractDescription = $contractDescription]/stmt:bucket[@name = $name and @currency = $currency]/@amount)" />
		</xsl:param>

		<xsl:variable name="totalLong"
			select="sum(../../stmt:row[@account = $account and @exchange = $exchange and @contractDescription = $contractDescription and boolean(@long)]/@long)" />
		<xsl:variable name="totalShort"
			select="sum(../../stmt:row[@account = $account and @exchange = $exchange and @contractDescription = $contractDescription and boolean(@short)]/@short)" />

		<xsl:variable name="subsection" select="../../@id" />

		<tr class="{$trClass}">
			<xsl:if test="$statementType = 'PARENT'">
				<td />
			</xsl:if>
			<td />

			<td class="ALIGN_RIGHT SUB_TOTAL" colspan="2">Total Quantity
			</td>

			<td class="ALIGN_RIGHT SUB_TOTAL">
				<xsl:if test="boolean($totalLong) and $totalLong != 0">
					<xsl:value-of select="stmtext:formatNumber($totalLong, 0)" />
				</xsl:if>
			</td>
			<td class="ALIGN_RIGHT SUB_TOTAL">
				<xsl:if test="boolean($totalShort) and $totalShort != 0">
					<xsl:value-of select="stmtext:formatNumber($totalShort, 0)" />
				</xsl:if>
			</td>

			<td />

			<td class="wrappable CONTRACT_DESCRIPTION SUB_TOTAL" colspan="5">
				<xsl:value-of select="$contractDescription" />
			</td>

			<td class="wrappable SUB_TOTAL ALIGN_RIGHT">
				<xsl:value-of select="$name" />
			</td>
			<td class="CURRENCY SUB_TOTAL">
				<xsl:value-of select="$currency" />
			</td>

			<xsl:for-each
				select="../../..//stmt:row/stmt:bucket[not(contains(@name, 'Total')) and generate-id() = generate-id(key('lifecycleActivityNonTotalFlowsKey', @name)[1])]">
				<xsl:sort select="@name" />
				<xsl:variable name="flowName" select="@name" />

				<xsl:variable name="flowAmount">
					<xsl:value-of
						select="sum(../../..//stmt:row[../@id = $subsection and @account = $account and @exchange = $exchange and @contractDescription = $contractDescription]/stmt:bucket[@name = $flowName and @currency = $currency]/@amount)" />
				</xsl:variable>

				<td class="SUB_TOTAL ALIGN_RIGHT">
					<xsl:if test="boolean(number($flowAmount)) and $flowAmount != 0">
						<xsl:value-of select="stmtext:formatNumber($flowAmount, $currency)" />
					</xsl:if>
				</td>
			</xsl:for-each>

			<td class="SUB_TOTAL ALIGN_RIGHT">
				<xsl:value-of select="stmtext:formatNumber($amount, $currency)" />
			</td>
		</tr>

	</xsl:template>

	<!-- OPEN POSITIONS SECTION ############################################### -->

	<xsl:key name="openPositionKey" match="stmt:section[@id='openPositions']/stmt:row"
		use="concat(@account, @exchange, @contractDescription)" />

	<xsl:template match="stmt:section[@id='openPositions']">
		<div class="SECTION">

			<xsl:call-template name="sectionTitle">
				<xsl:with-param name="title" select="'Open Positions'" />
			</xsl:call-template>

			<xsl:if test="boolean(stmt:row)">
				<table class="FULL_WIDTH">

					<thead>
						<xsl:call-template name="tradingActivityHeaderRow" />
					</thead>

					<tbody>
						<xsl:apply-templates mode="openPositionsGroup"
							select="stmt:row[generate-id() = generate-id(key('openPositionKey', concat(@account, @exchange, @contractDescription))[1])]">
							<xsl:sort select="@account" />
							<xsl:sort select="@exchange" />
							<xsl:sort select="@contractName" />
						</xsl:apply-templates>
					</tbody>

				</table>
			</xsl:if>

			<xsl:call-template name="emptySectionComment">
				<xsl:with-param name="content" select="stmt:row" />
			</xsl:call-template>

		</div>
	</xsl:template>

	<xsl:template name="formatPrice">

		<xsl:param name="quoteType" select="'Price'" />
		<xsl:param name="price" />
		<xsl:param name="quantity" />
		<xsl:param name="decimals" select="number(4)" />

		<xsl:choose>
			<xsl:when test="$quoteType = 'Future32' or $quoteType = 'Future64'">
				<xsl:value-of
					select="stmtext:formatNumber(($price * 100.0) div $quantity, $decimals)" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of
					select="stmtext:formatNumber($price div $quantity, $decimals)" />
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<xsl:template name="calculateTotalQtyWeightedPrice">
		<xsl:param name="rows" />
		<xsl:param name="isLong" />
		<xsl:param name="total" select="0" />
		<xsl:choose>
			<xsl:when test="$rows">
				<xsl:variable name="currentRowQtyPrice">
					<xsl:call-template name="calculateQtyWeightedPrice">
						<xsl:with-param name="row" select="$rows[1]" />
						<xsl:with-param name="isLong" select="$isLong" />
					</xsl:call-template>
				</xsl:variable>
				<xsl:call-template name="calculateTotalQtyWeightedPrice">
					<xsl:with-param name="rows" select="$rows[position() > 1]" />
					<xsl:with-param name="isLong" select="$isLong" />
					<xsl:with-param name="total" select="$total + $currentRowQtyPrice" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$total" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="calculateQtyWeightedPrice">
		<xsl:param name="row" />
		<xsl:param name="isLong" />
		<xsl:choose>
			<xsl:when test="$isLong != 0">
				<xsl:value-of select="$row/@price * $row/@long" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$row/@price * $row/@short" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="openPositionsHeaderRow">
		<tr>
			<xsl:if test="$statementType = 'PARENT'">
				<th>Account</th>
			</xsl:if>
			<th>ID</th>
			<th>Trade Date</th>
			<th>Origin</th>
			<th class="ALIGN_RIGHT">Long</th>
			<th class="ALIGN_RIGHT">Short</th>
			<th class="ALIGN_RIGHT">Type</th>
			<th class="ALIGN_CENTER">Symbol</th>
			<th>Strike</th>
			<th>Delivery</th>
			<th>Expiry Date</th>
			<th>Exchange</th>
			<th class="ALIGN_RIGHT">Trade Price</th>
			<th class="ALIGN_RIGHT">Close Price</th>
			<th class="CURRENCY">Ccy</th>
			<th class="DEBIT_CREDIT">Open Trade Equity</th>
		</tr>
	</xsl:template>

	<xsl:template match="stmt:section[@id='openPositions']">
		<div class="SECTION">

			<xsl:call-template name="sectionTitle">
				<xsl:with-param name="title" select="'Open Positions'" />
			</xsl:call-template>

			<xsl:if test="boolean(stmt:row)">
				<table class="FULL_WIDTH">

					<thead>
						<xsl:call-template name="openPositionsHeaderRow" />
					</thead>

					<tbody>
						<xsl:apply-templates mode="openPositionsGroup"
							select="stmt:row[generate-id() = generate-id(key('openPositionKey', concat(@account, @exchange, @contractDescription))[1])]">
							<xsl:sort select="@account" />
							<xsl:sort select="@ticker" />
							<xsl:sort select="@id" />
						</xsl:apply-templates>
					</tbody>

				</table>
			</xsl:if>

			<xsl:call-template name="emptySectionComment">
				<xsl:with-param name="content" select="stmt:row" />
			</xsl:call-template>

		</div>
	</xsl:template>

	<xsl:template match="stmt:row" mode="openPositionsGroup">

		<xsl:variable name="trClass">
			<xsl:if test="(position() mod 2) = 0">
				<xsl:value-of select="'EVEN_ROW'" />
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

		<xsl:apply-templates mode="openPositionsRow"
			select="../stmt:row[@account = $groupAccount and @exchange = $groupExchange and @contractDescription = $groupContractDescription]">
			<xsl:sort select="@deliveryDate" />
			<xsl:sort select="@date" />
			<xsl:with-param name="trClass" select="$trClass" />
		</xsl:apply-templates>

		<xsl:variable name="totalLong"
			select="sum(../stmt:row[@account = $groupAccount and @exchange = $groupExchange and @contractDescription = $groupContractDescription and boolean(@long)]/@long)" />
		<xsl:variable name="totalShort"
			select="sum(../stmt:row[@account = $groupAccount and @exchange = $groupExchange and @contractDescription = $groupContractDescription and boolean(@short)]/@short)" />

		<xsl:variable name="totalValue"
			select="stmtext:formatNumber(sum(../stmt:row[@account = $groupAccount and @exchange=$groupExchange and @contractDescription = $groupContractDescription and boolean(@debitCredit)]/@debitCredit), @currency)" />

		<xsl:variable name="totalMarketValue"
			select="stmtext:formatNumber(sum(../stmt:row[@account = $groupAccount and @exchange=$groupExchange and @contractDescription = $groupContractDescription and boolean(@marketValue)]/@marketValue), @currency)" />

		<tr class="{$trClass}">
			<xsl:if test="$statementType = 'PARENT'">
				<td />
			</xsl:if>
			<td class="ALIGN_RIGHT SUB_TOTAL" colspan="3">Total Quantity
			</td>

			<td class="ALIGN_RIGHT SUB_TOTAL">
				<xsl:if test="$totalLong != 0">
					<xsl:value-of select="stmtext:formatNumber($totalLong, 0)" />
				</xsl:if>
			</td>
			<td class="ALIGN_RIGHT SUB_TOTAL">
				<xsl:if test="$totalShort != 0">
					<xsl:value-of select="stmtext:formatNumber($totalShort, 0)" />
				</xsl:if>
			</td>


			<td class="wrappable CONTRACT_DESCRIPTION SUB_TOTAL" colspan="5">
				<xsl:value-of select="$groupContractDescription" />
			</td>

			<td colspan="2" />

			<td class="ALIGN_RIGHT SUB_TOTAL">
				<xsl:value-of select="$totalMarketValue" />
			</td>

			<td class="CURRENCY">
				<xsl:value-of select="@currency" />
			</td>

			<xsl:choose>
				<xsl:when test="@disc = 'true'">
					<!-- Total will be rendered on next row -->
					<td />
				</xsl:when>
				<xsl:otherwise>
					<td class="ALIGN_RIGHT SUB_TOTAL">
						<xsl:value-of select="$totalValue" />
					</td>
				</xsl:otherwise>
			</xsl:choose>

		</tr>

		<xsl:if test="@disc = 'true'">
			<tr class="{$trClass}">

				<td colspan="9" />

				<td class="ALIGN_RIGHT SUB_TOTAL" colspan="2">Discount Factor
				</td>

				<td class="ALIGN_RIGHT SUB_TOTAL">
					<xsl:value-of select="stmtext:formatNumber(@df, 6)" />
				</td>

				<td class="ALIGN_RIGHT SUB_TOTAL" colspan="2">Discounted Variation
					Margin
				</td>
				<td class="CURRENCY">
					<xsl:value-of select="@currency" />
				</td>
				<td class="ALIGN_RIGHT SUB_TOTAL">
					<xsl:value-of select="$totalValue" />
				</td>
			</tr>
		</xsl:if>

	</xsl:template>

	<xsl:template match="stmt:row" mode="openPositionsRow">
		<xsl:param name="trClass" />

		<tr class="{$trClass}">
			<xsl:if test="$statementType = 'PARENT'">
				<td>
					<xsl:value-of select="@account" />
				</td>
			</xsl:if>
			<td>
				<xsl:value-of select="@id" />
			</td>
			<td>
				<xsl:value-of select="@date" />
			</td>
			<td>
				<xsl:value-of select="@accountType" />
			</td>
			<td class="ALIGN_RIGHT">
				<xsl:value-of select="stmtext:formatNumber(@long, 0)" />
			</td>
			<td class="ALIGN_RIGHT">
				<xsl:value-of select="stmtext:formatNumber(@short, 0)" />
			</td>
			<td class="ALIGN_RIGHT">
				<xsl:value-of select="@productType" />
			</td>
			<td class="SYMBOL">
				<div class="BOXED">
					<xsl:value-of select="@ticker" />
				</div>
			</td>
			<td>
				<xsl:value-of select="@strike" />
			</td>
			<td>
				<xsl:value-of select="@deliveryDate" />
			</td>
			<td>
				<xsl:value-of select="@expirationDate" />
			</td>
			<td>
				<xsl:value-of select="@exchange" />
			</td>
			<td class="ALIGN_RIGHT">
				<xsl:value-of
					select="stmtext:formatNumberWithQuoteType(@price, number(@contractDecimals), @quoteType, $useExtendedFuture32)" />
			</td>
			<td class="ALIGN_RIGHT">
				<xsl:value-of
					select="stmtext:formatNumberWithQuoteType(@close, number(@contractDecimals), @productQuoteType, $useExtendedFuture32)" />
			</td>
			<td class="CURRENCY">
				<xsl:value-of select="@currency" />
			</td>
			<td class="ALIGN_RIGHT">
				<xsl:value-of select="stmtext:formatNumber(@debitCredit, @currency)" />
			</td>
		</tr>
	</xsl:template>

	<!-- DEPOSITS AND WITHDRAWALS SECTION ############################################### -->

	<xsl:template match="stmt:section[@id='depositsAndWithdrawals']">
		<div class="SECTION">

			<xsl:call-template name="sectionTitle">
				<xsl:with-param name="title" select="'Deposits And Withdrawals'" />
			</xsl:call-template>

			<xsl:if test="boolean(stmt:row)">
				<table class="FULL_WIDTH">

					<xsl:call-template name="depositsAndWithdrawalsHeaderRow" />

					<xsl:apply-templates select="stmt:row"
						mode="depositsAndWithdrawalsRow">
						<xsl:sort select="@settlementDate" />
						<xsl:sort select="@cashOrSecurity" order="descending" />
						<xsl:sort select="@currency" />
						<xsl:sort select="@direction" />
						<xsl:sort select="@description" />
					</xsl:apply-templates>
				</table>
			</xsl:if>

			<xsl:call-template name="emptySectionComment">
				<xsl:with-param name="content" select="stmt:row" />
			</xsl:call-template>

		</div>
	</xsl:template>

	<xsl:template name="depositsAndWithdrawalsHeaderRow">
		<tr>
			<th>Settlement Date</th>
			<th>ID</th>
			<th>Origin</th>
			<th>Transaction Type</th>
			<th class="ALIGN_RIGHT">Amount</th>
			<th class="CURRENCY">Ccy</th>
			<th>Description</th>
			<th class="COMMENT_20">Comment</th>
		</tr>
	</xsl:template>

	<xsl:template match="stmt:row" mode="depositsAndWithdrawalsRow">
		<xsl:variable name="trClass">
			<xsl:if test="(position() mod 2) = 0">
				<xsl:value-of select="'EVEN_ROW'" />
			</xsl:if>
		</xsl:variable>

		<tr class="{$trClass}">
			<td>
				<xsl:value-of select="@settlementDate" />
			</td>
			<td>
				<xsl:value-of select="@id" />
			</td>
			<td>
				<xsl:value-of select="@accountType" />
			</td>
			<td>
				<xsl:value-of select="concat(@cashOrSecurity, ' ', @direction)" />
			</td>
			<td class="ALIGN_RIGHT">
				<xsl:choose>
					<xsl:when test="@cashOrSecurity = 'SECURITY'">
						<xsl:value-of select="stmtext:formatNumber(@amount, 0)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="stmtext:formatNumber(@amount, @currency)" />
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td class="CURRENCY">
				<xsl:value-of select="@currency" />
			</td>
			<td class="wrappable">
				<xsl:if test="@description != @currency">
					<xsl:value-of select="@description" />
				</xsl:if>
			</td>
			<td class="wrappable">
				<xsl:value-of select="@comment" />
			</td>
		</tr>
	</xsl:template>


	<!-- SECURITIES ON DEPOSIT SECTION ############################################### -->

	<xsl:key name="securitiesOnDepositKey"
		match="stmt:section[@id='securitiesOnDeposit']/stmt:row" use="@productId" />

	<xsl:template match="stmt:section[@id='securitiesOnDeposit']">
		<div class="SECTION">

			<xsl:call-template name="sectionTitle">
				<xsl:with-param name="title" select="'Securities On Deposit'" />
			</xsl:call-template>

			<xsl:if test="boolean(stmt:row)">
				<table class="FULL_WIDTH">
					<tr>
						<th>Description</th>
						<th>Origin</th>
						<th class="ALIGN_RIGHT">Security Nominal</th>
						<th class="ALIGN_RIGHT">Price</th>
						<th class="ALIGN_RIGHT">Haircut</th>
						<th class="ALIGN_RIGHT">Fair Market Value</th>
						<th class="ALIGN_RIGHT">All-In Value</th>
						<th>Currency</th>
						<th class="ALIGN_RIGHT">FX</th>
						<th class="ALIGN_RIGHT">Base CCY Value</th>
					</tr>

					<xsl:apply-templates
						select="stmt:row[generate-id() = generate-id(key('securitiesOnDepositKey', @productId)[1])]"
						mode="securitiesOnDeposit">
						<xsl:sort select="@description" />
						<xsl:sort select="@securityCurrency" />
						<xsl:sort select="@nominal" />
					</xsl:apply-templates>
				</table>
			</xsl:if>

			<xsl:call-template name="emptySectionComment">
				<xsl:with-param name="content" select="stmt:row" />
			</xsl:call-template>

		</div>
	</xsl:template>

	<xsl:template match="stmt:row" mode="securitiesOnDeposit">
		<xsl:variable name="trClass">
			<xsl:if test="(position() mod 2) = 0">
				<xsl:value-of select="'EVEN_ROW'" />
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="currentProductId" select="@productId" />
		<tr class="{$trClass}">
			<td>
				<xsl:value-of select="@description" />
			</td>
			<td>
				<xsl:value-of select="@accountType" />
			</td>
			<td class="ALIGN_RIGHT">
				<xsl:value-of
					select="stmtext:formatNumber(sum(../stmt:row[@productId = $currentProductId]/@nominal), @securityCurrency)" />
			</td>
			<td class="ALIGN_RIGHT">
				<!-- Preformatted -->
				<xsl:value-of select="@price" />
			</td>
			<td class="ALIGN_RIGHT">
				<!-- Preformatted -->
				<xsl:value-of select="concat(@haircut, '%')" />
			</td>
			<td class="ALIGN_RIGHT">
				<xsl:value-of
					select="stmtext:formatNumber(sum(../stmt:row[@productId = $currentProductId]/@fairMarketValue), @securityCurrency)" />
			</td>
			<td class="ALIGN_RIGHT">
				<xsl:value-of
					select="stmtext:formatNumber(sum(../stmt:row[@productId = $currentProductId]/@allInValue), @securityCurrency)" />
			</td>
			<td>
				<xsl:value-of select="@securityCurrency" />
			</td>
			<td class="ALIGN_RIGHT">
				<xsl:value-of
					select="stmtext:formatFXRate(@fxRate, $statementCurrency, @securityCurrency)" />
			</td>
			<td class="ALIGN_RIGHT">
				<xsl:value-of
					select="stmtext:formatNumber(sum(../stmt:row[@productId = $currentProductId]/@statementCurrencyValue), $statementCurrency)" />
			</td>
		</tr>
	</xsl:template>


	<!-- FINANCIAL SUMMARY SECTION ################################################## -->

	<xsl:key name="financialSummaryKey" match="stmt:section[@id='financialSummary']/stmt:row"
		use="@currency" />
	
	<xsl:key name="financialSummaryRegcodeKey" match="stmt:section[@id='financialSummary']/stmt:row"
		use="@RegCode" />

	<xsl:template name="financialSummaryRow">
		<xsl:param name="title" />
		<xsl:param name="titleClass" />
		<xsl:param name="idToMatch" select="$title" />
		<xsl:param name="trClass" />

		<tr class="{$trClass}">
			<td class="{$titleClass}">
				<xsl:value-of select="$title" />
			</td>
			<xsl:for-each
				select="stmt:row[generate-id() = generate-id(key('financialSummaryKey', @currency)[1])]">
				<xsl:variable name="ccy" select="@currency" />
				<xsl:variable name="regID" select="'Regulatory Code'" />
				<xsl:variable name="openingBalance" select="'Opening Balance'" />
				<xsl:variable name="regReg" select="'SEG'" />
				<xsl:variable name="regSec" select="'30.7 SECURED'" />
				<xsl:variable name="regTotal" select="'Total'" />
				
				<xsl:choose>
					<xsl:when test="$idToMatch = $regID">
						<xsl:if test="not(string-length(stmtext:formatNumber(../stmt:row[@currency=$ccy and @id=$openingBalance and @RegCode=$regReg]/@value, $ccy)) = 0)">
							<td class="ALIGN_RIGHT">
								<xsl:value-of select="$regReg"/>
							</td>
						</xsl:if>
						<xsl:if test="not(string-length(stmtext:formatNumber(../stmt:row[@currency=$ccy and @id=$openingBalance and @RegCode=$regSec]/@value, $ccy)) = 0)">
							<td class="ALIGN_RIGHT">
								<xsl:value-of select="$regSec"/>
							</td>
						</xsl:if>
						<xsl:if test="not(string-length(stmtext:formatNumber(../stmt:row[@currency=$ccy and @id=$openingBalance and @RegCode=$regTotal]/@value, $ccy)) = 0)">
							<td class="ALIGN_RIGHT">
								<xsl:value-of select="$regTotal"/>
							</td>
						</xsl:if>
					</xsl:when>
					
					<xsl:otherwise>
						<xsl:if test="not(string-length(stmtext:formatNumber(../stmt:row[@currency=$ccy and @id=$openingBalance and @RegCode=$regReg]/@value, $ccy)) = 0)">
							<td class="ALIGN_RIGHT">
								<xsl:value-of
									select="stmtext:formatNumber(../stmt:row[@currency=$ccy and @id=$idToMatch and @RegCode=$regReg]/@value, $ccy)" />
							</td>
						</xsl:if>
						<xsl:if test="not(string-length(stmtext:formatNumber(../stmt:row[@currency=$ccy and @id=$openingBalance and @RegCode=$regSec]/@value, $ccy)) = 0)">
							<td class="ALIGN_RIGHT">
								<xsl:value-of
									select="stmtext:formatNumber(../stmt:row[@currency=$ccy and @id=$idToMatch and @RegCode=$regSec]/@value, $ccy)" />
							</td>
						</xsl:if>
						<xsl:if test="not(string-length(stmtext:formatNumber(../stmt:row[@currency=$ccy and @id=$openingBalance and @RegCode=$regTotal]/@value, $ccy)) = 0)">
							<td class="ALIGN_RIGHT">
								<xsl:value-of
									select="stmtext:formatNumber(../stmt:row[@currency=$ccy and @id=$idToMatch and @RegCode=$regTotal]/@value, $ccy)" />
							</td>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</tr>
	</xsl:template>

	<xsl:template name="financialSummarySeparatorRow">
		<tr>
			<td>&#160;</td>
		</tr>
	</xsl:template>

	<xsl:template match="stmt:section[@id='financialSummary']">

		<xsl:variable name="isOTE"
			select="boolean(//stmt:section[@id = 'metadata']/@marginMode = 'OTE')" />
		<xsl:variable name="isRealized"
			select="boolean(//stmt:section[@id = 'metadata']/@marginMode = 'RealizedVM')" />
		<xsl:variable name="regseg" select="'SEG'"/>
		<xsl:variable name="regsec" select="'30.7 SECURED'"/>
		<xsl:variable name="regtotal" select="'Total'"/>
		<xsl:variable name="openingBalance" select="'Opening Balance'" />

		<div class="SECTION">

			<xsl:call-template name="sectionTitle">
				<xsl:with-param name="title" select="'Financial Summary'" />
			</xsl:call-template>

			<div style="height: 1em;" />

			<table class="FINANCIAL_SUMMARY">
				<tr>
					<th class="FINANCIAL_SUMMARY" />
						<xsl:for-each
							select="stmt:row[generate-id() = generate-id(key('financialSummaryKey', @currency)[1])]">
							<xsl:variable name="ccy" select="@currency" />
							<xsl:if test="not(string-length(stmtext:formatNumber(../stmt:row[@currency=$ccy and @id=$openingBalance and @RegCode=$regseg]/@value, $ccy)) = 0)">
								<th class="ALIGN_RIGHT FINANCIAL_SUMMARY">
									<xsl:value-of select="$ccy" />
								</th>
							</xsl:if>
							
							<xsl:if test="not(string-length(stmtext:formatNumber(../stmt:row[@currency=$ccy and @id=$openingBalance and @RegCode=$regsec]/@value, $ccy)) = 0)">
								<th class="ALIGN_RIGHT FINANCIAL_SUMMARY">
									<xsl:value-of select="$ccy" />
								</th>
							</xsl:if>
							
							<xsl:if test="not(string-length(stmtext:formatNumber(../stmt:row[@currency=$ccy and @id=$openingBalance and @RegCode=$regtotal]/@value, $ccy)) = 0)">
								<th class="ALIGN_RIGHT FINANCIAL_SUMMARY">
									<xsl:value-of select="$ccy" />
								</th>
							</xsl:if>
					</xsl:for-each>
				</tr>
				
				<xsl:call-template name="financialSummaryRow">
					<xsl:with-param name="title" select="'Regulatory Code'" />
					<xsl:with-param name="trClass" select="'EVEN_ROW_SUBTOTAL'" />
				</xsl:call-template>
				
				<xsl:call-template name="financialSummaryRow">
					<xsl:with-param name="title" select="'Opening Balance'" />
					<xsl:with-param name="trClass" select="'EVEN_ROW_SUBTOTAL'" />
				</xsl:call-template>

				<xsl:call-template name="financialSummaryRow">
					<xsl:with-param name="title" select="'Commissions'" />
					<xsl:with-param name="titleClass" select="'ALIGN_LEFT'" />
				</xsl:call-template>

				<xsl:call-template name="financialSummaryRow">
					<xsl:with-param name="title" select="'Exchange Fees'" />
					<xsl:with-param name="titleClass" select="'ALIGN_LEFT'" />
					<xsl:with-param name="trClass" select="'EVEN_ROW_FINSUM'" />
				</xsl:call-template>

				<xsl:choose>
					<xsl:when test="stmt:row[@id='Brokerage' and @value!='0'] and stmt:row[@id='NFA']">
						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title" select="'Brokerage'" />
							<xsl:with-param name="titleClass" select="'ALIGN_LEFT'" />
						</xsl:call-template>

						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title" select="'NFA'" />
							<xsl:with-param name="titleClass" select="'ALIGN_LEFT'" />
							<xsl:with-param name="trClass" select="'EVEN_ROW_FINSUM'" />
						</xsl:call-template>

						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title" select="'Realized PL'" />
							<xsl:with-param name="titleClass" select="'ALIGN_LEFT'" />
						</xsl:call-template>

						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title" select="'Premium'" />
							<xsl:with-param name="titleClass" select="'ALIGN_LEFT'" />
							<xsl:with-param name="trClass" select="'EVEN_ROW_FINSUM'" />
						</xsl:call-template>

						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title" select="'Option Cash Settlement'" />
							<xsl:with-param name="titleClass" select="'ALIGN_LEFT'" />
						</xsl:call-template>

						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title" select="'Cash Movements'" />
							<xsl:with-param name="titleClass" select="'ALIGN_LEFT'" />
							<xsl:with-param name="trClass" select="'EVEN_ROW_FINSUM'" />
						</xsl:call-template>

						<xsl:if test="$isRealized">
							<xsl:call-template name="financialSummaryRow"> 
								<xsl:with-param  name="idToMatch" select="'Variation Margin'" /> 
								<xsl:with-param name="title"  select="'Variation Margin'" /> 
								<xsl:with-param name="titleClass" select="'ALIGN_LEFT'" />
							</xsl:call-template >

							<xsl:if test="$hasDiscountedPositions">
								<xsl:call-template name="financialSummaryRow">
									<xsl:with-param name="idToMatch"
										select="'Variation Margin Change (Discounted)'" />
									<xsl:with-param name="title" select="'Discounted VM Change'" />
									<xsl:with-param name="titleClass" select="'ALIGN_LEFT'" />
									<xsl:with-param name="trClass" select="'EVEN_ROW_FINSUM'" />
								</xsl:call-template>
							</xsl:if>
						</xsl:if>

						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title" select="'Closing Balance'" />
							<xsl:with-param name="trClass" select="'EVEN_ROW_SUBTOTAL'" />
						</xsl:call-template>
					</xsl:when>

					<xsl:when test="stmt:row[@id='Brokerage' and @value!=0]">
						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title" select="'Brokerage'" />
							<xsl:with-param name="titleClass" select="'ALIGN_LEFT'" />
						</xsl:call-template>

						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title" select="'Realized PL'" />
							<xsl:with-param name="titleClass" select="'ALIGN_LEFT'" />
							<xsl:with-param name="trClass" select="'EVEN_ROW_FINSUM'" />
						</xsl:call-template>

						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title" select="'Premium'" />
							<xsl:with-param name="titleClass" select="'ALIGN_LEFT'" />
						</xsl:call-template>

						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title" select="'Option Cash Settlement'" />
							<xsl:with-param name="titleClass" select="'ALIGN_LEFT'" />
							<xsl:with-param name="trClass" select="'EVEN_ROW_FINSUM'" />
						</xsl:call-template>

						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title" select="'Cash Movements'" />
							<xsl:with-param name="titleClass" select="'ALIGN_LEFT'" />
						</xsl:call-template>

						<xsl:if test="$isRealized">
							<xsl:call-template name="financialSummaryRow"> 
								<xsl:with-param  name="idToMatch" select="'Variation Margin'" /> 
								<xsl:with-param name="title"  select="'Variation Margin'" /> 
								<xsl:with-param name="titleClass" select="'ALIGN_LEFT'" />
								<xsl:with-param name="trClass" select="'EVEN_ROW_FINSUM'" />
							</xsl:call-template>
							<xsl:if test="$hasDiscountedPositions">
								<xsl:call-template name="financialSummaryRow">
									<xsl:with-param name="idToMatch"
										select="'Variation Margin Change (Discounted)'" />
									<xsl:with-param name="title" select="'Discounted VM Change'" />
									<xsl:with-param name="titleClass" select="'ALIGN_LEFT'" />
								</xsl:call-template>
							</xsl:if>
						</xsl:if>

						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title" select="'Closing Balance'" />
							<xsl:with-param name="trClass" select="'EVEN_ROW_SUBTOTAL'" />
						</xsl:call-template>
					</xsl:when>
					
					<xsl:when test="stmt:row[@id='NFA']">
						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title" select="'NFA'" />
							<xsl:with-param name="titleClass" select="'ALIGN_LEFT'" />
						</xsl:call-template>

						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title" select="'Realized PL'" />
							<xsl:with-param name="titleClass" select="'ALIGN_LEFT'" />
							<xsl:with-param name="trClass" select="'EVEN_ROW_FINSUM'" />
						</xsl:call-template>

						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title" select="'Premium'" />
							<xsl:with-param name="titleClass" select="'ALIGN_LEFT'" />
						</xsl:call-template>

						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title" select="'Option Cash Settlement'" />
							<xsl:with-param name="titleClass" select="'ALIGN_LEFT'" />
							<xsl:with-param name="trClass" select="'EVEN_ROW_FINSUM'" />
						</xsl:call-template>

						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title" select="'Cash Movements'" />
							<xsl:with-param name="titleClass" select="'ALIGN_LEFT'" />
						</xsl:call-template>

						<xsl:if test="$isRealized">
							<xsl:call-template name="financialSummaryRow"> 
								<xsl:with-param  name="idToMatch" select="'Variation Margin'" /> 
								<xsl:with-param name="title"  select="'Variation Margin'" /> 
								<xsl:with-param name="titleClass" select="'ALIGN_LEFT'" />
								<xsl:with-param name="trClass" select="'EVEN_ROW_FINSUM'" />
							</xsl:call-template >
							<xsl:if test="$hasDiscountedPositions">
								<xsl:call-template name="financialSummaryRow">
									<xsl:with-param name="idToMatch"
										select="'Variation Margin Change (Discounted)'" />
									<xsl:with-param name="title" select="'Discounted VM Change'" />
									<xsl:with-param name="titleClass" select="'ALIGN_LEFT'" />
								</xsl:call-template>
							</xsl:if>
						</xsl:if>

						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title" select="'Closing Balance'" />
							<xsl:with-param name="trClass" select="'EVEN_ROW_SUBTOTAL'" />
						</xsl:call-template>
					</xsl:when>
					
					<xsl:otherwise>
						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title" select="'Realized PL'" />
							<xsl:with-param name="titleClass" select="'ALIGN_LEFT'" />
						</xsl:call-template>

						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title" select="'Premium'" />
							<xsl:with-param name="titleClass" select="'ALIGN_LEFT'" />
							<xsl:with-param name="trClass" select="'EVEN_ROW_FINSUM'" />
						</xsl:call-template>

						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title" select="'Option Cash Settlement'" />
							<xsl:with-param name="titleClass" select="'ALIGN_LEFT'" />
						</xsl:call-template>

						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title" select="'Cash Movements'" />
							<xsl:with-param name="titleClass" select="'ALIGN_LEFT'" />
							<xsl:with-param name="trClass" select="'EVEN_ROW_FINSUM'" />
						</xsl:call-template>

						<xsl:if test="$isRealized">
							<xsl:call-template name="financialSummaryRow"> 
								<xsl:with-param name="idToMatch" select="'Variation Margin'" /> 
								<xsl:with-param name="title" select="'Variation Margin'" /> 
								<xsl:with-param name="titleClass" select="'ALIGN_LEFT'" />
							</xsl:call-template>

							<xsl:if test="$hasDiscountedPositions">
								<xsl:call-template name="financialSummaryRow">
									<xsl:with-param name="idToMatch"
										select="'Variation Margin Change (Discounted)'" />
									<xsl:with-param name="title" select="'Discounted VM Change'" />
									<xsl:with-param name="titleClass" select="'ALIGN_LEFT'" />
									<xsl:with-param name="trClass" select="'EVEN_ROW_FINSUM'" />
								</xsl:call-template>
							</xsl:if>
						</xsl:if>

						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title" select="'Closing Balance'" />
							<xsl:with-param name="trClass" select="'EVEN_ROW_SUBTOTAL'" />
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>


				<!-- xsl:call-template name="financialSummarySeparatorRow" / -->

				<xsl:if test="$isOTE">
					<xsl:call-template name="financialSummaryRow">
						<xsl:with-param name="title" select="'Open Trade Equity'" />
						<xsl:with-param name="idToMatch" select="'Open Trade Equity'" />
						<xsl:with-param name="trClass">
							<xsl:if test="not($hasDiscountedPositions)">
								<xsl:value-of select="'EVEN_ROW_FINSUM'" />
							</xsl:if>
						</xsl:with-param>
					</xsl:call-template>

					<xsl:if test="$hasDiscountedPositions">
						<xsl:call-template name="financialSummaryRow">
							<xsl:with-param name="title"
								select="'Discounted Variation Margin (OTE)'" />
							<xsl:with-param name="idToMatch"
								select="'Open Trade Equity (Discounted)'" />
							<xsl:with-param name="trClass" select="'EVEN_ROW_FINSUM'" />
						</xsl:call-template>
					</xsl:if>
				</xsl:if>

				<!-- xsl:if test="$isRealized"> <xsl:call-template name="financialSummaryRow"> 
					<xsl:with-param name="idToMatch" select="'Variation Margin Balance'" /> <xsl:with-param 
					name="title" select="'Open Trade Equity'" /> <xsl:with-param name="trClass"> 
					<xsl:if test="not($hasDiscountedPositions)"> <xsl:value-of select="'EVEN_ROW_FINSUM'" 
					/> </xsl:if> </xsl:with-param> </xsl:call-template> <xsl:if test="$hasDiscountedPositions"> 
					<xsl:call-template name="financialSummaryRow"> <xsl:with-param name="title" 
					select="'Discounted Variation Margin (OTE)'" /> <xsl:with-param name="idToMatch" 
					select="'Open Trade Equity (Discounted)'" /> <xsl:with-param name="trClass" 
					select="'EVEN_ROW_FINSUM'" /> </xsl:call-template> </xsl:if> </xsl:if> -->

				<xsl:call-template name="financialSummaryRow">
					<xsl:with-param name="title" select="'Net Option Value'" />
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
					<xsl:with-param name="trClass" select="'EVEN_ROW_SUBTOTAL'" />
				</xsl:call-template>

				<!-- xsl:call-template name="financialSummarySeparatorRow" / -->

				<xsl:call-template name="financialSummaryRow">
					<xsl:with-param name="title" select="'Securities on Deposit'" />
				</xsl:call-template>

				<xsl:call-template name="financialSummaryRow">
					<xsl:with-param name="title" select="'Margin Equity'" />
					<xsl:with-param name="trClass" select="'EVEN_ROW_FINSUM'" />
				</xsl:call-template>

				<xsl:call-template name="financialSummaryMarginSubsection">
					<xsl:with-param name="isRealized" select="$isRealized" />
					<xsl:with-param name="isOTE" select="$isOTE" />
				</xsl:call-template>


				<!-- xsl:call-template name="financialSummarySeparatorRow" / -->
					<xsl:choose>
						<xsl:when test="$isOTE">
						<tr class="EVEN_ROW_FINSUM">
							<td>
								FX Conversion to
								<xsl:value-of select="$statementCurrency" />
							</td>
							<!-- Don't pick the base currency column, which is not an actual currency 
								name -->
							<xsl:for-each
								select="stmt:row[not(string-length(@currency) > 3) and generate-id() = generate-id(key('financialSummaryKey', @currency)[1])]">
								<xsl:variable name="ccy" select="@currency" />
								<xsl:variable name="openingBalance" select="'Opening Balance'" />
								<xsl:variable name="regReg" select="'SEG'" />
								<xsl:variable name="regSec" select="'30.7 SECURED'" />
								<xsl:if test="not(string-length(stmtext:formatNumber(../stmt:row[@currency=$ccy and @id=$openingBalance and @RegCode=$regReg]/@value, $ccy)) = 0)">
									<td class="ALIGN_RIGHT">
										<xsl:value-of
											select="stmtext:formatFXRate(../stmt:row[@currency=$ccy and @id='FX Rate' and @RegCode=$regReg]/@value, $statementCurrency, $ccy)" />
									</td>
								</xsl:if>
								<xsl:if test="not(string-length(stmtext:formatNumber(../stmt:row[@currency=$ccy and @id=$openingBalance and @RegCode=$regSec]/@value, $ccy)) = 0)">
									<td class="ALIGN_RIGHT">
										<xsl:value-of
											select="stmtext:formatFXRate(../stmt:row[@currency=$ccy and @id='FX Rate' and @RegCode=$regSec]/@value, $statementCurrency, $ccy)" />
									</td>
								</xsl:if>
							</xsl:for-each>
							<td> </td>
						</tr>
						</xsl:when>
						<xsl:otherwise>
							<tr>
								<td>
									FX Conversion to
									<xsl:value-of select="$statementCurrency" />
								</td>
								<!-- Don't pick the base currency column, which is not an actual currency 
									name -->
								<xsl:for-each
									select="stmt:row[not(string-length(@currency) > 3) and generate-id() = generate-id(key('financialSummaryKey', @currency)[1])]">
									<xsl:variable name="ccy" select="@currency" />
									<xsl:variable name="openingBalance" select="'Opening Balance'" />
									<xsl:variable name="regReg" select="'SEG'" />
									<xsl:variable name="regSec" select="'30.7 SECURED'" />
									<xsl:if test="not(string-length(stmtext:formatNumber(../stmt:row[@currency=$ccy and @id=$openingBalance and @RegCode=$regReg]/@value, $ccy)) = 0)">
										<td class="ALIGN_RIGHT">
											<xsl:value-of
												select="stmtext:formatFXRate(../stmt:row[@currency=$ccy and @id='FX Rate' and @RegCode=$regReg]/@value, $statementCurrency, $ccy)" />
										</td>
									</xsl:if>
									<xsl:if test="not(string-length(stmtext:formatNumber(../stmt:row[@currency=$ccy and @id=$openingBalance and @RegCode=$regSec]/@value, $ccy)) = 0)">
										<td class="ALIGN_RIGHT">
											<xsl:value-of
												select="stmtext:formatFXRate(../stmt:row[@currency=$ccy and @id='FX Rate' and @RegCode=$regSec]/@value, $statementCurrency, $ccy)" />
										</td>
									</xsl:if>
								</xsl:for-each>
								<td> </td>
							</tr>
						</xsl:otherwise>
					</xsl:choose>
				
				<xsl:call-template name="financialSummaryRow">
					<xsl:with-param name="title"
						select="'Converted Net Liquidating Value'" />
					<xsl:with-param name="trClass" select="'EVEN_ROW_SUBTOTAL'" />
				</xsl:call-template>

			</table>
		</div>
		<br />
	</xsl:template>

	<xsl:template name="financialSummaryMarginSubsection">
		<xsl:param name="isRealized" />
		<xsl:param name="isOTE" />



		<xsl:call-template name="financialSummaryRow">
			<xsl:with-param name="idToMatch" select="'Total Margin Requirement'" />
			<xsl:with-param name="title" select="'Initial Margin'" />
		</xsl:call-template>

		<xsl:call-template name="financialSummaryRow">
			<xsl:with-param name="idToMatch" select="'Maintenance Margin'" />
			<xsl:with-param name="title" select="'Maintenance Margin'" />
			<xsl:with-param name="trClass" select="'EVEN_ROW_FINSUM'" />
		</xsl:call-template>

		<xsl:if test="$isRealized">
			<xsl:call-template name="financialSummaryRow">
				<xsl:with-param name="idToMatch" select="'Variation Margin Balance'" />
				<xsl:with-param name="title" select="'Open Trade Equity'" />

			</xsl:call-template>

			<xsl:if test="$hasDiscountedPositions">
				<xsl:call-template name="financialSummaryRow">
					<xsl:with-param name="title"
						select="'Discounted Variation Margin (OTE)'" />
					<xsl:with-param name="idToMatch"
						select="'Variation Margin (Discounted)'" />
					<xsl:with-param name="trClass" select="'EVEN_ROW_FINSUM'" />
				</xsl:call-template>
			</xsl:if>

		</xsl:if>

		<xsl:if test="$isOTE">
			<!--xsl:call-template name="financialSummaryRow"> <xsl:with-param name="idToMatch" 
				select="'Open Trade Equity Change'" /> <xsl:with-param name="title" select="'Variation 
				Margin Change'" /> <xsl:with-param name="trClass" select="'EVEN_ROW_FINSUM'" 
				/> </xsl:call-template -->

			<xsl:if test="$hasDiscountedPositions">
				<xsl:call-template name="financialSummaryRow">
					<xsl:with-param name="idToMatch"
						select="'Open Trade Equity Change (Discounted)'" />
					<xsl:with-param name="title" select="'Discounted VM Change'" />
					<xsl:with-param name="trClass" select="'EVEN_ROW_FINSUM'" />
				</xsl:call-template>
			</xsl:if>
		</xsl:if>

		<xsl:call-template name="financialSummaryRow">
			<xsl:with-param name="title" select="'Margin Excess/Deficit'" />
			<xsl:with-param name="trClass">
				<xsl:if test="$isRealized">
					<xsl:value-of select="'EVEN_ROW_FINSUM'" />
				</xsl:if>
			</xsl:with-param>
		</xsl:call-template>

	</xsl:template>

</xsl:stylesheet>
