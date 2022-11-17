import xmlrpclib
import TestLinkUserSpecifics
import traceback

#Wrapper for TestLinkAPI Client to call RPC methods
class TestLinkAPIClient:            
    def __init__(self, verbose):
        self.serverurl = TestLinkUserSpecifics.serverurl
        self.devKey = TestLinkUserSpecifics.devkey
        self.server = xmlrpclib.Server(TestLinkUserSpecifics.serverurl)
        self.data = {}
        self.verbose = verbose
            
    def getInfo(self):
        return self.callMethod("about")

    def getTestLinkVersion(self):
        return self.callMethod("testLinkVersion")
        
    def getTestProjectByName(self, project):
        self.addData("testprojectname", project)
        return self.callMethod("getTestProjectByName")

    def getTestPlanByName(self, project, plan):
        self.addData("testprojectname", project)        
        self.addData("testplanname", plan)
        return self.callMethod("getTestPlanByName")

    def addData(self, key, value):
        self.data[key] = value

    def resetData(self):
        self.data = {}

    def getFirstLevelTestSuitesForTestProject(self, projectid):
        self.addData("testprojectid", projectid)
        return self.callMethod("getFirstLevelTestSuitesForTestProject")

    def getTestCasesForTestSuite(self, suiteid):
        self.addData("testsuiteid", suiteid)
        self.addData("details", "full")
        self.addData("deep", "true")         
        return self.callMethod("getTestCasesForTestSuite")

    def getTestSuitesForTestSuite(self, suiteid):
        self.addData("testsuiteid", suiteid)
        self.addData("deep", "true")        
        return self.callMethod("getTestSuitesForTestSuite")

    def getTestCase(self, tcextid):
        self.addData("tcexternalid", tcextid)
        return self.callMethod("getTestCase")

    def getBuildsForTestPlan(self, testplanid):
        self.addData("testplanid", testplanid)
        return self.callMethod("getBuildsForTestPlan")

    def createBuild(self, testplanid, buildname, buildnotes):
        self.addData("testplanid", testplanid)
        self.addData("buildname", buildname)
        self.addData("buildnotes", buildnotes)
        return self.callMethod("createBuild")        

    def getTestCase(self, testcaseid):
        self.addData("testcaseexternalid", testcaseid)        
        return self.callMethod("getTestCase")

    def getCustomFieldValue(self, projectid, testcaseid, version, customfieldname):
        self.addData("testprojectid", projectid)
        self.addData("testcaseexternalid", testcaseid)
        self.addData("version", int(version))
        self.addData("customfieldname", customfieldname)
        return self.callMethod("getTestCaseCustomFieldDesignValue")
    
    def getTestCasesForTestPlan(self, testplanid, testcaseid, platformid=None):
        usePlatformParam = False        
        tlversion = self.getTestLinkVersion()
        if tlversion:
            tlversion = int(str(tlversion).replace(".", ""))
            if tlversion >= 1913:
                usePlatformParam = True
        
        self.addData("testplanid", testplanid)
        self.addData("testcaseid", testcaseid) 
        if usePlatformParam and platformid:
            self.addData("platformid", platformid)        
        return self.callMethod("getTestCasesForTestPlan")

    def getTestPlanPlatforms(self, testplanid):
        self.addData("testplanid", testplanid)       
        return self.callMethod("getTestPlanPlatforms")
    
    def addTestCaseToTestPlan(self, projectid, testplanid, testcaseid, version, platformid=None):
        self.addData("testprojectid", projectid)
        self.addData("testplanid", testplanid)
        self.addData("testcaseexternalid", testcaseid)
        self.addData("version", int(version))
        if platformid:
            self.addData("platformid", platformid)
        return self.callMethod("addTestCaseToTestPlan")    
                               
    def setTestCaseExecutionResult(self, testcaseid, status, testplanid, buildid, platformid):
        self.addData("testplanid", testplanid)
        self.addData("testcaseid", testcaseid)
        self.addData("status", status)
        self.addData("buildid", buildid)
        if platformid:
            self.addData("platformid", platformid)
            
        self.addData("overwrite", "true")
        return self.callMethod("reportTCResult")
    
    def callMethod(self, method):
        try:
            self.log("Call API method: " + method)
            self.addData("devKey", self.devKey)
            self.log("with parameters: " + str(self.data))
            retValue = eval("self.server.tl." + method + "(self.data)")
            self.log("Got return value: " + str(retValue))
            return retValue
        except Exception, err:
            print "Exception during calling method on TestLink client:", str(err)
            traceback.print_exc()
        finally:
            self.resetData()
            
    def log(self, msg):
        if self.verbose == 1:
            print msg

