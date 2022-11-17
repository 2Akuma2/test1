""" Instrument an SWT/RCP application for usage with QF-Test.

    instrument(
        rc: Run Context for log messages (or None to print on stdout)
        appDir: The SWT/RCP application directory
        qfsHome: The QF-Test version home directory; default is System.getProperty("qftest.versionhome")
        optInstallLatestVersion: Install the QF-Test SWT files even if they have a newer version; default is 1.

    The swt.jar as well as the libraries are assumed to reside in the application dir or its subdirectories.
    For an RCP appliction, the plugin is assumed to reside in the plugin subdirectory."""

import re
import os
import shutil
import string
from stat import *
from time import strftime, gmtime
from java.lang import System
from java.util.zip import ZipEntry, ZipInputStream
from java.io import File, FileInputStream
import jarray

from de.qfs.lib.util import Misc
from de.qfs.apps.qftest.io import InstrumentSWT
from de.qfs.apps.qftest.shared.extensions import Options

SWT_INSTRUMENTATION_REQUIRED_BEFORE = 4080

# --------------------------------------------------------------------------------------------
# Helper functions
# --------------------------------------------------------------------------------------------
# {{{ log

LOG_MESSAGE = 0
LOG_WARNING = 1
LOG_ERROR = 2

def log(rc, severity, *args):
    """Print a message via Run Context rc or on stdout, if rc is None."""
    if rc != None:
        msg = ""
        for a in args:
            if len(msg) > 0:
                msg = msg + " "
            msg = msg + str(a)
        if severity == LOG_ERROR:
            rc.logError(msg)
        elif severity == LOG_WARNING:
            rc.logWarning(msg)
        else:
            rc.logMessage(msg)
    else:
        print severity,
        for a in args:
            print a,
        print
        pass

def logNoCompact(rc, *args):
    """Print a message via Run Context rc or on stdout, if rc is None."""
    if rc != None:
        msg = ""
        for a in args:
            if len(msg) > 0:
                msg = msg + " "
            msg = msg + str(a)
        rc.logMessage(msg, dontcompactify=True)
    else:
        print severity,
        for a in args:
            print a,
        print
        pass

# }}}
# {{{ find

def find(directory, pattern, recursive, fileList):
    """Find files with pattern in directory and its sub-directories (recursive = 1)."""
    from java.io import File
    # print "directory: ", directory, File(directory).getCanonicalPath();
    cpat = re.compile(pattern)
    files = os.listdir(directory)
    for f in files:
        path = os.path.join(directory, f)
        if recursive and os.path.isdir(path):
            find(path, pattern, recursive, fileList)
        elif re.match(cpat, f):
            fileList.append(path)

# }}}
# {{{ copy

def copy(files, destdir):
    """Copy files to destdir (file times are preserved)."""
    for f in files:
        name = os.path.basename(f)
        shutil.copy2(f, os.path.join(destdir, name))

# }}}
# {{{ rename

renamedFilesLog = {}

def rename(rc, oldName, newName):
    try:
        os.rename(oldName, newName)
        renamedFilesLog[oldName] = newName
        log(rc, LOG_MESSAGE, "Keep original file as", newName)
    except EnvironmentError, er:
        log(rc, LOG_ERROR, er.strerror, oldName)
        raise

# }}}
# {{{ renameRollback

def renameRollback(rc, renamedFiles):
    for f in renamedFiles.keys():
        os.rename(renamedFiles[f], f)
        log(rc, LOG_MESSAGE, "Restore original file", f)

# }}}
# {{{ getModifyTime

def getModifyTime(fileName):
    """Return the file time as comparable string (YYYYMMDDhhmmss)."""
    return strftime("%Y%m%d%H%M%S", gmtime(os.stat(fileName)[ST_MTIME]))

# }}}
# {{{ getFileSize

def getFileSize(fileName):
    """Return the file size in bytes."""
    return os.path.getsize(fileName)

# }}}

# --------------------------------------------------------------------------------------------
# SWT stuff
# --------------------------------------------------------------------------------------------
# {{{ class SwtLibPattern

