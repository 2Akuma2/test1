# Initialization file for Jython embedded in an SUT for qftest
try:
    import sys
except:
    from org.python.core import Py
    sys = Py.defaultSystemState
    sys.modules['sys'] = sys
    import sys

import types
from exceptions import AttributeError
from os.path import isfile, join

from java.lang import Class, Integer, Runnable, System, Throwable, Thread, IllegalArgumentException
from java.lang.reflect import InvocationTargetException

from javax.swing import SwingUtilities
try:
    from de.qfs.lib.gui import Message
except:
    #QFT-1820
    try:
        from de.qfs.lib.option import BooleanOption
        Message = BooleanOption.getClassLoader().loadClass("de.qfs.lib.gui.Message")
    except:
        pass

from de.qfs.apps.qftest.shared.exceptions import \
     TestControlException, \
     TestException, \
     IndexNotFoundException, \
     NoSuchEngineException

from de.qfs.apps.qftest.client import Client, Engine, PrivilegedRunnable, ScriptAccess

from de.qfs.apps.qftest.client.awt.data import ItemToIndexVisitor

from sutcontext import SutContext as Context

import qfcommon

import qf
qf.setRCProvider(lambda: Context("jython"))

#----------------------------------------------------------------------
# Initialization
#----------------------------------------------------------------------
#{{{ init

def init(gl):
    __doc__ = """Initialize the client side Jython support

    @param      gl      The global dictionary
    """

    qfcommon.init(gl)
    # [issue474] need runAWT for terminal
    gl["runAndroid"] = runAndroid
    gl["runAWT"] = runAWT
    gl["runSWT"] = runSWT
    gl["runWeb"] = runWeb
    gl["runFX"] = runFX
    gl["runWin"] = runWin
    for dir in sys.path:
        qfsut = join(dir, "qfsut.py")
        if isfile(qfsut):
            try:
                execfile(qfsut, gl)
            except:
                import traceback
                traceback.print_exc()
            break
    try:
        import nebula_grid
        gl["nebula_grid"] = nebula_grid
    except:
        pass
    # [issue3191] Make NatTable resolver generally available
    try:
        import nebula_nattable
        gl["nebula_nattable"] = nebula_nattable
    except:
        pass
    # [issue2549] Make FormText resolver generally available
    try:
        import formtext
        formtext.register()
        gl["formtext"] = formtext
    except:
        pass
    # [issue1277] Make gef resolver generally available
    try:
        import gef
        gl["gef"] = gef
    except:
        pass
    # [issue1130] Make ktable resolver generally available
    try:
        import ktable
        gl["ktable"] = ktable
    except:
        pass
    # Make the resolvers module generally available
    try:
        import resolvers
        gl["resolvers"] = resolvers
        from resolvers import web as webResolvers
        gl["webResolvers"] = webResolvers
    except:
        pass
    # Generic RunContext access during replay
    gl["__rc"] = Context("jython")
#

# }}}

# {{{ runAndroid

def runAndroid(cmd, timeout=5000):
    runner = qfcommon.AWTRun(cmd, globals(), sys._getframe(1).f_locals)
    e = Engine.instance("android")
    if timeout <= 0:
        e.invokeLater(runner)
        return
    return e.getThreadPool() \
           .executeWatched(qfcommon.TPRun(e, runner), timeout, 0)
#

# }}}
# {{{ runAWT

def runAWT(cmd, timeout=5000):
    runner = qfcommon.AWTRun(cmd, globals(), sys._getframe(1).f_locals)
    if timeout <= 0:
        SwingUtilities.invokeLater(runner)
        return
    e = Engine.instance("awt")
    return e.getThreadPool() \
           .executeWatched(qfcommon.TPRun(e, runner), timeout, 0)
#

# }}}
# {{{ runSWT

def runSWT(cmd):
    runner = qfcommon.AWTRun(cmd, globals(), sys._getframe(1).f_locals)
    Display = Class.forName("org.eclipse.swt.widgets.Display")
    disp = Display.getDefault()
    if disp.getThread() == Thread.currentThread():
        runner.run()
    else:
        disp.syncExec(runner)
    if runner.ex:
        raise runner.ex
    return runner.retval

# }}}
# {{{ runWeb

