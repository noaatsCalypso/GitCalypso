<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  version="1.0"
  xmlns:stmt="urn:com:calypso:clearing:statement:etd"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:stmtext="xalan://com.calypso.tk.bo.StatementDataTypeFormatter"
  extension-element-prefixes="stmtext"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  exclude-result-prefixes="xs fo stmtext">

	<xsl:variable name="isDailyFrequency"
			select="boolean(//stmt:section[@id = 'metadata']/@statementFrequency = 'DAILY')" />


  <!-- METADATA/ACCOUNT INFO SECTION -->
  <xsl:attribute-set name="metadata-section-table-style">
    <xsl:attribute name="font-size">small</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="metadata-section-header-cell-style">
    <xsl:attribute name="font-weight">bold</xsl:attribute>
  </xsl:attribute-set>

  <xsl:template match="stmt:section[@id='metadata']">
    <fo:block xsl:use-attribute-sets="section-block-style">

      <xsl:call-template name="sectionTitle">
        <xsl:with-param
          name="title"
          select="'Account'" />
      </xsl:call-template>

      <fo:table xsl:use-attribute-sets="metadata-section-table-style debug-table-format-style">

        <fo:table-column column-width="15%" />
        <fo:table-column />
        <fo:table-column xsl:use-attribute-sets="right-align-table-cell-style" />

        <fo:table-body>

          <xsl:call-template name="accountStatementAccountSectionRow">
            <!-- Account name row -->
            <xsl:with-param
              name="title"
              select="'Account'" />
            <xsl:with-param
              name="value"
              select="@accountName" />
            <xsl:with-param name="addressValue">
              <xsl:call-template name="leReceiverName" />
            </xsl:with-param>
          </xsl:call-template>

          <xsl:choose>
            <xsl:when test="boolean(@tradeId) and string(number(@tradeId)) != 'NaN'">

              <!-- Trade statement -->

              <xsl:call-template name="accountStatementAccountSectionRow">
                <xsl:with-param
                  name="title"
                  select="'Trade Id'" />
                <xsl:with-param
                  name="value"
                  select="@tradeId" />
                <xsl:with-param
                  name="addressValue"
                  select="@receiverAddress" />
              </xsl:call-template>

              <xsl:call-template name="accountStatementAccountSectionRow">
                <xsl:with-param
                  name="title"
                  select="'Message Id'" />
                <xsl:with-param
                  name="value"
                  select="@messageId" />
                <xsl:with-param name="addressValue">
                  <xsl:call-template name="composeReceiverLocation" />
                </xsl:with-param>
              </xsl:call-template>

              <xsl:call-template name="accountStatementAccountSectionRow">
                <xsl:with-param
                  name="title"
                  select="'Last Update'" />
                <xsl:with-param
                  name="value"
                  select="@tradeUpdateDatetime" />
              </xsl:call-template>

              <xsl:call-template name="accountStatementAccountSectionRow">
                <xsl:with-param
                  name="title"
                  select="'Trade Status'" />
                <xsl:with-param
                  name="value"
                  select="@tradeStatus" />
              </xsl:call-template>


              <xsl:if test="boolean(@messageFunction)">
                <xsl:call-template name="accountStatementAccountSectionRow">
                  <xsl:with-param
                    name="title"
                    select="'Message Function'" />
                  <xsl:with-param
                    name="value"
                    select="@messageFunction" />
                </xsl:call-template>
              </xsl:if>

              <xsl:if test="boolean(@relatedMessageId)">
                <xsl:call-template name="accountStatementAccountSectionRow">
                  <xsl:with-param
                    name="title"
                    select="'Related Message Id'" />
                  <xsl:with-param
                    name="value"
                    select="@relatedMessageId" />
                </xsl:call-template>
              </xsl:if>

            </xsl:when>
            <xsl:otherwise>

              <!-- Account statement -->

              <xsl:call-template name="accountStatementAccountSectionRow">
                <xsl:with-param
                  name="title"
                  select="'Statement Date'" />
                <xsl:with-param
                  name="value"
                  select="@statementDate" />
                <xsl:with-param
                  name="addressValue"
                  select="@receiverAddress" />
              </xsl:call-template>

              <xsl:call-template name="accountStatementAccountSectionRow">
                <xsl:with-param
                  name="title"
                  select="'Previous Statement'" />
                <xsl:with-param
                  name="value"
                  select="@lastStatementDate" />
                <xsl:with-param name="addressValue">
                  <xsl:call-template name="composeReceiverLocation" />
                </xsl:with-param>
              </xsl:call-template>

            </xsl:otherwise>
          </xsl:choose>

        </fo:table-body>
      </fo:table>
      
      <xsl:choose>
      	<xsl:when test="$isDailyFrequency">
      	</xsl:when>
      	<xsl:otherwise>
      		<xsl:variable name="startDate"
			select="//stmt:section[@id = 'metadata']/@statementStartDate" />
			<xsl:variable name="endDate"
			select="//stmt:section[@id = 'metadata']/@statementEndDate" />
      		<fo:block
				space-after="1mm"
				xsl:use-attribute-sets="title-text-style"
				text-align="center">
				Monthly Statement 
			</fo:block>
    		<fo:block
				space-after="1mm"
				xsl:use-attribute-sets="padded-table-cell-style metadata-section-header-cell-style"
				font-size="11pt" text-align="center" >
				From  <xsl:value-of select="$startDate"/> To  <xsl:value-of select="$endDate"/>
    		</fo:block>
      	</xsl:otherwise>
      </xsl:choose>
    </fo:block>
  </xsl:template>

  <xsl:template name="composeReceiverLocation">
    <xsl:value-of select="@receiverCity" />
    <xsl:if test="boolean(@reciverState)">
      <xsl:value-of select="concat(', ', @receiverState)" />
    </xsl:if>
    <xsl:if test="boolean(@receiverZip)">
      <xsl:value-of select="concat(', ', @receiverZip)" />
    </xsl:if>
    <xsl:if test="boolean(@receiverCountry)">
      <xsl:value-of select="concat(', ', @receiverCountry)" />
    </xsl:if>
  </xsl:template>

  <xsl:template name="accountStatementAccountSectionRow">
    <xsl:param name="title" />
    <xsl:param name="value" />
    <xsl:param name="addressValue" />
    <fo:table-row>
      <fo:table-cell xsl:use-attribute-sets="padded-table-cell-style metadata-section-header-cell-style">
        <fo:block>
          <xsl:value-of select="$title" />
        </fo:block>
      </fo:table-cell>
      <fo:table-cell xsl:use-attribute-sets="padded-table-cell-style">
        <fo:block>
          <fo:block>
            <xsl:value-of select="$value" />
          </fo:block>
        </fo:block>
      </fo:table-cell>
      <fo:table-cell xsl:use-attribute-sets="right-align-table-cell-style">
        <fo:block>
          <xsl:value-of select="$addressValue" />
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
  </xsl:template>



</xsl:stylesheet>