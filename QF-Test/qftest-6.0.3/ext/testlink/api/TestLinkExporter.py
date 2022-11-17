import sys, getopt
import TestLinkClient
import TestLinkUserSpecifics
import codecs
import traceback

from java.lang import String

TESTCASE_ID_FULL = 3
TESTCASE_ID_ID = 1
TESTCASE_ID_NAME = 2
encoding = "iso-8859-1"

#Suite for writing pretty QFT files
class TestsuiteWriter:
    
    def __init__(self, suitefile, client, projectid, settestcaseid):
        self.suitefile = suitefile
        self.suitehandle = None
        self.client = client
        self.projectid = projectid
        self.settestcaseid = settestcaseid

    def open(self):
        self.suitehandle = codecs.open(self.suitefile, 'w', encoding)

    def write(self, text):
        self.suitehandle.write(text)
         
    def writeheader(self):
        #write header of test-suite
        self.write("<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n")
        self.write("<!DOCTYPE RootStep>\n")
        self.write("<RootStep id=\"_0\" name=\"root\" version=\"3.5.1\">\n")
        self.write("<include>qfs.qft</include>\n")

    def writefooter(self):
        #write end of test-suite
        self.write("<PackageRoot id=\"_4\"/>\n")
        self.write("<ExtraSequence id=\"_5\"/>\n")
        self.write("<WindowList id=\"_6\"/>\n")
        self.write("</RootStep>")
        
    def close(self):
        if self.suitehandle != None:
            self.suitehandle.close()

    def getCleanName(self, name, isComment=0, isHtmlCode=False):
        newName = String(name)

        if not isHtmlCode:
            newName = String(newName).replaceAll("&", "&amp;")
                
        if isComment == 0:
                newName = newName.replace(".", "_")
                newName = newName.replace(";", "_")
                
        newName = String(newName).replaceAll("&quot_", "&quot;")
        newName = String(newName).replaceAll("&amp_", "&amp;")
        newName = String(newName).replaceAll("&gt_", "&gt;")
        newName = String(newName).replaceAll("&lt_", "&lt;")
        newName = String(newName).replaceAll("<p>", "")
        newName = String(newName).replaceAll("<strong>", "")
        newName = String(newName).replaceAll("</strong>", "")
        newName = String(newName).replaceAll("<br />", "\r\n")
        newName = String(newName).replaceAll("</p>", "\r\n")
        
        newName = String(newName).replaceAll("<", "&lt;")
        newName = String(newName).replaceAll(">", "&gt;")
        
        mIdx = newName.find("<meta")
        if mIdx != -1:
            newName = newName[0:mIdx]

        newName = String(newName).replaceAll("&euro;", "&#8364;")
        newName = String(newName).replaceAll("\"", "&#34;")

        newName = newName.encode(encoding, 'xmlcharrefreplace')
        return String(newName).trim()
    #        
    
    def writeTestCase(self, tc):
        log("writeTestCase: Write : " + str(tc))

        tcname = tc["name"]
        print "Write test-case", tcname.encode(encoding, 'xmlcharrefreplace')
        tcid = tc["external_id"]
        tcversion = tc['version']

        comment = ""
        if tc.has_key("summary"):
            comment = tc["summary"] + "\n"
            
        if TestLinkUserSpecifics.custom_fields:
            for cm in TestLinkUserSpecifics.custom_fields:
                ret = self.client.getCustomFieldValue(self.projectid, tcid, tcversion, cm)
                if ret:
                    comment += cm + " : " + ret + "\n"
            
        self.write("<TestCase name =\"" + str(tcid) + ": " + self.getCleanName(tcname)+ "\"")
        if self.settestcaseid == TESTCASE_ID_FULL:
            self.write(" id =\"" + str(tcid) + ": " + self.getCleanName(tcname) + "\"")
        elif self.settestcaseid == TESTCASE_ID_ID:
            self.write(" id =\"" + str(tcid) + "\"")
        elif self.settestcaseid == TESTCASE_ID_NAME:
            self.write(" id =\"" + self.getCleanName(tcname) + "\"")            

        self.write(">\n")

        self.write("<comment>")
        self.write(self.getCleanName(comment, 1))
        self.write("</comment>")
        self.goThroughTestSteps(tc)
        self.write("</TestCase>\n")
        
        print "writeTestCase: Done."
    #

    def goThroughTestSteps(self, testcase):
        log("goThroughTestSteps: Start with " + str(testcase))
        
        steps = testcase["steps"]
        if len(steps) == 0:
            log("goThroughTestSteps: No test-steps.")
            return

        for step in steps:
            print "goThroughTestSteps: Write step: " + str(step)
            actions = step["actions"]
            expresults = step["expected_results"]
            stepnumber = step["step_number"]

            allActions = self.getCleanName(actions)
            parts = allActions.split("\n")
            simpleName = parts[0]
            
            self.write("<TestStep name=\"" + str(stepnumber) + ": " + simpleName + "\">\n")
            self.write("<comment>")
            self.write("Actions:\n")
            self.write(self.getCleanName(allActions, 1))
            self.write("\nExpected result:\n")
            self.write(self.getCleanName(expresults, 1))                      
            self.write("</comment>")
            self.write("</TestStep>\n")

        print "goThroughTestSteps: Done."
    #
        
    def getTestSuitesAsHash(self, suites):
        log("getTestSuitesAsHash: Start for " + str(suites))
                    
        if suites == None or len(suites) == 0:
            log("getTestSuitesAsHash: No child-suites found.")
            return

        retHash = {}
        if suites.has_key('node_order'):
            retHash[suites['node_order']] = suites
        else:
            for suiteId in suites:
                retHash[suites[suiteId]['node_order'] + "_" + suiteId] = suites[suiteId]

        return retHash
    #

    def goThroughTestSuites(self, suites, testsuite=None):
        log("goThroughTestSuites: " + str(suites))
        
        if len(suites) == 0:
            print "goThroughTestSuites: No Testsuites found."
            return

        for suite in suites:
            log("goThroughTestSuites: For suite: " + str(suite))
            suitename = suite["name"]
            typeid = suite["node_type_id"]
            suiteid = suite["id"]
            iter_testsuite = testsuite
            
            if iter_testsuite != None:
                suiteparts = iter_testsuite.split("/")

                if suitename != suiteparts[0]:
                    log("goThroughTestSuites: Suitename not ok, next. Should be " + suiteparts[0])
                    continue

                if len(suiteparts) > 1:
                    iter_testsuite = "/".join(suiteparts[1:])
                else:
                    iter_testsuite = None
                    
            print "goThroughTestSuites: Write suite...", suitename.encode(encoding, 'xmlcharrefreplace')
            
            self.write("<TestSet name =\"" + self.getCleanName(suitename) + "\">\n")

            try:
                #read all testsuites and testcases into hash to be able to
                #write the elements in the same order as defined in TestLink
                orderHash = {}
                testsuites = client.getTestSuitesForTestSuite(suiteid)
                if testsuites and len(testsuites) > 0:
                    orderHash = self.getTestSuitesAsHash(testsuites)

                testcases = client.getTestCasesForTestSuite(suiteid)
                testcaseOrder = []

                if orderHash != None:
                    for key in orderHash.keys():
                        testcaseOrder.append(key)
                        
                if testcases and len(testcases) > 0:
                    for tc in testcases:
                        #get testcases return all child testcases, even testcases
                        #which are a child of a child test-suite, to filter it
                        parentid = tc["parent_id"]
                        if parentid != suiteid:
                            continue
                        key = tc['node_order'] + "-" + tc['external_id']
                        orderHash[key] = tc
                        testcaseOrder.append(key)
                    
                #write in the same order as defined in TestLink
                if testcaseOrder != None:
                    for key in testcaseOrder:
                        element = orderHash[key]

                        #write testcase
                        if element['node_type_id'] == '3':
                            if iter_testsuite == None:
                                self.writeTestCase(element)

                        #write testsuite
                        elif element['node_type_id'] == '2':
                            self.goThroughTestSuites([element], iter_testsuite)
            
            except Exception, err:
                print "Exception during writing testsuite.", str(err)
                traceback.print_exc()

            self.write("</TestSet>\n")
            print "goThroughTestSuites: Done."
        #
