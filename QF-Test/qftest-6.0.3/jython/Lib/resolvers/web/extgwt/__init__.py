"""Wrapper for the Java implementation of QF-Test resolvers for extgwt."""

from de.qfs.apps.qftest.client.resolvers import VersionedResolver

# {{{ install

def install(rc=None, version=None, warnIfNewer=True, reloadModule=True):
    uninstall(rc)
    mversion = VersionedResolver.installResolver("web.GwtResolver", version) # warn, reload
    if mversion:
        msg = "Installed extgwt part 1: Java gwt Resolver version %s" % mversion
        print msg
        if rc:
            rc.logMessage(msg)
    else:
        if version.startswith("2"):
            # workaround for installing extgwt 2 with gwt 1
            mversion = VersionedResolver.installResolver("web.GwtResolver", "1") # warn, reload
            if mversion:
                msg = "Installed extgwt part 1: Java gwt Resolver version %s" % mversion
                print msg
                if rc:
                    rc.logMessage(msg)
    if not mversion:
        msg = "Error when trying to install extgwt part 1: Java gwt Resolver version %s: Version not found." % version
        print msg
        if rc:
            rc.logError(msg)

    mversion = VersionedResolver.installResolver("web.ExtjsResolver", version) # warn, reload
    if mversion:
        msg = "Installed extgwt part 2: Java extjs Resolver version %s" % mversion
        print msg
        if rc:
            rc.logMessage(msg)
    else:
        msg = "Error when trying to install extgwt part 2: Java extjs Resolver version %s: Version not found." % version
        print msg
        if rc:
            rc.logError(msg)
#

# }}}
# {{{ uninstall

def uninstall(rc=None):
    version = VersionedResolver.uninstallResolver("web.ExtjsResolver")
    if version:
        msg = "Uninstalled Java extjs Resolver version %s" % version
        print msg
        if rc:
            rc.logMessage(msg)
    version = VersionedResolver.uninstallResolver("web.GwtResolver")
    if version:
        msg = "Uninstalled Java gwt Resolver version %s" % version
        print msg
        if rc:
            rc.logMessage(msg)
#

# }}}
