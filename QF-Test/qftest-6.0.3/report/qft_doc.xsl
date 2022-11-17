<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>
<!-- <!DOCTYPE xsl:stylesheet [ -->
  <!-- <!ENTITY nbsp   "&#160;" > -->
<!-- ]> -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xalan="http://xml.apache.org/xslt"
                exclude-result-prefixes="xalan"
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

  <!-- {{{ Default and root -->

  <!-- Entry point and default -->
  <xsl:template match="*">
    <xsl:apply-templates select="*"/>
  </xsl:template>

  <xsl:template match="@*">
    <xsl:copy/>
  </xsl:template>

  <!--
  The root node

  Create a test-suite node and iterate over the testsets
  -->
  <xsl:template match="/RootStep">
    <test-suite type="qftest" qftest-version="{@qfversion}">
      <xsl:apply-templates select="comment | userdef" mode="subnode"/>
      <xsl:apply-templates select="*"/>
    </test-suite>
  </xsl:template>

  <!-- }}} -->

  <!-- {{{ Main nodes -->

  <xsl:template name="create-node">
    <xsl:param name="type"/>
    <xsl:element name="{$type}">
      <xsl:attribute name="name">
        <xsl:value-of select="@name"/>
      </xsl:attribute>
      <xsl:attribute name="qname">
        <xsl:call-template name="qname"/>
      </xsl:attribute>
      <xsl:attribute name="ref">
        <xsl:value-of select="generate-id()"/>
      </xsl:attribute>
      <!-- Numbered attributes for screenshots -->
      <xsl:for-each select="attribute::*[starts-with(name(), 'sfile')]">
        <xsl:variable name="idx" select="substring-after(name(), 'sfile')"/>
        <screenshot>
          <xsl:attribute name="src">
            <xsl:value-of select="."/>
          </xsl:attribute>
          <xsl:attribute name="width">
            <xsl:value-of select="../attribute::*[name() = concat('swidth', $idx)]"/>
          </xsl:attribute>
          <xsl:attribute name="height">
            <xsl:value-of select="../attribute::*[name() = concat('sheight', $idx)]"/>
          </xsl:attribute>
          <xsl:if test="../attribute::*[name() = concat('title', $idx)]">
            <xsl:attribute name="title">
              <xsl:value-of select="../attribute::*[name() = concat('title', $idx)]"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="../attribute::*[name() = concat('tfile', $idx)]">
            <thumbnail>
              <xsl:attribute name="src">
                <xsl:value-of select="../attribute::*[name() = concat('tfile', $idx)]"/>
              </xsl:attribute>
              <xsl:attribute name="width">
                <xsl:value-of select="../attribute::*[name() = concat('twidth', $idx)]"/>
              </xsl:attribute>
              <xsl:attribute name="height">
                <xsl:value-of select="../attribute::*[name() = concat('theight', $idx)]"/>
              </xsl:attribute>
            </thumbnail>
          </xsl:if>
        </screenshot>
      </xsl:for-each>
      <xsl:apply-templates select="." mode="extra-attributes"/>
      <xsl:call-template name="copy-id"/>
      <xsl:choose>
        <xsl:when test="@comment">
          <!-- Can be set only via a NodeResolver -->
          <comment>
            <xsl:value-of select="@comment"/>
          </comment>
          <xsl:apply-templates select="userdef" mode="subnode"/>
        </xsl:when>
        <xsl:otherwise>
          <!-- The default -->
          <xsl:apply-templates select="comment | userdef" mode="subnode"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="*" mode="extra-attributes">
    <!-- Do nothing -->
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ Extra nodes -->

  <xsl:template match="comment | userdef" mode="subnode">
    <xsl:element name="{name()}">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="*" mode="subnode">
    <!-- Do nothing -->
  </xsl:template>

  <!-- }}} -->

  <!-- {{{ Helper templates -->

  <xsl:template name="copy-id">
      <xsl:if test="@id and not(starts-with(@id, '_'))">
        <xsl:attribute name="nodeid">
          <xsl:value-of select="@id"/>
        </xsl:attribute>
      </xsl:if>
  </xsl:template>

  <!-- }}} -->

</xsl:stylesheet>
