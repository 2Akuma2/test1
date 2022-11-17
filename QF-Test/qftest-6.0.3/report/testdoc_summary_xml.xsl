<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>
<!-- <!DOCTYPE xsl:stylesheet [ -->
  <!-- <!ENTITY nbsp   "&#160;" > -->
<!-- ]> -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xalan="http://xml.apache.org/xslt"
                exclude-result-prefixes="xalan"
                version="1.0">

  <xsl:import href="summary_xml.xsl"/>

  <xsl:template match="testdoc-summary | test-suite | testset" mode="createSummary">
    <!-- Not yet implemented -->
    <!-- <xsl:variable name="impl"> -->
      <!-- <xsl:value-of select="count(.//testcase[@implemented='true'])"/> -->
    <!-- </xsl:variable> -->
    <!-- <xsl:variable name="nonimpl"> -->
      <!-- <xsl:value-of select="count(.//testcase[@implemented='false'])"/> -->
    <!-- </xsl:variable> -->
    <summary>
      <xsl:attribute name="testsets">
        <xsl:value-of select="count(.//testset)"/>
      </xsl:attribute>
      <xsl:attribute name="testcases">
        <xsl:value-of select="count(.//testcase)"/>
      </xsl:attribute>
      <!-- Not yet implemented -->
      <!-- <xsl:attribute name="totalcases"> -->
        <!-- <xsl:value-of select="$impl + $nonimpl"/> -->
      <!-- </xsl:attribute> -->
      <!-- <xsl:attribute name="implcases"> -->
        <!-- <xsl:value-of select="$impl"/> -->
      <!-- </xsl:attribute> -->
      <!-- <xsl:attribute name="nonimplcases"> -->
        <!-- <xsl:value-of select="$nonimpl"/> -->
      <!-- </xsl:attribute> -->
      <!-- <xsl:attribute name="percentimpl"> -->
        <!-- <xsl:choose> -->
          <!-- <xsl:when test="$impl + $nonimpl > 0"> -->
            <!-- <xsl:value-of select="floor (100 * $impl div ($nonimpl + $impl))"/> -->
          <!-- </xsl:when> -->
          <!-- <xsl:otherwise> -->
            <!-- <xsl:text>0</xsl:text> -->
          <!-- </xsl:otherwise> -->
        <!-- </xsl:choose> -->
      <!-- </xsl:attribute> -->
    </summary>
  </xsl:template>

  <xsl:template match="testcase">
    <!-- suppress -->
  </xsl:template>

</xsl:stylesheet>