class SwtLibPattern:
    # {{{ __init__

    def __init__(self):
        self.__pattern = r"^(libswt|swt)-([^-]+)-(\d+)\.(so|dll)$"

    # }}}
    # {{{ __getGroup

    def __getGroup(self, lib, index):
        name = os.path.basename(lib)
        m = re.match(self.getPattern(), name)
        if m != None:
            group = m.string[m.start(index):m.end(index)]
        else:
            group = ""
        return group

    # }}}
    # {{{ getPattern

    def getPattern(self):
        """Return pattern for lib file name."""
        return self.__pattern

    # }}}
    # {{{ getWindowSystem

    def getWindowSystem(self, lib):
        """Return the window system of the lib (e. g. 'gtk')."""
        return self.__getGroup(lib, 2)

    # }}}
    # {{{ getVersion

    def getVersion(self, lib):
        """Return the version of the lib (e. g. '3235')."""
        return self.__getGroup(lib, 3)

    # }}}
    # {{{ getRelease

    def getRelease(self, lib):
        """Return the release of the lib (e. g. '3.2')."""
        version = self.getVersion(lib)
        release = version[0] + "." + version[1]
        return release

    # }}}
    # {{{ getOs

    def getOs(self, lib):
        """Return the operation system of the lib (e. g. 'win32')."""
        ext = self.__getGroup(lib, 4)
        if ext == "so":
            return "linux"
        else:
            return "win32"

    # }}}

# }}}
# {{{ class SwtAllLibsPattern

class SwtAllLibsPattern:
    # {{{ __init__

    def __init__(self):
        self.__pattern = r"^(libswt|swt)-(.*)-(\d+)\.(so|dll)$"

    # }}}
    # {{{ __getGroup

    def __getGroup(self, lib, index):
        name = os.path.basename(lib)
        m = re.match(self.getPattern(), name)
        if m != None:
            group = m.string[m.start(index):m.end(index)]
        else:
            group = ""
        return group

    # }}}
    # {{{ getPattern

    def getPattern(self):
        """Return pattern for lib file name."""
        return self.__pattern

    # }}}
    # {{{ getVersion

    def getVersion(self, lib):
        """Return the version of the lib (e. g. '3235')."""
        return self.__getGroup(lib, 3)

    # }}}
    # {{{ compareLibNames

    def compareLibNames(self, lib1, lib2):
        """Return true, if lib1 and lib2 have the same name (except for the version)."""
        return (self.__getGroup(lib1, 1) == self.__getGroup(lib2, 1)) \
            and (self.__getGroup(lib1, 2) == self.__getGroup(lib2, 2)) \
            and (self.__getGroup(lib1, 4) == self.__getGroup(lib2, 4))

    # }}}

# }}}

swtLibPattern = SwtLibPattern()
swtAllLibsPattern = SwtAllLibsPattern()

# {{{ class SwtJar