def runWeb(cmd, timeout=5000):
    runner = qfcommon.AWTRun(cmd, globals(), sys._getframe(1).f_locals)
    e = Engine.instance("web")
    if timeout <= 0:
        e.invokeLater(runner)
        return
    return e.getThreadPool() \
           .executeWatched(qfcommon.TPRun(e, runner), timeout, 0)

# }}}
# {{{ runFX

def runFX(cmd, timeout=5000):
    runner = qfcommon.AWTRun(cmd, globals(), sys._getframe(1).f_locals)
    e = Engine.instance("fx")
    if timeout <= 0:
        e.invokeLater(runner)
        return
    return e.getThreadPool() \
           .executeWatched(qfcommon.TPRun(e, runner), timeout, 0)
#

# }}}
# {{{ runWin

def runWin(cmd, timeout=5000):
    runner = qfcommon.AWTRun(cmd, globals(), sys._getframe(1).f_locals)
    e = Engine.instance("win")
    if timeout <= 0:
        e.invokeLater(runner)
        return
    return e.getThreadPool() \
           .executeWatched(qfcommon.TPRun(e, runner), timeout, 0)
#

# }}}

#----------------------------------------------------------------------
# Helper methods
#----------------------------------------------------------------------
#{{{ runscript

def runscript(context, code, exContext, dir, access, engine):
    __doc__ = """Run a Jython script in the server

    @param      context The current RunContext
    @param      code    The code to execute
    @param      exContext Exception value holder
    @param      dir     The directory of the current suite
    @param      access  Helper for accessing obfuscated internal methods
    @param      engine  The engine that's executing the code
    """

    ctxt = Context("jython")
    ctxt._pushVars(context, access, engine)
    ctxt.setExContext(exContext)
    ctxt.setEngine(engine)
    qfcommon.runscript(ctxt, code, exContext, dir)
#

#}}}

#----------------------------------------------------------------------
# Helper classes
#----------------------------------------------------------------------
#{{{ class PrivilegedCaller

class PrivilegedCaller(PrivilegedRunnable):
    __doc__ = """Helper class used to call back into a qftest procedure
    in a background thread"""
    def __init__(self, context, proc, props):
        self.context = context
        self.proc = proc
        self.props = props
    #

    def doRun(self):
        try:
            self.setReturnValue(self.context.getContext().callProcedure(self.proc, self.props))
        except Throwable, ex:
            self.context.getExContext().setException(ex)
            if isinstance(ex, TestControlException):
                delay = 100
            else:
                delay = 1000
            self.context.getExContext().interrupt(delay, self.context.getEngine().getThreadPool())
            self.setException(ex)
    #
#

#}}}
#{{{ class ComponentWaiter

class ComponentWaiter(PrivilegedRunnable):
    __doc__ = """Helper class used to find a component with active event processing"""
    def __init__(self, context, info, timeout, hidden):
        self.context = context
        self.info = info
        self.timeout = timeout
        self.hidden = hidden
    #

    def doRun(self):
        try:
            self.setReturnValue(self.context.getEngine().getTracker().waitForElement
                                (self.context.getContext(), self.info, self.timeout, self.hidden, None))
        except TestException, ex:
            self.setException(ex)
    #
#

#}}}
#{{{ class ItemWaiter

class ItemWaiter(PrivilegedRunnable):
    __doc__ = """Helper class used to find an item with active event processing"""
    def __init__(self, context, com, timeout, primary, secondary):
        self.context = context
        self.com = com
        self.timeout = timeout
        self.primary = primary
        self.secondary = secondary
    #

    def doRun(self):
        self.setReturnValue(self.context.getEngine().getTracker().waitForItem
                            (self.com, self.timeout, self.primary, self.secondary))
    #
#

#}}}
#{{{ class CurrentRunContext

class CurrentRunContext:
    def __getattr__(self, name):
        if name.startswith("__"):
            # Need standard behavior
            raise AttributeError
        rc = Client.instance().getRunContext()
        if rc:
            ctxt = Context(rc, ScriptAccess(), Client.instance().getEngine())
            return getattr(ctxt, name)
        else:
            raise Exception("No RunContext available.")
    #
#

# }}}

#{{{ local vars

# 
# Local Variables:
# gim-program: "telnet"
# eval: (setq gim-arguments (list "localhost" "18181"))
# eval: (local-set-key "\M-R" '(lambda () (interactive) (gim-send-string "rel()\n")))
# End:

#}}}
