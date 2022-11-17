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
  everything else results in an English report -->
  <xsl:param name="lang" select="'en'"/>

  <!-- Parameter to switch the icons on(1) and off(0). If the icons are switched
  off the symbols are replaced with framed characters (T for Test and S for
  Sequence). The vertical lines connecting siblings are not avaiable in this mode.-->
  <xsl:param name="icons" select="0"/>

  <!-- The directory where the icons are stored is, if necessary transferred to
  this parameter from qftestJUI-->
  <xsl:param name="icondir"/>

  <!-- whether to pass HTML tags through -->
  <xsl:param name="pass_html" select="'1'"/>
  <!-- Entry point -->
  <xsl:template match="/">
    <html>
      <head>
        <xsl:choose>
          <xsl:when test="$lang='de'">
            <title>qftestJUI Testergebnisse</title>
          </xsl:when>
          <xsl:otherwise>
            <title>qftestJUI test results</title>
          </xsl:otherwise>
        </xsl:choose>
      </head>
      <body bgcolor="&white;">
        <xsl:apply-templates/>
      </body>
    </html>
  </xsl:template>

  <!-- The root node  with the test-suite info and summary
  The first test tree-node is manually produced here
  since the icon and vertical line belonging to a tree-
  node is "outside" the test/sequence icons table.
  All subsequent tables are produced in the tree-node template.-->
  <xsl:template match="/test-suite">
    <h1><xsl:value-of select="@type"/>
      <xsl:choose>
        <xsl:when test="$lang='de'">
          <xsl:text> Testergebnisse</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text> test results</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </h1>
    <h2><xsl:value-of select="@name"/></h2>
    <table border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td>
          <xsl:choose>
            <xsl:when test="$lang='de'">
              <xsl:text>Rechner:&nbsp;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>Host:&nbsp;</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td><xsl:value-of select="@host"/></td>
      </tr>
      <tr>
        <td><xsl:text>OS:&nbsp;</xsl:text></td><td><xsl:value-of select="@os-version"/></td>
      </tr>
      <tr>
        <td>
          <xsl:choose>
            <xsl:when test="$lang='de'">
              <xsl:text>Durchgeführt von:&nbsp;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>Executed by:&nbsp;</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td><xsl:value-of select="@executed-by"/></td>
      </tr>
      <tr>
        <td>
          <xsl:choose>
            <xsl:when test="$lang='de'">
              <xsl:text>Ausführungsdatum:&nbsp;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>Execution date:&nbsp;</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td><xsl:value-of select="@execution-date"/></td>
      </tr>
      <xsl:if test="@java-version">
        <tr>
          <td>
            <xsl:choose>
              <xsl:when test="$lang='de'">
                <xsl:text>Java Version:&nbsp;</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>Java version:&nbsp;</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </td>
          <td><xsl:value-of select="@java-version"/></td>
        </tr>
      </xsl:if>
      <xsl:if test="@qftestJUI-version">
        <tr>
          <td>
            <xsl:choose>
              <xsl:when test="$lang='de'">
                <xsl:text>qftestJUI Version:&nbsp;</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>qftestJUI version:&nbsp;</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </td>
          <td><xsl:value-of select="@qftestJUI-version"/></td>
        </tr>
      </xsl:if>
      <tr>
        <td>
          <xsl:choose>
            <xsl:when test="$lang='de'">
              <xsl:text>Ergebnis:&nbsp;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>Result:&nbsp;</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td>
          <xsl:choose>
            <xsl:when test="$lang='de'">
              <xsl:if test="@vstate = 0"><xsl:text>OK</xsl:text></xsl:if>
              <xsl:if test="@vstate = 1"><xsl:text>Warnung</xsl:text></xsl:if>
              <xsl:if test="@vstate = 2"><xsl:text>Fehler</xsl:text></xsl:if>
              <xsl:if test="@vstate = 3"><xsl:text>Exception</xsl:text></xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:if test="@vstate = 0"><xsl:text>OK</xsl:text></xsl:if>
              <xsl:if test="@vstate = 1"><xsl:text>Warning</xsl:text></xsl:if>
              <xsl:if test="@vstate = 2"><xsl:text>Error</xsl:text></xsl:if>
              <xsl:if test="@vstate = 3"><xsl:text>Exception</xsl:text></xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
    </table>

    <xsl:apply-templates select="summary"/>

    <!-- An empty table to create some vertical space-->
    <table><tr><td/></tr></table>

    <!--The bottom tree-nodes -->
    <table border="&show-border;" cellspacing="0" cellpadding="1">
      <xsl:for-each select="test|sequence|procedure">
        <tr>
                  <!-- If we are using icons we place links to the appropriate ones, including the vertical
                  line which is a 16 pixel wide and one pixel high picture. The vertical line is only placed
                  if we have siblings-->
          <xsl:choose>
            <xsl:when test="$icons='1'">
              <xsl:choose>
                <xsl:when test="position() &lt; last()">
                  <td  valign="top" style="background-image:url({$icondir}VerticalLine.png)">
                    <!-- <table><tr><td/></tr></table> -->
                    <xsl:choose>
                                      <!-- if the new node is a test node we use the open tree node, otherwise a closed -->
                      <xsl:when test="self::test">
                        <img alt="" src="{$icondir}OpenTreeNode.png"  width="16px" height="16px" border="0"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <img alt="" src="{$icondir}ClosedTreeNode.png"  width="16px" height="16px" border="0"/>
                      </xsl:otherwise>
                    </xsl:choose>
                                    </td>
                </xsl:when>
                <xsl:otherwise>
                  <td valign="top">
                    <!-- <table><tr><td/></tr></table> -->
                    <xsl:choose>
                                      <!-- if the new node is a test node we use the open tree node, otherwise a closed -->
                      <xsl:when test="self::test">
                        <img alt="" src="{$icondir}OpenTreeNode.png"  width="16px" height="16px" border="0"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <img alt="" src="{$icondir}ClosedTreeNode.png"  width="16px" height="16px" border="0"/>
                      </xsl:otherwise>
                    </xsl:choose>
                                    </td>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
                    <!-- In case of no-icons we simply set a minus sign and a larger than sign to simulate
                    an arrow instead of the icon. There is no vertical line. -->
            <xsl:otherwise>
              <td valign="top"  nowrap="nowrap">
                <p style="font-size:smaller;text-align:center"><xsl:text>-&gt;</xsl:text></p>
              </td>
            </xsl:otherwise>
          </xsl:choose>
          <td><xsl:apply-templates select="."/></td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <!-- The test, sequence and procedure templates are almost identical and only
  call the tree-node template with the right parameters-->
  <xsl:template match="test">
    <xsl:call-template name="tree-node">
      <xsl:with-param name="type" select="'Test'"/>
      <xsl:with-param name="itype" select="'Test'"/>
      <xsl:with-param name="name" select="@name"/>
      <xsl:with-param name="vstate" select="@vstate"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="sequence">
    <xsl:call-template name="tree-node">
      <xsl:with-param name="type">
        <xsl:choose>
          <xsl:when test="$lang='de'">
            <xsl:text>Sequenz</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>Sequence</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
      <xsl:with-param name="itype" select="'Sequence'"/>
      <xsl:with-param name="name" select="@name"/>
      <xsl:with-param name="vstate" select="
