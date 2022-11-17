package de.qfs
import org.openqa.selenium.WebElement
class WebDriver{
    //  redirected constants
    //  redirected methods
    private final de.qfs.apps.qftest.client.web.webdriver.script.modules.WebDriver __wrappedInstance
    public WebDriver(Object rc){
        __wrappedInstance = de.qfs.apps.qftest.client.web.webdriver.script.modules.WebDriver.instance(rc)
    }
    /** Deprecated API, use the WebDriverConnection object instead */
    public org.openqa.selenium.WebDriver getDriver(String windowname=null){
        return __wrappedInstance.getDriver(windowname)
    }
    /** Deprecated API, use the WebDriverConnection object instead */
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
    /** Deprecated API, use the WebDriverConnection object instead */
    public WebElement getElement(Object componentOrID){
        return __wrappedInstance.getElement(componentOrID)
    }
    /** Deprecated API, use the WebDriverConnection object instead */
    public Object getComponent(Object element, String windowname=null){
        return __wrappedInstance.getComponent(element, windowname)
    }
    /** Deprecated API, use the WebDriverConnection object instead */
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
}
