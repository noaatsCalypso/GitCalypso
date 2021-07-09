<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:stmt="urn:com:calypso:clearing:statement:etd"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:stmtext="xalan://com.calypso.tk.bo.StatementDataTypeFormatter"
	version="1.0" extension-element-prefixes="stmtext"
	exclude-result-prefixes="xs stmtext">


  <xsl:import href="classpath:com/calypso/templates/ClearingCondensedETDStatement.xsl" />
  <xsl:import href="classpath:com/calypso/templates/CommonClearingETDStatement.xsl" />

	<xsl:variable name="isDailyFrequency"
			select="boolean(//stmt:section[@id = 'metadata']/@statementFrequency = 'DAILY')" />
			
  <xsl:template match="/stmt:ClearingStatement">
    <html>
      <head>
        <meta
          http-equiv="Content-Type"
          content="text/html;charset=utf-8" />
        <title>Clearing Statement</title>
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
                Statement Date:
                <xsl:value-of select="stmt:section[@id='metadata']/@statementDate" />
              </td>
              <td class="NO_PADDING ALIGN_RIGHT">
                <xsl:value-of select="stmt:section[@id='metadata']/@receiverAddress" />
              </td>
            </tr>
            <tr>
              <td class="NO_PADDING">
                Previous Statement:
                <xsl:value-of select="stmt:section[@id='metadata']/@lastStatementDate" />
              </td>
              <td class="NO_PADDING ALIGN_RIGHT">
                <xsl:if test="stmt:section[@id='metadata']/receiverCity">
                  <xsl:value-of select="concat(stmt:section[@id='metadata']/@receiverCity, ',')" />
                </xsl:if>
                <xsl:value-of select="concat(' ', stmt:section[@id='metadata']/@receiverState)" />
                <xsl:value-of select="concat(' ', stmt:section[@id='metadata']/@receiverZip)" />
              </td>
            </tr>
          </table>
        </div>
        <p />
		
	        <xsl:choose>
	      		<xsl:when test="$isDailyFrequency">
	      		</xsl:when>
	      		<xsl:otherwise>
		      		<xsl:variable name="startDate"
					select="//stmt:section[@id = 'metadata']/@statementStartDate" />
					<xsl:variable name="endDate"
					select="//stmt:section[@id = 'metadata']/@statementEndDate" />
		      		<p style="color:#2E4053;text-align:center;font-size:110%;">
		      			<u>Monthly Statement</u>
		      		</p>
					<p style="color:#1A5276;text-align:center;font-size:75%;">
						From  <xsl:value-of select="$startDate"/> To  <xsl:value-of select="$endDate"/>
					</p>
		      	</xsl:otherwise>
	      	</xsl:choose>
        		        
        <xsl:apply-templates select="stmt:section" />
        <xsl:call-template name="footer" />
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>