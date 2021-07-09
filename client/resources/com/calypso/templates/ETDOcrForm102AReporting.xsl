<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:ltr="urn:com:calypso:clearing:cftc:ltr" xmlns:cftcForm102="urn:com:calypso:clearing:cftc:ocr" xmlns:cftc="urn:com:calypso:clearing:cftc" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xalan="http://xml.apache.org/xalan">
	<xsl:key name="cftcAccountNumberKey" match="/ltr:LTReport/ltr:account" use="@cftcAccountNumber" />
	<xsl:key name="accountNameKey" match="/ltr:LTReport/ltr:account/ltr:product/ltr:subAccount/ltr:position/ltr:positionDetail" use="@calypsoAccountName"/>

	<xsl:template match="/ltr:LTReport">
		<cftcBatch>
			<cftcHeader>
				<xsl:attribute name="sentDate"><xsl:value-of select="@creationDateTime"/></xsl:attribute>
				<xsl:attribute name="email"><xsl:value-of select="cftc:reportingFirm/@email"/></xsl:attribute>
				<xsl:attribute name="sentBy"><xsl:value-of select="cftc:reportingFirm/@cftcId"/></xsl:attribute>
			</cftcHeader>
			
			<xsl:for-each select="/ltr:LTReport/ltr:account[generate-id() = generate-id(key('cftcAccountNumberKey',@cftcAccountNumber)[1])]">
				<xsl:variable name="cftcAccount" select="@cftcAccountNumber" />
				<xsl:call-template name="buildCftcForm102A">
					<xsl:with-param name="cftcAccount" select="$cftcAccount" />
				</xsl:call-template> 
			</xsl:for-each>
		</cftcBatch>
	</xsl:template>
	
	<xsl:template name="buildCftcForm102A">
		<xsl:param name="cftcAccount"/>
			<xsl:if test="/ltr:LTReport/ltr:account[@cftcAccountNumber=$cftcAccount]/@ocrBreached = 'true'">
				<cftcForm102>
					<xsl:attribute name="accountCategory"><xsl:value-of select="/ltr:LTReport/ltr:account/cftcForm102:accountDetails/@accountCategory"/></xsl:attribute>
					<xsl:attribute name="accountNumber"><xsl:value-of select="$cftcAccount"/></xsl:attribute>
					<xsl:attribute name="accountClass"><xsl:value-of select="/ltr:LTReport/ltr:account/cftcForm102:accountDetails/@accountClass"/></xsl:attribute>
	
					<xsl:for-each select="/ltr:LTReport/ltr:account[@cftcAccountNumber=$cftcAccount]">
						<xsl:variable name="accountNode" select="." />
						<xsl:call-template name="buildRelatedAccount">
							<xsl:with-param name="accountNode" select="$accountNode" />
						</xsl:call-template> 
					</xsl:for-each> 
				</cftcForm102>
			</xsl:if>
	</xsl:template>

	<xsl:template name="buildRelatedAccount">
		<xsl:param name="accountNode"/>
		<xsl:for-each select="$accountNode/ltr:product/ltr:subAccount/ltr:position/ltr:positionDetail[generate-id() = generate-id(key('accountNameKey',@calypsoAccountName)[1])]">
			<xsl:variable name="positionNode" select="." />
			<xsl:call-template name="buildRelatedAcc">
				<xsl:with-param name="accountNode" select="$accountNode" />
				<xsl:with-param name="accountName" select="$positionNode/@calypsoAccountName"/>
			</xsl:call-template> 
		</xsl:for-each> 
	</xsl:template>

	<xsl:template name="buildRelatedAcc">
		<xsl:param name="accountNode"/>
		<xsl:param name="accountName"/>
		<relatedAccount>
			<xsl:attribute name="accountNumber"><xsl:value-of select="@calypsoAccountName"/></xsl:attribute>
			<xsl:attribute name="isTradingAccount">Y</xsl:attribute>

			<xsl:for-each select="/ltr:LTReport/ltr:account/ltr:product/ltr:subAccount/ltr:position/ltr:positionDetail[@calypsoAccountName=$accountName]">
				<xsl:variable name="positionNode" select="." />

				<xsl:call-template name="buildRelatedAccountInfo">
					<xsl:with-param name="positionNode" select="." />
				</xsl:call-template> 
			</xsl:for-each> 
		</relatedAccount>
	</xsl:template>
	
	<xsl:template name="buildRelatedAccountInfo">
		<xsl:param name="positionNode"/>
		<relatedAcctInfo>
			<xsl:attribute name="accountShortCode"><xsl:value-of select="$positionNode/@calypsoAccountName"/></xsl:attribute>
			<xsl:attribute name="marketIdentifier"><xsl:value-of select="$positionNode/../../../ltr:exchange/@calypsoShortName"/></xsl:attribute>
		</relatedAcctInfo>
	</xsl:template>

</xsl:stylesheet>
