<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp   "&#160;" >
  <!ENTITY mainNodes "AbstractStepLog[ProcedureCall] | BasicSequenceLog | ProcedureLog | BaseTestLog">
  <!ENTITY seqNodes "BasicSequenceLog | ProcedureLog | BaseTestLog ">
  <!ENTITY errorNodes "ExceptionLog | CheckFailedLog | FailedCheckStepLog | ImageCheckFailedLog | MessageLog">
  <!ENTITY failedChecks "CheckFailedLog | FailedCheckStepLog | ImageCheckFailedLog">
  <!ENTITY procNodes "ProcedureLog | SuiteChangeLog">
  <!ENTITY iterNodes "LoopLog | SuiteChangeLog | AbstractStepLog">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xalan="http://xml.apache.org/xslt"
                version="1.0">

  <xsl:output method="xml"
              indent="yes"
              encoding="ISO-8859-1"
              doctype-public="-//QFS//DTD Test Report 1.0//EN"
              doctype-system="report.dtd"
              xalan:indent-amount="2"/>

  <!-- Key used to retrieve indirect nodes with ref=... -->
  <xsl:key name="idkey" match="*" use="@id"/>

  <!-- {{{ Parameters -->

  <!-- The language, default is 'en', alternative is 'de' -->
  <xsl:param name="lang" select="'en'"/>

  <!-- Default depth for the root test -->
  <xsl:param name="depth" select="1"/>

  <!-- Whether to list checks in summary -->
  <xsl:param name="summary-list-checks" select="1"/>

  <!-- Whether to list exceptions in summary -->
  <xsl:param name="summary-list-exceptions" select="1"/>

  <!-- Whether to list errors in summary -->
  <xsl:param name="summary-list-errors" select="1"/>

  <!-- Whether to list warnings in summary -->
  <xsl:param name="summary-list-warnings" select="1"/>

  <!-- Whether to log messages -->
  <xsl:param name="debug"/>

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
    <test-suite type="qftestJUI" name="{@suite}" host="{@host}" os-version="{@os}"
                executed-by="{@user}" execution-date="{@time}"
                java-version="{@jversion}" qftestJUI-version="{@qfversion}">
      <xsl:apply-templates select="." mode="createStates"/>
      <xsl:apply-templates select="." mode="createComment"/>
      <xsl:apply-templates select="." mode="createSummary">
        <xsl:with-param name="depth" select="$depth"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="*" mode="iterate-children">
        <xsl:with-param name="depth" select="$depth"/>
      </xsl:apply-templates>
    </test-suite>
  </xsl:template>


  <!-- }}} -->
  <!-- {{{ Tests and Sequences -->

  <!-- {{{ iterate-children -->

  <!--
  Called to iterate over the children of a node.

  Then iterate over the test/sequence child nodes. If depth > 0 or
  the child is marked as special, calculate new depth for the child as
  max(depth - 1, number of exclamation marks - 1) and recurse -->
  <xsl:template match="RootStepLog | &seqNodes; " mode="iterate-children">
    <xsl:param name="depth" select="0"/>

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
    <xsl:apply-templates select="&mainNodes; | &iterNodes;" mode="iterate-children">
      <xsl:with-param name="depth" select="$depth"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- Special version for ProcedureCalls: Proceed with the called Procedure  -->
  <xsl:template match="AbstractStepLog[ProcedureCall] | SuiteChangeLog" mode="iterate-children">
    <xsl:param name="depth" select="0"/>
    <xsl:apply-templates select="&procNodes;" mode="iterate-children">
      <xsl:with-param name="depth" select="$depth"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- Special version for RootStep: Proceed with the tests  -->
  <xsl:template match="BasicSequenceLog[RootStep]" mode="iterate-children">
    <xsl:param name="depth" select="0"/>
    <xsl:apply-templates select="&seqNodes;" mode="iterate-children">
      <xsl:with-param name="depth" select="$depth"/>
    </xsl:apply-templates>
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
      <xsl:apply-templates select="&mainNodes; | &iterNodes;" mode="iterate-children">
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
    <summary time="{@time}">
      <xsl:attribute name="duration">
        <xsl:apply-templates select="." mode="getDuration"/>
      </xsl:attribute>
      <xsl:attribute name="exceptions">
        <xsl:value-of select="count(.//*[@pstate=3])"/>
      </xsl:attribute>
      <xsl:attribute name="errors">
        <xsl:value-of select="count(.//*[@pstate=2])"/>
      </xsl:attribute>
      <xsl:attribute name="warnings">
        <xsl:value-of select="count(.//*[@pstate=1])"/>
      </xsl:attribute>

      <xsl:if test="$summary-list-checks">
        <xsl:apply-templates select="." mode="createChecks">
          <xsl:with-param name="depth" select="$depth"/>
        </xsl:apply-templates>
      </xsl:if>

      <xsl:if test="$summary-list-exceptions">
        <xsl:apply-templates select="." mode="createErrors">
          <xsl:with-param name="depth" select="$depth"/>
          <xsl:with-param name="type" select="'exception'"/>
          <xsl:with-param name="pstate" select="3"/>
        </xsl:apply-templates>
      </xsl:if>
      <xsl:if test="$summary-list-errors">
        <xsl:apply-templates select="." mode="createErrors">
          <xsl:with-param name="depth" select="$depth"/>
          <xsl:with-param name="type" select="'error'"/>
          <xsl:with-param name="pstate" select="2"/>
        </xsl:apply-templates>
      </xsl:if>
      <xsl:if test="$summary-list-warnings">
        <xsl:apply-templates select="." mode="createErrors">
          <xsl:with-param name="depth" select="$depth"/>
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

  <xsl:template match="CheckStepLog[&failedChecks;]" mode="createMessage">
    <xsl:apply-templates select="&failedChecks;" mode="createMessage"/>
  </xsl:template>

  <xsl:template match="CheckStepLog" mode="createMessage">
    <xsl:element name="message">
      <xsl:text>--</xsl:text>
    </xsl:element>
  </xsl:template>

  <xsl:template match="&failedChecks;" mode="createMessage">
    <xsl:element name="message">
      <xsl:apply-templates select="message"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="MessageLog" mode="createMessage">
    <xsl:element name="message">
      <xsl:apply-templates select="." mode="showMessage"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="ExceptionLog" mode="createMessage">
    <xsl:element name="message">
      <xsl:apply-templates select="Exception/message"/>
    </xsl:element>
  </xsl:template>

  <!-- ignore -->
  <xsl:template match="*" mode="createMessage"/>

  <!-- }}} -->
  <!-- {{{ showMessage -->

  <!-- Default: Plain copy -->
  <xsl:template match="MessageLog" mode="showMessage">
    <xsl:apply-templates select="param"/>
  </xsl:template>

  <!-- Client Exception: Piece together -->
  <xsl:template match="MessageLog[@resource='msg.clientException']" mode="showMessage">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Unerwartete Exception in Client '</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Unexpected exception in client '</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="param[1]"/>
    <xsl:text>':</xsl:text>
    <xsl:value-of select="param[2]"/>
  </xsl:template>

  <!-- Component info, default: Extract first line -->
  <xsl:template match="MessageLog[@resource='msg.sut']" mode="showMessage">
    <xsl:variable name="msg">
      <xsl:apply-templates select="param[1]"/>
    </xsl:variable>
    <xsl:value-of select="substring-before($msg, '&#x0A;')"/>
  </xsl:template>

  <!-- Component info with detail: Show detail -->
  <xsl:template match="MessageLog[@resource='msg.sut'][param[2] and param[2] != '']"  mode="showMessage" priority="1">
    <xsl:apply-templates select="param[2]"/>
  </xsl:template>

  <!-- qftest variable deprecated -->
  <xsl:template match="MessageLog[@resource='msg.qftestDeprecated']"  mode="showMessage">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Die Gruppe '${qftest:...}' wird demnächst entfernt.
Bitte verwenden Sie stattdessen '${qftestJUI:...}'</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>The group '${qftest:...}' is deprecated.
Please use '${qftestJUI:...}' instead</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Check OK -->
  <xsl:template match="MessageLog[@resource='msg.checkOK']"  mode="showMessage">
    <xsl:text>Check OK: </xsl:text>
    <xsl:call-template name="stripExcl">
      <xsl:with-param name="name" select="param"/>
    </xsl:call-template>
  </xsl:template>

  <!-- Check message -->
  <xsl:template match="MessageLog[@resource='msg.checkFailed']"  mode="showMessage">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Check fehlgeschlagen: </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Check failed: </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="stripExcl">
      <xsl:with-param name="name" select="param"/>
    </xsl:call-template>
  </xsl:template>

  <!-- Time limit exceeded -->
  <xsl:template match="MessageLog[@resource='checkFailed.time']"  mode="showMessage">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Zeitbeschränkung von </xsl:text>
        <xsl:apply-templates select="param[1]"/>
        <xsl:text>ms überschritten. Tatsächliche Dauer: </xsl:text>
        <xsl:apply-templates select="param[2]"/>
        <xsl:text>ms.</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Time limit of</xsl:text>
        <xsl:apply-templates select="param[1]"/>
        <xsl:text>ms exceeded. Actual time taken: </xsl:text>
        <xsl:apply-templates select="param[2]"/>
        <xsl:text>ms.</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="MessageLog[@resource='checkOK.time']"  mode="showMessage">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Zeitbeschränkung von </xsl:text>
        <xsl:apply-templates select="param[1]"/>
        <xsl:text>ms eingehalten. Tatsächliche Dauer: </xsl:text>
        <xsl:apply-templates select="param[2]"/>
        <xsl:text>ms.</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Time limit of</xsl:text>
        <xsl:apply-templates select="param[1]"/>
        <xsl:text>ms observed. Actual time taken: </xsl:text>
        <xsl:apply-templates select="param[2]"/>
        <xsl:text>ms.</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Version mismatch -->
  <xsl:template match="MessageLog[@resource='msg.versionMismatch']"  mode="showMessage">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>qftestJUI Versionen passen nicht zusammen. Server: </xsl:text>
        <xsl:apply-templates select="param[1]"/>
        <xsl:text> - SUT Client: </xsl:text>
        <xsl:apply-templates select="param[2]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>qftestJUI version mismatch. Server: </xsl:text>
        <xsl:apply-templates select="param[1]"/>
        <xsl:text> - SUT client: </xsl:text>
        <xsl:apply-templates select="param[2]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- }}} -->

  <!-- {{{ createChecks -->

  <!--
  Create a list of checks for the current node.

  Skip "important" child nodes.
  -->

  <xsl:template match="*" mode="createChecks">
    <xsl:param name="depth" select="0"/>
    <checks>
      <xsl:apply-templates select="*" mode="listChecks">
        <xsl:with-param name="depth" select="$depth"/>
      </xsl:apply-templates>
    </checks>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ listChecks -->

  <!--
  List the checks for the current node.
  -->

  <!-- Sequence nodes: iterate unless we get our own summary -->
  <xsl:template match="&seqNodes;" mode="listChecks">
    <xsl:param name="depth" select="0"/>

    <xsl:variable name="ndepth">
      <xsl:apply-templates select="." mode="calcDepth">
        <xsl:with-param name="depth" select="$depth"/>
      </xsl:apply-templates>
    </xsl:variable>

    <xsl:if test="$debug">
      <xsl:message>
        <xsl:text>List check: </xsl:text>
        <xsl:apply-templates select="." mode="getName"/>
        <xsl:text>
          Depth: </xsl:text>
        <xsl:value-of select="$depth"/>
        <xsl:text>
          ndepth: </xsl:text>
        <xsl:value-of select="$ndepth"/>
      </xsl:message>
    </xsl:if>

    <xsl:if test="$ndepth &lt; 0">
      <xsl:apply-templates select="*" mode="listChecks">
        <xsl:with-param name="depth" select="$ndepth"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <!-- Special version for ProcedureCalls: Proceed with the called Procedure  -->
  <xsl:template match="AbstractStepLog[ProcedureCall] | SuiteChangeLog" mode="listChecks">
    <xsl:param name="depth" select="0"/>

    <xsl:apply-templates select="&procNodes;" mode="listChecks">
      <xsl:with-param name="depth" select="$depth"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- Special version for RootStep: Proceed with the tests  -->
  <xsl:template match="BasicSequenceLog[RootStep]" mode="listChecks">
    <xsl:param name="depth" select="0"/>

    <xsl:apply-templates select="&seqNodes;" mode="listChecks">
      <xsl:with-param name="depth" select="$depth"/>
    </xsl:apply-templates>
  </xsl:template>

  <!--
  Create a check node.
  -->
  <xsl:template match="CheckStepLog" mode="listChecks">
    <xsl:param name="depth" select="0"/>

    <xsl:if test="$debug">
      <xsl:message>
        <xsl:text>Create check: </xsl:text>
        <xsl:apply-templates select="." mode="getName"/>
        <xsl:text>
          Depth: </xsl:text>
        <xsl:value-of select="$depth"/>
      </xsl:message>
    </xsl:if>

    <xsl:variable name="comment">
      <xsl:apply-templates select="." mode="getComment"/>
    </xsl:variable>
    <xsl:if test="$debug">
      <xsl:message>
        <xsl:text>comment:</xsl:text>
        <xsl:value-of select="$comment"/>
      </xsl:message>
    </xsl:if>

    <xsl:if test="starts-with($comment,'!')">
      <check>
        <xsl:apply-templates select="." mode="createStates"/>
        <xsl:apply-templates select="." mode="createComment"/>
        <xsl:apply-templates select="." mode="createMessage"/>
      </check>
    </xsl:if>
  </xsl:template>

  <!--
  Create a check node.
  -->
  <xsl:template match="MessageLog[starts-with(param/text(),'!') and (@resource='msg.checkOK' or @resource='msg.checkFailed')]"
    mode="listChecks">
    <xsl:param name="depth" select="0"/>

    <xsl:if test="$debug">
      <xsl:message>
        <xsl:text>Create check: </xsl:text>
        <xsl:apply-templates select="." mode="getName"/>
        <xsl:text>
          Depth: </xsl:text>
        <xsl:value-of select="$depth"/>
      </xsl:message>
    </xsl:if>

    <check>
      <xsl:apply-templates select="." mode="createStates"/>
      <xsl:apply-templates select="." mode="createMessage"/>
    </check>
  </xsl:template>

  <!--
  Create a check node.
  -->
  <xsl:template match="MessageLog[@resource = 'checkFailed.time' or @resource = 'checkOK.time']"
                mode="listChecks">
    <xsl:param name="depth" select="0"/>

    <xsl:if test="$debug">
      <xsl:message>
        <xsl:text>Create check: </xsl:text>
        <xsl:apply-templates select="." mode="getName"/>
        <xsl:text>
          Depth: </xsl:text>
        <xsl:value-of select="$depth"/>
      </xsl:message>
    </xsl:if>

    <xsl:variable name="comment">
      <xsl:apply-templates select=".." mode="getComment"/>
    </xsl:variable>
    <xsl:if test="$debug">
      <xsl:message>
        <xsl:text>comment:</xsl:text>
        <xsl:value-of select="$comment"/>
      </xsl:message>
    </xsl:if>

    <xsl:if test="starts-with($comment,'!')">
      <check>
        <xsl:apply-templates select="." mode="createStates"/>
        <xsl:apply-templates select=".." mode="createComment"/>
        <xsl:apply-templates select="." mode="createMessage"/>
      </check>
    </xsl:if>
  </xsl:template>

  <!-- Default: go on -->
  <xsl:template match="*" mode="listChecks">
    <xsl:param name="depth" select="0"/>

    <xsl:apply-templates select="*" mode="listChecks">
      <xsl:with-param name="depth" select="$depth"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- }}} -->

  <!-- {{{ createErrors -->

  <!--
  Create a list of warnings/errors/exceptions for the current node.

  The complex part is skipping the "important" child nodes. To avoid
  duplicating the templates, all kinds of errors are combined.
  -->

  <xsl:template match="*" mode="createErrors">
    <xsl:param name="depth" select="0"/>
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
        <xsl:with-param name="depth" select="$depth"/>
        <xsl:with-param name="type" select="$type"/>
        <xsl:with-param name="pstate" select="$pstate"/>
      </xsl:apply-templates>
    </xsl:element>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ listErrors -->

  <!--
  List the warnings/errors/exceptions for the current node.

  The complex part is skipping the "important" child nodes. To avoid
  duplicating the templates, all kinds of errors are combined.
  -->

  <xsl:template match="&seqNodes;" mode="listErrors">
    <xsl:param name="depth" select="0"/>
    <xsl:param name="type" select="error"/>
    <xsl:param name="pstate" select="2"/>

    <xsl:variable name="ndepth">
      <xsl:apply-templates select="." mode="calcDepth">
        <xsl:with-param name="depth" select="$depth"/>
      </xsl:apply-templates>
    </xsl:variable>

    <xsl:if test="$debug">
      <xsl:message>
        <xsl:text>List error: </xsl:text>
        <xsl:value-of select="local-name(current())"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="@timestamp"/>
        <xsl:text> </xsl:text>
        <xsl:apply-templates select="." mode="getName"/>
        <xsl:text>
          Depth: </xsl:text>
        <xsl:value-of select="$depth"/>
        <xsl:text>
          Type: </xsl:text>
        <xsl:value-of select="$type"/>
        <xsl:text>
          pstate: </xsl:text>
        <xsl:value-of select="$pstate"/>
        <xsl:text>
          ndepth: </xsl:text>
        <xsl:value-of select="$ndepth"/>
      </xsl:message>
    </xsl:if>

    <xsl:if test="$ndepth &lt; 0">
      <xsl:apply-templates select="*" mode="listErrors">
        <xsl:with-param name="depth" select="$ndepth"/>
        <xsl:with-param name="type" select="$type"/>
        <xsl:with-param name="pstate" select="$pstate"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <!-- Special version for ProcedureCalls: Proceed with the called Procedure  -->
  <xsl:template match="AbstractStepLog[ProcedureCall] | SuiteChangeLog" mode="listErrors">
    <xsl:param name="depth" select="0"/>
    <xsl:param name="type" select="error"/>
    <xsl:param name="pstate" select="2"/>

    <xsl:apply-templates select="&procNodes;" mode="listErrors">
      <xsl:with-param name="depth" select="$depth"/>
      <xsl:with-param name="type" select="$type"/>
      <xsl:with-param name="pstate" select="$pstate"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- Special version for RootStep: Proceed with the tests  -->
  <xsl:template match="BasicSequenceLog[RootStep]" mode="listErrors">
    <xsl:param name="depth" select="0"/>
    <xsl:param name="type" select="error"/>
    <xsl:param name="pstate" select="2"/>

    <xsl:apply-templates select="&seqNodes;" mode="listErrors">
      <xsl:with-param name="depth" select="$depth"/>
      <xsl:with-param name="type" select="$type"/>
      <xsl:with-param name="pstate" select="$pstate"/>
    </xsl:apply-templates>
  </xsl:template>

  <!--
  Create a warning/error/exception node.
  -->
  <xsl:template match="&errorNodes;" mode="listErrors">
    <xsl:param name="depth" select="0"/>
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
          Depth: </xsl:text>
        <xsl:value-of select="$depth"/>
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

    <xsl:if test="@pstate=$pstate">
      <xsl:apply-templates select="." mode="createError">
        <xsl:with-param name="type" select="$type"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <!-- Default: go on -->
  <xsl:template match="*" mode="listErrors">
    <xsl:param name="depth" select="0"/>
    <xsl:param name="type" select="error"/>
    <xsl:param name="pstate" select="2"/>

    <xsl:if test="$debug">
      <xsl:message>
        <xsl:text>Default list error: </xsl:text>
        <xsl:value-of select="local-name(current())"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="@timestamp"/>
        <xsl:text> </xsl:text>
        <xsl:apply-templates select="." mode="getName"/>
        <xsl:text>
          Depth: </xsl:text>
        <xsl:value-of select="$depth"/>
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

    <xsl:apply-templates select="*" mode="listErrors">
      <xsl:with-param name="depth" select="$depth"/>
      <xsl:with-param name="type" select="$type"/>
      <xsl:with-param name="pstate" select="$pstate"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ createError -->

  <!--
  Create a warning/error/exception node.
  -->
  <xsl:template match="ExceptionLog | &failedChecks;
                | MessageLog[@resource='msg.plain' or @resource='msg.user' or
                @resource='msg.usernocompact' or @resource='msg.sut' or
                @resource='msg.clientException' or @resource='msg.qftestDeprecated' or
                @resource='checkFailed.time' or @resource='msg.versionMismatch']"
                mode="createError">
    <xsl:param name="type" select="error"/>
    <xsl:element name="{$type}">
      <xsl:apply-templates select="." mode="createStates"/>
      <xsl:apply-templates select="." mode="createMessage"/>
    </xsl:element>
  </xsl:template>

  <!-- ignore -->
  <xsl:template match="*" mode="createError"/>

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

  <!-- }}} -->
  <!-- {{{ Possibly indirect access for step nodes -->

  <!-- {{{ getName -->

  <!--
  Get the name of the current node.

  Retrieve the name directly from a step child or indirecly from an id
  reference.
  -->

  <xsl:template match="BasicSequenceLog" mode="getName">
    <xsl:apply-templates select="*[1]" mode="getName"/>
  </xsl:template>

  <xsl:template match="*" mode="getName">
    <xsl:choose>
      <xsl:when test="@ref">
        <xsl:value-of select="key('idkey',@ref)/@name"/>
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
  <!-- {{{ getId -->

  <!--
  Get the id of the current node.

  Retrieve the id directly from a step child.
  -->

  <xsl:template match="BasicSequenceLog | BaseTestLog" mode="getId">
    <xsl:apply-templates select="*[1]" mode="getId"/>
  </xsl:template>

  <xsl:template match="*" mode="getId">
    <xsl:choose>
      <xsl:when test="@ref">
        <xsl:value-of select="@ref"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@id"/>
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

  Retrieve the comment directly from a step child or indirecly from an id
  reference.
  -->

  <xsl:template match="&mainNodes; | CheckStepLog" mode="getComment">
    <xsl:apply-templates select="*[1]" mode="getComment"/>
  </xsl:template>

  <xsl:template match="*" mode="getComment">
    <xsl:choose>
      <xsl:when test="@ref">
        <xsl:apply-templates select="key('idkey',@ref)/comment"/>
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

  <xsl:template match="*[Test] | *[TestCase] | *[TestSet]" mode="getType">
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

  <!-- Special version for TestCase/TestSet -->
  <xsl:template match="BaseTestLog" mode="calcDepth" priority="1">
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
      <xsl:when test="$depth &gt;= 0 or starts-with($sname, '!')">
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
              <xsl:choose>
                <xsl:when test="$idepth &lt; 1">
                  <xsl:value-of select="0"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$idepth - 1"/>
                </xsl:otherwise>
              </xsl:choose>
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
        <xsl:text>0</xsl:text>
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
    <xsl:apply-templates select="&seqNodes;" mode="iterate-children">
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
      <xsl:when test="starts-with($name, '!')">
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
