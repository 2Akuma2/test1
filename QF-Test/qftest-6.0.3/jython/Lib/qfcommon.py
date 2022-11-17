# Common server and SUT-side helper casses and methods
import sys, synchronize, types
# default is 1000, can be exceeded easily
sys.setrecursionlimit(2000)

from java.awt.event import InputEvent, KeyEvent
from java.lang import Runnable, System, Object, Boolean, ArrayIndexOutOfBoundsException, String
from java.lang.reflect import Array
from java.io import File
from java.io import InterruptedIOException
from java.net import SocketTimeoutException
from java.util import ArrayList

from de.qfs.lib.log import Log, Logger
from de.qfs.lib.option import BooleanOption, ChoiceOption, IntegerOption, KeyOption, StringOption, TableOption
from de.qfs.lib.util import MRUCache, Observer, Pair, ThreadPool, Misc
try:
    from de.qfs.lib.gui import SwingUtil
except:
    try:
        # QFT-1820
        SwingUtil = BooleanOption.getClassLoader().loadClass("de.qfs.lib.gui.SwingUtil")
    except:
        pass

from de.qfs.apps.qftest.shared.extensions import Node, Options

import qf
qf.print = qf._print # Work around Jython 2.5 limitation

logger = Logger("de.qfs.jython.qfcommon")
# [issue1048] Need a unique lock for synchronized calls
mutex = Object()
# issueXXX Cache for compiled Jython scripts
cplCache = MRUCache(100)

# {{{ import exceptions

from de.qfs.apps.qftest.shared.exceptions import \
     BadComponentException, \
     BadExitCodeException, \
     BadExpressionException, \
     BadItemException, \
     BadRangeException, \
     BadRegexpException, \
     BadTestException, \
     BadVariableSyntaxException, \
     BreakException, \
     BusyPaneException, \
     CannotAttachException, \
     CannotExecuteException, \
     CannotRethrowException, \
     CheckFailedException, \
     CheckNotSupportedException, \
     ClientNotConnectedException, \
     ClientNotTerminatedException, \
     ComponentCannotGetFocusException, \
     ComponentFoundException, \
     ComponentIdMismatchException, \
     ComponentNotFoundException, \
     ConnectionFailureException, \
     DeadlockTimeoutException, \
     DependencyNotFoundException, \
     DisabledComponentException, \
     DisabledComponentStepException, \
     DocumentNotLoadedException, \
     DownloadNotCompleteException, \
     DownloadStillActiveException, \
     DuplicateClientException, \
     ExecutionTimeoutExpiredException, \
     ExtensionException, \
     InconsistentDependenciesException, \
     IndexFormatException, \
     IndexFoundException, \
     IndexNotFoundException, \
     IndexRequiredException, \
     InvalidDirectoryException, \
     InvisibleDnDTargetException, \
     InvisibleTargetComponentException, \
     InvisibleTargetItemException, \
     MissingPropertiesException, \
     MissingPropertyException, \
     ModalDialogException, \
     NoSuchClientException, \
     NoSuchDownloadException, \
     NoSuchEngineException, \
     OperationNotSupportedException, \
     ProcedureNotFoundException, \
     RecursiveVariableException, \
     RecursiveDependencyReferenceException, \
     ReturnException, \
     ScriptException, \
     StackOverflowException, \
     StopException, \
     TestCaseSkippedException, \
     TestCaseStoppedException, \
     TestControlException, \
     TestException, \
     TestNotFoundException, \
     TestOutOfMemoryException, \
     UnboundVariableException, \
     UnexpectedClientException, \
     UnexpectedExitCodeException, \
     UnexpectedIndexException, \
     UnresolvedComponentIdException, \
     UnresolvedIdException, \
     UserException, \
     VariableException, \
     VariableNumberException

# }}}

exc_info = None
code_old = None

#----------------------------------------------------------------------
# Initialization
#----------------------------------------------------------------------
# {{{ init

