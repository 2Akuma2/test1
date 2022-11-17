"""Wrapper for the Java implementation of QF-Test resolvers for extjs."""

from java.lang import Thread
import qf

from de.qfs.lib.log import Log, Logger
from de.qfs.apps.qftest.client import Engine
from de.qfs.apps.qftest.client.resolvers import VersionedResolver
from de.qfs.apps.qftest.client.web import WebEventFilter
from de.qfs.apps.qftest.client.web.dom import DocumentNode
from de.qfs.apps.qftest.client.web.event import MeexEvent


logger = Logger("de.qfs.apps.qftest.jython.resolvers.web.Extjs")
wef = None
rounds = 20

# {{{ install

def install(rc=None, version=None, warnIfNewer=True, reloadModule=True, nofallback=False):
    if logger.level >= Log.MTD:
        logger.build("install()").add("version: ").add(version).log(Log.MTD)

    uninstall(rc)
    global _resolver
    if version == "":
        version = None
    _resolver = VersionedResolver.loadResolver("web.ExtjsResolver", version)

    if _resolver:
        global treeIsNodeExpanded, treeGridIsNodeExpanded
        treeIsNodeExpanded = lambda treeItem, resolver=_resolver: resolver.treeIsNodeExpanded(treeItem)
        treeGridIsNodeExpanded = lambda treeItem, resolver=_resolver: resolver.treeGridIsNodeExpanded(treeItem)

        _resolver.install()
        msg = "Installed Java extjs Resolver version %s" % _resolver.getVersion()
        print msg
        if rc:
            qf.logMessage(msg)
        if (version is None or version >= "2") and not nofallback:
            # Check extjs version older than 4.1 and fall back to resolver 1
            if rc:
                tr = rc.engine.getTracker()
            else:
                tr = Engine.threadInstance("web").getTracker()
            for doc in tr.getToplevels():
                if maybeFallback(doc, rc, _resolver.getVersion(), warnIfNewer, reloadModule,
                                 mayDelay=False):
                    break
            else:
                global wef
                wef = WEF(tr, warnIfNewer, reloadModule)
                tr.addEventFilter(wef, MeexEvent.EVT_BR_DOCUMENT_COMPLETE)
    else:
        msg = "Error when trying to install Java extjs Resolver version %s: Version not found." % version
        print msg
        if rc:
            qf.logError(msg)

#

# }}}
# {{{ uninstall

def uninstall(rc=None):
    global _resolver
    global treeIsNodeExpanded, treeGridIsNodeExpanded

    try:
        if rc:
            tr = rc.engine.getTracker()
        else:
            tr = Engine.threadInstance("web").getTracker()
        if wef:
            tr.removeEventFilter(wef, MeexEvent.EVT_BR_DOCUMENT_COMPLETE)
        del treeIsNodeExpanded, treeGridIsNodeExpanded
        if logger.level >= Log.DBG:
            logger.build("uninstall()").add("_resolver: ").add(_resolver).log(Log.DBG)
        _resolver.uninstall()
        msg = "Uninstalled Java Extjs Resolver version %s" % _resolver.getVersion()
        del _resolver
        print msg
        if rc:
            qf.logMessage(msg)
    except Exception, ex:
        if logger.level >= Log.DBG:
            logger.build("uninstall()").add("No _resolver").log(Log.DBG)
        #print "Uninstall failed ", ex
        pass
#

# }}}
# {{{ maybeFallback

def maybeFallback(doc, rc, version, warnIfNewer, reloadModule, mayDelay=True):
    if logger.level >= Log.MTD:
        logger.build("maybeFallback()").add("doc: ").add(doc) \
            .add(", warnIfNewer: ").add(warnIfNewer) \
            .add(", reloadModule: ").add(reloadModule) \
            .add(", mayDelay: ").add(mayDelay) \
            .dumpStack(Log.MTD)
    if doc.isDisposed():
        # Skip this round
        if logger.level >= Log.MSG:
            logger.build("maybeFallback()").add("Document disposed").log(Log.MSG)
        return False
    try:
        doc.evalJS("Ext")
    except:
        # No ext at all
        if logger.level >= Log.DBG:
            logger.build("maybeFallback()").add("No Ext").log(Log.DBG)
        # Keep things, possible retry
        if mayDelay:
            scheduleCall(doc, version, warnIfNewer, reloadModule)
        return False
    fallback = False
    fbversion = None
    try:
        vs = doc.evalJS("Ext.getVersion().version")
    except:
        if logger.level >= Log.DBG:
            logger.build("maybeFallback()").add("No Ext.getVersion").log(Log.DBG)
        try:
            vs = doc.evalJS("Ext.version")
        except:
            if logger.level >= Log.DBG:
                logger.build("maybeFallback()").add("No Ext.version either").log(Log.DBG)
            # Keep things, possible retry
            if mayDelay:
                scheduleCall(doc, version, warnIfNewer, reloadModule)
            return False
    if logger.level >= Log.DBG:
        logger.build("maybeFallback()").add("vs: ").add(vs).log(Log.DBG)
    if not vs:
        # Keep things, possible retry
        if mayDelay:
            scheduleCall(doc, version, warnIfNewer, reloadModule)
        return False
    print "Extjs version: ", vs
    if vs and vs < "4.1" and version >= "2":
        fallback = True
        fbversion = "1"
    elif vs and vs < "5" and version >= "3":
        fallback = True
        fbversion = "2"
    if logger.level >= Log.DBG:
        logger.build("maybeFallback()").add("fallback: ").add(fallback) \
            .add(", fbversion: ").add(fbversion).log(Log.DBG)
    if fallback:
        print "Extjs versions older than 5 are not supported by resolver version 3 - " + \
              "falling back to resolver version %s" % fbversion
        uninstall(rc)
        install(rc, fbversion, warnIfNewer, reloadModule)
    return True