class SwtJar:
    # {{{ __init__

    def __init__(self, fileName):
        self.__fileName = fileName
        self.__version = ""
        self.__release = ""
        self.__containsLibs = 0
        self.__os = ""
        self.__arch = ""
        self.__64bit = 0
        if os.path.exists(self.__fileName):
            self.__analyse()

    # }}}
    # {{{ __analyse

    def __analyse(self):
        libPattern = re.compile(r"^(libswt|swt)-([^-]+)-(\d+)(r(\d+))?\.(so|dll)$")
        fis = FileInputStream(self.__fileName)
        zis = ZipInputStream(fis)
        ze = zis.getNextEntry()
        global e_ident
        while ze != None:
            m = re.match(libPattern, ze.getName())
            if m:
                # print "ze: ", ze.getName()
                self.__containsLibs = True
                self.__version = m.group(3)
                self.__release = m.group(5)
                self.__arch = m.group(2)
                ext = m.group(6)
                # print "ext: ", ext
                if ext == "so":
                    self.__os = "linux"
                    e_ident = self.__readCurrentZipEntry(zis, ze, 16)
                    # print "e_ident: ", e_ident
                    self.__64bit = (e_ident[4] == 2)
                    # print "self.__64bit: ", self.__64bit
                else:
                    self.__os = "win32"
                    # see https://github.com/tgandor/meats/blob/master/missing/arch_of.py
                    e_ident = self.__readCurrentZipEntry(zis, ze, 64)
                    # print "e_ident: ", e_ident
                    b3, b2, b1 = e_ident[-4:-1]
                    if b3 < 0:
                        b3 += 256
                    if b2 < 0:
                        b2 += 256
                    if b1 < 0:
                        b1 += 256
                    offset = b1 * 32768 + b2 * 256 + b3
                    # print "offset: ", offset, b1, b2, b3
                    e_ident = self.__readCurrentZipEntry(zis, ze, offset -58)
                    # print "e_ident: ...", e_ident[-20:]
                    self.__64bit = e_ident[-2] == 100 and e_ident[-1] == -122
                    # print "self.__64bit: ", self.__64bit
                break
            ze = zis.getNextEntry()
        zis.close()

    # }}}
    # {{{ __readCurrentZipEntry

    def __readCurrentZipEntry(self, zipInputStream, zipEntry, size=-1):
        xbuflen = 256
        xbuf = jarray.zeros(xbuflen, 'b')
        if size < 0:
            size = zipEntry.getSize()
        if size >= 0:
            entrySize = zipEntry.getSize()
            if entrySize >= 0:
                size = min(size, entrySize)
            buf = jarray.zeros(size, 'b')
        else:
            buf = jarray.zeros(0, 'b')
        count = 0
        while 1:
            if size >= 0:
                xlen = min(xbuflen, size - count)
            else:
                xlen = xbuflen
            c = zipInputStream.read(xbuf, 0, xlen)
            if c > 0:
                if len(buf) >= count + c:
                    for i in range(c):
                        buf[count + i] = xbuf[i]
                else:
                    for i in range(c):
                        buf.append(xbuf[i])
                count += c
            else:
                break
        return buf

    # }}}
    # {{{ containsLibs

    def containsLibs(self):
        return self.__containsLibs

    # }}}
    # {{{ getVersion

    def getVersion(self):
        return string.replace(self.__version, ".", "")

    # }}}
    # {{{ getRelease

    def getRelease(self):
        """Return the release of the SWT jar (e. g. '3.3')."""
        version = self.getVersion()
        return version[0] + "." + version[1]

    # }}}
    # {{{ getOs

    def getOs(self):
        return self.__os

    # }}}
    # {{{ getArch

    def getArch(self):
        return self.__arch

    # }}}
    # {{{ get64bit

    def get64bit(self):
        return self.__64bit

    # }}}

# }}}

# {{{ findSwtLib

def findSwtLib(rc, appDir):
    """Find libswt-gtk-XXXX.so or swt-win32-XXXX.dll respectively."""
    libs = []
    find(appDir, swtLibPattern.getPattern(), 1, libs)
    if len(libs) == 0:
        log(rc, LOG_WARNING, "No swt library found in application (sub)directory.")
        return None
    else:
        if len(libs) > 1:
            log(rc, LOG_WARNING, "More than one swt library found.")
        return libs[0]

# }}}
# {{{ findSwtJar

def findSwtJar(rc, appDir):
    """Find swt.jar."""
    files = []
    find(appDir, r"^swt\.jar$", 1, files)
    if len(files) == 0:
        return None
    else:
        if len(files) > 1:
            log(rc, LOG_WARNING, "More than one swt jar file found.")
        return files[0]

# }}}
# {{{ findQfsSwtLib

def findQfsSwtLib(rc, qfsSwtDir):
    """Find libswt-gtk-XXXX.so or swt-win32-XXXX.dll respectively."""
    libs = []
    find(qfsSwtDir, swtLibPattern.getPattern(), 1, libs)
    if len(libs) == 0:
        log(rc, LOG_ERROR, "Qfs swt library not found in", qfsSwtDir)
        return None
    elif len(libs) > 1:
        log(rc, LOG_ERROR, "More than one Qfs swt library found in", qfsSwtDir)
    else:
        return libs[0]

# }}}
# {{{ findSwtLibs

def findSwtLibs(libDir):
    """Find libswt-.*-XXXX.so or swt-.*-XXXX.dll files."""
    libs = []
    find(libDir, swtAllLibsPattern.getPattern(), 0, libs)
    return libs

# }}}
# {{{ findCorrespondingQfsSwtLib

def findCorrespondingQfsSwtLib(lib, qfsLibs):
    for ql in qfsLibs:
        if swtAllLibsPattern.compareLibNames(lib, ql):
            return ql
    return None

# }}}
# {{{ getQfsSwtDir

def getQfsSwtDir(qfsHome, theOs, release, _64bit):
    if string.lower(theOs) == "linux":
        theOs += "-" + "gtk"
        if _64bit:
            theOs += "-64"
    qfsSwtDir = os.path.join(qfsHome, "swt", theOs, release)
    # print "qfsSwtDir", qfsSwtDir
    return qfsSwtDir