def init(gl):
    __doc__ = """Initialize the server side Jython support

    @param      gl      The global dictionary
    """

    global globalDict
    globalDict = gl

    # [issue643], [issue639] Split import of qftest exception and be sure to get all
    gl['BadComponentException'] = BadComponentException
    gl['BadExitCodeException'] = BadExitCodeException
    gl['BadExpressionException'] = BadExpressionException
    gl['BadItemException'] = BadItemException
    gl['BadRangeException'] = BadRangeException
    gl['BadRegexpException'] = BadRegexpException
    gl['BadTestException'] = BadTestException
    gl['BadVariableSyntaxException'] = BadVariableSyntaxException
    gl['BreakException'] = BreakException
    gl['BusyPaneException'] = BusyPaneException
    gl['CannotAttachException'] = CannotAttachException
    gl['CannotExecuteException'] = CannotExecuteException
    gl['CannotRethrowException'] = CannotRethrowException
    gl['CheckFailedException'] = CheckFailedException
    gl['CheckNotSupportedException'] = CheckNotSupportedException
    gl['ClientNotConnectedException'] = ClientNotConnectedException
    gl['ClientNotTerminatedException'] = ClientNotTerminatedException
    gl['ComponentCannotGetFocusException'] = ComponentCannotGetFocusException
    gl['ComponentFoundException'] = ComponentFoundException
    gl['ComponentIdMismatchException'] = ComponentIdMismatchException
    gl['ComponentNotFoundException'] = ComponentNotFoundException
    gl['ConnectionFailureException'] = ConnectionFailureException
    gl['DeadlockTimeoutException'] = DeadlockTimeoutException
    gl['DependencyNotFoundException'] = DependencyNotFoundException
    gl['DisabledComponentException'] = DisabledComponentException
    gl['DisabledComponentStepException'] = DisabledComponentStepException
    gl['DocumentNotLoadedException'] = DocumentNotLoadedException
    gl['DownloadNotCompleteException'] = DownloadNotCompleteException
    gl['DownloadStillActiveException'] = DownloadStillActiveException
    gl['DuplicateClientException'] = DuplicateClientException
    gl['ExecutionTimeoutExpiredException'] = ExecutionTimeoutExpiredException
    gl['ExtensionException'] = ExtensionException
    gl['InconsistentDependenciesException'] = InconsistentDependenciesException
    gl['IndexFormatException'] = IndexFormatException
    gl['IndexFoundException'] = IndexFoundException
    gl['IndexNotFoundException'] = IndexNotFoundException
    gl['IndexRequiredException'] = IndexRequiredException
    gl['InvalidDirectoryException'] = InvalidDirectoryException
    gl['InvisibleDnDTargetException'] = InvisibleDnDTargetException
    gl['InvisibleTargetComponentException'] = InvisibleTargetComponentException
    gl['InvisibleTargetItemException'] = InvisibleTargetItemException
    gl['MissingPropertiesException'] = MissingPropertiesException
    gl['MissingPropertyException'] = MissingPropertyException
    gl['ModalDialogException'] = ModalDialogException
    gl['NoSuchClientException'] = NoSuchClientException
    gl['NoSuchDownloadException'] = NoSuchDownloadException
    gl['NoSuchEngineException'] = NoSuchEngineException
    gl['OperationNotSupportedException'] = OperationNotSupportedException
    gl['ProcedureNotFoundException'] = ProcedureNotFoundException
    gl['RecursiveDependencyReferenceException'] = RecursiveDependencyReferenceException
    gl['RecursiveVariableException'] = RecursiveVariableException
    gl['ReturnException'] = ReturnException
    gl['ScriptException'] = ScriptException
    gl['StackOverflowException'] = StackOverflowException
    gl['StopException'] = StopException
    gl['TestControlException'] = TestControlException
    gl['TestException'] = TestException
    gl['TestNotFoundException'] = TestNotFoundException
    gl['TestOutOfMemoryException'] = TestOutOfMemoryException
    gl['UnboundVariableException'] = UnboundVariableException
    gl['UnexpectedClientException'] = UnexpectedClientException
    gl['UnexpectedExitCodeException'] = UnexpectedExitCodeException
    gl['UnexpectedIndexException'] = UnexpectedIndexException
    gl['UnresolvedComponentIdException'] = UnresolvedComponentIdException
    gl['UnresolvedIdException'] = UnresolvedIdException
    gl['UserException'] = UserException
    gl['VariableException'] = VariableException
    gl['VariableNumberException'] = VariableNumberException

    gl['debug'] = debug
    gl['Options'] = Options
    gl['qf'] = qf
    gl['types'] = types
    try:
        import usernotifications as UserNotifications
        gl['notifications'] = UserNotifications
    except:
        pass

    global packageType, classType
    import org
    from org.python.core import Py
    packageType = type(org)
    classType = type(Py)

    global _encodingObserver
    _encodingObserver = EncodingObserver()
    opt = Options.getOption("DefaultJythonEncoding")
    opt.addObserver(_encodingObserver)
    opt.notifyObservers()
    try:
        opt = Options.getOption("JythonUnicodeLiterals")
        opt.addObserver(_encodingObserver)
        opt.notifyObservers()
    except:
        # new option doesn't exist in old versions
        pass
