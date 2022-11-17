"""AJAX Toolkit auto detector"""

from java.lang import System, Thread, Runnable, RuntimeException
from de.qfs.apps.qftest.client import Engine
from de.qfs.apps.qftest.client.resolvers import VersionedResolver
from de.qfs.apps.qftest.client.web import WebEventFilter
from de.qfs.apps.qftest.client.web.dom import DocumentNode
from de.qfs.apps.qftest.client.web.event import MeexEvent
from de.qfs.lib.log import Log, Logger
from de.qfs.lib.tree import ReturnFromTraversalException, TraversalCallback, TreeUtil

logger = Logger("de.qfs.apps.qftest.client.resolvers.web.AutoDetect")

wef = None
resolver = None
auto_versions = None

# {{{ CSS classes for jeasyui

easyuiClasses = [
    "datagrid-header",
    "datagrid-row",
    "datagrid-row-expander",
    "tree",
    "tree-node",
    "tree-hit",
    "tree-icon",
    "tree-checkbox",
    "easyui-linkbutton",
    "l-btn",
    "menu",
    "menu-item",
    "spinner",
    "textbox-icon",
    "combo-p",
    "combo-panel",
    "combobox-item",
    "datagrid-pager",
    "panel",
    "easyui-resizable",
    "portal-panel",
    "panel-header",
    "panel-title",
    "panel-tool-collapse",
    "panel-tool-max",
    "panel-tool-min",
    "panel-tool-close",
    "calendar",
    "calendar-day",
    "datebox-button-a",
    "calendar-nav",
    "easyui-accordion",
    "accordion-header",
    "accordion-body",
    "icon-reload",
    "accordion-collapse",
    "easyui-progressbar",
    "window",
    "tabs-container",
    "tabs-close",
    "dialog-toolbar",
    "spinner-arrow-up",
    "spinner-arrow-down",
    "layout-button-right",
    "layout-button-left",
    "slider",
    "slider-handle",
    ]

# }}}

# {{{ install

def install(rc=None, version=None, auto_versions=None):
    global wef, resolver, g_auto_versions
    if logger.level >= Log.MTD:
        logger.log(Log.MTD, "install()", "rc: %s, version: %s" % (rc, version))
    if wef or resolver:
        uninstall(rc)
    print "Starting auto detector"
    if rc is not None:
        # Check existing documents
        tr = rc.engine.getTracker()
        g_auto_versions = auto_versions
        if g_auto_versions:
            for key in g_auto_versions.keys():
                if g_auto_versions[key] == "":
                    g_auto_versions[key] = None

        for doc in tr.getToplevels():
            if logger.level >= Log.DBG:
                logger.log(Log.DBG, "install()", "doc: %s" % doc)
            if detect(doc, rc, g_auto_versions):
                break
        else:
            global wef
            wef = WEF(rc.engine, tr)
            if logger.level >= Log.DBG:
                logger.log(Log.DBG, "install()", "wef: %s" % wef)
            tr.addEventFilter(wef, MeexEvent.EVT_BR_DOCUMENT_COMPLETE)
#

# }}}
# {{{ uninstall

def uninstall(rc=None):
    print "Stopping auto detector"
    global wef, resolver
    try:
        if logger.level >= Log.MTD:
            logger.log(Log.MTD, "uninstall()", "")
        if wef:
            tr.removeEventFilter(wef, MeexEvent.EVT_BR_DOCUMENT_COMPLETE)
        if rc:
            rc.logMessage("resolver: %s" % resolver)
        if resolver:
            resolver.uninstall()
            resolver = null
    except Exception, ex:
        #print "Uninstall failed ", ex
        pass
#

# }}}
# {{{ detect

