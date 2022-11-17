<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>
<!-- <!DOCTYPE xsl:stylesheet [ -->
  <!-- <!ENTITY nbsp   "&#160;" > -->
<!-- ]> -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xalan="http://xml.apache.org/xslt"
                exclude-result-prefixes="xalan"
                version="1.0">

  <xsl:import href="summary_xml.xsl"/>

  <!--
  This transformation is executed twice, once for each transformed test-suite and then again
  for the final report-summary.
  -->

  <!-- Key used to retrieve indirect nodes with ref=... -->
  <xsl:key name="refkey" match="*" use="@ref"/>


  <!-- {{{ report-summary -->

  <xsl:template match="report-summary">
    <report-summary>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="." mode="createSummary"/>
      <xsl:for-each select="test-suite">
        <xsl:sort select="summary/@timestamp"/>
        <!-- <xsl:apply-templates select="."/> -->
        <xsl:copy>
          <xsl:apply-templates select="@*|node()|text()" mode="copy"/>
        </xsl:copy>
      </xsl:for-each>
    </report-summary>
  </xsl:template>

  <xsl:template match="report-summary" mode="createSummary">
    <summary time="{@time}"
      duration="{@duration}"
      realtime="{@realtime}"
      exceptions="{sum(test-suite/summary/@exceptions)}"
      errors="{sum(test-suite/summary/@errors)}"
      expectederrors="{sum(test-suite/summary/@expectederrors)}"
      flakyexceptions="{sum(test-suite/summary/@flakyexceptions)}"
      flakyerrors="{sum(test-suite/summary/@flakyerrors)}"
      warnings="{sum(test-suite/summary/@warnings)}">
    <xsl:attribute name="tests">
      <xsl:value-of select="sum(test-suite/summary/@tests)"/>
    </xsl:attribute>
    <xsl:attribute name="executedtests">
      <xsl:value-of select="sum(test-suite/summary/@executedtests)"/>
    </xsl:attribute>
    <xsl:attribute name="passedtests">
      <xsl:value-of select="sum(test-suite/summary/@passedtests)"/>
    </xsl:attribute>
    <xsl:attribute name="failedtests">
      <xsl:value-of select="sum(test-suite/summary/@failedtests)"/>
    </xsl:attribute>
    <xsl:attribute name="expectedfailedtests">
      <xsl:value-of select="sum(test-suite/summary/@expectedfailedtests)"/>
    </xsl:attribute>
    <xsl:attribute name="exceptedtests">
      <xsl:value-of select="sum(test-suite/summary/@exceptedtests)"/>
    </xsl:attribute>
    <xsl:attribute name="skippedtests">
      <xsl:value-of select="sum(test-suite/summary/@skippedtests)"/>
    </xsl:attribute>
    <xsl:attribute name="skippedtestsets">
      <xsl:value-of select="sum(test-suite/summary/@skippedtestsets)"/>
    </xsl:attribute>
    <xsl:attribute name="nonimpltests">
      <xsl:value-of select="sum(test-suite/summary/@nonimpltests)"/>
    </xsl:attribute>
    </summary>
  </xsl:template>

  <xsl:template match="@*|node()" mode="copy">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()|text()" mode="copy"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="text()" mode="copy">
    <xsl:copy/>
  </xsl:template>

  <!-- }}} -->

  <xsl:template match="test-suite" mode="createSummary">
    <summary>
      <xsl:apply-templates select="summary/@*"/>
      <xsl:call-template name="count-tests"/>
    </summary>
    <!-- <xsl:apply-templates select=".//error[@ref] | .//exception[@ref] | .//check[@ref and @pstate &gt;= 2]"/> -->
    <xsl:for-each select=".//error[@link] | .//exception[@link] | .//check[@link and key('refkey', @link)/@pstate &gt;= 2]">
      <xsl:apply-templates select="key('refkey', @link)"/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="testset | testcase | summary">
      <!-- suppress -->
  </xsl:template>

  <xsl:template match="error | exception | check">
    <xsl:element name="{name()}">
      <xsl:attribute name="name">
        <xsl:value-of select="ancestor::testcase/@name"/>
      </xsl:attribute>
      <xsl:attribute name="qname">
        <xsl:value-of select="ancestor::testcase/@qname"/>
      </xsl:attribute>
      <xsl:attribute name="ref">
        <xsl:value-of select="ancestor::testcase/@ref"/>
      </xsl:attribute>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="*"/>
    </xsl:element>
  </xsl:template>

  <xsl:template name="count-tests">
    <xsl:variable name="good">
      <xsl:value-of select="count(.//testcase[@vstate &lt;= 1])"/>
    </xsl:variable>
    <xsl:variable name="failed">
      <xsl:value-of select="count(.//testcase[@vstate = 2 and not(@expectedfail = 'true')])"/>
    </xsl:variable>
    <xsl:variable name="expfailed">
      <xsl:value-of select="count(.//testcase[@vstate = 2 and @expectedfail = 'true'])"/>
    </xsl:variable>
    <xsl:variable name="excepted">
      <xsl:value-of select="count(.//testcase[@vstate = 3])"/>
    </xsl:variable>
    <xsl:variable name="skipped">
      <xsl:value-of select="count(.//testcase[@skipped = 'true'])"/>
    </xsl:variable>
    <xsl:variable name="skippedsets">
      <xsl:value-of select="count(.//testset[@skipped = 'true'])"/>
    </xsl:variable>
    <xsl:variable name="nonimpl">
      <xsl:value-of select="count(.//testcase[(not(@skipped) or @skipped != 'true') and @implemented = 'false'])"/>
    </xsl:variable>
    <xsl:attribute name="tests">
      <xsl:value-of select="$good + $failed + $expfailed + $excepted"/>
    </xsl:attribute>
    <xsl:attribute name="executedtests">
      <xsl:value-of select="$good + $failed + $expfailed + $excepted - $skipped - $nonimpl"/>
    </xsl:attribute>
    <xsl:attribute name="passedtests">
      <xsl:value-of select="$good - $skipped - $nonimpl"/>
    </xsl:attribute>
    <xsl:attribute name="failedtests">
      <xsl:value-of select="$failed"/>
    </xsl:attribute>
    <xsl:attribute name="expectedfailedtests">
      <xsl:value-of select="$expfailed"/>
    </xsl:attribute>
    <xsl:attribute name="exceptedtests">
      <xsl:value-of select="$excepted"/>
    </xsl:attribute>
    <xsl:attribute name="skippedtests">
      <xsl:value-of select="$skipped"/>
    </xsl:attribute>
    <xsl:attribute name="skippedtestsets">
      <xsl:value-of select="$skippedsets"/>
    </xsl:attribute>
    <xsl:attribute name="nonimpltests">
      <xsl:value-of select="$nonimpl"/>
    </xsl:attribute>
  </xsl:template>

</xsl:stylesheet>
