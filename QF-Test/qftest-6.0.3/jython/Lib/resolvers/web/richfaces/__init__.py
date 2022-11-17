"""Wrapper for the Java implementation of QF-Test resolvers for Richfaces."""

from de.qfs.apps.qftest.client.resolvers import VersionedResolver

# {{{ install

def install(rc=None, version=None, warnIfNewer=True, reloadModule=True):
    uninstall(rc)
    global _resolver
    _resolver = VersionedResolver.loadResolver("web.RichFacesResolver", version) # warn, reload

    if _resolver:
        global treeIsNodeExpanded, treeIsNodeSelected, tabpanelIsItemSelected
        tabpanelIsItemSelected = lambda tabBarItem, resolver=_resolver: resolver.tabpanelIsItemSelected(tabBarItem)
        treeIsNodeExpanded = lambda treeItem, resolver=_resolver: resolver.treeIsNodeExpanded(treeItem)
        treeIsNodeSelected = lambda treeItem, resolver=_resolver: resolver.treeIsNodeSelected(treeItem)
        
        _resolver.install()

        msg = "Installed Java richfaces Resolver version %s" % _resolver.getVersion()
        print msg
        if rc:
            rc.logMessage(msg)
    else:
        msg = "Error when trying to install Java richfaces Resolver version %s: Version not found." % version
        print msg
        if rc:
            rc.logError(msg)
#

# }}}
# {{{ uninstall

def uninstall(rc=None):
    global _resolver
    global treeIsNodeExpanded, treeIsNodeSelected, tabpanelIsItemSelected
    try:
        del treeIsNodeExpanded, treeIsNodeSelected, tabpanelIsItemSelected
        _resolver.uninstall()
        msg = "Uninstalled Java RichFaces Resolver version %s" % _resolver.getVersion()
        del _resolver
        print msg
        if rc:
            rc.logMessage(msg)
    except Exception, ex:
        #print "Uninstall failed ", ex
        pass
#

# }}}