#

# }}}

#----------------------------------------------------------------------
# Debugging
#----------------------------------------------------------------------
# {{{ debug

def debug():
    global exc_info
    if exc_info is None:
        print "No error"
        return
    import pdb
    pdb.post_mortem(exc_info[2])
#

# }}}

#----------------------------------------------------------------------
# Helper classes
#----------------------------------------------------------------------
# {{{ class AWTRun

class AWTRun(Runnable):
    def __init__(self, cmd, globals, locals):
        self.cmd = cmd
        self.retval = None
        self.globals = globals
        self.locals = locals
        self.ex = None
    #

    def run(self):
        try:
            self.retval = eval(self.cmd, self.globals, self.locals)
        except:
            try:
                exec self.cmd in self.globals, self.locals
            except Exception, ex:
                self.ex = ex
    #
#

# }}}
# {{{ class TPRun

class TPRun(ThreadPool.UnsafeRunnable):
    def __init__(self, engine, runner):
        self.engine = engine
        self.runner = runner
    #

    def run(self):
        if self.engine is None:
            SwingUtil.invokeAndWait(self.runner)
        else:
            self.engine.invokeNow(self.runner)
        if self.runner.ex:
            raise self.runner.ex
        return self.runner.retval
    #
#

# }}}
# {{{ GlobalsWithFallback

class GlobalsWithFallback:
    """Wrapper around globals that looks up values from the locals also, but stores values in the actual globals."""

    def __init__(self, globals, locals):
        self.globals = globals
        self.locals = locals
    #

    def __getattr__(self, key):
        return self.globals.__getattribute__(key)
    #

    def __getitem__(self, key):
        try:
            return self.globals[key]
        except KeyError:
            return self.locals[key]
    #
#

# }}}

#----------------------------------------------------------------------
# Helper methods
#----------------------------------------------------------------------
# {{{ dictToProps

def dictToProps(dict, props=None):
    __doc__ = """Convert a dictionary to a list of key value pairs"""
    # if props is passed in we must check for key overlaps
    musttest = 1
    if dict is None:
        return None
    if props is None:
        props = ArrayList()
        musttest = 0
    for key in dict.keys():
        val = dict[key]
        if val is None:
            val = ""
        elif not type(val) in types.StringTypes:
            val = unicode(val)
        i = 0
        if musttest:
            while i < len(props):
                if props.get(i) == key:
                    props.put(i + 1, val)
                    break
        else:
            i = len(props)
        if i == len(props):
            props.add(key)
            props.add(val)
    return props
#

# }}}
# {{{ runscript

def _add_dir(mutex, dir):
    from java.lang import Thread
    sys.path.insert(0, dir)

add_dir = synchronize.make_synchronized(_add_dir)

