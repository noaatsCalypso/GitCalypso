<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:html="http://www.w3.org/1999/xhtml">

  <xsl:output method="xml"
              version="1.0"
              encoding="UTF-8"
              indent="no"/>

  <!--======================================================================
      Parameters
  =======================================================================-->

  <!-- page size -->
  <xsl:param name="page-width">auto</xsl:param>
  <xsl:param name="page-height">auto</xsl:param>
  <xsl:param name="page-margin-top">.5in</xsl:param>
  <xsl:param name="page-margin-bottom">.5in</xsl:param>
  <xsl:param name="page-margin-left">0.5in</xsl:param>
  <xsl:param name="page-margin-right">0.5in</xsl:param>

  <!-- page header and footer -->
  <xsl:param name="page-header-margin">0.5in</xsl:param>
  <xsl:param name="page-footer-margin">0.5in</xsl:param>
  <xsl:param name="title-print-in-header">true</xsl:param>
  <xsl:param name="page-number-print-in-footer">false</xsl:param>

  <!-- multi column -->
  <xsl:param name="column-count">1</xsl:param>
  <xsl:param name="column-gap">12pt</xsl:param>

  <!-- writing-mode: lr-tb | rl-tb | tb-rl -->
  <xsl:param name="writing-mode">lr-tb</xsl:param>

  <!-- text-align: justify | start -->
  <xsl:param name="text-align">start</xsl:param>

  <!-- hyphenate: true | false -->
  <xsl:param name="hyphenate">false</xsl:param>


  <!--======================================================================
      Attribute Sets
  =======================================================================-->

  <!--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
       Root
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-->

  <xsl:attribute-set name="root">
    <xsl:attribute name="writing-mode"><xsl:value-of select="$writing-mode"/></xsl:attribute>
    <xsl:attribute name="hyphenate"><xsl:value-of select="$hyphenate"/></xsl:attribute>
    <xsl:attribute name="text-align"><xsl:value-of select="$text-align"/></xsl:attribute>
    <!-- specified on fo:root to change the properties' initial values -->
  </xsl:attribute-set>

  <xsl:attribute-set name="page">
    <xsl:attribute name="page-width"><xsl:value-of select="$page-width"/></xsl:attribute>
    <xsl:attribute name="page-height"><xsl:value-of select="$page-height"/></xsl:attribute>
    <!-- specified on fo:simple-page-master -->
  </xsl:attribute-set>

  <xsl:attribute-set name="body">
    <!-- specified on fo:flow's only child fo:block -->
  </xsl:attribute-set>

  <xsl:attribute-set name="page-header">
    <!-- specified on (page-header)fo:static-content's only child fo:block -->
    <xsl:attribute name="font-size">small</xsl:attribute>
    <xsl:attribute name="text-align">center</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="page-footer">
    <!-- specified on (page-footer)fo:static-content's only child fo:block -->
    <xsl:attribute name="font-size">small</xsl:attribute>
    <xsl:attribute name="text-align">center</xsl:attribute>
  </xsl:attribute-set>

  <!--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
       Block-level
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-->

  <xsl:attribute-set name="h1">
    <xsl:attribute name="font-size">1em</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>

    <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="h2">
    <xsl:attribute name="font-size">1em</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>

    <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="h3">
    <xsl:attribute name="font-size">1em</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>

    <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="p">
    <!-- e.g.,
    <xsl:attribute name="text-indent">1em</xsl:attribute>
    -->
  </xsl:attribute-set>

  <xsl:attribute-set name="p-initial" use-attribute-sets="p">
    <!-- initial paragraph, preceded by h1..6 or div -->
    <!-- e.g.,
    <xsl:attribute name="text-indent">0em</xsl:attribute>
    -->
  </xsl:attribute-set>

  <xsl:attribute-set name="p-initial-first" use-attribute-sets="p-initial">
    <!-- initial paragraph, first child of div, body or td -->
  </xsl:attribute-set>


  <xsl:attribute-set name="pre">
    <xsl:attribute name="font-size">1em</xsl:attribute>
    <xsl:attribute name="font-family">courier</xsl:attribute>
    <xsl:attribute name="white-space-collapse">false</xsl:attribute>
    <xsl:attribute name="white-space">pre</xsl:attribute>
    <xsl:attribute name="wrap-option">normal</xsl:attribute>
  </xsl:attribute-set>

  <!--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
       Root
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-->

  <xsl:template match="html">
    <fo:root xsl:use-attribute-sets="root">
      <xsl:call-template name="process-common-attributes"/>
      <xsl:call-template name="make-layout-master-set"/>
      <xsl:apply-templates/>
    </fo:root>
  </xsl:template>

  <xsl:template name="make-layout-master-set">
    <fo:layout-master-set>
      <fo:simple-page-master master-name="all-pages"
                             xsl:use-attribute-sets="page">
        <fo:region-body margin-top="{$page-margin-top}"
                        margin-right="{$page-margin-right}"
                        margin-bottom="{$page-margin-bottom}"
                        margin-left="{$page-margin-left}"
                        column-count="{$column-count}"
                        column-gap="{$column-gap}"/>
        <xsl:choose>
          <xsl:when test="$writing-mode = 'tb-rl'">
            <fo:region-before extent="{$page-margin-right}"
                              precedence="true"/>
            <fo:region-after  extent="{$page-margin-left}"
                              precedence="true"/>
            <fo:region-start  region-name="page-header"
                              extent="{$page-margin-top}"
                              writing-mode="lr-tb"
                              display-align="before"/>
            <fo:region-end    region-name="page-footer"
                              extent="{$page-margin-bottom}"
                              writing-mode="lr-tb"
                              display-align="after"/>
          </xsl:when>
          <xsl:when test="$writing-mode = 'rl-tb'">
            <fo:region-before region-name="page-header"
                              extent="{$page-margin-top}"
                              display-align="before"/>
            <fo:region-after  region-name="page-footer"
                              extent="{$page-margin-bottom}"
                              display-align="after"/>
            <fo:region-start  extent="{$page-margin-right}"/>
            <fo:region-end    extent="{$page-margin-left}"/>
          </xsl:when>
          <xsl:otherwise><!-- $writing-mode = 'lr-tb' -->
            <fo:region-before region-name="page-header"
                              extent="{$page-margin-top}"
                              display-align="before"/>
            <fo:region-after  region-name="page-footer"
                              extent="{$page-margin-bottom}"
                              display-align="after"/>
            <fo:region-start  extent="{$page-margin-left}"/>
            <fo:region-end    extent="{$page-margin-bottom}"/>
          </xsl:otherwise>
        </xsl:choose>
      </fo:simple-page-master>
    </fo:layout-master-set>
  </xsl:template>

  <xsl:template match="head | script"/>

  <xsl:template match="body">
    <fo:page-sequence master-reference="all-pages">
      <fo:title>
        <xsl:value-of select="/html/head/title"/>
      </fo:title>
      <fo:static-content flow-name="page-header">
        <fo:block space-before.conditionality="retain"
                  space-before="{$page-header-margin}"
                  xsl:use-attribute-sets="page-header">
          <xsl:if test="$title-print-in-header = 'true'">
            <xsl:value-of select="/html/head/title"/>
          </xsl:if>
        </fo:block>
      </fo:static-content>
      <fo:static-content flow-name="page-footer">
        <fo:block space-after.conditionality="retain"
                  space-after="{$page-footer-margin}"
                  xsl:use-attribute-sets="page-footer">
          <xsl:if test="$page-number-print-in-footer = 'true'">
            <xsl:text>- </xsl:text>
            <fo:page-number/>
            <xsl:text> -</xsl:text>
          </xsl:if>
        </fo:block>
      </fo:static-content>
      <fo:flow flow-name="xsl-region-body">
        <fo:block space-before.conditionality="retain"
        	      xsl:use-attribute-sets="body">
          <xsl:call-template name="process-common-attributes"/>
          <xsl:apply-templates/>
        </fo:block>
          
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>

  <!--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
   process common attributes and children
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-->

  <xsl:template name="process-common-attributes-and-children">
    <xsl:call-template name="process-common-attributes"/>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template name="process-common-attributes">
    <xsl:attribute name="role">
      <xsl:value-of select="concat('', local-name())"/>
    </xsl:attribute>

    <xsl:if test="@style">
      <xsl:call-template name="process-style">
        <xsl:with-param name="style" select="@style"/>
      </xsl:call-template>
    </xsl:if>

      <xsl:if test="@bgcolor">
          <xsl:attribute name="background-color">
              <xsl:value-of select="@bgcolor"/>
          </xsl:attribute>
      </xsl:if>

  </xsl:template>

  <xsl:template name="process-style">
    <xsl:param name="style"/>
    <!-- e.g., style="text-align: center; color: red"
         converted to text-align="center" color="red" -->
    <xsl:variable name="name"
                  select="normalize-space(substring-before($style, ':'))"/>
    <xsl:if test="$name">
      <xsl:variable name="value-and-rest"
                    select="normalize-space(substring-after($style, ':'))"/>
      <xsl:variable name="value">
        <xsl:choose>
          <xsl:when test="contains($value-and-rest, ';')">
            <xsl:value-of select="normalize-space(substring-before(
                                  $value-and-rest, ';'))"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$value-and-rest"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$name = 'width' and (self::col or self::colgroup)">
          <xsl:attribute name="column-width">
            <xsl:value-of select="$value"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="$name = 'vertical-align' and (
                                 self::table or self::caption or
                                 self::thead or self::tfoot or
                                 self::tbody or self::colgroup or
                                 self::col or self::tr or
                                 self::th or self::td)">
          <xsl:choose>
            <xsl:when test="$value = 'top'">
              <xsl:attribute name="display-align">before</xsl:attribute>
            </xsl:when>
            <xsl:when test="$value = 'bottom'">
              <xsl:attribute name="display-align">after</xsl:attribute>
            </xsl:when>
            <xsl:when test="$value = 'middle'">
              <xsl:attribute name="display-align">center</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="display-align">auto</xsl:attribute>
              <xsl:attribute name="relative-align">baseline</xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="{$name}">
            <xsl:value-of select="$value"/>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:variable name="rest"
                  select="normalize-space(substring-after($style, ';'))"/>
    <xsl:if test="$rest">
      <xsl:call-template name="process-style">
        <xsl:with-param name="style" select="$rest"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>


  <!--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
       Block-level
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-->

  <xsl:template match="h1">
    <fo:block xsl:use-attribute-sets="h1">
      <xsl:call-template name="process-common-attributes-and-children"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="h2">
    <fo:block xsl:use-attribute-sets="h2">
      <xsl:call-template name="process-common-attributes-and-children"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="h3">
    <fo:block xsl:use-attribute-sets="h3">
      <xsl:call-template name="process-common-attributes-and-children"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="p">
    <fo:block xsl:use-attribute-sets="p">
        <xsl:attribute name="font-size">
            <xsl:choose>
                <xsl:when test="@class">
                    <xsl:choose>
                        <xsl:when test="contains(@class, 'header1')">26px</xsl:when>
                        <xsl:when test="contains(@class, 'header2')">22px</xsl:when>
                        <xsl:when test="contains(@class, 'header3')">18px</xsl:when>
                        <xsl:otherwise>10px</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>10px</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

      <xsl:call-template name="process-common-attributes-and-children"/>
    </fo:block>
  </xsl:template>

  <!-- initial paragraph, preceded by h1..6 or div -->
  <xsl:template match="p[preceding-sibling::*[1][
                       self::h1 or self::h2 or self::h3 or
                       self::h4 or self::h5 or self::h6 or
                       self::div]]">
    <fo:block xsl:use-attribute-sets="p-initial">
      <xsl:call-template name="process-common-attributes-and-children"/>
    </fo:block>
  </xsl:template>

  <!-- initial paragraph, first child of div, body or td -->
  <xsl:template match="p[not(preceding-sibling::*) and (
                       parent::div or parent::body or
                       parent::td)]">
    <fo:block xsl:use-attribute-sets="p-initial-first">
      <xsl:call-template name="process-common-attributes-and-children"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="pre">
    <fo:block xsl:use-attribute-sets="pre" font-family="monospace" font-size="10pt"
    white-space-collapse="false"
    wrap-option="wrap">
    <xsl:apply-templates select="*|text()"/>
  </fo:block>
  </xsl:template>
  
  <xsl:template match="regularTextcc">
    <fo:block xsl:use-attribute-sets="regularText" font-family="monospace" font-size="10pt"
    white-space-collapse="false"
    wrap-option="wrap">
    <xsl:apply-templates select="*|text()"/>
  </fo:block>
  </xsl:template>

  <xsl:template match="div">
    <!-- need fo:block-container? or normal fo:block -->
    <xsl:variable name="need-block-container">
      <xsl:call-template name="need-block-container"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$need-block-container = 'true'">
        <fo:block-container>
          <xsl:if test="@dir">
            <xsl:attribute name="writing-mode">
              <xsl:choose>
                <xsl:when test="@dir = 'rtl'">rl-tb</xsl:when>
                <xsl:otherwise>lr-tb</xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
          </xsl:if>
          <xsl:call-template name="process-common-attributes"/>
          <fo:block start-indent="0pt" end-indent="0pt">
            <xsl:apply-templates/>
          </fo:block>
        </fo:block-container>
      </xsl:when>
      <xsl:otherwise>
        <!-- normal block -->
        <fo:block>
          <xsl:call-template name="process-common-attributes"/>
          <xsl:apply-templates/>
        </fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="need-block-container">
    <xsl:choose>
      <xsl:when test="@dir">true</xsl:when>
      <xsl:when test="@style">
        <xsl:variable name="s"
                      select="concat(';', translate(normalize-space(@style),
                                                    ' ', ''))"/>
        <xsl:choose>
          <xsl:when test="contains($s, ';width:') or
                          contains($s, ';height:') or
                          contains($s, ';position:absolute') or
                          contains($s, ';position:fixed') or
                          contains($s, ';writing-mode:')">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="center">
    <fo:block text-align="center">
      <xsl:call-template name="process-common-attributes-and-children"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="fieldset | form | dir | menu">
    <fo:block space-before="1em" space-after="1em">
      <xsl:call-template name="process-common-attributes-and-children"/>
    </fo:block>
  </xsl:template>

  


  <!--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
       Inline-level
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-->

  <xsl:template match="b">
    <fo:inline xsl:use-attribute-sets="b">
      <xsl:call-template name="process-common-attributes-and-children"/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="strong">
    <fo:inline xsl:use-attribute-sets="strong">
      <xsl:call-template name="process-common-attributes-and-children"/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="strong//em | em//strong">
    <fo:inline xsl:use-attribute-sets="strong-em">
      <xsl:call-template name="process-common-attributes-and-children"/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="i">
    <fo:inline xsl:use-attribute-sets="i">
      <xsl:call-template name="process-common-attributes-and-children"/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="cite">
    <fo:inline xsl:use-attribute-sets="cite">
      <xsl:call-template name="process-common-attributes-and-children"/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="em">
    <fo:inline xsl:use-attribute-sets="em">
      <xsl:call-template name="process-common-attributes-and-children"/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="var">
    <fo:inline xsl:use-attribute-sets="var">
      <xsl:call-template name="process-common-attributes-and-children"/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="dfn">
    <fo:inline xsl:use-attribute-sets="dfn">
      <xsl:call-template name="process-common-attributes-and-children"/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="tt">
    <fo:inline xsl:use-attribute-sets="tt">
      <xsl:call-template name="process-common-attributes-and-children"/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="code">
    <fo:inline xsl:use-attribute-sets="code">
      <xsl:call-template name="process-common-attributes-and-children"/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="kbd">
    <fo:inline xsl:use-attribute-sets="kbd">
      <xsl:call-template name="process-common-attributes-and-children"/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="samp">
    <fo:inline xsl:use-attribute-sets="samp">
      <xsl:call-template name="process-common-attributes-and-children"/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="big">
    <fo:inline xsl:use-attribute-sets="big">
      <xsl:call-template name="process-common-attributes-and-children"/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="small">
    <fo:inline xsl:use-attribute-sets="small">
      <xsl:call-template name="process-common-attributes-and-children"/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="sub">
    <fo:inline xsl:use-attribute-sets="sub">
      <xsl:call-template name="process-common-attributes-and-children"/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="sup">
    <fo:inline xsl:use-attribute-sets="sup">
      <xsl:call-template name="process-common-attributes-and-children"/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="s">
    <fo:inline xsl:use-attribute-sets="s">
      <xsl:call-template name="process-common-attributes-and-children"/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="strike">
    <fo:inline xsl:use-attribute-sets="strike">
      <xsl:call-template name="process-common-attributes-and-children"/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="del">
    <fo:inline xsl:use-attribute-sets="del">
      <xsl:call-template name="process-common-attributes-and-children"/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="u">
    <fo:inline xsl:use-attribute-sets="u">
      <xsl:call-template name="process-common-attributes-and-children"/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="ins">
    <fo:inline xsl:use-attribute-sets="ins">
      <xsl:call-template name="process-common-attributes-and-children"/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="abbr">
    <fo:inline xsl:use-attribute-sets="abbr">
      <xsl:call-template name="process-common-attributes-and-children"/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="acronym">
    <fo:inline xsl:use-attribute-sets="acronym">
      <xsl:call-template name="process-common-attributes-and-children"/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="span">
    <fo:inline>
      <xsl:call-template name="process-common-attributes-and-children"/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="span[@dir]">
    <fo:bidi-override direction="{@dir}" unicode-bidi="embed">
      <xsl:call-template name="process-common-attributes-and-children"/>
    </fo:bidi-override>
  </xsl:template>

  <xsl:template match="span[@style and contains(@style, 'writing-mode')]">
    <fo:inline-container alignment-baseline="central"
                         text-indent="0pt"
                         last-line-end-indent="0pt"
                         start-indent="0pt"
                         end-indent="0pt"
                         text-align="center"
                         text-align-last="center">
      <xsl:call-template name="process-common-attributes"/>
      <fo:block wrap-option="no-wrap" line-height="1">
        <xsl:apply-templates/>
      </fo:block>
    </fo:inline-container>
  </xsl:template>

  <xsl:template match="bdo">
    <fo:bidi-override direction="{@dir}" unicode-bidi="bidi-override">
      <xsl:call-template name="process-common-attributes-and-children"/>
    </fo:bidi-override>
  </xsl:template>

  <xsl:template match="br">
    <fo:block>
      <xsl:call-template name="process-common-attributes"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="q">
    <fo:inline xsl:use-attribute-sets="q">
      <xsl:call-template name="process-common-attributes"/>
      <xsl:choose>
        <xsl:when test="lang('ja')">
          <xsl:text>「</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>」</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <!-- lang('en') -->
          <xsl:text>“</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>”</xsl:text>
          <!-- todo: other languages ...-->
        </xsl:otherwise>
      </xsl:choose>
    </fo:inline>
  </xsl:template>

  <xsl:template match="q//q">
    <fo:inline xsl:use-attribute-sets="q-nested">
      <xsl:call-template name="process-common-attributes"/>
      <xsl:choose>
        <xsl:when test="lang('ja')">
          <xsl:text>『</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>』</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <!-- lang('en') -->
          <xsl:text>‘</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>’</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </fo:inline>
  </xsl:template>



  <xsl:template match="param"/>
  <xsl:template match="map"/>
  <xsl:template match="area"/>
  <xsl:template match="label"/>
  <xsl:template match="input"/>
  <xsl:template match="select"/>
  <xsl:template match="optgroup"/>
  <xsl:template match="option"/>
  <xsl:template match="textarea"/>
  <xsl:template match="legend"/>
  <xsl:template match="button"/>

 
</xsl:stylesheet>
