=========================================================================
=				GENERAL					=
=========================================================================
Beginning with TestLink 1.9.4 QF-Test supports the Automation API of TestLink.

You can either create QF-Test testsuites via exporting the planned test-cases from TestLink or import test-results from a QF-Test test execution into TestLink.

Note for older TestLink version than 1.9.4:
     The QF-Test/TestLink integration works with direct access of the database up-to-now.
     For a direct database access you need a Java database driver for your database. You can either ask your database administrator for it or download it from the internet.

=========================================================================
=			Before you start TestLink 1.9.4 or newer	=
=========================================================================

Step 1)
Please copy the folder 'api' to a dedicated directory for your project.
Then open the Jython module 'api/TestLinkUserSpecifics.py' with a text-editor.
There you have to change the link to your TestLink installation as well as the developer key to use the API.
In case you want to set custom_fields for the export, please do modify those as well.

'serverurl' specifies the link to your TestLink API.
'devkey' specifies development key for TestLink.
'custom_fields' specifies the custom fields of a test-case for the export.

=========================================================================
=       Exporting test-cases from TestLink into a QFT-Testsuite		=
=		  	     (1.9.4 or newer)				=
=========================================================================
You can create a QF-Test testsuite file after you have completed planning your test-cases in TestLink.

Here you can find a sample call for that:

On Windows:
exportTests.bat --testproject project1 --targetsuite export.qft

On Linux/Unix:
exportTests.sh --testproject project1 --targetsuite export.qft

In the created test-suite export.qft you can now find all test-cases of project 1 with the same structure like in TestLink.

If you only want to export single testsuites you can specify the parameter '--testsuite suite1' or '--testsuite suite1/subsuite2'.

If you want to get custom fields into the exported test-cases, you can specify the names of the custom fields in the list "custom_fields" in 'TestLinkUserSpecifics.py'. That's a comma-separated-list within the square brackets.

=========================================================================
=	Uploading test-results from QF-Test to TestLink			=
=		  	     (1.9.4 or newer)				=
=========================================================================
For uploading test-results into TestLink, you should create a XML-report during the QF-Test execution.
You can specify that name using the '-report.xml' parameter.

Sample Call of QF-Test:

qftest -batch -report.xml myreport.xml testsuite.qft

Then you can upload those results calling the import script.

On Windows:
importResults.bat --testproject project1 --resultfile myreport.xml --testplan the-plan

On Linux/Unix:
importResults.sh --testproject project1 --resultfile myreport.xml --testplan the-plan

=========================================================================
=			Before you start (before TestLink 1.9.4)	=
=========================================================================

Step 1)
Please copy the folders 'export' and 'import' to a dedicated directory for your project.
Then open the Jython module 'export/TestLinkDBIntegrator.py' and 'import/ReportParser.py' with a text-editor.
There you have to change the variables for the database access according to your database.

'dbdriver' specifies the class of the database driver.
'connectionstr' specifies the path how to access the database
'dbuser' and 'dbpass' are the public users for accessing the TestLink Database.
We recommend to use a dedicated user for importing automated test-results.

Step 2)
Please open the .bat/.sh scripts for performing the export and import and adapt it to the correct installation folder of QF-Test om your system.

On Windows:
Open 'export/exportTestLinkToQFT.bat' and 'import/importToTestLink.bat' with a text-editor and change the line
QFTDIR=c:\Program Files\qfs\qftest\qftest-3.1.4
TESTLINKINTEGRATOR=\path\where\you\copied\the\export\folder/to
to your installation folder.

On Unix:
Open 'export/exportTestLinkToQFT.sh' and 'import/importToTestLink.sh' with a text-editor and change the line
QFTDIR=/opt/qftest/qftest-3.1.4
TESTLINKINTEGRATOR=/path/where/you/copied/the/import/folder/to
to your installation folder.

Step 3)
The database connection requires a database driver, so please don't forget to add your database driver to the CLASSPATH variable.

On Windows:
set CLASSPATH=\location\of\driver.jar;%CLASSPATH%

On Unix:
export CLASSPATH=/location/of/driver.jar:$CLASSPATH

=========================================================================
=       Exporting test-cases from TestLink into a QFT-Testsuite		=
=	(before 1.9.4)							=
=========================================================================
You can create a QF-Test testsuite file after you have completed planning your test-cases in TestLink.

Here you can find a sample call for that:

On Windows:
exportTestLinkToQFT.bat --testproject project1 --targetsuite export.qft

On Linux/Unix:
exportTestLinkToQFT.sh --testproject project1 --targetsuite export.qft

In the created test-suite export.qft you can now find all test-cases of project 1 with the same structure like in TestLink.

If you only want to export single testsuites you can specify the parameter '-testsuite suite1' or '-testsuite suite1/subsuite2'.

If you want to get custom fields into the exported test-cases, you can specify the names of the custom fields in the list "custom_fields" in 'export/TestLinkDBIntegrator.py'. That's a comma-separated-list within the square brackets.

=========================================================================
=	Uploading test-results from QF-Test to TestLink			=
=	(before 1.9.4)							=
=========================================================================
For uploading test-results into TestLink, you should create a XML-report during the QF-Test execution.
You can specify that name using the '-report.xml' parameter.

Sample Call of QF-Test:

qftest -batch -report.xml myreport.xml testsuite.qft

Then you can upload those results calling the import script, located in the 'import' folder.

On Windows:
importToTestLink.bat --testproject project1 --resultfile myreport.xml --tester admin --testplan the-plan

On Linux/Unix:
importToTestLink.sh --testproject project1 --resultfile myreport.xml --tester admin --testplan the-plan

=========================================================================
=			Getting parameters of the scripts		=	
=========================================================================

.) Getting help
qfsTestLink.bat --help
