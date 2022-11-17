<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp   "&#160;" >
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xalan="http://xml.apache.org/xslt"
                exclude-result-prefixes="xalan"
                version="1.0">

  <xsl:import href="doc_html.xsl"/>

  <!-- whether to sort packages alphabetically -->
  <xsl:param name="sort_packages" select="'1'"/>

  <!-- whether to sort packages alphabetically -->
  <xsl:param name="sort_procedures" select="'1'"/>

  <!-- whether to include dependencies -->
  <xsl:param name="include_dependencies" select="'1'"/>

  <!-- {{{ Entrypoint -->

  <xsl:template match="/">
    <xsl:call-template name="entrypoint">
      <xsl:with-param name="kind" select="'pkgdoc'"/>
    </xsl:call-template>
  </xsl:template >

  <!-- }}} -->
  <!-- {{{ Pkgdoc summary root node -->

  <xsl:template match="/pkgdoc-summary">

    <h2 class="pkgdocsummarytitle gutter-left" cellspacing="0">
          <xsl:call-template name="lc-summary"/>
    </h2>

    <xsl:if test="comment">
      <div class="gutter-left">
        <xsl:apply-templates select="comment" mode="description"/>
      </div>
    </xsl:if>

    <div class="pkgdocsummary gutter-left" cellspacing="0">
      <div>
        <div class="label">
          <xsl:call-template name="lc-numsuites"/>
        </div>
        <div><xsl:value-of select="count(.//test-suite)"/></div>
      </div>
      <div>
        <div class="label">
          <xsl:call-template name="lc-numpackages"/>
        </div>
        <div><xsl:value-of select="summary/@packages"/></div>
      </div>
      <div>
        <div class="label">
          <xsl:call-template name="lc-numprocedures"/>
        </div>
        <div><xsl:value-of select="summary/@procedures"/></div>
      </div>
      <xsl:if test="$include_dependencies = '1'">
        <div>
          <div class="label">
            <xsl:call-template name="lc-numdependencies"/>
          </div>
          <div><xsl:value-of select="summary/@dependencies"/></div>
        </div>
      </xsl:if>
    </div>

    <xsl:call-template name="list-all-suites"/>
    <!-- <xsl:call-template name="list-all-packages"/> -->
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
    <xsl:if test=".//package | .//procedure | .//dependency">
      <nav class="pkgdocnav">
        <xsl:if test=".//package">
          <a href="#allpackages" class="nav-link">
            <xsl:call-template name="lc-packagesoverview"/>
          </a>
        </xsl:if>
        <xsl:if test=".//procedure | .//dependency">
          <a href="#allprocedures" class="nav-link">
            <xsl:call-template name="lc-packagesandproceduresoverview"/>
          </a>
        </xsl:if>
        <a href="#details" class="nav-link">
          <xsl:call-template name="lc-details"/>
        </a>
      </nav>
    </xsl:if>

    <xsl:call-template name="list-all-branches"/>
    <xsl:call-template name="list-all-branches-and-leaves">
      <xsl:with-param name="kind" select="'pkgdoc'"/>
    </xsl:call-template>
    <xsl:if test=".//package | .//procedure | .//dependency">
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
      <xsl:when test="$sort_procedures = '1'">
        <xsl:for-each select="procedure">
          <xsl:sort select="@qname"/>
          <xsl:apply-templates select="." mode="leaf"/>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="procedure">
          <xsl:apply-templates select="." mode="leaf"/>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="$include_dependencies = '1'">
      <xsl:choose>
        <xsl:when test="$sort_procedures = '1'">
          <xsl:for-each select="dependency">
            <xsl:sort select="@qname"/>
            <xsl:apply-templates select="." mode="leaf"/>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="dependency">
            <xsl:apply-templates select="." mode="leaf"/>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>

    <!-- one level of branches -->
    <xsl:choose>
      <xsl:when test="$sort_packages = '1'">
        <xsl:for-each select="package">
          <xsl:sort select="@qname"/>
          <xsl:apply-templates select="." mode="branch"/>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="package">
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

  <xsl:template match="pkgdoc-summary" mode="doctitle">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Package Dokumentation Zusammenfassung</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Package Documentation Summary</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="test-suite" mode="doctitle">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Package Dokumentation für </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Package Documentation for </xsl:text>
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
  <xsl:template match="pkgdoc-summary" mode="links">
    <a class="nav-link ">
      <xsl:apply-templates select="." mode="link-to"/>
      <xsl:call-template name="lc-summary"/>
    </a>
  </xsl:template>

  <xsl:template match="test-suite" mode="summarylink">
    <a class="nav-link">
      <xsl:attribute name="href">
        <xsl:call-template name="basedir"/>
        <xsl:text>pkgdoc.html</xsl:text>
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
        <nav class="pkgdocsuiteslinks gutter-left">
          <xsl:apply-templates select="." mode="create-anchor"/>
          <xsl:for-each select="ancestor-or-self::*">
            <xsl:apply-templates select="." mode="links"/>
          </xsl:for-each>
        </nav>

        <h2 class="pkgdocsuitestitle gutter-left">
          <xsl:choose>
            <xsl:when test="$lang='de'">
              <xsl:text>Testsuite Übersicht</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>Test-suite overview</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </h2>

        <table class="pkgdocsuiteslist" cellspacing="0">
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
            <th class="numpackages">
              <xsl:call-template name="lc-numpackages"/>
            </th>
            <th class="numprocedures">
              <xsl:call-template name="lc-numprocedures"/>
            </th>
            <xsl:if test="$include_dependencies = '1'">
              <th class="numdependencies">
                <xsl:call-template name="lc-numdependencies"/>
              </th>
            </xsl:if>
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
              <td class="numpackages">
                <xsl:value-of select="summary/@packages"/>
              </td>
              <td class="numprocedures">
                <xsl:value-of select="summary/@procedures"/>
              </td>
              <xsl:if test="$include_dependencies = '1'">
                <td class="numdependencies">
                  <xsl:value-of select="summary/@dependencies"/>
                </td>
              </xsl:if>
            </tr>
          </xsl:for-each>
        </table>
      </div>
    </xsl:if>
  </xsl:template>

  <!-- }}} -->

  <!-- Branch overview level -->
  <!-- {{{ get-branch-class -->

  <!-- Get the node type of branch-level nodes -> package -->
  <xsl:template name="get-branch-class">
    <xsl:text>package</xsl:text>
  </xsl:template>


  <!-- }}} -->
  <!-- {{{ get-branch-list-title -->

  <!-- Get the title for the overview of branch-level nodes -> Test-set overview -->
  <xsl:template name="get-branch-list-title">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Package Übersicht</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Package overview</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <!-- <xsl:text>rel/name/ofSuite.qft</xsl:text> -->
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ get-branch-and-leaves-list-title -->

  <!-- Get the title for the overview of branch-level nodes -> Test-set overview -->
  <xsl:template name="get-branch-and-leaves-list-title">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Package Übersicht</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Package overview</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <!-- <xsl:text>rel/name/ofSuite.qft</xsl:text> -->
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ get-sort-branches -->

  <!-- Whether to sort branch nodes -->
  <xsl:template name="get-sort-branches">
    <xsl:value-of select="$sort_packages"/>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ get-branch-headers -->

  <!-- Create the table headers for the overview list of branch nodes,
       i.e. the list of test-sets -->
  <xsl:template name="get-branch-headers">
    <xsl:param name="withleaf" select="'false'"/>
    <th class="margin"/>
    <th class="package">
      <xsl:call-template name="lc-package"/>
      <xsl:if test="$withleaf = 'true'">
        <xsl:text>/</xsl:text>
        <xsl:call-template name="lc-procedure"/>
        <xsl:text>/</xsl:text>
        <xsl:call-template name="lc-dependency"/>
      </xsl:if>
    </th>
    <th class="desc">
      <xsl:call-template name="lc-description"/>
    </th>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ get-branch-details -->

  <xsl:template name="get-branch-details">
    <td class="margin"/>
    <td class="{name()}">
      <div class="padding-left-{count(ancestor::package)*16}" style="padding-left:{count(ancestor::package)*16}px">
        <xsl:choose>
          <xsl:when test="$nodeicons=1">
            <div class="withicon">
              <div class="icon">
                <xsl:choose>
                  <xsl:when test="name() = 'package'">
                    <xsl:call-template name="create-package-icon"/>
                  </xsl:when>
                  <xsl:when test="name() = 'procedure'">
                    <xsl:call-template name="create-procedure-icon"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="create-dependency-icon"/>
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

  <!-- Get the title of branch-level nodes -> Package -->
  <xsl:template name="get-branch-title">
    <xsl:call-template name="lc-package"/>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ create-branch-title-margin -->

  <xsl:template match="package" mode="create-branch-title-margin">
    <td class="margin"/>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ get-sort-leaves -->

  <!-- Whether to sort leaf nodes -->
  <xsl:template name="get-sort-leaves">
    <xsl:value-of select="$sort_procedures"/>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ get-leaf-headers -->

  <!-- Create the table headers for the list of leaf nodes in a branch entry,
       i.e. the list of test-cases for a test-set -->
  <xsl:template name="get-leaf-headers">
    <th class="margin"/>
    <th class="procedure">
      <xsl:choose>
        <xsl:when test="$include_dependencies = '1'">
          <xsl:call-template name="lc-procedure-dependency"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="lc-procedure"/>
        </xsl:otherwise>
      </xsl:choose>
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
    <td class="procedure">
      <xsl:choose>
        <xsl:when test="$nodeicons=1">
          <div class="withicon">
            <div class="icon">
              <xsl:choose>
                <xsl:when test="name() = 'procedure'">
                  <xsl:call-template name="create-procedure-icon"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="create-dependency-icon"/>
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

  <!-- Get the node type of leaf-level nodes -> procedure -->
  <xsl:template name="get-leaf-class">
    <xsl:text>procedure</xsl:text>
  </xsl:template>


  <!-- }}} -->
  <!-- {{{ get-leaf-title -->

  <!-- Get the title of leaf-level nodes -> Test-set -->
  <xsl:template name="get-leaf-title">
    <xsl:choose>
      <xsl:when test="name() = 'dependency'">
        <xsl:call-template name="lc-dependency"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="lc-procedure"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ create-leaf-title-margin -->

  <xsl:template match="procedure | dependency" mode="create-leaf-title-margin">
    <td class="margin"/>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ leaf-extras -->

  <xsl:template match="procedure | dependency" mode="leaf-extras">
  </xsl:template>


  <!-- }}} -->

  <!-- {{{ Link to -->

  <xsl:template match="package | procedure | dependency" mode="link-to">
    <xsl:attribute name="href">
      <xsl:text>#</xsl:text>
      <xsl:call-template name="url-encode">
        <xsl:with-param name="str" select="@qname"/>
      </xsl:call-template>
    </xsl:attribute>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ Create anchor -->

  <xsl:template match="package | procedure | dependency" mode="create-anchor">
    <a>
      <xsl:attribute name="name">
        <xsl:call-template name="url-encode">
          <xsl:with-param name="str" select="@qname"/>
        </xsl:call-template>
      </xsl:attribute>
    </a>
  </xsl:template>

  <!-- }}} -->

  <!-- }}} -->
  <!-- {{{ Doctag overrides -->

  <!-- {{{ override package handling to process doctags -->

  <xsl:template match="package[$doctags='1']" mode="description">
    <xsl:if test="deprecated">
        <xsl:apply-templates select="deprecated"/>
    </xsl:if>
    <xsl:if test="comment">
      <xsl:apply-templates select="comment" mode="description"/>
    </xsl:if>
    <xsl:if test="author | version | since">
      <dl>
        <xsl:apply-templates select="author"/>
        <xsl:apply-templates select="version"/>
        <xsl:apply-templates select="since"/>
      </dl>
    </xsl:if>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ override procedure handling to process doctags -->

  <xsl:template match="procedure[$doctags='1'] | dependency[$doctags='1']" mode="description">
    <xsl:if test="deprecated">
      <xsl:apply-templates select="deprecated"/>
    </xsl:if>
    <xsl:if test="comment">
      <xsl:apply-templates select="comment" mode="description"/>
    </xsl:if>
    <xsl:if test="param |charvar | catches | return | result | throws | author | version | since">
      <dl>
        <xsl:apply-templates select="param"/>
        <xsl:apply-templates select="charvar"/>
        <xsl:apply-templates select="return"/>
        <xsl:apply-templates select="result"/>
        <xsl:apply-templates select="throws"/>
        <xsl:apply-templates select="catches"/>
        <xsl:apply-templates select="author"/>
        <xsl:apply-templates select="version"/>
        <xsl:apply-templates select="since"/>
      </dl>
    </xsl:if>
  </xsl:template>

  <!-- }}} -->

  <!-- }}} -->
  <!-- {{{ Helpers -->


  <!-- }}} -->

</xsl:stylesheet>
