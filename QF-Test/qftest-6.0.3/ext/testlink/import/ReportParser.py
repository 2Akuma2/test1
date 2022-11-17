# -*- coding: iso-8859-1 -*-

import xmllib
from com.ziclix.python.sql import zxJDBC
from os.path import dirname, join
from java.lang import String
import getopt, sys

#connection info for the database
#a JDBC database driver is required
dbdriver = "org.postgresql.Driver"
#dbdriver = "com.mysql.jdbc.Driver"
connectionstr = "jdbc:postgresql://localhost/testlink"
#connectionstr = "jdbc:mysql://localhost/testlink18"
dbuser = "testlink"
dbpass = "testlink"

#The specified custom fields will be written into the 'Comment' attribute of the according sequence.
custom_fields = []

class TestCase:
    def __init__(self, name, result):
        self.name = name
        self.result = result

    def getResult(self):
        return self.result

    def getName(self):
        return self.name

class TestSuite:
    def __init__(self, name, executionDate=None, runid=None):
        self.membersuites = []
        self.name = name
        self.executionDate = executionDate
        self.testsets = []
        self.testcases = []
        self.runid = runid

    def addTestCase(self, testcase):
        self.testcases.append(testcase)

    def addTestSet(self, testset):
        self.testsets.append(testset)

    def getTestSets(self):
        return self.testsets

    def getTestCases(self):
        return self.testcases

    def getRunid(self):
        return self.runid

    def getName(self):
        return self.name

    def getExecutionDate(self):
        return self.executionDate

class ReportParser(xmllib.XMLParser):

    def __init__(self, testSuite=None, inTopReport = 0):
        xmllib.XMLParser.__init__(self)
        self.reportFile = None
        self.inTopReport = inTopReport
        self.testSuite = testSuite

        self.allTestSuites = {}

        self.currentTestSuite = None
        self.currentTestSet = None
        self.currentTestCase = None

        self.topSuites = []
        self.openTestSets = []

        self.subFile = None

    def load(self, reportFile):
        self.reportFile = reportFile
        rH = open(reportFile)
        while 1:
            s = rH.read(512)
            if not s:
                break
            self.feed(s)
        self.close()

    def handle_data(self, data):
        pass

    def unknown_starttag(self, tag, attributes):
        self.currentTag = tag
        if tag == "test-suite":
            name = attributes['name']
            nameParts = name.split("/")
            currentName = nameParts[len(nameParts) - 1]
            runid = attributes['runid']
            executionDate = attributes['execution-date']

            self.subFile = attributes['xfile']
            self.currentTestSuite = TestSuite(currentName, executionDate, runid)

            if self.inTopReport == 1:
              topSuite = TestSuite(runid, executionDate)
              self.testSuite = topSuite
            else:
                self.testSuite = self.currentTestSuite

        elif tag == "testset":
            currentName = attributes['name']
            self.currentTestSet = TestSuite(currentName)
            self.openTestSets.append(self.currentTestSet)

        elif tag == "testcase":
            currentName = attributes['name']
            currentResult = attributes['vstate']
            self.currentTestCase = TestCase(currentName, currentResult)

    def unknown_endtag(self, tag):
        self.currentTag = tag
        if tag == "test-suite":
            if self.inTopReport == 1:
                subReportfile = self.subFile
                dir = dirname(self.reportFile)
                if dir:
                    subReportfile = join(dir, subReportfile)
                xmlReportFile = ReportParser(self.currentTestSuite)
                xmlReportFile.load(subReportfile)
                allTests = xmlReportFile.getTestsuite()
                if not self.allTestSuites.has_key(self.testSuite.getName()):
                    self.testSuite.addTestSet(allTests)
                    self.allTestSuites[self.testSuite.getName()] = self.testSuite
                else:
                    self.allTestSuites[self.testSuite.getName()].addTestSet(allTests)
            else:
                self.testSuite = self.currentTestSuite

            self.currentTestSuite = None

        elif tag == "testset":
            if(len(self.openTestSets) == 1):
                self.currentTestSuite.addTestSet(self.currentTestSet)
                self.openTestSets = []
                self.currentTestSet = None
            else:
                thisTestSet = self.openTestSets.pop() #remove current test set from stack
                thisTestSet = self.openTestSets[len(self.openTestSets) - 1]
                thisTestSet.addTestSet(self.currentTestSet)
                self.currentTestSet = thisTestSet

        elif tag == "testcase":
            if self.currentTestSet != None:
                self.currentTestSet.addTestCase(self.currentTestCase)
            else:
                self.currentTestSuite.addTestCase(self.currentTestCase)
            self.currentTestCase = None

    def getTestsuite(self):
        return self.testSuite

    def getAllTestsuites(self):
        return self.allTestSuites

