import xml.sax
from os.path import dirname, join
import sys, getopt
import TestLinkClient
import traceback
from java.lang import String

encoding = "iso-8859-1"

class TestCase:
    def __init__(self, name, result, implemented, tcid):
        self.name = name
        self.result = result
        self.implemented = implemented
        self.tcid = tcid

    def getResult(self):
        return self.result

    def getName(self):
        return self.name

    def getImplemented(self):
        return self.implemented

    def getId(self):
        return self.tcid

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

class ReportParser(xml.sax.ContentHandler):

    def __init__(self, testSuite=None, inTopReport = 0):
        log("Initialize XML Parser")
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
        log("XML Parser loads reportFile: " + reportFile)
        self.reportFile = reportFile
        
        parser = xml.sax.make_parser()
        #Namespaces are not required for QF-Test XML reports
        parser.setFeature(xml.sax.handler.feature_namespaces, 0)
        parser.setContentHandler(self)
   
        parser.parse(reportFile)

    def startElement(self, tag, attributes):
        self.currentTag = tag
        if tag == "test-suite":
            name = attributes['name']
            log("Parse test-suite: " + name)
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
            if attributes.has_key('skipped'):
                currentResult = -1
            else:
                currentResult = attributes['vstate']
            currentImplemented = attributes['implemented']
            try:
                currentTCId = attributes['nodeid']
            except:
                currentTCId = None
            self.currentTestCase = TestCase(currentName, currentResult, currentImplemented, currentTCId)
    
    def endElement(self, tag):
        self.currentTag = tag
        if tag == "test-suite":
            if self.inTopReport == 1:
                subReportfile = self.subFile
                dir = dirname(self.reportFile)
                if dir:
                    subReportfile = join(dir, subReportfile)

                log("Parse sub-report file: " + subReportfile)
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

    def characters(self, content):
        pass

    def getTestsuite(self):
        return self.testSuite

    def getAllTestsuites(self):
        return self.allTestSuites

#

#print usage information
def usageExit(msg):
    print "\n" + msg
    print "\nUsage of script for uploading results:"
    print "\t--testproject <project> --resultfile <xml-report-file-to-import> --testplan <plan> [--platform <platform>] [--build <buildname>] [--ignoretestcaseid <testcaseid>] [--usetestcaseid] [-v|--verbose]"
    print "Take care to set the right API key in TestLinkUserSpecifics.py!"
    sys.exit(2)
#

#parse the command line
def parseArgs(argv):
    parameters = {}

    try:
        options, args = getopt.getopt(argv[1:], 'hv',
                                          ['help','testplan=','testproject=','resultfile=','platform=','build=','ignoretestcaseid=','verbose','usetestcaseid'])
        for opt, value in options:
            if opt in ('-h','-H','--help'):
                usageExit("Help:\n")
            if opt == '--testproject':
                parameters['testproject'] = value
            if opt == '--testplan':
                parameters ['testplan'] = value
            if opt == '--resultfile':
                parameters ['resultfile'] = value
            if opt == '--platform':
                parameters ['platform'] = value
            if opt == '--build':
                parameters ['build'] = value
            if opt == '--ignoretestcaseid':
                parameters ['ignoretestcaseid'] = value
            if opt == '--usetestcaseid':
                parameters ['usetestcaseid'] = True
            if opt == '--verbose' or opt == '-v':
                parameters['verbose'] = 1

    except getopt.error, msg:
        usageExit(str(msg))

    return parameters
#

def log(msg):
    if verbose == 1:
        print msg
#

