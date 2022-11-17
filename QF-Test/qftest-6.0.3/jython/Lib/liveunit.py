from java.lang import System
from java.lang.reflect import Modifier
from de.qfs.lib.util import Misc

def liveUnitTest(rc, instance, test):
    testclass = eval("instance.__class__." + test)
    # We cannot simply import the unit test classes. They might be tightly integrated with
    # the SUT and not available to the Jython classloader. Thus we need to use the classloader
    # of the test.
    TestResult = testclass.getClassLoader().loadClass("junit.framework.TestResult")
    TestSuite = testclass.getClassLoader().loadClass("junit.framework.TestSuite")
    BaseTestRunner = testclass.getClassLoader().loadClass("junit.runner.BaseTestRunner")

    suite = TestSuite()
    superclass = testclass
    while superclass:
        for method in superclass.getDeclaredMethods():
            if method.getName().startswith("test") and Modifier.isPublic(method.getModifiers()):
                testinstance = testclass(instance)
                testinstance.setName(method.getName())
                suite.addTest(testinstance)
        superclass = superclass.getSuperclass()

    class LiveRunner(BaseTestRunner):
        def __init__(self, rc):
            self.rc = rc

        def runFailed(self, message):
            print "run failed:", message
        #

        def testStarted(self, testName):
            # print "test started:", testName
            self.start = System.currentTimeMillis()
            self.failures = None
        #

        def testFailed(self, status, test, t):
            # print "test", t, "failed", status, "with Throwable", t
            if self.failures is None:
                self.failures = []
            if status == 1:
                st = "Error"
            else:
                st = "Failure"
            self.failures.append("%s %s: \n%s" % (test, st, Misc.getStackTrace(t)))
        #

        def testEnded(self, testName):
            # print "test ended:", testName
            now = System.currentTimeMillis()
            msg = testName + " (%dms)" % (now - self.start)
            if self.failures is not None:
                msg = msg + "\n\n" + "\n\n".join(self.failures)
            self.rc.check(self.failures is None, msg)

    runner = LiveRunner(rc)
    result = TestResult()
    result.addListener(runner)
    suite.run(result)