#

# }}}

# {{{ scheduleCall

def scheduleCall(doc, version, warnIfNewer, reloadModule):
    if logger.level >= Log.MTD:
        logger.build("scheduleCall()").add("version: ").add(version) \
            .add(", warnIfNewer: ").add(warnIfNewer) \
            .add(", reloadModule: ").add(reloadModule).log(Log.MTD)
    DelayedCall(doc, version, warnIfNewer, reloadModule).start()
#

# }}}

# {{{ event filter

class WEF(WebEventFilter):
    # No use saving rc, it can go out of scope while we're waiting for a doc complete
    def __init__(self, tracker, warnIfNewer, reloadModule):
        self.tracker = tracker
        self.warnIfNewer = warnIfNewer
        self.reloadModule = reloadModule
        self.count = 0
    #

    def filterEvent(self, browser, event, doc):
        # print "got doc: ", doc
        self.count = self.count + 1
        try:
            rv = _resolver.getVersion()
        except:
            rv = None
        if doc and not doc.hasParent():
            if maybeFallback(doc, None, rv, self.warnIfNewer, self.reloadModule) or self.count >= 3:
                self.tracker.removeEventFilter(self, MeexEvent.EVT_BR_DOCUMENT_COMPLETE)
        return True
    #

# }}}

# {{{ delayed call

class DelayedCall(Thread):
    def __init__(self, doc, version, warnIfNewer, reloadModule):
        self.doc = doc
        self.version = version
        self.warnIfNewer = warnIfNewer
        self.reloadModule = reloadModule
        self.sleeps = 0
        self.threadMode = True
        self.ret = False

    def run(self):
        if logger.level >= Log.MTD:
            logger.build("run()").add("threadMode: ").add(self.threadMode) \
                .add(", sleeps: ").add(self.sleeps).log(Log.MTD)
        if self.threadMode:
            while self.sleeps < rounds:
                print self.sleeps
                self.sleep(1000)
                self.sleeps = self.sleeps + 1
                self.threadMode = False
                e = Engine.engineFor(self.doc)
                e.safeInvokeNow(self)
                self.threadMode = False
                if logger.level >= Log.DBG:
                    logger.build("run()").add("ret: ").add(self.ret).log(Log.MTD)
                if self.ret:
                    return
                if self.doc.isDisposed():
                    # Try to replace
                    if logger.level >= Log.MSG:
                        logger.build("run()").add("Document disposed").log(Log.MSG)
                    hdl = self.doc.browser.getDocument("\x00")
                    self.doc = DocumentNode.getDocument(hdl)
                    if self.doc is None:
                        if logger.level >= Log.MSG:
                            logger.build("run()").add("Could note replace doc").log(Log.MSG)
                        return
        else:
            self.ret = maybeFallback(self.doc, None, self.version, self.warnIfNewer,
                                     self.reloadModule, False)
#

# }}}

# Example for overriding a Java resolver
# {{{ Extend Resolver class

# cl = VersionedResolver.loadResolverClass("web.extjs.ExtjsResolver", "1")
# print "cl:", cl
# class Resolver(cl):
    # def getId(self, node, id):
        # ret = cl.getId(self, node, id)
        # if id == "sample-ct":
            # print "node, id, ret, class:", node, id, ret, node.getClassName()
        # if (ret == "" or (ret is None and not id)) and node.getClassName() == "DIV":
            # # print "set property for ", node
            # node.setProperty(ResolverRegistry.RESOLVED_INTERESTING_PARENT, Boolean(False))
        # return ret
#

# }}}
# {{{ _install

# def _install(rc):
    # global _resolver
    # _resolver = Resolver()
    # _resolver.install()
    # version = _resolver.getVersion()
    # print "Installed Java extjs Resolver version %s" % version
    # qf.logMessage("Installed Java extjs Resolver version %s" % version)
#

# }}}
# {{{ _uninstall

# def _uninstall(rc):
    # try:
        # global _resolver
        # _resolver.uninstall()
        # version = _resolver.getVersion()
        # print "Uninstalled Java extjs Resolver version %s" % version
        # qf.logMessage("Uninstalled Java extjs Resolver version %s" % version)
    # except:
        # import traceback
        # traceback.print_exc()
#

# }}}