#

#print usage information
def usageExit(msg):
    print "\n" + msg
    print "Usage of script for exporting a project:"
    print "\t--testproject <project> --targetsuite <testsuite-to-create> [--testsuite <testsuite-to-export>] [--set-testcase-id <testcase-id-mode>] [--encoding <encoding>] [-v|--verbose]"
    print "\tIf you want to export a sub-test-suite, you can use testsuite/testsuite2."
    print "\tThe parameter testcase-id-mode can be set to 'full', 'id' or 'name'."
    print "\tThe default encoding is " + encoding + ". That's also the default of QF-Test itself."
    print "Take care to set the right API key in TestLinkUserSpecifics.py!\n"
    sys.exit(2)
#

#parse the command line
def parseArgs(argv):
    parameters = {}
    
    try:
        options, args = getopt.getopt(argv[1:], 'hv',
                                          ['help','testplan=','testproject=','targetsuite=','testsuite=','verbose','set-testcase-id=','encoding='])
        for opt, value in options:    
            if opt in ('-h','-H','--help'):
                usageExit("Help:\n")
            if opt == '--testproject':
                parameters['testproject'] = value
            if opt == '--testplan':
                parameters ['testplan'] = value
            if opt == '--targetsuite':
                parameters ['targetsuite'] = value
            if opt == '--testsuite':
                parameters ['testsuite'] = value
            if opt == '--encoding':
                parameters ['encoding'] = value
            if opt == '--verbose' or opt == '-v':
                parameters['verbose'] = 1
            if opt == '--set-testcase-id':
                parameters['set-testcase-id'] = value             
                
                
    except getopt.error, msg:
        usageExit(str(msg))

    return parameters  

