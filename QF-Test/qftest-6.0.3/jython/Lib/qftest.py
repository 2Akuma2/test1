# Initialization file for Jython embedded in qftest
try:
    import sys
except:
    from org.python.core import Py
    sys = Py.defaultSystemState
    sys.modules['sys'] = sys
    import sys

import types
from javax.swing import SwingUtilities

from de.qfs.apps.qftest import App
from de.qfs.apps.qftest.run import AbstractRunContext
from de.qfs.apps.qftest.shared.exceptions import TestException, TestControlException

from os.path import isfile, join

from servercontext import ServerContext as Context

import qfcommon

import qf
qf.setRCProvider(lambda: Context("jython"))

#----------------------------------------------------------------------
# Initialization
#----------------------------------------------------------------------
#{{{ init

def init(gl):
    __doc__ = """Initialize the server side Jython support

    @param      gl      The global dictionary
    """

    qfcommon.init(gl)

    # [issue474] need runAWT for terminal
    gl["runAWT"] = runAWT

    for dir in sys.path:
        qfserver = join(dir, "qfserver.py")
        if isfile(qfserver):
            try:
                execfile(qfserver, gl)
            except:
                import traceback
                traceback.print_exc()
            break
    # Make the databinder module generally available
    try:
        import databinder
        gl["databinder"] = databinder
    except:
        pass
    # Generic RunContext access during replay
    gl["__rc"] = Context("jython")
#

#}}}

#{{{ runAWT

def runAWT(cmd, timeout=5000):
    runner = qfcommon.AWTRun(cmd, globals(), sys._getframe(1).f_locals)
    if timeout <= 0:
        SwingUtilities.invokeLater(runner)
        return
    return App.instance().getThreadPool().executeWatched(qfcommon.TPRun(None, runner), timeout, 0)
#

# }}}

#----------------------------------------------------------------------
# Helper methods
#----------------------------------------------------------------------
#{{{ runscript

def runscript(context, code, exContext, dir):
    __doc__ = """Run a Jython script in the server

    @param      context The current RunContext
    @param      code    The code to execute
    @param      exContext Exception value holder
    @param      dir     The directory of the current suite
    """

    ctxt = Context("jython")
    ctxt.setContext(context)
    qfcommon.runscript(ctxt, code, exContext, dir)
#

#}}}
#{{{ evalexpression

def evalexpression(ret, context, code, exHolder):
    __doc__ = """Evaluate a Jython expression in the server

    @param      ret     Return value holder
    @param      context The current RunContext
    @param      code    The expression to evluate
    @param      exHolder Exception value holder
    """
    try:
        ctxt = Context("jython")
        ctxt.setContext(context)
        localDict = {'rc': ctxt,
                     '__code': code, '__ret': ret}
        if not qfcommon.globalDict.has_key('true'):
            localDict['true'] = 1
        if not qfcommon.globalDict.has_key('false'):
            localDict['false'] = 0
        exec """
__tmp = eval(__code)
if type(__tmp) in types.StringTypes:
    __ret[0] = __tmp
else:
    __ret[0] = unicode(__tmp)
""" in qfcommon.globalDict, localDict
    except TestException, ex:
        exHolder[0] = ex
#

#}}}
#{{{ evalscript

def evalscript(ret, context, code, exHolder):
    __doc__ = """Evaluate or execute a Jython expression in the server

    @param      ret     Return value holder
    @param      context The current RunContext
    @param      code    The code to execute
    @param      exHolder Exception value holder
    """
    try:
        ctxt = Context("jython")
        ctxt.setContext(context)
        localDict = {'rc': ctxt,
         '__code': code, '__ret': ret}
        if not qfcommon.globalDict.has_key('true'):
            localDict['true'] = 1
        if not qfcommon.globalDict.has_key('false'):
            localDict['false'] = 0
        exec """
__tmp = eval(__code)
if type(__tmp) in types.StringTypes:
    __ret[0] = __tmp
else:
    __ret[0] = unicode(__tmp)
""" in qfcommon.globalDict, localDict
    except:
        try:
            exec code in qfcommon.globalDict, localDict
        except TestException, ex:
            exHolder[0] = ex
#

#}}}
#{{{ evaltest

def evaltest(ret, context, test, exHolder):
    __doc__ = """Evaluate a boolean expression

    @param      ret     Return value holder
    @param      context The current RunContext
    @param      test    The expression to execute
    @param      exHolder Exception value holder
    """

    try:
        ctxt = Context("jython")
        ctxt.setContext(context)
        localDict = {'rc': ctxt,
                     'ret': ret,
                     'false': 0,
                     'true': 1}
        exec "if " + test + ": ret[0]='true'" \
             in qfcommon.globalDict, localDict
    except TestException, ex:
        exHolder[0] = ex
    except TestControlException, ex:
        exHolder[0] = ex
#

#}}}

#----------------------------------------------------------------------
# Helper classes
#----------------------------------------------------------------------
#{{{ class CurrentRunContext

class CurrentRunContext:
    def __getattr__(self, name):
        if name.startswith("__"):
            # Need standard behavior
            raise AttributeError
        rc = AbstractRunContext.threadInstance()
        if rc:
            ctxt = Context("jython")
            return getattr(ctxt, name)
        else:
            raise Exception("No RunContext available.")
    #
#

# }}}
