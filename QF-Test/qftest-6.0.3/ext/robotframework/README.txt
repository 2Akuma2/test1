This directory holds the implementation of the Robot Framework library "qftest" which implements
Robot Framework keywords as procedure calls to a QF-Test daemon.

Please see the QF-Test manual for further information about the QF-Test daemon and how to implement
Robot Framework keywords in QF-Test test-suites.


The integration requires the following setup:

Robot Framework / Python:
=========================

You need at least Robot Framework version 4.


The Python module jpype is used for the integration of Python and Java. To install it via pip, use

pip install JPype1


To make the qftest library known to Robot Framework, add this directory to your PYTHONPATH
environment variable or create a file called qftest_robot.pth in the site-packages of your Python 3
installation - i.e .../python3/Lib/site-packages/qftest_robot.pth - with just one line, the full
path to this directory.


QF-Test:
========

You need at least QF-Test version 6.0.0 installed.


Start QF-Test (in batch mode or interactively) with the additional arguments
-daemon -daemonport 5454 -keystore=

Interactive daemon mode is perfect while setting up your keywords and writing your tests.

The port 5454 is just an example, choose whatever you like, but make sure you use the same in the
robot file.

As explained in the QF-Test manual, -keystore= tells the daemon to use unsecured communication,
which is OK for internal use on your local machine. The third argument to the qftest library shown
below should be "false" if the QF-Test daemon is started with -keystore= and "true" otherwise.


Robot Framework / robot scripts:
================================

To interact with QF-Test, include the qftest Robot Framework library as shown below. It has the
following four optional parameters:

host (default localhost)
port (default 5454)
use-keystore (default true, false is faster)
primary test-suite (default robot.qft in the current directory)

*** Settings ***
Library    qftest    localhost    5454    false    ${SUITE}


Pre-defined keywords:
---------------------

Set Global: Set one or more global QF-Test variables, use with one or more name=value arguments


Defining your own keywords:
---------------------------

The primary test-suite specified above and all its directly or indirectly included test-suites are
traversed for keyword lookup.

Keywords are specified via the @keyword doctag in the comment attribute of a Package or Procedure
node.

Package with @keyword: Map the whole package hierarchy as keywords.

Procedure with @keyword: Map the procedure's name as a keyword.

Procedure with @keyword <keyword name>: Map the procedure as a the keyword specified in the doctag.

Multiple @keyword tags for a single procedure are possible. During execution the keyword called by
RF is passed to the procedure as the parameter __keyword.

Robot Framework tags can be specified via - possibly multiple - @tag doctags in the Procedure's
comment.

The procedure's comment will also be returned as keyword documentation to Robot Framework.


Calling keywords:
-----------------

All parameters are named arguments with the names and default values taken from the procedure in the
order given there.

Every keyword accepts free named parameters of the form name=value. These are bound as additional
parameters for the procedure call.


Notes:
------

When working in interactive mode you can set breakpoints in QF-Test as usual and - if the QF-Test
debugger is activated - the test will be interrupted on errors so you can see what's going on and
edit your keywords as necessary.

Completely stopping the test in QF-Test will also stop the robot script.

After the run, the result of the entire script is stored as a single QF-Test run-log with a
test-case structure matching the executed Robot Framework tests. It ist accessible as usual via
Ctrl-L or the Run menu.
