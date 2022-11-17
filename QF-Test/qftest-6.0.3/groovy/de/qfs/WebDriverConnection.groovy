package de.qfs
import org.openqa.selenium.WebElement
import org.openqa.selenium.remote.DesiredCapabilities
class WebDriverConnection{
    //  redirected constants
    //  redirected methods
    private final de.qfs.apps.qftest.client.web.webdriver.script.modules.WebDriverConnection __wrappedInstance
    public WebDriverConnection(Object rc){
        __wrappedInstance = de.qfs.apps.qftest.client.web.webdriver.script.modules.WebDriverConnection.instance(rc)
    }
    /**
     * Returns a Selenium WebDriver-Object, without loading up the QF-Test component recognition engine.
     * Be aware that the execution of a "Open Browser Window" loads up the recognition engine for all
     * drivers returned by this method.
     * 
     * @param browserType The browser type, or null if the engine's default browser type should be used, or
     * if specified in the desiredCapabilities.
     * @param desiredCapabilities the desiredCapabilties for the driver. Might be null.
     * @return The synchronized and guarded Selenium WebDriver object
     */
    public org.openqa.selenium.WebDriver getUnmanagedDriver(String browserType=null, DesiredCapabilities desiredCapabilities=null){
        return __wrappedInstance.getUnmanagedDriver(browserType, desiredCapabilities)
    }
    /**
     * Returns a Selenium WebDriver-Object, without loading up the QF-Test component recognition engine.
     * Be aware that the execution of a "Open Browser Window" loads up the recognition engine for all
     * drivers returned by this method.
     * 
     * @param browserType The browser type, or null if the engine's default browser type should be used, or
     * if specified in the desiredCapabilities.
     * @param desiredCapabilities the desiredCapabilties for the driver. Might be null.
     * @return The synchronized and guarded Selenium WebDriver object
     */
    public org.openqa.selenium.WebDriver getUnmanagedDriver(Map mappedParams){
        def browserType = null
        if(mappedParams.containsKey("browserType")){
            browserType = mappedParams.browserType
        }
        def desiredCapabilities = null
        if(mappedParams.containsKey("desiredCapabilities")){
            desiredCapabilities = mappedParams.desiredCapabilities
        }
        return __wrappedInstance.getUnmanagedDriver(browserType, desiredCapabilities)
    }
    /**
     * Get the WebDriver instance used to interact with a browser in webdriver
     * mode. Requires a browse window to be opened by QF-Test using an "Open Browser Window" node
     * or a "Start Browser" node with specified URL.
     * 
     * @param windowname
     * The 'windowname' of the browser of which the driver is
     * requested
     * @return The webdriver instance
     */
    public org.openqa.selenium.WebDriver getDriver(String windowname=null){
        return __wrappedInstance.getDriver(windowname)
    }
    /**
     * Get the WebDriver instance used to interact with a browser in webdriver
     * mode. Requires a browse window to be opened by QF-Test using an "Open Browser Window" node
     * or a "Start Browser" node with specified URL.
     * 
     * @param windowname
     * The 'windowname' of the browser of which the driver is
     * requested
     * @return The webdriver instance
     */
    public org.openqa.selenium.WebDriver getDriver(Map mappedParams){
        if(mappedParams == null){
            return __wrappedInstance.getDriver(mappedParams, windowname)
        }
        def windowname = null
        if(mappedParams.containsKey("windowname")){
            windowname = mappedParams.windowname
        }
        return __wrappedInstance.getDriver(windowname)
    }
    /**
     * Get the WebDriver-WebElement of a component when interacting with a
     * browser using webdriver mode.
     * 
     * @param componentOrID
     * The QF-Test component or its QF-Test component ID
     * @return The WebElement object of the component
     */
    public WebElement getElement(Object componentOrID){
        return __wrappedInstance.getElement(componentOrID)
    }
    /**
     * Get the QF-Test component of a given WebDriver-WebElement
     * 
     * @param element
     * The WebElement
     * @param windowname
     * The 'windowname' of the browser of which the driver is
     * requested
     * @return The component or null if unknown
     */
    public Object getComponent(Object element, String windowname=null){
        return __wrappedInstance.getComponent(element, windowname)
    }
    /**
     * Get the QF-Test component of a given WebDriver-WebElement
     * 
     * @param element
     * The WebElement
     * @param windowname
     * The 'windowname' of the browser of which the driver is
     * requested
     * @return The component or null if unknown
     */
    public Object getComponent(Map mappedParams, Object element){
        if(mappedParams == null){
            return __wrappedInstance.getComponent(mappedParams, element)
        }
        def windowname = null
        if(mappedParams.containsKey("windowname")){
            windowname = mappedParams.windowname
        }
        return __wrappedInstance.getComponent(element, windowname)
    }
    /** Returns the current WebDriver Stack as String */
    public String getWebDriverStack(String windowname=null){
        return __wrappedInstance.getWebDriverStack(windowname)
    }
    /** Returns the current WebDriver Stack as String */
    public String getWebDriverStack(Map mappedParams){
        if(mappedParams == null){
            return __wrappedInstance.getWebDriverStack(mappedParams, windowname)
        }
        def windowname = null
        if(mappedParams.containsKey("windowname")){
            windowname = mappedParams.windowname
        }
        return __wrappedInstance.getWebDriverStack(windowname)
    }
}
