<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp   "&#160;" >
  <!ENTITY mainNodes "BaseTestLog[@testtype='testset' or @testtype='testcase']
                      | BasicSequenceLog[@testtype='test']">
  <!ENTITY mainAncestorNodes "ancestor::BaseTestLog
                              | ancestor::BasicSequenceLog[@testtype='test']">
  <!ENTITY seqNodes "BaseTestLog
                     | BasicSequenceLog
                     | ProcedureLog">
  <!ENTITY errorNodes "ExceptionLog
                       | CheckFailedLog
                       | FailedCheckStepLog
                       | ImageCheckFailedLog
                       | MessageLog">
  <!ENTITY checkNodes "CheckStepLog
                       | ImageCheckFailedLog
                       | ImageCheckAdvancedOKLog
                       | MessageLog[@resource = 'checkFailed.time'
                                    or @resource = 'checkOK.time'
                                    or @resource = 'checkFailed.timeout'
                                    or @resource = 'checkOK.timeout'
                                    or @resource= 'checkFailed'
                                    or @resource='msg.checkOK'
                                    or @resource='image.advancedAlgo.checkOK'
                                    or @resource='msg.checkFailed'
                                    or @resource='msg.checkFailedMessage'
                                    or @resource='msg.unittest.message.successful'
                                    or @resource='msg.unittest.message.testfailed'
                                    or @resource='msg.unittest.message.testfailedex'
                                    or @resource='checkFailed.image.advancedAlgo.checkfailed']">
  <!ENTITY failedChecks "CheckFailedLog
                         | FailedCheckStepLog
                         | ImageCheckFailedLog
                         | MessageLog[@resource='msg.checkFailed'
                                      or @resource='msg.checkFailedMessage'
                                      or @resource='msg.unittest.message.testfailed'
                                      or @resource='msg.unittest.message.testfailedex'
                                      or @resource='checkFailed.image.advancedAlgo.checkfailed'
                                      or @resource='checkFailed.time'
                                      or @resource='checkFailed.timeout']">
  <!ENTITY procNodes "ProcedureLog
                      | SuiteChangeLog
                      | BaseTestLog">
  <!ENTITY iterNodes "LoopLog
                      | SuiteChangeLog
                      | ExternalizedLog
                      | RootStepLog
                      | AbstractStepLog
                      | ThreadLog
                      | BaseTestLog
                      | BasicSequenceLog">
  <!ENTITY stepNode "node[@type='report' and @kind='teststep']">
  <!ENTITY setupNode "node[@type='report' and
                           (@kind='dependency' or @kind='setup' or @kind='cleanup')]">
  <!ENTITY stepNodes "BasicSequenceLog[@testtype='teststep']
                      | BaseTestLog[@testtype='teststep']
                      | Screenshot[@cause='report']
                      | *[&stepNode;]">
  <!ENTITY messageNode "MessageLog[@pstate=0 and node[@type='report']]">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xalan="http://xml.apache.org/xslt"
                exclude-result-prefixes="xsl xalan"
                version="1.0">

  <xsl:import href="helpers.xsl"/>

  <xsl:output method="xml"
              indent="yes"
              encoding="UTF-8"
              doctype-public="-//QFS//DTD Test Report 1.0//EN"
              doctype-system="report.dtd"
              xalan:indent-amount="2"/>


  <!-- Key used to retrieve indirect nodes with ref=... -->
  <xsl:key name="idkey" match="*" use="@id"/>

  <!-- {{{ Parameters -->

  <!-- The language, default is 'en', alternative is 'de' -->
  <xsl:param name="lang" select="'en'"/>

  <!-- Default depth for the root test -->
  <xsl:param name="depth" select="0"/>

  <!-- Whether to list checks in summary -->
  <xsl:param name="summary-list-checks" select="0"/>

  <!-- Whether to list exceptions in summary -->
  <xsl:param name="summary-list-exceptions" select="1"/>

  <!-- Whether to list errors in summary -->
  <xsl:param name="summary-list-errors" select="1"/>

  <!-- Whether to list warnings in summary -->
  <xsl:param name="summary-list-warnings" select="1"/>

  <!-- Whether to log messages -->
  <xsl:param name="debug" select="0"/>

  <!-- }}} -->

  <!-- {{{ main structure -->

  <!-- Entry point -->
  <xsl:template match="/">
    <xsl:if test="$debug">
      <xsl:message>
        <xsl:text>depth: </xsl:text>
        <xsl:value-of select="$depth"/>
        <xsl:text>, summary-list-checks: </xsl:text>
        <xsl:value-of select="$summary-list-checks"/>
        <xsl:text>, summary-list-exceptions: </xsl:text>
        <xsl:value-of select="$summary-list-exceptions"/>
        <xsl:text>, summary-list-errors: </xsl:text>
        <xsl:value-of select="$summary-list-errors"/>
        <xsl:text>, summary-list-warnings: </xsl:text>
        <xsl:value-of select="$summary-list-warnings"/>
      </xsl:message>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:template>

  <!--
  The root node

  Create a test-suite node and iterate over the children of the root node
  with a depth defined as the $depth parameter (default 1)
  -->
  <xsl:template match="/RootStepLog">
    <test-suite type="qftest" suitename="{@name}" name="{@suite}" host="{@host}" os-version="{@os}"
                executed-by="{@user}" execution-date="{@time}"
                java-version="{@jversion}" qftest-version="{@qfversion}" qftest-build="{@qfbuild}"
                runid="{@runid}">
      <xsl:apply-templates select="." mode="createStates"/>
      <xsl:apply-templates select="." mode="createComment"/>
      <xsl:apply-templates select="." mode="createSummary">
        <xsl:with-param name="depth" select="$depth"/>
      </xsl:apply-templates>
      <!-- <xsl:apply-templates select="*" mode="iterate-tests"/> -->
      <xsl:apply-templates select="*" mode="iterate-children">
        <xsl:with-param name="depth" select="$depth"/>
      </xsl:apply-templates>
    </test-suite>
  </xsl:template>

  <xsl:template match="*" mode="iterate-tests">
      <xsl:apply-templates select="*" mode="iterate-tests"/>
  </xsl:template>

  <!-- <xsl:template match="BaseTestLog" mode="iterate-tests"> -->
  <xsl:template match="&mainNodes;" mode="iterate-children" priority="1">
    <xsl:param name="depth" select="0"/>

    <xsl:variable name="type">
      <xsl:choose>
        <xsl:when test="TestSet or @testtype='testset'">
          <xsl:text>TestSet</xsl:text>
        </xsl:when>
        <xsl:when test="TestCase or @testtype='testcase'">
          <xsl:text>TestCase</xsl:text>
        </xsl:when>
        <xsl:when test=".//BaseTestLog or .//BasicSequenceLog[@testtype='test']">
          <xsl:text>TestSet</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>TestCase</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:if test="$debug">
      <xsl:message>BaseTestLog: <xsl:apply-templates select="." mode="getNameStripped"/>
        type: <xsl:value-of select="$type"/>
      </xsl:message>
    </xsl:if>

    <xsl:choose>
      <!-- <xsl:when test="TestSet or @testtype='TestSet'"> -->
      <xsl:when test="$type='TestSet'">
        <!-- <xsl:message>Got TestSet</xsl:message> -->
        <testset implemented="{@implemented}" ref="{generate-id()}">
          <xsl:attribute name="name">
            <xsl:apply-templates select="." mode="getNameStripped"/>
          </xsl:attribute>
          <xsl:attribute name="qname">
            <xsl:apply-templates select="." mode="qname"/>
          </xsl:attribute>
          <xsl:attribute name="plainname">
            <xsl:apply-templates select="." mode="getPlainNameStripped"/>
          </xsl:attribute>
          <xsl:if test="@suite != ''">
            <xsl:attribute name="suite">
              <xsl:value-of select="@suite"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:variable name="nodeid">
            <xsl:apply-templates select="." mode="getId"/>
          </xsl:variable>
          <!-- <xsl:if test="not(starts-with($nodeid, '_'))"> -->
            <xsl:attribute name="nodeid">
              <xsl:value-of select="$nodeid"/>
            </xsl:attribute>
          <!-- </xsl:if> -->
          <xsl:if test="@skipped='true'">
            <xsl:attribute name="skipped">
              <xsl:text>true</xsl:text>
            </xsl:attribute>
          </xsl:if>
          <xsl:apply-templates select="." mode="createStates"/>
          <xsl:apply-templates select="." mode="createComment"/>
          <xsl:for-each select="value">
            <charvar name="{@name}">
              <xsl:apply-templates/>
            </charvar>
          </xsl:for-each>
          <xsl:apply-templates select="." mode="createSummary"/>
          <!-- <xsl:apply-templates select="*" mode="iterate-tests"/> -->
          <xsl:apply-templates select="*" mode="iterate-children">
            <xsl:with-param name="depth" select="$depth"/>
          </xsl:apply-templates>
        </testset>
      </xsl:when>
      <!-- <xsl:when test="TestCase or @testtype='TestCase'"> -->
      <xsl:when test="$type='TestCase'">
        <!-- <xsl:message>Got TestCase</xsl:message> -->
        <testcase implemented="{@implemented}" ref="{generate-id()}">
          <xsl:attribute name="name">
            <xsl:apply-templates select="." mode="getNameStripped"/>
          </xsl:attribute>
          <xsl:attribute name="qname">
            <xsl:apply-templates select="." mode="qname"/>
          </xsl:attribute>
          <xsl:attribute name="plainname">
            <xsl:apply-templates select="." mode="getPlainNameStripped"/>
          </xsl:attribute>
          <xsl:if test="@suite != ''">
            <xsl:attribute name="suite">
              <xsl:value-of select="@suite"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:variable name="nodeid">
            <xsl:apply-templates select="." mode="getId"/>
          </xsl:variable>
          <!-- <xsl:if test="not(starts-with($nodeid, '_'))"> -->
            <xsl:attribute name="nodeid">
              <xsl:value-of select="$nodeid"/>
            </xsl:attribute>
          <!-- </xsl:if> -->
          <xsl:if test="@skipped='true'">
            <xsl:attribute name="skipped">
              <xsl:text>true</xsl:text>
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="@reliability='expectedfail'">
            <xsl:attribute name="expectedfail">
              <xsl:text>true</xsl:text>
            </xsl:attribute>
          </xsl:if>
          <xsl:apply-templates select="." mode="createStates"/>
          <xsl:apply-templates select="." mode="createComment"/>
          <xsl:for-each select="value">
            <charvar name="{@name}">
              <xsl:apply-templates/>
            </charvar>
          </xsl:for-each>
          <xsl:apply-templates select="." mode="createSummary"/>
          <xsl:apply-templates select="." mode="iterateNodes"/>
        </testcase>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- <xsl:template match="*[not(name()='node')]" mode="iterateNodes"> -->
  <xsl:template match="&stepNodes; | *[&setupNode;]" mode="iterateNodes">
    <xsl:if test="$debug">
      <xsl:message>Collect node
        <xsl:value-of select="name()"/>
        <xsl:text> testtype=</xsl:text>
        <xsl:value-of select="@testtype"/>
      </xsl:message>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="&setupNode;">
        <xsl:element name='{node/@kind}'>
          <xsl:apply-templates select="." mode="createTeststep"/>
          <xsl:apply-templates select="*" mode="iterateNodes"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <teststep>
          <xsl:apply-templates select="." mode="createTeststep"/>
          <xsl:apply-templates select="*" mode="iterateNodes"/>
        </teststep>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="Screenshot[@cause='report']" mode="iterateNodes" priority="1">
    <screenshot>
      <xsl:apply-templates select="." mode="createTeststep"/>
    </screenshot>
  </xsl:template>

  <xsl:template match="&messageNode;" mode="iterateNodes">
    <!-- <message link="{generate-id()}"/> -->
    <message>
      <xsl:if test="node/@nowrap">
        <xsl:attribute name="nowrap">
          <xsl:value-of select="node/@nowrap"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@lines">
        <xsl:attribute name="lines">
          <xsl:value-of select="@lines"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="." mode="showMessage"/>
    </message>
  </xsl:template>

  <xsl:template match="CheckStepLog
                       | FailedCheckStepLog
                       | ImageCheckFailedLog
                       | ImageCheckAdvancedOKLog
                       | MessageLog[(@resource='msg.checkOK'
                                     or @resource='image.advancedAlgo.checkOK'
                                     or @resource='msg.checkFailed'
                                     or @resource='msg.checkFailedMessage'
                                     or @resource='msg.unittest.message.successful'
                                     or @resource='msg.unittest.message.testfailed'
                                     or @resource='msg.unittest.message.testfailedex'
                                     or @resource='checkFailed.image.advancedAlgo.checkfailed'
                                     or @resource = 'checkFailed.time'
                                     or @resource = 'checkOK.time'
                                     or @resource = 'checkFailed.timeout'
                                     or @resource = 'checkOK.timeout')
                                    and (@pstate &gt; 1 or node[@type='report'])]"
                mode="iterateNodes" priority='1'>
    <xsl:if test="$debug">
      <xsl:message>
        <xsl:text>iterateNodes for Check:</xsl:text>
        <xsl:value-of select="name()"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="@timestamp"/>
      </xsl:message>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="ExceptionLog">
        <xsl:apply-templates select="*" mode="iterateNodes"/>
      </xsl:when>
      <xsl:when test="$summary-list-checks=1 and
                      (*[@pstate = 1
                         and (($summary-list-warnings=1
                               and name() != 'MessageLog')
                              or node[@type='report'])]
                       or *[@pstate = 2]
                       or node[@type='report' and @kind='check']
                       or ((name() = 'MessageLog'
                            or name() = 'ImageCheckFailedLog'
                            or name() = 'ImageCheckAdvancedOKLog')
                           and node[@type='report']))">
        <check link="{generate-id()}"/>
        <xsl:apply-templates select="*" mode="iterateNodes"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$summary-list-checks=1 and
                          (name() = 'FailedCheckStepLog'
                           or name() = 'ImageCheckFailedLog'
                           or name() = 'ImageCheckAdvancedOKLog')">
            <!-- Already covered above when itertaing over the CheckStepLog - do nothing -->
            <xsl:if test="$debug">
              <xsl:message>
                <xsl:text>skipped</xsl:text>
              </xsl:message>
            </xsl:if>
          </xsl:when>
          <xsl:when test="$summary-list-exceptions=1 and @pstate=3">
            <exception link="{generate-id()}"/>
          </xsl:when>
          <xsl:when test="$summary-list-errors=1 and @pstate=2">
            <error link="{generate-id()}"/>
          </xsl:when>
          <!-- Special case: rc.checkImage(report=False) -->
          <xsl:when test="$summary-list-warnings=1 and @pstate=1
                          and ((name() != 'MessageLog'
                                and ((name() != 'ImageCheckFailedLog'
                                      and name() != 'ImageCheckAdvancedOKLog')
                                     or ancestor::*[position() = 1 and name() = 'CheckStepLog']))
                               or node[@type='report'])">
            <warning link="{generate-id()}"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="*" mode="iterateNodes"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="&errorNodes;" mode="iterateNodes">
    <xsl:if test="$debug">
      <xsl:message>
        <xsl:text>iterateNodes for error:</xsl:text>
        <xsl:value-of select="name()"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="@timestamp"/>
      </xsl:message>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="$summary-list-exceptions=1 and @pstate=3">
        <exception link="{generate-id()}"/>
      </xsl:when>
      <xsl:when test="$summary-list-errors=1 and @pstate=2">
        <error link="{generate-id()}"/>
      </xsl:when>
      <xsl:when test="$summary-list-warnings=1 and @pstate=1
                      and node[@type='report']">
        <warning link="{generate-id()}"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="*" mode="iterateNodes"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- <xsl:template match="&failedChecks;" mode="iterateNodes"> -->
    <!-- <xsl:message> -->
      <!-- <xsl:text>FC</xsl:text> -->
      <!-- <xsl:value-of select="name()"/> -->
      <!-- <xsl:value-of select="@pstate"/> -->
    <!-- </xsl:message> -->
    <!-- <xsl:if test="$summary-list-checks=0 and $summary-list-errors=1"> -->
      <!-- <error link="{generate-id()}"/> -->
    <!-- </xsl:if> -->
  <!-- </xsl:template> -->

  <!-- <xsl:template match="&stepNode;" mode="iterateNodes"/> -->
  <xsl:template match="*" mode="iterateNodes">
    <xsl:apply-templates select="*" mode="iterateNodes"/>
  </xsl:template>

  <xsl:template match="BaseTestLog[TestCase and @testtype='teststep']" mode="createTeststep">
    <xsl:if test="$debug">
      <xsl:message>create teststep
        <xsl:text> reportname=</xsl:text>
        <xsl:value-of select="@reportname"/>
        <xsl:text> name=</xsl:text>
        <xsl:value-of select="TestCase/@name"/>
      </xsl:message>
    </xsl:if>
    <xsl:attribute name="name">
      <xsl:choose>
        <xsl:when test="@reportname and @reportname != ''">
          <xsl:value-of select="@reportname"/>
        </xsl:when>
        <!-- name is set in case of variable expansion -->
        <xsl:when test="@name and @name != ''">
          <xsl:value-of select="@name"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="TestCase" mode="getName"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:apply-templates select="." mode="createStates"/>
    <xsl:apply-templates select="." mode="createComment"/>
    <xsl:apply-templates select="." mode="createSummary"/>
  </xsl:template>

  <xsl:template match="BasicSequenceLog[TestStep|UnitTestCase]" mode="createTeststep">
    <xsl:if test="$debug">
      <xsl:message>create teststep
        <xsl:text> reportname=</xsl:text>
        <xsl:value-of select="@reportname"/>
        <xsl:text> name=</xsl:text>
        <xsl:value-of select="TestStep/@name"/>
      </xsl:message>
    </xsl:if>
    <xsl:attribute name="name">
      <xsl:choose>
        <xsl:when test="@reportname and @reportname != ''">
          <xsl:value-of select="@reportname"/>
        </xsl:when>
        <!-- name is set in case of variable expansion -->
        <xsl:when test="@name and @name != ''">
          <xsl:value-of select="@name"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="TestStep|UnitTestCase" mode="getName"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:if test="UnitTestCase">
      <xsl:attribute name="kind">
        <xsl:text>unittestcase</xsl:text>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates select="." mode="createStates"/>
    <xsl:apply-templates select="." mode="createComment"/>
    <xsl:apply-templates select="." mode="createSummary"/>
  </xsl:template>

  <xsl:template match="Screenshot[@cause='report']" mode="createTeststep">
    <xsl:if test="$debug">
      <xsl:message>create screenshot
        <xsl:text> title=</xsl:text>
        <xsl:value-of select="@title"/>
      </xsl:message>
    </xsl:if>
    <xsl:if test="@title">
      <xsl:attribute name="name">
        <xsl:value-of select="@title"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:attribute name="src">
      <xsl:value-of select="@sfile"/>
    </xsl:attribute>
    <xsl:attribute name="width">
      <xsl:value-of select="@swidth"/>
      </xsl:attribute>
    <xsl:attribute name="height">
      <xsl:value-of select="@sheight"/>
    </xsl:attribute>
    <xsl:if test="@tfile">
      <thumbnail src="{@tfile}" width="{@twidth}" height ="{@theight}"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*[&stepNode;]" mode="createTeststep">
    <xsl:if test="$debug">
      <xsl:message>create teststep for
        <xsl:value-of select="&stepNode;"/>
      </xsl:message>
    </xsl:if>
    <xsl:attribute name="name">
      <xsl:apply-templates select="./&stepNode;/value"/>
    </xsl:attribute>
    <xsl:if test="UnitStep">
      <xsl:attribute name="kind">
        <xsl:text>unittest</xsl:text>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates select="." mode="createStates"/>
    <xsl:apply-templates select="." mode="createComment"/>
    <xsl:apply-templates select="." mode="createSummary"/>
  </xsl:template>

  <xsl:template match="*[&setupNode;]" mode="createTeststep">
    <xsl:if test="$debug">
      <xsl:message>create teststep for
        <xsl:value-of select="&setupNode;"/>
      </xsl:message>
    </xsl:if>
    <xsl:attribute name="name">
      <xsl:choose>
        <xsl:when test="node/@kind='dependency' and node/@name">
          <xsl:value-of select="node/@name"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="./&setupNode;/value"/>
          <xsl:if test="name() = 'DependencyLog' and @mode='REQUIRE'">
            <xsl:variable name="id">
              <xsl:choose>
                <xsl:when test="Dependency/@id">
                  <xsl:value-of select="Dependency/@id"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="Dependency/@ref"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:if test="DependencyLog[Dependency/@ref=$id and @mode='LOG']/value">
              <xsl:text>(</xsl:text>
              <xsl:for-each select="DependencyLog[Dependency/@ref=$id and @mode='LOG']/value">
                <xsl:if test="position() &gt; 1">
                  <xsl:text>,&nbsp;</xsl:text>
                </xsl:if>
                <xsl:value-of select="text()"/>
              </xsl:for-each>
              <xsl:text>)</xsl:text>
            </xsl:if>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:if test="node[@kind='dependency' and @namespace]">
      <xsl:attribute name="namespace">
        <xsl:value-of select="node/@namespace"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates select="." mode="createStates"/>
    <xsl:apply-templates select="." mode="createComment"/>
    <xsl:apply-templates select="." mode="createSummary"/>
  </xsl:template>

  <!-- {{{ Fully qualified name -->

  <xsl:template match="&mainNodes;" mode="qname" priority="2">
    <xsl:if test="$debug">
      <xsl:message>qname on BaseTestLog: <xsl:apply-templates select="." mode="getName"/>
      </xsl:message>
    </xsl:if>
    <xsl:for-each select="&mainAncestorNodes;">
      <xsl:apply-templates select="." mode="getNameStripped"/>
      <xsl:text>.</xsl:text>
    </xsl:for-each>
    <xsl:apply-templates select="." mode="getNameStripped"/>
  </xsl:template>


  <!-- }}} -->
  <!-- {{{ Stripped name -->

  <xsl:template match="*" mode="getNameStripped">
    <xsl:variable name="name">
      <xsl:apply-templates select="." mode="getName"/>
    </xsl:variable>
    <xsl:call-template name="stripExcl">
      <xsl:with-param name="name" select="$name"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="*" mode="getPlainNameStripped">
    <xsl:variable name="name">
      <xsl:apply-templates select="." mode="getPlainName"/>
    </xsl:variable>
    <xsl:call-template name="stripExcl">
      <xsl:with-param name="name" select="$name"/>
    </xsl:call-template>
  </xsl:template>

  <!-- }}} -->

  <!-- }}} -->
  <!-- {{{ Tests and Sequences -->

  <!-- {{{ iterate-children -->

  <!-- Is this still used? Appears completely useless. -->

  <!--
  Called to iterate over the children of a node.

  Then iterate over the test/sequence child nodes. If depth > 0 or
  the child is marked as special, calculate new depth for the child as
  max(depth - 1, number of exclamation marks - 1) and recurse -->
  <xsl:template match="RootStepLog | &seqNodes; " mode="iterate-children">
    <xsl:param name="depth" select="0"/>

    <xsl:if test="$debug">
      <xsl:message>
        <xsl:text>Iterate-children over: </xsl:text>
        <xsl:apply-templates select="." mode="getName"/>
        <xsl:text>
          Depth: </xsl:text>
        <xsl:value-of select="$depth"/>
      </xsl:message>
    </xsl:if>

    <xsl:variable name="ndepth">
      <xsl:apply-templates select="." mode="calcDepth">
        <xsl:with-param name="depth" select="$depth"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$ndepth &gt;= 0">
        <xsl:apply-templates select="." mode="iterate">
          <xsl:with-param name="depth" select="$ndepth"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="&mainNodes; | &iterNodes;" mode="iterate-children">
          <xsl:with-param name="depth" select="-1"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Special version for nodes to skip: Proceed with the children  -->
  <xsl:template match="&iterNodes;" mode="iterate-children">
    <xsl:param name="depth" select="0"/>

    <xsl:if test="$debug">
      <xsl:message>
        <xsl:text>Iterate-children over: </xsl:text>
        <xsl:apply-templates select="." mode="getName"/>
        <xsl:text>
          Depth: </xsl:text>
        <xsl:value-of select="$depth"/>
      </xsl:message>
    </xsl:if>

    <xsl:apply-templates select="&mainNodes; | &iterNodes;" mode="iterate-children">
      <xsl:with-param name="depth" select="$depth"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- Special version for ProcedureCalls and TestCalls: Proceed with the called node  -->
  <xsl:template match="AbstractStepLog[ProcedureCall or TestCall]" mode="iterate-children">
    <xsl:param name="depth" select="0"/>

    <xsl:if test="$debug">
      <xsl:message>
        <xsl:text>Iterate-children over: </xsl:text>
        <xsl:apply-templates select="." mode="getName"/>
        <xsl:text>
          Depth: </xsl:text>
        <xsl:value-of select="$depth"/>
      </xsl:message>
    </xsl:if>

    <xsl:apply-templates select="&mainNodes; | &iterNodes;" mode="iterate-children">
      <xsl:with-param name="depth" select="$depth"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- Special version for SuiteChangeLog: Proceed with child  -->
  <xsl:template match="SuiteChangeLog" mode="iterate-children">
    <xsl:param name="depth" select="0"/>

    <xsl:if test="$debug">
      <xsl:message>
        <xsl:text>Iterate-children over: </xsl:text>
        <xsl:apply-templates select="." mode="getName"/>
        <xsl:text>
          Depth: </xsl:text>
        <xsl:value-of select="$depth"/>
      </xsl:message>
    </xsl:if>

    <xsl:apply-templates select="&mainNodes; | &iterNodes;" mode="iterate-children">
      <xsl:with-param name="depth" select="$depth"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- Special version for RootStep: Proceed with the tests  -->
  <xsl:template match="BasicSequenceLog[RootStep]" mode="iterate-children">
    <xsl:param name="depth" select="0"/>

    <xsl:if test="$debug">
      <xsl:message>
        <xsl:text>Iterate-children over: </xsl:text>
        <xsl:apply-templates select="." mode="getName"/>
        <xsl:text>
          Depth: </xsl:text>
        <xsl:value-of select="$depth"/>
      </xsl:message>
    </xsl:if>

    <xsl:apply-templates select="BasicSequenceLog | BaseTestLog | ExternalizedLog"
                         mode="iterate-children">
      <xsl:with-param name="depth" select="$depth"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- Special version for Checks: create check node -->
  <xsl:template match="&checkNodes;" mode="iterate-children">
    <xsl:apply-templates select="." mode="createCheckNode"/>
  </xsl:template>

  <!-- ignore -->
  <xsl:template match="*" mode="iterate-children"/>

  <!-- }}} -->
  <!-- {{{ iterate -->

  <!--
  Called when iterating over the children of a node.

  Create a test/sequence/procedure node with name, summary and comment
  Then iterate over the test/sequence child nodes. If depth > 0 or
  the child is marked as special, calculate new depth for the child as
  max(depth - 1, number of exclamation marks - 1) and recurse -->
  <xsl:template match="&seqNodes;" mode="iterate">
    <xsl:param name="depth" select="0"/>

    <xsl:variable name="id">
      <xsl:apply-templates select="." mode="getId"/>
    </xsl:variable>
    <xsl:variable name="name">
      <xsl:apply-templates select="." mode="getName"/>
    </xsl:variable>
    <xsl:variable name="type">
      <xsl:apply-templates select="." mode="getType"/>
    </xsl:variable>
    <xsl:if test="$debug">
      <xsl:message>
        <xsl:text>Iterate over: </xsl:text>
        <xsl:apply-templates select="." mode="getName"/>
        <xsl:text>
          Id: </xsl:text>
        <xsl:value-of select="$id"/>
        <xsl:text>
          Depth: </xsl:text>
        <xsl:value-of select="$depth"/>
        <xsl:text>
          Type: </xsl:text>
        <xsl:value-of select="$type"/>
      </xsl:message>
    </xsl:if>
    <xsl:element name="{$type}">
      <xsl:if test="$id and not(starts-with($id, '_'))">
        <xsl:attribute name="id">
          <xsl:value-of select="$id"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:attribute name="name">
        <xsl:call-template name="stripExcl">
          <xsl:with-param name="name" select="$name"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:apply-templates select="." mode="createStates"/>
      <xsl:apply-templates select="." mode="createComment"/>
      <xsl:apply-templates select="." mode="createSummary">
        <xsl:with-param name="depth" select="$depth"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="&mainNodes; | &iterNodes; | &checkNodes;" mode="iterate-children">
        <xsl:with-param name="depth" select="$depth"/>
      </xsl:apply-templates>
    </xsl:element>
    <xsl:if test="$debug">
      <xsl:message>
        <xsl:text>Done iterating over: </xsl:text>
        <xsl:apply-templates select="." mode="getName"/>
      </xsl:message>
    </xsl:if>
  </xsl:template>

  <!-- ignore -->
  <xsl:template match="BaseTestLog" mode="iterate" priority="1"/>
  <xsl:template match="*" mode="iterate"/>

  <!-- }}} -->

  <!-- }}} -->
  <!-- {{{ Summaries -->

  <!-- {{{ createSummary -->

  <!--
  Create a summary node.

  Calculate the duration, exception, error and warning count for the current
  node. If depth is zero, create lists of checks, exceptions, errors, and
  warnings, but skip "important" child nodes.
  -->

  <xsl:template match="*" mode="createSummary">
    <xsl:param name="depth" select="0"/>
    <xsl:if test="$debug">
      <xsl:message>
        <xsl:text>Create summary for: </xsl:text>
        <xsl:apply-templates select="." mode="getName"/>
        <xsl:text>
          Depth: </xsl:text>
        <xsl:value-of select="$depth"/>
      </xsl:message>
    </xsl:if>
    <summary time="{@time}" timestamp="{@timestamp}">
      <xsl:attribute name="duration">
        <xsl:apply-templates select="." mode="getDuration"/>
      </xsl:attribute>
      <xsl:attribute name="realtime">
        <xsl:apply-templates select="." mode="getRealtime"/>
      </xsl:attribute>
      <xsl:attribute name="exceptions">
        <xsl:value-of select="count(.//*[@pstate=3])"/>
      </xsl:attribute>
      <xsl:variable name="flakyexceptions" select="count(.//*[@pstate=3 and @reliability='flaky'])"/>
      <xsl:if test="$flakyexceptions&gt;0">
        <xsl:attribute name="flakyexceptions">
          <xsl:value-of select="$flakyexceptions"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:attribute name="errors">
        <xsl:value-of select="count(.//*[@pstate=2 and not(ancestor::BaseTestLog[1]/@reliability='expectedfail')])"/>
      </xsl:attribute>
      <xsl:attribute name="expectederrors">
        <xsl:value-of select="count(.//*[@pstate=2 and ancestor::BaseTestLog[1]/@reliability='expectedfail'])"/>
      </xsl:attribute>
      <xsl:variable name="flakyerrors" select="count(.//*[@pstate=2 and @reliability='flaky'])"/>
      <xsl:if test="$flakyerrors&gt;0">
        <xsl:attribute name="flakyerrors">
          <xsl:value-of select="$flakyerrors"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:attribute name="warnings">
        <xsl:choose>
          <xsl:when test="$summary-list-warnings=1">
            <xsl:value-of select="count(.//*[@pstate=1 and (name() != 'MessageLog' or node[@type='report'])])"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>0</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:if test="$summary-list-checks=1">
        <xsl:apply-templates select="." mode="createChecks">
        </xsl:apply-templates>
      </xsl:if>

      <xsl:if test="$summary-list-exceptions=1">
        <xsl:apply-templates select="." mode="createErrors">
          <xsl:with-param name="type" select="'exception'"/>
          <xsl:with-param name="pstate" select="3"/>
        </xsl:apply-templates>
      </xsl:if>
      <xsl:if test="$summary-list-errors=1">
        <xsl:apply-templates select="." mode="createErrors">
          <xsl:with-param name="type" select="'error'"/>
          <xsl:with-param name="pstate" select="2"/>
        </xsl:apply-templates>
      </xsl:if>
      <xsl:if test="$summary-list-warnings=1">
        <xsl:apply-templates select="." mode="createErrors">
          <xsl:with-param name="type" select="'warning'"/>
          <xsl:with-param name="pstate" select="1"/>
        </xsl:apply-templates>
      </xsl:if>
    </summary>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ createComment -->

  <!--
  Create a comment node for the current node.
  -->

  <xsl:template match="*" mode="createComment">
    <xsl:variable name="comment">
      <xsl:apply-templates select="." mode="getComment"/>
    </xsl:variable>
    <xsl:if test="$comment and $comment != ''">
      <xsl:element name="comment">
        <xsl:call-template name="stripExcl">
          <xsl:with-param name="name" select="$comment"/>
        </xsl:call-template>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ createMessage -->

  <!--
  Create a message node for the current node.
  -->

  <xsl:template match="CheckStepLog[&failedChecks;]" mode="createMessage" priority="1">
    <xsl:element name="message">
      <xsl:if test="node/@nowrap">
        <xsl:attribute name="nowrap">
          <xsl:value-of select="node/@nowrap"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="*/node/@nowrap">
        <xsl:attribute name="nowrap">
          <xsl:value-of select="*/node/@nowrap"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="FailedCheckStepLog/@lines">
        <xsl:attribute name="lines">
          <xsl:value-of select="FailedCheckStepLog//@lines"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="node[@type='report' and @kind='check']/value">
          <xsl:value-of select="node[@type='report' and @kind='check']/value/text()"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@xname"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text> - </xsl:text>
      <xsl:apply-templates select="&failedChecks;" mode="doCreateMessage"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="CheckStepLog[node[@type='report' and @kind='check']]" mode="createMessage">
    <xsl:element name="message">
      <xsl:if test="node/@nowrap">
        <xsl:attribute name="nowrap">
          <xsl:value-of select="node/@nowrap"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="FailedCheckStepLog/@lines">
        <xsl:attribute name="lines">
          <xsl:value-of select="FailedCheckStepLog//@lines"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="node[@type='report' and @kind='check']/value">
          <xsl:value-of select="node[@type='report' and @kind='check']/value/text()"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@xname"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

  <xsl:template match="CheckStepLog" mode="createMessage">
    <xsl:element name="message">
      <xsl:text>--</xsl:text>
    </xsl:element>
  </xsl:template>

  <xsl:template match="&failedChecks;" mode="createMessage" priority='.5'>
    <xsl:element name="message">
      <xsl:if test="node/@nowrap">
        <xsl:attribute name="nowrap">
          <xsl:value-of select="node/@nowrap"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="." mode="doCreateMessage"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="&failedChecks;" mode="doCreateMessage" priority='.5'>
    <xsl:apply-templates select="message"/>
  </xsl:template>

  <xsl:template match="MessageLog" mode="createMessage" priority='1'>
    <xsl:element name="message">
      <xsl:if test="node/@nowrap">
        <xsl:attribute name="nowrap">
          <xsl:value-of select="node/@nowrap"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@lines">
        <xsl:attribute name="lines">
          <xsl:value-of select="@lines"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="." mode="showMessage"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="ExceptionLog" mode="createMessage">
    <xsl:element name="message">
      <xsl:apply-templates select="Exception/message"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="ImageCheckAdvancedOKLog" mode="createMessage" priority='.5'>
    <xsl:element name="message">
      <xsl:apply-templates select="message"/>
    </xsl:element>
  </xsl:template>

  <!-- ignore -->
  <xsl:template match="*" mode="createMessage"/>

  <!-- }}} -->
  <!-- {{{ showMessage -->

  <xsl:template match="MessageLog" mode="showMessage">
    <xsl:attribute name="lines">
      <xsl:value-of select="message/@lines"/>
    </xsl:attribute>
    <xsl:apply-templates select="message"/>
  </xsl:template>

  <!-- }}} -->

  <!-- {{{ createChecks -->

  <!--
  Create a list of checks for the current node.

  Skip "important" child nodes.
  -->

  <xsl:template match="BaseTestLog[TestCase]" mode="createChecks">
    <checks>
      <xsl:apply-templates select="*" mode="listChecks">
        <xsl:with-param name="forcedeep" select="@testtype='testcase'"/>
      </xsl:apply-templates>
    </checks>
  </xsl:template>

  <xsl:template match="BasicSequenceLog[@testtype='test']" mode="createChecks">
    <xsl:if test="not(.//BaseTestLog) and not(.//BasicSequenceLog[@testtype='test'])">
      <checks>
        <xsl:apply-templates select="*" mode="listChecks"/>
      </checks>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*" mode="createChecks">
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ listChecks -->

  <!--
  List the checks for the current node.
  -->

  <!-- {{{ Default: go on -->

  <xsl:template match="*" mode="listChecks">
    <xsl:param name="forcedeep" select="false"/>
  <!-- <xsl:if test="$debug"> -->
      <!-- <xsl:message> -->
        <!-- listChecks default for -->
        <!-- <xsl:value-of select="local-name(current())"/> -->
        <!-- <xsl:text> </xsl:text> -->
        <!-- <xsl:value-of select="@timestamp"/> -->
        <!-- <xsl:text> </xsl:text> -->
        <!-- <xsl:apply-templates select="." mode="getName"/> -->
      <!-- </xsl:message> -->
    <!-- </xsl:if> -->
    <xsl:apply-templates select="*" mode="listChecks">
      <xsl:with-param name="forcedeep" select="$forcedeep"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ Checks: create check node -->

  <xsl:template match="&checkNodes;" mode="listChecks">
    <xsl:if test="$debug">
      <xsl:message>
        listChecks for
        <xsl:value-of select="local-name(current())"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="@timestamp"/>
        <xsl:text> </xsl:text>
        <xsl:apply-templates select="." mode="getName"/>
      </xsl:message>
    </xsl:if>
    <xsl:apply-templates select="." mode="createCheckNode"/>
  </xsl:template>

  <!-- }}} -->

  <!-- {{{ createCheckNode -->

  <!-- {{{ CheckStepLog -->

  <xsl:template match="CheckStepLog" mode="createCheckNode">

    <xsl:if test="$debug">
      <xsl:message>
        <xsl:text>Create check: </xsl:text>
        <xsl:apply-templates select="." mode="getName"/>
      </xsl:message>
    </xsl:if>

    <xsl:if test="*[@pstate &gt; 1 or (@pstate = 1 and $summary-list-warnings=1)]
                  or node[@type='report' and @kind='check']">
      <check>
        <xsl:attribute name="ref">
          <xsl:value-of select="generate-id()"/>
        </xsl:attribute>
        <xsl:apply-templates select="." mode="createStates"/>
        <xsl:if test="(@pstate = 2 or *[@pstate = 2]) and ancestor::BaseTestLog[1]/@reliability='expectedfail'">
          <xsl:attribute name="expectedfail">
            <xsl:text>true</xsl:text>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="@reliability='flaky'">
          <xsl:attribute name="flaky">
            <xsl:text>true</xsl:text>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="$debug">
          <xsl:message>
            <xsl:text>Screenshot: </xsl:text>
            <xsl:value-of select="Screenshot/@sfile"/>
          </xsl:message>
        </xsl:if>
        <xsl:apply-templates select="Screenshot" mode="createScreenshot"/>
        <xsl:apply-templates select="." mode="createImageCheckFailedImages"/>
        <xsl:apply-templates select="." mode="createComment"/>
        <xsl:apply-templates select="." mode="createMessage"/>
      </check>
    </xsl:if>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ MessageLog | ImageCheckFailedLog | ImageCheckAdvancedOKLog -->

  <xsl:template match="MessageLog[(@resource='msg.checkOK'
                                   or @resource='image.advancedAlgo.checkOK'
                                   or @resource='msg.checkFailed'
                                   or @resource='msg.checkFailedMessage'
                                   or @resource='msg.unittest.message.successful'
                                   or @resource='msg.unittest.message.testfailed'
                                   or @resource='msg.unittest.message.testfailedex'
                                   or @resource='checkFailed.image.advancedAlgo.checkfailed')
                                  and (@pstate &gt; 1 or node[@type='report'])]
                       | ImageCheckFailedLog[(@resource='msg.checkOK'
                                              or @resource='msg.checkOKAdv'
                                              or @resource='msg.checkFailed'
                                              or @resource='msg.checkFailedMessage'
                                              or @resource='msg.checkFailedAdv'
                                              or @resource='checkFailed.image.advancedAlgo.checkfailed')
                                             and (@pstate &gt; 1 or node[@type='report'])]
                       | ImageCheckAdvancedOKLog[(@resource='image.advancedAlgo.checkOK')]"
                mode="createCheckNode">

    <xsl:if test="$debug">
      <xsl:message>
        <xsl:text>Create check: </xsl:text>
        <xsl:apply-templates select="." mode="getName"/>
      </xsl:message>
    </xsl:if>

    <check>
      <xsl:attribute name="ref">
        <xsl:value-of select="generate-id()"/>
      </xsl:attribute>
      <xsl:apply-templates select="." mode="createStates"/>
      <xsl:if test="@pstate = 2 and ancestor::BaseTestLog[1]/@reliability='expectedfail'">
        <xsl:attribute name="expectedfail">
          <xsl:text>true</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@reliability='flaky'">
        <xsl:attribute name="flaky">
          <xsl:text>true</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="$debug">
        <xsl:message>
          <xsl:text>Screenshot: </xsl:text>
          <xsl:value-of select="../Screenshot/@sfile"/>
        </xsl:message>
      </xsl:if>
      <xsl:apply-templates select="../Screenshot" mode="createScreenshot"/>
      <xsl:apply-templates select="." mode="createImageCheckFailedImages"/>
      <xsl:apply-templates select="." mode="createMessage"/>
    </check>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ MessageLog .time  -->

  <xsl:template match="MessageLog[@resource = 'checkFailed.time'
                                  or @resource = 'checkFailed.timeout'
                                  or ((@resource = 'checkOK.time'  or @resource = 'checkOK.timeout')
                                      and (@pstate &gt; 1 or node[@type='report']
                                           or (@pstate = 1 and $summary-list-warnings=1)))]"
                mode="createCheckNode">

    <xsl:if test="$debug">
      <xsl:message>
        <xsl:text>Create check: </xsl:text>
        <xsl:apply-templates select="." mode="getName"/>
      </xsl:message>
    </xsl:if>

    <check>
      <xsl:attribute name="ref">
        <xsl:value-of select="generate-id()"/>
      </xsl:attribute>
      <xsl:apply-templates select="." mode="createStates"/>
      <xsl:if test="@pstate = 2 and ancestor::BaseTestLog[1]/@reliability='expectedfail'">
        <xsl:attribute name="expectedfail">
          <xsl:text>true</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@reliability='flaky'">
        <xsl:attribute name="flaky">
          <xsl:text>true</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="$debug">
        <xsl:message>
          <xsl:text>Screenshot: </xsl:text>
          <xsl:value-of select="../Screenshot/@sfile"/>
        </xsl:message>
      </xsl:if>
      <xsl:apply-templates select="../Screenshot" mode="createScreenshot"/>
      <xsl:apply-templates select="." mode="createImageCheckFailedImages"/>
      <xsl:apply-templates select=".." mode="createComment"/>
      <xsl:apply-templates select="." mode="createMessage"/>
    </check>
  </xsl:template>

  <!-- }}} -->

  <!-- Special version for TestSet/TestCase: Stop immediately  -->
  <xsl:template match="BaseTestLog" mode="listChecks" priority="1">
    <xsl:param name="forcedeep" select="false"/>
    <!-- Go on if forced -->
    <xsl:if test="$forcedeep">
      <xsl:apply-templates select="*" mode="listChecks">
        <xsl:with-param name="forcedeep" select="$forcedeep"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>
  <xsl:template match="text()" mode="listChecks"/>
  <xsl:template match="*|text()" mode="createCheckNode"/>

  <!-- }}} -->

  <!-- }}} -->

  <!-- {{{ createErrors -->

  <!--
  Create a list of warnings/errors/exceptions for the current node.

  The complex part is skipping the "important" child nodes. To avoid
  duplicating the templates, all kinds of errors are combined.
  -->

  <xsl:template match="&mainNodes; | RootStepLog" mode="createErrors">
    <xsl:param name="type" select="error"/>
    <xsl:param name="pstate" select="2"/>
    <xsl:if test="$debug">
      <xsl:message>
        <xsl:text>Create errors for: </xsl:text>
        <xsl:apply-templates select="." mode="getName"/>
        <xsl:text>type: </xsl:text>
        <xsl:value-of select="$type"/>
      </xsl:message>
    </xsl:if>
    <xsl:element name="{$type}s">
      <xsl:apply-templates select="*" mode="listErrors">
        <xsl:with-param name="type" select="$type"/>
        <xsl:with-param name="pstate" select="$pstate"/>
        <xsl:with-param name="forcedeep" select="@testtype='testcase'"/>
      </xsl:apply-templates>
    </xsl:element>
  </xsl:template>

  <xsl:template match="*" mode="createErrors">
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ listErrors -->

  <!--
  List the warnings/errors/exceptions for the current node.

  The complex part is skipping the "important" child nodes. To avoid
  duplicating the templates, all kinds of errors are combined.
  -->

  <!-- Default: go on -->
  <xsl:template match="*" mode="listErrors">
    <xsl:param name="type" select="error"/>
    <xsl:param name="pstate" select="2"/>
    <xsl:param name="forcedeep" select="false"/>

    <!-- <xsl:if test="$debug"> -->
      <!-- <xsl:message> -->
        <!-- <xsl:text>Default list error: </xsl:text> -->
        <!-- <xsl:value-of select="local-name(current())"/> -->
        <!-- <xsl:text> </xsl:text> -->
        <!-- <xsl:value-of select="@timestamp"/> -->
        <!-- <xsl:text> </xsl:text> -->
        <!-- <xsl:apply-templates select="." mode="getName"/> -->
        <!-- <xsl:text> -->
          <!-- Type: </xsl:text> -->
        <!-- <xsl:value-of select="$type"/> -->
        <!-- <xsl:text> -->
          <!-- pstate: </xsl:text> -->
        <!-- <xsl:value-of select="$pstate"/> -->
        <!-- <xsl:text> -->
          <!-- @pstate: </xsl:text> -->
        <!-- <xsl:value-of select="@pstate"/> -->
      <!-- </xsl:message> -->
    <!-- </xsl:if> -->

    <xsl:apply-templates select="*" mode="listErrors">
      <xsl:with-param name="type" select="$type"/>
      <xsl:with-param name="pstate" select="$pstate"/>
      <xsl:with-param name="forcedeep" select="$forcedeep"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- Special version for TestSet/TestCase: Stop immediately  -->
  <xsl:template match="&mainNodes;" mode="listErrors" priority="1">
    <xsl:param name="type" select="error"/>
    <xsl:param name="pstate" select="2"/>
    <xsl:param name="forcedeep" select="false"/>
    <!-- Go on if forced -->
    <xsl:if test="$forcedeep">
      <xsl:apply-templates select="*" mode="listErrors">
        <xsl:with-param name="type" select="$type"/>
        <xsl:with-param name="pstate" select="$pstate"/>
        <xsl:with-param name="forcedeep" select="$forcedeep"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <!--
  Create a warning/error/exception node.
  -->
  <xsl:template match="&errorNodes;" mode="listErrors">
    <xsl:param name="type" select="error"/>
    <xsl:param name="pstate" select="2"/>

    <xsl:if test="$debug">
      <xsl:message>
        <xsl:text>List error: </xsl:text>
        <xsl:value-of select="local-name(current())"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="@timestamp"/>
        <xsl:text> </xsl:text>
        <xsl:apply-templates select="." mode="getName"/>
        <xsl:text>
          Type: </xsl:text>
        <xsl:value-of select="$type"/>
        <xsl:text>
          pstate: </xsl:text>
        <xsl:value-of select="$pstate"/>
        <xsl:text>
          @pstate: </xsl:text>
        <xsl:value-of select="@pstate"/>
      </xsl:message>
    </xsl:if>

    <xsl:if test="@pstate=$pstate and
                  (@pstate != 1
                   or (name() != 'MessageLog'
                       and ((name() != 'ImageCheckFailedLog'
                             and name() != 'ImageCheckAdvancedOKLog')
                            or ancestor::*[position() = 1 and name() = 'CheckStepLog']))
                   or node[@type='report'])">
      <xsl:apply-templates select="." mode="createError">
        <xsl:with-param name="type" select="$type"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ createError -->

  <!--
  Create a warning/error/exception node.
  -->
  <xsl:template match="ExceptionLog
    | MessageLog[@resource='msg.plain'
                 or @resource='msg.user'
                 or @resource='msg.usernocompact'
                 or @resource='msg.expfailfail'
                 or @resource='msg.sut'
                 or @resource='msg.clientException'
                 or @resource='msg.stoppedDueToTimeout'
                 or @resource='msg.stoppedDueToTimeoutFromBatch'
                 or @resource='msg.qftestDeprecated'
                 or @resource='disabledComponentStep.message'
                 or @resource='msg.versionMismatch']"
                mode="createError">
    <xsl:param name="type" select="error"/>
    <xsl:apply-templates select="." mode="doCreateError">
      <xsl:with-param name="type" select="$type"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="&failedChecks;" mode="createError">
    <xsl:param name="type" select="error"/>
    <xsl:choose>
      <xsl:when test="$summary-list-checks!=1">
        <xsl:apply-templates select="." mode="doCreateError">
          <xsl:with-param name="type" select="$type"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="tcparent">
          <xsl:apply-templates select="ancestor::BaseTestLog[1]" mode="testcaseParent"/>
        </xsl:variable>
        <!-- Not ideal. A named Test parent that represents a test-set matches -->
        <!-- BasicSequenceLog[@testtype='test'] so some special errors may get lost -->
        <xsl:if test="not ($tcparent = 'yes' or ancestor::BasicSequenceLog[@testtype='test'])">
          <xsl:apply-templates select="." mode="doCreateError">
            <xsl:with-param name="type" select="$type"/>
          </xsl:apply-templates>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="BaseTestLog" mode="testcaseParent">
    <xsl:for-each select="*[1]">
      <xsl:if test="name() = 'TestCase'">
        <xsl:text>yes</xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="*" mode="doCreateError">
    <xsl:param name="type" select="error"/>
    <xsl:element name="{$type}">
      <xsl:attribute name="ref">
        <xsl:value-of select="generate-id()"/>
      </xsl:attribute>
      <xsl:variable name="tcparent">
        <xsl:apply-templates select="ancestor::BaseTestLog[1]" mode="testcaseParent"/>
      </xsl:variable>

      <!-- Not ideal. A named Test parent that represents a test-set matches -->
      <!-- BasicSequenceLog[@testtype='test'] so some special errors may get lost -->
      <xsl:if test="not ($tcparent = 'yes' or ancestor::BasicSequenceLog[@testtype='test'])">
        <xsl:attribute name="link">
          <xsl:value-of select="generate-id()"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="$type = 'error' and ancestor::BaseTestLog[1]/@reliability='expectedfail'">
        <xsl:attribute name="expectedfail">
          <xsl:text>true</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@reliability='flaky'">
        <xsl:attribute name="flaky">
          <xsl:text>true</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="." mode="createStates"/>
      <xsl:if test="$type='warning' or $type='error' or $type='exception'">
        <xsl:if test="$debug">
          <xsl:message>
            <xsl:text>Screenshot: </xsl:text>
            <xsl:value-of select="../Screenshot/@sfile"/>
          </xsl:message>
        </xsl:if>
        <xsl:apply-templates select="../Screenshot" mode="createScreenshot"/>
        <xsl:apply-templates select="." mode="createImageCheckFailedImages"/>
      </xsl:if>
      <xsl:apply-templates select="." mode="createMessage"/>
    </xsl:element>
  </xsl:template>

  <!-- ignore -->
  <xsl:template match="*" mode="createError"/>

  <!-- }}} -->
  <!-- {{{ createScreenshot -->

  <!--
  Create screenshot attributes for an error or exception node.
  -->
  <xsl:template match="Screenshot" mode="createScreenshot">
    <screenshot src="{@sfile}" width="{@swidth}" height ="{@sheight}">
      <xsl:choose>
	<xsl:when test="@title and @title != ''">
          <xsl:attribute name="title">
            <xsl:value-of select="@title"/>
          </xsl:attribute>
	</xsl:when>
	<xsl:when test="@screen">
          <xsl:attribute name="screen">
            <xsl:value-of select="@screen + 1"/>
          </xsl:attribute>
	</xsl:when>
      </xsl:choose>
      <xsl:if test="@client and @client != ''">
        <xsl:attribute name="client">
          <xsl:value-of select="@client"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@tfile">
        <thumbnail src="{@tfile}" width="{@twidth}" height ="{@theight}"/>
      </xsl:if>
    </screenshot>
  </xsl:template>

  <!-- ignore -->
  <xsl:template match="*" mode="createScreenshot"/>

  <!-- }}} -->
  <!-- {{{ createImageCheckFailedImages -->

  <!--
  Create screenshot attributes for an error or exception node.
  -->
  <xsl:template match="ImageCheckFailedLog[@pstate &gt; 0 or @report = 1]" mode="createImageCheckFailedImages">
    <xsl:if test="@efile">
      <screenshot src="{@efile}" width="{@ewidth}" height ="{@eheight}">
        <xsl:if test="@etitle and @etitle != ''">
          <xsl:attribute name="title">
            <xsl:value-of select="@etitle"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="@etfile">
          <thumbnail src="{@etfile}" width="{@etwidth}" height ="{@etheight}"/>
        </xsl:if>
      </screenshot>
    </xsl:if>
    <xsl:if test="@afile">
      <screenshot src="{@afile}" width="{@awidth}" height ="{@aheight}">
        <xsl:if test="@atitle and @atitle != ''">
          <xsl:attribute name="title">
            <xsl:value-of select="@atitle"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="@atfile">
          <thumbnail src="{@atfile}" width="{@atwidth}" height ="{@atheight}"/>
        </xsl:if>
      </screenshot>
    </xsl:if>
    <xsl:if test="@xfile">
      <screenshot src="{@xfile}" width="{@xwidth}" height ="{@xheight}">
        <xsl:if test="@xtitle and @xtitle != ''">
          <xsl:attribute name="title">
            <xsl:value-of select="@xtitle"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="@xtfile">
          <thumbnail src="{@xtfile}" width="{@xtwidth}" height ="{@xtheight}"/>
        </xsl:if>
      </screenshot>
    </xsl:if>
    <xsl:if test="@dfile">
      <screenshot src="{@dfile}" width="{@dwidth}" height ="{@dheight}">
        <xsl:if test="@dtitle and @dtitle != ''">
          <xsl:attribute name="title">
            <xsl:value-of select="@dtitle"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="@dtfile">
          <thumbnail src="{@dtfile}" width="{@dtwidth}" height ="{@dtheight}"/>
        </xsl:if>
      </screenshot>
    </xsl:if>
  </xsl:template>

  <!-- delegate -->
  <xsl:template match="CheckStepLog" mode="createImageCheckFailedImages">
    <xsl:apply-templates select="ImageCheckFailedLog" mode="createImageCheckFailedImages"/>
  </xsl:template>

  <!-- ignore -->
  <xsl:template match="*" mode="createImageCheckFailedImages"/>

  <!-- }}} -->

  <!-- }}} -->
  <!-- {{{ templates that extract data -->

  <!-- {{{ Common attribute access -->

  <!-- {{{ createStates -->

  <!--
  Create state, vstate and pstate attributes for the current node.
  -->

  <xsl:template match="*" mode="createStates">
    <xsl:attribute name="state">
      <xsl:choose>
        <xsl:when test="@state">
          <xsl:value-of select="@state"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>0</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="vstate">
      <xsl:choose>
        <xsl:when test="@vstate">
          <xsl:value-of select="@vstate"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>0</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="pstate">
      <xsl:choose>
        <xsl:when test="@pstate">
          <xsl:value-of select="@pstate"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>0</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="CheckStepLog[&failedChecks;]" mode="createStates">
    <xsl:apply-templates select="&failedChecks;" mode="createStates"/>
  </xsl:template>

  <xsl:template match="CheckStepLog" mode="createStates">
    <xsl:apply-templates select="*[1]" mode="createStates"/>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ getDuration -->

  <!--
  Get the duration of the current node.
  -->
  <xsl:template match="*[@duration]" mode="getDuration">
    <xsl:value-of select="@duration"/>
  </xsl:template>

  <!-- Default: unknown. Shouldn't really happen -->
  <xsl:template match="*" mode="getDuration">
    <xsl:text>unknown</xsl:text>
  </xsl:template>


  <!-- }}} -->
  <!-- {{{ getRealtime -->

  <!--
  Get the realtime of the current node.
  -->
  <xsl:template match="*[@realtime]" mode="getRealtime">
    <xsl:value-of select="@realtime"/>
  </xsl:template>

  <!-- Default: unknown. Shouldn't really happen -->
  <xsl:template match="*" mode="getRealtime">
    <xsl:text>unknown</xsl:text>
  </xsl:template>


  <!-- }}} -->

  <!-- }}} -->
  <!-- {{{ Possibly indirect access for step nodes -->

  <!-- {{{ getName -->

  <!--
  Get the name of the current node.

  Retrieve the name directly from a step child or indirecly from an id
  reference.
  -->

  <xsl:template match="BaseTestLog[@reportname and @reportname != '']" mode="getName" priority="2">
    <xsl:value-of select="@reportname"/>
  </xsl:template>

  <xsl:template match="BaseTestLog[TestSet] | BaseTestLog[TestCase]" mode="getName" priority="1">
    <xsl:value-of select="@name"/>
    <xsl:if test="value">
      <xsl:text>(</xsl:text>
      <xsl:for-each select="value">
        <xsl:if test="position() > 1">
          <xsl:text>,&nbsp;</xsl:text>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="text() = 'UNDEFINED'">
            <xsl:text>-</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="text()"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
      <xsl:text>)</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="BasicSequenceLog[@testtype='test' and @name!='']" mode="getName" priority="1">
    <xsl:apply-templates select="@name"/>
  </xsl:template>

  <xsl:template match="BasicSequenceLog | BaseTestLog[Test]" mode="getName">
    <xsl:apply-templates select="Test" mode="getName"/>
  </xsl:template>

  <xsl:template match="*" mode="getName">
    <xsl:choose>
      <xsl:when test="@ref">
        <xsl:value-of select="key('idkey',@ref)[1]/@name"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@name"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
  Special nodes
  -->
  <xsl:template match="ProcedureLog" mode="getName">
    <xsl:variable name="comment">
      <xsl:choose>
        <xsl:when test="local-name(..) = 'SuiteChangeLog'">
          <xsl:apply-templates select="../../ProcedureCall" mode="getComment"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="../ProcedureCall" mode="getComment"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="starts-with($comment, '!')">
        <xsl:value-of select="$comment"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="*[1]" mode="getName"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- }}} -->
  <!-- {{{ getPlainName -->

  <xsl:template match="*" mode="getPlainName">
    <xsl:apply-templates select="." mode="getName"/>
  </xsl:template>
  <xsl:template match="BaseTestLog[@reportname and @reportname != '']" mode="getPlainName"
    priority="2">
    <xsl:value-of select="@reportname"/>
  </xsl:template>

  <xsl:template match="BaseTestLog[TestSet] | BaseTestLog[TestCase]" mode="getPlainName"
    priority="1">
    <xsl:value-of select="@name"/>
  </xsl:template>

  <xsl:template match="*" mode="getPlainName">
    <xsl:apply-templates select="." mode="getName"/>
  </xsl:template>

  <!-- }}} -->

  <!-- {{{ getId -->

  <!--
  Get the id of the current node.

  Retrieve the id directly from a step child.
  -->

  <xsl:template match="BasicSequenceLog | BaseTestLog" mode="getId">
    <xsl:apply-templates select="*[1]" mode="getId"/>
  </xsl:template>

  <xsl:template match="*" mode="getId">
    <xsl:variable name="val">
      <xsl:choose>
        <xsl:when test="@ref">
          <xsl:value-of select="@ref"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@id"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="starts-with($val, '__')">
        <xsl:value-of select="substring-after(substring($val, 3), '_')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$val"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
  Special nodes
  -->
  <xsl:template match="ProcedureLog" mode="getId">
    <xsl:variable name="comment">
      <xsl:choose>
        <xsl:when test="local-name(..) = 'SuiteChangeLog'">
          <xsl:apply-templates select="../../ProcedureCall" mode="getComment"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="../ProcedureCall" mode="getComment"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="starts-with($comment, '!')">
        <xsl:choose>
          <xsl:when test="local-name(..) = 'SuiteChangeLog'">
            <xsl:apply-templates select="../../ProcedureCall" mode="getId"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="../ProcedureCall" mode="getId"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="*[1]" mode="getId"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ getComment -->

  <!--
  Get the comment of the current node.

  If the annotation is defined, use that. Otherwise
  Retrieve the comment directly from a step child or indirecly from an id
  reference.
  -->

  <xsl:template match="&mainNodes;
                       | RootStepLog
                       | CheckStepLog
                       | BasicSequenceLog[RootStep]
                       | &stepNodes;"
                mode="getComment">
    <xsl:choose>
      <xsl:when test="annotation">
        <xsl:value-of select="annotation"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="*[1]" mode="getComment"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*" mode="getComment">
    <xsl:choose>
      <xsl:when test="annotation">
        <xsl:value-of select="annotation"/>
      </xsl:when>
      <xsl:when test="@ref">
        <xsl:apply-templates select="key('idkey',@ref)[1]/comment"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="comment"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ getType -->

  <!--
  Get the type of the current node.

  Currently test, sequence and procedure are supported.
  -->

  <xsl:template match="*[Test]" mode="getType">
    <xsl:text>test</xsl:text>
  </xsl:template>

  <xsl:template match="*[Procedure | ProcedureCall]" mode="getType">
    <xsl:text>procedure</xsl:text>
  </xsl:template>

  <xsl:template match="*" mode="getType">
    <xsl:text>sequence</xsl:text>
  </xsl:template>

  <!-- <xsl:template match="*" mode="getType"> -->
    <!-- <xsl:message><xsl:text>This template should not have been called.</xsl:text></xsl:message> -->
  <!-- </xsl:template> -->

  <!-- }}} -->

  <!-- }}} -->

  <!-- }}} -->
  <!-- {{{ miscellaneous helpers -->

  <!-- {{{ calcDepth -->

  <!--
  This is the central template for traversing the run-log.
  It calculates the depth for the next level, based on the current level and
  the number of '!' marks in the name or comment of the current node.
  -->

  <xsl:template match="&seqNodes;" mode="calcDepth">
    <!-- The current depth -->
    <xsl:param name="depth" select="0"/>

    <!-- The identifier -->
    <xsl:variable name="sname">
      <xsl:apply-templates select="." mode="getName"/>
    </xsl:variable>
    <xsl:if test="$debug">
      <xsl:message>
        <xsl:text>SName: </xsl:text>
        <xsl:value-of select="$sname"/>
        <xsl:text>depth: </xsl:text>
        <xsl:value-of select="$depth"/>
      </xsl:message>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="($depth &gt; 0 and not(SetupSequence) and not(CleanupSequence)) or starts-with($sname, '!')">
        <!-- Inner depth -->
        <xsl:variable name="idepth">
          <xsl:call-template name="countDepth">
            <xsl:with-param name="name" select="$sname"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:if test="$debug">
          <xsl:message>
            <xsl:text>IDepth: </xsl:text>
            <xsl:value-of select="$idepth"/>
          </xsl:message>
        </xsl:if>

        <!-- New depth -->
        <xsl:variable name="ndepth">
          <xsl:choose>
            <xsl:when test="$depth &gt; $idepth">
              <xsl:value-of select="$depth - 1"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$idepth - 1"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:if test="$debug">
          <xsl:message>
            <xsl:text>NDepth: </xsl:text>
            <xsl:value-of select="$ndepth"/>
          </xsl:message>
        </xsl:if>

        <!-- The result -->
        <xsl:value-of select="$ndepth"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- The result -->
        <xsl:text>-1</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Special version for ProcedureCalls: Proceed with the called Procedure  -->
  <xsl:template match="AbstractStepLog[ProcedureCall] | SuiteChangeLog" mode="calcDepth">
    <!-- The current depth -->
    <xsl:param name="depth" select="0"/>
    <xsl:apply-templates select="&procNodes;" mode="iterate-children">
      <xsl:with-param name="depth" select="$depth"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- Special version for RootStep: Proceed with the tests  -->
  <xsl:template match="BasicSequenceLog[RootStep]" mode="calcDepth">
    <!-- The current depth -->
    <xsl:param name="depth" select="0"/>
    <xsl:apply-templates select="BasicSequenceLog | BaseTestLog" mode="iterate-children">
      <xsl:with-param name="depth" select="$depth"/>
    </xsl:apply-templates>
  </xsl:template>


  <!-- Default -->
  <xsl:template match="*" mode="calcDepth">
    <!-- The current depth -->
    <xsl:param name="depth" select="0"/>
    <xsl:message><xsl:text>Shouldn't be called</xsl:text></xsl:message>
    <xsl:text>0</xsl:text>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ countDepth -->

  <xsl:template name="countDepth">
    <xsl:param name="depth" select="0"/>
    <xsl:param name="name" select="''"/>

    <xsl:if test="$debug">
      <xsl:message>
        <xsl:text>countDepth depth: " </xsl:text>
        <xsl:value-of select="$depth"/>
        <xsl:text>, name:</xsl:text>
        <xsl:value-of select="$name"/>
      </xsl:message>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="starts-with($name, '!')">
        <xsl:call-template name="countDepth">
          <xsl:with-param name="depth" select="$depth + 1"/>
          <xsl:with-param name="name" select="substring($name, 2)"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$depth"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ stripExcl -->

  <xsl:template name="stripExcl">
    <xsl:param name="name" select="''"/>

    <xsl:if test="$debug">
      <xsl:message>
        <xsl:text>stripExcl name: " </xsl:text>
        <xsl:value-of select="$name"/>
      </xsl:message>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="starts-with($name, '!') or starts-with($name, ' ')">
        <xsl:call-template name="stripExcl">
          <xsl:with-param name="name" select="substring($name, 2)"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$name"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->

  <!-- }}} -->

</xsl:stylesheet>