def detect(doc, rc, auto_versions):
    if logger.level >= Log.MTD:
        logger.log(Log.MTD, "detect()", "rc: %s, doc: %s" % (rc, doc))
    if doc.isDisposed():
        if logger.level >= Log.MSG:
            logger.log(Log.MSG, "detect()", "doc disposed: %s" % doc)
        return False
    global resolver
    if rc:
        engine = rc.engine
    else:
        engine = Engine.engineFor(doc)
    if logger.level >= Log.DBG:
        logger.log(Log.DBG, "detect()", "engine: %s" % engine)

    try:
        # {{{ extGWT - must come before extjs and gwt

        if logger.level >= Log.DBG:
            logger.log(Log.DBG, "detect()", "Checking extGWT")
        if rc:
            rc.logMessage("Checking extGWT")
        extgwt = doc.evalJS("try {GXT; true} catch(e) {false}")
        if logger.level >= Log.DBG:
            logger.log(Log.DBG, "detect()", "extgwt: %s" % extgwt)
        if rc:
            rc.logMessage("extgwt: %s" % extgwt)
        if extgwt:
            from resolvers.web import extgwt
            resolver = extgwt
            # Only extjs resolver version 1 tested so far
            #version = "1"
            try:
                version = auto_version["extgwt"]
            except:
                version = None

            if not version:
                version = "1"
                if logger.level >= Log.DBG:
                    logger.log(Log.DBG, "detect()", "No auto version for extgwt found")
            if logger.level >= Log.DBG:
                logger.log(Log.DBG, "detect()", "Installing extGWT resolver version %s" % version)
            if rc:
                rc.logMessage("Installing extGWT resolver version %s" % version)
            resolver.install(rc, version)
            return True

        # }}}
        # {{{ extjs

        if logger.level >= Log.DBG:
            logger.log(Log.DBG, "detect()", "Checking Extjs")
        if rc:
            rc.logMessage("Checking Extjs")
        ext = doc.evalJS("try {Ext; true} catch(e) {false}")
        if logger.level >= Log.DBG:
            logger.log(Log.DBG, "detect()", "ext: %s" % ext)
        if rc:
            rc.logMessage("ext: %s" % ext)
        if ext:
            from resolvers.web import extjs
            # don't override nofallback, let the extjs resolver handle old versions
            # extjs.nofallback = True
            resolver = extjs
            try:
                version = auto_versions["extjs"]
            except:
                version = None

            if not version:
                version = "3"
                if logger.level >= Log.DBG:
                    logger.log(Log.DBG, "detect()", "No auto version for extjs found")
            if logger.level >= Log.DBG:
                logger.log(Log.DBG, "detect()", "Installing Extjs resolver version %s" % version)
            if rc:
                rc.logMessage("Installing Extjs resolver version %s" % version)
            resolver.install(rc, version)
            return True

        # }}}
        # {{{ icefaces

        if logger.level >= Log.DBG:
            logger.log(Log.DBG, "detect()", "Checking IceFaces")
        if rc:
            rc.logMessage("Checking IceFaces")
        ice = doc.evalJS("try {ice.windowID; true} catch(e) {false}")
        if logger.level >= Log.DBG:
            logger.log(Log.DBG, "detect()", "ice: %s" % ice)
        if rc:
            rc.logMessage("ice: %s" % ice)
        if ice:
            from resolvers.web import icefaces
            resolver = icefaces
            try:
                version = auto_versions["icefaces"]
            except:
                version = None

            if not version:
                if logger.level >= Log.DBG:
                    logger.log(Log.DBG, "detect()", "No auto version for icefaces found")

            if logger.level >= Log.DBG:
                logger.log(Log.DBG, "detect()", "Installing IceFaces resolver version %s" % version)
            if rc:
                rc.logMessage("Installing IceFaces resolver version %s" % version)
            resolver.install(rc, version)
            return True

        # }}}
        # {{{ primefaces

        if logger.level >= Log.DBG:
            logger.log(Log.DBG, "detect()", "Checking PrimeFaces")
        if rc:
            rc.logMessage("Checking PrimeFaces")
        pf = doc.evalJS("try {PrimeFaces.VIEW_ROOT; true} catch(e) {false}")
        if logger.level >= Log.DBG:
            logger.log(Log.DBG, "detect()", "pf: %s" % pf)
        if rc:
            rc.logMessage("pf: %s" % pf)
        if pf:
            from resolvers.web import primefaces
            resolver = primefaces
            try:
                version = auto_versions["primefaces"]
            except:
                version = None

            if not version:
                if logger.level >= Log.DBG:
                    logger.log(Log.DBG, "detect()", "No auto version for primefaces found")
            if logger.level >= Log.DBG:
                logger.log(Log.DBG, "detect()", "Installing PrimeFaces resolver version %s" % version)
            if rc:
                rc.logMessage("Installing PrimeFaces resolver version %s" % version)
            resolver.install(rc, version)
            return True

        # }}}
        # {{{ rap

        if logger.level >= Log.DBG:
            logger.log(Log.DBG, "detect()", "Checking RAP")
        if rc:
            rc.logMessage("Checking RAP")
        rap = doc.evalJS("try {org.eclipse.rwt.Client._defaultLocale; true} catch(e) {false}")
        if logger.level >= Log.DBG:
            logger.log(Log.DBG, "detect()", "rap1: %s" % rap)
        if rc:
            rc.logMessage("rap1: %s" % rap)
        if rap:
            try:
                version = auto_versions["rap"]
            except:
                version = None
            if not version:
                # 2 instead of latest version
                version = "2"
                if logger.level >= Log.DBG:
                    logger.log(Log.DBG, "detect()", "No auto version for rap1 found")
        else:
            rap = doc.evalJS("try {rwt.client.Client._defaultLocale; true} catch(e) {false}")
            if logger.level >= Log.DBG:
                logger.log(Log.DBG, "detect()", "rap2: %s" % rap)
            if rc:
                rc.logMessage("rap 2: %s" % rap)
            try:
                version = auto_versions["rap2"]
            except:
                version = None
            if not version:
                version = "3"
                if logger.level >= Log.DBG:
                    logger.log(Log.DBG, "detect()", "No auto version for rap2  found")
        if rap:
            from resolvers.web import rap
            resolver = rap
            if logger.level >= Log.DBG:
                logger.log(Log.DBG, "detect()", "Installing RAP resolver version %s" % version)
            if rc:
                rc.logMessage("Installing RAP resolver version %s" % version)
            resolver.install(rc, version)
            return True

        # }}}
        # {{{ richfaces

        if logger.level >= Log.DBG:
            logger.log(Log.DBG, "detect()", "Checking RichFaces")
        if rc:
            rc.logMessage("Checking RichFaces")
        # RichFaces should be available in rf 3 and 4 and the resolver is the same anyway
        rf = doc.evalJS("try {RichFaces; true} catch(e) {false}")
        if logger.level >= Log.DBG:
            logger.log(Log.DBG, "detect()", "rf: %s" % rf)
        if rc:
            rc.logMessage("rf: %s" % rf)
        if rf:
            from resolvers.web import richfaces
            resolver = richfaces
            try:
                version = auto_versions["richfaces"]
            except:
                version = None

            if not version:
                #version = "3" -> no, take the latest as same anyway
                if logger.level >= Log.DBG:
                    logger.log(Log.DBG, "detect()", "No auto version for richfaces found")
            if logger.level >= Log.DBG:
                logger.log(Log.DBG, "detect()", "Installing RichFaces resolver version %s" % version)
            if rc:
                rc.logMessage("Installing RichFaces resolver version %s" % version)
            resolver.install(rc, version)
            return True

        # }}}
        # {{{ vaadin

        if logger.level >= Log.DBG:
            logger.log(Log.DBG, "detect()", "Checking Vaadin")
        if rc:
            rc.logMessage("Checking Vaadin")
        vaadin = doc.evalJS("try {window.vaadin && true} catch(e) {false}")
        if logger.level >= Log.DBG:
            logger.log(Log.DBG, "detect()", "vaadin: %s" % vaadin)
        if rc:
            rc.logMessage("vaadin: %s" % vaadin)
        if vaadin:
            from resolvers.web import vaadin
            resolver = vaadin
            try:
                version = auto_versions["vaadin"]
            except:
                version = None
            if not version:
                if logger.level >= Log.DBG:
                    logger.log(Log.DBG, "detect()", "No auto version for vaadin found")

            if logger.level >= Log.DBG:
                logger.log(Log.DBG, "detect()", "Installing Vaadin resolver version %s" % version)
            if rc:
                rc.logMessage("Installing Vaadin resolver version %s" % version)
            resolver.install(rc, version)
            return True

        # }}}
        # {{{ zk

        if logger.level >= Log.DBG:
            logger.log(Log.DBG, "detect()", "Checking ZK")
        if rc:
            rc.logMessage("Checking ZK")
        zk = doc.evalJS("try {zk.version; true} catch(e) {false}")
        if logger.level >= Log.DBG:
            logger.log(Log.DBG, "detect()", "zk: %s" % zk)
        if rc:
            rc.logMessage("zk: %s" % zk)
        if zk:
            from resolvers.web import zk
            resolver = zk
            try:
                version = auto_versions["zk"]
            except:
                version = None
            if not version:
                if logger.level >= Log.DBG:
                    logger.log(Log.DBG, "detect()", "No auto version for zk found")

            if logger.level >= Log.DBG:
                logger.log(Log.DBG, "detect()", "Installing ZK resolver version %s" % version)
            if rc:
                rc.logMessage("Installing ZK resolver version %s" % version)
            resolver.install(rc, version)
            return True

        # }}}
        # {{{ qooxdoo - last because RAP 1 is based on qooxdoo

        if logger.level >= Log.DBG:
            logger.log(Log.DBG, "detect()", "Checking qooxdoo")
        if rc:
            rc.logMessage("Checking qooxdoo")
        qx = doc.evalJS("try {qx; true} catch(e) {false}")
        if logger.level >= Log.DBG:
            logger.log(Log.DBG, "detect()", "qx: %s" % qx)
        if rc:
            rc.logMessage("qx: %s" % qx)
        if qx:
            from resolvers.web import qooxdoo
            resolver = qooxdoo
            try:
                version = auto_versions["qooxdoo"]
            except:
                version = None
            if not version:
                if logger.level >= Log.DBG:
                    logger.log(Log.DBG, "detect()", "No auto version for qooxdoo found")

            if logger.level >= Log.DBG:
                logger.log(Log.DBG, "detect()", "Installing qooxdoo resolver version %s" % version)
            if rc:
                rc.logMessage("Installing qooxdoo resolver version %s" % version)
            resolver.install(rc, version)
            return True

        # }}}
        # {{{ gwt - last because several others are based on GWT

        if logger.level >= Log.DBG:
            logger.log(Log.DBG, "detect()", "Checking GWT")
        if rc:
            rc.logMessage("Checking GWT")
        gwt = doc.evalJS("try {__gwt_Locale; true} catch(e) {false}")
        if logger.level >= Log.DBG:
            logger.log(Log.DBG, "detect()", "gwt: %s" % gwt)
        if rc:
            rc.logMessage("gwt: %s" % gwt)
        if gwt:
            from resolvers.web import gwt
            resolver = gwt
            try:
                version = auto_versions["gwt"]
            except:
                version = None
            if not version:
                if logger.level >= Log.DBG:
                    logger.log(Log.DBG, "detect()", "No auto version for gwt found")

            if logger.level >= Log.DBG:
                logger.log(Log.DBG, "detect()", "Installing GWT resolver version %s" % version)
            if rc:
                rc.logMessage("Installing GWT resolver version %s" % version)
            resolver.install(rc, version)
            return True

        # }}}
        # {{{ kendoui

        if logger.level >= Log.DBG:
            logger.log(Log.DBG, "detect()", "Checking KendoUI")
        if rc:
            rc.logMessage("Checking KendoUI")
        kendoui = doc.evalJS("try {kendo.version; true} catch(e) {false}")
        if logger.level >= Log.DBG:
            logger.log(Log.DBG, "detect()", "kendoui: %s" % kendoui)
        if rc:
            rc.logMessage("kendoui: %s" % kendoui)
        if kendoui:
            from resolvers.web import kendoui
            resolver = kendoui
            try:
                version = auto_versions["kendoui"]
            except:
                version = None
            if not version:
                if logger.level >= Log.DBG:
                    logger.log(Log.DBG, "detect()", "No auto version for kendoui found")

            if logger.level >= Log.DBG:
                logger.log(Log.DBG, "detect()", "Installing KendoUI resolver version %s" % version)
            if rc:
                rc.logMessage("Installing KendoUI resolver version %s" % version)
            resolver.install(rc, version)
            return True

        # }}}        
        # others that we can't detect at Javascript level yet
        # jQuery based UIs
        jq = doc.evalJS("try {jQuery; true} catch(e) {false}")
        if jq and engine:
            engine.getTracker().rescanToplevels(None, False)
            # Rescanning might have disposed our documnent
            if doc.isDisposed():
                ndoc = DocumentNode.getDocument(doc.getHandle())
                if logger.level >= Log.DBG:
                    logger.log(Log.DBG, "detect()", "Document disposed during rescan, replacement: %s" % ndoc)
                if ndoc is None:
                    return False
                doc = ndoc

            h = engine.getElementHelper()
            td = TraversalDetector()
            try:
                TreeUtil.traverse(h.getAdapter(), doc, td)
            except RuntimeException, ex:
                if logger.level >= Log.WRN:
                    logger.log(Log.WRN, "detect()", ex, "")

            if logger.level >= Log.DBG:
                logger.log(Log.DBG, "detect()", "jqueryui: %s, jeasyui: %s" % (td.jqueryui, td.jeasyui))
            if td.jqueryui >= 5 and td.jeasyui < td.jqueryui:
                from resolvers.web import jqueryui
                resolver = jqueryui
                try:
                    version = auto_versions["jqueryui"]
                except:
                    version = None
                if not version:
                    if logger.level >= Log.DBG:
                        logger.log(Log.DBG, "detect()", "No auto version for jqueryui found")

                if logger.level >= Log.DBG:
                    logger.log(Log.DBG, "detect()", "Installing JQueryUI resolver version %s" % version)
                if rc:
                    rc.logMessage("Installing JQueryUI resolver version %s" % version)
                resolver.install(rc, version)
                return True
            elif td.jeasyui >= 5:
                from resolvers.web import jeasyui
                resolver = jeasyui
                try:
                    version = auto_versions["jeasyui"]
                except:
                    version = None
                if not version:
                    if logger.level >= Log.DBG:
                        logger.log(Log.DBG, "detect()", "No auto version for jeasyui found")

                if logger.level >= Log.DBG:
                    logger.log(Log.DBG, "detect()", "Installing JEasyUI resolver version %s" % version)
                if rc:
                    rc.logMessage("Installing JEasyUI resolver version %s" % version)
                resolver.install(rc, version)
                return True


    except:
        import traceback
        traceback.print_exc()
    return False
