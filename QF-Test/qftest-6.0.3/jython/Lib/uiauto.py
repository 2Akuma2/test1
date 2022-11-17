from de.qfs.apps.qftest.shared.script.modules import UIAuto as _WrappedUIAuto
#  redirected constants
#  redirected methods
__wrappedInstance = _WrappedUIAuto.instance()
def launchWithDirectory(*command):
    """
    Launches the application, from a given directory.
    
    @param command
    The command to be called.
    @return AutomationApplication that represents the application.
    @throws java.io.IOException
    Cannot start application?
    @throws AutomationException
    Automation library error.
    """
    return __wrappedInstance.launchWithDirectory(command)

def attach(process):
    """
    Attaches to the application process.
    
    @param process
    Process to attach to.
    @return AutomationApplication that represents the application.
    @throws AutomationException
    Automation library error.
    """
    return __wrappedInstance.attach(process)

def launchOrAttach(*command):
    """
    Attaches or launches the application.
    
    @param command
    Command to be started.
    @return AutomationApplication that represents the application.
    @throws java.lang.Exception
    Unable to find process.
    """
    return __wrappedInstance.launchOrAttach(command)

def launchWithWorkingDirectoryOrAttach(*command):
    """ Deprecated, Use launchWithDirectoryOrAttach"""
    return __wrappedInstance.launchWithWorkingDirectoryOrAttach(command)

def launchWithDirectoryOrAttach(*command):
    """
    Attaches or launches the application.
    
    @param command
    Command to be started.
    @return AutomationApplication that represents the application.
    @throws java.lang.Exception
    Unable to find process.
    """
    return __wrappedInstance.launchWithDirectoryOrAttach(command)

def findProcess(*commandOrPattern):
    """
    Finds the given process.
    
    @param commandOrPattern
    Command to look for or a pattern which matches the filename of the application.
    @return The Application.
    @throws Exception
    """
    return __wrappedInstance.findProcess(commandOrPattern)

def getDesktopWindow(titleOrPattern, retries=25):
    """
    Gets the desktop 'window' associated with the title, with a variable
    number of retries.
    
    @param titleOrPattern
    Title to search for or a pattern matching the title.
    @param retries
    Number of attempts to find the window. If not given or 0, it falls back to the
    default number of 25.
    @return AutomationWindow The found window.
    @throws ElementNotFoundException
    Element is not found.
    @throws PatternNotFoundException
    Expected pattern not found.
    """
    return __wrappedInstance.getDesktopWindow(titleOrPattern, retries)

def getWindow(titleOrPattern, retries=25):
    """
    Gets the 'window' associated with the title, with a variable
    number of retries. Searches all currently opened windows.
    
    @param titleOrPattern
    Title to search for or a pattern matching the title.
    @param retries
    Number of attempts to find the window. If not given or 0, it falls back to the
    default number of 25.
    @return AutomationWindow The found window.
    @throws ElementNotFoundException
    Element is not found.
    @throws PatternNotFoundException
    Expected pattern not found.
    """
    return __wrappedInstance.getWindow(titleOrPattern, retries)

def getDesktop():
    """
    Gets the main desktop object.
    
    @return AutomationPanel The found object.
    @throws ElementNotFoundException
    Element is not found.
    @throws PatternNotFoundException
    Expected pattern not found.
    """
    return __wrappedInstance.getDesktop()

def getDesktopObject(titleOrPattern, retries=25):
    """
    Gets the desktop object (panel) associated with the title.
    
    @param titleOrPattern
    Title to search for or a pattern matching the title.
    @param retries
    Number of attempts to find the window. If not given or 0, it falls back to the
    default number of 25.
    @return AutomationPanel The found object.
    @throws ElementNotFoundException
    Element is not found.
    @throws PatternNotFoundException
    Expected pattern not found.
    """
    return __wrappedInstance.getDesktopObject(titleOrPattern, retries)

