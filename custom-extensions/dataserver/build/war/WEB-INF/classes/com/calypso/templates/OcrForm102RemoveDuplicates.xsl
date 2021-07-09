<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:ltr="urn:com:calypso:clearing:cftc:ltr" xmlns:cftcForm102="urn:com:calypso:clearing:cftc:ocr" xmlns:cftc="urn:com:calypso:clearing:cftc" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xalan="http://xml.apache.org/xalan">

	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:strip-space elements="*"/>
 	<xsl:key name="RelatedAccountInfo" match="relatedAcctInfo" use="concat(@accountShortCode, '|', @marketIdentifier)" />
 	
	<xsl:template match="@*|node()">
	<xsl:copy>
    	 <xsl:apply-templates select="@*|node()" />
	</xsl:copy>

	</xsl:template>
	<xsl:template match="relatedAcctInfo[generate-id() != generate-id( key('RelatedAccountInfo', concat(@accountShortCode, '|', @marketIdentifier) )[1])]"/>  
</xsl:stylesheet>