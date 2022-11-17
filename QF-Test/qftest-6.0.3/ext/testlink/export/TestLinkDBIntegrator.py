# -*- coding: iso-8859-1 -*-

from com.ziclix.python.sql import zxJDBC
from java.lang import String
import getopt, sys        

#connection info for the database
#a JDBC database driver is required
#don't forget to add the .jar file to the CLASSPATH environment variable
dbdriver = "org.postgresql.Driver" #com.mysql.jdbc.Driver"
connectionstr = "jdbc:postgresql://localhost/testlink"
dbuser = "testlink"
dbpass = "testlink"

#The specified custom fields will be written into the 'Comment' attribute of the according sequence.
custom_fields = [] #['RequirementID']


#print usage information
def usageExit(msg):
    print "\n" + msg
    print "Usage of script for exporting a project:"
    print "\t--testproject <project> --targetsuite <testsuite-to-create> [--testsuite <testsuite-to-export>] [-v|--verbose]"
    print "\tIf you want to export a sub-test-suite, you can use testsuite/testsuite2."
    print "Take care to put the JDBC driver to the CLASSPATH!"
    sys.exit(2)
#

#parse the command line
def parseArgs(argv):
    parameters = {}
    
    try:
        options, args = getopt.getopt(argv[1:], 'hv',
                                          ['help','testplan=','testproject=','targetsuite=','testsuite=','verbose'])
        for opt, value in options:    
            if opt in ('-h','-H','--help'):
                usageExit("Help:\n")
            if opt == '--testproject':
                parameters['testproject'] = str(value)
            if opt == '--testplan':
                parameters ['testplan'] = str(value)
            if opt == '--targetsuite':
                parameters ['targetsuite'] = str(value)
            if opt == '--testsuite':
                parameters ['testsuite'] = str(value)               
            if opt == '--verbose' or opt == '-v':
                parameters['verbose'] = 1                   
                
    except getopt.error, msg:
        usageExit(str(msg))

    return parameters  
#

