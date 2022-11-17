exports.__esModule = true;
var module$input = exports;
WebDriverConnection = function() {
  _WrappedWebDriverConnection = Java.type("de.qfs.apps.qftest.client.web.webdriver.script.modules.WebDriverConnection");
  var __wrappedInstance;
  function WebDriverConnection(rc) {
    __wrappedInstance = _WrappedWebDriverConnection.instance(rc);
  }
  WebDriverConnection.prototype.getUnmanagedDriver = parameterfy(function(browserType, desiredCapabilities) {
    if (browserType === undefined) {
      browserType = null;
    }
    if (desiredCapabilities === undefined) {
      desiredCapabilities = null;
    }
    return __wrappedInstance.getUnmanagedDriver(browserType, desiredCapabilities);
  });
  WebDriverConnection.prototype.getDriver = parameterfy(function(windowname) {
    if (windowname === undefined) {
      windowname = null;
    }
    return __wrappedInstance.getDriver(windowname);
  });
  WebDriverConnection.prototype.getElement = parameterfy(function(componentOrID) {
    return __wrappedInstance.getElement(componentOrID);
  });
  WebDriverConnection.prototype.getComponent = parameterfy(function(element, windowname) {
    if (windowname === undefined) {
      windowname = null;
    }
    return __wrappedInstance.getComponent(element, windowname);
  });
  WebDriverConnection.prototype.getWebDriverStack = parameterfy(function(windowname) {
    if (windowname === undefined) {
      windowname = null;
    }
    return __wrappedInstance.getWebDriverStack(windowname);
  });
  return WebDriverConnection;
}();
var $jscompDefaultExport = WebDriverConnection;
WebDriver = function() {
  _WrappedWebDriver = Java.type("de.qfs.apps.qftest.client.web.webdriver.script.modules.WebDriver");
  var __wrappedInstance;
  function WebDriver(rc) {
    __wrappedInstance = _WrappedWebDriver.instance(rc);
  }
  WebDriver.prototype.getDriver = parameterfy(function(windowname) {
    if (windowname === undefined) {
      windowname = null;
    }
    return __wrappedInstance.getDriver(windowname);
  });
  WebDriver.prototype.getElement = parameterfy(function(componentOrID) {
    return __wrappedInstance.getElement(componentOrID);
  });
  WebDriver.prototype.getComponent = parameterfy(function(element, windowname) {
    if (windowname === undefined) {
      windowname = null;
    }
    return __wrappedInstance.getComponent(element, windowname);
  });
  return WebDriver;
}();
var $jscompDefaultExport = WebDriver;
module$input.WebDriverConnection = WebDriverConnection;
module$input["default"] = $jscompDefaultExport;
module$input.WebDriver = WebDriver;