def log(msg):
    if verbose == 1:
        print msg

global verbose

#main
params = parseArgs(sys.argv)

verbose = 0  
if params.has_key('verbose'):
    verbose = 1
    
if params.has_key('encoding'):
    encoding = params['encoding']
    log("Encoding changed to: " + encoding)
else:
    log("Use default encoding: " + encoding)
    
if not (params.has_key('testproject') and params.has_key('targetsuite')):
    usageExit("Mandatory input parameter missing!")

if not params.has_key('testsuite'):
    params['testsuite'] = None
    
print "Check API of TestLink for testproject: " + params['testproject'].encode(encoding, 'xmlcharrefreplace')
client = TestLinkClient.TestLinkAPIClient(verbose)
projectData = client.getTestProjectByName(params['testproject'])

#difference between testlink 1.9.4 and 1.9.7
try:
    if projectData[0].has_key("code"):
        print projectData[0]["message"].encode(encoding, 'xmlcharrefreplace')
        sys.exit(1)
except:
    pass #ok, valid project
    
print "Begin export, ..."

pid = -1

#difference between testlink 1.9.4 and 1.9.7
try:
    if projectData.has_key('id'):
        pid = projectData['id']
    else:
        pid = projectData[0]['id']
except:
    try:
        pid = projectData[0]['id']
    except:
        pass
    

if pid == -1:
    print "Can't detect project id, please specify existing project. If project exists, perhaps TestLink developers changed the API."
    sys.exit(1)

print "Go ahead with project-id:", pid
setTestCaseId = 0
if params.has_key('set-testcase-id'):
    value = params.get('set-testcase-id')
    if value:
        if value.lower() == "full":
            setTestCaseId = TESTCASE_ID_FULL
        elif value.lower() == "name":
            setTestCaseId = TESTCASE_ID_NAME
        elif value.lower() == "id":
            setTestCaseId = TESTCASE_ID_ID
        else:
            usageExit("Wrong testcase-id-mode set. Please use either 'full', 'name' or 'id'.\n")            
    else:
        usageExit("Wrong testcase-id-mode set. Please use either 'full', 'name' or 'id'.\n")
    
suites = client.getFirstLevelTestSuitesForTestProject(pid)
suiteWriter = TestsuiteWriter(params['targetsuite'], client, pid, setTestCaseId)

try:
    suiteWriter.open()
    suiteWriter.writeheader()

    suiteWriter.goThroughTestSuites(suites, params['testsuite'])

    suiteWriter.writefooter()
except Exception, err:
    print "Exception during writing file:", str(err)
    traceback.print_exc()
finally:    
    suiteWriter.close()

print "... export completed!"
    
sys.exit(0)
