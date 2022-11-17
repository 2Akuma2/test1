from de.qfs.apps.qftest.client.script.modules import RunEngine as _WrappedRunEngine
#  redirected methods
def runAndroid(languageName, cmd, timeout=5000):
    return _WrappedRunEngine.runAndroid(languageName, cmd, timeout)

def runAWT(languageName, cmd, timeout=5000):
    return _WrappedRunEngine.runAWT(languageName, cmd, timeout)

def runSWT(languageName, cmd, timeout=5000):
    return _WrappedRunEngine.runSWT(languageName, cmd, timeout)

def runWeb(languageName, cmd, timeout=5000):
    return _WrappedRunEngine.runWeb(languageName, cmd, timeout)

def runFX(languageName, cmd, timeout=5000):
    return _WrappedRunEngine.runFX(languageName, cmd, timeout)

def runWin(languageName, cmd, timeout=5000):
    return _WrappedRunEngine.runWin(languageName, cmd, timeout)

def runCmd(languageName, cmd):
    return _WrappedRunEngine.runCmd(languageName, cmd)

