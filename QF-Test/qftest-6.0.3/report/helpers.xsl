<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xalan="http://xml.apache.org/xslt"
                exclude-result-prefixes="xalan"
                version="1.0">

  <!-- {{{ Language-specific callables -->

  <!-- {{{ lc-and -->

  <xsl:template name="lc-and">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>und</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>and</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-author -->

  <xsl:template name="lc-author">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Autor</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Author</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-charvar -->

  <xsl:template name="lc-catch">
    <xsl:text>Catch</xsl:text>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-charvar -->

  <xsl:template name="lc-charvar">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Charakteristische Variablen</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Characteristic variables</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-check -->

  <xsl:template name="lc-check">
    <xsl:text>Check</xsl:text>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-checks -->

  <xsl:template name="lc-checks">
    <xsl:text>Checks</xsl:text>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-cleanup -->

  <xsl:template name="lc-cleanup">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Aufräumen</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Cleanup</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-comment -->

  <xsl:template name="lc-comment">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Bemerkung</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Comment</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-condition -->

  <xsl:template name="lc-condition">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Bedingung</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Condition</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-created -->

  <xsl:template name="lc-created">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Erstellt</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Created</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-dependency -->

  <xsl:template name="lc-dependency">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Abhängigkeit</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Dependency</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-deprecated -->

  <xsl:template name="lc-deprecated">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Veraltet</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Deprecated</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-description -->

  <xsl:template name="lc-description">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Beschreibung</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Description</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-details -->

  <xsl:template name="lc-details">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Details</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Details</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-directory -->

  <xsl:template name="lc-directory">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Verzeichnis</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Directory</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-duration -->

  <xsl:template name="lc-duration">
      <xsl:choose>
        <xsl:when test="$lang='de'">
          <xsl:text>Dauer</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Duration</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-duration-long -->

  <xsl:template name="lc-duration-long">
      <xsl:choose>
        <xsl:when test="$lang='de'">
          <xsl:text>In Tests verbrachte Zeit</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Time spent in tests</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-error -->

  <xsl:template name="lc-error">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Fehler</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Error</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-error-list -->

  <xsl:template name="lc-error-list">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Fehler</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>error</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-errorsoverview -->

  <xsl:template name="lc-errorsoverview">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Übersicht: Fehler</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Overview: Errors</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-errors -->

  <xsl:template name="lc-errors">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Fehler</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Errors</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-errors-list -->

  <xsl:template name="lc-errors-list">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Fehler</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>errors</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-errorsuitesoverview -->

  <xsl:template name="lc-errorsuitesoverview">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Übersicht: Testsuiten mit Fehlern</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Overview: Test-suites with errors</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-exception -->

  <xsl:template name="lc-exception">
    <xsl:text>Exception</xsl:text>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-exception-list -->

  <xsl:template name="lc-exception-list">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Exception</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>exception</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-exceptions -->

  <xsl:template name="lc-exceptions">
    <xsl:text>Exceptions</xsl:text>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-exceptions-list -->

  <xsl:template name="lc-exceptions-list">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Exceptions</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>exceptions</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-executed -->

  <xsl:template name="lc-executed">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Ausgeführt</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Executed</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-executedby -->

  <xsl:template name="lc-executedby">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Ausgeführt von</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Executed by</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-executiondate -->

  <xsl:template name="lc-executiondate">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Ausführungsdatum</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Execution date</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-experror -->

  <xsl:template name="lc-experror">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Erwarteter Fehler</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Expected error</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-experrors -->

  <xsl:template name="lc-experrors">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Erwartete Fehler</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Expected errors</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-experror-list -->

  <xsl:template name="lc-experror-list">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>erwarteter Fehler</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>expected error</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-experrors -->

  <xsl:template name="lc-experrors-list">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>erwartete Fehler</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>expected errors</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-flaky -->

  <xsl:template name="lc-flaky">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>unregelmäßig</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>flaky</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-flakyerror -->

  <xsl:template name="lc-flakyerror">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Unregelmäßiger Fehler</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Flaky error</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-flakyexception -->

  <xsl:template name="lc-flakyexception">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Unregelmäßige Exception</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Flaky exception</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-failed -->

  <xsl:template name="lc-failed">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Fehler</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Failed</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-host -->

  <xsl:template name="lc-host">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Rechner</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Host</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-innamespace -->

  <xsl:template name="lc-innamespace">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>im Namensraum</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>in namespace</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-javaversion -->

  <xsl:template name="lc-javaversion">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Java Version</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Java version</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-message -->

  <xsl:template name="lc-message">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Meldung</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Message</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-name -->

  <xsl:template name="lc-name">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Name</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Name</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-notimplemented -->

  <xsl:template name="lc-notimplemented">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Nicht implementiert</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Not implemented</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-numdependencies -->

  <xsl:template name="lc-numdependencies">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Abhängigkeiten</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Dependencies</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-numerror -->

  <xsl:template name="lc-numerror">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Anzahl Testfälle mit Fehlern</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Number of test-cases with errors</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-numexcepted -->

  <xsl:template name="lc-numexcepted">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Anzahl Testfälle mit Exceptions</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Number of test-cases with exceptions</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-numexecuted -->

  <xsl:template name="lc-numexecuted">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Anzahl ausgeführter Testfälle</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Number of executed test-cases</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-numexperror -->

  <xsl:template name="lc-numexperror">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Anzahl Testfälle mit erwarteten Fehlern</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Number of test-cases with expected errors</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-numnotimpl -->

  <xsl:template name="lc-numnotimpl">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Anzahl nicht implementierter Testfälle</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Number of not implemented test-cases</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-numpackages -->

  <xsl:template name="lc-numpackages">
    <xsl:text>Packages</xsl:text>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-numpassed -->

  <xsl:template name="lc-numpassed">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Anzahl erfolgreicher Testfälle</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Number of successful test-cases</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-numprocedures -->

  <xsl:template name="lc-numprocedures">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Prozeduren</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Procedures</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-numskipped -->

  <xsl:template name="lc-numskipped">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Anzahl übersprungener Testfälle</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Number of skipped test-cases</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-numskippedsets -->

  <xsl:template name="lc-numskippedsets">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Anzahl übersprungener Testfallsätze</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Number of skipped test-sets</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-numsuites -->

  <xsl:template name="lc-numsuites">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Testsuites</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Test-suites</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-numtestcase -->

  <xsl:template name="lc-numtestcase">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Anzahl Testfälle insgesamt</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Total number of test-cases</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-numtestcases -->

  <xsl:template name="lc-numtestcases">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Testfälle</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Test-cases</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-numtestsets -->

  <xsl:template name="lc-numtestsets">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Testfallsätze</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Test-sets</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-piepassed -->

  <xsl:template name="lc-piepassed">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>erfolgreich</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>passed</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-piefailed -->

  <xsl:template name="lc-piefailed">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>fehlgeschlagen</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>failed</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-pieskipped -->

  <xsl:template name="lc-pieskipped">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>nicht ausgeführt</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>not executed</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-pietitle -->

  <xsl:template name="lc-pietitle">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Testfallübersicht - für Details klicken</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Test-case overview - click for details</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-host -->

  <xsl:template name="lc-os">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Betriebssystem</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Operating system</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-ok -->

  <xsl:template name="lc-ok">
    <xsl:text>OK</xsl:text>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-package -->

  <xsl:template name="lc-package">
    <xsl:text>Package</xsl:text>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-packagesoverview -->

  <xsl:template name="lc-packagesoverview">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Übersicht: Packages</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Overview: Packages</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-packagesandproceduresoverview -->

  <xsl:template name="lc-packagesandproceduresoverview">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Übersicht: Packages und Prozeduren</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Overview: Packages and procedures</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-parameters -->

  <xsl:template name="lc-parameters">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Parameter</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Parameters</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-passed -->

  <xsl:template name="lc-passed">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Erfolgreich</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Passed</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-percentpassed -->

  <xsl:template name="lc-percentpassed">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Prozent Testfälle erfolgreich</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Percent test-cases passed</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-problems -->

  <xsl:template name="lc-problems">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Probleme</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Problems</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-procedure -->

  <xsl:template name="lc-procedure">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Prozedur</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Procedure</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-procedure-dependency -->

  <xsl:template name="lc-procedure-dependency">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Prozedur/Abhängigkeit</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Procedure/Dependency</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-qftestversion -->

  <xsl:template name="lc-qftestversion">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>QF-Test Version</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>QF-Test version</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-realtime -->

  <xsl:template name="lc-realtime">
      <xsl:choose>
        <xsl:when test="$lang='de'">
          <xsl:text>Echtzeit</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Realtime</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-realtime-long -->

  <xsl:template name="lc-realtime-long">
      <xsl:choose>
        <xsl:when test="$lang='de'">
          <xsl:text>Real verstrichene Zeit</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Elapsed realtime</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-reportname -->

  <xsl:template name="lc-reportname">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Name des Reports</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Report name</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-result -->

  <xsl:template name="lc-result">
      <xsl:choose>
        <xsl:when test="$lang='de'">
          <xsl:text>Ergebnis</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Result</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-return -->

  <xsl:template name="lc-return">
      <xsl:choose>
        <xsl:when test="$lang='de'">
          <xsl:text>Rückgabewert</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Returns</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-runid -->

  <xsl:template name="lc-runid">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Testlauf ID</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Test-run ID</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-skipped -->

  <xsl:template name="lc-skipped">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Übersprungen</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Skipped</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-screenshot -->

  <xsl:template name="lc-screenshot">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Bildschirmabbild</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Screenshot</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-screenshot-for -->

  <xsl:template name="lc-screenshot-of-screen">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Abbild von Bildschirm </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Screenshot of screen </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-setup -->

  <xsl:template name="lc-setup">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Vorbereitung</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Setup</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-since -->

  <xsl:template name="lc-since">
      <xsl:choose>
        <xsl:when test="$lang='de'">
          <xsl:text>Seit</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Since</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-starttime -->

  <xsl:template name="lc-starttime">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Startzeit</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Start time</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-step -->

  <xsl:template name="lc-step">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Schritt</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Step</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-summary -->

  <xsl:template name="lc-summary">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Zusammenfassung</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Summary</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-suitesoverview -->

  <xsl:template name="lc-suitesoverview">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Übersicht: Testsuiten</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Overview: Test-suites</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-testcase -->

  <xsl:template name="lc-testcase">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Testfall</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Test-case</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-testcasesexecuted -->

  <xsl:template name="lc-testcasesexecuted">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Testfälle ausgeführt</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Test-cases executed</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-testrun -->

  <xsl:template name="lc-testrun">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Testlauf</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>test-run</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-Testrun -->

  <xsl:template name="lc-Testrun">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Testlauf</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Test-run</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-testset -->

  <xsl:template name="lc-testset">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Testfallsatz</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Test-set</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-testsetsoverview -->

  <xsl:template name="lc-testsetsoverview">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Übersicht: Testfallsätze</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Overview: Test-sets</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-testsetsandtestcasesoverview -->

  <xsl:template name="lc-testsetsandtestcasesoverview">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Übersicht: Testfallsätze und Testfälle</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Overview: Test-sets and test-cases</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-testsuite -->

  <xsl:template name="lc-testsuite">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Testsuite</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>test-suite</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-Testsuite -->

  <xsl:template name="lc-Testsuite">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Testsuite</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Test-suite</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-testsuite-name -->

  <xsl:template name="lc-testsuite-name">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Testsuite-Name</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>test-suite name</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-testsuite-file -->

  <xsl:template name="lc-testsuite-file">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Testsuite-Datei</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>test-suite file</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-tests -->

  <xsl:template name="lc-tests">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Tests</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Tests</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-teststep -->

  <xsl:template name="lc-teststep">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Testschritt</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Test-step</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-teststeps -->

  <xsl:template name="lc-teststeps">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Testschritte</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Test-steps</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-totalresult -->

  <xsl:template name="lc-totalresult">
      <xsl:choose>
        <xsl:when test="$lang='de'">
          <xsl:text>Gesamtergebnis</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Overall result</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-type -->

  <xsl:template name="lc-type">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Art</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Type</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-version -->

  <xsl:template name="lc-version">
    <xsl:text>Version</xsl:text>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-warning -->

  <xsl:template name="lc-warning">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Warnung</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Warning</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-warning-list -->

  <xsl:template name="lc-warning-list">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Warnung</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>warning</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-warnings -->

  <xsl:template name="lc-warnings">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Warnungen</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Warnings</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-warnings-list -->

  <xsl:template name="lc-warnings-list">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Warnungen</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>warnings</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ lc-warningsoverview -->

  <xsl:template name="lc-warningsoverview">
    <xsl:choose>
      <xsl:when test="$lang='de'">
        <xsl:text>Übersicht: Warnungen</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Overview: Warnings</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->

  <!-- }}} -->

  <!-- {{{ basename -->

  <!-- Get the filename part of a file -->
  <xsl:template name="basename">
    <xsl:param name="file"/>
    <xsl:choose>
      <xsl:when test="contains($file, '/')">
        <xsl:variable name="rest">
          <xsl:value-of select="substring-after($file, '/')"/>
        </xsl:variable>
        <xsl:call-template name="basename">
          <xsl:with-param name="file" select="$rest"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$file"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ dirname -->

  <!-- Get the directory name of a file -->
  <xsl:template name="dirname">
    <xsl:param name="file"/>
    <xsl:if test="contains($file, '/')">
      <xsl:value-of select="substring-before($file, '/')"/>
      <xsl:variable name="rest">
        <xsl:value-of select="substring-after($file, '/')"/>
      </xsl:variable>
      <xsl:if test="contains($rest, '/')">
        <xsl:text>/</xsl:text>
        <xsl:call-template name="dirname">
          <xsl:with-param name="file" select="$rest"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ dirnameforjoin -->

  <!-- Get the directory name of a file with a trailing / if non-empty -->
  <xsl:template name="dirnameforjoin">
    <xsl:param name="file"/>
    <xsl:if test="contains($file, '/')">
      <xsl:value-of select="substring-before($file, '/')"/>
      <xsl:variable name="rest">
        <xsl:value-of select="substring-after($file, '/')"/>
      </xsl:variable>
      <xsl:if test="$rest != ''">
        <xsl:text>/</xsl:text>
        <xsl:call-template name="dirnameforjoin">
          <xsl:with-param name="file" select="$rest"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ result-text -->

  <xsl:template name="result-text">
    <xsl:param name="result"/>
    <xsl:choose>
      <xsl:when test="@skipped='true'">
        <xsl:call-template name="lc-skipped"/>
      </xsl:when>
      <xsl:when test="@implemented='false'">
        <xsl:call-template name="lc-notimplemented"/>
      </xsl:when>
      <xsl:when test="$result = 0">
        <xsl:call-template name="lc-passed"/>
      </xsl:when>
      <xsl:when test="$result = 1">
        <xsl:call-template name="lc-warning"/>
      </xsl:when>
      <xsl:when test="$result = 2">
        <xsl:call-template name="lc-error"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="lc-exception"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ result-list -->

  <xsl:template match="*[summary]" mode="result-list">
    <xsl:choose>
      <xsl:when test="@skipped='true'">
        <xsl:call-template name="lc-skipped"/>
      </xsl:when>
      <xsl:when test="@implemented='false'">
          <xsl:call-template name="lc-notimplemented"/>
      </xsl:when>
      <xsl:when test="summary/@exceptions + summary/@errors + summary/@expectederrors + summary/@warnings = 0">
        <xsl:call-template name="lc-passed"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="summary/@exceptions &gt; 0">
          <xsl:value-of select="summary/@exceptions"/>
          <xsl:text> </xsl:text>
          <xsl:choose>
            <xsl:when test="summary/@exceptions &gt; 1">
              <xsl:call-template name="lc-exceptions-list"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="lc-exception-list"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:if test="summary/@flakyexceptions &gt; 0">
            <xsl:text> (</xsl:text>
            <xsl:value-of select="summary/@flakyexceptions"/>
            <xsl:text> </xsl:text>
            <xsl:call-template name="lc-flaky"/>
            <xsl:text>)</xsl:text>
          </xsl:if>
          <xsl:choose>
            <xsl:when test="(summary/@errors &gt; 0 and summary/@expectederrors + summary/@warnings &gt; 0)
                            or (summary/@expectederrors &gt; 0 and summary/@warnings &gt; 0)">
              <xsl:text>, </xsl:text>
            </xsl:when>
            <xsl:when test="summary/@errors + summary/@expectederrors + summary/@warnings &gt; 0">
              <xsl:text> </xsl:text>
              <xsl:call-template name="lc-and"/>
              <xsl:text> </xsl:text>
            </xsl:when>
          </xsl:choose>
        </xsl:if>
        <xsl:if test="summary/@errors &gt; 0">
          <xsl:value-of select="summary/@errors"/>
          <xsl:text> </xsl:text>
          <xsl:choose>
            <xsl:when test="summary/@errors &gt; 1">
              <xsl:call-template name="lc-errors-list"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="lc-error-list"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:if test="summary/@flakyerrors &gt; 0">
            <xsl:text> (</xsl:text>
            <xsl:value-of select="summary/@flakyerrors"/>
            <xsl:text> </xsl:text>
            <xsl:call-template name="lc-flaky"/>
            <xsl:text>)</xsl:text>
          </xsl:if>
          <xsl:choose>
            <xsl:when test="summary/@expectederrors &gt; 0 and summary/@warnings &gt; 0">
              <xsl:text>, </xsl:text>
            </xsl:when>
            <xsl:when test="summary/@expectederrors + summary/@warnings &gt; 0">
              <xsl:text> </xsl:text>
              <xsl:call-template name="lc-and"/>
              <xsl:text> </xsl:text>
            </xsl:when>
          </xsl:choose>
        </xsl:if>
        <xsl:if test="summary/@expectederrors &gt; 0">
          <xsl:value-of select="summary/@expectederrors"/>
          <xsl:text> </xsl:text>
          <xsl:choose>
            <xsl:when test="summary/@expectederrors &gt; 1">
              <xsl:call-template name="lc-experrors-list"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="lc-experror-list"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:if test="summary/@warnings &gt; 0">
            <xsl:text> </xsl:text>
            <xsl:call-template name="lc-and"/>
            <xsl:text> </xsl:text>
          </xsl:if>
        </xsl:if>
        <xsl:if test="summary/@warnings &gt; 0">
          <xsl:value-of select="summary/@warnings"/>
          <xsl:text> </xsl:text>
          <xsl:choose>
            <xsl:when test="summary/@warnings &gt; 1">
              <xsl:call-template name="lc-warnings-list"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="lc-warning-list"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ duration-text -->

  <xsl:template name="duration-text">
    <xsl:param name="duration"/>
    <xsl:choose>
      <xsl:when test="$duration &lt; 1000">
        <xsl:value-of select="$duration"/>
        <xsl:text> ms</xsl:text>
      </xsl:when>
      <xsl:when test="$duration &lt; 60000">
        <xsl:value-of select="round($duration div 1000)"/>
        <xsl:text> s</xsl:text>
      </xsl:when>
      <xsl:when test="$duration &lt; 3600000">
        <xsl:value-of select="floor(($duration + 500) div 60000)"/>
        <xsl:text>:</xsl:text>
        <xsl:variable name="sec" select="round($duration div 1000) mod 60"/>
        <xsl:if test="$sec &lt; 10">
          <xsl:text>0</xsl:text>
        </xsl:if>
        <xsl:value-of select="$sec"/>
        <xsl:text> min</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="floor(($duration + 500) div 3600000)"/>
        <xsl:text>:</xsl:text>
        <xsl:variable name="min" select="floor(($duration + 500) div 60000) mod 60"/>
        <xsl:if test="$min &lt; 10">
          <xsl:text>0</xsl:text>
        </xsl:if>
        <xsl:value-of select="$min"/>
        <xsl:text>:</xsl:text>
        <xsl:variable name="sec" select="round($duration div 1000) mod 60"/>
        <xsl:if test="$sec &lt; 10">
          <xsl:text>0</xsl:text>
        </xsl:if>
        <xsl:value-of select="$sec"/>
        <xsl:text> h</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ percent -->

  <xsl:template name="percent">
    <xsl:param name="numerator"/>
    <xsl:param name="denominator"/>
    <xsl:choose>
      <xsl:when test="$denominator = 0">
        <xsl:text>100</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="percent" select="round($numerator div $denominator * 100)"/>
        <xsl:choose>
          <!-- Don't report 100% unless _all_ tests succeeded -->
          <xsl:when test="$percent = 100 and $numerator &lt; $denominator">
            <xsl:text>99</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$percent"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ count-lines -->

  <xsl:template name="count-lines">
    <xsl:param name="text" select="''"/>
    <xsl:param name="max" select="-1"/>
    <xsl:param name="count" select="0"/>
    <xsl:variable name="line" select="substring-before($text,'&#x0a;')"/>
    <xsl:variable name="rest" select="substring-after($text,'&#x0a;')"/>
    <xsl:choose>
      <xsl:when test="$line=''">
        <xsl:choose>
          <xsl:when test="$text=''">
            <xsl:value-of select="$count"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$count + 1"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$count + 1 = max">
            <xsl:value-of select="max"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="count-lines">
              <xsl:with-param name="text" select="$rest"/>
              <xsl:with-param name="count" select="$count + 1"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ subst-hash -->

  <!-- Replace hash characters with %23 for use in URLs -->
  <xsl:template name="subst-hash">
    <xsl:param name="text"/>
    <xsl:choose>
      <xsl:when test="contains($text, '#')">
        <xsl:value-of select="substring-before($text, '#')"/>
        <xsl:text>%23</xsl:text>
        <xsl:call-template name="subst-hash">
          <xsl:with-param name="text" select="substring-after($text, '#')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
</xsl:stylesheet>
