"""Wrapper for the Java implementation of QF-Test basic resolvers."""

from de.qfs.apps.qftest.client.resolvers import VersionedResolver

# {{{ install

def install(rc=None, version=None, warnIfNewer=True, reloadModule=True):
    uninstall(rc)
    global _resolver
    _resolver = VersionedResolver.loadResolver("web.BasicResolver", version)
    if _resolver:
        global setTimeout
        setTimeout = lambda value, resolver=_resolver: resolver.setTimeout(value)
    
        _resolver.install()
        msg = "Installed Java Basic Web Resolver version %s" % _resolver.getVersion()
        print msg
        if rc:
            rc.logMessage(msg)
    else:
        msg = "Error when trying to install Basic Web Resolver version %s: Version not found." % version
        print msg
        if rc:
            rc.logError(msg)
      
# }}}
# {{{ uninstall

def uninstall(rc=None):
    global _resolver
    global setTimeout
    try:
        del setTimeout
        _resolver.uninstall()
        msg = "Uninstalled Java Basic Web Resolver version %s" % _resolver.getVersion()
        del _resolver
        print msg
        if rc:
            rc.logMessage(msg)
    except Exception, ex:
        pass

# }}}