# }}}
# {{{ versionCheck

def versionCheck(rc, version, qfsVersion, optInstallLatestVersion):
    if qfsVersion != version:
        if ((qfsVersion > version) and (not optInstallLatestVersion)) or (qfsVersion < version):
            log(rc, LOG_WARNING, "Version mismatch!", "Version:", version, "!= Qfs version:", qfsVersion)
            return 0
        else:
            log(rc, LOG_WARNING, "Version:", version, "!= Qfs version:", qfsVersion)
    return 1

# }}}
# {{{ installCheck

def installCheck(rc, swtFile, qfsSwtFile):
    orig,orig2 = makeOriginalName(swtFile)
    origExists = os.path.exists(orig) or os.path.exists(orig2)
    mt = getModifyTime(swtFile)
    qfsMt = getModifyTime(qfsSwtFile)
    fs = getFileSize(swtFile)
    qfsFs = getFileSize(qfsSwtFile)
    installNeeded = ((not origExists) and mt != qfsMt) or qfsMt > mt or fs != qfsFs
    if not installNeeded:
        log(rc, LOG_MESSAGE, "Already instrumented.")
    return installNeeded

# }}}
# {{{ installSwt

def installSwt(rc, swtFile, qfsSwtFile):
    """Replace swtFile with qfsSwtFile."""
    orig,orig2 = makeOriginalName(swtFile)
    if os.path.exists(swtFile) and (not os.path.exists(orig)) and (not os.path.exists(orig2)):
        rename(rc, swtFile, orig2)
    try:
        if os.path.exists(swtFile):
            os.remove(swtFile)
    except EnvironmentError, er:
        log(rc, LOG_ERROR, er.strerror, lib)
        raise
    swtDir = os.path.dirname(swtFile)
    try:
        copy([qfsSwtFile], swtDir)
        log(rc, LOG_MESSAGE, qfsSwtFile, "installed.")
    except EnvironmentError, er:
        log(rc, LOG_ERROR, er)
        raise

# }}}
# {{{ instrumentSwtLibs

def instrumentSwtLibs(rc, appDir, qfsHome = System.getProperty("qftest.versionhome"),
               optInstallLatestVersion = 1, force=False):
    """Instrument swt.jar and the swt libraries for the SWT standalone application in appDir."""

    swtLib = findSwtLib(rc, appDir)
    if swtLib == None:
        return
    qfsSwtDir = getQfsSwtDir(qfsHome, swtLibPattern.getOs(swtLib), swtLibPattern.getRelease(swtLib), 0)
    qfsSwtLib = findQfsSwtLib(rc, qfsSwtDir)
    if qfsSwtLib == None:
        return

    if not installCheck(rc, swtLib, qfsSwtLib):
        return

    version = swtLibPattern.getVersion(swtLib)
    qfsVersion = swtLibPattern.getVersion(qfsSwtLib)
    if not versionCheck(rc, version, qfsVersion, optInstallLatestVersion):
        return

    swtDir = os.path.dirname(swtLib)
    swtLibs = findSwtLibs(swtDir)
    qfsSwtLibs = findSwtLibs(qfsSwtDir)
    for lib in swtLibs:
        qfsLib = findCorrespondingQfsSwtLib(lib, qfsSwtLibs)
        if qfsLib != None:
            installSwt(rc, lib, qfsLib)
        else:
            log(rc, LOG_WARNING, "No qfs lib for", lib)
    if string.lower(swtLibPattern.getOs(swtLib)) == "linux":
        libQfsSwt = "libqfswt-gtk-" + qfsVersion + ".so"
        installSwt(rc, os.path.join(swtDir, libQfsSwt), os.path.join(qfsSwtDir, libQfsSwt))

    return qfsSwtDir

# }}}
# {{{ makeOriginalName

def makeOriginalName(swtFile):
    orig = swtFile + ".orig"
    dir,file = os.path.split(orig)
    orig2 = os.path.join(dir, "_" + file)
    return orig,orig2

# }}}

# --------------------------------------------------------------------------------------------
# RCP stuff
# --------------------------------------------------------------------------------------------
# {{{ class PluginPattern