#

# }}}

# {{{ WebEventFilter implementation

class WEF(WebEventFilter, Runnable):
    # No use saving rc, it can go out of scope while we're waiting for a doc complete
    def __init__(self, engine, tracker):
        self.engine = engine
        self.tracker = tracker
        self.count = 0
        self.icount = 0
        self.doc = None
    #

    def filterEvent(self, browser, event, doc):
        if logger.level >= Log.MTD:
            logger.log(Log.MTD, "wef.filterEvent()", "event: %s, doc: %s, toplevel: %s"
                       % (event, doc, not doc.hasParent()))
        if doc is None:
            if logger.level >= Log.WRN:
                logger.log(Log.WRN, "wef.filterEvent()", "null document")
            return True
        if not doc.hasParent():
            self.count = self.count + 1
            if logger.level >= Log.DBG:
                logger.log(Log.DBG, "wef.filterEvent()", "count: %s" % self.count)
            if detect(doc, None, g_auto_versions) or self.count >= 3:
                if logger.level >= Log.DBG:
                    logger.log(Log.DBG, "wef.filterEvent()", "removing event filter")
                self.tracker.removeEventFilter(self, MeexEvent.EVT_BR_DOCUMENT_COMPLETE)
                global wef
                wef = None
            else:
                self.icount = 0
                self.doc = doc
                self.engine.invokeLater(self)
        return True
    #

    def run(self):
        if logger.level >= Log.MTD:
            logger.log(Log.MTD, "wef.run()", "doc: %s" % self.doc)
        global wef
        if wef is None:
            if logger.level >= Log.MSG:
                logger.log(Log.MSG, "wef.run()", "already detected")
            return

        self.icount = self.icount + 1
        if logger.level >= Log.DBG:
            logger.log(Log.DBG, "wef.run()", "icount: %s" % self.icount)
        if detect(self.doc, None, g_auto_versions):
            if logger.level >= Log.DBG:
                logger.log(Log.DBG, "wef.filterEvent()", "removing event filter")
            self.tracker.removeEventFilter(self, MeexEvent.EVT_BR_DOCUMENT_COMPLETE)
            global wef
            wef = None
        elif self.icount < 5:
            self.engine.invokeLater(self)

