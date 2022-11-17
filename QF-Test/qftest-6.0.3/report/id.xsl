<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xalan="http://xml.apache.org/xslt"
                exclude-result-prefixes="xsl xalan"
                version="1.0">

  <xsl:output method="xml"
              indent="yes"
              encoding="ISO-8859-1"
              xalan:indent-amount="2"/>

  <!-- Entry point -->
  <xsl:template match="/">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()|text()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()|text()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="text()">
    <xsl:copy/>
  </xsl:template>

</xsl:stylesheet>