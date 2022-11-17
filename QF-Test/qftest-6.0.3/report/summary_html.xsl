<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [
<!-- Some entities which can be modified by the user-->
<!-- Blank-space-->
  <!ENTITY nbsp   "&#160;" >
<!-- White color used as background-->
  <!ENTITY white   "#ffffff" >
<!-- The color of the text boxes-->
  <!ENTITY pane-color   "#ededed" >
<!-- The color of the framed characters in the no-icon mode-->
  <!ENTITY warning-color   "#ffca00" >
  <!ENTITY error-color   "#ff0000" >
  <!ENTITY show-border   "0" >
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xalan="http://xml.apache.org/xslt"
                version="1.0">


  <xsl:output method="html"
              encoding="ISO-8859-1"
              indent="yes"
              xalan:indent-amount="2"
              doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"/>

  <!-- Parameter for the target language. Currently only 'de' is recognized,
  everything else results in an English report
  -->
  <xsl:param name="lang" select="'en'"/>

  <!-- {{{ Default operations -->

  <!-- Copy nodes -->
  <xsl:template match="*" priority="-.1">
    <!-- We don't use copy to avoid copying possible namespace nodes -->
    <xsl:element name="{name()}">
      <xsl:apply-templates select="* | @* | text() | comment()"/>
    </xsl:element>
  </xsl:template>

  <!-- Copy attributes -->
  <xsl:template match="@*">
    <xsl:copy/>
  </xsl:template>

  <!-- Copy text -->
  <xsl:template match="text()">
    <xsl:copy/>
  </xsl:template>

  <xsl:template match="*" mode="row">
  </xsl:template>

  <!-- }}} -->

  <!-- {{{ root node -->

  <xsl:template match="testdoc-summary | pkgdoc-summary">
    <xsl:apply-templates select="summary"/>
    <xsl:call-template name="list-test-suites"/>
    <xsl:call-template name="list-branches"/>
  </xsl:template>

  <!-- }}} -->

  <!-- {{{ List of test-suites -->

  <xsl:template name="list-test-suites">
    <hr/>
    <h2>Test-suites</h2>
    <table class="suites" border="1" width="100%">
      <tr>
        <th>
          <xsl:text>Suite</xsl:text>
        </th>
        <th>
          <xsl:text>Description</xsl:text>
        </th>
        <xsl:call-template name="suite-headers"/>
      </tr>
      <xsl:for-each select="test-suite">
        <xsl:sort select="@sourcefile"/>
        <xsl:apply-templates select="." mode="row">
          <xsl:with-param name="pos" select="position()"/>
        </xsl:apply-templates>
      </xsl:for-each>
    </table>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ One test-suite row -->

  <xsl:template match="test-suite" mode="row">
    <xsl:param name="pos" select="1"/>
    <tr>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="$pos mod 2 = 0">
            <xsl:text>b</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>a</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <td>
        <xsl:call-template name="link-source"/>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="comment">
            <xsl:apply-templates select="comment" mode="sentence"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>&nbsp;</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <xsl:apply-templates select="." mode="suite-details"/>
    </tr>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ List of branches -->

  <xsl:template name="list-branches">
    <hr/>
    <h2><xsl:call-template name="get-branch-overview-title"/></h2>
    <table class="branch" border="1" width="100%">
      <tr>
        <xsl:call-template name="branch-headers"/>
      </tr>
      <xsl:for-each select=".//testset | .//package">
        <xsl:sort select="concat(ancestor::test-suite/@sourcefile, '#', @qname)"/>
        <xsl:apply-templates select="." mode="row">
          <xsl:with-param name="pos" select="position()"/>
        </xsl:apply-templates>
      </xsl:for-each>
    </table>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ One branch row -->

  <xsl:template match="testset | package" mode="row">
    <xsl:param name="pos" select="1"/>
    <xsl:variable name="file">
      <xsl:value-of select="ancestor::test-suite/@sourcefile"/>
    </xsl:variable>
    <tr>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="$pos mod 2 = 0">
            <xsl:text>b</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>a</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <td>
        <a href="{ancestor::test-suite/@hfile}#{@ref}">
          <xsl:value-of select="concat($file, '#', @qname)"/>
        </a>
        <xsl:text> (</xsl:text>
        <a href="{/testdoc-summary/@sourcedir}/{$file}"><xsl:text>open</xsl:text></a>
        <xsl:text>)</xsl:text>
      </td>
      <td>
        <xsl:apply-templates select="comment" mode="sentence"/>
      </td>
      <xsl:apply-templates select="." mode="branch-details"/>
    </tr>
  </xsl:template>

  <!-- }}} -->

  <!-- {{{ First sentence -->

  <!-- Print the first sentence of a piece of text only. -->
  <xsl:template match="text()" mode="sentence">
    <xsl:choose>
      <xsl:when test="contains(., '.')">
        <xsl:value-of select="substring-before(., '.')"/>
        <xsl:text>.</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="pass_through"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ Link to source -->

  <xsl:template name="link-source">
    <a href="{@hfile}">
      <xsl:value-of select="@sourcefile"/>
    </a>
    <xsl:text> (</xsl:text>
    <a href="{../@sourcedir}/{@sourcefile}"><xsl:text>open</xsl:text></a>
    <xsl:text>)</xsl:text>
  </xsl:template>

  <!-- }}} -->

</xsl:stylesheet>