def getDesktopMenu(title):
    """
    Gets the desktop object associated with the title.
    
    @param title
    Title of the menu to search for.
    @return AutomationMenu The found menu.
    @throws ElementNotFoundException
    Element is not found.
    """
    return __wrappedInstance.getDesktopMenu(title)

def getDesktopWindows():
    """
    Gets the list of desktop windows.
    
    @return List of desktop windows.
    @throws AutomationException
    Something has gone wrong.
    @throws PatternNotFoundException
    Expected pattern not found.
    """
    return __wrappedInstance.getDesktopWindows()

def getDesktopObjects():
    """
    Gets the list of desktop objects.
    
    @return List of desktop object.
    @throws AutomationException
    Something has gone wrong.
    @throws PatternNotFoundException
    Expected pattern not found.
    """
    return __wrappedInstance.getDesktopObjects()

def getControlTypeByName(controlTypeName):
    """
    Returns a control type object, specified by the given name
    
    @param controlTypeName the name of the control type
    
    @return the controlType object
    """
    return __wrappedInstance.getControlTypeByName(controlTypeName)

def getControlTypeByValue(controlTypeValue):
    """
    Returns a control type object, specified by the given integer value
    
    @param controlTypeValue the name of the control type
    
    @return the controlType object
    """
    return __wrappedInstance.getControlTypeByValue(controlTypeValue)

def getControlByPointer(ptr):
    """
    Returns an AutomationBase object, defined by the given pointer
    
    @param ptr Pointer to the UIAutomation element
    
    @return the AutomationBase object or null on error
    """
    return __wrappedInstance.getControlByPointer(ptr)

def getSearch():
    """ Returns the Search class, used to specify search parameters via builder"""
    return __wrappedInstance.getSearch()

def getAutomationPatternClass(patternClassName):
    """
    Returns a Pattern Class, specified by the given Pattern class name
    
    @param patternClassName the name of the control type
    
    @return the controlType object
    """
    return __wrappedInstance.getAutomationPatternClass(patternClassName)

def getAutomationExceptionClass():
    """
    Returns the AutomationException class, for usage in catch statements
    
    @return the AutomationException class
    """
    return __wrappedInstance.getAutomationExceptionClass()

def getControlViewWalker():
    """
    Gets the control view walker.
    
    @return The tree walker object.
    @throws AutomationException
    if something goes wrong.
    """
    return __wrappedInstance.getControlViewWalker()

def dumpControls(parent=None, maxDepth=0):
    """
    Dumps identification data of the given control and all children to the terminal
    
    @param parent
    the control to dump. Defaults to the desktop
    @param maxDepth
    the maximal depth of children to dump. Defaults to infinite
    @throws AutomationException
    if something goes wrong
    @throws PatternNotFoundException
    if the desktop could not be found
    """
    return __wrappedInstance.dumpControls(parent, maxDepth)

def dumpControlsToFile(filename, parent=None, maxDepth=0, charset="UTF-8"):
    """
    Dumps identification data of the given control and all children to a file
    
    @param filename
    the name of the file to dump data to
    @param parent
    the Control object to dump. Defaults to the desktop
    @param maxDepth
    the maximal depth of children to dump. Defaults to infinite
    @param charset
    the charset to use for the dump. Defaults to "UTF-8", other options include "US-ASCII", "ISO-8859-1", and "UTF-16"
    @throws AutomationException
    if something goes wrong
    @throws PatternNotFoundException
    if the desktop could not be found
    """
    __wrappedInstance.dumpControlsToFile(filename, parent, maxDepth, charset)

def setExpectLibsInClasspath(self, expectLibsInClasspath):
    """
    Set to true if jna/ui-automation libraries are willingly on the main classpath and should
    not reported as a warning.
    """
    __wrappedInstance.expectLibsInClasspath = expectLibsInClasspath

expectLibsInClasspath = property(None, setExpectLibsInClasspath)
