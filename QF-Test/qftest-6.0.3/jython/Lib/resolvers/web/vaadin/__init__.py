"""Wrapper for the Java implementation of QF-Test resolvers for vaadin."""

from de.qfs.apps.qftest.client.resolvers import VersionedResolver

# {{{ install

def install(rc=None, version=None, warnIfNewer=True, reloadModule=True):
    global _resolver
    try:
        if _resolver:
            return
    except:
        pass
    _resolver = VersionedResolver.loadResolver("web.VaadinResolver", version)

    if _resolver:
        _resolver.install()
        msg = "Installed Java vaadin Resolver version %s" % _resolver.getVersion()
        print msg
        if rc:
            rc.logMessage(msg)
    else:
        msg = "Error when trying to install Java vaadin Resolver version %s: Version not found." % version
        print msg
        if rc:
            rc.logError(msg)

#

# }}}
# {{{ uninstall

def uninstall(rc=None):
    global _resolver
    try:
        _resolver.uninstall()
        msg = "Uninstalled Java Vaadin Resolver version %s" % _resolver.getVersion()
        del _resolver
        print msg
        if rc:
            rc.logMessage(msg)
    except Exception, ex:
        #print "Uninstall failed ", ex
        pass
#

# }}}


# Example for overriding a Java resolver
# {{{ Extend Resolver class

# cl = VersionedResolver.loadResolverClass("web.vaadin.VaadinResolver", "1")
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
    # print "Installed Java vaadin Resolver version %s" % version
    # rc.logMessage("Installed Java vaadin Resolver version %s" % version)
#

# }}}
# {{{ _uninstall

# def _uninstall(rc):
    # try:
        # global _resolver
        # _resolver.uninstall()
        # version = _resolver.getVersion()
        # print "Uninstalled Java vaadin Resolver version %s" % version
        # rc.logMessage("Uninstalled Java vaadin Resolver version %s" % version)
    # except:
        # import traceback
        # traceback.print_exc()
#

# }}}