@vstate"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="procedure">
    <xsl:call-template name="tree-node">
      <xsl:with-param name="type">
        <xsl:choose>
          <xsl:when test="$lang='de'">
            <xsl:text>Prozedur</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>Procedure</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
      <xsl:with-param name="itype" select="'Procedure'"/>
      <xsl:with-param name="name" select="@name"/>
      <xsl:with-param name="vstate" select="@vstate"/>
    </xsl:call-template>
  </xsl:template>

  <!-- The central template producing all subsequent tables-->
  <xsl:template name="tree-node">
    <xsl:param name="type"/>
    <xsl:param name="itype"/>
    <xsl:param name="name"/>
    <xsl:param name="vstate"/>
    <xsl:variable name="border">

      <!-- Set the style argument for the first table-cell containing the
      test/sequence icon for the case we do not use icons.  It is done with a
      colored border around a character T or S-->
      <xsl:if test="$vstate = 0">
        <xsl:text></xsl:text>
      </xsl:if>
      <xsl:if test="$vstate = 1">
        <xsl:text>border-style:solid;border-color:&warning-color;;border-width:1px;</xsl:text>
      </xsl:if>
      <xsl:if test="$vstate = 2">
        <xsl:text>border-style:solid;border-color:&error-color;;border-width:1px;</xsl:text>
      </xsl:if>
      <xsl:if test="$vstate = 3">
        <xsl:text>border-style:solid;border-color:&error-color;;border-width:2px;</xsl:text>
      </xsl:if>
    </xsl:variable>
    <!-- Create the next table, it has only two cells, left and right. The
    left cell contains the test/sequence icon and the right cell the text.-->
    <table  border="&show-border;" cellspacing="0" cellpadding="0">
      <tr>
        <!-- check if need a vertical line-->
        <xsl:variable name="background">
          <xsl:choose>
            <xsl:when test="test|sequence|procedure and $icons='1'">
              <xsl:text>vertical-align:top;background-image:url(</xsl:text>
              <xsl:value-of select="$icondir"/>
              <xsl:text>VerticalLine.png);</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>vertical-align:top;</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <!-- The left cell containing the icon and vertical line in case of icons, and a frame character in
                case of no-icons.-->
        <td style="{$background}">
          <xsl:choose>
            <xsl:when test="$icons='1'">
              <img  alt="" src="{$icondir}{$itype}{$vstate}.png" width="16px" height="16px" border="0"/>
            </xsl:when>
            <xsl:otherwise>
              <p style="text-align:center;font-weight:bold;{$border}height:16px;width:16px;font-size:smaller">
                <xsl:value-of select="substring($type,1,1)"/></p>
            </xsl:otherwise>
          </xsl:choose>
        </td>

        <!-- The right cell -->
        <td>
          <!-- Inside the right cell a new table with border contains the text-->
          <table  border="1" cellspacing="0" cellpadding="1">
            <tr>
              <td>
                <b><xsl:value-of select="$type"/><xsl:text>: </xsl:text><xsl:value-of select="$name"/></b><br/>
                <xsl:if test="comment != ''">
                  <xsl:choose>
                    <xsl:when test="$lang='de'">
                      <xsl:text>Bemerkung: </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text>Comment: </xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:apply-templates select="comment"/><br/>
                </xsl:if>
                <xsl:apply-templates select="summary"/>
              </td>
            </tr>
          </table>
          <!-- An empty table to create some vertical space-->
          <table><tr><td/></tr></table>
        </td>
      </tr>
      <!-- Does this test/sequence contain child nodes? If so, create a new row and insert
      the tree-node icon and vertical line in the left cell-->
      <xsl:for-each select="test|sequence|procedure">
        <tr>
          <xsl:choose>
                    <!-- Check if are supposed to insert the icons-->
            <xsl:when test="$icons='1'">
              <xsl:choose>
                <!-- Vertical line for every node but the last-->
                <xsl:when test="position() &lt; last()">
                  <td  valign="top" width="16px" style="background-image:url({$icondir}VerticalLine.png)">
                    <!-- <table><tr><td/></tr></table> -->
                    <xsl:choose>
                                      <!-- if the new node is a test node we use the open tree node, otherwise a closed -->
                      <xsl:when test="self::test">
                        <img alt="" src="{$icondir}OpenTreeNode.png"  width="16px" height="16px" border="0"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <img alt="" src="{$icondir}ClosedTreeNode.png"  width="16px" height="16px" border="0"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                </xsl:when>
                <xsl:otherwise>
                  <td valign="top">
                    <!-- <table><tr><td/></tr></table> -->
                    <xsl:choose>
                      <xsl:when test="self::test">
                        <img alt="" src="{$icondir}OpenTreeNode.png"  width="16px" height="16px" border="0"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <img alt="" src="{$icondir}ClosedTreeNode.png"  width="16px" height="16px" border="0"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                    <!-- In case of no-icons we insert a minus sign and a greater than to simulate an arrow instead of
                    the tree-node icon-->
              <td  valign="top" nowrap="nowrap">
                <p style="font-size:smaller;text-align:center"><xsl:text>-&gt;</xsl:text></p>
              </td>
            </xsl:otherwise>
          </xsl:choose>
                  <!-- Start over with the next node-->
          <td><xsl:apply-templates select="."/></td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

