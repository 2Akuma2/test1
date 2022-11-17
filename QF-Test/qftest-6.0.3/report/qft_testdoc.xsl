<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>
<!-- <!DOCTYPE xsl:stylesheet [ -->
  <!-- <!ENTITY nbsp   "&#160;" > -->
<!-- ]> -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xalan="http://xml.apache.org/xslt"
                version="1.0">

  <xsl:import href="qft_doc.xsl"/>

  <!-- {{{ Main nodes -->

  <xsl:template match="TestSet[@disabled='true']"/>

  <xsl:template match="TestSet">
    <xsl:call-template name="create-node">
      <xsl:with-param name="type" select="'testset'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="TestCase[@disabled='true']"/>

  <xsl:template match="TestCase">
    <xsl:call-template name="create-node">
      <xsl:with-param name="type" select="'testcase'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="TestCase[@disabled='true']" mode="extra-attributes"/>

  <xsl:template match="TestCase" mode="extra-attributes">
    <xsl:if test="@implemented">
      <xsl:attribute name="implemented">
        <xsl:value-of select="@implemented"/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <xsl:template match="TestStep[@disabled='true']"/>

  <xsl:template match="TestStep">
    <xsl:call-template name="create-node">
      <xsl:with-param name="type" select="'teststep'"/>
    </xsl:call-template>
  </xsl:template>

  <!-- Stop traversal at the following -->
  <xsl:template match="PackageRoot | ExtraSequence | WindowList"/>

  <!-- }}} -->
  <!-- {{{ Fully qualified name -->

  <xsl:template name="qname">
    <xsl:for-each select="ancestor::TestSet">
      <xsl:value-of select="@name"/>
      <xsl:text>.</xsl:text>
    </xsl:for-each>
    <xsl:value-of select="@name"/>
  </xsl:template>

  <!-- }}} -->

</xsl:stylesheet>