class PluginPattern:
    """Pattern to find Eclipse SWT plugins and to retrieve plugin properties
    (e. g. the operating system)."""

    # {{{ __init__

    def __init__(self):
        self.__pattern = ["org\\.eclipse\\.swt\\.",
                          "(\\S*?)\.(\\S*?)\\.(\\S*?)_(\\d+\\.\\d+)\\.(\\d+)(\\S*?)",
                          "\\.jar$"]
        self.__basepattern = ["swt\\.",
                          "(\\S*?)\.(\\S*?)\\.(\\S*?)_(\\d+\\.\\d+)",
                          "\\.instrument\\.jar$"]
        self.__cpattern = re.compile(self.getPattern())

    # }}}
    # {{{ __getGroup

    def __getGroup(self, plugin, index):
        name = os.path.basename(plugin)
        m = re.match(self.getCPattern(), name)
        if m <> None:
            group = m.string[m.start(index):m.end(index)]
        else:
            group = ""
        return group

    # }}}
    # {{{ matches

    def matches(self, plugin):
        name = os.path.basename(plugin)
        return re.match(self.getCPattern(), name) is not None

    # }}}
    # {{{ getPattern

    def getPattern(self):
        """Return pattern for plugin file name."""
        return self.__pattern[0] + self.__pattern[1] + self.__pattern[2]

    # }}}
    # {{{ getCPattern

    def getCPattern(self):
        """Return compiled pattern for plugin file name."""
        return self.__cpattern

    # }}}
    # {{{ getPatternWsOsArchRelease

    def getPatternWsOsArchRelease(self, ws, theos, arch, release):
        """Return pattern for plugin file name with specified window system etc."""
        return self.__pattern[0] + ws + "\\." + \
               theos + "\\." + \
               arch + "_" + \
               release.replace(".", "\\.") + ".*" + \
               self.__pattern[2]

    # }}}
    # {{{ getBasePatternWsOsArchRelease

    def getBasePatternWsOsArchRelease(self, ws, theos, arch, release):
        """Return pattern for plugin file name with specified window system etc."""
        return self.__basepattern[0] + ws + "\\." + \
               theos + "\\." + \
               arch + "_" + \
               release.replace(".", "\\.") + ".*" + \
               self.__basepattern[2]

    # }}}
    # {{{ getWindowSystem

    def getWindowSystem(self, plugin):
        """Return window system of the plugin (e. g. 'gtk')."""
        return self.__getGroup(plugin, 1)

    # }}}
    # {{{ getOs

    def getOs(self, plugin):
        """Return operating system of the plugin (e. g. 'linux')."""
        return self.__getGroup(plugin, 2)

    # }}}
    # {{{ getArch

    def getArch(self, plugin):
        """Return architecture of the plugin (e. g. 'x86')."""
        return self.__getGroup(plugin, 3)

    # }}}
    # {{{ getRelease

    def getRelease(self, plugin):
        """Return release of the plugin (e. g. '3.2')."""
        return self.__getGroup(plugin, 4)

    # }}}
    # {{{ getSubRelease

    def getSubRelease(self, plugin):
        """Return subrelease of the plugin (e. g. '1' in case of version '4.6.1')."""
        return self.__getGroup(plugin, 5)

    # }}}
    # {{{ getVersion

    def getVersion(self, plugin):
        """Return version of the plugin (e. g. '1.v3235')."""
        return self.__getGroup(plugin, 6)

    # }}}

# }}}

pluginPattern = PluginPattern()

# {{{ class InstrumentationError

class InstrumentationError:
    # {{{ __init __

    def __init__(self, value):
        self.value = value

    # }}}
    # {{{ __str__

    def __str__(self):
        return `self.value`

    # }}}

# }}}

# {{{ findSubDirectories

def findSubDirs(directory):
    """Find the direct subdirectories of directory."""
    if not os.path.isdir(directory):
        raise InstrumentationError("'" + directory + "' is not a directory.")
    dirs = []
    files = os.listdir(directory)
    for f in files:
        path = os.path.join(directory, f)
        if os.path.isdir(path):
            dirs.append(path)
    return dirs

# }}}
# {{{ findPluginsDir

def findPluginsDir(rcpDir):
    """Find the 'plugins' directory below rcpDir."""
    piDir = os.path.join(rcpDir, "plugins")
    if os.path.exists(piDir):
        return piDir
    if os.path.basename(rcpDir) == "plugins":
        return rcpDir
    piDirs = []
    for d in findSubDirs(rcpDir):
        piDir = os.path.join(d, "plugins")
        if os.path.exists(piDir):
            piDirs.append(piDir)
    if len(piDirs) == 1:
        return piDirs[0]
    elif len(piDirs) == 0:
        return ""
    else:
        raise InstrumentationError("Several 'plugins' directories found.")

