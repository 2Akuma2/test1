<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>
<!-- <!DOCTYPE xsl:stylesheet [ -->
  <!-- <!ENTITY nbsp   "&#160;" > -->
<!-- ]> -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xalan="http://xml.apache.org/xslt"
                version="1.0">

  <xsl:output method="xml"
              indent="yes"
              encoding="ISO-8859-1"
              xalan:indent-amount="2"/>

  <!-- {{{ Parameters -->

  <!-- The language, default is 'en', alternative is 'de' -->
  <xsl:param name="lang" select="'en'"/>

  <!-- Whether to log messages -->
  <xsl:param name="debug"/>

  <!-- }}} -->

  <!-- {{{ main structure -->

  <!-- Entry point -->
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- }}} -->

  <!-- {{{ Defaults -->


  <xsl:template match="*">
    <xsl:element name="{name()}">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="." mode="createSummary"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="*" mode="createSummary">
    <!-- noop -->
  </xsl:template>

  <xsl:template match="@*">
    <xsl:copy/>
  </xsl:template>

  <!-- }}} -->

</xsl:stylesheet>
