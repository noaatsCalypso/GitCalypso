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

  <!-- MAIN STRUCTURE DEFINITION -->

  <xsl:variable
    name="statementCurrency"
    select="//stmt:section[@id='metadata']/@statementCurrency" />
    
  <xsl:variable
    name="statementType"
    select="//stmt:section[@id='metadata']/@statementType" />
    
  <!-- Controls the formatting of Future32/64 quotes -->
  <xsl:variable
    name="useExtendedFuture32"
    select="false()" />    

  <xsl:param
    name="versionParam"
    select="'1.1'" />
  <xsl:output
    method="xml"
    version="1.0"
    omit-xml-declaration="no" />

  <xsl:attribute-set name="root-font-style">
    <xsl:attribute name="font-family">Helvetica, sans-serif</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="debug-table-format-style">
    <!-- Uncomment these attributes to debug table positioning/dimensioning issues -->
    <!-- <xsl:attribute name="border">1px dashed red</xsl:attribute> -->
  </xsl:attribute-set>

  <xsl:attribute-set name="debug-symbol-table-cell-style">
    <!-- Uncomment these attributes to debug contract symbol positioning/dimensioning issues -->
    <!-- <xsl:attribute name="border">0.5px solid</xsl:attribute> <xsl:attribute name="background-color">yellow</xsl:attribute> -->
  </xsl:attribute-set>

  <xsl:attribute-set name="page-dimensions-style">
    <!-- A4 -->
    <xsl:attribute name="page-height">210mm</xsl:attribute>
    <xsl:attribute name="page-width">297mm</xsl:attribute>
    <xsl:attribute name="margin">7mm</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="region-body-style">
    <xsl:attribute name="space-before">39mm</xsl:attribute>
    <xsl:attribute name="space-after">5mm</xsl:attribute>
  </xsl:attribute-set>

  <xsl:template match="/stmt:ClearingStatement">
    <!-- This is the main template, which will be matched first -->

    <fo:root
      xmlns:fo="http://www.w3.org/1999/XSL/Format"
      xsl:use-attribute-sets="root-font-style">

      <fo:layout-master-set>

        <fo:simple-page-master
          master-name="firstPage"
          xsl:use-attribute-sets="page-dimensions-style">

          <fo:region-body
            region-name="first-page-body"
            xsl:use-attribute-sets="region-body-style" />
          <fo:region-before region-name="header" />
          <fo:region-after region-name="footer" />

        </fo:simple-page-master>

        <fo:simple-page-master
          master-name="mainPage"
          xsl:use-attribute-sets="page-dimensions-style">

          <fo:region-body
            region-name="main-body"
            xsl:use-attribute-sets="region-body-style" />
          <fo:region-before region-name="header" />
          <fo:region-after region-name="footer" />

        </fo:simple-page-master>

        <fo:simple-page-master
          master-name="lastPage"
          xsl:use-attribute-sets="page-dimensions-style">

          <fo:region-body
            region-name="last-page-body"
            xsl:use-attribute-sets="region-body-style" />
          <fo:region-before region-name="header" />
          <fo:region-after region-name="footer" />

        </fo:simple-page-master>

        <page-sequence-master master-name="pages">
          <repeatable-page-master-alternatives>
            <conditional-page-master-reference
              page-position="first"
              master-reference="firstPage" />
            <conditional-page-master-reference
              page-position="rest"
              master-reference="mainPage" />
            <conditional-page-master-reference
              page-position="last"
              master-reference="lastPage" />
          </repeatable-page-master-alternatives>
        </page-sequence-master>

      </fo:layout-master-set>

      <!-- Definition of the first page -->
      <fo:page-sequence master-reference="firstPage">

        <xsl:call-template name="headerContent">
          <xsl:with-param
            name="withSubheader"
            select="'false'" />
        </xsl:call-template>

        <xsl:call-template name="footerContent" />

        <fo:flow flow-name="first-page-body">
          <xsl:apply-templates select="stmt:section[@id = 'metadata']" />
        </fo:flow>

      </fo:page-sequence>

      <!-- Definition of the main pages -->
      <fo:page-sequence master-reference="mainPage">

        <xsl:call-template name="headerContent" />
        <xsl:call-template name="footerContent" />

        <fo:flow flow-name="main-body">
          <xsl:apply-templates select="stmt:section[@id != 'metadata']" />
        </fo:flow>

      </fo:page-sequence>

      <!-- Definition of the last page -->
      <fo:page-sequence master-reference="lastPage">

        <xsl:call-template name="headerContent">
          <xsl:with-param
            name="withSubheader"
            select="'false'" />
        </xsl:call-template>

        <xsl:call-template name="footerContent" />

        <fo:flow flow-name="last-page-body">
          <xsl:call-template name="lastPageBodyContent" />
          <fo:block id="endMarker" />
        </fo:flow>

      </fo:page-sequence>

    </fo:root>
  </xsl:template>


  <!-- COMMON TEMPLATES and ATTRIBUTE SETS -->

  <!-- See https://material.io/guidelines/style/color.html#color-color-palette -->

  <xsl:variable
    name="INDIGO900"
    select="'#1A237E'" />

  <xsl:variable
    name="INDIGO100"
    select="'#C5CAE9'" />

  <xsl:variable
    name="INDIGO050"
    select="'#E8EAF6'" />

  <xsl:variable
    name="GREY700"
    select="'#616161'" />

  <xsl:variable
    name="GREY500"
    select="'#9E9E9E'" />

  <xsl:variable
    name="GREY050"
    select="'#FAFAFA'" />

  <xsl:attribute-set name="section-block-style">
    <xsl:attribute name="page-break-before">always</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="padded-table-cell-style">
    <xsl:attribute name="padding">5px</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="right-align-table-cell-style">
    <xsl:attribute name="padding">5px</xsl:attribute>
    <xsl:attribute name="text-align">right</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="ticker-symbol-block-style">

  </xsl:attribute-set>

  <xsl:attribute-set name="title-text-style">
    <xsl:attribute name="text-transform">uppercase</xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$INDIGO900" /></xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="font-size">1.05em</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set
    name="subtitle-text-style"
    use-attribute-sets="title-text-style">
    <xsl:attribute name="font-size">1em</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="comment-text-style">
    <xsl:attribute name="font-style">italic</xsl:attribute>
    <xsl:attribute name="font-size">0.8em</xsl:attribute>
    <xsl:attribute name="color"><xsl:value-of select="$GREY700" /></xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="content-table-style">
    <xsl:attribute name="font-size">0.55em</xsl:attribute>
    <xsl:attribute name="font-family">"Lucida Console", Monaco, monospace</xsl:attribute>
    <xsl:attribute name="inline-progression-dimension">auto</xsl:attribute>
    <xsl:attribute name="table-layout">auto</xsl:attribute>
    <xsl:attribute name="space-after">5mm</xsl:attribute>
    <xsl:attribute name="display-align">after</xsl:attribute>
    <!-- Stick to sub/title -->
    <xsl:attribute name="keep-with-previous.within-page">always</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="content-table-header-style">
    <xsl:attribute name="font-weight">bold</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="content-table-header-row-style">
    <xsl:attribute name="border-bottom-style">solid</xsl:attribute>
    <xsl:attribute name="border-bottom-width">1px</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="right-align-block-style">
    <xsl:attribute name="text-align">right</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set
    name="quantity-block-style"
    use-attribute-sets="right-align-block-style">
  </xsl:attribute-set>
  
  <xsl:attribute-set name="quantity-bold-block-style">
  	<xsl:attribute name="text-align">right</xsl:attribute>
  	<xsl:attribute name="font-weight">bold</xsl:attribute>
  </xsl:attribute-set>
  
    <xsl:attribute-set name="bold-block-style">
  	<xsl:attribute name="font-weight">bold</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="long-header-block-style">
    <xsl:attribute name="wrap-option">wrap</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="contract-description-block-style">
    <xsl:attribute name="text-align">left</xsl:attribute>
    <xsl:attribute name="letter-spacing">0.25pt</xsl:attribute>
    <xsl:attribute name="word-spacing">0.5pt</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="subtotal-label-block-style">
    <xsl:attribute name="text-align">right</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="left-padded-column-cell-style">
    <xsl:attribute name="padding-left">4px</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="ticker-symbol-column-cell-style">
    <xsl:attribute name="text-align">center</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="first-column-cell-style" />

  <xsl:attribute-set name="last-column-cell-style" />

  <xsl:template name="tickerSymbolCell">
    <xsl:param name="ticker" />

    <xsl:param name="fontSize">
      <xsl:choose>
        <xsl:when test="string-length($ticker) &lt; 5">
          1.15em
        </xsl:when>
        <xsl:when test="string-length($ticker) &lt; 6">
          1em
        </xsl:when>
        <xsl:when test="string-length($ticker) &lt; 9">
          0.8em
        </xsl:when>
        <xsl:otherwise>
          0.65em
        </xsl:otherwise>
      </xsl:choose>
    </xsl:param>

    <fo:table-cell
      padding-left="0.75em"
      padding-right="0.75em"
      xsl:use-attribute-sets="ticker-symbol-column-cell-style debug-symbol-table-cell-style">
      <fo:block-container overflow="hidden">
        <fo:block
          text-align="center"
          background-color="{$INDIGO900}"
          color="white"
          font-weight="900"
          padding-top="1px"
          line-height="10pt"
          font-size="{$fontSize}"
          font-family="Helvetica, sans-serif">
          <xsl:value-of select="$ticker" />
        </fo:block>
      </fo:block-container>
    </fo:table-cell>
  </xsl:template>

  <xsl:template name="contentRowAttributes">
    <xsl:param name="isEvenRow" />
    <!-- Zebra striping disabled by default -->
    <xsl:param
      name="evenRowColor"
      select="'white'" />

    <xsl:if test="$isEvenRow = 'true'">
      <xsl:attribute name="background-color"><xsl:value-of select="$evenRowColor" /></xsl:attribute>
    </xsl:if>

    <xsl:attribute name="height">1.75em</xsl:attribute>
    <xsl:attribute name="display-align">center</xsl:attribute>
  </xsl:template>

  <xsl:template name="subtotalRowAttributes">
    <xsl:param name="isEvenRow" />
    <xsl:call-template name="contentRowAttributes">
      <xsl:with-param
        name="isEvenRow"
        select="$isEvenRow" />
    </xsl:call-template>

    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="keep-with-previous.within-page">always</xsl:attribute>
  </xsl:template>

  <xsl:template name="finsumSubtotalRowAttributes">
    <xsl:call-template name="contentRowAttributes">
      <xsl:with-param
        name="evenRowColor"
        select="$INDIGO100" />
      <xsl:with-param
        name="isEvenRow"
        select="'true'" />
    </xsl:call-template>

    <xsl:attribute name="font-weight">bold</xsl:attribute>

  </xsl:template>

  <xsl:variable name="finsumPageSize">
    <!-- Maximum number of currencies per financial summary page, including the Base one -->
    <xsl:value-of select="number(6)" />
  </xsl:variable>

  <xsl:template name="sectionTitle">
    <xsl:param name="title" />
    <xsl:param name="comment" />

    <fo:block
      border-bottom-width="1.5px"
      border-bottom-color="{$INDIGO900}"
      border-bottom-style="solid"
      space-after="1mm"
      xsl:use-attribute-sets="title-text-style">
      <xsl:value-of select="$title" />
    </fo:block>
    <xsl:if test="boolean($comment)">
      <fo:block
        space-after="2mm"
        font-size="0.7em"
        xsl:use-attribute-sets="comment-text-style">
        <xsl:value-of select="$comment" />
      </fo:block>
    </xsl:if>
  </xsl:template>

  <xsl:template name="sectionSubtitle">
    <xsl:param name="subtitle" />
    <fo:block
      space-after="2mm"
      xsl:use-attribute-sets="subtitle-text-style">
      <xsl:value-of select="$subtitle" />
    </fo:block>
  </xsl:template>

  <xsl:template name="emptySectionComment">
    <!-- Add to every section table, passing its content, to render a comment row if empty -->
    <xsl:param name="content" />
    <xsl:if test="not(boolean($content))">
      <fo:block
        xsl:use-attribute-sets="comment-text-style"
        color="{$GREY500}"
        space-before="7mm"
        text-align="center"
        font-size="1.2em">
        No activity
      </fo:block>
    </xsl:if>
  </xsl:template>

  <xsl:template name="leReceiverName">
    <xsl:variable name="receiverName">
      <xsl:value-of select="//stmt:section[@id = 'metadata']/@receiver" />
    </xsl:variable>
    <xsl:variable name="accountLEName">
      <xsl:value-of select="//stmt:section[@id = 'metadata']/@accountLEName" />
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="boolean($receiverName)">
        <xsl:value-of select="$receiverName" />
      </xsl:when>
      <xsl:when test="boolean($accountLEName)">
        <xsl:value-of select="$accountLEName" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'&lt;UNKNOWN RECEIVER&gt;'" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>