<!-- The summary. This is a place which can be edited and changed
by the user. It is simply text within a table-cell. The table-cell is created
in the tree-node template above. -->
  <xsl:template match="summary">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Uhrzeit </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Time </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="@time"/>
    <xsl:text>, </xsl:text>
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Dauer </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Duration </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="@duration"/><xsl:text> ms</xsl:text>
    <!-- Do we have exceptions?-->
    <xsl:if test="@exceptions > 0">
      <xsl:text>, </xsl:text><xsl:value-of select="@exceptions"/>
      <xsl:choose>
        <xsl:when test="$lang='de'">
          <xsl:text>&nbsp;Exception</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>&nbsp;exception</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <!-- Maybe plural?-->
      <xsl:if test="@exceptions > 1">
        <xsl:text>s</xsl:text>
      </xsl:if>
    </xsl:if>
    <!-- Do we have errors?-->
    <xsl:if test="@errors > 0">
      <xsl:text>, </xsl:text><xsl:value-of select="@errors"/>
      <xsl:choose>
        <xsl:when test="$lang='de'">
          <xsl:text>&nbsp;Fehler</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>&nbsp;error</xsl:text>
          <!-- Maybe plural?-->
          <xsl:if test="@errors > 1">
            <xsl:text>s</xsl:text>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <!-- Do we have warnings?-->
    <xsl:if test="@warnings > 0">
      <xsl:text>, </xsl:text><xsl:value-of select="@warnings"/>
      <xsl:choose>
        <xsl:when test="$lang='de'">
          <xsl:text>&nbsp;Warnung</xsl:text>
          <!-- Maybe plural?-->
          <xsl:if test="@warnings > 1">
            <xsl:text>en</xsl:text>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>&nbsp;warning</xsl:text>
          <!-- Maybe plural?-->
          <xsl:if test="@warnings > 1">
            <xsl:text>s</xsl:text>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:template>