class TestLinkDBIntegrator:
    #constructor
    def __init__(self):
        self.dbconnectionstring = ""
        self.dbuser = ""
        self.dbpass = ""
        self.dbclass = ""
        self.logmode = 0 #1 ... debug, 0 ... normal

    def getDBClass(self):
        return self.dbclass

    def getDBConnectionString(self):
        return self.dbconnectionstring

    def getDBUser(self):
        return self.dbuser

    def getDBPass(self):
        return self.dbpass

    def setDBInfo(self, dbClass, connectionString, dbUser, dbPass):
        self.dbconnectionstring = connectionString
        self.dbuser = dbUser
        self.dbpass = dbPass
        self.dbclass = dbClass
    #

    def setLogmode(self, logmode):
        self.logmode = logmode
    #

    def getLogmode(self):
        return self.logmode
    #

    #used for logging
    def log(self, msg):
        if self.getLogmode() == 1:
            print msg
    #

    #executes a given select statement and return the first result-row
    def readFromDB(self, stmt, errorPart=None):
        try:
            self.log("Read from db -> " + stmt)
            self.cursor.execute (stmt)
            value = self.cursor.fetchone()[0]
            return value

        except Exception, err:
            if errorPart != None:
                errorMessage = "An error occured during: " + errorPart + " -&gt; " + str(err)
                print errorMessage
    #

    #executes a given select statement and return the first result-row but all columns
    def readFromDBMultipleCols(self, stmt, errorPart=None):
        try:
            self.log("Read from db -> " + stmt)
            self.cursor.execute (stmt)
            return self.cursor.fetchone()

        except Exception, err:
            if errorPart != None:
                errorMessage = "An error occured during: " + errorPart + " -&gt; " + str(err)
                print errorMessage
    #    

    #print an error message and leaves the program
    def exitWithMessage(self, msg):
        print msg
        sys.exit(1)
    #

    def doUpload(self, tests, testproject, testplan, tester, platformName):
        #db connection
        self.db = zxJDBC.connect(self.getDBConnectionString(), self.getDBUser(), self.getDBPass(), self.getDBClass())
        self.cursor = self.db.cursor()

        #look for required node types
        self.projectTypeID = self.readFromDB("select id from node_types where description='testproject';", "reading testproject type ID")
        self.testcaseTypeID = self.readFromDB("select id from node_types where description='testcase';", "reading testcase type ID")
        self.testplanTypeID = self.readFromDB("select id from node_types where description='testplan';", "reading testplan type ID")
        self.testsuiteTypeID = self.readFromDB("select id from node_types where description='testsuite';", "reading testsuite type ID")
        self.tcversionTypeID = self.readFromDB("select id from node_types where description='testcase_version';", "reading tcversion type ID")
        self.tcplanTCVersionTypeID =  self.readFromDB("select id from assignment_types where fk_table='testplan_tcversions';", "reading assignment type ID for testplan and test version")

       #look for project
        projectID = self.readFromDB("select id from nodes_hierarchy where node_type_id='" + str(self.projectTypeID) + "' and name ='"+ testproject +"';", "reading given project")
        if projectID == None:
            self.exitWithMessage("Couldn't find given project  '" + project + "'!")

        #look for testplan
        testplanID = self.readFromDB("select id from nodes_hierarchy where node_type_id='" + str(self.testplanTypeID) + "' and name ='" + testplan + "' and parent_id='" + str(projectID) + "';", "reading given testplan")
        if testplanID == None:
            self.exitWithMessage("Couldn't find given testplan  '" + testplan + "'!")

        #look for specified tester
        testerID = self.readFromDB("select id from users where login='" + str(tester) + "';", "reading given tester")
        if testerID == None:
            self.exitWithMessage("Couldn't find given tester  '" + tester + "'!")

        runids = tests.keys()
        for rid in runids:
            thisTestSuite = tests[rid]
            thisBuild = thisTestSuite.getName()
            buildID = self.insertBuild(testplanID, thisBuild)

            self.createResults(thisTestSuite, projectID, buildID, thisTestSuite.getExecutionDate(), testerID, testplanID, platformName)

    #

    #create tests in db
    def createResults(self, testSuite, parentID, buildID, executionDate, testerID, testplanID, platformName):
        testsets = testSuite.getTestSets()
        for ts in testsets:
            #tsName = self.getCleanName(ts.getName())
            idparts = ts.getName().split(":")
            testsuiteID = idparts[0]
            #look for test-suite
            #testsuiteID = self.readFromDB("select id from nodes_hierarchy where parent_id='" + str(parentID) + "' and name ='"+ tsName +"';")
            self.createResults(ts, testsuiteID, buildID, executionDate, testerID, testplanID, platformName)

        testcases = testSuite.getTestCases()
        for tc in testcases:
            #tcName = self.getCleanName(tc.getName())  
            idparts = tc.getName().split(":") # extract id, e.g. q-22
            woparts = idparts[0].split("-") # extract number
            if len(woparts) > 1:
                testcaseID = woparts[1]
            else:
                testcaseID = woparts[0]

            testplanData = self.readFromDBMultipleCols("select id,tcversion_id from testplan_tcversions where testplan_id='" + str(testplanID) + "' and tcversion_id in (select id from tcversions where tc_external_id='"  + str(testcaseID) + "');")
            tptvID = -1
            tcversionID = -1
            
            if testplanData != None:
                tptvID = testplanData[0]
                tcversionID = testplanData[1]

            if tcversionID == -1 or tptvID == -1:
                self.log("No relation between test-case and testplan found, so create a new one with latest version assignment.")
                tcversionID = self.readFromDB("select max(id) from tcversions where tc_external_id='" + str(testcaseID)+"';")# + "' and node_type_id='"+ str(self.tcversionTypeID) +"';")
                if tcversionID == None:
                    print "Couldn't find test-case version in database!\n"
                    print "Possible reason(s):\n"
                    print "No ID used in test-case names.\n"
                    print "Wrong ID used in test-case names.\n"
                    sys.exit(1)


                #get tsetplan-tcversion relationship
                tptvID = self.readFromDB("select id from testplan_tcversions where " + \
                                "testplan_id='" + str(testplanID) + "' " + \
                                "and tcversion_id='" + str(tcversionID) + "';")
                if tptvID == None:
                    insertStmt = "insert into testplan_tcversions(testplan_id,tcversion_id) values (" + \
                             "" + str(testplanID) + "," + \
                             "" + str(tcversionID) + "" + \
                             ");"
                    self.log("Insert testplan-tcversion connection " + insertStmt)
                    self.cursor.execute (insertStmt)
                    self.db.commit()

                    tptvID = self.readFromDB("select id from testplan_tcversions where " + \
                                    "testplan_id='" + str(testplanID) + "' " + \
                                    "and tcversion_id='" + str(tcversionID) + "';")

            #read tcversionnumber as well, as it's been introducted to execution table
            tcversionnumber = self.readFromDB("select version from tcversions where id='" + str(tcversionID)+"';")
            
            ######################################################
            platformId = 0
            if platformName != None:
                platformId= self.readFromDB("select id from platforms where name='" + str(platformName)+"';")
                if platformId == None:
                    print "Platform '", platformName, "' doesn't exist."
                    sys.exit(1)

            #####################################################
            res = int(tc.getResult())
            currentResult = 'f'
            if res <= 1:
                currentResult = 'p'

            if platformId == 0:
                executionID = self.readFromDB("select id from executions where " + \
                                "build_id='" + str(buildID) + "' and " + \
                                "tester_id='" + str(testerID) + "' and " + \
                                "testplan_id='" + str(testplanID) + "' " + \
                                "and tcversion_id='" + str(tcversionID) + "';")
            else:
                executionID = self.readFromDB("select id from executions where " + \
                                "build_id='" + str(buildID) + "' and " + \
                                "tester_id='" + str(testerID) + "' and " + \
                                "testplan_id='" + str(testplanID) + "' and " + \
                                "platform_id='" + str(platformId) + "' " + \
                                "and tcversion_id='" + str(tcversionID) + "';")

            if executionID == None:
                #insert result into executions
                insertStmt = "insert into executions(build_id,tester_id,status,testplan_id,tcversion_id,execution_ts,tcversion_number,platform_id) values (" + \
                             "" + str(buildID) + "," + \
                             "" + str(testerID) + "," + \
                             "'" + str(currentResult) + "'," + \
                             "" + str(testplanID) + "," + \
                             "" + str(tcversionID) + "," + \
                             "'" + str(executionDate) + "'," + \
                             "'" + str(tcversionnumber) + "'," + \
                             "'" + str(platformId) + "'" + ");"

                self.log("Insert execution " + insertStmt)
                self.cursor.execute (insertStmt)
                self.db.commit()
            else:
                updateStmt = "update executions set status='" + str(currentResult) + "'" + \
                ", execution_ts='" + str(executionDate) + "',tester_id='" + str(testerID) + "',tcversion_id='" + str(tcversionID) +  "',tcversion_number='" + str(tcversionnumber) +"' where id = '" + str(executionID) + "';"
                self.log("Update execution " + updateStmt)
                self.cursor.execute(updateStmt)
                self.db.commit()

            assignmentID = self.readFromDB("select id from user_assignments where " + \
                                "type='" + str(1) + "' " + \
                                "and status='" + str(1) + "' " + \
                                "and feature_id='" + str(tptvID) + "';")

            if assignmentID == None:
                insertStmt = "insert into user_assignments(type,feature_id,user_id,assigner_id,status) values (" + \
                             "'" + str(1) + "'," + \
                             "'" + str(tptvID) + "'," + \
                             "'" + str(1) + "'," + \
                             "'" + str(1) + "'," + \
                             "'" + str(1)+ "');"
                
                self.log("User assignment  " + insertStmt)
                self.cursor.execute (insertStmt)
                self.db.commit()
            else:
                self.log("User assignment exists already!")
                
        #
    #

    def getCleanName(self, name):
        if name != None:
            name = name[:99]
            name = name.replace("'", "_")
        return name

    #

    def insertBuild(self, testplanID, thisBuild):
        buildID = self.readFromDB("select id from builds where name='"+ thisBuild +"' and testplan_id ='" + str(testplanID) +"';")
        if buildID == None:
            insertStmt = "insert into builds(testplan_id, name, notes, active, is_open) values (" + \
                         "'" + str(testplanID).strip() + "'," + \
                         "'" + str(thisBuild) + "'," + \
                         "'" + "automatically generated by QF-Test" + "', " + \
                         str(1) + ", " + str(1) + \
                         ");"
            self.log("Insert build with: " + insertStmt)
            self.cursor.execute (insertStmt)
            self.db.commit()
            buildID = self.readFromDB("select id from builds where name='"+ thisBuild +"' and testplan_id ='" + str(testplanID) +"';", "reading build ID after insert")
        return buildID
    #

