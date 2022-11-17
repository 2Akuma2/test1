# {{{ imports

import os
import sys
import time

import robot
from robot.api.logger import debug, info, warn, error
from robot.api.deco import keyword
is4 = int(robot.version.get_version().split(".")[0]) >= 4
if is4:
    # requires robot 4
    from robot.api import FatalError, Error, Failure, ContinuableFailure, SkipExecution
else:
    FatalError = Error = Failure = ContinuableFailure = SkipException = Exception
#

# }}}

# {{{ globals

iswin = sys.platform == 'win32'
isosx = sys.platform == 'darwin'
islinux = not iswin and not isosx

STATE_INVALID = -1
STATE_IDLE = 0
STATE_SCHEDULED = 1
STATE_RUNNING = 2
STATE_PAUSED = 3
STATE_FINISHED = 4

# }}}

# {{{ JVM setup

import jpype
import jpype.imports
from jpype.types import *

# Determine QF-Test directory
# Optional override via environment
QFTEST_DIR = os.environ.get("QFTEST_HOME", None)
if not QFTEST_DIR:
    # Default: Determine automatically relative to this module
    QFTEST_DIR = os.path.abspath(__file__ + "/../../../..")
# Internal use during development
QFTEST_DEV_CLASSPATH = os.environ.get("QFTEST_DEV_CLASSPATH", "")
# print("QFTEST_DEV_CLASSPATH", QFTEST_DEV_CLASSPATH, file=sys.stderr)


# Determine JAVA_HOME
if "JAVA_HOME" not in os.environ:
    if iswin:
        os.environ["JAVA_HOME"] = os.path.join(QFTEST_DIR, "jre", "win64")
    elif islinux:
        os.environ["JAVA_HOME"] = os.path.join(QFTEST_DIR, "jre", "linux64")

# beware of reload
if not jpype.isJVMStarted():
    for d in QFTEST_DEV_CLASSPATH.split(";"):
        jpype.addClassPath(d)
    jpype.addClassPath(os.path.join(QFTEST_DIR, "qflib", "qflib.jar"))
    jpype.addClassPath(os.path.join(QFTEST_DIR, "qflib", "qfshared.jar"))
    jpype.addClassPath(os.path.join(QFTEST_DIR, "qflib", "qftest.jar"))
    jpype.startJVM()

    from java.lang import System
    from java.lang import Exception as JavaException
    from java.util import Properties

    # qflog
    from de.qfs.lib.log import Log, QFLogger
    from de.qfs.lib.log.Log import ERR, ERRDETAIL, WRN, WRNDETAIL, MSG, MSGDETAIL, MTD, MTDDETAIL, DBG, DBGDETAIL
    logger = QFLogger("qftest.Daemon")
    from de.qfs.lib.util import ArgsParser, LogSetup
    ap = ArgsParser ()
    LogSetup.instance().setupInitialLogging("robot")
    LogSetup.instance().addOptions(ap)
    args = JArray(JString)(4)
    try:
        args[0] = JString("-log-de.qfs.apps.qftest.daemon.=10")
        args[1] = JString("-log-qftest.=10")
        args[2] = JString("-logserver=qflog")
        args[3] = JString("-logoutputlevel=2")
    except java.lang.Exception as ex:
        ex.infoStackTrace()
    ap.parse(args)
    LogSetup.instance().setupLogging("robot", ap)

    def qflog(level, method, message=""):
        if logger.level >= level:
            logger.log(level, method, message)
    def qflogException(level, method, throwable):
        if logger.level >= level:
            logger.log(level, method, throwable)
    qflog(DBG, "module.Daemon()", "setup finished")

# }}}

# {{{ class Daemon

