To set up QF-Test for imbus TestBench test automation, 
copy the file "itep.jar" and all JAR files from the libs/ 
folder in the iTEP directory to <QF-Test>/plugin/qftest.

The files of the TestBench QF-Test wrapper explained:

1) testaut.properties
   user.properties
   These two files are for configuring the basic behavior 
   of the wrapper, as explained in testaut.properties.
   For English version please change the entry "reportFileToExecute" to 
   "[...] report-en.zip" in user.properties.

2) report/report-*.zip
   A sample TestBench export file that can be executed 
   with the wrapper.
   You find a German and English version.

3) suite/TestBench_*.qft
   The implementation of the wrapper. Normally, these files 
   need NOT be modified.

4) suite/demo/CarConfig*.qft
   They (German and English version) are the starting point for running 
   the automated tests and using the TestBench QF-Test wrapper. 
   Both suites need the corresponding report/report*.zip file for test execution. 


For TestBench specific questions, please address the imbus 
TestBench support at support@imbus.de
