"""Common utilities used by various QF-Test resolver modules."""

import os, re, sys, types
from os.path import dirname, join

# {{{ global variables

reVersionedModule = re.compile("v(\\d+)_(\\d+)_(\\d+)\\.py")

# }}}
# {{{ installVersion

def installVersion(rc, base, version, glbl, warnIfNewer, reloadModule):
    """Import and install a given version of a module in a way equivalent to 'from 1.0 import *'.
    If the version to import is 1.0 the implementing module must be named v1_0.py.

    @param  rc           The QF-Test run context for logging - optional.
    @param  base         The base path for the module.
    @param  version      The version to import.
    @param  glbl         The globals of the calling module into which to import the versioned module.
    @param  warnIfNewer  Whether to warn in case a newer version is available.
    @param  reloadModule Whether to reload the module."""

    modname = base.split(".")[-1]

    # Determine the module's directory
    moddir = dirname(__file__)
    for mdir in base.split(".")[1:]:
        moddir = join(moddir, mdir)
    # print moddir

    # Maybe uninstall the current version
    if glbl.has_key("_uninstall"):
        if not reloadModule:
            if rc:
                rc.logMessage("Module %s already loaded at version %s" %
                              (modname, glbl["_version"]))
            return
        uninstallVersion(rc, base, glbl)

    # Get the latest variant for the required version
    lversion = getLatestVersion(moddir, version)
    # print lversion

    # Build the module name
    _version = "v" + lversion.replace(".", "_")
    mname = base + "." + _version
    # print mname

    # Import the module
    mod = __import__(mname)
    for com in mname.split(".")[1:]:
        mod = getattr(mod, com)
    # print mod
    if reloadModule:
        reload(mod)

    # Copy the module's contents to the calling module's globals
    glbl["_version"] = lversion
    for key in dir(mod):
        if not key in ["__file__", "__name__", "__path__"]:
            glbl[key] = getattr(mod, key)
    try:
        del glbl[_version]
    except:
        pass

    # Actually install the module
    try:
        glbl["_install"](rc)
    except:
        import traceback
        traceback.print_exc()
        if rc:
            rc.logWarning(traceback.format_exception(sys.exc_type, sys.exc_value,
                                                     sys.exc_traceback))

    print "Module %s version %s installed" % (modname, lversion)
    if rc:
        rc.logMessage("Module %s version %s installed" % (modname, lversion))
    if rc and version and warnIfNewer:
        # Check if there's an even newer module available
        latest = getLatestVersion(moddir)
        if latest != lversion:
            name = base.split(".")[-1]
            rc.logWarning("A newer %s module with version %s is available." %
                          (name, latest))
#

# }}}
# {{{ uninstallVersion

def uninstallVersion(rc, base, glbl):
    """Uninstall a module and delete its methods and variables.

    @param  rc           The QF-Test run context for logging - optional.
    @param  base         The base path for the module.
    @param  glbl         The globals of the calling module from which to remove the values."""

    if glbl.has_key("_uninstall"):
        try:
            glbl["_uninstall"](rc)
        except:
            import traceback
            traceback.print_exc()
            if rc:
                rc.logWarning(traceback.format_exception(sys.exc_type, sys.exc_value,
                                                         sys.exc_traceback))
    # print glbl
    try:
        version = glbl["_version"]
    except:
        version = "?"
    for key in glbl.keys():
        if not key in ["__file__", "__name__", "__path__", "install", "uninstall",
                       "installVersion", "uninstallVersion"] \
                and type(glbl[key]) != types.ModuleType:
            # print key
            del glbl[key]
            # print glbl
    print "Module %s version %s uninstalled" % (base.split(".")[-1], version)
    if rc:
        rc.logMessage("Module %s version %s installed" % (base.split(".")[-1], version))
#

# }}}
# {{{ getLatestVersion

def getLatestVersion(dir, base=None):
    """Get the latest module version available in a given directory.
    Modules are expected to be of the form v1_1_0.py.

    @param      base    The base version to match against, e.g. 1.0 to get the highest 1.0.x
                        version.
    @param      dir     The directory to search.

    @return     The highest version found as a string, e.g. '1.1.0'."""

    if base:
        rebase = base.split(".")
        while len(rebase) < 3:
            rebase.append("\\d")
        rebase = tuple(rebase)
    else:
        rebase = ("\\d", "\\d", "\\d")
    # print rebase
    reModule = re.compile("v(%s)_(%s)_(%s)\\.py" % rebase)
    # print dir
    if dir.endswith(".py"):
        dir = dirname(dir)
    # print dir
    files = os.listdir(dir)
    max = [0, 0, 0]
    got = None
    for f in files:
        # print f
        match = reModule.match(f)
        if match:
            try:
                nums = [int(match.group(1)), int(match.group(2)), int(match.group(3))]
                if nums[0] >= max[0] and nums[1] >= max[1] and nums[2] >= max[2]:
                    max = nums
                    got = ".".join([str(x) for x in nums])
            except:
                pass
    return got
#

# }}}


