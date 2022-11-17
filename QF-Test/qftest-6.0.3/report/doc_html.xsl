<?xml version="1.0" encoding="UTF-8"?>
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
  <!ENTITY leafNodes "testcase | procedure | dependency" >
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xalan="http://xml.apache.org/xslt"
                exclude-result-prefixes="xalan"
                version="1.0">

  <xsl:import href="helpers.xsl"/>

  <xsl:output method="html"
              encoding="UTF-8"
              indent="yes"
              xalan:indent-amount="2"
              doctype-public="-//W3C//DTD HTML 4.01//EN"/>

<!-- Parameter for the target language. Currently only 'de' is recognized,
     everything else results in an English report
-->
  <xsl:param name="lang" select="'en'"/>

  <!-- Time of creation, already formated -->
  <xsl:param name="currenttime" select="'?'"/>

  <!-- Name of the report -->
  <xsl:param name="reportname"/>

  <!-- whether to pass HTML tags through -->
  <xsl:param name="pass_html" select="1"/>

  <!-- whether to make use of doctags -->
  <xsl:param name="doctags" select="1"/>

  <!-- Whether to show icons for test nodes -->
  <xsl:param name="nodeicons" select="1"/>

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

  <!-- }}} -->

  <!-- {{{ Entry point -->

  <xsl:template name="entrypoint">
    <xsl:param name="kind" select="'report'"/>
    <html>
      <head>
        <link type="text/css" rel="stylesheet">
          <xsl:attribute name="href">
            <xsl:call-template name="basedir"/>
            <xsl:text>css/qftest.css</xsl:text>
          </xsl:attribute>
        </link>
        <link rel="shortcut icon"  type="image/vnd.microsoft.icon">
          <xsl:attribute name="href">
            <xsl:call-template name="basedir"/>
            <xsl:text>icons/favicon.ico</xsl:text>
          </xsl:attribute>
        </link>
        <title>
          <xsl:apply-templates select="." mode="doctitle"/>
        </title>
	<xsl:if test="$kind = 'report'">
	  <script type = "text/javascript">
	      <xsl:attribute name="src">
		  <xsl:call-template name="basedir"/>
		  <xsl:text>user.js</xsl:text>
	      </xsl:attribute>
	  </script>
	</xsl:if>
      </head>
      <body>
        <xsl:call-template name="header"/>
        <xsl:apply-templates/>
        <xsl:call-template name="footer"/>
      </body>
    </html>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ Header -->

  <xsl:template name="header">
    <xsl:param name="title" select="''"/>
    <header class="gutter-left">
      <div class="header">
          <h1 class="title">
            <xsl:apply-templates select="." mode="doctitle"/>
          </h1>
          <div class="homeicon">
            <a href="http://www.qfs.de/en/qftest/index.html">
              <img width="127" height="42" alt="QF-Test" title="QF-Test">
                <xsl:attribute name="src">
                  <xsl:call-template name="basedir"/>
                  <xsl:text>icons/qftest.png</xsl:text>
                </xsl:attribute>
              </img>
            </a>
          </div>
      </div>
      <div class="headerversion">
        <div>
          <xsl:text>Version </xsl:text><xsl:value-of select="//test-suite/@qftest-version"/>
        </div>
      </div>
    </header>
  </xsl:template>


  <!-- }}} -->
  <!-- {{{ Footer -->

  <xsl:template name="footer">
    <footer>
      <div class="createdcopy">
        <xsl:call-template name="lc-created"/>
        <xsl:text>: </xsl:text>
        <xsl:value-of select="$currenttime"/>
      </div>
    </footer>
  </xsl:template>


  <!-- }}} -->

  <!-- {{{ Callables -->

  <!-- {{{ basedir -->

  <xsl:template name="basedir">
    <xsl:value-of select="/*/@basedir"/>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ links -->

  <!-- default: noop -->
  <xsl:template match="*" mode="links"/>
  <xsl:template match="*" mode="summarylink"/>

  <!-- create a link to the node or document -->
  <xsl:template match="test-suite" mode="links">
    <xsl:apply-templates select="." mode="summarylink"/>
    <a class="nav-link test-suite-link">
      <xsl:apply-templates select="." mode="link-to"/>
      <xsl:apply-templates select="." mode="linkname"/>
    </a>
  </xsl:template>

  <xsl:template match="testset | testcase | package | procedure | dependency" mode="links">
    <a class="nav-link">
      <xsl:apply-templates select="." mode="link-to"/>
      <xsl:apply-templates select="." mode="linkname"/>
    </a>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ linkname -->

  <!-- default: noop -->
  <xsl:template match="*" mode="linkname"/>

  <!-- default for useful nodes: use the name -->
  <xsl:template match="*" mode="linkname">
    <xsl:value-of select="@name"/>
  </xsl:template>

  <!-- }}} -->

  <!-- }}} -->
  <!-- {{{ Doctags -->

  <!-- {{{ @author -->

  <xsl:template match="author">
    <dt>
      <xsl:call-template name="lc-author"/>
      <xsl:text>:</xsl:text>
    </dt>
    <dd>
      <xsl:apply-templates mode="pass_through"/>
    </dd>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ @charvar -->

  <xsl:template match="charvar">
    <xsl:if test="position() = 1">
      <dt>
        <xsl:call-template name="lc-charvar"/>
        <xsl:text>:</xsl:text>
      </dt>
    </xsl:if>
    <dd>
      <code><xsl:value-of select="@name"/></code>
      <xsl:text> - </xsl:text>
      <xsl:apply-templates mode="pass_through"/>
    </dd>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ @condition -->

  <xsl:template match="condition">
    <dt>
      <xsl:call-template name="lc-condition"/>
      <xsl:text>:</xsl:text>
    </dt>
    <dd>
      <xsl:apply-templates mode="pass_through"/>
    </dd>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ @deprecated -->

  <xsl:template match="deprecated">
    <p>
      <b><xsl:call-template name="lc-deprecated"/></b>
      <xsl:text>: </xsl:text>
      <xsl:apply-templates mode="pass_through"/>
    </p>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ @param -->

  <xsl:template match="param">
    <xsl:if test="position() = 1">
      <dt>
        <xsl:call-template name="lc-parameters"/>
        <xsl:text>:</xsl:text>
      </dt>
    </xsl:if>
    <dd>
      <code><xsl:value-of select="@name"/></code>
      <xsl:text> - </xsl:text>
      <xsl:apply-templates mode="pass_through"/>
    </dd>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ @result -->

  <xsl:template match="result">
    <dt>
      <xsl:call-template name="lc-result"/>
      <xsl:text>:</xsl:text>
    </dt>
    <dd>
      <xsl:apply-templates mode="pass_through"/>
    </dd>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ @return -->

  <xsl:template match="return">
    <dt>
      <xsl:call-template name="lc-return"/>
      <xsl:text>:</xsl:text>
    </dt>
    <dd>
      <xsl:apply-templates mode="pass_through"/>
    </dd>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ @since -->

  <xsl:template match="since">
    <dt>
      <xsl:call-template name="lc-since"/>
      <xsl:text>:</xsl:text>
    </dt>
    <dd>
      <xsl:apply-templates mode="pass_through"/>
    </dd>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ @throws -->

  <xsl:template match="throws">
    <xsl:if test="position() = 1">
      <dt>
        <xsl:call-template name="lc-exceptions"/>
        <xsl:text>:</xsl:text>
      </dt>
    </xsl:if>
    <dd>
      <code><xsl:value-of select="@name"/></code>
      <xsl:text> - </xsl:text>
      <xsl:apply-templates mode="pass_through"/>
    </dd>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ @catches -->

  <xsl:template match="catches">
    <xsl:if test="position() = 1">
      <dt>
        <xsl:call-template name="lc-catch"/>
        <xsl:text>:</xsl:text>
      </dt>
    </xsl:if>
    <dd>
      <code><xsl:value-of select="@name"/></code>
      <xsl:text> - </xsl:text>
      <xsl:apply-templates mode="pass_through"/>
    </dd>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ @version -->

  <xsl:template match="version">
    <dt>
      <xsl:call-template name="lc-version"/>
      <xsl:text>:</xsl:text>
    </dt>
    <dd>
      <xsl:apply-templates mode="pass_through"/>
    </dd>
  </xsl:template>

  <!-- }}} -->

  <!-- }}} -->
  <!-- {{{ List of branches -->

  <xsl:template name="list-all-branches">
    <xsl:if test=".//testset | .//package">
      <div>
        <xsl:attribute name="class">
          <xsl:text>all</xsl:text>
          <xsl:call-template name="get-branch-class"/>
          <xsl:text>s branch</xsl:text>
        </xsl:attribute>
        <nav>
          <xsl:attribute name="class">
            <xsl:call-template name="get-branch-class"/>
            <xsl:text>alllinks branchlinks gutter-left</xsl:text>
          </xsl:attribute>

          <a>
            <xsl:attribute name="name">
              <xsl:text>all</xsl:text>
              <xsl:call-template name="get-branch-class"/>
              <xsl:text>s</xsl:text>
            </xsl:attribute>
          </a>

          <xsl:apply-templates select="." mode="create-anchor"/>
            <xsl:for-each select="ancestor-or-self::*">
              <xsl:apply-templates select="." mode="links"/>
            </xsl:for-each>
        </nav>

        <h2>
          <xsl:attribute name="class">
            <xsl:call-template name="get-branch-class"/>
            <xsl:text>alltitle branchtitle gutter-left</xsl:text>
          </xsl:attribute>

          <xsl:call-template name="get-branch-list-title"/>
        </h2>

        <table cellspacing="0">
          <xsl:attribute name="class">
            <xsl:call-template name="get-branch-class"/>
            <xsl:text>alllist branchlist</xsl:text>
          </xsl:attribute>

          <tr class="headers">
            <xsl:call-template name="get-branch-headers"/>
          </tr>

          <xsl:variable name="sort">
            <xsl:call-template name="get-sort-branches"/>
          </xsl:variable>

          <xsl:choose>
            <xsl:when test="$sort = '1'">
              <xsl:for-each select=".//testset | .//package">
                <xsl:sort select="@qname"/>
                <!-- <xsl:apply-templates select="." mode="list-leaves"/> -->
                <tr>
                  <!-- <xsl:apply-templates select="." mode="list-branches"/> -->
                  <xsl:call-template name="get-branch-details"/>
                </tr>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select=".//testset | .//package">
                <!-- <xsl:apply-templates select="." mode="list-leaves"/> -->
                <tr>
                  <!-- <xsl:apply-templates select="." mode="list-branches"/> -->
                  <xsl:call-template name="get-branch-details"/>
                </tr>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
        </table>
      </div>
    </xsl:if>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ List of branches including leaves -->

  <xsl:template name="list-all-branches-and-leaves">
    <xsl:param name="kind" select="'report'"/>

    <xsl:if test=".//testset | .//testcase |
                  .//package[$kind = 'pkgdoc'] | .//procedure[$kind = 'pkgdoc'] |
                  .//dependency[$kind = 'pkgdoc']">
      <div>
        <xsl:attribute name="class">
          <xsl:text>all</xsl:text>
          <xsl:call-template name="get-leaf-class"/>
          <xsl:text>s branch</xsl:text>
        </xsl:attribute>
        <nav>
          <xsl:attribute name="class">
            <xsl:call-template name="get-leaf-class"/>
            <xsl:text>alllinks branchlinks gutter-left</xsl:text>
          </xsl:attribute>
          <a>
            <xsl:attribute name="name">
              <xsl:text>all</xsl:text>
              <xsl:call-template name="get-leaf-class"/>
              <xsl:text>s</xsl:text>
            </xsl:attribute>
          </a>

          <xsl:apply-templates select="." mode="create-anchor"/>
          <xsl:for-each select="ancestor-or-self::*">
            <xsl:apply-templates select="." mode="links"/>
          </xsl:for-each>
        </nav>

        <h2>
          <xsl:attribute name="class">
            <xsl:call-template name="get-leaf-class"/>
            <xsl:text>alltitle branchtitle gutter-left</xsl:text>
          </xsl:attribute>

          <xsl:call-template name="get-branch-and-leaves-list-title"/>
        </h2>

        <table cellspacing="0">
          <xsl:attribute name="class">
            <xsl:call-template name="get-leaf-class"/>
            <xsl:text>alllist</xsl:text>
          </xsl:attribute>

          <tr class="headers">
            <xsl:call-template name="get-branch-headers">
              <xsl:with-param name="withleaf" select="'true'"/>
            </xsl:call-template>
          </tr>

          <xsl:variable name="sort">
            <xsl:call-template name="get-sort-branches"/>
          </xsl:variable>

          <xsl:choose>
            <xsl:when test="$sort = '1'">
              <xsl:for-each select=".//testset | .//testcase |
                                    .//package[$kind = 'pkgdoc'] | .//procedure[$kind = 'pkgdoc'] |
                                    .//dependency[$kind = 'pkgdoc']">
                <xsl:sort select="@qname"/>
                <!-- <xsl:apply-templates select="." mode="list-leaves"/> -->
                <tr>
                  <!-- <xsl:apply-templates select="." mode="list-branches"/> -->
                  <xsl:call-template name="get-branch-details"/>
                </tr>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select=".//testset | .//testcase |
                                    .//package[$kind = 'pkgdoc'] | .//procedure[$kind = 'pkgdoc'] |
                                    .//dependency[$kind = 'pkgdoc']">
                <!-- <xsl:apply-templates select="." mode="list-leaves"/> -->
                <tr>
                  <!-- <xsl:apply-templates select="." mode="list-branches"/> -->
                  <xsl:call-template name="get-branch-details">
                    <xsl:with-param name="withleaf" select="'true'"/>
                  </xsl:call-template>
                </tr>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
        </table>
      </div>
    </xsl:if>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ Single branch -->

  <xsl:template match="*" mode="create-branch-title-margin">
    <td class="margin"/>
  </xsl:template>

  <!-- Create the entry for one branch, i.e. the table with its leaf nodes
       followed by individual entries for the leaves -->

  <xsl:template match="testset | package" mode="branch">
      <xsl:variable name="sort">
        <xsl:call-template name="get-sort-leaves"/>
      </xsl:variable>

    <div>
      <xsl:attribute name="class">
        <xsl:call-template name="get-branch-class"/>
        <xsl:text> branch</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="name">
        <xsl:value-of select="@qname"/>
      </xsl:attribute>
      <nav>
        <xsl:attribute name="class">
          <xsl:call-template name="get-branch-class"/>
          <xsl:text>links branchlinks gutter-left</xsl:text>
        </xsl:attribute>
        <xsl:apply-templates select="." mode="create-anchor"/>
        <xsl:for-each select="ancestor::*">
          <xsl:apply-templates select="." mode="links"/>
        </xsl:for-each>
        <div class="links">
          <xsl:apply-templates select="." mode="cross-links"/>
        </div>
      </nav>

      <h3>
        <xsl:attribute name="class">
          <xsl:call-template name="get-branch-class"/>
          <xsl:text>title branchtitle gutter-left</xsl:text>
        </xsl:attribute>
        <xsl:apply-templates select="." mode="create-branch-title-margin"/>
        <xsl:call-template name="get-branch-title"/>
        <xsl:text>: "</xsl:text>
        <xsl:value-of select="@name"/>
        <xsl:text>"</xsl:text>
      </h3>

      <div>
        <xsl:attribute name="class">
          <xsl:call-template name="get-branch-class"/>
          <xsl:text>desc branchdesc gutter-left</xsl:text>
        </xsl:attribute>
        <xsl:apply-templates select="." mode="description"/>
      </div>

      <xsl:apply-templates select="." mode="branch-extras"/>

      <xsl:if test="&leafNodes;">
        <table cellspacing="0">
          <xsl:attribute name="class">
            <xsl:call-template name="get-branch-class"/>
            <xsl:text>list</xsl:text>
          </xsl:attribute>

          <tr class="headers">
            <xsl:call-template name="get-leaf-headers"/>
          </tr>

          <xsl:choose>
            <xsl:when test="$sort = '1'">
              <xsl:for-each select="&leafNodes;">
                <xsl:sort select="@qname"/>
                <!-- <xsl:apply-templates select="." mode="list-leaves"/> -->
                <tr>
                  <xsl:call-template name="get-leaf-details"/>
                </tr>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select="&leafNodes;">
                <!-- <xsl:apply-templates select="." mode="list-leaves"/> -->
                <tr>
                  <xsl:call-template name="get-leaf-details"/>
                </tr>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
        </table>
      </xsl:if>
    </div>

    <xsl:choose>
      <xsl:when test="$sort = '1'">
        <xsl:for-each select="&leafNodes;">
          <xsl:sort select="@qname"/>
          <xsl:apply-templates select="." mode="leaf"/>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="&leafNodes;">
          <xsl:apply-templates select="." mode="leaf"/>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>

    <!-- next level of branches -->
    <xsl:variable name="sort_branch">
      <xsl:call-template name="get-sort-branches"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$sort_branch = '1'">
        <xsl:for-each select="testset | package">
          <xsl:sort select="@qname"/>
          <xsl:apply-templates select="." mode="branch"/>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="testset | package">
          <xsl:apply-templates select="." mode="branch"/>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- default: noop -->
  <xsl:template match="*" mode="branch-extras"/>
  <xsl:template match="*" mode="cross-links"/>
  <!-- }}} -->
  <!-- {{{ Single leaf -->

  <xsl:template match="&leafNodes;" mode="leaf">
    <div>
      <xsl:attribute name="class">
        <xsl:call-template name="get-leaf-class"/>
        <xsl:text> leaf</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="name">
        <xsl:value-of select="@qname"/>
      </xsl:attribute>
      <nav>
        <xsl:attribute name="class">
          <xsl:call-template name="get-leaf-class"/>
          <xsl:text>links leaflinks gutter-left</xsl:text>
        </xsl:attribute>

        <xsl:apply-templates select="." mode="create-anchor"/>
        <xsl:for-each select="ancestor::*">
          <xsl:apply-templates select="." mode="links"/>
        </xsl:for-each>
        <div class="links">
          <xsl:apply-templates select="." mode="cross-links"/>
        </div>
      </nav>

      <h4>
        <xsl:attribute name="class">
          <xsl:call-template name="get-leaf-class"/>
          <xsl:text>title leaftitle gutter-left</xsl:text>
        </xsl:attribute>

        <xsl:apply-templates select="." mode="create-leaf-title-margin"/>
        <xsl:call-template name="get-leaf-title"/>
        <xsl:text>: "</xsl:text>
        <xsl:value-of select="@name"/>
        <xsl:text>"</xsl:text>
      </h4>

      <div>
        <xsl:attribute name="class">
          <xsl:call-template name="get-leaf-class"/>
          <xsl:text>desc leafdesc gutter-left</xsl:text>
        </xsl:attribute>
        <xsl:apply-templates select="." mode="description"/>
        <xsl:apply-templates select="." mode="leaf-desc-extras"/>
      </div>

      <xsl:apply-templates select="." mode="leaf-extras"/>

    </div>
  </xsl:template>

  <!-- default: noop -->
  <xsl:template match="*" mode="leaf-desc-extras"/>
  <xsl:template match="*" mode="leaf-extras"/>

  <!-- }}} -->

  <!-- {{{ description -->

  <!-- default handling of testset description -->
  <xsl:template match="*" mode="description">
    <xsl:if test="comment">
      <xsl:apply-templates select="comment" mode="description"/>
    </xsl:if>
  </xsl:template>

  <!-- default handling of testset comment -->
  <xsl:template match="comment" mode="description">
    <xsl:choose>
      <xsl:when test="p">
        <!-- comment contains paragraphs -->
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <!-- comment contains plain text, add <p> tags -->
        <p>
          <xsl:apply-templates/>
        </p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- print just the first sentence of a comment -->
  <xsl:template match="comment" mode="sentence">
    <xsl:for-each select=".//text()">
      <xsl:if test="position() = 1">
        <xsl:apply-templates select="." mode="sentence"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ Link to -->

  <xsl:template match="*" mode="link-to">
    <xsl:attribute name="href">
      <xsl:text>#</xsl:text>
      <xsl:value-of select="@ref"/>
    </xsl:attribute>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ Create anchor -->

  <xsl:template match="*" mode="create-anchor">
    <a name="{@ref}"/>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ First sentence -->

  <!-- Print the first sentence of a piece of text only. -->
  <xsl:template match="text()" mode="sentence">
    <xsl:variable name="sentence1">
      <xsl:call-template name="sentence">
        <xsl:with-param name="string" select="."/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="needfix">
      <xsl:value-of select="$pass_html = 1 and contains($sentence1, '&lt;!--')"/>
    </xsl:variable>

    <xsl:variable name="sentence">
      <xsl:value-of select="$sentence1"/>
      <xsl:if test="$needfix = 'true'">
        <xsl:text>&lt;!----&gt;</xsl:text>
      </xsl:if>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$needfix = 'true' or contains(., '.')">
        <xsl:choose>
          <xsl:when test="$pass_html = '1'">
            <xsl:value-of disable-output-escaping="yes" select="$sentence"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$sentence"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="pass_through"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="sentence">
    <xsl:param name="string"/>
    <xsl:choose>
      <xsl:when test="contains($string, '.')">
        <xsl:value-of select="substring-before($string, '.')"/>
        <xsl:text>.</xsl:text>
        <xsl:variable name="rest" select="substring-after($string, '.')"/>
        <xsl:choose>
          <xsl:when test="$rest = ''">
          </xsl:when>
          <xsl:when test="normalize-space(substring($rest, 1, 1)) = ''">
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="sentence">
              <xsl:with-param name="string" select="$rest"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$string" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ Possibly pass HTML tags through -->

  <!-- Possilby pass HTML tags through for text -->
  <xsl:template match="text()" mode="pass_through">
    <xsl:choose>
      <xsl:when test="$pass_html = '1'">
        <xsl:value-of disable-output-escaping="yes" select="."/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Possibly pass HTML tags through for text below comment -->
  <xsl:template match="text()[$pass_html = '1' and ancestor::comment]">
    <xsl:value-of disable-output-escaping="yes" select="."/>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ Icon helpers -->

  <!-- {{{ create-testset-icon -->

  <xsl:template name="create-testset-icon">
    <img width="16" height="16" class="icon">
      <xsl:attribute name="src">
        <xsl:call-template name="basedir"/>
        <xsl:text>icons/testset.png</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="alt">
        <xsl:call-template name="lc-testset"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:call-template name="lc-testset"/>
      </xsl:attribute>
    </img>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ create-testcase-icon -->

  <xsl:template name="create-testcase-icon">
    <img width="16" height="16" class="icon">
      <xsl:attribute name="src">
        <xsl:call-template name="basedir"/>
        <xsl:text>icons/testcase.png</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="alt">
        <xsl:call-template name="lc-testcase"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:call-template name="lc-testcase"/>
      </xsl:attribute>
    </img>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ create-teststep-icon -->

  <xsl:template name="create-teststep-icon">
    <xsl:param name="kind" select="'teststep'"/>
    <img width="16" height="16" class="icon">
      <xsl:attribute name="src">
        <xsl:call-template name="basedir"/>
        <xsl:text>icons/</xsl:text>
        <xsl:value-of select="$kind"/>
        <xsl:text>.png</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="alt">
        <xsl:call-template name="lc-teststep"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:call-template name="lc-teststep"/>
      </xsl:attribute>
    </img>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ create-package-icon -->

  <xsl:template name="create-package-icon">
    <img width="16" height="16" class="icon">
      <xsl:attribute name="src">
        <xsl:call-template name="basedir"/>
        <xsl:text>icons/package.png</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="alt">
        <xsl:call-template name="lc-package"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:call-template name="lc-package"/>
      </xsl:attribute>
    </img>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ create-procedure-icon -->

  <xsl:template name="create-procedure-icon">
    <img width="16" height="16" class="icon">
      <xsl:attribute name="src">
        <xsl:call-template name="basedir"/>
        <xsl:text>icons/procedure.png</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="alt">
        <xsl:call-template name="lc-procedure"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:call-template name="lc-procedure"/>
      </xsl:attribute>
    </img>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ create-dependency-icon -->

  <xsl:template name="create-dependency-icon">
    <img width="16" height="16" class="icon">
      <xsl:attribute name="src">
        <xsl:call-template name="basedir"/>
        <xsl:text>icons/dep.png</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="alt">
        <xsl:call-template name="lc-dependency"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:call-template name="lc-dependency"/>
      </xsl:attribute>
    </img>
  </xsl:template>

  <!-- }}} -->

  <!-- }}} -->
  <!-- {{{ URL encoding -->

  <!-- Characters that usually don't need to be escaped -->
  <xsl:variable name="safe">!'()*-.0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz~</xsl:variable>

  <xsl:template name="url-encode">
    <xsl:param name="str"/>
    <xsl:if test="$str">
      <xsl:variable name="first-char" select="substring($str,1,1)"/>
      <xsl:choose>
        <xsl:when test="contains($safe,$first-char)">
          <xsl:value-of select="$first-char"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>_</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="string-length($str) > 1">
        <xsl:call-template name="url-encode">
          <xsl:with-param name="str" select="substring($str,2)"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <!-- }}} -->
</xsl:stylesheet>
