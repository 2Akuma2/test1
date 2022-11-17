<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp   "&#160;" >
  <!ENTITY larr   "&#8592;" >
  <!ENTITY rarr   "&#8594;" >
  <!ENTITY uarr   "&#8593;" >

  <!ENTITY detailNodes ".//teststep | .//message[not(ancestor::summary)] | .//check[@link]
                        | .//error[@link] | .//exception[@link] | .//warning[@link]
                        | .//dependency | .//setup | .//cleanup
                        | .//screenshot[not(ancestor::summary)]" >
  <!ENTITY ancestorTeststepNodes  "ancestor::teststep | ancestor::dependency
                                   | ancestor::setup | ancestor::cleanup" >
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xalan="http://xml.apache.org/xslt"
                exclude-result-prefixes="xalan"
                version="1.0">

  <xsl:import href="doc_html.xsl"/>

  <!-- Key used to retrieve indirect nodes with ref=... -->
  <xsl:key name="refkey" match="*" use="@ref"/>


  <!-- {{{ Parameters -->

  <!-- Whether to show thumbnails -->
  <xsl:param name="thumbnails" select="0"/>

  <!-- Whether to show teststeps -->
  <xsl:param name="teststeps" select="1"/>

  <!-- Whether to ignore skipped nodes -->
  <xsl:param name="ignoreskipped" select="0"/>

  <!-- Whether to ignore not implemented nodes -->
  <xsl:param name="ignorenotimplemented" select="0"/>

  <!-- Whether to create a pie chart -->
  <xsl:param name="piechart" select="0"/>
  
  <!-- Whether to use the suitename instead of the basename -->
  <xsl:param name="includesuitename" select="1"/>

  <!-- }}} -->

  <!-- {{{ Entrypoint -->

  <xsl:template match="/">
    <xsl:call-template name="entrypoint">
      <xsl:with-param name="kind" select="'report'"/>
    </xsl:call-template>
  </xsl:template >

  <!-- }}} -->
  <!-- {{{ Report summary root node -->

  <xsl:template match="/report-summary">
    <section class="summarylegend gutter-left">
      <div class="summary">
        <h2 class="reportsummarytitle">
          <xsl:call-template name="lc-summary"/>
        </h2>

        <div class="reportsummary" cellspacing="0">
          <xsl:if test="@reportname and @reportname != ''">
            <div>
              <div class="label">
                <xsl:call-template name="lc-reportname"/>
              </div>
              <div><xsl:value-of select="@reportname"/></div>
            </div>
          </xsl:if>
          <div>
            <div class="label">
              <xsl:call-template name="lc-starttime"/>
            </div>
            <div><xsl:value-of select="@execution-date"/></div>
          </div>
          <div>
            <div class="label">
              <xsl:call-template name="lc-runid"/>
            </div>
            <div><xsl:value-of select="@runid"/></div>
          </div>
          <div>
            <div class="label">
              <xsl:call-template name="lc-executedby"/>
            </div>
            <div><xsl:value-of select="@executed-by"/></div>
          </div>
          <div>
            <div class="label">
              <xsl:call-template name="lc-host"/>
            </div>
            <div><xsl:value-of select="@host"/></div>
          </div>
          <div>
            <div class="label">
              <xsl:call-template name="lc-os"/>
            </div>
            <div><xsl:value-of select="@os-version"/></div>
          </div>
          <xsl:if test="@java-version">
            <div>
              <div class="label">
                <xsl:call-template name="lc-javaversion"/>
              </div>
              <div><xsl:value-of select="@java-version"/></div>
            </div>
          </xsl:if>
          <xsl:if test="@qftest-version">
            <div>
              <div class="label">
                <xsl:call-template name="lc-qftestversion"/>
              </div>
              <div><xsl:value-of select="@qftest-version"/></div>
            </div>
          </xsl:if>
        </div>
      </div>
      <div class="chart">
        <xsl:call-template name="create-chart">
          <xsl:with-param name="tests" select="summary/@tests"/>
          <xsl:with-param name="kind" select="'summary'"/>
        </xsl:call-template>
      </div>
      <div class="legendcontainer">
        <xsl:call-template name="create-legend"/>
      </div>
    </section>

    <section class="reportresult">
      <table class="reportresult" cellspacing="0">
        <tr>
          <th class="margin"/>
          <th class="result">
            <xsl:call-template name="lc-totalresult"/>
          </th>
          <xsl:call-template name="create-th-tests"/>
          <xsl:call-template name="create-th-excepted"/>
          <xsl:call-template name="create-th-failed"/>
          <xsl:call-template name="create-th-expfailed"/>
          <xsl:call-template name="create-th-passed"/>
          <xsl:if test="$ignoreskipped = 0">
            <xsl:call-template name="create-th-skipped"/>
            <xsl:call-template name="create-th-skippedsets"/>
          </xsl:if>
          <xsl:if test="$ignorenotimplemented = 0">
            <xsl:call-template name="create-th-notimpl"/>
          </xsl:if>
          <xsl:call-template name="create-th-executed"/>
          <xsl:call-template name="create-th-percent"/>
          <xsl:call-template name="create-th-duration"/>
          <xsl:call-template name="create-th-realtime"/>
        </tr>
        <tr>
          <td class="marginicon">
            <xsl:call-template name="create-result-img"/>
          </td>
          <td class="result">
            <xsl:apply-templates select="." mode="result-list"/>
          </td>
          <td class="tests">
            <xsl:if test="$ignoreskipped = 0 and summary/@skippedtestsets > 0">
              <xsl:text>&gt;</xsl:text>
            </xsl:if>
            <xsl:value-of select="summary/@tests"/>
          </td>
          <td class="excepted">
            <xsl:value-of select="summary/@exceptedtests"/>
          </td>
          <td class="failed">
            <xsl:value-of select="summary/@failedtests"/>
          </td>
          <td class="expfailed">
            <xsl:value-of select="summary/@expectedfailedtests"/>
          </td>
          <td class="passed">
            <xsl:value-of select="summary/@passedtests"/>
          </td>
          <xsl:if test="$ignoreskipped = 0">
            <td class="skipped">
              <xsl:if test="summary/@skippedtestsets > 0">
                <xsl:text>&gt;</xsl:text>
              </xsl:if>
              <xsl:value-of select="summary/@skippedtests"/>
            </td>
            <td class="skippedsets">
              <xsl:value-of select="summary/@skippedtestsets"/>
            </td>
          </xsl:if>
          <xsl:if test="$ignorenotimplemented = 0">
            <td class="notimpl">
              <xsl:value-of select="summary/@nonimpltests"/>
            </td>
          </xsl:if>
          <td class="executed">
            <xsl:value-of select="summary/@executedtests"/>
          </td>
          <td class="percent">
            <xsl:call-template name="percent">
              <xsl:with-param name="numerator" select="summary/@passedtests"/>
              <xsl:with-param name="denominator" select="summary/@executedtests"/>
            </xsl:call-template>
          </td>
          <td class="duration">
            <xsl:call-template name="duration-text">
              <xsl:with-param name="duration" select="summary/@duration"/>
            </xsl:call-template>
          </td>
          <td class="realtime">
            <xsl:call-template name="duration-text">
              <xsl:with-param name="duration" select="summary/@realtime"/>
            </xsl:call-template>
          </td>
        </tr>
      </table>
      <xsl:if test="comment">
        <table>
          <tr>
            <td class="margin"/>
            <td class="comment">
              <xsl:apply-templates select="comment" mode="description"/>
            </td>
          </tr>
        </table>
      </xsl:if>
    </section>
    <!-- Local navigation links -->
    <xsl:if test=".//test-suite |
                  .//error[@ref] | .//exception[@ref] | .//check[@ref and @pstate &gt;= 2]">
      <nav class="reportnav">
        <xsl:if test=".//test-suite">
          <a href="#allsuites">
            <xsl:call-template name="lc-suitesoverview"/>
          </a>
        </xsl:if>
        <xsl:if test=".//test-suite[@vstate &gt; 1]">
          <a href="#allerrorsuites">
            <xsl:call-template name="lc-errorsuitesoverview"/>
          </a>
        </xsl:if>
        <xsl:if test=".//error[@ref] | .//exception[@ref] | .//check[@ref and @pstate &gt;= 2]">
          <a href="#allerrors">
            <xsl:call-template name="lc-errorsoverview"/>
          </a>
        </xsl:if>
      </nav>
    </xsl:if>
    <xsl:call-template name="list-all-suites"/>
    <xsl:call-template name="list-all-suites-with-errors"/>
    <xsl:call-template name="list-all-errors"/>
    <xsl:call-template name="list-all-warnings"/>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ Test-suite root node -->

  <xsl:template match="/test-suite">
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
    <xsl:variable name="executedtests">
      <xsl:value-of select="$good + $failed + $expfailed + $excepted - $skipped - $nonimpl"/>
    </xsl:variable>
    <xsl:variable name="tests">
      <xsl:value-of select="$good + $failed + $expfailed + $excepted"/>
    </xsl:variable>
    <section class="summarylegend gutter-left">
      <div class="summary">
        <h2 class="suitesummarytitle">
          <xsl:call-template name="lc-summary"/>
        </h2>

        <div class="suitesummary">
          <xsl:variable name="suitename">
            <xsl:value-of select="@suitename"/>
          </xsl:variable>
          <xsl:if test="$includesuitename = 1 and $suitename and $suitename != ''">
          <div>
            <div class="label">
              <xsl:call-template name="lc-testsuite-name"/>
            </div>
            <div>
              <div><xsl:value-of select="$suitename"/></div>
            </div>
          </div>
          </xsl:if>
          <div>
            <div class="label">
              <xsl:call-template name="lc-testsuite-file"/>
            </div>
            <div>
              <xsl:call-template name="basename">
                <xsl:with-param name="file" select="@relname"/>
              </xsl:call-template>
            </div>
          </div>
          <div>
            <div class="label">
              <xsl:call-template name="lc-directory"/>
            </div>
            <div>
              <xsl:call-template name="dirname">
                <xsl:with-param name="file" select="@relname"/>
              </xsl:call-template>
            </div>
          </div>
          <div>
            <div class="label">
              <xsl:call-template name="lc-runid"/>
            </div>
            <div><xsl:value-of select="@runid"/></div>
          </div>
          <div>
            <div class="label">
              <xsl:call-template name="lc-starttime"/>
            </div>
            <div><xsl:value-of select="@execution-date"/></div>
          </div>
          <div>
            <div class="label">
              <xsl:call-template name="lc-executedby"/>
            </div>
            <div><xsl:value-of select="@executed-by"/></div>
          </div>
          <div>
            <div class="label">
              <xsl:call-template name="lc-host"/>
            </div>
            <div><xsl:value-of select="@host"/></div>
          </div>
          <div>
            <div class="label">
              <xsl:call-template name="lc-os"/>
            </div>
            <div><xsl:value-of select="@os-version"/></div>
          </div>
          <xsl:if test="@java-version">
            <div>
              <div class="label">
                <xsl:call-template name="lc-javaversion"/>
              </div>
              <div><xsl:value-of select="@java-version"/></div>
            </div>
          </xsl:if>
          <xsl:if test="@qftest-version">
            <div>
              <div class="label">
                <xsl:call-template name="lc-qftestversion"/>
              </div>
              <div><xsl:value-of select="@qftest-version"/></div>
            </div>
          </xsl:if>
        </div>
      </div>
      <div class="chart">
        <xsl:call-template name="create-chart">
          <xsl:with-param name="tests" select="$tests"/>
          <xsl:with-param name="kind" select="'testsuite'"/>
        </xsl:call-template>
      </div>
      <div class="legendcontainer">
        <xsl:call-template name="create-legend"/>
      </div>
    </section>

    <xsl:if test="comment">
      <section class="suitedesc gutter-left">
        <div class="test-suitedesc">
          <xsl:apply-templates select="." mode="description"/>
        </div>
      </section>
    </xsl:if>

    <section class="suiteresult">
      <table class="suiteresult" cellspacing="0">
        <tr>
          <th class="margin"/>
          <th class="result">
            <xsl:call-template name="lc-totalresult"/>
          </th>
          <xsl:call-template name="create-th-tests"/>
          <xsl:call-template name="create-th-excepted"/>
          <xsl:call-template name="create-th-failed"/>
          <xsl:call-template name="create-th-expfailed"/>
          <xsl:call-template name="create-th-passed"/>
          <xsl:if test="$ignoreskipped = 0">
            <xsl:call-template name="create-th-skipped"/>
            <xsl:call-template name="create-th-skippedsets"/>
          </xsl:if>
          <xsl:if test="$ignorenotimplemented = 0">
            <xsl:call-template name="create-th-notimpl"/>
          </xsl:if>
          <xsl:call-template name="create-th-executed"/>
          <xsl:call-template name="create-th-percent"/>
          <xsl:call-template name="create-th-duration"/>
          <xsl:call-template name="create-th-realtime"/>
        </tr>
        <tr>
          <td class="marginicon">
            <xsl:call-template name="create-result-img"/>
          </td>
          <td class="result">
            <xsl:apply-templates select="." mode="result-list"/>
          </td>
          <td class="tests">
            <xsl:if test="$ignoreskipped = 0 and $skippedsets > 0">
              <xsl:text>&gt;</xsl:text>
            </xsl:if>
            <xsl:value-of select="$tests"/>
          </td>
          <td class="excepted">
            <xsl:value-of select="$excepted"/>
          </td>
          <td class="failed">
            <xsl:value-of select="$failed"/>
          </td>
          <td class="expfailed">
            <xsl:value-of select="$expfailed"/>
          </td>
          <td class="passed">
            <xsl:value-of select="$good - $skipped - $nonimpl"/>
          </td>
          <xsl:if test="$ignoreskipped = 0">
            <td class="skipped">
              <xsl:if test="$skippedsets > 0">
                <xsl:text>&gt;</xsl:text>
              </xsl:if>
              <xsl:value-of select="$skipped"/>
            </td>
            <td class="skippedsets">
              <xsl:value-of select="$skippedsets"/>
            </td>
          </xsl:if>
          <xsl:if test="$ignorenotimplemented = 0">
            <td class="notimpl">
              <xsl:value-of select="$nonimpl"/>
            </td>
          </xsl:if>
          <td class="executed">
            <xsl:value-of select="$executedtests"/>
          </td>
          <td class="percent">
            <xsl:call-template name="percent">
              <xsl:with-param name="numerator" select="$good - $skipped - $nonimpl"/>
              <xsl:with-param name="denominator" select="$executedtests"/>
            </xsl:call-template>
          </td>
          <td class="duration">
            <xsl:call-template name="duration-text">
              <xsl:with-param name="duration" select="summary/@duration"/>
            </xsl:call-template>
          </td>
          <td class="realtime">
            <xsl:call-template name="duration-text">
              <xsl:with-param name="duration" select="summary/@realtime"/>
            </xsl:call-template>
          </td>
        </tr>
      </table>
    </section>
    <!-- Local navigation links -->
    <xsl:if test=".//testset |
                  .//testcase |
                  .//error[@ref] | .//exception[@ref] | .//check[@ref and @pstate &gt;= 2] |
                  .//warning[@ref] | .//check[@ref and @pstate = 1]">
      <nav class="reportnav">
        <xsl:if test=".//testset">
          <a href="#alltestsets">
            <xsl:call-template name="lc-testsetsoverview"/>
          </a>
        </xsl:if>
        <xsl:if test=".//testcase">
          <a href="#alltestcases">
            <xsl:call-template name="lc-testsetsandtestcasesoverview"/>
          </a>
        </xsl:if>
        <xsl:if test=".//error[@ref] | .//exception[@ref] | .//check[@ref and @pstate &gt;= 2]">
          <a href="#allerrors">
            <xsl:call-template name="lc-errorsoverview"/>
          </a>
        </xsl:if>
        <xsl:if test=".//warning[@ref] | .//check[@ref and @pstate = 1]">
          <a href="#allwarnings">
            <xsl:call-template name="lc-warningsoverview"/>
          </a>
        </xsl:if>
        <xsl:if test=".//testset | .//testcase">
          <a href="#details">
            <xsl:call-template name="lc-details"/>
          </a>
        </xsl:if>
      </nav>
    </xsl:if>
    <xsl:call-template name="list-all-branches"/>
    <xsl:call-template name="list-all-branches-and-leaves">
      <xsl:with-param name="kind" select="'report'"/>
    </xsl:call-template>
    <xsl:call-template name="list-all-errors">
      <xsl:with-param name="kind" select="'suite'"/>
    </xsl:call-template>
    <xsl:call-template name="list-all-warnings">
      <xsl:with-param name="kind" select="'suite'"/>
    </xsl:call-template>
    <div class="details">
      <nav class="detailslinks overviewlinks gutter-left">
        <a name="details"/>
        <xsl:for-each select="ancestor-or-self::*">
          <xsl:apply-templates select="." mode="links"/>
        </xsl:for-each>
      </nav>

      <h2 class="detailstitle gutter-left">
        <xsl:call-template name="lc-details"/>
      </h2>
    </div>
    <!-- top-level leaves outside any branch -->
    <xsl:apply-templates select="testcase" mode="leaf"/>
    <!-- one level of branches -->
    <xsl:apply-templates select="testset" mode="branch"/>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ Abstract calls and overrides -->

  <!-- {{{ doctitle -->

  <xsl:template match="*" mode="doctitle"/>

  <xsl:template match="/" mode="doctitle">
    <xsl:apply-templates mode="doctitle"/>
  </xsl:template>

  <xsl:template match="report-summary" mode="doctitle">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Testbericht Zusammenfassung</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Test Report Summary</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="test-suite" mode="doctitle">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Testbericht für </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Test Report for </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="title">
        <xsl:value-of select="title"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="name">
          <xsl:call-template name="basename">
            <xsl:with-param name="file" select="@name"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="suitename">
          <xsl:value-of select="@suitename"/>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$lang='de'">
            <xsl:text>Testsuite</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>Test-suite</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="$includesuitename = 1 and $suitename and $suitename != ''">
            <xsl:text> </xsl:text>
            <xsl:value-of select="$suitename"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$name and $name != ''">
              <xsl:text> </xsl:text>
              <xsl:value-of select="$name"/>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ links -->

  <!-- create a link to the summary document -->
  <xsl:template match="report-summary" mode="links">
    <a class="nav-link report-summary-link">
      <xsl:apply-templates select="." mode="link-to"/>
      <xsl:choose>
        <xsl:when test="@reportname">
          <xsl:value-of select="@reportname"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="lc-summary"/>
        </xsl:otherwise>
      </xsl:choose>
    </a>
  </xsl:template>

  <xsl:template match="test-suite" mode="summarylink">
    <a class="nav-link test-suite-link">
      <xsl:attribute name="href">
        <xsl:call-template name="basedir"/>
        <xsl:text>report.html</xsl:text>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="$reportname and $reportname != ''">
          <xsl:value-of select="$reportname"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="lc-summary"/>
        </xsl:otherwise>
      </xsl:choose>
    </a>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ linkname -->

  <!-- for test-suite: use the test suite name or the run-log filename -->
  <xsl:template match="test-suite" mode="linkname">
    <xsl:variable name="suitename">
      <xsl:value-of select="@suitename"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$includesuitename = 1 and $suitename and $suitename != ''">
        <xsl:value-of select="$suitename"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@relname"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="report-summary" mode="linkname">
  </xsl:template>

  <!-- }}} -->

  <!-- Error overview -->
  <!-- {{{ list-all-errors -->

  <xsl:template name="list-all-errors">
    <xsl:param name="kind" select="'summary'"/>
    <xsl:if test=".//error[@ref] | .//exception[@ref] | .//check[@ref and @pstate &gt;= 2]">
      <div class="allerrors branch">
        <nav class="allerrorslinks overviewlinks gutter-left">
          <a name="allerrors"/>
          <xsl:for-each select="ancestor-or-self::*">
            <xsl:apply-templates select="." mode="links"/>
          </xsl:for-each>
        </nav>

        <h2 class="allerrorstitle gutter-left">
          <xsl:call-template name="lc-errorsoverview"/>
        </h2>

        <table class="allerrorslist" cellspacing="0">
          <tr class="headers">
            <th class="margin"/>
            <xsl:if test="$kind='summary'">
              <th class="testsuite">
                <xsl:call-template name="lc-Testsuite"/>
              </th>
              <th class="runid">
                <xsl:call-template name="lc-runid"/>
              </th>
            </xsl:if>
            <th class="testcase">
              <xsl:call-template name="lc-testcase"/>
            </th>
            <th class="message">
              <xsl:call-template name="lc-message"/>
            </th>
            <th class="screenshot">
              <xsl:call-template name="lc-screenshot"/>
            </th>
          </tr>

          <xsl:choose>
            <xsl:when test="$kind='summary'">
              <xsl:for-each select=".//exception[@ref] | .//error[@ref] | .//check[@ref and @pstate &gt;= 2]">
                <xsl:apply-templates select="." mode="single-error">
                  <xsl:with-param name="kind" select="$kind"/>
                  <xsl:with-param name="rowNr" select="position()"/>
                </xsl:apply-templates>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select=".//exception[@link]
                                    | .//error[@link]
                                    | .//check[@link and key('refkey', @link)/@pstate &gt;= 2]">
                <xsl:apply-templates select="key('refkey', @link)" mode="single-error">
                  <xsl:with-param name="kind" select="$kind"/>
                  <xsl:with-param name="rowNr" select="position()"/>
                </xsl:apply-templates>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
        </table>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="exception | error | check" mode="single-error">
    <xsl:param name="kind" select="'summary'"/>
    <xsl:param name="rowNr" select="0" />
    <tr>
      <td class="marginicon">
        <a name="{@ref}"/>
        <xsl:choose>
          <xsl:when test="name() = 'exception'">
            <xsl:choose>
              <xsl:when test="@flaky='true'">
                <xsl:call-template name="create-img-flakyexception"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="create-img-exception"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="name() = 'error' or (name() = 'check' and @pstate = 2)">
            <xsl:choose>
              <xsl:when test="@flaky='true'">
                <xsl:call-template name="create-img-flakyerror"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="@expectedfail='true'">
                    <xsl:call-template name="create-img-experror"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="create-img-error"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="pstate=3">
                <xsl:choose>
                  <xsl:when test="@flaky='true'">
                    <xsl:call-template name="create-img-flakyexception"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="create-img-exception"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="@flaky='true'">
                    <xsl:call-template name="create-img-flakyerror"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:choose>
                      <xsl:when test="ancestor::testcase/@expectedfail='true'">
                        <xsl:call-template name="create-img-experror"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:call-template name="create-img-error"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <xsl:if test="$kind='summary'">
        <td class="testsuite">
          <a>
            <xsl:variable name="suitename">
              <xsl:value-of select="ancestor::test-suite/@suitename"/>
            </xsl:variable>
            <xsl:attribute name="href">
              <xsl:call-template name="subst-hash">
                <xsl:with-param name="text" select="ancestor::test-suite/@hfile"/>
              </xsl:call-template>
            </xsl:attribute>
            <xsl:choose>
              <xsl:when test="$includesuitename = 1 and $suitename and $suitename != ''">
                <xsl:attribute name="title">
                  <xsl:call-template name="basename">
                    <xsl:with-param name="file" select="ancestor::test-suite/@relname"/>
                  </xsl:call-template>
                </xsl:attribute>
                <xsl:value-of select="$suitename"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="basename">
                  <xsl:with-param name="file" select="ancestor::test-suite/@relname"/>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </a>
        </td>
        <td class="testsuite">
          <xsl:value-of select="ancestor::test-suite/@runid"/>
        </td>
      </xsl:if>
      <td class="testcase">
        <div class="possibleScroll">
          <xsl:choose>
            <xsl:when test="$nodeicons=1">
              <div class="withicon">
                <xsl:if test="ancestor::testcase">
                  <div class="icon">
                    <xsl:call-template name="create-testcase-icon"/>
                  </div>
                </xsl:if>
                <div class="item">
                  <a>
                    <xsl:choose>
                      <xsl:when test="$kind='summary'">
                        <xsl:choose>
                          <xsl:when test="@name and @name != ''">
                            <xsl:attribute name="href">
                              <xsl:call-template name="subst-hash">
                                <xsl:with-param name="text" select="ancestor::test-suite/@hfile"/>
                              </xsl:call-template>
                              <xsl:text>#</xsl:text>
                              <xsl:value-of select="@ref"/>
                            </xsl:attribute>
                            <xsl:value-of select="@name"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:text>-</xsl:text>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:choose>
                          <xsl:when test="ancestor::testcase">
                            <xsl:attribute name="href">
                              <xsl:text>#</xsl:text>
                              <xsl:value-of select="ancestor::testcase/@ref"/>
                            </xsl:attribute>
                            <xsl:value-of select="ancestor::testcase/@name"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:text>-</xsl:text>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                  </a>
                </div>
              </div>
            </xsl:when>
            <xsl:otherwise>
              <a>
                <xsl:choose>
                  <xsl:when test="$kind='summary'">
                    <xsl:choose>
                      <xsl:when test="@name and @name != ''">
                        <xsl:attribute name="href">
                          <xsl:call-template name="subst-hash">
                            <xsl:with-param name="text" select="ancestor::test-suite/@hfile"/>
                          </xsl:call-template>
                          <xsl:text>#</xsl:text>
                          <xsl:value-of select="@ref"/>
                        </xsl:attribute>
                        <xsl:value-of select="@name"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:text>-</xsl:text>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:choose>
                      <xsl:when test="ancestor::testcase">
                        <xsl:attribute name="href">
                          <xsl:text>#</xsl:text>
                          <xsl:value-of select="ancestor::testcase/@ref"/>
                        </xsl:attribute>
                        <xsl:value-of select="ancestor::testcase/@name"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:text>-</xsl:text>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:otherwise>
                </xsl:choose>
              </a>
            </xsl:otherwise>
          </xsl:choose>
        </div>
      </td>
      <td class="message">
        <div class="possibleScroll">
          <xsl:apply-templates select="." mode="message"/>
        </div>
      </td>
      <td class="screenshot">
        <xsl:call-template name="create-screenshots">
          <xsl:with-param name="kind" select="$kind"/>
        </xsl:call-template>
      </td>
    </tr>
  </xsl:template>

  <!-- }}} -->

  <!-- Warnings overview -->
  <!-- {{{ list-all-warnings -->

  <xsl:template name="list-all-warnings">
    <xsl:param name="kind" select="'summary'"/>
    <xsl:if test=".//warning[@ref] | .//check[@ref and @pstate = 1]">
      <div class="allwarnings branch">
        <nav class="allwarningslinks overviewlinks gutter-left">
          <a name="allwarnings"/>
          <xsl:for-each select="ancestor-or-self::*">
            <xsl:apply-templates select="." mode="links"/>
          </xsl:for-each>
        </nav>

        <h2 class="allwarningstitle gutter-left">
            <xsl:call-template name="lc-warningsoverview"/>
        </h2>
        <table class="allwarningslist" cellspacing="0">
          <tr class="headers">
            <th class="margin"/>
            <xsl:if test="$kind='summary'">
              <th class="testsuite">
                <xsl:call-template name="lc-Testsuite"/>
              </th>
              <th class="runid">
                <xsl:call-template name="lc-runid"/>
              </th>
            </xsl:if>
            <th class="testcase">
              <xsl:call-template name="lc-testcase"/>
            </th>
            <th class="message">
              <xsl:call-template name="lc-message"/>
            </th>
            <th class="screenshot">
              <xsl:call-template name="lc-screenshot"/>
            </th>
          </tr>

          <xsl:choose>
            <xsl:when test="$kind='summary'">
              <xsl:for-each select=".//warning[@ref] | .//check[@ref and @pstate = 1]">
                <xsl:apply-templates select="." mode="single-warning">
                  <xsl:with-param name="kind" select="$kind"/>
                </xsl:apply-templates>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select=".//warning[@link]
                                    | .//check[@link and key('refkey', @link)/@pstate = 1]">
                <xsl:apply-templates select="key('refkey', @link)" mode="single-warning">
                  <xsl:with-param name="kind" select="$kind"/>
                </xsl:apply-templates>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
        </table>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="warning | check" mode="single-warning">
    <xsl:param name="kind" select="'summary'"/>
    <tr>
      <td class="marginicon">
        <a name="{@ref}"/>
        <xsl:call-template name="create-img-warning"/>
      </td>
      <xsl:if test="$kind='summary'">
        <td class="testsuite">
          <a>
            <xsl:attribute name="href">
              <xsl:call-template name="subst-hash">
                <xsl:with-param name="text" select="ancestor::test-suite/@hfile"/>
              </xsl:call-template>
            </xsl:attribute>
            <xsl:call-template name="basename">
              <xsl:with-param name="file" select="ancestor::test-suite/@relname"/>
            </xsl:call-template>
          </a>
        </td>
        <td class="testsuite">
          <xsl:value-of select="ancestor::test-suite/@runid"/>
        </td>
      </xsl:if>
      <td class="testcase">
        <xsl:choose>
          <xsl:when test="$nodeicons=1">
            <div class="withicon">
              <xsl:if test="ancestor::testcase">
                <div class="icon">
                  <xsl:call-template name="create-testcase-icon"/>
                </div>
              </xsl:if>
              <div class="item">
                <a>
                  <xsl:choose>
                    <xsl:when test="$kind='summary'">
                      <xsl:choose>
                        <xsl:when test="@name and @name != ''">
                          <xsl:attribute name="href">
                            <xsl:call-template name="subst-hash">
                              <xsl:with-param name="text" select="ancestor::test-suite/@hfile"/>
                            </xsl:call-template>
                            <xsl:text>#</xsl:text>
                            <xsl:value-of select="@ref"/>
                          </xsl:attribute>
                          <xsl:value-of select="@name"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:text>-</xsl:text>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:choose>
                        <xsl:when test="ancestor::testcase">
                          <xsl:attribute name="href">
                            <xsl:text>#</xsl:text>
                            <xsl:value-of select="ancestor::testcase/@ref"/>
                          </xsl:attribute>
                          <xsl:value-of select="ancestor::testcase/@name"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:text>-</xsl:text>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>
                </a>
              </div>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <a>
              <xsl:choose>
                <xsl:when test="$kind='summary'">
                  <xsl:choose>
                    <xsl:when test="@name and @name != ''">
                      <xsl:attribute name="href">
                        <xsl:call-template name="subst-hash">
                          <xsl:with-param name="text" select="ancestor::test-suite/@hfile"/>
                        </xsl:call-template>
                        <xsl:text>#</xsl:text>
                        <xsl:value-of select="@ref"/>
                      </xsl:attribute>
                      <xsl:value-of select="@name"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text>-</xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="ancestor::testcase">
                      <xsl:attribute name="href">
                        <xsl:text>#</xsl:text>
                        <xsl:value-of select="ancestor::testcase/@ref"/>
                      </xsl:attribute>
                      <xsl:value-of select="ancestor::testcase/@name"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text>-</xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
            </a>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td class="message">
        <xsl:apply-templates select="." mode="message"/>
      </td>
      <td class="screenshot">
        <xsl:call-template name="create-screenshots">
          <xsl:with-param name="kind" select="$kind"/>
        </xsl:call-template>
      </td>
    </tr>
  </xsl:template>

  <!-- }}} -->

  <!-- Suite overview -->
  <!-- {{{ list-all-suites -->

  <xsl:template name="list-all-suites">
    <xsl:if test=".//test-suite">
      <div class="allsuites branch">
        <nav class="allsuiteslinks overviewlinks gutter-left">
          <a name="allsuites"/>
          <xsl:for-each select="ancestor-or-self::*">
            <xsl:apply-templates select="." mode="links"/>
          </xsl:for-each>
        </nav>

        <h2 class="allsuitestitle gutter-left">
          <xsl:call-template name="lc-suitesoverview"/>
        </h2>
        <table class="allsuiteslist" cellspacing="0">
          <tr class="headers">
            <th class="margin"/>
            <th class="testsuite">
              <xsl:call-template name="lc-Testsuite"/>
            </th>
            <th class="directory">
              <xsl:call-template name="lc-directory"/>
            </th>
            <th class="runid">
              <xsl:call-template name="lc-runid"/>
            </th>
            <th class="starttime">
              <xsl:call-template name="lc-starttime"/>
            </th>
            <th class="result">
              <xsl:call-template name="lc-result"/>
            </th>
            <xsl:call-template name="create-th-tests"/>
            <xsl:call-template name="create-th-excepted"/>
            <xsl:call-template name="create-th-failed"/>
            <xsl:call-template name="create-th-expfailed"/>
            <xsl:call-template name="create-th-passed"/>
            <xsl:if test="$ignoreskipped = 0">
              <xsl:call-template name="create-th-skipped"/>
              <xsl:call-template name="create-th-skippedsets"/>
            </xsl:if>
            <xsl:if test="$ignorenotimplemented = 0">
              <xsl:call-template name="create-th-notimpl"/>
            </xsl:if>
            <xsl:call-template name="create-th-executed"/>
            <xsl:call-template name="create-th-percent"/>
            <xsl:call-template name="create-th-duration"/>
            <xsl:call-template name="create-th-realtime"/>
          </tr>

          <xsl:for-each select=".//test-suite">

            <xsl:variable name="suitename">
              <xsl:value-of select="@suitename"/>
            </xsl:variable>
            <xsl:variable name="tests">
              <xsl:value-of select="summary/@tests"/>
            </xsl:variable>
            <xsl:variable name="good">
              <xsl:value-of select="summary/@passedtests"/>
            </xsl:variable>
            <xsl:variable name="failed">
              <xsl:value-of select="summary/@failedtests"/>
            </xsl:variable>
            <xsl:variable name="expfailed">
              <xsl:value-of select="summary/@expectedfailedtests"/>
            </xsl:variable>
            <xsl:variable name="excepted">
              <xsl:value-of select="summary/@exceptedtests"/>
            </xsl:variable>
            <xsl:variable name="skipped">
              <xsl:value-of select="summary/@skippedtests"/>
            </xsl:variable>
            <xsl:variable name="skippedsets">
              <xsl:value-of select="summary/@skippedtestsets"/>
            </xsl:variable>
            <xsl:variable name="nonimpl">
              <xsl:value-of select="summary/@nonimpltests"/>
            </xsl:variable>
            <xsl:variable name="executedtests">
              <xsl:value-of select="summary/@executedtests"/>
            </xsl:variable>

            <tr>
              <td class="marginicon">
                <a name="{@ref}"/>
                <xsl:call-template name="create-result-img"/>
              </td>
              <td class="testsuite">
                <a>
                  <xsl:attribute name="href">
                    <xsl:call-template name="subst-hash">
                      <xsl:with-param name="text" select="@hfile"/>
                    </xsl:call-template>
                  </xsl:attribute>
                  <xsl:choose>
                    <xsl:when test="$includesuitename = 1 and $suitename and $suitename != ''">
                      <xsl:attribute name="title">
                        <xsl:call-template name="basename">
                          <xsl:with-param name="file" select="@relname"/>
                        </xsl:call-template>
                      </xsl:attribute>
                      <xsl:value-of select="$suitename"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:call-template name="basename">
                        <xsl:with-param name="file" select="@relname"/>
                      </xsl:call-template>
                    </xsl:otherwise>
                  </xsl:choose>      
                </a>
              </td>
              <td class="directory">
                <xsl:call-template name="dirname">
                  <xsl:with-param name="file" select="@relname"/>
                </xsl:call-template>
              </td>
              <td class="runid">
                <xsl:value-of select="@runid"/>
              </td>
              <td class="starttime">
                <xsl:value-of select="@execution-date"/>
              </td>
              <td class="result">
                <xsl:apply-templates select="." mode="result-list"/>
              </td>
              <td class="tests">
                <xsl:if test="$ignoreskipped = 0 and $skippedsets > 0">
                  <xsl:text>&gt;</xsl:text>
                </xsl:if>
                <xsl:value-of select="$tests"/>
              </td>
              <td class="excepted">
                <xsl:value-of select="$excepted"/>
              </td>
              <td class="failed">
                <xsl:value-of select="$failed"/>
              </td>
              <td class="expfailed">
                <xsl:value-of select="$expfailed"/>
              </td>
              <td class="passed">
                <xsl:value-of select="$good"/>
              </td>
              <xsl:if test="$ignoreskipped = 0">
                <td class="skipped">
                  <xsl:if test="$skippedsets > 0">
                    <xsl:text>&gt;</xsl:text>
                  </xsl:if>
                  <xsl:value-of select="$skipped"/>
                </td>
                <td class="skippedsets">
                  <xsl:value-of select="$skippedsets"/>
                </td>
              </xsl:if>
              <xsl:if test="$ignorenotimplemented = 0">
                <td class="notimpl">
                  <xsl:value-of select="$nonimpl"/>
                </td>
              </xsl:if>
              <td class="executed">
                <xsl:value-of select="$executedtests"/>
              </td>
              <td class="percent">
                <xsl:call-template name="percent">
                  <xsl:with-param name="numerator" select="$good"/>
                  <xsl:with-param name="denominator" select="$executedtests"/>
                </xsl:call-template>
              </td>
              <td class="duration">
                <xsl:call-template name="duration-text">
                  <xsl:with-param name="duration" select="summary/@duration"/>
                </xsl:call-template>
              </td>
              <td class="realtime">
                <xsl:call-template name="duration-text">
                  <xsl:with-param name="duration" select="summary/@realtime"/>
                </xsl:call-template>
              </td>
            </tr>
          </xsl:for-each>
        </table>
      </div>
    </xsl:if>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ list-all-suites-with-errors -->

  <xsl:template name="list-all-suites-with-errors">
    <xsl:if test=".//test-suite[@vstate &gt; 1]">
      <div class="allerrorsuites branch">
        <nav class="allerrorsuiteslinks overviewlinks gutter-left">
          <a name="allerrorsuites"/>
          <xsl:for-each select="ancestor-or-self::*">
            <xsl:apply-templates select="." mode="links"/>
          </xsl:for-each>
        </nav>

        <h2 class="allerrorsuitestitle gutter-left">
          <xsl:call-template name="lc-errorsuitesoverview"/>
        </h2>
        <table class="allerrorsuiteslist" cellspacing="0">
          <tr class="headers">
            <th class="margin"/>
            <th class="testsuite">
              <xsl:call-template name="lc-Testsuite"/>
            </th>
            <th class="directory">
              <xsl:call-template name="lc-directory"/>
            </th>
            <th class="runid">
              <xsl:call-template name="lc-runid"/>
            </th>
            <th class="starttime">
              <xsl:call-template name="lc-starttime"/>
            </th>
            <th class="result">
              <xsl:call-template name="lc-result"/>
            </th>
            <xsl:call-template name="create-th-tests"/>
            <xsl:call-template name="create-th-excepted"/>
            <xsl:call-template name="create-th-failed"/>
            <xsl:call-template name="create-th-expfailed"/>
            <xsl:call-template name="create-th-passed"/>
            <xsl:call-template name="create-th-skipped"/>
            <xsl:call-template name="create-th-skippedsets"/>
            <xsl:call-template name="create-th-notimpl"/>
            <xsl:call-template name="create-th-executed"/>
            <xsl:call-template name="create-th-percent"/>
            <xsl:call-template name="create-th-duration"/>
            <xsl:call-template name="create-th-realtime"/>
          </tr>

          <xsl:for-each select=".//test-suite[@vstate &gt; 1]">

            <xsl:variable name="suitename">
              <xsl:value-of select="@suitename"/>
            </xsl:variable>
            <xsl:variable name="tests">
              <xsl:value-of select="summary/@tests"/>
            </xsl:variable>
            <xsl:variable name="good">
              <xsl:value-of select="summary/@passedtests"/>
            </xsl:variable>
            <xsl:variable name="failed">
              <xsl:value-of select="summary/@failedtests"/>
            </xsl:variable>
            <xsl:variable name="expfailed">
              <xsl:value-of select="summary/@expectedfailedtests"/>
            </xsl:variable>
            <xsl:variable name="excepted">
              <xsl:value-of select="summary/@exceptedtests"/>
            </xsl:variable>
            <xsl:variable name="skipped">
              <xsl:value-of select="summary/@skippedtests"/>
            </xsl:variable>
            <xsl:variable name="skippedsets">
              <xsl:value-of select="summary/@skippedtestsets"/>
            </xsl:variable>
            <xsl:variable name="nonimpl">
              <xsl:value-of select="summary/@nonimpltests"/>
            </xsl:variable>
            <xsl:variable name="executedtests">
              <xsl:value-of select="summary/@executedtests"/>
            </xsl:variable>

            <tr>
              <td class="marginicon">
                <a name="{@ref}"/>
                <xsl:call-template name="create-result-img"/>
              </td>
              <td class="testsuite">
                <a>
                  <xsl:attribute name="href">
                    <xsl:call-template name="subst-hash">
                      <xsl:with-param name="text" select="@hfile"/>
                    </xsl:call-template>
                  </xsl:attribute>
                  <xsl:choose>
                    <xsl:when test="$includesuitename = 1 and $suitename and $suitename != ''">
                      <xsl:attribute name="title">
                        <xsl:call-template name="basename">
                          <xsl:with-param name="file" select="@relname"/>
                        </xsl:call-template>
                      </xsl:attribute>
                      <xsl:value-of select="$suitename"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:call-template name="basename">
                        <xsl:with-param name="file" select="@relname"/>
                      </xsl:call-template>
                    </xsl:otherwise>
                  </xsl:choose>
                </a>
              </td>
              <td class="directory">
                <xsl:call-template name="dirname">
                  <xsl:with-param name="file" select="@relname"/>
                </xsl:call-template>
              </td>
              <td class="runid">
                <xsl:value-of select="@runid"/>
              </td>
              <td class="starttime">
                <xsl:value-of select="@execution-date"/>
              </td>
              <td class="result">
                <xsl:apply-templates select="." mode="result-list"/>
              </td>
              <td class="tests">
                <xsl:if test="$skippedsets > 0">
                  <xsl:text>&gt;</xsl:text>
                </xsl:if>
                <xsl:value-of select="$tests"/>
              </td>
              <td class="excepted">
                <xsl:value-of select="$excepted"/>
              </td>
              <td class="failed">
                <xsl:value-of select="$failed"/>
              </td>
              <td class="expfailed">
                <xsl:value-of select="$expfailed"/>
              </td>
              <td class="passed">
                <xsl:value-of select="$good"/>
              </td>
              <td class="skipped">
                <xsl:if test="$skippedsets > 0">
                  <xsl:text>&gt;</xsl:text>
                </xsl:if>
                <xsl:value-of select="$skipped"/>
              </td>
              <td class="skippedsets">
                <xsl:value-of select="$skippedsets"/>
              </td>
              <td class="notimpl">
                <xsl:value-of select="$nonimpl"/>
              </td>
              <td class="executed">
                <xsl:value-of select="$executedtests"/>
              </td>
              <td class="percent">
                <xsl:call-template name="percent">
                  <xsl:with-param name="numerator" select="$good"/>
                  <xsl:with-param name="denominator" select="$executedtests"/>
                </xsl:call-template>
              </td>
              <td class="duration">
                <xsl:call-template name="duration-text">
                  <xsl:with-param name="duration" select="summary/@duration"/>
                </xsl:call-template>
              </td>
              <td class="realtime">
                <xsl:call-template name="duration-text">
                  <xsl:with-param name="duration" select="summary/@realtime"/>
                </xsl:call-template>
              </td>
            </tr>
          </xsl:for-each>
        </table>
      </div>
    </xsl:if>
  </xsl:template>

  <!-- }}} -->

  <!-- Branch overview level -->
  <!-- {{{ get-branch-class -->

  <!-- Get the node type of branch-level nodes -> testset -->
  <xsl:template name="get-branch-class">
    <xsl:text>testset</xsl:text>
  </xsl:template>


  <!-- }}} -->
  <!-- {{{ get-branch-list-title -->

  <!-- Get the title for the overview of branch-level nodes -> Test-set overview -->
  <xsl:template name="get-branch-list-title">
    <xsl:call-template name="lc-testsetsoverview"/>
    <!-- <xsl:text>rel/name/ofSuite.qft</xsl:text> -->
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ get-branch-and-leaves-list-title -->

  <!-- Get the title for the overview of branch and leaf-level nodes -->
  <xsl:template name="get-branch-and-leaves-list-title">
    <xsl:call-template name="lc-testsetsandtestcasesoverview"/>
    <!-- <xsl:text>rel/name/ofSuite.qft</xsl:text> -->
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ get-sort-branches -->

  <!-- Whether to sort branch nodes -> Not in reports -->
  <xsl:template name="get-sort-branches">
    <xsl:text>0</xsl:text>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ get-branch-headers -->

  <!-- Create the table headers for the overview list of branch nodes,
       i.e. the list of test-sets -->
  <xsl:template name="get-branch-headers">
    <xsl:param name="withleaf" select="'false'"/>
    <th class="margin"/>
    <th class="testset">
      <xsl:call-template name="lc-testset"/>
      <xsl:if test="$withleaf = 'true'">
        <xsl:text>/</xsl:text>
        <xsl:call-template name="lc-testcase"/>
      </xsl:if>
    </th>
    <th class="desc">
      <xsl:call-template name="lc-description"/>
    </th>
    <xsl:choose>
      <xsl:when test="$withleaf = 'true'">
        <th class="result">
          <xsl:call-template name="lc-result"/>
        </th>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="create-th-tests"/>
        <xsl:call-template name="create-th-excepted"/>
        <xsl:call-template name="create-th-failed"/>
        <xsl:call-template name="create-th-expfailed"/>
        <xsl:call-template name="create-th-passed"/>
        <xsl:if test="$ignoreskipped = 0">
          <xsl:call-template name="create-th-skipped"/>
          <xsl:call-template name="create-th-skippedsets"/>
        </xsl:if>
        <xsl:if test="$ignorenotimplemented = 0">
          <xsl:call-template name="create-th-notimpl"/>
        </xsl:if>
        <xsl:call-template name="create-th-executed"/>
        <xsl:call-template name="create-th-percent"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="create-th-duration"/>
    <xsl:call-template name="create-th-realtime"/>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ get-branch-details -->

  <xsl:template name="get-branch-details">
    <xsl:param name="withleaf" select="'false'"/>
    <xsl:variable name="tests">
      <xsl:value-of select="count(.//testcase)"/>
    </xsl:variable>
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
    <xsl:variable name="executedtests">
      <xsl:value-of select="$good + $failed + $expfailed + $excepted - $skipped - $nonimpl"/>
    </xsl:variable>

    <td class="marginicon">
      <xsl:call-template name="create-result-img"/>
    </td>
    <xsl:choose>
      <xsl:when test="$withleaf='false'">
        <td class="testset">
          <div class="padding-left-{count(ancestor::testset)*16}" style="padding-left:{count(ancestor::testset)*16}px">
            <xsl:choose>
              <xsl:when test="$nodeicons=1">
                <div class="withicon">
                  <div class="icon">
                    <xsl:call-template name="create-testset-icon" />
                  </div>
                  <div class="item">
                    <a>
                      <xsl:apply-templates select="." mode="link-to"/>
                      <xsl:value-of select="@name"/>
                    </a>
                  </div>
                </div>
              </xsl:when>
              <xsl:otherwise>
                <a>
                  <xsl:apply-templates select="." mode="link-to"/>
                  <xsl:value-of select="@name"/>
                </a>
              </xsl:otherwise>
            </xsl:choose>
          </div>
        </td>
        <td class="desc">
          <xsl:choose>
            <xsl:when test="comment">
              <xsl:apply-templates select="comment" mode="sentence"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>&nbsp;</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="tests">
          <xsl:if test="$ignoreskipped = 0 and (@skipped = 'true' or $skippedsets > 0)">
            <xsl:text>&gt;</xsl:text>
          </xsl:if>
          <xsl:value-of select="$tests"/>
        </td>
        <td class="excepted">
          <xsl:value-of select="$excepted"/>
        </td>
        <td class="failed">
          <xsl:value-of select="$failed"/>
        </td>
        <td class="expfailed">
          <xsl:value-of select="$expfailed"/>
        </td>
        <td class="passed">
          <xsl:value-of select="$good - $skipped - $nonimpl"/>
        </td>
        <xsl:if test="$ignoreskipped = 0">
          <td class="skipped">
            <xsl:if test="@skipped = 'true' or $skippedsets > 0">
              <xsl:text>&gt;</xsl:text>
            </xsl:if>
            <xsl:value-of select="$skipped"/>
          </td>
          <td class="skippedsets">
            <xsl:choose>
              <xsl:when test="@skipped = 'true'">
                <xsl:text>1</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$skippedsets"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </xsl:if>
        <xsl:if test="$ignorenotimplemented = 0">
          <td class="notimpl">
            <xsl:value-of select="$nonimpl"/>
          </td>
        </xsl:if>
        <td class="executed">
          <xsl:value-of select="$executedtests"/>
        </td>
        <td class="percent">
          <xsl:call-template name="percent">
            <xsl:with-param name="numerator" select="$good - $skipped - $nonimpl"/>
            <xsl:with-param name="denominator" select="$executedtests"/>
          </xsl:call-template>
        </td>
        <td class="duration">
          <xsl:call-template name="duration-text">
            <xsl:with-param name="duration" select="summary/@duration"/>
          </xsl:call-template>
        </td>
        <td class="realtime">
          <xsl:call-template name="duration-text">
            <xsl:with-param name="duration" select="summary/@realtime"/>
          </xsl:call-template>
        </td>
      </xsl:when>
      <xsl:otherwise>
        <td class="{name()}">
          <div class="padding-left-{count(ancestor::testset)*16}" style="padding-left:{count(ancestor::testset)*16}px">
            <xsl:choose>
              <xsl:when test="$nodeicons=1">
                <div class="withicon">
                  <div class="icon">
                    <xsl:choose>
                      <xsl:when test="name() = 'testset'">
                        <xsl:call-template name="create-testset-icon" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:call-template name="create-testcase-icon" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </div>
                  <div class="item">
                    <a>
                      <xsl:apply-templates select="." mode="link-to"/>
                      <xsl:value-of select="@name"/>
                    </a>
                  </div>
                </div>
              </xsl:when>
              <xsl:otherwise>
                <a>
                  <xsl:apply-templates select="." mode="link-to"/>
                  <xsl:value-of select="@name"/>
                </a>
              </xsl:otherwise>
            </xsl:choose>
          </div>
        </td>
        <td class="desc">
          <xsl:choose>
            <xsl:when test="comment">
              <xsl:apply-templates select="comment" mode="sentence"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>&nbsp;</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="result">
          <xsl:apply-templates select="." mode="result-list"/>
        </td>
        <td class="duration">
          <xsl:call-template name="duration-text">
            <xsl:with-param name="duration" select="summary/@duration"/>
          </xsl:call-template>
        </td>
        <td class="realtime">
          <xsl:call-template name="duration-text">
            <xsl:with-param name="duration" select="summary/@realtime"/>
          </xsl:call-template>
        </td>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->

  <!-- Branch level -->
  <!-- {{{ get-branch-title -->

  <!-- Get the title of branch-level nodes -> Test-set -->
  <xsl:template name="get-branch-title">
    <xsl:call-template name="lc-testset"/>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ create-branch-title-margin -->

  <xsl:template match="testset" mode="create-branch-title-margin">
    <div class="marginicon">
      <xsl:call-template name="create-result-img"/>
    </div>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ get-sort-leaves -->

  <!-- Whether to sort leaf nodes -> Not in reports -->
  <xsl:template name="get-sort-leaves">
    <xsl:text>0</xsl:text>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ testset.branchExtras -->

  <xsl:template match="testset" mode="branch-extras">
    <div class="testsetresult gutter-left">
      <xsl:call-template name="lc-result"/>
      <xsl:text>: </xsl:text>
      <xsl:apply-templates select="." mode="result-list"/>
    </div>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ get-leaf-headers -->

  <!-- Create the table headers for the list of leaf nodes in a branch entry,
       i.e. the list of test-cases for a test-set -->
  <xsl:template name="get-leaf-headers">
    <th class="margin"/>
    <th class="testcase">
      <xsl:call-template name="lc-testcase"/>
    </th>
    <th class="desc">
      <xsl:call-template name="lc-description"/>
    </th>
    <th class="result">
      <xsl:call-template name="lc-result"/>
    </th>
    <xsl:call-template name="create-th-duration"/>
    <xsl:call-template name="create-th-realtime"/>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ get-leaf-details -->

  <!-- Create the table cells for one leaf nodes in a branch entry,
       i.e. one test-case in a test-set -->
  <xsl:template name="get-leaf-details">
    <td class="marginicon">
      <xsl:call-template name="create-result-img"/>
    </td>
    <td class="testcase">
      <xsl:choose>
        <xsl:when test="$nodeicons=1">
          <div class="withicon">
            <div class="icon">
              <xsl:call-template name="create-testcase-icon"/>
            </div>
            <div class="item">
              <a>
                <xsl:apply-templates select="." mode="link-to"/>
                <!-- <xsl:value-of select="@qname"/> -->
                <xsl:value-of select="@name"/>
              </a>
            </div>
          </div>
        </xsl:when>
        <xsl:otherwise>
          <a>
            <xsl:apply-templates select="." mode="link-to"/>
            <!-- <xsl:value-of select="@qname"/> -->
            <xsl:value-of select="@name"/>
          </a>
        </xsl:otherwise>
      </xsl:choose>
    </td>
    <td class="desc">
      <xsl:choose>
        <xsl:when test="comment">
          <xsl:apply-templates select="comment" mode="sentence"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>&nbsp;</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </td>
    <td class="result">
      <xsl:apply-templates select="." mode="result-list"/>
    </td>
    <td class="duration">
      <xsl:call-template name="duration-text">
        <xsl:with-param name="duration" select="summary/@duration"/>
      </xsl:call-template>
    </td>
    <td class="realtime">
      <xsl:call-template name="duration-text">
        <xsl:with-param name="duration" select="summary/@realtime"/>
      </xsl:call-template>
    </td>
  </xsl:template>

  <!-- }}} -->

  <!-- Leaf level -->
  <!-- {{{ get-leaf-class -->

  <!-- Get the node type of leaf-level nodes -> testset -->
  <xsl:template name="get-leaf-class">
    <xsl:text>testcase</xsl:text>
  </xsl:template>


  <!-- }}} -->
  <!-- {{{ get-leaf-title -->

  <!-- Get the title of leaf-level nodes -> Test-set -->
  <xsl:template name="get-leaf-title">
    <xsl:call-template name="lc-testcase"/>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ create-leaf-title-margin -->

  <xsl:template match="testcase" mode="create-leaf-title-margin">
    <div class="marginicon">
      <xsl:call-template name="create-result-img"/>
    </div>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ non-teststep leaf-extras -->

  <xsl:template match="testcase[$teststeps=0]" mode="leaf-extras">
    <xsl:variable name="expectedfail" select="@expectedfail"/>
    <table class="testcaseresult" cellspacing="0">
      <tr>
        <td class="margin"/>
        <td>
          <xsl:call-template name="lc-result"/>
          <xsl:text>: </xsl:text>
          <xsl:apply-templates select="." mode="result-list"/>
        </td>
      </tr>
    </table>

    <xsl:if test=".//exception[@ref] | .//error[@ref] | .//warning[@ref]">
      <table class="testcaseerrorstitle" cellspacing="0">
        <tr class="title">
          <td class="margin"/>
          <td class="title">
            <xsl:call-template name="lc-problems"/>
            <xsl:text>: </xsl:text>
          </td>
        </tr>
      </table>
      <table class="testcaseerrorslist" cellspacing="0">
        <tr class="headers">
          <th class="margin">
            <!-- <xsl:call-template name="lc-type"/> -->
          </th>
          <th class="message">
            <xsl:call-template name="lc-message"/>
          </th>
          <th class="screenshot">
            <xsl:call-template name="lc-screenshot"/>
          </th>
        </tr>
        <xsl:for-each select=".//exception[@ref] | .//error[@ref] | .//warning[@ref]">
          <tr>
            <td class="marginicon">
              <a name="{@ref}"/>
              <xsl:choose>
                <xsl:when test="name() = 'exception'">
                  <xsl:choose>
                    <xsl:when test="@flaky='true'">
                      <xsl:call-template name="create-img-flakyexception"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:call-template name="create-img-exception"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:when test="name() = 'warning'">
                  <xsl:call-template name="create-img-warning"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="@flaky='true'">
                      <xsl:call-template name="create-img-flakyerror"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:choose>
                        <xsl:when test="$expectedfail='true'">
                          <xsl:call-template name="create-img-experror"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:call-template name="create-img-error"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td class="message">
              <xsl:apply-templates select="." mode="message"/>
            </td>
            <td class="screenshot">
              <xsl:call-template name="create-screenshots">
                <xsl:with-param name="kind" select="'suite'"/>
              </xsl:call-template>
            </td>
          </tr>
        </xsl:for-each>
      </table>
    </xsl:if>

    <xsl:if test=".//check[@ref]">
      <table class="testcasecheckstitle" cellspacing="0">
        <tr class="title">
          <td class="margin"/>
          <td class="title">
            <xsl:call-template name="lc-checks"/>
            <xsl:text>: </xsl:text>
          </td>
        </tr>
      </table>
      <table class="testcasecheckslist" cellspacing="0">
        <tr class="headers">
          <th class="margin">
            <!-- <xsl:call-template name="lc-type"/> -->
          </th>
          <th class="message">
            <xsl:call-template name="lc-message"/>
          </th>
          <th class="comment">
            <xsl:call-template name="lc-comment"/>
          </th>
        </tr>
        <xsl:for-each select=".//check[@ref]">
          <tr>
            <td class="marginicon">
              <a name="{@ref}"/>
              <xsl:choose>
                <xsl:when test="@pstate = 3">
                  <xsl:choose>
                    <xsl:when test="@flaky='true'">
                      <xsl:call-template name="create-img-flakyexception"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:call-template name="create-img-exception"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:when test="@pstate = 2">
                  <xsl:choose>
                    <xsl:when test="@flaky='true'">
                      <xsl:call-template name="create-img-flakyerror"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:call-template name="create-img-error"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:when test="@pstate = 1">
                  <xsl:call-template name="create-img-warning"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="create-img-passed"/>
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td class="message">
              <xsl:apply-templates select="message"/>
            </td>
            <td class="comment">
              <xsl:choose>
                <xsl:when test="comment">
                  <xsl:apply-templates select="comment" mode="step"/>
                </xsl:when>
                <xsl:otherwise>
                  &nbsp;
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
        </xsl:for-each>
      </table>
    </xsl:if>
  </xsl:template>


  <!-- }}} -->
  <!-- {{{ new leaf-extras: details -->

  <!-- {{{ testcase.leafExtras -->

  <xsl:template match="testcase[$teststeps=1]" mode="leaf-extras">

    <div class="testcaseresult gutter-left">
      <xsl:call-template name="lc-result"/>
      <xsl:text>: </xsl:text>
      <xsl:apply-templates select="." mode="result-list"/>
    </div>

    <xsl:if test="&detailNodes;">
      <table class="testcasedetailslist" cellspacing="0">
        <tr>
          <th class="margin"/>
          <th colspan="2" class="teststep">
            <xsl:call-template name="lc-teststep"/>
            <xsl:text>/</xsl:text>
            <xsl:call-template name="lc-message"/>
          </th>
          <xsl:call-template name="create-th-duration"/>
          <xsl:call-template name="create-th-realtime"/>
        </tr>
        <tr>
          <td class="margin"/>
          <td colspan="2" class="testcase">
            <xsl:choose>
              <xsl:when test="$nodeicons=1">
                <div class="withicon">
                  <div class="icon">
                    <xsl:call-template name="create-testcase-icon"/>
                  </div>
                  <div class="item">
                    <xsl:value-of select="@name"/>
                  </div>
                </div>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="@name"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
          <td class="duration">
            <xsl:call-template name="duration-text">
              <xsl:with-param name="duration" select="summary/@duration"/>
            </xsl:call-template>
          </td>
          <td class="realtime">
            <xsl:call-template name="duration-text">
              <xsl:with-param name="duration" select="summary/@realtime"/>
            </xsl:call-template>
          </td>
        </tr>
        <xsl:for-each select="&detailNodes;">
          <tr>
            <xsl:apply-templates select="." mode="createDetail"/>
          </tr>
        </xsl:for-each>
      </table>
    </xsl:if>
  </xsl:template>

  <!-- }}} -->

  <!-- {{{ teststep.createDetail -->

  <xsl:template match="teststep" mode="createDetail">
    <td class="margin"/>
    <td class="teststep">
      <div class="step padding-left-{(count(&ancestorTeststepNodes;) + 1)*20}" style="padding-left:{(count(&ancestorTeststepNodes;) + 1)*20}px">
        <xsl:choose>
          <xsl:when test="$nodeicons=1">
            <div class="withicon">
              <div class="icon">
                <xsl:variable name="kind">
                  <xsl:choose>
                    <xsl:when test="@kind">
                      <xsl:value-of select="@kind"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text>teststep</xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <xsl:call-template name="create-teststep-icon">
                  <xsl:with-param name="kind" select="$kind"/>
                </xsl:call-template>
              </div>
              <div class="item">
                <xsl:value-of select="@name"/>
                <xsl:if test="comment">
                  <br/>
                  <xsl:apply-templates select="comment" mode="step"/>
                </xsl:if>
              </div>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@name"/>
            <xsl:if test="comment">
              <br/>
              <xsl:apply-templates select="comment" mode="step"/>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </div>
    </td>
    <td class="buffer"/>
    <td class="duration">
      <xsl:call-template name="duration-text">
        <xsl:with-param name="duration" select="summary/@duration"/>
      </xsl:call-template>
    </td>
    <td class="realtime">
      <xsl:call-template name="duration-text">
        <xsl:with-param name="duration" select="summary/@realtime"/>
      </xsl:call-template>
    </td>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ message.createDetail -->

  <xsl:template match="message" mode="createDetail">
    <td class="margin"/>
    <td colspan="4" class="longmessage">
      <div class="step padding-left-{(count(&ancestorTeststepNodes;) + 1)*20}" style="padding-left:{(count(&ancestorTeststepNodes;) + 1)*20}px">
        <xsl:choose>
          <xsl:when test="$nodeicons=1">
            <div class="withicon">
              <div class="icon">
                <xsl:call-template name="create-msg-icon"/>
              </div>
              <div class="item">
                <xsl:apply-templates select="." mode="message"/>
              </div>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="." mode="message"/>
          </xsl:otherwise>
        </xsl:choose>
      </div>
    </td>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ exception.createDetail -->

  <xsl:template match="exception" mode="createDetail">
    <td class="marginicon">
      <xsl:call-template name="create-result-icon">
        <xsl:with-param name="result" select="'exception'"/>
      </xsl:call-template>
    </td>
    <td>
      <xsl:choose>
        <xsl:when test="key('refkey', @link)/screenshot">
          <xsl:attribute name="class">
            <xsl:text>message</xsl:text>
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="class">
            <xsl:text>longmessage</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="colspan">
            <xsl:text>4</xsl:text>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <div class="step padding-left-{(count(&ancestorTeststepNodes;) + 1)*20}" style="padding-left:{(count(&ancestorTeststepNodes;) + 1)*20}px">
        <xsl:choose>
          <xsl:when test="$nodeicons=1">
            <div class="withicon">
              <div class="icon">
                <xsl:call-template name="create-msg-err-icon"/>
              </div>
              <div class="item">
                <xsl:apply-templates select="key('refkey', @link)/message" mode="message"/>
              </div>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="key('refkey', @link)/message" mode="message"/>
          </xsl:otherwise>
        </xsl:choose>
      </div>
    </td>
    <xsl:if test="key('refkey', @link)/screenshot">
      <td colspan="3" class="screenshot">
        <xsl:text>&nbsp;</xsl:text>
        <xsl:for-each select="key('refkey', @link)">
          <xsl:call-template name="create-screenshots">
            <xsl:with-param name="kind" select="'suite'"/>
          </xsl:call-template>
        </xsl:for-each>
      </td>
    </xsl:if>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ error.createDetail -->

  <xsl:template match="error" mode="createDetail">
    <td class="marginicon">
      <xsl:call-template name="create-result-icon">
        <xsl:with-param name="result">
          <xsl:choose>
            <xsl:when test="ancestor::testcase/@expectedfail='true'">
              <xsl:text>experror</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>error</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </td>
    <td>
      <xsl:choose>
        <xsl:when test="key('refkey', @link)/screenshot">
          <xsl:attribute name="class">
            <xsl:text>message</xsl:text>
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="class">
            <xsl:text>longmessage</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="colspan">
            <xsl:text>4</xsl:text>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <div class="step padding-left-{(count(&ancestorTeststepNodes;) + 1)*20}" style="padding-left:{(count(&ancestorTeststepNodes;) + 1)*20}px">
        <xsl:choose>
          <xsl:when test="$nodeicons=1">
            <div class="withicon">
              <div class="icon">
                <xsl:call-template name="create-msg-err-icon"/>
              </div>
              <div class="item">
                <xsl:apply-templates select="key('refkey', @link)/message" mode="message"/>
              </div>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="key('refkey', @link)/message" mode="message"/>
          </xsl:otherwise>
        </xsl:choose>
      </div>
    </td>
    <xsl:if test="key('refkey', @link)/screenshot">
      <td colspan="3" class="screenshot">
        <xsl:text>&nbsp;</xsl:text>
        <xsl:for-each select="key('refkey', @link)">
          <xsl:call-template name="create-screenshots">
            <xsl:with-param name="kind" select="'suite'"/>
          </xsl:call-template>
        </xsl:for-each>
      </td>
    </xsl:if>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ warning.createDetail -->

  <xsl:template match="warning" mode="createDetail">
    <td class="marginicon">
      <xsl:call-template name="create-result-icon">
        <xsl:with-param name="result" select="'warning'"/>
      </xsl:call-template>
    </td>
    <td>
      <xsl:choose>
        <xsl:when test="key('refkey', @link)/screenshot">
          <xsl:attribute name="class">
            <xsl:text>message</xsl:text>
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="class">
            <xsl:text>longmessage</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="colspan">
            <xsl:text>4</xsl:text>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <div class="step padding-left-{(count(&ancestorTeststepNodes;) + 1)*20}" style="padding-left:{(count(&ancestorTeststepNodes;) + 1)*20}px">
        <xsl:choose>
          <xsl:when test="$nodeicons=1">
            <div class="withicon">
              <div class="icon">
                <xsl:call-template name="create-msg-wrn-icon"/>
              </div>
              <div class="item">
                <xsl:apply-templates select="key('refkey', @link)/message" mode="message"/>
              </div>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="key('refkey', @link)/message" mode="message"/>
          </xsl:otherwise>
        </xsl:choose>
      </div>
    </td>
    <xsl:if test="key('refkey', @link)/screenshot">
      <td colspan="3" class="screenshot">
        <xsl:text>&nbsp;</xsl:text>
        <xsl:for-each select="key('refkey', @link)">
          <xsl:call-template name="create-screenshots">
            <xsl:with-param name="kind" select="'suite'"/>
          </xsl:call-template>
        </xsl:for-each>
      </td>
    </xsl:if>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ check.createDetail -->

  <xsl:template match="check" mode="createDetail">
    <xsl:choose>
      <xsl:when test="key('refkey', @link)/@pstate=0">
        <td class="margin"/>
      </xsl:when>
      <xsl:otherwise>
        <td class="marginicon">
          <xsl:call-template name="create-result-icon">
            <xsl:with-param name="result">
              <xsl:choose>
                <xsl:when test="key('refkey', @link)/@pstate=3">
                  <xsl:text>exception</xsl:text>
                </xsl:when>
                <xsl:when test="key('refkey', @link)/@pstate=2">
                  <xsl:choose>
                    <xsl:when test="ancestor::testcase/@expectedfail='true'">
                      <xsl:text>experror</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text>error</xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:when test="key('refkey', @link)/@pstate=1">
                  <xsl:text>warning</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>ok</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:with-param>
          </xsl:call-template>
        </td>
      </xsl:otherwise>
    </xsl:choose>
    <td>
      <xsl:choose>
        <xsl:when test="key('refkey', @link)/screenshot">
          <xsl:attribute name="class">
            <xsl:text>message</xsl:text>
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="class">
            <xsl:text>longmessage</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="colspan">
            <xsl:text>4</xsl:text>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <div class="step padding-left-{(count(&ancestorTeststepNodes;) + 1)*20}" style="padding-left:{(count(&ancestorTeststepNodes;) + 1)*20}px">
        <xsl:choose>
          <xsl:when test="$nodeicons=1">
            <div class="withicon">
              <div class="icon">
                <xsl:choose>
                  <xsl:when test="key('refkey', @link)/@pstate=0">
                    <xsl:call-template name="create-check-icon"/>
                  </xsl:when>
                  <xsl:when test="key('refkey', @link)/@pstate=1">
                    <xsl:call-template name="create-check-wrn-icon"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="create-check-err-icon"/>
                  </xsl:otherwise>
                </xsl:choose>
              </div>
              <div class="item">
                <xsl:apply-templates select="key('refkey', @link)/message" mode="message"/>
              </div>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="key('refkey', @link)/message" mode="message"/>
          </xsl:otherwise>
        </xsl:choose>
      </div>
    </td>
    <xsl:if test="key('refkey', @link)/screenshot">
      <td colspan="3" class="screenshot">
        <xsl:text>&nbsp;</xsl:text>
        <xsl:for-each select="key('refkey', @link)">
          <xsl:call-template name="create-screenshots">
            <xsl:with-param name="kind" select="'suite'"/>
          </xsl:call-template>
        </xsl:for-each>
      </td>
    </xsl:if>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ dependency.createDetail -->

  <xsl:template match="dependency" mode="createDetail">
    <td class="margin"/>
    <td class="teststep">
      <div class="step padding-left-{(count(&ancestorTeststepNodes;) + 1)*20}" style="padding-left:{(count(&ancestorTeststepNodes;) + 1)*20}px;">
        <xsl:choose>
          <xsl:when test="$nodeicons=1">
            <div class="withicon">
              <div class="icon">
                <xsl:call-template name="create-dependency-icon"/>
              </div>
              <div class="item">
                <xsl:value-of select="@name"/>
                <xsl:if test="@namespace">
                  <xsl:text> </xsl:text>
                  <xsl:call-template name="lc-innamespace"/>
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="@namespace"/>
                </xsl:if>
                <xsl:if test="comment">
                  <br/>
                  <xsl:apply-templates select="comment" mode="step"/>
                </xsl:if>
              </div>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@name"/>
            <xsl:if test="@namespace">
              <xsl:text> </xsl:text>
              <xsl:call-template name="lc-innamespace"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="@namespace"/>
            </xsl:if>
            <xsl:if test="comment">
              <br/>
              <xsl:apply-templates select="comment" mode="step"/>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </div>
    </td>
    <td class="buffer"/>
    <td class="duration">
      <xsl:call-template name="duration-text">
        <xsl:with-param name="duration" select="summary/@duration"/>
      </xsl:call-template>
    </td>
    <td class="realtime">
      <xsl:call-template name="duration-text">
        <xsl:with-param name="duration" select="summary/@realtime"/>
      </xsl:call-template>
    </td>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ setup.createDetail -->

  <xsl:template match="setup" mode="createDetail">
    <td class="margin"/>
    <td class="teststep">
      <div class="step padding-left-{(count(&ancestorTeststepNodes;) + 1)*20}" style="padding-left:{(count(&ancestorTeststepNodes;) + 1)*20}px;">
        <xsl:choose>
          <xsl:when test="$nodeicons=1">
            <div class="withicon">
              <div class="icon">
                <xsl:call-template name="create-setup-icon"/>
              </div>
              <div class="item">
                <xsl:choose>
                  <xsl:when test="@name and @name != ''">
                    <xsl:value-of select="@name"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="lc-setup"/>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="comment">
                  <br/>
                  <xsl:apply-templates select="comment" mode="step"/>
                </xsl:if>
              </div>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="@name and @name != ''">
                <xsl:value-of select="@name"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="lc-setup"/>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="comment">
              <br/>
              <xsl:apply-templates select="comment" mode="step"/>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </div>
    </td>
    <td class="buffer"/>
    <td class="duration">
      <xsl:call-template name="duration-text">
        <xsl:with-param name="duration" select="summary/@duration"/>
      </xsl:call-template>
    </td>
    <td class="realtime">
      <xsl:call-template name="duration-text">
        <xsl:with-param name="duration" select="summary/@realtime"/>
      </xsl:call-template>
    </td>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ cleanup.createDetail -->

  <xsl:template match="cleanup" mode="createDetail">
    <td class="margin"/>
    <td class="teststep">
      <div class="step padding-left-{(count(&ancestorTeststepNodes;) + 1)*20}" style="padding-left:{(count(&ancestorTeststepNodes;) + 1)*20}px;">
        <xsl:choose>
          <xsl:when test="$nodeicons=1">
            <div class="withicon">
              <div class="icon">
                <xsl:call-template name="create-cleanup-icon"/>
              </div>
              <div class="item">
                <xsl:choose>
                  <xsl:when test="@name and @name != ''">
                    <xsl:value-of select="@name"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="lc-cleanup"/>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="comment">
                  <br/>
                  <xsl:apply-templates select="comment" mode="step"/>
                </xsl:if>
              </div>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="@name and @name != ''">
                <xsl:value-of select="@name"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="lc-cleanup"/>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="comment">
              <br/>
              <xsl:apply-templates select="comment" mode="step"/>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </div>
    </td>
    <td class="buffer"/>
    <td class="duration">
      <xsl:call-template name="duration-text">
        <xsl:with-param name="duration" select="summary/@duration"/>
      </xsl:call-template>
    </td>
    <td class="realtime">
      <xsl:call-template name="duration-text">
        <xsl:with-param name="duration" select="summary/@realtime"/>
      </xsl:call-template>
    </td>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ screenshot.createDetail -->

  <xsl:template match="screenshot" mode="createDetail">
    <td class="margin"/>
    <td class="message">
      <div class="step padding-left-{(count(&ancestorTeststepNodes;) + 1)*20}" style="padding-left:{(count(&ancestorTeststepNodes;) + 1)*20}px">
        <xsl:choose>
          <xsl:when test="$nodeicons=1">
            <div class="withicon">
              <div class="icon">
                <xsl:call-template name="create-screenshot-icon"/>
              </div>
              <div class="item">
                <xsl:call-template name="create-screenshot-name"/>
              </div>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="create-screenshot-name"/>
          </xsl:otherwise>
        </xsl:choose>
      </div>
    </td>
    <td colspan="3" class="screenshot">
      <xsl:text>&nbsp;</xsl:text>
      <xsl:call-template name="create-screenshot">
        <xsl:with-param name="kind" select="'teststep'"/>
      </xsl:call-template>
    </td>
  </xsl:template>

  <!-- }}} -->

  <!-- }}} -->

  <!-- {{{ CrossLinks -->

  <xsl:template match="testset | testcase" mode="cross-links">
    <xsl:variable name="qn" select="name()"/>
    <xsl:choose>
      <xsl:when test="preceding-sibling::*[name() = $qn]">
        <xsl:apply-templates select="preceding-sibling::*[name() = $qn][1]"
          mode="link-prev"/>
      </xsl:when>
      <xsl:otherwise>
        <img width="17" height="18">
          <xsl:attribute name="src">
            <xsl:call-template name="basedir"/>
            <xsl:text>icons/linkprevdis.png</xsl:text>
          </xsl:attribute>
        </img>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="." mode="maybe-link-next"/>
    <xsl:choose>
      <xsl:when test="following-sibling::*[name() = $qn]">
        <xsl:apply-templates select="following-sibling::*[name() = $qn][1]"
          mode="link-next"/>
      </xsl:when>
      <xsl:otherwise>
        <img width="17" height="18">
          <xsl:attribute name="src">
            <xsl:call-template name="basedir"/>
            <xsl:text>icons/linknextdis.png</xsl:text>
          </xsl:attribute>
        </img>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="ancestor::testset[1]">
        <xsl:apply-templates select="ancestor::testset[1]" mode="link-parent"/>
      </xsl:when>
      <xsl:otherwise>
          <img width="17" height="18">
            <xsl:attribute name="src">
              <xsl:call-template name="basedir"/>
              <xsl:text>icons/linkupdis.png</xsl:text>
            </xsl:attribute>
          </img>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
  Single stepping through test-sets and test-case is difficult because the test-cases are listed
  with the test-set to which they belong.
  -->
  <!-- {{{ maybe-link-next -->

  <!-- {{{ testset -->

  <xsl:template match="testset" mode="maybe-link-next">
    <xsl:choose>
      <xsl:when test="testcase">
        <!-- If a test-set has test-cases, link to the first one -->
        <xsl:apply-templates select="testcase[1]" mode="link-cont"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- If not, link to the following testset, regardless at which level -->
        <xsl:apply-templates select="." mode="maybe-link-next-testset"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ testcase -->

  <xsl:template match="testcase" mode="maybe-link-next">
    <xsl:choose>
      <xsl:when test="following-sibling::testcase">
        <!-- For a test-case, prefer the next test-case at the same level -->
        <xsl:apply-templates select="following-sibling::testcase[1]" mode="link-cont"/>
      </xsl:when>
      <xsl:otherwise>
        <!--
        If there are no further test-cases, go to the following test-set of the parent, regardless
        at which level.
        -->
        <xsl:apply-templates select=".." mode="maybe-link-next-testset"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->

  <xsl:template match="*" mode="maybe-link-next"/>

  <!-- }}} -->
  <!-- {{{ maybe-link-next-testset -->

  <xsl:template match="testset" mode="maybe-link-next-testset">
    <xsl:choose>
      <xsl:when test="testset | following::testset">
        <xsl:apply-templates select="(testset | following::testset)[1]" mode="link-cont"/>
      </xsl:when>
      <xsl:otherwise>
        <img width="17" height="18">
          <xsl:attribute name="src">
            <xsl:call-template name="basedir"/>
            <xsl:text>icons/linkcontdis.png</xsl:text>
          </xsl:attribute>
        </img>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*" mode="maybe-link-next-testset">
    <img width="17" height="18">
      <xsl:attribute name="src">
        <xsl:call-template name="basedir"/>
        <xsl:text>icons/linkcontdis.png</xsl:text>
      </xsl:attribute>
    </img>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ link-prev -->

  <xsl:template match="*" mode="link-prev">
    <a href="#{@ref}">
      <img width="17" height="18">
        <xsl:attribute name="src">
          <xsl:call-template name="basedir"/>
          <xsl:text>icons/linkprev.png</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:choose>
            <xsl:when test="name() = 'testset'">
              <xsl:call-template name="lc-testset"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="lc-testcase"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:text>: </xsl:text>
          <xsl:value-of select="@name"/>
        </xsl:attribute>
      </img>
    </a>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ link-cont -->

  <xsl:template match="*" mode="link-cont">
    <a href="#{@ref}">
      <img width="17" height="18">
        <xsl:attribute name="src">
          <xsl:call-template name="basedir"/>
          <xsl:text>icons/linkcont.png</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:choose>
            <xsl:when test="name() = 'testset'">
              <xsl:call-template name="lc-testset"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="lc-testcase"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:text>: </xsl:text>
          <xsl:value-of select="@name"/>
        </xsl:attribute>
      </img>
    </a>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ link-next -->

  <xsl:template match="*" mode="link-next">
    <a href="#{@ref}">
      <img width="17" height="18">
        <xsl:attribute name="src">
          <xsl:call-template name="basedir"/>
          <xsl:text>icons/linknext.png</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:choose>
            <xsl:when test="name() = 'testset'">
              <xsl:call-template name="lc-testset"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="lc-testcase"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:text>: </xsl:text>
          <xsl:value-of select="@name"/>
        </xsl:attribute>
      </img>
    </a>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ link-parent -->

  <xsl:template match="*" mode="link-parent">
    <a href="#{@ref}">
      <img width="17" height="18">
        <xsl:attribute name="src">
          <xsl:call-template name="basedir"/>
          <xsl:text>icons/linkup.png</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:call-template name="lc-testset"/>
          <xsl:text>: </xsl:text>
          <xsl:value-of select="@name"/>
        </xsl:attribute>
      </img>
    </a>
  </xsl:template>

  <!-- }}} -->

  <!-- }}} -->
  <!-- {{{ Comments in steps -->

  <xsl:template match="comment" mode="step">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- }}} -->

  <!-- }}} -->
  <!-- {{{ Message handling -->

  <xsl:template match="exception | error | warning | check" mode="message">
        <xsl:apply-templates select="message" mode="message"/>
  </xsl:template>

      <!-- <xsl:message><xsl:text>Translated: '</xsl:text> -->
        <!-- <xsl:value-of select="$translated"/> -->
        <!-- <xsl:text>', ends with: '</xsl:text> -->
        <!-- <xsl:value-of select="substring($translated, string-length($translated) - 6)"/> -->
        <!-- <xsl:text>'</xsl:text> -->
      <!-- </xsl:message> -->

  <!-- <xsl:variable name="translated" select="translate(message,'HTMLBODY', 'htmlbody')"/> -->
    <!-- <xsl:choose> -->
      <!-- <xsl:when test="$pass_html = 1 and starts-with($translated, '&lt;html&gt;') -->
        <!-- and substring($translated, string-length($translated) - 6) = '&lt;/html&gt;'"> -->
        <!-- <xsl:variable name="stripped" select="substring(., 7, string-length(.) - 13)"/> -->
        <!-- <xsl:choose> -->
          <!-- <xsl:when test="starts-with($stripped, '&lt;body&gt;') -->
            <!-- and substring($stripped, string-length($stripped) - 6) = '&lt;/body&gt;'"> -->
            <!-- <xsl:value-of disable-output-escaping="yes" -->
                          <!-- select="substring($stripped, 7, string-length($stripped) - 13)"/> -->
          <!-- </xsl:when> -->
          <!-- <xsl:otherwise> -->
            <!-- <xsl:value-of disable-output-escaping="yes" select="$stripped"/> -->
          <!-- </xsl:otherwise> -->
        <!-- </xsl:choose> -->
      <!-- </xsl:when> -->
      <!-- <xsl:otherwise> -->
        <!-- <xsl:apply-templates select="message" mode="message"/> -->
      <!-- </xsl:otherwise> -->
    <!-- </xsl:choose> -->
  <!-- </xsl:template> -->

  <xsl:template match="message" mode="message">
    <xsl:variable name="translated" select="translate(., 'HTMLBODY', 'htmlbody')"/>
    <xsl:choose>
      <xsl:when test="$pass_html = 1 and starts-with($translated, '&lt;html&gt;')
        and substring($translated, string-length($translated) - 6) = '&lt;/html&gt;'">
        <xsl:variable name="stripped" select="substring(., 7, string-length(.) - 13)"/>
        <xsl:choose>
          <xsl:when test="starts-with($stripped, '&lt;body&gt;')
            and substring($stripped, string-length($stripped) - 6) = '&lt;/body&gt;'">
            <xsl:value-of disable-output-escaping="yes"
              select="substring($stripped, 7, string-length($stripped) - 13)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="$stripped"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="@nowrap='true' or @lines &gt; 5">
        <textarea readonly="readonly" wrap="off" cols="200">
          <xsl:attribute name="rows">
            <xsl:choose>
              <xsl:when test="@lines &lt; 5">
                <xsl:text>5</xsl:text>
              </xsl:when>
              <xsl:when test="@lines &gt; 10">
                <xsl:text>10</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="@lines"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:apply-templates/>
        </textarea>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*" mode="message">
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ Helpers -->

  <!-- {{{ create-img-error -->

  <xsl:template name="create-img-error">
    <img width="16" height="16">
      <xsl:attribute name="src">
        <xsl:call-template name="basedir"/>
        <xsl:text>icons/error.png</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="alt">
        <xsl:call-template name="lc-error"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:call-template name="lc-error"/>
      </xsl:attribute>
    </img>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ create-img-exception -->

  <xsl:template name="create-img-exception">
    <img width="16" height="16">
      <xsl:attribute name="src">
        <xsl:call-template name="basedir"/>
        <xsl:text>icons/exception.png</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="alt">
        <xsl:call-template name="lc-exception"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:call-template name="lc-exception"/>
      </xsl:attribute>
    </img>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ create-img-experror -->

  <xsl:template name="create-img-experror">
    <img width="16" height="16">
      <xsl:attribute name="src">
        <xsl:call-template name="basedir"/>
        <xsl:text>icons/experror.png</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="alt">
        <xsl:call-template name="lc-experror"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:call-template name="lc-experror"/>
      </xsl:attribute>
    </img>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ create-img-flakyerror -->

  <xsl:template name="create-img-flakyerror">
    <img width="16" height="16">
      <xsl:attribute name="src">
        <xsl:call-template name="basedir"/>
        <xsl:text>icons/flakyerror.png</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="alt">
        <xsl:call-template name="lc-flakyerror"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:call-template name="lc-flakyerror"/>
      </xsl:attribute>
    </img>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ create-img-flakyexception -->

  <xsl:template name="create-img-flakyexception">
    <img width="16" height="16">
      <xsl:attribute name="src">
        <xsl:call-template name="basedir"/>
        <xsl:text>icons/flakyexception.png</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="alt">
        <xsl:call-template name="lc-flakyexception"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:call-template name="lc-flakyexception"/>
      </xsl:attribute>
    </img>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ create-img-notimplemented -->

  <xsl:template name="create-img-notimplemented">
    <img width="16" height="16">
      <xsl:attribute name="src">
        <xsl:call-template name="basedir"/>
        <xsl:text>icons/notimpl.png</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="alt">
        <xsl:call-template name="lc-notimplemented"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:call-template name="lc-notimplemented"/>
      </xsl:attribute>
    </img>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ create-img-passed -->

  <xsl:template name="create-img-passed">
    <img width="16" height="16">
      <xsl:attribute name="src">
        <xsl:call-template name="basedir"/>
        <xsl:text>icons/ok.png</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="alt">
        <xsl:call-template name="lc-passed"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:call-template name="lc-passed"/>
      </xsl:attribute>
    </img>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ create-img-percent -->

  <xsl:template name="create-img-percent">
    <img width="16" height="16">
      <xsl:attribute name="src">
        <xsl:call-template name="basedir"/>
        <xsl:text>icons/percent.png</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="alt">
        <xsl:call-template name="lc-percentpassed"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:call-template name="lc-percentpassed"/>
      </xsl:attribute>
    </img>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ create-img-skipped -->

  <xsl:template name="create-img-skipped">
    <img width="16" height="16">
      <xsl:attribute name="src">
        <xsl:call-template name="basedir"/>
        <xsl:text>icons/skipped.png</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="alt">
        <xsl:call-template name="lc-skipped"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:call-template name="lc-skipped"/>
      </xsl:attribute>
    </img>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ create-img-warning -->

  <xsl:template name="create-img-warning">
    <img width="16" height="16">
      <xsl:attribute name="src">
        <xsl:call-template name="basedir"/>
        <xsl:text>icons/warning.png</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="alt">
        <xsl:call-template name="lc-warning"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:call-template name="lc-warning"/>
      </xsl:attribute>
    </img>
  </xsl:template>

  <!-- }}} -->

  <!-- {{{ create-result-img -->

  <xsl:template name="create-result-img">
    <xsl:choose>
      <xsl:when test="@skipped='true'">
        <xsl:call-template name="create-img-skipped"/>
      </xsl:when>
      <xsl:when test="@implemented='false'">
        <xsl:call-template name="create-img-notimplemented"/>
      </xsl:when>
      <xsl:when test="summary/@exceptions &gt; 0">
        <xsl:choose>
          <xsl:when test="summary/@exceptions=summary/@flakyexceptions">
            <xsl:call-template name="create-img-flakyexception"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="create-img-exception"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="summary/@errors &gt; 0">
        <xsl:choose>
          <xsl:when test="summary/@errors=summary/@flakyerrors">
            <xsl:call-template name="create-img-flakyerror"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="create-img-error"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="summary/@expectederrors &gt; 0">
        <xsl:call-template name="create-img-experror"/>
      </xsl:when>
      <xsl:when test="summary/@warnings &gt; 0">
        <xsl:call-template name="create-img-warning"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="create-img-passed"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->

  <!-- {{{ create-th-duration -->

  <xsl:template name="create-th-duration">
    <th class="duration">
      <img width="16" height="16">
        <xsl:attribute name="src">
          <xsl:call-template name="basedir"/>
          <xsl:text>icons/duration.png</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="alt">
          <xsl:call-template name="lc-duration-long"/>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:call-template name="lc-duration-long"/>
        </xsl:attribute>
      </img>
    </th>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ create-th-executed -->

  <xsl:template name="create-th-executed">
    <th class="executed">
      <img width="16" height="16">
        <xsl:attribute name="src">
          <xsl:call-template name="basedir"/>
          <xsl:text>icons/run.png</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="alt">
          <xsl:call-template name="lc-numexecuted"/>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:call-template name="lc-numexecuted"/>
        </xsl:attribute>
      </img>
    </th>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ create-th-excepted -->

  <xsl:template name="create-th-excepted">
    <th class="excepted">
      <img width="16" height="16">
        <xsl:attribute name="src">
          <xsl:call-template name="basedir"/>
          <xsl:text>icons/exception.png</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="alt">
          <xsl:call-template name="lc-numexcepted"/>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:call-template name="lc-numexcepted"/>
        </xsl:attribute>
      </img>
    </th>
  </xsl:template>


  <!-- }}} -->
  <!-- {{{ create-th-failed -->

  <xsl:template name="create-th-failed">
    <th class="failed">
      <img width="16" height="16">
        <xsl:attribute name="src">
          <xsl:call-template name="basedir"/>
          <xsl:text>icons/error.png</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="alt">
          <xsl:call-template name="lc-numerror"/>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:call-template name="lc-numerror"/>
        </xsl:attribute>
      </img>
    </th>
  </xsl:template>


  <!-- }}} -->
  <!-- {{{ create-th-expfailed -->

  <xsl:template name="create-th-expfailed">
    <th class="expfailed">
      <img width="16" height="16">
        <xsl:attribute name="src">
          <xsl:call-template name="basedir"/>
          <xsl:text>icons/experror.png</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="alt">
          <xsl:call-template name="lc-numexperror"/>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:call-template name="lc-numexperror"/>
        </xsl:attribute>
      </img>
    </th>
  </xsl:template>


  <!-- }}} -->
  <!-- {{{ create-th-notimpl -->

  <xsl:template name="create-th-notimpl">
    <th class="notimpl">
      <!-- <xsl:call-template name="lc-notimplemented"/> -->
      <img width="16" height="16">
        <xsl:attribute name="src">
          <xsl:call-template name="basedir"/>
          <xsl:text>icons/notimpl.png</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="alt">
          <xsl:call-template name="lc-numnotimpl"/>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:call-template name="lc-numnotimpl"/>
        </xsl:attribute>
      </img>
    </th>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ create-th-passed -->

  <xsl:template name="create-th-passed">
    <th class="passed">
      <img width="16" height="16">
        <xsl:attribute name="src">
          <xsl:call-template name="basedir"/>
          <xsl:text>icons/ok.png</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="alt">
          <xsl:call-template name="lc-numpassed"/>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:call-template name="lc-numpassed"/>
        </xsl:attribute>
      </img>
    </th>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ create-th-percent -->

  <xsl:template name="create-th-percent">
    <th class="percent">
      <xsl:call-template name="create-img-percent"/>
    </th>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ create-th-realtime -->

  <xsl:template name="create-th-realtime">
    <th class="realtime">
      <img width="16" height="16">
        <xsl:attribute name="src">
          <xsl:call-template name="basedir"/>
          <xsl:text>icons/realtime.png</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="alt">
          <xsl:call-template name="lc-realtime-long"/>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:call-template name="lc-realtime-long"/>
        </xsl:attribute>
      </img>
    </th>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ create-th-skipped -->

  <xsl:template name="create-th-skipped">
    <th class="skipped">
      <!-- <xsl:call-template name="lc-skipped"/> -->
      <img width="16" height="16">
        <xsl:attribute name="src">
          <xsl:call-template name="basedir"/>
          <xsl:text>icons/skipped.png</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="alt">
          <xsl:call-template name="lc-numskipped"/>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:call-template name="lc-numskipped"/>
        </xsl:attribute>
      </img>
    </th>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ create-th-skippedsets -->

  <xsl:template name="create-th-skippedsets">
    <th class="skippedsets">
      <!-- <xsl:call-template name="lc-skipped"/> -->
      <img width="16" height="16">
        <xsl:attribute name="src">
          <xsl:call-template name="basedir"/>
          <xsl:text>icons/skippedsets.png</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="alt">
          <xsl:call-template name="lc-numskippedsets"/>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:call-template name="lc-numskippedsets"/>
        </xsl:attribute>
      </img>
    </th>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ create-th-tests -->

  <xsl:template name="create-th-tests">
    <th class="tests">
      <!-- <xsl:call-template name="lc-tests"/> -->
      <img width="16" height="16">
        <xsl:attribute name="src">
          <xsl:call-template name="basedir"/>
          <xsl:text>icons/tests.png</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="alt">
          <xsl:call-template name="lc-numtestcase"/>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:call-template name="lc-numtestcase"/>
        </xsl:attribute>
      </img>
    </th>
  </xsl:template>

  <!-- }}} -->

  <!-- {{{ create-chart -->

  <xsl:template name="create-chart">
    <xsl:param name="kind"/>
    <xsl:param name="tests"/>
    <xsl:if test="$piechart = 1">
      <xsl:if test="$tests &gt; 0">
        <div class="chart">
          <a class="icon">
            <xsl:attribute name="href">
              <xsl:text>images/</xsl:text>
              <xsl:choose>
                <xsl:when test="$kind='summary'">
                  <xsl:text>chart2.png</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="basename">
                    <xsl:with-param name="file"
                                    select="substring(@hfile, 0, string-length(@hfile) - 4)"/>
                  </xsl:call-template>
                  <xsl:text>_chart2.png</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <img width="150" height="150" border="none">
              <xsl:attribute name="src">
                <xsl:text>images/</xsl:text>
                <xsl:choose>
                  <xsl:when test="$kind='summary'">
                    <xsl:text>chart.png</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="basename">
                      <xsl:with-param name="file"
                                    select="substring(@hfile, 0, string-length(@hfile) - 4)"/>
                    </xsl:call-template>
                    <xsl:text>_chart.png</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
              <xsl:attribute name="title">
                <xsl:call-template name="lc-pietitle"/>
              </xsl:attribute>
            </img>
          </a>
          <div class="desc">
            <p>
              <img width="9" height="9">
                <xsl:attribute name="src">
                  <xsl:call-template name="basedir"/>
                  <xsl:text>icons/piefailed.png</xsl:text>
                </xsl:attribute>
              </img>
              <xsl:text>&nbsp;</xsl:text>
              <xsl:call-template name="lc-piefailed"/>
              <xsl:text>  </xsl:text>
              <img width="9" height="9">
                <xsl:attribute name="src">
                  <xsl:call-template name="basedir"/>
                  <xsl:text>icons/piepassed.png</xsl:text>
                </xsl:attribute>
              </img>
              <xsl:text>&nbsp;</xsl:text>
              <xsl:call-template name="lc-piepassed"/>
              <xsl:if test="$ignorenotimplemented = 0 or $ignoreskipped = 0">
                <xsl:text>  </xsl:text>
                <img width="9" height="9">
                  <xsl:attribute name="src">
                    <xsl:call-template name="basedir"/>
                    <xsl:text>icons/pieskipped.png</xsl:text>
                  </xsl:attribute>
                </img>
                <xsl:text>&nbsp;</xsl:text>
                <xsl:call-template name="lc-pieskipped"/>
              </xsl:if>
            </p>
          </div>
        </div>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ create-legend -->

  <xsl:template name="create-legend">
    <div class="legend">
      <div class="legenditem">
        <div class="icon">
          <img width="16" height="16">
            <xsl:attribute name="src">
              <xsl:call-template name="basedir"/>
              <xsl:text>icons/tests.png</xsl:text>
            </xsl:attribute>
          </img>
        </div>
        <div class="desc">
          <xsl:call-template name="lc-numtestcase"/>
        </div>
      </div>
      <div class="legenditem">
        <div class="icon">
          <img width="16" height="16">
            <xsl:attribute name="src">
              <xsl:call-template name="basedir"/>
              <xsl:choose>
                <xsl:when test="$ignoreskipped = 0">
                  <xsl:text>icons/skippedsets.png</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="$ignorenotimplemented = 0">
                      <xsl:text>icons/notimpl.png</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text>icons/run.png</xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
          </img>
        </div>
        <div class="desc">
          <xsl:choose>
            <xsl:when test="$ignoreskipped = 0">
              <xsl:call-template name="lc-numskippedsets"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="$ignorenotimplemented = 0">
                  <xsl:call-template name="lc-numnotimpl"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="lc-numexecuted"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </div>
      </div>
      <div class="legenditem">
        <div class="icon">
          <img width="16" height="16">
            <xsl:attribute name="src">
              <xsl:call-template name="basedir"/>
              <xsl:text>icons/exception.png</xsl:text>
            </xsl:attribute>
          </img>
        </div>
        <div class="desc">
          <xsl:call-template name="lc-numexcepted"/>
        </div>
      </div>
      <div class="legenditem">
        <div class="icon">
          <img width="16" height="16">
            <xsl:attribute name="src">
              <xsl:call-template name="basedir"/>
              <xsl:choose>
                <xsl:when test="$ignoreskipped = 0">
                  <xsl:choose>
                    <xsl:when test="$ignorenotimplemented = 0">
                      <xsl:text>icons/notimpl.png</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text>icons/run.png</xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="$ignorenotimplemented = 0">
                      <xsl:text>icons/run.png</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text>icons/percent.png</xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
          </img>
        </div>
        <div class="desc">
          <xsl:choose>
            <xsl:when test="$ignoreskipped = 0">
              <xsl:choose>
                <xsl:when test="$ignorenotimplemented = 0">
                  <xsl:call-template name="lc-numnotimpl"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="lc-numexecuted"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="$ignorenotimplemented = 0">
                  <xsl:call-template name="lc-numexecuted"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="lc-percentpassed"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </div>
      </div>
      <div class="legenditem">
        <div class="icon">
          <img width="16" height="16">
            <xsl:attribute name="src">
              <xsl:call-template name="basedir"/>
              <xsl:text>icons/error.png</xsl:text>
            </xsl:attribute>
          </img>
        </div>
        <div class="desc">
          <xsl:call-template name="lc-numerror"/>
        </div>
      </div>
      <div class="legenditem">
        <div class="icon">
          <img width="16" height="16">
            <xsl:attribute name="src">
              <xsl:call-template name="basedir"/>
              <xsl:choose>
                <xsl:when test="$ignoreskipped = 0">
                  <xsl:choose>
                    <xsl:when test="$ignorenotimplemented = 0">
                      <xsl:text>icons/run.png</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text>icons/percent.png</xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="$ignorenotimplemented = 0">
                      <xsl:text>icons/percent.png</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text>icons/duration.png</xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
          </img>
        </div>
        <div class="desc">
          <xsl:choose>
            <xsl:when test="$ignoreskipped = 0">
              <xsl:choose>
                <xsl:when test="$ignorenotimplemented = 0">
                  <xsl:call-template name="lc-numexecuted"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="lc-percentpassed"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="$ignorenotimplemented = 0">
                  <xsl:call-template name="lc-percentpassed"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="lc-duration-long"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </div>
      </div>
      <div class="legenditem">
        <div class="icon">
          <img width="16" height="16">
            <xsl:attribute name="src">
              <xsl:call-template name="basedir"/>
              <xsl:text>icons/experror.png</xsl:text>
            </xsl:attribute>
          </img>
        </div>
        <div class="desc">
          <xsl:call-template name="lc-numexperror"/>
        </div>
      </div>
      <div class="legenditem">
        <div class="icon">
          <img width="16" height="16">
            <xsl:attribute name="src">
              <xsl:call-template name="basedir"/>
              <xsl:choose>
                <xsl:when test="$ignoreskipped = 0">
                  <xsl:choose>
                    <xsl:when test="$ignorenotimplemented = 0">
                      <xsl:text>icons/percent.png</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text>icons/duration.png</xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="$ignorenotimplemented = 0">
                      <xsl:text>icons/duration.png</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text>icons/realtime.png</xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
          </img>
        </div>
        <div class="desc">
          <xsl:choose>
            <xsl:when test="$ignoreskipped = 0">
              <xsl:choose>
                <xsl:when test="$ignorenotimplemented = 0">
                  <xsl:call-template name="lc-percentpassed"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="lc-duration-long"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="$ignorenotimplemented = 0">
                  <xsl:call-template name="lc-duration-long"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="lc-realtime-long"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </div>
      </div>
      <div class="legenditem">
        <div class="icon">
          <img width="16" height="16">
            <xsl:attribute name="src">
              <xsl:call-template name="basedir"/>
              <xsl:text>icons/ok.png</xsl:text>
            </xsl:attribute>
          </img>
        </div>
        <div class="desc">
          <xsl:call-template name="lc-numpassed"/>
        </div>
      </div>
      <div class="legenditem">
        <div class="icon">
          <xsl:choose>
            <xsl:when test="$ignoreskipped = 0 or $ignorenotimplemented = 0">
              <img width="16" height="16">
                <xsl:attribute name="src">
                  <xsl:call-template name="basedir"/>
                  <xsl:choose>
                    <xsl:when test="$ignoreskipped = 0">
                      <xsl:choose>
                        <xsl:when test="$ignorenotimplemented = 0">
                          <xsl:text>icons/duration.png</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:text>icons/realtime.png</xsl:text>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text>icons/realtime.png</xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
              </img>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>&nbsp;</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </div>
        <div class="desc">
          <xsl:choose>
            <xsl:when test="$ignoreskipped = 0">
              <xsl:choose>
                <xsl:when test="$ignorenotimplemented = 0">
                  <xsl:call-template name="lc-duration-long"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="lc-realtime-long"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="$ignorenotimplemented = 0">
                  <xsl:call-template name="lc-realtime-long"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>&nbsp;</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </div>
      </div>
      <xsl:if test="$ignoreskipped = 0">
        <div class="legenditem">
          <div class="icon">
            <img width="16" height="16">
              <xsl:attribute name="src">
                <xsl:call-template name="basedir"/>
                <xsl:text>icons/skipped.png</xsl:text>
              </xsl:attribute>
            </img>
          </div>
          <div class="desc">
            <xsl:call-template name="lc-numskipped"/>
          </div>
        </div>
        <div class="legenditem">
          <div class="icon">
            <xsl:choose>
              <xsl:when test="$ignorenotimplemented = 0">
                <img width="16" height="16">
                  <xsl:attribute name="src">
                    <xsl:call-template name="basedir"/>
                    <xsl:text>icons/realtime.png</xsl:text>
                  </xsl:attribute>
                </img>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>&nbsp;</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </div>
          <div class="desc">
            <xsl:choose>
              <xsl:when test="$ignorenotimplemented = 0">
                <xsl:call-template name="lc-realtime-long"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>&nbsp;</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </div>
        </div>
      </xsl:if>
    </div>
  </xsl:template>

  <!-- }}} -->

  <!-- {{{ create-screenshots -->

  <xsl:template name="create-screenshots">
    <xsl:param name="kind" select="'summary'"/>
    <xsl:choose>
      <xsl:when test="screenshot">
        <xsl:for-each select="screenshot">
          <xsl:if test="position() > 1">
            <xsl:choose>
              <xsl:when test="$thumbnails=1 and thumbnail">
                <xsl:text>&nbsp;</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <br/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
          <xsl:variable name="file">
	    <xsl:call-template name="subst-hash">
	      <xsl:with-param name="text" select="ancestor::test-suite/@hfile"/>
	    </xsl:call-template>
          </xsl:variable>
          <a>
            <xsl:attribute name="href">
              <xsl:if test="$kind='summary'">
                <xsl:call-template name="dirnameforjoin">
                  <xsl:with-param name="file" select="$file"/>
                </xsl:call-template>
              </xsl:if>
              <xsl:call-template name="subst-hash">
                <xsl:with-param name="text" select="@src"/>
              </xsl:call-template>
            </xsl:attribute>
            <xsl:choose>
              <xsl:when test="$thumbnails=1 and thumbnail">
                <xsl:variable name="title">
                  <xsl:call-template name="create-screenshot-title"/>
                </xsl:variable>
                <img class="thumbnail"
                  width="{thumbnail/@width}"
                  height="{thumbnail/@height}"
                  alt="title" title="{$title}" align="bottom">
                  <xsl:attribute name="src">
		    <xsl:if test="$kind='summary'">
                      <xsl:call-template name="dirnameforjoin">
			<xsl:with-param name="file" select="$file"/>
                      </xsl:call-template>
		    </xsl:if>
                    <xsl:call-template name="subst-hash">
                      <xsl:with-param name="text" select="thumbnail/@src"/>
                    </xsl:call-template>
                  </xsl:attribute>
                </img>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="create-screenshot-title"/>
              </xsl:otherwise>
            </xsl:choose>
          </a>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <!-- <xsl:text>-</xsl:text> -->
        <xsl:text>&nbsp;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ create-screenshot -->

  <xsl:template name="create-screenshot">
    <xsl:param name="kind" select="'summary'"/>
    <xsl:variable name="file">
      <xsl:call-template name="subst-hash">
	<xsl:with-param name="text" select="ancestor::test-suite/@hfile"/>
      </xsl:call-template>
    </xsl:variable>
    <a>
      <xsl:attribute name="href">
        <xsl:if test="$kind='summary'">
          <xsl:call-template name="dirnameforjoin">
            <xsl:with-param name="file" select="file"/>
          </xsl:call-template>
        </xsl:if>
        <xsl:call-template name="subst-hash">
          <xsl:with-param name="text" select="@src"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="$thumbnails=1 and thumbnail">
          <xsl:variable name="title">
            <xsl:call-template name="create-screenshot-title"/>
          </xsl:variable>
          <img class="thumbnail"
            width="{thumbnail/@width}"
            height="{thumbnail/@height}"
            alt="title" title="{$title}" align="bottom">
            <xsl:attribute name="src">
	      <xsl:if test="$kind='summary'">
                <xsl:call-template name="dirnameforjoin">
		  <xsl:with-param name="file" select="$file"/>
                </xsl:call-template>
	      </xsl:if>
              <xsl:call-template name="subst-hash">
                <xsl:with-param name="text" select="thumbnail/@src"/>
              </xsl:call-template>
            </xsl:attribute>
          </img>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="create-screenshot-title"/>
        </xsl:otherwise>
      </xsl:choose>
    </a>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ create-result-icon -->

  <xsl:template name="create-result-icon">
    <xsl:param name="result" select="ok"/>
    <img width="16" height="16">
      <xsl:choose>
        <xsl:when test="$result = 'exception'">
          <xsl:attribute name="src">
            <xsl:call-template name="basedir"/>
            <xsl:text>icons/exception.png</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="alt">
            <xsl:call-template name="lc-exception"/>
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:call-template name="lc-exception"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="$result = 'error'">
          <xsl:attribute name="src">
            <xsl:call-template name="basedir"/>
            <xsl:text>icons/error.png</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="alt">
            <xsl:call-template name="lc-error"/>
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:call-template name="lc-error"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="$result = 'experror'">
          <xsl:attribute name="src">
            <xsl:call-template name="basedir"/>
            <xsl:text>icons/experror.png</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="alt">
            <xsl:call-template name="lc-experror"/>
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:call-template name="lc-experror"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="$result = 'warning'">
          <xsl:attribute name="src">
            <xsl:call-template name="basedir"/>
            <xsl:text>icons/warning.png</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="alt">
            <xsl:call-template name="lc-warning"/>
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:call-template name="lc-warning"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="src">
            <xsl:call-template name="basedir"/>
            <xsl:text>icons/ok.png</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="alt">
            <xsl:call-template name="lc-passed"/>
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:call-template name="lc-passed"/>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
    </img>
  </xsl:template>

  <!-- }}} -->

  <!-- {{{ create-check-icon -->

  <xsl:template name="create-check-icon">
    <img width="16" height="16" class="icon">
      <xsl:attribute name="src">
        <xsl:call-template name="basedir"/>
        <xsl:text>icons/check.png</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="alt">
        <xsl:call-template name="lc-check"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:call-template name="lc-check"/>
      </xsl:attribute>
    </img>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ create-check-wrn-icon -->

  <xsl:template name="create-check-wrn-icon">
    <img width="16" height="16" class="icon">
      <xsl:attribute name="src">
        <xsl:call-template name="basedir"/>
        <xsl:text>icons/check_wrn.png</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="alt">
        <xsl:call-template name="lc-check"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:call-template name="lc-check"/>
      </xsl:attribute>
    </img>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ create-check-err-icon -->

  <xsl:template name="create-check-err-icon">
    <img width="16" height="16" class="icon">
      <xsl:attribute name="src">
        <xsl:call-template name="basedir"/>
        <xsl:text>icons/check_err.png</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="alt">
        <xsl:call-template name="lc-check"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:call-template name="lc-check"/>
      </xsl:attribute>
    </img>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ create-msg-icon -->

  <xsl:template name="create-msg-icon">
    <img width="16" height="16" class="icon">
      <xsl:attribute name="src">
        <xsl:call-template name="basedir"/>
        <xsl:text>icons/msg.png</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="alt">
        <xsl:call-template name="lc-message"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:call-template name="lc-message"/>
      </xsl:attribute>
    </img>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ create-msg-wrn-icon -->

  <xsl:template name="create-msg-wrn-icon">
    <img width="16" height="16" class="icon">
      <xsl:attribute name="src">
        <xsl:call-template name="basedir"/>
        <xsl:text>icons/msg_wrn.png</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="alt">
        <xsl:call-template name="lc-message"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:call-template name="lc-message"/>
      </xsl:attribute>
    </img>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ create-msg-err-icon -->

  <xsl:template name="create-msg-err-icon">
    <img width="16" height="16" class="icon">
      <xsl:attribute name="src">
        <xsl:call-template name="basedir"/>
        <xsl:text>icons/msg_err.png</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="alt">
        <xsl:call-template name="lc-message"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:call-template name="lc-message"/>
      </xsl:attribute>
    </img>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ create-setup-icon -->

  <xsl:template name="create-setup-icon">
    <img width="16" height="16" class="icon">
      <xsl:attribute name="src">
        <xsl:call-template name="basedir"/>
        <xsl:text>icons/setup.png</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="alt">
        <xsl:call-template name="lc-setup"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:call-template name="lc-setup"/>
      </xsl:attribute>
    </img>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ create-cleanup-icon -->

  <xsl:template name="create-cleanup-icon">
    <img width="16" height="16" class="icon">
      <xsl:attribute name="src">
        <xsl:call-template name="basedir"/>
        <xsl:text>icons/cleanup.png</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="alt">
        <xsl:call-template name="lc-cleanup"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:call-template name="lc-cleanup"/>
      </xsl:attribute>
    </img>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ create-screenshot-icon -->

  <xsl:template name="create-screenshot-icon">
    <img width="16" height="16" class="icon">
      <xsl:attribute name="src">
        <xsl:call-template name="basedir"/>
        <xsl:text>icons/screenshot.png</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="alt">
        <xsl:call-template name="lc-screenshot"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:call-template name="lc-screenshot"/>
      </xsl:attribute>
    </img>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ create-screenshot-name -->

  <xsl:template name="create-screenshot-name">
    <xsl:choose>
      <xsl:when test="@name and @name != ''">
        <xsl:value-of select="@name"/>
      </xsl:when>
      <xsl:when test="@screen">
	<xsl:call-template name="lc-screenshot-of-screen"/>
	<xsl:value-of select="@screen"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="lc-screenshot"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ create-screenshot-title -->

  <xsl:template name="create-screenshot-title">
    <xsl:choose>
      <xsl:when test="@title and @title != ''">
	<xsl:call-template name="lc-screenshot"/>
	<xsl:text> </xsl:text>
        <xsl:value-of select="@title"/>
      </xsl:when>
      <xsl:when test="@screen">
	<xsl:call-template name="lc-screenshot-of-screen"/>
	<xsl:value-of select="@screen"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="lc-screenshot"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="@client and @client != ''">
      <xsl:text> [</xsl:text>
      <xsl:value-of select="@client"/>
      <xsl:text> ]</xsl:text>
    </xsl:if>
  </xsl:template>

  <!-- }}} -->

  <!-- }}} -->
  <!-- {{{ Doctag overrides -->

  <!-- {{{ override testset handling to process doctags -->

  <xsl:template match="testset[$doctags=1]" mode="description">
    <xsl:if test="deprecated">
      <dl>
        <xsl:apply-templates select="deprecated"/>
      </dl>
    </xsl:if>
    <xsl:if test="comment">
      <xsl:apply-templates select="comment" mode="description"/>
    </xsl:if>
    <xsl:if test="condition | charvar | author | version | since">
      <dl>
        <xsl:apply-templates select="condition"/>
        <xsl:apply-templates select="charvar"/>
        <xsl:apply-templates select="author"/>
        <xsl:apply-templates select="version"/>
        <xsl:apply-templates select="since"/>
      </dl>
    </xsl:if>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ override testcase handling to process doctags -->

  <xsl:template match="testcase[$doctags=1]" mode="description">
    <xsl:if test="deprecated">
      <xsl:apply-templates select="deprecated"/>
    </xsl:if>
    <xsl:if test="comment">
      <xsl:apply-templates select="comment" mode="description"/>
    </xsl:if>
    <xsl:if test="param | condition | charvar | result | author | version | since">
      <dl>
        <xsl:apply-templates select="param"/>
        <xsl:apply-templates select="condition"/>
        <xsl:apply-templates select="charvar"/>
        <xsl:apply-templates select="result"/>
        <xsl:apply-templates select="author"/>
        <xsl:apply-templates select="version"/>
        <xsl:apply-templates select="since"/>
      </dl>
    </xsl:if>
  </xsl:template>

  <!-- }}} -->

  <!-- }}} -->

</xsl:stylesheet>