#integration
class TestLinkIntegrator:

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
    def readFromDB(self, cursor, stmt, errorPart):
        try:
            self.log("Read from db -> " + stmt)
            cursor.execute (stmt)
            value = cursor.fetchone()[0]   
            return value

        except Exception, err:
            errorMessage = "An error occured during: " + errorPart + " -&gt; " + str(err)
            print errorMessage            
    #
    
    #print an error message and leaves the program
    def exitWithMessage(self, msg):
        print msg
        sys.exit(1)
    #
    
    #looks for parent in hierarchy
    def getParentID(self, cursor, projectTypeID, testsuiteTypeID, testproject, testsuiteParts):
        parentID = ""
        parentName = testproject
        nodeTypeID = projectTypeID
        
        for i in range(len(testsuiteParts)):
            stmt = "select id, name from nodes_hierarchy where name='" + str(parentName) + "'" \
                   " and node_type_id='" + str(nodeTypeID) + "'"                   
            if parentID != "":
                stmt = stmt + " and parent_id='" + str(parentID) + "'"
                
            stmt = stmt + ";"
            
            self.log("Look for parent: " + stmt)           
            
            cursor.execute(stmt)
            parentName = str(testsuiteParts[i])
            results = cursor.fetchall()
            
            for thisResult in results:
                parentID = str(thisResult[0])
                pstate = self.verifyProject(cursor, parentID, projectTypeID)
                if pstate == "OK":
                        break                        
                
            nodeTypeID = testsuiteTypeID

        return parentID
    #
    
    def verifyProject(self, cursor, testproject, projectTypeID):
        stmt = "select active from testprojects where id='" + str(testproject) + "'";
        self.log("Verify project: " + stmt)
        cursor.execute(stmt)
        verify = cursor.fetchone()
        if verify != None:
                return "OK"
        return "KO"
    #
            
    #entry point for exporting data from testlink to qf-test
    def doExport(self, testproject, suiteFile, testsuite=None):
        db = zxJDBC.connect(self.getDBConnectionString(), self.getDBUser(), self.getDBPass(), self.getDBClass())
        cursor = db.cursor()

        projectTypeID = -1
        testsuiteTypeID = -1        
        projectID = -1
        tcversionTypeID = -1

        #look for required node types
        projectTypeID = self.readFromDB(cursor, "select id from node_types where description='testproject';", "reading testproject ID")
        testcaseTypeID = self.readFromDB(cursor, "select id from node_types where description='testcase';", "reading testcase ID")
        testsuiteTypeID = self.readFromDB(cursor, "select id from node_types where description='testsuite';", "reading testsuite ID")
        tcversionTypeID = self.readFromDB(cursor, "select id from node_types where description='testcase_version';", "reading tcversion type ID")  
        #look for project
        projectID = self.readFromDB(cursor, "select id from nodes_hierarchy where node_type_id='" + str(projectTypeID) + "' and name ='"+ testproject +"';", "reading given project")
        if projectID == None:
            self.exitWithMessage("Couldn't find given project  '" + project + "'!")

        suiteID = -1
        
        try:
            suiteFile = open(suiteFile, 'w')

            #write header of test-suite
            suiteFile.write("<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n")
            suiteFile.write("<!DOCTYPE RootStep>\n")
            suiteFile.write("<RootStep id=\"_0\" name=\"root\" version=\"3.1.3\">\n")
            suiteFile.write("<include>qfs.qft</include>\n")

            self.nodeIndex = 6

            testsuiteParts = []
            testsuiteParts.append(testsuite)
            
            if testsuite != None:
                testsuiteParts = testsuite.split("/")                
                testsuite = testsuiteParts[len(testsuiteParts)-1]                
            
            testSuiteParentID = self.getParentID(cursor, projectTypeID, testsuiteTypeID, testproject, testsuiteParts)

            #look for test-suite
            if testsuite != None:
                try:
                    stmt = "select id, parent_id from nodes_hierarchy " + \
                   "where name='" + str(testsuite) + "' " + \
                   "and node_type_id='" + str(testsuiteTypeID) + "' and " + \
                   "parent_id = '" + str(testSuiteParentID) + "';"
                    self.log("Read ID of testsuite: " + stmt)                                        
                    cursor.execute (stmt)
                    results = cursor.fetchall()
                    
                    for r in results:
                        suiteID = r[0]                                                              
                    
                    if suiteID == -1:
                        print "Couldn't find test-suite for given suite!"
                        return -1
                    else:
                        self.goThroughSuites(cursor, testsuiteTypeID, testcaseTypeID, tcversionTypeID, suiteID, suiteFile)
                        
                except Exception, err:
                    print "Error during looking for given suite : " + str(err)
                    return -1                                                           
            else:
                self.goThroughSuites(cursor, testsuiteTypeID, testcaseTypeID, tcversionTypeID, projectID, suiteFile)                

            #write end of test-suite
            suiteFile.write("<PackageRoot id=\"_4\"/>\n")
            suiteFile.write("<ExtraSequence id=\"_5\"/>\n")
            suiteFile.write("<WindowList id=\"_6\"/>\n")
            suiteFile.write("</RootStep>")
            
        finally:
            try:
                suiteFile.close()
            except:
                self.log("Couldn't close suitefile.")
            try:
                cursor.close()
            except:
                self.log("Couldn't close db cursor.")
            try:
                db.close()
            except:
                self.log("Couldn't close db connection.")
    #

    #write single test-cases or test-sets        
    def goThroughSuites(self, cursor, testsuiteTypeID, testcaseTypeID, tcversionTypeID, parentID, suiteFile):
        try:
            stmt = "select id, node_type_id, name from nodes_hierarchy " + \
                    "where parent_id='" + str(parentID) + "' " + \
                    "and (node_type_id='" + str(testcaseTypeID) + "' " + \
                    "or node_type_id='" + str(testsuiteTypeID) + "');"
            self.log("Read ID of testsuite or testcase: " + stmt)

            cursor.execute (stmt)
            results = cursor.fetchall()

            if results == None:
                self.log("No test-cases for suite with id '" + str(parentID) + "'!")
            else:                
                for r in results:                    
                    self.nodeIndex = self.nodeIndex + 1
                    if r[1] == testcaseTypeID:
                        internalId = int(r[0]) + 1
                        ext_tcversionID = self.readFromDB(cursor, "select max(tc_external_id) from tcversions where id='" + str(internalId) + "';", " reading external tc id")
                        suiteFile.write("<TestCase id=\"_" + str(self.nodeIndex) + "\" name =\"" + str(ext_tcversionID) + ": " + self.getCleanName(str(r[2])) +"\">\n")               
                        self.readSteps(cursor, tcversionTypeID, r[0], suiteFile)
                        suiteFile.write("</TestCase>\n")                    
                    elif r[1] == testsuiteTypeID:
                        suiteFile.write("<TestSet id=\"_" + str(self.nodeIndex) + "\" name =\"" + self.getCleanName(str(r[2])) + "\">\n")
                        self.goThroughSuites(cursor, testsuiteTypeID, testcaseTypeID, tcversionTypeID, str(r[0]), suiteFile)
                        suiteFile.write("</TestSet>\n")
        except Exception, err:
            print "Exception during reading information and writing targetfile: ", str(err)
    #

    #read comment from tcversions and write it to test-case
    def writeComment(self, cursor, tcVersionID, realTestCaseID, suiteFile):

        suiteFile.write("<comment>")
        
        try:            
            stmt = "select summary from tcversions " + \
                    "where id='" + str(tcVersionID) + "';"
                    
            self.log("Read summary testcase: " + stmt)

            cursor.execute (stmt)

            r = cursor.fetchone()
            if r[0] != None:
                if r[0] != "":
                    comment = self.getCleanName(r[0], 1)
                    suiteFile.write(comment + "\n")
                    
            where = ""

            if len(custom_fields) > 0:
                for f in custom_fields:
                    if where != "":
                        where = where + " or "
                    where = where + "name='" + f + "'"
            
                #field ids lesen            
                stmt = "select id from custom_fields where " + where + ";"
                self.log("Read design values; " + stmt)
                                            
                cursor.execute(stmt)
                lists = cursor.fetchall()
                for li in range(len(lists)):        
                    stmt = "select value from cfield_design_values where node_id='" + \
                           str(realTestCaseID) + "' and field_id=' " + str(lists[li][0]) + "';"
                    self.log("Read design values; " + stmt)
           
                    cursor.execute(stmt)
           
                    for r in cursor.fetchall():
                        suiteFile.write(custom_fields[li] + " : " + r[0] + "\n")
                                           
        except Exception, err:
            print "Exception during reading summary: ", str(err)
            
        suiteFile.write("</comment>")
    #

    
    #walk through all steps and write them as sequences into a test-case
    def readSteps(self, cursor, tcversionTypeID, parentID, suiteFile):
        try:
            dbversion = self.getDBVersion(cursor)
            if dbversion >= 13:
                stmt = "select id from node_types where description='testcase_step';"                                   
            
                self.log("Look for teststep-id: " + stmt)           
            
                cursor.execute(stmt)
                result = cursor.fetchone()                                
                teststepId = result[0]                

                stmt = "select id from nodes_hierarchy " + \
                    "where parent_id='" + str(parentID) + "' " + \
                    "and (node_type_id='" + str(tcversionTypeID) + "');"
                    
                self.log("Read stepparent of testcase: " + stmt)

                cursor.execute (stmt)               
                result = max(cursor.fetchall())                
                stepParentId = result[0]
                
                stmt = "select id from nodes_hierarchy " + \
                    "where parent_id='" + str(stepParentId) + "' " + \
                    "and (node_type_id='" + str(teststepId) + "');"
                    
                self.log("Read steps of testcase: " + stmt)

                cursor.execute (stmt)
                results = cursor.fetchall()

                stepOrder = {}
                for thisResult in results:
                    theStepId = str(thisResult[0])
                    stmt = "select actions, expected_results, step_number from tcsteps " + \
                    "where id='" + str(theStepId) + "';"
                    
                    self.log("Read stepdata: " + stmt)

                    cursor.execute (stmt)               
                    result = cursor.fetchone()

                    if result and len(result) > 0:
                        #first store steps in hash with stepnumbers as key
                        stepNumber = result[2]                    
                        stepOrder[stepNumber] = result
                    else:
                        self.log("No teststepdata found.")

                if len(stepOrder) > 0:
                    theKeys = sorted(stepOrder.keys())
                    #write steps in right order
                    for stepNumber in theKeys:
                        result = stepOrder[stepNumber]
                        action = result[0]
                        expRes = result[1]
                        stepNumber = result[2]                    
                        self.writeSequence19(action, expRes, suiteFile)
                
            else:
                stmt = "select id from nodes_hierarchy " + \
                    "where parent_id='" + str(parentID) + "' " + \
                    "and (node_type_id='" + str(tcversionTypeID) + "');"
                    
                self.log("Read steps of testcase: " + stmt)

                cursor.execute (stmt)
                
                r = cursor.fetchone()
                self.writeComment(cursor, r[0], parentID, suiteFile)
                self.writeSequence(cursor, r[0], suiteFile)
            
        except Exception, err:
            print "Exception during reading information of test-steps: ", str(err)
    #

    #read current version of testlink db
    def getDBVersion(self, cursor):
        try:            
            stmt = "select version from db_version;"
                    
            self.log("Read version of db: " + stmt)

            cursor.execute (stmt)

            r = cursor.fetchone()
            dbversion = r[0]
            parts = dbversion.split(" ")
            dbv = parts[1].replace(".", "")
            self.log("Db version" + dbversion)
            return dbv
            
        except Exception, err:
            print "Exception during reading db_version: ", str(err)
    #

    #write the given step as sequence into testsuite
    def writeSequence19(self, name, expRes, suiteFile):
        try:
            name = name.replace("<ol>", "")
            name = name.replace("</ol>", "")
            name = name.replace("<li>", "")
            name = name.replace("</li>", "")            
            name = name.replace("<ul>", "")
            name = name.replace("</ul>", "")
            name = name.replace("<u>", "")
            name = name.replace("</u>", "")
            name = name.replace("<em>", "")
            name = name.replace("</em>", "")            
            name = self.getCleanName(name)            
            name = String(name).trim()
            nameParts = name.split("\n")
            name = nameParts[0]
 
            seqName = name
            self.nodeIndex = self.nodeIndex + 1
            if seqName != "" and seqName != None:                
                suiteFile.write("<TestStep id=\"_" + str(self.nodeIndex) + "\" name =\"" + str(seqName) + "\">\n")
                suiteFile.write("<comment>Expected result:\n" + self.getCleanName(expRes, 1) + "</comment>")
                suiteFile.write("</TestStep>\n")                                    
                
        except Exception, err:
            print "Exception during writing tcstep: ", str(err)
    #
    
    #write the given step as sequence into testsuite
    def writeSequence(self, cursor, tcid, suiteFile):
        try:            
            stmt = "select steps, expected_results from tcversions " + \
                    "where id='" + str(tcid) + "';"
                    
            self.log("Read steps of tc-version: " + stmt)

            cursor.execute (stmt)

            r = cursor.fetchone()
            parts = r[0].split("\n")        
            expRes = r[1].split("\n")

            for i in range(len(parts)):
                expName = ""
                try: #build string of expected result               
                    expResCI = len(expRes[i])
                    expResOI = expRes[i].find("<li>")
                    expResCI = expRes[i].find("</li>")
                
                    if expResOI == -1:
                        expResOI = expRes[i].find("<p>")
                        if expResOI == -1:
                            expResOI = 0
                        else:
                            expResOI = expResOI + 3
                    else:
                        expResOI = expResOI + 4
                            
                    if expResCI == -1:
                        expResCI = expRes[i].find("</p>")
                        if expResCI == -1:
                            expResCI = len(expRes[i])                        
                            
                    expName = expRes[i][expResOI:expResCI]
                    expName = String(expName).replaceAll("<ol>", "")
                    expName = String(expName).replaceAll("</ol>", "")
                    expName = String(expName).replaceAll("<ul>", "")
                    expName = String(expName).replaceAll("</ul>", "")
                except: #no expected result specified
                    expName = ""
                
                if parts[i].startswith("<p>"):
                    seqName = ""
                    if i == len(parts) - 1:
                        seqName = parts[i][3:-4]
                    else:
                        seqName =  parts[i][3:-5]
                     
                    seqName = self.getCleanName(seqName)
                    self.nodeIndex = self.nodeIndex + 1
                    if seqName != "" and seqName != None:                
                            suiteFile.write("<TestStep id=\"_" + str(self.nodeIndex) + "\" name =\"" + str(seqName) + "\">\n")
                            suiteFile.write("<comment>Expected result:\n" + self.getCleanName(expName, 1) + "</comment>")
                            suiteFile.write("</TestStep>\n")                        
                elif parts[i].find("<li>") != -1 or parts[i].find("</li>") != -1:
                    seqName = ""
                    self.nodeIndex = self.nodeIndex + 1
                    openIdx = parts[i].find("<li>")
                    closeIdx = parts[i].find("</li>")
                    
                    if closeIdx == -1:
                        seqName = parts[i][openIdx+4:]

                        seqName = self.getCleanName(seqName)                        
                        suiteFile.write("<TestStep id=\"_" + str(self.nodeIndex) + "\" name =\"" + str(seqName) + "\">\n")
                        suiteFile.write("<comment>Expected result:\n" + self.getCleanName(expName, 1) + "</comment>")
                    elif openIdx == -1:
                        suiteFile.write("</TestStep>\n")
                        
                    else:
                        seqName = parts[i][openIdx+4:-6]

                        seqName = self.getCleanName(seqName)
                        if seqName != "" and seqName != None:                
                                suiteFile.write("<TestStep id=\"_" + str(self.nodeIndex) + "\" name =\"" + str(seqName) + "\">\n")
                                suiteFile.write("<comment>Expected result:\n" + self.getCleanName(expName, 1) + "</comment>")   
                                suiteFile.write("</TestStep>\n")
                
        except Exception, err:
            print "Exception during reading information of tc-version: ", str(err)
    #
            
            
    #removes not allowed characters from test-case's name
    def getCleanName(self, name, isComment = 0):
        newName = name.encode('ascii', 'xmlcharrefreplace')
        newName = String(newName)
        
        
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
        
        mIdx = newName.find("<meta")
        if mIdx != -1:
            newName = newName[0:mIdx]

        return String(newName).trim()
    #
        
#end of class


#main
sys.setdefaultencoding("latin-1")
params = parseArgs(sys.argv)

tl = TestLinkIntegrator()

tl.setDBInfo(dbdriver, connectionstr, dbuser, dbpass)

if params.has_key('verbose'):
    tl.setLogmode(1)
    
print "Begin export, ..."
  
if not (params.has_key('testproject') and params.has_key('targetsuite')):
    usageExit("Mandatory input parameter missing!")

if not params.has_key('testsuite'):
    params['testsuite'] = None
        
tl.doExport(params['testproject'], params['targetsuite'], params['testsuite'])

print "... export completed!"
    
sys.exit(0)
