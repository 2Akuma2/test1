<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>
<!-- <!DOCTYPE xsl:stylesheet [ -->
  <!-- <!ENTITY nbsp   "&#160;" > -->
<!-- ]> -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xalan="http://xml.apache.org/xslt"
                exclude-result-prefixes="xalan"
                version="1.0">

  <xsl:import href="summary_xml.xsl"/>

  <!-- whether to include dependencies -->
  <xsl:param name="include_dependencies" select="'1'"/>

  <xsl:template match="pkgdoc-summary | test-suite | package" mode="createSummary">
    <summary>
      <xsl:attribute name="packages">
        <xsl:value-of select="count(.//package)"/>
      </xsl:attribute>
      <xsl:attribute name="procedures">
        <xsl:value-of select="count(.//procedure)"/>
      </xsl:attribute>
      <xsl:if test="$include_dependencies = '1'">
        <xsl:attribute name="dependencies">
          <xsl:value-of select="count(.//dependency)"/>
        </xsl:attribute>
      </xsl:if>
    </summary>
  </xsl:template>

  <xsl:template match="procedure">
    <!-- suppress -->
  </xsl:template>

</xsl:stylesheet>
