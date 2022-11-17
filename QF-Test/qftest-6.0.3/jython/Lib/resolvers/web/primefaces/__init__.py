"""Wrapper for the Java implementation of QF-Test resolvers for primefaces."""

from de.qfs.apps.qftest.client.resolvers import VersionedResolver

# {{{ install

def install(rc=None, version=None, warnIfNewer=True, reloadModule=True):
    uninstall(rc)
    mversion = VersionedResolver.installResolver("web.PrimefacesResolver", version) # warn, reload
    if mversion:
        msg = "Installed Java primefaces Resolver version %s" % mversion
        print msg
        if rc:
            rc.logMessage(msg)
    else:         
        msg = "Error when trying to install Java primefaces Resolver version %s: Version not found." % version
        print msg
        if rc:
            rc.logError(msg)
#

# }}}
# {{{ uninstall

def uninstall(rc=None):
    version = VersionedResolver.uninstallResolver("web.PrimefacesResolver")
    if version:
        print "Uninstalled Java primefaces Resolver version %s" % version
        if rc:
            rc.logMessage("Uninstalled Java primefaces Resolver version %s" % version)
#

# }}}
