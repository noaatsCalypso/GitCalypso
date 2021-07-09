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

  <xsl:attribute-set name="disclaimer-text-style">
    <xsl:attribute name="font-family">Helvetica, sans-serif</xsl:attribute>
    <xsl:attribute name="font-style">italic</xsl:attribute>
    <xsl:attribute name="text-align">justify</xsl:attribute>
  </xsl:attribute-set>

  <xsl:template name="lastPageBodyContent">

    <fo:block
      xsl:use-attribute-sets="disclaimer-text-style"
      color="red"
      font-size="13pt"
      font-weight="bold"
      border-bottom-color="red"
      border-bottom-style="solid">
      DISCLAIMER
    </fo:block>

    <fo:block
      xsl:use-attribute-sets="disclaimer-text-style"
      space-before="9pt">Lorem ipsum dolor sit amet, sem amet interdum at. Consequat
      natoque felis et, et
      suspendisse
      ac faucibus dolor faucibus, vel erat. Sem odio aptent
      consequat amet, arcu neque,
      nec aenean lacinia
      lectus sit justo. Rutrum ultrices nulla turpis
      non. Vivamus erat a nascetur
      sed nibh, nam wisi vivamus
      maecenas pretium, qui amet elementum
      nisl sed, eu vel fames
      suscipit
      sed, vitae dolor.
    </fo:block>

    <fo:block
      xsl:use-attribute-sets="disclaimer-text-style"
      space-before="9pt">Est ridiculus feugiat, orci laoreet aenean dui lectus, placerat
      parturient netus
      egestas
      voluptas
      bibendum diam, wisi egestas fusce pellentesque nunc lorem
      feugiat, tempus massa
      cursus sed.
      Vestibulum et gravida molestie tempor wisi vel, hac risus sed
      libero, magna dolor.
      Ut volutpat
      vitae erat
      neque. Potenti vestibulum et dolor viverra, neque
      ac, urna donec, lacus
      molestie a
      sed eget feugiat. Turpis
      libero urna vestibulum, mi sem ut ut
      pretium in quis,
      ridiculus
      voluptatem risus etiam neque phasellus
      neque, dui iaculis eu nibh.
      Ut elementum lacus
      a, dolor
      nibh amet, in semper in tempus venenatis consequat,
      suspendisse
      elit dolor pellentesque
      pellentesque dolor.
    </fo:block>

    <fo:block
      xsl:use-attribute-sets="disclaimer-text-style"
      space-before="9pt">Libero elit metus nonummy. Morbi pellentesque. Libero nullam
      felis nec maecenas
      nascetur, sed
      ante eu,
      neque quis. Dui malesuada vivamus vivamus risus,
      suscipit vel magna, nunc
      et. Cras ipsum
      rhoncus,
      quis adipiscing, ut id mauris neque nonummy
      eros, vulputate pede velit
      vitae in vero.
      Et mollis maecenas
      hymenaeos pellentesque, molestie
      gravida in erat odio.
      Porttitor aptent
      laoreet volutpat aspernatur id,
      amet nullam est, amet a
      orci ipsum, non neque
      ut. Semper
      semper non wisi ipsum pede sodales, voluptas quam
      velit
      ultrices ante ac, primis
      vitae eu
      velit ut ipsum, ut volutpat dignissim vestibulum suscipit.
    </fo:block>

  </xsl:template>

</xsl:stylesheet>