class ResultImporter:
    def __init__(self, client):
        self.client = client

    #

    def maybeCreateBuild(self):
        buildId = -1
        existingBuilds = self.client.getBuildsForTestPlan(self.testplanId)

        if existingBuilds:
            #search for right build name
            log("Check for existence of " + self.thisBuild.encode(encoding, 'xmlcharrefreplace') + " in database.")
            buildId = -1
            for bs in existingBuilds:
                theBuildName = bs['name']
                if theBuildName == self.thisBuild:
                    buildId = bs['id']
                    print "Build with name " + self.thisBuild.encode(encoding, 'xmlcharrefreplace') + " found."
                    break

        #no build found
        if buildId == -1:
            print "Build " + self.thisBuild.encode(encoding, 'xmlcharrefreplace') + " not found, create new one."
            result = self.client.createBuild(self.testplanId, self.thisBuild, "Created by QF-Test")
            if self.wasCreatingBuildSuccessuful(result):
                print "Build couldn't be created!", result
                sys.exit(1)

            buildId = self.getBuildIfFromResult(result)

        return buildId
    #

    def getBuildIfFromResult(self, result):
        try:
            return result[0]['id']
        except:
            pass
            
        try:
            return result['id']
        except:
            pass
            
        return -1
    #
    
    def wasCreatingBuildSuccessuful(self, result):
        if not result:
            return False
            
        try:
            if bool(result[0]['status']) != True:
                return False
        except:
            pass
            
        try:
            if bool(result['status']) != True:
                return False
        except:
            pass
    #
    
    def setExecutionResult(self, tsroot):
        testsets = tsroot.getTestSets()
        for ts in testsets:
            self.setExecutionResult(ts)

        testcases = tsroot.getTestCases()
        for tc in testcases:
            readTCId = True #flag whether it's required to read tc id from name
            #that's a fallback, if QFT-id need to be used, but wasn't set

            if self.usetcid:
                log("Usetsetcaseid switch defined, use QF-Test ID attribute.")
                testcaseID = tc.getId()
                readTCId = False

            if readTCId:
                log("Get testcase id from name.")
                idparts = tc.getName().split(":") # extract id, e.g. q-22
                if len(idparts) > 1:
                    testcaseID = idparts[0]
                else:
                    testcaseID = idparts[0]


            print "Set result of testcase:", tc.getName().encode(encoding, 'xmlcharrefreplace')
            print "Test-case has id:", testcaseID
            
            if params.has_key('ignoretestcaseid') and params['ignoretestcaseid']==testcaseID:
                print "Ignore this Test-case"
                continue
            
            tcinfo = self.client.getTestCase(testcaseID)
            tcinfo = self.getCleanTcInfo(tcinfo)
            
            if not tcinfo.has_key('testcase_id'):
                print "Return value for getting test-case info: ", tcinfo['message']
                sys.exit(1)

            tcid = tcinfo['testcase_id']
            tcversion = tcinfo['version']

            log("Read testcase with id from testplan: " + tcid)
            result = self.client.getTestCasesForTestPlan(self.testplanId, tcid, self.platformid)
            tcExistsInPlan = self.checkTCExistsInTestPlan(result, tcid)
                        
            if not tcExistsInPlan:
                log("Add testcase to testplan")
                addingResult = self.client.addTestCaseToTestPlan(self.projectid, self.testplanId, testcaseID, tcversion, self.platformid)
                try:
                    if self.wasAddingSuccessful(addingResult):
                        log("Test-case successfully added to testplan.")
                    else:
                        print "Result of adding test-case to test-plan:", addingResult
                        sys.exit(1)
                except:
                    print "Adding testcase and platform to plan failed -> Already existing.", addingResult
            else:
                log("Test-case already existing.")

            if tc.getImplemented() == "true":
                res = int(tc.getResult())
                log("Set result to: " + str(res))
                if res != -1:
                    currentResult = 'f'
                    if res <= 1:
                        currentResult = 'p'

                    print "Update result now."
                    uploadResult = self.client.setTestCaseExecutionResult(tcid, currentResult, self.testplanId, self.buildId, self.platformid)

                    try:
                        print "Uploading result:", uploadResult
                    except:
                        print "Updating result with return value: ", uploadResult
                else:
                    print "Test-case was skipped!"
            else:
                print "Test-case wasn't implemented in QF-Test."
    #
    
    def getCleanTcInfo(self, tcinfo):
        try:
            return tcinfo[0]
        except:
            pass
        return tcinfo
    #
    
    def wasAddingSuccessful(self, addingResult):
        #"older" TestLink versions
        try:
            if addingResult[0]['status'] == True:
                return True
        except:
            pass
            
        #"newer" TestLink versions
        try:
            state = str(addingResult['status'])
            if bool(state):
                return True
        except:
            pass
            
        return False
    #
    
    def checkTCExistsInTestPlan(self, results, tcid):
        tcExistsInPlan = True
        
        #"Old" TestLink API Versions
        try:
            if not result[tcid]:
                tcExistsInPlan = False
        except:
            pass
            
        #"Newer" TestLink API Versions
        try:
            code = str(results[0]['code'])
            if code == "3030":
                tcExistsInPlan = False
        except:
            pass
            
        if not results:
            tcExistsInPlan = False

        return tcExistsInPlan 

    #
    
    def setUseTestcaseId(self, usetcid):
        self.usetcid = usetcid
    #

    def getCleanHashReturnData(self, projectData):
        try:
            return projectData[0]
        except:
            pass
        return projectData
    #
    
    def doUploadResult(self, tests, testproject, testplan, platform, build):
        print "Read project from TestLink '" + testproject.encode(encoding, 'xmlcharrefreplace') + "'"
        projectData = self.client.getTestProjectByName(testproject)
        projectData = self.getCleanHashReturnData(projectData)
        
        pid = -1

        if build:
            self.thisBuild = build

        #difference between testlink 1.9.4 and 1.9.7
        try:
            if projectData.has_key("code"):
                print projectData["message"].encode(encoding, 'xmlcharrefreplace')
        except:
            pass #ok, valid project

        #difference between testlink 1.9.4 and 1.9.7
        try:
            if projectData.has_key('id'):
                pid = projectData['id']
            else:
                pid = projectData['id']
        except:
            try:
                pid = projectData['id']
            except:
                pass

        if pid == -1:
            print "Can't detect project id, please specify existing project. If project exists, perhaps TestLink developers changed the API."
            sys.exit(1)

        self.projectid = pid

        print "Got projectId: '" + pid + "'"
        print "Read testplan from TestLink '" + testplan.encode(encoding, 'xmlcharrefreplace') + "'"
        planData = self.client.getTestPlanByName(testproject, testplan)
        planData = self.getCleanHashReturnData(planData)
        if planData.has_key("code"):
            print "TestPlan couldn't be read ->:", planData["message"].encode(encoding, 'xmlcharrefreplace')
            sys.exit(1)
            
        self.testplanId = planData['id']

        print "Got testplanId '" + self.testplanId + "'"

        self.platformid = None

        if platform:
            print "Read platforms for testplan from TestLink."
            platforminfos = self.client.getTestPlanPlatforms(self.testplanId)
            if platform and not platforminfos:
                print "Platform " + platform.encode(encoding, 'xmlcharrefreplace') + " is not assigned to test-plan."
                sys.exit(1)

            if platforminfos[0].has_key("code"):
                print platforminfos[0].get("message").encode(encoding, 'xmlcharrefreplace')
                sys.exit(1)

            if platform and platforminfos:
                for pif in platforminfos:
                    if pif['name'] == platform:
                        self.platformid = pif['id']

            if platform and not self.platformid:
                print "Platform ", platform.encode(encoding, 'xmlcharrefreplace'), " is not assigned to test-plan.", platforminfos
                sys.exit(1)
        else:
            print "No platform specified."

        print "Start uploading results..."
        runids = tests.keys()
        for rid in runids:
            print "Go for runid:" + rid
            thisTestSuite = tests[rid]
            log("Go for testsuite:" + str(thisTestSuite))
            try:
                if not self.thisBuild:
                    self.thisBuild = thisTestSuite.getName()
            except: # no build name, take the one from qft
                self.thisBuild = thisTestSuite.getName()

            self.buildId = self.maybeCreateBuild()

            print "Set result for build-id:" + str(self.buildId)
            self.setExecutionResult(thisTestSuite)
        print "... uploading done."
    #

#

global verbose

#main
params = parseArgs(sys.argv)

if not (params.has_key('testproject') and params.has_key('testplan') and params.has_key('resultfile')):
        usageExit("Mandatory input parameter missing!")

verbose = 0
if params.has_key('verbose'):
    verbose = 1
    
xmlReportFile = ReportParser(inTopReport = 1)
xmlReportFile.load(params['resultfile'])

tests = xmlReportFile.getAllTestsuites()

client = TestLinkClient.TestLinkAPIClient(verbose)

thePlatform = None
if params.has_key('platform'):
    thePlatform = params['platform']

theBuild = None
if params.has_key('build'):
    theBuild = params['build']

usetcid = False
if params.has_key('usetestcaseid'):
    usetcid = True

print "Begin import, ..."

ri = ResultImporter(client)
ri.setUseTestcaseId(usetcid)
ri.doUploadResult(tests, params['testproject'], params['testplan'], thePlatform, theBuild)

print "... import completed!"

sys.exit(0)