class Daemon:
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'
    ROBOT_LIBRARY_VERSION = '6.0'
    ROBOT_LISTENER_API_VERSION = 2

    # {{{ __init__

    def __init__(self, host="localhost", port=5454, keystore=False, suite="robot.qft"):
        qflog(MTD, "__init__()", "host: %s, port: %s, keystore: %s, suite: %s" % (host, port, keystore, suite))
        qflog(DBG, "__init__()", "CLASSPATH: %s" % System.getProperty("java.class.path"))
        self.ROBOT_LIBRARY_LISTENER = self
        self.daemon = None
        self.context = None

        from . import ThreadHelper
        ThreadHelper.setAtExit(self)
        try:
            from de.qfs.apps.qftest.daemon import DaemonLocator
            dl = DaemonLocator.simpleInstance()
            qflog(DBG, "__init__()", "dl: %s" % dl)
            if keystore:
                dl.setKeystore(os.path.join(QFTEST_DIR, "daemon.keystore"))
            else:
                dl.setKeystore("")
            self.daemon = dl.locateDaemon(host, port)
            qflog(DBG, "__init__()", "daemon: %s" % self.daemon)
            if self.daemon is None:
                raise FatalError("Cannot locate QF-Test daemon")
            self.daemon.ping()
            self.robotDaemon = self.daemon.getRobotDaemon()
            qflog(DBG, "__init__()", "robotDaemon: %s" % self.robotDaemon)
            self.robotDaemon.setRootDirectory(os.getcwd())
            self.context = self.robotDaemon.getRobotContext()
            qflog(DBG, "__init__()", "context: %s" % self.context)
            if suite:
                if not suite.endswith(".qft"):
                    suite += ".qft"
                self.suite = os.path.abspath(suite)
            else:
                self.suite = os.path.abspath("robot.qft")
            try:
                self.context.setSuite(self.suite)
            except:
                pass
        except:
            import traceback
            traceback.print_exc(file=sys.stderr)
    #

    # }}}

    # {{{ get_keyword_names

    def get_keyword_names(self):
        qflog(MTD, "get_keyword_names()")
        if self.context:
            self.keywords = {}
            kwds = self.context.getKeywords()
            qflog(DBG,"get_keyword_names()", "kwds: %s, type(kwds): %s" % (kwds, type(kwds)))
            qflog(DBG,"get_keyword_names()", "kwd: %s" % kwds[0].getClass().getProtectionDomain())
            for kwd in kwds:
                qflog(DBG,"get_keyword_names()", "kwd: %s" % kwd.getName())
                name = str(kwd.getName())
                self.keywords[name] = kwd
            qflog(DBG,"get_keyword_names()", "self.keywords: %s" % self.keywords)
            ret = list(self.keywords)[:]
            ret.append("set_global")
            qflog(DBG, "get_keyword_names()", "ret: %s" % ret)
            return ret
    #

    # }}}
    # {{{ run_keyword

    def run_keyword(self, name, args, kwargs):
        qflog(MTD, "run_keyword()", "name: %s, args: %s, kwargs: %s" %(name, args, kwargs))
        if name == "set_global":
            # name = "qfs.setGlobal"
            return self.set_global(*args, **kwargs)
        props = Properties()
        myargs = self.get_keyword_arguments(name)
        for i, arg in enumerate(args):
            if myargs and len(myargs) > i:
                props.setProperty(asJString(myargs[i][0]), asJString(arg))
            else:
                props.setProperty(JString("arg%d" % i), asJString(arg))
        for k in kwargs.keys():
            arg = kwargs[k]
            props.setProperty(JString(k), asJString(arg))
        if not props.containsKey(JString("__keyword")):
            props.setProperty(JString("__keyword"), JString(name))
        try:
            result = self.context.runKeyword(JString(name), props)
            qflog(DBG, "run_keyword()", "result: %s" % result)
            if result.getException():
                if str(result.getException().className) == "de.qfs.apps.qftest.shared.exceptions.StopException":
                    # Explicit stop
                    raise Error ("QF-Test daemon: Test stopped")
                if str(result.getException().className) == "de.qfs.apps.qftest.shared.exceptions.SkipException":
                    # Skipped outside test
                    raise Error ("QF-Test daemon: Skipped out of test context")
                msg = str(result.getException().message)
                qflog(DBG, "run_keyword()", "msg from exception: %s" % msg)
                raise Failure (msg)
            if result.getErrors():
                if is4:
                    msg = "\n\n".join([str(x) for x in result.getErrors()])
                    qflog(DBG, "run_keyword()", "msg from errors: %s" % msg)
                    raise ContinuableFailure (msg)
                else:
                    for x in result.getErrors():
                        msg = str(x)
                        qflog(DBG, "run_keyword()", "msg from errors: %s" % msg)
                        error(msg)
            return str(result.getResult())
        except JavaException as ex:
            # ex.printStackTrace()
            # error("ex: %s" % ex)
            msg = str(ex.getMessage())
            if msg.startswith("Illegal state:"):
                msg = "Daemon is busy"
            raise Error(msg)
    #

    # }}}
    # {{{ set_global

    def set_global(self, name=None, value=None, **kwargs):
        qflog(MTD, "set_global()", "name: %s, value: %s, kwargs: %s" %(name, value, kwargs))
        try:
            if name is not None:
                # result = self.context.runKeyword(JString(self.suite + "#qfs.setGlobal"), props)
                self.robotDaemon.setGlobal(JString(name), asJString(value))
            for n,v in kwargs.items():
                if n is not None:
                    qflog(DBG, "set_global()", "n: '%s', v: '%s'" % (n, v))
                    self.robotDaemon.setGlobal(JString(n), asJString(v))
        except JavaException as ex:
            # ex.printStackTrace()
            # error("ex: %s" % ex)
            msg = str(ex.getMessage())
            if msg.startswith("Illegal state:"):
                msg = "Daemon is busy"
            raise Error(msg)
    #

    # }}}
    # {{{ get_keyword_arguments

    def get_keyword_arguments(self, name):
        qflog(MTD, "get_keyword_arguments()", "name: %s" % name)
        if name == "set_global":
            return [("name", ""), ("value",""),'**kwargs']
        args = []
        kwd = self.keywords.get(name,None)
        if kwd:
            for arg in kwd.getArguments():
                args.append((str(arg[0]), str(arg[1])))
        args.append("**kwargs")
        return args
    #

    # }}}
    # {{{ get_keyword_types

    def XXget_keyword_types(self, name):
        qflog(MTD, "get_keyword_types()", "name: %s" % name)
        info("get_keyword_types %s" % name)
        return ["%s_type1" % name, "%s_type2" % name]
    #

    # }}}
    # {{{ get_keyword_tags

    def get_keyword_tags(self, name):
        qflog(MTD, "get_keyword_tags()", "name: %s" % name)
        info("get_keyword_tags %s" % name)
        tags = []
        kwd = self.keywords.get(name,None)
        if kwd and kwd.getTags():
            tags = [str(tag) for tag in kwd.getTags()]
        return tags
    #

    # }}}
    # {{{ get_keyword_documentation

    def get_keyword_documentation(self, name):
        qflog(MTD, "get_keyword_documentation()", "name: %s" % name)
        kwd = self.keywords.get(name,None)
        if kwd and kwd.getDocumentation():
            return str(kwd.getDocumentation())
    #

    # }}}

    # Listener implementation
    # {{{ start_suite

    def start_suite(self, name, attrs):
        qflog(MTD, "start_suite()", "name: %s, attrs: %s" % (name, attrs))
        if self.context:
            try:
                self.context.startTestSuite(JString(name))
            except JavaException as ex:
                qflogException(WRN, "end_test()", ex)
    #

    # }}}
    # {{{ end_suite

    def end_suite(self, name, attrs):
        qflog(MTD, "end_suite()", "name: %s, attrs: %s" % (name, attrs))
        if self.context:
            try:
                self.context.endTestSuite(JString(name))
            except JavaException as ex:
                qflogException(WRN, "end_test()", ex)
    #

    # }}}
    # {{{ start_test

    def start_test(self, name, attrs):
        qflog(MTD, "start_test()", "name: %s, attrs: %s" % (name, attrs))
        if self.context:
            try:
                self.context.startTestCase(JString(name))
            except JavaException as ex:
                qflogException(WRN, "end_test()", ex)
    #

    # }}}
    # {{{ end_test

    def end_test(self, name, attrs):
        qflog(MTD, "end_test()", "name: %s, attrs: %s" % (name, attrs))
        if self.context:
            try:
                self.context.endTestCase(JString(name))
            except JavaException as ex:
                qflogException(WRN, "end_test()", ex)
    #

    # }}}
    # {{{ close

    def close(self):
        qflog(MTD, "close()")
        if self.context:
            try:
                self.context.stopTest()
            except JavaException as ex:
                qflogException(WRN, "end_test()", ex)
    #

    # }}}

#

# }}}

# Helpers
# {{{ asJString

def asJString(val):
    return JString("" if val is None else str(val))
#

# }}}

# {{{ __main__

if __name__ == "__main__":
    daemon = Daemon()
    daemon.daemon.ping()
    print("success")

#

# }}}
