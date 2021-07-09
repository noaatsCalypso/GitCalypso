<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:stmt="urn:com:calypso:clearing:statement:etd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">

	<xsl:import href="classpath:com/calypso/templates/ClearingCondensedETDStatement.xsl" />
	<xsl:import
		href="classpath:com/calypso/templates/CommonClearingETDStatement.xsl" />

	<xsl:template match="/stmt:ClearingStatement">
		<html>
			<head>
				<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
				<title>Clearing Trade Statement</title>
				<xsl:call-template name="statementStyle" />
			</head>
			<body>
				<div class="SECTION">
					<xsl:call-template name="logo" />
					<br />
					<table class="FULL_WIDTH">
						<tr>
							<td class="NO_PADDING">
								Account:
								<xsl:value-of select="stmt:section[@id='metadata']/@accountName" />
							</td>
							<td class="NO_PADDING ALIGN_RIGHT">
								<xsl:value-of select="stmt:section[@id='metadata']/@receiver" />
							</td>
						</tr>
						<tr>
							<td class="NO_PADDING">
								Trade Id:
								<xsl:value-of select="stmt:section[@id='metadata']/@tradeId" />
							</td>
							<td class="NO_PADDING ALIGN_RIGHT">
								<xsl:value-of select="stmt:section[@id='metadata']/@receiverAddress" />
							</td>
						</tr>
						<tr>
							<td class="NO_PADDING">
								Message Id:
								<xsl:value-of select="stmt:section[@id='metadata']/@messageId" />
							</td>
							<td class="NO_PADDING ALIGN_RIGHT">
								<xsl:if test="stmt:section[@id='metadata']/receiverCity">
									<xsl:value-of
										select="concat(stmt:section[@id='metadata']/@receiverCity, ',')" />
								</xsl:if>
								<xsl:value-of
									select="concat(' ', stmt:section[@id='metadata']/@receiverState)" />
								<xsl:value-of
									select="concat(' ', stmt:section[@id='metadata']/@receiverZip)" />
							</td>
						</tr>

						<tr>
							<td class="NO_PADDING">
								Last Update:
								<xsl:value-of
									select="stmt:section[@id='metadata']/@tradeUpdateDatetime" />
							</td>
							<td class="NO_PADDING ALIGN_RIGHT" />
						</tr>
						<tr>
							<td class="NO_PADDING">
								Trade Status:
								<xsl:value-of select="stmt:section[@id='metadata']/@tradeStatus" />
							</td>
							<td class="NO_PADDING ALIGN_RIGHT" />
						</tr>
						<xsl:if test="boolean(stmt:section[@id='metadata']/@messageFunction)">
							<tr>
								<td class="NO_PADDING">
									Message Function:
									<xsl:value-of select="stmt:section[@id='metadata']/@messageFunction" />
								</td>
								<td class="NO_PADDING ALIGN_RIGHT" />
							</tr>
						</xsl:if>
						<xsl:if test="boolean(stmt:section[@id='metadata']/@relatedMessageId)">
							<tr>
								<td class="NO_PADDING">
									Related Message Id:
									<xsl:value-of select="stmt:section[@id='metadata']/@relatedMessageId" />
								</td>
								<td class="NO_PADDING ALIGN_RIGHT" />
							</tr>
						</xsl:if>
					</table>
				</div>
				<p />
				<xsl:apply-templates select="stmt:section" />
				<xsl:call-template name="footer" />
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>