def runscript(context, code, exContext, dir):
    __doc__ = """Run a Jython script in the server

    @param      context The jythonized RunContext wrapper
    @param      code    The code to execute
    @param      exContext Exception value holder
    @param      dir     The directory of the current suite
    """

    global exc_info
    global code_old
    remove = 0
    if dir != "":
        add_dir(mutex, dir)
        remove = 1
    excepted = 0
    file = None
    try:
        try:
            localDict = {'rc': context}
            if not globalDict.has_key('true'):
                localDict['true'] = 1
            if not globalDict.has_key('false'):
                localDict['false'] = 0
            # [issue492] Provide special globals with local backup
            file = context.getContext().getScriptFile()
            if file is None:
                file = "<string>"
            shouldsave = Options.getInt(Options.OPT_PLAY_SCRIPT_JYTHON_SAVE)
            if shouldsave == Options.VAL_PLAY_SCRIPT_JYTHON_SAVE_ALWAYS or \
               (shouldsave == Options.VAL_PLAY_SCRIPT_JYTHON_SAVE_IF_CHANGED and code != code_old):
                # Save temporary script file when code has changed as it may be shown for remote debugging
                try:
                    context.getContext().saveScriptToFile(code)
                    code_old = code
                except:
                    pass
            pair = Pair(file, code)
            cpl = cplCache.get(pair)
            if cpl is None:
                try:
                    cpl = compile(code, file, "exec")
                except ArrayIndexOutOfBoundsException, ex:
                    # The infamous Jython compiler bug
                    if logger.level >= Log.ERR:
                        logger.log(Log.ERR,
                                   "runscript(RunContext,String,ExceptionContext,String)", ex)
                    # Try again
                    cpl = compile(code, file, "exec")
            else:
                if logger.level >= Log.DBG:
                    logger.log(Log.DBG,
                               "runscript(RunContext,String,ExceptionContext,String)",
                               "cache hit: %s->%s" % (pair, cpl))
            cplCache.put(pair, cpl)
            # Non-global variables defined at script level are local for Python but should appear like globals
            # from the user's perspective
            exec cpl in GlobalsWithFallback(globalDict, localDict), localDict
            # [issue58] clear exContext to prevent caught exceptions from
            # re-appearing
            exContext.setException(None)
        except TestException, ex:
            excepted = 1
            exc_info = sys.exc_info()
            exContext.setException(ex)
        except TestControlException, ex:
            excepted = 1
            exc_info = sys.exc_info()
            exContext.setException(ex)
        except:
            excepted = 1
            exc_info = sys.exc_info()
            raise
    finally:
        # [issue754] Potential concurrency in multi thread mode
        cleanupafterrun(mutex, localDict, dir, remove)
        if excepted and file:
            try:
                context.getContext().saveScriptToFile(code)
            except:
                pass
#

# }}}
# {{{ cleanupafterrun

def _cleanupafterrun(mutex, localDict, dir, remove):
    __doc__ = """Clean up after a jython script was run.

    @param      localDict The local dictionary from the run
    @param      dir     The directory of the current suite
    @param      remove  Whether to remove the directory from sys.path
    """
    if remove:
        try:
            sys.path.remove(dir)
        except:
            pass
    # This is a special hack:
    # Jython is hard-coded to store imported modules in the local
    # namespace, so import statements are lost. The local namespace is
    # needed to allow synchronous calls from miscellaneous runcontexts.
    # As a workaround we copy all modules to the global namespace.
    for key in localDict.keys():
        val = localDict[key]
        try:
            if val is sys.modules[key]:
                globalDict[key] = val
                continue
        except KeyError:
            pass
        if type(val) is packageType or type(val) is classType:
                globalDict[key] = val
#
cleanupafterrun = synchronize.make_synchronized(_cleanupafterrun)

# }}}
# {{{ pickle

# QFT-1326 Note: The result is a guaranteed ASCII String and unpickling will reencode unicode correctly.

def pickle(dict):
    """Pickle a dictionary and return its string representation"""
    import cPickle
    return cPickle.dumps(dict)
#

# }}}
# {{{ unpickle

# QFT-1326 Note: The data is a guaranteed ASCII String and unpickling will reencode unicode correctly.

def unpickle(data):
    """Unpickle a pickled string and return its value"""

    import cPickle
    return cPickle.loads(data)
#

# }}}
# {{{ unpickleAndStore