#print usage information
def usageExit(msg):
    print "\n" + msg
    print "\nUsage of script for uploading results:"
    print "\t--testproject <project> --resultfile <xml-report-file-to-import> --testplan <plan> --tester <tester> [-platform <platform>] [-v|--verbose]"
    print "Take care to put the JDBC driver to the CLASSPATH!"
    sys.exit(2)
#

#parse the command line
def parseArgs(argv):
    parameters = {}

    try:
        options, args = getopt.getopt(argv[1:], 'hv',
                                          ['help','testplan=','testproject=','resultfile=','tester=','platform=','verbose'])
        for opt, value in options:
            if opt in ('-h','-H','--help'):
                usageExit("Help:\n")
            if opt == '--testproject':
                parameters['testproject'] = str(value)
            if opt == '--testplan':
                parameters ['testplan'] = str(value)
            if opt == '--resultfile':
                parameters ['resultfile'] = str(value)
            if opt == '--tester':
                parameters ['tester'] = str(value)
            if opt == '--platform':
                parameters ['platform'] = str(value)                
            if opt == '--verbose' or opt == '-v':
                parameters['verbose'] = 1

    except getopt.error, msg:
        usageExit(str(msg))

    return parameters
#

#main
sys.setdefaultencoding("latin-1")
params = parseArgs(sys.argv)

if not (params.has_key('testproject') and params.has_key('testplan') and params.has_key('tester') and params.has_key('resultfile')):
        usageExit("Mandatory input parameter missing!")

xmlReportFile = ReportParser(inTopReport = 1)
xmlReportFile.load(params['resultfile'])

tests = xmlReportFile.getAllTestsuites()

tl = TestLinkDBIntegrator()

if params.has_key('verbose'):
    tl.setLogmode(1)

thePlatform = None
if params.has_key('platform'):
    thePlatform = params['platform']
    
tl.setDBInfo(dbdriver, connectionstr, dbuser, dbpass)
tl.doUpload(tests, params['testproject'], params['testplan'], params['tester'], thePlatform)