# }}}
# {{{ findPlugins

def findPlugins(rcpDir):
    """Find plugins in rcpDir."""
    piDir = findPluginsDir(rcpDir)
    files = []
    if os.path.exists(piDir):
        find(piDir, pluginPattern.getPattern(), 0, files)
    # Filter out SWT language packs
    files = filter(lambda p: pluginPattern.getArch(p).find(".") < 0, files)
    return filter(lambda p: p.find(".source") < 0, files)

# }}}
# {{{ findQfsPlugin

def findQfsPlugin(rc, qfsDir, ws, theos, arch, version, release, subrelease):
    """Find best match for plugin in qfsDir/swt sub-directories."""
    osDir =  os.path.join(qfsDir, "swt", theos + ("" if theos == "win32" else "-%s" % ws) +
                          ("-64" if arch.endswith("64") else ""))
    swtDir = os.path.join(osDir, version)
    if not os.path.isdir(swtDir) and float(version) > 4:
        try:
            minor = int(version.split(".")[1]) -1
            # fallback to latest version
            while minor >= 9:
                tmp = os.path.join(osDir, "4.%d" % minor)
                if os.path.isdir(tmp):
                    swtDir = tmp
                    break
                minor -= 1
        except:
            import traceback
            traceback.print_exc()
    # exact match first
    files = []
    pattern = PluginPattern().getPatternWsOsArchRelease(ws, theos, arch, release)
    rc.logMessage("exact pattern: %s" % pattern)
    find(swtDir, pattern, False, files)
    if files:
        return files[0]

    # new-style instrumentation pattern next
    pattern = "instrument(-%s(.%s)?)?.jar" % (version, subrelease)
    rc.logMessage("new-style instrument pattern: %s" % pattern)
    find(swtDir, pattern, False, files)
    if files:
        # longest first - i.e. the most detailed one
        files.sort(lambda a,b: len(b) - len(a))
        return files[0]

    # finally old-style instrumentation pattern
    pattern = PluginPattern().getBasePatternWsOsArchRelease(ws, theos, arch, version)
    rc.logMessage("old-style instrumentation pattern: %s" % pattern)
    find(swtDir, pattern, False, files)
    if files:
        files.sort(comparePluginsByVersion)
        return files[0]

# }}}
# {{{ getPluginWithVersion

def getPluginWithVersion(plugins, version):
    """Return the plugin with matching version from the plugins list."""
    # print "plugins:", plugins
    # print "version:", version
    for p in plugins:
        # print "ppv:", pluginPattern.getVersion(p)
        if pluginPattern.getVersion(p) == version:
            return p
    return None

# }}}
# {{{ getBaseJarWithVersion

def getBaseJarWithVersion(basejars, version):
    """Return the basejar with matching version from the basejars list."""
    # print "basejars:", basejars
    # print "version:", version
    main = None
    for bj in basejars:
        # print bj
        bjm = re.match(".*_\d+\.\d+(\.(\d+))?\.instrument\.jar", bj)
        if bjm:
            bjv = bjm.group(2)
            # print "bjv:", bjv
            if bjv:
                if version.startswith(bjv + "."):
                    # print "Exact match:", bj
                    return bj
            else:
                main = bj
    if main:
        # print "Default match:", main
        return main
    return None

# }}}
# {{{ comparePluginsByVersion

def comparePluginsByVersion(plugin1, plugin2):
    """The latest version should be on top."""
    v1 = pluginPattern.getVersion(plugin1)
    v2 = pluginPattern.getVersion(plugin2)
    if (v1 > v2):
        return -1
    elif (v1 < v2):
        return 1
    else:
        return 0

# }}}
# {{{ rmtree_onerror

def rmtree_onerror(rc, function, path, excinfo):
    """Error handler for shutil.rmtree."""
    log(rc, LOG_WARNING, excinfo[1])

# }}}
# {{{ installRcp