def unpickleAndStore(data):
    """Unpickle a pickled string that represents a dictionary and store
    those values in the globals"""

    globalDict.update(unpickle(data))
#

# }}}
# {{{ getvar

def getvar(name, result):
    result[0] = pickle(globalDict[name])
#

# }}}
# {{{ toKeystroke

def toKeystroke(value):
    if value == None or value == "":
        return KeyOption.Data(0, '\0', 0)
    try:
        modifiers = 0
        parts = value.split("-")
        for i in range(len(parts) - 1):
            mod = parts[i].upper()
            if mod == "SHIFT":
                modifiers = modifiers | InputEvent.SHIFT_MASK
            elif mod == "CTRL" or mod == "CONTROL":
                modifiers = modifiers | InputEvent.CTRL_MASK
            elif mod == "ALT":
                modifiers = modifiers | InputEvent.ALT_MASK
            elif mod == "META":
                modifiers = modifiers | InputEvent.META_MASK
        key = KeyEvent.getField("VK_" + parts[-1].upper()).getInt(None)
        return KeyOption.Data(key, '\0', modifiers)
    except:
        # import traceback
        # traceback.print_exc()
        raise TestException ("Cannot parse keystroke: %s" % value)
#

# }}}

# {{{ Doctag processing

import re
reDoctag = re.compile("^\\s*@(\\S+)\\s*", re.DOTALL | re.MULTILINE)
reTagname = re.compile("(\\S+)\\s*")

# {{{ stripDoctags

def stripDoctags(text):
    """Strip all doctacs from a comment.

    @param      text    The comment to strip the doctags from.

    @return      The comment without doctags with trailing whitespace removed."""
    match = reDoctag.search(text)
    if not match:
        return text
    ret = text[0:match.start()].rstrip()
    return ret
#

# }}}
# {{{ getDoctag

def getDoctag(text, tag, named=True, name=None):
    match = reDoctag.search(text)
    while match:
        next = reDoctag.search(text, match.end())
        if match.group(1) != tag:
            match = next
            continue
        if next:
            rest = text[match.end(1) + 1:next.start()].rstrip()
        else:
            rest = text[match.end(1) + 1:].rstrip()
        if named:
            nmatch = reTagname.match(rest)
            if not nmatch or (name and name != nmatch.group(1)):
                match = next
                continue
            return (nmatch.group(1), rest[nmatch.end():])
        else:
            return rest
#

# }}}
# {{{ getDoctags

def getDoctags(text, tag=None, named=True):
    ret = []
    match = reDoctag.search(text)
    while match:
        next = reDoctag.search(text, match.end())
        if tag and match.group(1) != tag:
            match = next
            continue
        if next:
            rest = text[match.end(1) + 1:next.start()].rstrip()
        else:
            rest = text[match.end(1) + 1:].rstrip()
        if tag and named:
            nmatch = reTagname.match(rest)
            if not nmatch:
                match = next
                continue
            ret.append((match.group(1), nmatch.group(1), rest[nmatch.end():]))
        else:
            ret.append((match.group(1), rest))
        match = next
    return ret
#

# }}}

# }}}
# {{{ Encoding option observer

class EncodingObserver(Observer):
    def update(self, option, context):
        if option.getName() == "DefaultJythonEncoding":
            encoding = option.getValue()
            if encoding:
                # Legacy with unicode included - drop it
                for val in encoding.split():
                    val = val.strip()
                    if not val.lower() in ["unicode", "nounicode"]:
                        encoding = val
                        break
            if not encoding:
                encoding = "ascii"
            # print "Jython default encoding: %s" % encoding
            try:
                import org.python.core.codecs as __codecs
                __codecs.setDefaultEncoding(encoding)
                del __codecs
            except:
                import traceback
                traceback.print_exc()
        elif option.getName() == "JythonUnicodeLiterals":
            unicodeLiterals = option.getValue()
            # print "Jython unicode literals: %s" % unicodeLiterals
            System.setProperty("qftest.workarounds.forceJythonUnicodeLiterals",
                               "true" if unicodeLiterals else "false")
        cplCache.clear()
        # print "Jython encoding updated and compiler cache cleared"

# }}}
