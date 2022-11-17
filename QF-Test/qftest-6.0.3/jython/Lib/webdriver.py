from de.qfs.apps.qftest.client.web.webdriver.script.modules import WebDriverConnection as _WrappedWebDriverConnection
class WebDriverConnection(object):
    #  redirected constants
    #  redirected methods
    def __init__(self, rc):
        self.__wrappedInstance = _WrappedWebDriverConnection.instance(rc)
    
    def getUnmanagedDriver(self, browserType=None, desiredCapabilities=None):
        """
        Returns a Selenium WebDriver-Object, without loading up the QF-Test component recognition engine.
        Be aware that the execution of a "Open Browser Window" loads up the recognition engine for all
        drivers returned by this method.
        
        @param browserType The browser type, or null if the engine's default browser type should be used, or
        if specified in the desiredCapabilities.
        @param desiredCapabilities the desiredCapabilties for the driver. Might be null.
        @return The synchronized and guarded Selenium WebDriver object
        """
        return self.__wrappedInstance.getUnmanagedDriver(browserType, desiredCapabilities)
    
    def getDriver(self, windowname=None):
        """
        Get the WebDriver instance used to interact with a browser in webdriver
        mode. Requires a browse window to be opened by QF-Test using an "Open Browser Window" node
        or a "Start Browser" node with specified URL.
        
        @param windowname
        The 'windowname' of the browser of which the driver is
        requested
        @return The webdriver instance
        """
        return self.__wrappedInstance.getDriver(windowname)
    
    def getElement(self, componentOrID):
        """
        Get the WebDriver-WebElement of a component when interacting with a
        browser using webdriver mode.
        
        @param componentOrID
        The QF-Test component or its QF-Test component ID
        @return The WebElement object of the component
        """
        return self.__wrappedInstance.getElement(componentOrID)
    
    def getComponent(self, element, windowname=None):
        """
        Get the QF-Test component of a given WebDriver-WebElement
        
        @param element
        The WebElement
        @param windowname
        The 'windowname' of the browser of which the driver is
        requested
        @return The component or null if unknown
        """
        return self.__wrappedInstance.getComponent(element, windowname)
    
    def getWebDriverStack(self, windowname=None):
        """ Returns the current WebDriver Stack as String"""
        return self.__wrappedInstance.getWebDriverStack(windowname)
    

from de.qfs.apps.qftest.client.web.webdriver.script.modules import WebDriver as _WrappedWebDriver
class WebDriver(object):
    #  redirected constants
    #  redirected methods
    def __init__(self, rc):
        self.__wrappedInstance = _WrappedWebDriver.instance(rc)
    
    def getDriver(self, windowname=None):
        """ Deprecated API, use the WebDriverConnection object instead"""
        return self.__wrappedInstance.getDriver(windowname)
    
    def getElement(self, componentOrID):
        """ Deprecated API, use the WebDriverConnection object instead"""
        return self.__wrappedInstance.getElement(componentOrID)
    
    def getComponent(self, element, windowname=None):
        """ Deprecated API, use the WebDriverConnection object instead"""
        return self.__wrappedInstance.getComponent(element, windowname)
    

