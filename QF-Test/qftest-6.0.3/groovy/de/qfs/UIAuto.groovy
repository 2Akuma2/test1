package de.qfs
import java.util.List
/**
 * Provides a script facade for UIAutomation Library and manages loading of
 * ui-automation.jar in its own classloader
 * 
 * @author Pascal Bihler
 */
class UIAuto{
    //  redirected constants
    //  redirected methods
    private final de.qfs.apps.qftest.shared.script.modules.UIAuto __wrappedInstance
    private static UIAuto __instance = new UIAuto()
    /** @return the Singleton instance */
    static UIAuto instance(){
        return __instance
    }
    /** @return the Singleton instance */
    private UIAuto(){
        __wrappedInstance = de.qfs.apps.qftest.shared.script.modules.UIAuto.instance()
    }
    /**
     * Launches the application, from a given directory.
     * 
     * @param command
     * The command to be called.
     * @return AutomationApplication that represents the application.
     * @throws java.io.IOException
     * Cannot start application?
     * @throws AutomationException
     * Automation library error.
     */
    public Object launchWithDirectory(String... command){
        return __wrappedInstance.launchWithDirectory(command)
    }
    /**
     * Attaches to the application process.
     * 
     * @param process
     * Process to attach to.
     * @return AutomationApplication that represents the application.
     * @throws AutomationException
     * Automation library error.
     */
    public Object attach(Process process){
        return __wrappedInstance.attach(process)
    }
    /**
     * Attaches or launches the application.
     * 
     * @param command
     * Command to be started.
     * @return AutomationApplication that represents the application.
     * @throws java.lang.Exception
     * Unable to find process.
     */
    public Object launchOrAttach(String... command){
        return __wrappedInstance.launchOrAttach(command)
    }
    /** Deprecated, Use launchWithDirectoryOrAttach */
    public Object launchWithWorkingDirectoryOrAttach(String... command){
        return __wrappedInstance.launchWithWorkingDirectoryOrAttach(command)
    }
    /**
     * Attaches or launches the application.
     * 
     * @param command
     * Command to be started.
     * @return AutomationApplication that represents the application.
     * @throws java.lang.Exception
     * Unable to find process.
     */
    public Object launchWithDirectoryOrAttach(String... command){
        return __wrappedInstance.launchWithDirectoryOrAttach(command)
    }
    /**
     * Finds the given process.
     * 
     * @param commandOrPattern
     * Command to look for or a pattern which matches the filename of the application.
     * @return The Application.
     * @throws Exception
     */
    public Object findProcess(Object... commandOrPattern){
        return __wrappedInstance.findProcess(commandOrPattern)
    }
    /**
     * Gets the desktop 'window' associated with the title, with a variable
     * number of retries.
     * 
     * @param titleOrPattern
     * Title to search for or a pattern matching the title.
     * @param retries
     * Number of attempts to find the window. If not given or 0, it falls back to the
     * default number of 25.
     * @return AutomationWindow The found window.
     * @throws ElementNotFoundException
     * Element is not found.
     * @throws PatternNotFoundException
     * Expected pattern not found.
     */
    public Object getDesktopWindow(Object titleOrPattern, int retries=25){
        return __wrappedInstance.getDesktopWindow(titleOrPattern, retries)
    }
    /**
     * Gets the desktop 'window' associated with the title, with a variable
     * number of retries.
     * 
     * @param titleOrPattern
     * Title to search for or a pattern matching the title.
     * @param retries
     * Number of attempts to find the window. If not given or 0, it falls back to the
     * default number of 25.
     * @return AutomationWindow The found window.
     * @throws ElementNotFoundException
     * Element is not found.
     * @throws PatternNotFoundException
     * Expected pattern not found.
     */
    public Object getDesktopWindow(Map mappedParams, Object titleOrPattern){
        if(mappedParams == null){
            return __wrappedInstance.getDesktopWindow(mappedParams, titleOrPattern)
        }
        def retries = 25
        if(mappedParams.containsKey("retries")){
            retries = mappedParams.retries
        }
        return __wrappedInstance.getDesktopWindow(titleOrPattern, retries)
    }
    /**
     * Gets the 'window' associated with the title, with a variable
     * number of retries. Searches all currently opened windows.
     * 
     * @param titleOrPattern
     * Title to search for or a pattern matching the title.
     * @param retries
     * Number of attempts to find the window. If not given or 0, it falls back to the
     * default number of 25.
     * @return AutomationWindow The found window.
     * @throws ElementNotFoundException
     * Element is not found.
     * @throws PatternNotFoundException
     * Expected pattern not found.
     */
    public Object getWindow(Object titleOrPattern, int retries=25){
        return __wrappedInstance.getWindow(titleOrPattern, retries)
    }
    /**
     * Gets the 'window' associated with the title, with a variable
     * number of retries. Searches all currently opened windows.
     * 
     * @param titleOrPattern
     * Title to search for or a pattern matching the title.
     * @param retries
     * Number of attempts to find the window. If not given or 0, it falls back to the
     * default number of 25.
     * @return AutomationWindow The found window.
     * @throws ElementNotFoundException
     * Element is not found.
     * @throws PatternNotFoundException
     * Expected pattern not found.
     */
    public Object getWindow(Map mappedParams, Object titleOrPattern){
        if(mappedParams == null){
            return __wrappedInstance.getWindow(mappedParams, titleOrPattern)
        }
        def retries = 25
        if(mappedParams.containsKey("retries")){
            retries = mappedParams.retries
        }
        return __wrappedInstance.getWindow(titleOrPattern, retries)
    }
    /**
     * Gets the main desktop object.
     * 
     * @return AutomationPanel The found object.
     * @throws ElementNotFoundException
     * Element is not found.
     * @throws PatternNotFoundException
     * Expected pattern not found.
     */
    public Object getDesktop(){
        return __wrappedInstance.getDesktop()
    }
    /**
     * Gets the desktop object (panel) associated with the title.
     * 
     * @param titleOrPattern
     * Title to search for or a pattern matching the title.
     * @param retries
     * Number of attempts to find the window. If not given or 0, it falls back to the
     * default number of 25.
     * @return AutomationPanel The found object.
     * @throws ElementNotFoundException
     * Element is not found.
     * @throws PatternNotFoundException
     * Expected pattern not found.
     */
    public Object getDesktopObject(Object titleOrPattern, int retries=25){
        return __wrappedInstance.getDesktopObject(titleOrPattern, retries)
    }
    /**
     * Gets the desktop object (panel) associated with the title.
     * 
     * @param titleOrPattern
     * Title to search for or a pattern matching the title.
     * @param retries
     * Number of attempts to find the window. If not given or 0, it falls back to the
     * default number of 25.
     * @return AutomationPanel The found object.
     * @throws ElementNotFoundException
     * Element is not found.
     * @throws PatternNotFoundException
     * Expected pattern not found.
     */
    public Object getDesktopObject(Map mappedParams, Object titleOrPattern){
        if(mappedParams == null){
            return __wrappedInstance.getDesktopObject(mappedParams, titleOrPattern)
        }
        def retries = 25
        if(mappedParams.containsKey("retries")){
            retries = mappedParams.retries
        }
        return __wrappedInstance.getDesktopObject(titleOrPattern, retries)
    }
    /**
     * Gets the desktop object associated with the title.
     * 
     * @param title
     * Title of the menu to search for.
     * @return AutomationMenu The found menu.
     * @throws ElementNotFoundException
     * Element is not found.
     */
    public Object getDesktopMenu(String title){
        return __wrappedInstance.getDesktopMenu(title)
    }
    /**
     * Gets the list of desktop windows.
     * 
     * @return List of desktop windows.
     * @throws AutomationException
     * Something has gone wrong.
     * @throws PatternNotFoundException
     * Expected pattern not found.
     */
    public List<Object> getDesktopWindows(){
        return __wrappedInstance.getDesktopWindows()
    }
    /**
     * Gets the list of desktop objects.
     * 
     * @return List of desktop object.
     * @throws AutomationException
     * Something has gone wrong.
     * @throws PatternNotFoundException
     * Expected pattern not found.
     */
    public List<Object> getDesktopObjects(){
        return __wrappedInstance.getDesktopObjects()
    }
    /**
     * Returns a control type object, specified by the given name
     * 
     * @param controlTypeName the name of the control type
     * 
     * @return the controlType object
     */
    public Object getControlTypeByName(String controlTypeName){
        return __wrappedInstance.getControlTypeByName(controlTypeName)
    }
    /**
     * Returns a control type object, specified by the given integer value
     * 
     * @param controlTypeValue the name of the control type
     * 
     * @return the controlType object
     */
    public Object getControlTypeByValue(int controlTypeValue){
        return __wrappedInstance.getControlTypeByValue(controlTypeValue)
    }
    /**
     * Returns an AutomationBase object, defined by the given pointer
     * 
     * @param ptr Pointer to the UIAutomation element
     * 
     * @return the AutomationBase object or null on error
     */
    public Object getControlByPointer(long ptr){
        return __wrappedInstance.getControlByPointer(ptr)
    }
    /** Returns the Search class, used to specify search parameters via builder */
    public Class getSearch(){
        return __wrappedInstance.getSearch()
    }
    /**
     * Returns a Pattern Class, specified by the given Pattern class name
     * 
     * @param patternClassName the name of the control type
     * 
     * @return the controlType object
     */
    public Class getAutomationPatternClass(String patternClassName){
        return __wrappedInstance.getAutomationPatternClass(patternClassName)
    }
    /**
     * Returns the AutomationException class, for usage in catch statements
     * 
     * @return the AutomationException class
     */
    public Class getAutomationExceptionClass(){
        return __wrappedInstance.getAutomationExceptionClass()
    }
    /**
     * Gets the control view walker.
     * 
     * @return The tree walker object.
     * @throws AutomationException
     * if something goes wrong.
     */
    public Object getControlViewWalker(){
        return __wrappedInstance.getControlViewWalker()
    }
    /**
     * Dumps identification data of the given control and all children to the terminal
     * 
     * @param parent
     * the control to dump. Defaults to the desktop
     * @param maxDepth
     * the maximal depth of children to dump. Defaults to infinite
     * @throws AutomationException
     * if something goes wrong
     * @throws PatternNotFoundException
     * if the desktop could not be found
     */
    public String dumpControls(Object parent=null, int maxDepth=0){
        return __wrappedInstance.dumpControls(parent, maxDepth)
    }
    /**
     * Dumps identification data of the given control and all children to the terminal
     * 
     * @param parent
     * the control to dump. Defaults to the desktop
     * @param maxDepth
     * the maximal depth of children to dump. Defaults to infinite
     * @throws AutomationException
     * if something goes wrong
     * @throws PatternNotFoundException
     * if the desktop could not be found
     */
    public String dumpControls(Map mappedParams){
        def parent = null
        if(mappedParams.containsKey("parent")){
            parent = mappedParams.parent
        }
        def maxDepth = 0
        if(mappedParams.containsKey("maxDepth")){
            maxDepth = mappedParams.maxDepth
        }
        return __wrappedInstance.dumpControls(parent, maxDepth)
    }
    /**
     * Dumps identification data of the given control and all children to a file
     * 
     * @param filename
     * the name of the file to dump data to
     * @param parent
     * the Control object to dump. Defaults to the desktop
     * @param maxDepth
     * the maximal depth of children to dump. Defaults to infinite
     * @param charset
     * the charset to use for the dump. Defaults to "UTF-8", other options include "US-ASCII", "ISO-8859-1", and "UTF-16"
     * @throws AutomationException
     * if something goes wrong
     * @throws PatternNotFoundException
     * if the desktop could not be found
     */
    public void dumpControlsToFile(String filename, Object parent=null, int maxDepth=0, String charset="UTF-8"){
        __wrappedInstance.dumpControlsToFile(filename, parent, maxDepth, charset)
    }
    /**
     * Dumps identification data of the given control and all children to a file
     * 
     * @param filename
     * the name of the file to dump data to
     * @param parent
     * the Control object to dump. Defaults to the desktop
     * @param maxDepth
     * the maximal depth of children to dump. Defaults to infinite
     * @param charset
     * the charset to use for the dump. Defaults to "UTF-8", other options include "US-ASCII", "ISO-8859-1", and "UTF-16"
     * @throws AutomationException
     * if something goes wrong
     * @throws PatternNotFoundException
     * if the desktop could not be found
     */
    public void dumpControlsToFile(Map mappedParams, String filename){
        def parent = null
        if(mappedParams.containsKey("parent")){
            parent = mappedParams.parent
        }
        def maxDepth = 0
        if(mappedParams.containsKey("maxDepth")){
            maxDepth = mappedParams.maxDepth
        }
        def charset = "UTF-8"
        if(mappedParams.containsKey("charset")){
            charset = mappedParams.charset
        }
        __wrappedInstance.dumpControlsToFile(filename, parent, maxDepth, charset)
    }
    /**
     * Set to true if jna/ui-automation libraries are willingly on the main classpath and should
     * not reported as a warning.
     */
    public void setExpectLibsInClasspath(boolean expectLibsInClasspath){
        __wrappedInstance.expectLibsInClasspath = expectLibsInClasspath
    }
}