<!-- Any checks?-->
  <xsl:template match="checks[check]">
    <hr/>
    <b><xsl:text>Checks</xsl:text></b>
    <ul>
      <xsl:apply-templates/>
    </ul>
  </xsl:template>

<!-- Output the result and the message from the check-->
  <xsl:template match="check">
    <li>
      <xsl:choose>
        <xsl:when test="$lang='de'">
          <xsl:text>Ergebnis: </xsl:text>
          <xsl:if test="@pstate = 0"><xsl:text>OK</xsl:text></xsl:if>
          <xsl:if test="@pstate = 1"><xsl:text>Warnung</xsl:text></xsl:if>
          <xsl:if test="@pstate = 2"><xsl:text>Fehler</xsl:text></xsl:if>
          <xsl:if test="@pstate = 3"><xsl:text>Exception</xsl:text></xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Result: </xsl:text>
          <xsl:if test="@pstate = 0"><xsl:text>OK</xsl:text></xsl:if>
          <xsl:if test="@pstate = 1"><xsl:text>Warning</xsl:text></xsl:if>
          <xsl:if test="@pstate = 2"><xsl:text>Error</xsl:text></xsl:if>
          <xsl:if test="@pstate = 3"><xsl:text>Exception</xsl:text></xsl:if>
        </xsl:otherwise>
      </xsl:choose>
      <br/>
      <xsl:choose>
        <xsl:when test="$lang='de'">
          <xsl:text>Meldung: </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Message: </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="message"/>
      <xsl:if test="comment">
        <br/>
        <xsl:choose>
          <xsl:when test="$lang='de'">
            <xsl:text>Bemerkung: </xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>Comment: </xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates select="comment"/>
      </xsl:if>
    </li>
  </xsl:template>

<!-- The exception, errors and warnings are listed in a bulleted list-->
  <xsl:template match="exceptions[exception]">
    <hr/><b><xsl:text>Exceptions</xsl:text></b>
    <ul>
      <xsl:apply-templates/>
    </ul>
  </xsl:template>

  <xsl:template match="errors[error]">
    <hr/><b>
      <xsl:choose>
        <xsl:when test="$lang='de'">
          <xsl:text>Fehler</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Errors</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </b>
    <ul>
      <xsl:apply-templates/>
    </ul>
  </xsl:template>

  <xsl:template match="warnings[warning]">
    <hr/><b>
      <xsl:choose>
        <xsl:when test="$lang='de'">
          <xsl:text>Warnungen</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Warnings</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </b>
    <ul>
      <xsl:apply-templates/>
    </ul>
  </xsl:template>

  <xsl:template match="warning | error | exception">
    <li><xsl:apply-templates/></li>
  </xsl:template>

  <!-- Filter empty lines from summary -->
  <xsl:template match="checks | warnings | errors | exceptions | summary/text()">
  </xsl:template>

  <!-- possibly pass HTML tags through -->
  <xsl:template match="comment | message">
    <xsl:apply-templates select="* | @* | text() | comment()" mode="pass_through"/>
  </xsl:template>

  <xsl:template match="*" mode="pass_through">
    <xsl:element name="{name()}">
      <xsl:apply-templates select="* | @* | text() | comment()" mode="pass_through"/>
    </xsl:element>
  </xsl:template>

  <!-- Copy text -->
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

</xsl:stylesheet>