# }}}

# Traversal based detectors
# {{{ TraversalDetector

class TraversalDetector (TraversalCallback):
    def __init__(self):
        self.jqueryui = 0
        self.jeasyui = 0

    def nodeEntered(self, traversal):
        node = traversal.getNode()
        if logger.level >= Log.DBG:
            logger.log(Log.DBG, "nodeEntered()", "node: %s" % node)
        try:
            cl = node.getAttribute("class")
            if logger.level >= Log.DBG:
                logger.log(Log.DBG, "nodeEntered()", "cl: %s" % cl)
            if cl:
                for c in cl.split(" "):
                    if c.startswith("ui-"):
                        self.jqueryui += 1
                        if logger.level >= Log.DBG:
                            logger.log(Log.DBG, "nodeEntered()", "jqueryui: %s" % c)
                        if self.jqueryui >= 10:
                            raise ReturnFromTraversalException()
                    elif c.startswith("easyui") or \
                         c.startswith("datagrid-view") or \
                         c in easyuiClasses:
                        if logger.level >= Log.DBG:
                            logger.log(Log.DBG, "nodeEntered()", "jeasyui: %s" % c)
                        self.jeasyui += 1
                        if self.jeasyui >= 10:
                            raise ReturnFromTraversalException()
        except:
            pass
        return True

    def nodeExited(self, traversal):
        pass
#

# }}}
