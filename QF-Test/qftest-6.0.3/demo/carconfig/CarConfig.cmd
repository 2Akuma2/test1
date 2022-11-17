@echo off

rem *******************************************
rem Start script for the CarConfig example.
rem Arguments:
rem [-engine <swing>] UI engine to use (swing/fx)
rem [-lang <language>] It's either English or German.
rem [-fontsize <fontsize>]  To setup font size.
rem [-loadtest]  To start load test mode.
rem [-login]  To start with login dialog. Use tester/tester to login.
rem [-splash]  To start with splash screen.
rem *******************************************

VERIFY OTHER 2>nul
SETLOCAL ENABLEEXTENSIONS
IF ERRORLEVEL 1 ECHO Unable to enable extensions
SET QF_JRE_REL=%CD%\..\..\jre
SET QF_JRE_REL_W64=%QF_JRE_REL%\win64\bin
SET QF_JRE_REL_W32=%QF_JRE_REL%\win32\bin
IF DEFINED QFTEST_JAVA (
   SET JAVA_BIN="%QFTEST_JAVA%"
) ELSE (
   ECHO Trying to find embedded JRE
    IF EXIST "%QF_JRE_REL%" (
       IF EXIST "%QF_JRE_REL_W64%" (SET JAVA_BIN="%QF_JRE_REL_W64%\java"
       ) ELSE IF EXIST "%QF_JRE_REL_W32%" (SET JAVA_BIN="%QF_JRE_REL_W32%\java"
       ) ELSE (SET JAVA_BIN=java)
    ) ELSE (
        ECHO No embedded Java runtime found. Using default java installed.
        SET JAVA_BIN=java
    )
)

ECHO Using following java runtime: %JAVA_BIN%

%JAVA_BIN% -cp "../../qflib/qfdemo.jar;../../qflib/qflib.jar;../../lib/looks.jar;../../lib/jgraphx.jar" "de.qfs.apps.qftest.demo.multi.carconfigurator.main.CarConfigurator" %*

ENDLOCAL
