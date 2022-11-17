@echo off

rem  ###########################################################################
rem  Wrapper script for calling the TestLinkImporter Jython class of QF-Test   #
rem  Author: QFS, www.qfs.de                                                   #
rem  Since: 3.5.1                                                              #
rem  ###########################################################################

rem Version folder of QF-Test
set QFTDIR=c:\Program Files\QFS\QF-Test\qftest-6.0.3

rem Folder, where the .py file is located
set TESTLINKINTEGRATORDIR=%QFTDIR%\ext\testlink\api

rem java used for executing
set JAVA="java"

rem the classpath including QF-Test's Jython Jar
set CLASSPATH=%CLASSPATH%;%QFTDIR%\lib\jython.jar

rem The TestlinkIntegrator class
set TESTLINKINTEGRATOR=%TESTLINKINTEGRATORDIR%\TestLinkImporter.py

rem Jython directory
set JYTHONDIR=%QFTDIR%\jython

rem Launch the Java command - exit code comes from java call
%JAVA% -classpath "%CLASSPATH%" -Dpython.home="%JYTHONDIR%" org.python.util.jython -S "%TESTLINKINTEGRATOR%" %*
