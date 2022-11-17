<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>
<!-- <!DOCTYPE xsl:stylesheet [ -->
  <!-- <!ENTITY nbsp   "&#160;" > -->
<!-- ]> -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xalan="http://xml.apache.org/xslt"
                exclude-result-prefixes="xalan"
                version="1.0">

  <xsl:import href="qft_doc.xsl"/>

  <!-- whether to include local packages and procedures -->
  <xsl:param name="include_local" select="'0'"/>

  <!-- whether to include dependencies -->
  <xsl:param name="include_dependencies" select="'1'"/>

  <!-- {{{ Main nodes -->

  <xsl:template match="Package[@disabled='true' or ($include_local != '1' and starts-with(@name, '_'))]"/>

  <xsl:template match="Package">
    <xsl:call-template name="create-node">
      <xsl:with-param name="type" select="'package'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="Procedure[@disabled='true' or ($include_local != '1' and starts-with(@name, '_'))]"/>

  <xsl:template match="Procedure">
    <xsl:call-template name="create-node">
      <xsl:with-param name="type" select="'procedure'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="Dependency">
    <xsl:if test="$include_dependencies = '1'">
      <xsl:call-template name="create-node">
        <xsl:with-param name="type" select="'dependency'"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- Exclude Dependencies in tests -->
  <xsl:template match="TestSet/Dependency | TestCase/Dependency"/>

  <!-- Stop traversal at the following -->
  <xsl:template match="ExtraSequence | WindowList"/>

  <!-- }}} -->
  <!-- {{{ Fully qualified name -->

  <xsl:template name="qname">
    <xsl:for-each select="ancestor::Package">
      <xsl:value-of select="@name"/>
      <xsl:text>.</xsl:text>
    </xsl:for-each>
    <xsl:value-of select="@name"/>
  </xsl:template>

  <!-- }}} -->

</xsl:stylesheet>