def installRcp(rc, plugin, qfsPlugin):
    """Replace the plugin by the qfsPlugin and clean the cache."""
    pluginDir = os.path.dirname(plugin)
    try:
        if os.path.exists(plugin):
            os.remove(plugin)
    except EnvironmentError, er:
        log(rc, LOG_ERROR, er.strerror, plugin)
        raise
    except:
        ex = sys.exc_info()[:2]
        log(rc, LOG_ERROR, ex[0], ex[1])
        raise

    try:
        copy([qfsPlugin], pluginDir)
        log(rc, LOG_MESSAGE, "QF-Test plugin installed successfully.")
        if pluginPattern.getVersion(qfsPlugin) != pluginPattern.getVersion(plugin):
            log(rc, LOG_WARNING, "QF-Test plugin has different version!")
    except EnvironmentError, er:
        log(rc, LOG_ERROR, er)
        raise
    cleanRCP(rc, pluginDir)

# }}}
# {{{ cleanRCP

def cleanRCP(rc, pluginDir):
    osgiDir = os.path.join(pluginDir, "..", "configuration", "org.eclipse.osgi")
    if os.path.exists(osgiDir):
        logNoCompact(rc, "Remove cache folder: ", osgiDir, getModifyTime(osgiDir))
        ignoreErrors = 0
        shutil.rmtree(osgiDir, ignoreErrors, lambda x,y,z,rc=rc: rmtree_onerror(rc, x, y, z))
    else:
        logNoCompact(rc, "No cached files.")
#

# }}}
# {{{ remapVersion

def remapVersion(version, subrelease):
    def mapv(match):
        sep = match.group(1)
        val = int(match.group(2))
        if val == 100:
            pval = 2
        elif val == 108 and subrelease == "100":
            pval = 10
        else:
            pval = val - 99
        return "4%s%d" % (sep, pval)

    return re.sub("3(\\.|_)(1[01][0-9])", mapv, version)
#

# }}}
# {{{ instrumentRcp

def instrumentRcp(rc, plugins, qfsHome, optInstallLatestVersion, force=False):
    """Instrument the SWT plugin(s) for a RCP application."""
    ignored = 0
    for plugin in plugins:
        isPlugin = pluginPattern.matches(plugin)
        if isPlugin:
            ws = pluginPattern.getWindowSystem(plugin)
            if not ws in ["gtk", "win32"]:
                log(rc, LOG_MESSAGE, "Ignoring", os.path.basename(plugin))
                ignored += 1
                continue
            theos = pluginPattern.getOs(plugin)
            arch = pluginPattern.getArch(plugin)
            release = pluginPattern.getRelease(plugin)
            subrelease = pluginPattern.getSubRelease(plugin)
            version = remapVersion(release, subrelease)
            xversion = int(version.split(".")[0]) * 1000 + int(version.split(".")[1]) * 10
            log(rc, "version 1: %s, xversion 1: %s" % (version, xversion))
        if not isPlugin or version >= 9:
            # Starting with 4.9 version counting has become extermely unreliable, especially during milestones
            swtJar = SwtJar(plugin)
            release = swtJar.getVersion()
            major = int(release[0])
            minor = int(release[1:])
            if major >= 4 and minor >= 922:
                # 922 represents 4.10, increase by 2 for each quarterly release
                offset = 10 + (minor - 922) / 2
                if minor >= 940:
                    offset -= 1
                version = "4.%d" % offset
                xversion = 4000 + offset * 10
            else:
                version = "%d.%s" % (major, release[1])
                xversion = major * 1000 + int(release[1]) * 10
            theos = swtJar.getOs()
            ws = swtJar.getArch()
            arch = "x86_64" if swtJar.get64bit() else "x86"
            subrelease = swtJar.getRelease()
            log(rc, "version 2: %s, xversion 2: %s" % (version, xversion))
        log(rc, LOG_MESSAGE, "plugin: %s, os: %s, arch: %s, version: %s, release: %s, subrelease: %s" % \
            (plugin, theos, arch, version, release, subrelease))
        if not force:
            if Misc.OS_IS_LINUX and xversion >= SWT_INSTRUMENTATION_REQUIRED_BEFORE:
                log(rc, LOG_MESSAGE,
                    "SWT instrumentation on Linux not required for SWT version %s and forceInstrumentation is false" \
                    % version)
                return
            else:
                log(rc, LOG_MESSAGE,
                    "SWT instrumentation on Linux required for SWT version %s" % version)

        qfsPlugin = findQfsPlugin(rc, qfsHome, ws, theos, arch, version, release, subrelease)
        rc.logMessage("qfsPlugin: %s" % qfsPlugin)

        if qfsPlugin:
            ret = InstrumentSWT().instrument(rc.context, plugin, qfsPlugin, release, theos, ws, arch=="x86_64")
            if ret < 0:
                # already instrumented
                pass
            elif ret == 0:
                # (re-)instrumented, force clean start
                cleanRCP(rc, os.path.dirname(plugin))
            else:
                log(rc, LOG_ERROR, "On-the-fly instrumentation for %s from %s failed" % (plugin, qfsPlugin))
        else:
            errorMessage = "No matching QF-Test plugin found for % s" % os.path.basename(plugin)
            if release >= "3.5" and release[:3] <= "3.8":
                errorMessage += "\nSupport for Eclipse/SWT 3.5 - 3.8 is available from\n" + \
                                "https://archive.qfs.de/pub/qftest/swt_legacy.zip\n" + \
                                "Please extract the contents into the swt directory of your QF-Test installation."
            log(rc, LOG_ERROR, errorMessage)
    if len(plugins) == ignored:
        log(rc, LOG_ERROR, "All plugins were ignored")

