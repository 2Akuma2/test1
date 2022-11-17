<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" version="1.0" encoding="ISO-8859-1" indent="yes"/>

  <!-- {{{ root -->

  <xsl:template match="/">
    <xsl:apply-templates select="test-suite"/>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ test-suite  -->

  <xsl:template match="test-suite">
    <testsuite>
      <xsl:attribute name="errors">
        <xsl:value-of select="number(summary/@exceptions)"/>
	<!-- <xsl:value-of select="count(.//testcase/summary[@exceptions &gt; 0])"/> -->
      </xsl:attribute>
      <xsl:attribute name="failures">
        <xsl:value-of select="number(summary/@errors)"/>
	<!-- <xsl:value-of select="count(.//testcase/summary[@errors &gt; 0 and @exceptions = 0])"/> -->
      </xsl:attribute>
      <xsl:attribute name="hostname">
	<xsl:value-of select="@host"/>
      </xsl:attribute>
      <!-- skipped and not-implemented tests are now reportes as skipped in TestNG style to be
      properly displayed in Hudson/Jenkins -->
      <xsl:if test="number(count (.//testcase[@implemented = 'false']) + count(.//testcase[@skipped = 'true'])) &gt; 0">
        <xsl:attribute name="skipped">
          <xsl:value-of select="number(count (.//testcase[@implemented = 'false']) + count(.//testcase[@skipped = 'true']))"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:attribute name="name">
	<xsl:value-of select="translate(@name,'.','_')"/>
      </xsl:attribute>
      <xsl:attribute name="tests">
	<!-- <xsl:value-of select="number(count(.//testcase) - count (.//testcase[@implemented = 'false']) - count(.//testcase[@skipped = 'true']))"/> -->
	<xsl:value-of select="number(count(.//testcase))"/>
      </xsl:attribute>
      <xsl:attribute name="time">
	<xsl:value-of select="number(summary/@realtime)*0.001"/>
      </xsl:attribute>
      <xsl:attribute name="timestamp">
	<xsl:value-of select="@execution-date"/>
      </xsl:attribute>
      <properties>
	<property>
	  <xsl:attribute name="name">
	    <xsl:text>relname</xsl:text>
	  </xsl:attribute>
	  <xsl:attribute name="value">
	    <xsl:value-of select="@relname"/>
	  </xsl:attribute>
	</property>
	<property>
	  <xsl:attribute name="name">
	    <xsl:text>basedir</xsl:text>
	  </xsl:attribute>
	  <xsl:attribute name="value">
	    <xsl:value-of select="@basedir"/>
	  </xsl:attribute>
	</property>
	<property>
	  <xsl:attribute name="name">
	    <xsl:text>runid</xsl:text>
	  </xsl:attribute>
	  <xsl:attribute name="value">
	    <xsl:value-of select="@runid"/>
	  </xsl:attribute>
	</property>
	<property>
	  <xsl:attribute name="name">
	    <xsl:text>execution-date</xsl:text>
	  </xsl:attribute>
	  <xsl:attribute name="value">
	    <xsl:value-of select="@execution-date"/>
	  </xsl:attribute>
	</property>
	<property>
	  <xsl:attribute name="name">
	    <xsl:text>executed-by</xsl:text>
	  </xsl:attribute>
	  <xsl:attribute name="value">
	    <xsl:value-of select="@executed-by"/>
	  </xsl:attribute>
	</property>
	<property>
	  <xsl:attribute name="name">
	    <xsl:text>host</xsl:text>
	  </xsl:attribute>
	  <xsl:attribute name="value">
	    <xsl:value-of select="@host"/>
	  </xsl:attribute>
	</property>
	<property>
	  <xsl:attribute name="name">
	    <xsl:text>os-version</xsl:text>
	  </xsl:attribute>
	  <xsl:attribute name="value">
	    <xsl:value-of select="@os-version"/>
	  </xsl:attribute>
	</property>
	<property>
	  <xsl:attribute name="name">
	    <xsl:text>java-version</xsl:text>
	  </xsl:attribute>
	  <xsl:attribute name="value">
	    <xsl:value-of select="@java-version"/>
	  </xsl:attribute>
	</property>
	<property>
	  <xsl:attribute name="name">
	    <xsl:text>qftest-version</xsl:text>
	  </xsl:attribute>
	  <xsl:attribute name="value">
	    <xsl:value-of select="@qftest-version"/>
	  </xsl:attribute>
	</property>
      </properties>

      <!--       check for exceptions and errors outside test-cases -->
      <xsl:if test="count(summary/exceptions/exception) &gt; 0 or count(summary/errors/error) &gt; 0">
        <testcase>
          <xsl:attribute name="name">
            <xsl:text>-</xsl:text>
          </xsl:attribute>
          <xsl:call-template name="collect-errors"/>
        </testcase>
      </xsl:if>

      <!-- continue with test-sets and test-cases -->
      <xsl:apply-templates select="descendant::testcase | descendant::testset"/>
    <system-out/>
    <system-err/>
    </testsuite>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ test-set -->

  <xsl:template match="testset">
    <xsl:if test="count(summary/exceptions/exception) &gt; 0 or count(summary/errors/error) &gt; 0">
      <testcase>
        <xsl:attribute name="name">
          <xsl:value-of select="concat(@qname,'.-')"/>
        </xsl:attribute>
        <xsl:call-template name="collect-errors"/>
      </testcase>
    </xsl:if>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ test-case -->

  <xsl:template match="testcase">
    <testcase>
      <xsl:attribute name="name">
        <xsl:value-of select="@qname"/>
      </xsl:attribute>
      <xsl:call-template name="collect-errors"/>
      <xsl:if test="@implemented = 'false' or @skipped = 'true'">
        <skipped>
          <xsl:if test="@implemented = 'false'">
            <xsl:attribute name="message">
              <xsl:text>Not implemented</xsl:text>
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="@skipped = 'true'">
            <xsl:attribute name="message">
              <xsl:text>Skipped</xsl:text>
           </xsl:attribute>
          </xsl:if>
        </skipped>
      </xsl:if>
    </testcase>
  </xsl:template>

  <!-- }}} -->

  <!-- {{{ collect-errors -->

  <!-- collect-errors -->
  <xsl:template name="collect-errors">
    <xsl:attribute name="time">
      <xsl:value-of select='format-number(number(summary/@realtime)*0.001, "#.###")'/>
    </xsl:attribute>
    <xsl:choose>
      <xsl:when test="number(summary/@exceptions) &gt; 0">
        <error>
          <xsl:apply-templates select="./summary/exceptions"/>
        </error>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="number(summary/@errors) &gt; 0">
          <failure>
            <xsl:attribute name="message">
              <!-- Collect error and check messages -->
              <xsl:for-each select="child::summary/child::*/child::*">
                <xsl:if test="@pstate = '2'">
                  <xsl:if test="position() &gt; 1">
                    <xsl:text>&#10;--------------------&#10;</xsl:text>
                  </xsl:if>
                  <xsl:value-of select="message"/>
                </xsl:if>
              </xsl:for-each>
            </xsl:attribute>
            <xsl:attribute name="type">
              <xsl:text>error</xsl:text>
            </xsl:attribute>
          </failure>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- }}} -->
  <!-- {{{ exceptions -->

  <xsl:template match="exceptions">
    <xsl:attribute name="message">
      <xsl:for-each select="child::*">
	<xsl:value-of select="message"/>
	<xsl:if test="count(following-sibling::*) &gt; 0">
	  <xsl:text>&#10;--------------------&#10;</xsl:text>
	</xsl:if>
      </xsl:for-each>
    </xsl:attribute>
    <xsl:attribute name="type">
      <xsl:text>exception</xsl:text>
    </xsl:attribute>
  </xsl:template>

  <!-- }}} -->

</xsl:stylesheet>
