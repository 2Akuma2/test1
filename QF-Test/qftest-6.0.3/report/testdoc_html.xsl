<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp   "&#160;" >
  <!ENTITY ancestorTeststepNodes  "ancestor::teststep | ancestor::dependency
                                   | ancestor::setup | ancestor::cleanup" >
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xalan="http://xml.apache.org/xslt"
                exclude-result-prefixes="xalan"
                version="1.0">

  <xsl:import href="doc_html.xsl"/>

  <!-- Whether to show teststeps -->
  <xsl:param name="teststeps" select="1"/>

  <!-- whether to sort testsets alphabetically -->
  <xsl:param name="sort_testsets" select="'0'"/>

  <!-- whether to sort testsets alphabetically -->
  <xsl:param name="sort_testcases" select="'0'"/>

  <!-- {{{ Entrypoint -->

  <xsl:template match="/">
    <xsl:call-template name="entrypoint">
      <xsl:with-param name="kind" select="'testdoc'"/>
    </xsl:call-template>
  </xsl:template >

  <!-- }}} -->
  <!-- {{{ Testdoc summary root node -->

  <xsl:template match="/testdoc-summary">

    <h2 class="testdocsummarytitle gutter-left">
      <xsl:call-template name="lc-summary"/>
    </h2>

    <xsl:if test="comment">
      <div class="gutter-left">
        <xsl:apply-templates select="comment" mode="description"/>
      </div>
    </xsl:if>

    <div class="testdocsummary gutter-left">
      <div>
        <div class="label">
          <xsl:call-template name="lc-numsuites"/>
        </div>
        <div><xsl:value-of select="count(.//test-suite)"/></div>
      </div>
      <div>
        <div class="label">
          <xsl:call-template name="lc-numtestsets"/>
        </div>
        <div><xsl:value-of select="summary/@testsets"/></div>
      </div>
      <div>
        <div class="label">
          <xsl:call-template name="lc-numtestcases"/>
        </div>
        <div><xsl:value-of select="summary/@testcases"/></div>
      </div>
    </div>

    <xsl:call-template name="list-all-suites"/>
    <!-- <xsl:call-template name="list-all-testsets"/> -->
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ Test-suite root node -->

  <xsl:template match="/test-suite">

    <section class="summarylegend gutter-left">
      <div class="summary">
        <h2 class="suitesummarytitle">
          <xsl:call-template name="lc-summary"/>
        </h2>
        <div class="suitesummary">
          <div>
            <div class="label">
              <xsl:call-template name="lc-Testsuite"/>
            </div>
            <div>
              <xsl:call-template name="basename">
                <xsl:with-param name="file" select="@sourcefile"/>
              </xsl:call-template>
            </div>
          </div>
          <div>
            <div class="label">
              <xsl:call-template name="lc-directory"/>
            </div>
            <div>
              <xsl:call-template name="dirname">
                <xsl:with-param name="file" select="@sourcefile"/>
              </xsl:call-template>
            </div>
          </div>
        </div>
      </div>
    </section>

    <xsl:if test="comment">
      <section class="suitedesc gutter-left">
        <div class="test-suitedesc">
          <xsl:apply-templates select="." mode="description"/>
        </div>
      </section>
    </xsl:if>

    <!-- Local navigation links -->
    <xsl:if test=".//testset |
                  .//testcase">
      <nav class="testdocnav">
        <xsl:if test=".//testset">
          <a href="#alltdtestsets">
            <xsl:call-template name="lc-testsetsoverview"/>
          </a>
        </xsl:if>
        <xsl:if test=".//testcase">
          <a href="#alltdtestcases">
            <xsl:call-template name="lc-testsetsandtestcasesoverview"/>
          </a>
        </xsl:if>
          <a href="#details">
            <xsl:call-template name="lc-details"/>
          </a>
      </nav>
    </xsl:if>

    <xsl:call-template name="list-all-branches"/>
    <xsl:call-template name="list-all-branches-and-leaves">
      <xsl:with-param name="kind" select="'testdoc'"/>
    </xsl:call-template>

    <xsl:if test=".//testset | .//testcase">
      <div class="details">
        <a name="details"/>
        <nav class="detailslinks overviewlinks gutter-left">
          <xsl:apply-templates select="." mode="create-anchor"/>
          <xsl:for-each select="ancestor-or-self::*">
            <xsl:apply-templates select="." mode="links"/>
          </xsl:for-each>
        </nav>

        <h2 class="detailstitle title gutter-left">
          <xsl:call-template name="lc-details"/>
        </h2>
      </div>
    </xsl:if>

    <!-- top-level leaves outside any branch -->
    <xsl:choose>
      <xsl:when test="$sort_testcases = '1'">
        <xsl:for-each select="testcase">
          <xsl:sort select="@qname"/>
          <xsl:apply-templates select="." mode="leaf"/>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="testcase">
          <xsl:apply-templates select="." mode="leaf"/>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>

    <!-- one level of branches -->
    <xsl:choose>
      <xsl:when test="$sort_testsets = '1'">
        <xsl:for-each select="testset">
          <xsl:sort select="@qname"/>
          <xsl:apply-templates select="." mode="branch"/>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="testset">
          <xsl:apply-templates select="." mode="branch"/>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ Abstract calls and overrides -->

  <!-- {{{ doctitle -->

  <xsl:template match="*" mode="doctitle"/>

  <xsl:template match="/" mode="doctitle">
    <xsl:apply-templates mode="doctitle"/>
  </xsl:template>

  <xsl:template match="testdoc-summary" mode="doctitle">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Testdokumentation Zusammenfassung</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Test Documentation Summary</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="test-suite" mode="doctitle">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Testdokumentation für </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Test Documentation for </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="title">
        <xsl:value-of select="title"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="name">
          <xsl:call-template name="basename">
            <xsl:with-param name="file" select="@sourcefile"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$lang='de'">
            <xsl:text>Testsuite</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>Test-suite</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="$name and $name != ''">
          <xsl:text> </xsl:text>
          <xsl:value-of select="$name"/>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ links -->

  <!-- create a link to the summary document -->
  <xsl:template match="testdoc-summary" mode="links">
    <a class="nav-link">
      <xsl:apply-templates select="." mode="link-to"/>
      <xsl:call-template name="lc-summary"/>
    </a>
  </xsl:template>

  <xsl:template match="test-suite" mode="summarylink">
    <a class="nav-link">
      <xsl:attribute name="href">
        <xsl:call-template name="basedir"/>
        <xsl:text>testdoc.html</xsl:text>
      </xsl:attribute>
      <xsl:call-template name="lc-summary"/>
    </a>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ linkname -->

  <!-- for test-suite: use the run-log filename -->
  <xsl:template match="test-suite" mode="linkname">
    <xsl:value-of select="@sourcefile"/>
  </xsl:template>

  <xsl:template match="report-summary" mode="linkname">
  </xsl:template>

  <!-- }}} -->

  <!-- Suite overview -->
  <!-- {{{ list-all-suites -->

  <xsl:template name="list-all-suites">
    <xsl:if test=".//test-suite">
      <div class="branch">
        <nav class="testdocsuiteslinks gutter-left">
          <xsl:apply-templates select="." mode="create-anchor"/>
          <xsl:for-each select="ancestor-or-self::*">
            <xsl:apply-templates select="." mode="links"/>
          </xsl:for-each>
        </nav>
        <h2 class="testdocsuitestitle gutter-left">
          <xsl:choose>
            <xsl:when test="$lang='de'">
              <xsl:text>Testsuite Übersicht</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>Test-suite overview</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </h2>

        <table class="testdocsuiteslist" cellspacing="0">
          <tr class="headers">
            <th class="margin"/>
            <th class="testsuite">
              <xsl:call-template name="lc-Testsuite"/>
            </th>
            <th class="directory">
              <xsl:call-template name="lc-directory"/>
            </th>
            <th class="desc">
              <xsl:call-template name="lc-description"/>
            </th>
            <th class="numtestsets">
              <xsl:call-template name="lc-numtestsets"/>
            </th>
            <th class="numtestcases">
              <xsl:call-template name="lc-numtestcases"/>
            </th>
          </tr>

          <xsl:for-each select=".//test-suite">
            <xsl:sort select="@sourcefile"/>
            <tr>
              <td class="margin"/>
              <td class="testsuite">
                <a href="{@hfile}">
                  <xsl:call-template name="basename">
                    <xsl:with-param name="file" select="@sourcefile"/>
                  </xsl:call-template>
                </a>
              </td>
              <td class="directory">
                <xsl:call-template name="dirname">
                  <xsl:with-param name="file" select="@sourcefile"/>
                </xsl:call-template>
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
              <td class="numtestsets">
                <xsl:value-of select="summary/@testsets"/>
              </td>
              <td class="numtestcases">
                <xsl:value-of select="summary/@testcases"/>
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
    <xsl:text>tdtestset</xsl:text>
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

  <!-- Whether to sort branch nodes -->
  <xsl:template name="get-sort-branches">
    <xsl:value-of select="$sort_testsets"/>
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
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ get-branch-details -->

  <!-- List of testsets -->
  <xsl:template name="get-branch-details">
    <td class="margin">
    </td>
    <td class="{name()}">
      <div class="padding-left-{count(ancestor::testset)*16}" style="padding-left:{count(ancestor::testset)*16}px">
        <xsl:choose>
          <xsl:when test="$nodeicons=1">
            <div class="withicon">
              <div class="icon">
                <xsl:choose>
                  <xsl:when test="name() = 'testset'">
                    <xsl:call-template name="create-testset-icon"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="create-testcase-icon"/>
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
  </xsl:template>

  <!-- }}} -->

  <!-- Branch level -->
  <!-- {{{ get-branch-title -->

  <!-- Get the title of branch-level nodes -> Testset -->
  <xsl:template name="get-branch-title">
    <xsl:call-template name="lc-testset"/>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ create-branch-title-margin -->

  <xsl:template match="testset" mode="create-branch-title-margin">
    <td class="margin"/>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ get-sort-leaves -->

  <!-- Whether to sort leaf nodes -->
  <xsl:template name="get-sort-leaves">
    <xsl:value-of select="$sort_testcases"/>
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
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ get-leaf-details -->

  <!-- Create the table cells for one leaf nodes in a branch entry,
       i.e. one test-case in a test-set -->
  <xsl:template name="get-leaf-details">
    <td class="margin">
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
  </xsl:template>

  <!-- }}} -->

  <!-- Leaf level -->
  <!-- {{{ get-leaf-class -->

  <!-- Get the node type of leaf-level nodes -> testcase -->
  <xsl:template name="get-leaf-class">
    <xsl:text>tdtestcase</xsl:text>
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
    <td class="margin"/>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ leaf-extras -->

  <xsl:template match="testcase" mode="leaf-extras">
  </xsl:template>

  <xsl:template match="testcase[$teststeps=1 and teststep]" mode="leaf-extras">
    <table class="tdtestcasedetailslist" cellspacing="0">
      <tr>
        <th class="margin"/>
        <th class="teststep">
          <xsl:call-template name="lc-teststep"/>
        </th>
      </tr>
      <tr>
        <td class="margin"/>
        <td class="testcase">
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
      </tr>
      <xsl:for-each select=".//teststep">
        <tr>
          <td class="margin"/>
          <td class="teststep">
            <div class="step padding-left-{(count(&ancestorTeststepNodes;) + 1)*20}" style="padding-left:{(count(&ancestorTeststepNodes;) + 1)*20}px">
              <xsl:choose>
                <xsl:when test="$nodeicons=1">
                  <div class="withicon">
                    <div class="icon">
                      <xsl:call-template name="create-teststep-icon"/>
                    </div>
                    <div class="item">
                      <xsl:value-of select="@name"/>
                      <xsl:if test="comment">
                        <br/>
                        <xsl:apply-templates select="comment" mode="description"/>
                      </xsl:if>
                    </div>
                  </div>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="@name"/>
                  <xsl:if test="comment">
                    <br/>
                    <xsl:apply-templates select="comment" mode="description"/>
                  </xsl:if>
                </xsl:otherwise>
              </xsl:choose>
            </div>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <!-- }}} -->

  <!-- }}} -->
  <!-- {{{ Link to -->

  <xsl:template match="testset | testcase | teststep" mode="link-to">
    <xsl:attribute name="href">
      <xsl:text>#</xsl:text>
      <xsl:call-template name="url-encode">
        <xsl:with-param name="str" select="@qname"/>
      </xsl:call-template>
    </xsl:attribute>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ Create anchor -->

  <xsl:template match="testset | testcase | teststep" mode="create-anchor">
    <a>
      <xsl:attribute name="name">
        <xsl:call-template name="url-encode">
          <xsl:with-param name="str" select="@qname"/>
        </xsl:call-template>
      </xsl:attribute>
    </a>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ Doctag overrides -->

  <!-- {{{ override testset handling to process doctags -->

  <xsl:template match="testset[$doctags='1']" mode="description">
    <xsl:if test="deprecated">
        <xsl:apply-templates select="deprecated"/>
    </xsl:if>
    <xsl:if test="comment">
      <xsl:apply-templates select="comment" mode="description"/>
    </xsl:if>
    <xsl:if test="condition | param | charvar | author | version | since">
      <dl>
        <xsl:apply-templates select="condition"/>
        <xsl:apply-templates select="param"/>
        <xsl:apply-templates select="charvar"/>
        <xsl:apply-templates select="author"/>
        <xsl:apply-templates select="version"/>
        <xsl:apply-templates select="since"/>
      </dl>
    </xsl:if>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ override testcase handling to process doctags -->

  <xsl:template match="testcase[$doctags='1']" mode="description">
    <xsl:if test="deprecated">
      <xsl:apply-templates select="deprecated"/>
    </xsl:if>
    <xsl:if test="comment">
      <xsl:apply-templates select="comment" mode="description"/>
    </xsl:if>
    <xsl:if test="param | condition | charvar | author | version | since">
      <dl>
        <xsl:apply-templates select="param"/>
        <xsl:apply-templates select="condition"/>
        <xsl:apply-templates select="charvar"/>
        <xsl:apply-templates select="author"/>
        <xsl:apply-templates select="version"/>
        <xsl:apply-templates select="since"/>
      </dl>
    </xsl:if>
  </xsl:template>

  <!-- }}} -->

  <!-- }}} -->

</xsl:stylesheet>