# }}}

# --------------------------------------------------------------------------------------------
# instrument
# --------------------------------------------------------------------------------------------
# {{{ instrument

def instrument(rc, appDir, plugin=None, qfsHome=System.getProperty("qftest.versionhome"),
               optInstallLatestVersion=1, force=False):
    """Instrument SWT/RCP application in appDir.
    The Run Context rc is used to print (debug) messages."""

    if force:
        log(rc, LOG_MESSAGE,
            "SWT instrumentation forced via forceInstrumentation")
    elif not force and not (Options.getBoolean(Options.OPT_PLAY_CONNECT_VIA_AGENT) \
                          and Options.getBoolean(Options.OPT_PLAY_SWT_VIA_AGENT)):
        log(rc, LOG_MESSAGE,
            "SWT instrumentation via agent disabled, performing instrumentation")
        force = True
    if not force and not Misc.OS_IS_LINUX:
        log(rc, LOG_MESSAGE,
            "SWT instrumentation not required on Windows and forceInstrumentation is false")
        return

    try:
        if plugin:
            plugins = [plugin]
        else:
            plugins = findPlugins(appDir)
        if len(plugins) > 0:
            instrumentRcp(rc, plugins, qfsHome, optInstallLatestVersion, force=force)
        else:
            swtJarFile = findSwtJar(rc, appDir)
            if swtJarFile == None:
                log(rc, LOG_ERROR,
                    "Neither RCP plugin nor SWT jar file found in application (sub)directory.")
                return

            cpqfs = File(qfsHome + "/..").getCanonicalPath()
            cpapp = File(swtJarFile).getCanonicalPath()
            if os.path.commonprefix([cpqfs, cpapp]) == cpqfs:
                log(rc, LOG_ERROR,
                    "Can not instrument QF-Test home directory.")
                return

            swtJar = SwtJar(swtJarFile)
            log(rc, LOG_MESSAGE, "SWT jar:", swtJarFile, getFileSize(swtJarFile),
                getModifyTime(swtJarFile))
            if not swtJar.containsLibs():
                qfsSwtDir = instrumentSwtLibs(rc, appDir, qfsHome, optInstallLatestVersion, force=force)
            else:
                # since SWT 3.3 M4 the libraries are contained in swt.jar
                qfsSwtDir = getQfsSwtDir(qfsHome, swtJar.getOs(), swtJar.getRelease(), swtJar.get64bit())
                qfsSwtJarFile = os.path.join(qfsSwtDir, os.path.basename(swtJarFile))
                if not installCheck(rc, swtJarFile, qfsSwtJarFile):
                    return
                qfsSwtJar = SwtJar(qfsSwtJarFile)
                if not versionCheck(rc, swtJar.getVersion(), qfsSwtJar.getVersion(),
                                    optInstallLatestVersion):
                    return
            if qfsSwtDir != None:
                installSwt(rc, swtJarFile, os.path.join(qfsSwtDir, os.path.basename(swtJarFile)))
    except InstrumentationError, e:
        log(rc, LOG_ERROR, e)
        renameRollback(rc, renamedFilesLog)
    except:
        renameRollback(rc, renamedFilesLog)
        raise

# }}}
