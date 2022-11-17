exports.__esModule = true;
var module$input = exports;
SutContext = function() {
  _WrappedSutContext = Java.type("de.qfs.apps.qftest.client.script.modules.SutContext");
  SutContext.OK = SutContext.prototype.OK = _WrappedSutContext.OK;
  SutContext.WARNING = SutContext.prototype.WARNING = _WrappedSutContext.WARNING;
  SutContext.ERROR = SutContext.prototype.ERROR = _WrappedSutContext.ERROR;
  SutContext.EXCEPTION = SutContext.prototype.EXCEPTION = _WrappedSutContext.EXCEPTION;
  SutContext.SKIPPED = SutContext.prototype.SKIPPED = _WrappedSutContext.SKIPPED;
  SutContext.NOT_IMPLEMENTED = SutContext.prototype.NOT_IMPLEMENTED = _WrappedSutContext.NOT_IMPLEMENTED;
  var __wrappedInstance;
  function SutContext(language) {
    __wrappedInstance = _WrappedSutContext.instance(language);
  }
  SutContext.prototype.expand = parameterfy(function(text) {
    return __wrappedInstance.expand(text);
  });
  SutContext.prototype.getComponent = parameterfy(function(id, timeout, hidden) {
    if (timeout === undefined) {
      timeout = -1;
    }
    if (hidden === undefined) {
      hidden = false;
    }
    return __wrappedInstance.getComponent(id, timeout, hidden);
  });
  SutContext.prototype.getLastComponent = parameterfy(function() {
    return __wrappedInstance.getLastComponent();
  });
  SutContext.prototype.getLastItem = parameterfy(function() {
    return __wrappedInstance.getLastItem();
  });
  SutContext.prototype.callProcedure = parameterfy(function(procname, parameters) {
    if (parameters === undefined) {
      parameters = null;
    }
    return __wrappedInstance.callProcedure(procname, parameters);
  });
  SutContext.prototype.toServer = parameterfy(function(vars) {
    __wrappedInstance.toServer(vars);
  });
  SutContext.prototype.fromServer = parameterfy(function(name) {
    return __wrappedInstance.fromServer(name);
  });
  SutContext.prototype.overrideElement = parameterfy(function(id, element) {
    __wrappedInstance.overrideElement(id, element);
  });
  SutContext.prototype.pushScope = parameterfy(function(focusID, element) {
    __wrappedInstance.pushScope(focusID, element);
  });
  SutContext.prototype.getAndPushScope = parameterfy(function(id) {
    __wrappedInstance.getAndPushScope(id);
  });
  SutContext.prototype.popScope = parameterfy(function(elementOrScopeId, popChildren) {
    if (elementOrScopeId === undefined) {
      elementOrScopeId = null;
    }
    if (popChildren === undefined) {
      popChildren = true;
    }
    __wrappedInstance.popScope(elementOrScopeId, popChildren);
  });
  SutContext.prototype.resetScope = parameterfy(function() {
    __wrappedInstance.resetScope();
  });
  SutContext.prototype.dynamicOverrideElement = parameterfy(function(id, provider) {
    __wrappedInstance.dynamicOverrideElement(id, provider);
  });
  SutContext.prototype.blockHardEvents = parameterfy(function() {
    __wrappedInstance.blockHardEvents();
  });
  SutContext.prototype.unblockHardEvents = parameterfy(function() {
    __wrappedInstance.unblockHardEvents();
  });
  SutContext.prototype.getEngine = parameterfy(function() {
    return __wrappedInstance.getEngine();
  });
  SutContext.prototype.setEngine = parameterfy(function(engine) {
    __wrappedInstance.setEngine(engine);
  });
  SutContext.prototype.getAccess = parameterfy(function() {
    return __wrappedInstance.getAccess();
  });
  SutContext.prototype.setAccess = parameterfy(function(access) {
    __wrappedInstance.setAccess(access);
  });
  SutContext.prototype.setExContext = parameterfy(function(exContext) {
    __wrappedInstance.setExContext(exContext);
  });
  SutContext.prototype.getExContext = parameterfy(function() {
    return __wrappedInstance.getExContext();
  });
  SutContext.prototype.setContext = parameterfy(function(context) {
    __wrappedInstance.setContext(context);
  });
  SutContext.prototype.getContext = parameterfy(function() {
    return __wrappedInstance.getContext();
  });
  SutContext.prototype._pushVars = parameterfy(function(context, access, engine) {
    __wrappedInstance._pushVars(context, access, engine);
  });
  SutContext.prototype._popVars = parameterfy(function() {
    __wrappedInstance._popVars();
  });
  SutContext.prototype.logMessage = parameterfy(function(message, dontcompactify, report, nowrap) {
    if (dontcompactify === undefined) {
      dontcompactify = false;
    }
    if (report === undefined) {
      report = false;
    }
    if (nowrap === undefined) {
      nowrap = false;
    }
    __wrappedInstance.logMessage(message, dontcompactify, report, nowrap);
  });
  SutContext.prototype.logWarning = parameterfy(function(message, report, nowrap) {
    if (report === undefined) {
      report = true;
    }
    if (nowrap === undefined) {
      nowrap = false;
    }
    __wrappedInstance.logWarning(message, report, nowrap);
  });
  SutContext.prototype.logError = parameterfy(function(message, nowrap) {
    if (nowrap === undefined) {
      nowrap = false;
    }
    __wrappedInstance.logError(message, nowrap);
  });
  SutContext.prototype.logImage = parameterfy(function(image, title, dontcompactify, report) {
    if (title === undefined) {
      title = null;
    }
    if (dontcompactify === undefined) {
      dontcompactify = false;
    }
    if (report === undefined) {
      report = false;
    }
    __wrappedInstance.logImage(image, title, dontcompactify, report);
  });
  SutContext.prototype.check = parameterfy(function(condition, message, level, report, nowrap) {
    if (level === undefined) {
      level = 2;
    }
    if (report === undefined) {
      report = true;
    }
    if (nowrap === undefined) {
      nowrap = false;
    }
    return __wrappedInstance.check(condition, message, level, report, nowrap);
  });
  SutContext.prototype.checkEqual = parameterfy(function(actual, expected, message, level, report, nowrap) {
    if (level === undefined) {
      level = 2;
    }
    if (report === undefined) {
      report = true;
    }
    if (nowrap === undefined) {
      nowrap = false;
    }
    return __wrappedInstance.checkEqual(actual, expected, message, level, report, nowrap);
  });
  SutContext.prototype.checkImage = parameterfy(function(actual, expected, message, level, report, nowrap) {
    if (level === undefined) {
      level = 2;
    }
    if (report === undefined) {
      report = true;
    }
    if (nowrap === undefined) {
      nowrap = false;
    }
    return __wrappedInstance.checkImage(actual, expected, message, level, report, nowrap);
  });
  SutContext.prototype.checkImageAdvanced = parameterfy(function(actual, expected, message, algorithm, level, report, nowrap) {
    if (level === undefined) {
      level = 2;
    }
    if (report === undefined) {
      report = true;
    }
    if (nowrap === undefined) {
      nowrap = false;
    }
    return __wrappedInstance.checkImageAdvanced(actual, expected, message, algorithm, level, report, nowrap);
  });
  SutContext.prototype.getStr = parameterfy(function(var1, var2, expand) {
    if (var2 === undefined) {
      var2 = null;
    }
    if (expand === undefined) {
      expand = true;
    }
    return __wrappedInstance.getStr(var1, var2, expand);
  });
  SutContext.prototype.getPattern = parameterfy(function(var1, var2, expand) {
    if (var2 === undefined) {
      var2 = null;
    }
    if (expand === undefined) {
      expand = true;
    }
    return __wrappedInstance.getPattern(var1, var2, expand);
  });
  SutContext.prototype.getInt = parameterfy(function(var1, var2, expand) {
    if (var2 === undefined) {
      var2 = null;
    }
    if (expand === undefined) {
      expand = true;
    }
    return __wrappedInstance.getInt(var1, var2, expand);
  });
  SutContext.prototype.getNum = parameterfy(function(var1, var2, expand) {
    if (var2 === undefined) {
      var2 = null;
    }
    if (expand === undefined) {
      expand = true;
    }
    return __wrappedInstance.getNum(var1, var2, expand);
  });
  SutContext.prototype.getBool = parameterfy(function(var1, var2, expand) {
    if (var2 === undefined) {
      var2 = null;
    }
    if (expand === undefined) {
      expand = true;
    }
    return __wrappedInstance.getBool(var1, var2, expand);
  });
  SutContext.prototype.lookup = parameterfy(function(var1, var2, expand) {
    if (var2 === undefined) {
      var2 = null;
    }
    if (expand === undefined) {
      expand = true;
    }
    return __wrappedInstance.lookup(var1, var2, expand);
  });
  SutContext.prototype.setGlobal = parameterfy(function(name, value) {
    __wrappedInstance.setGlobal(name, value);
  });
  SutContext.prototype.setLocal = parameterfy(function(name, value) {
    __wrappedInstance.setLocal(name, value);
  });
  SutContext.prototype.setProperty = parameterfy(function(group, name, value) {
    __wrappedInstance.setProperty(group, name, value);
  });
  SutContext.prototype.getGlobals = parameterfy(function() {
    return __wrappedInstance.getGlobals();
  });
  SutContext.prototype.getLocals = parameterfy(function(nonEmpty) {
    if (nonEmpty === undefined) {
      nonEmpty = false;
    }
    return __wrappedInstance.getLocals(nonEmpty);
  });
  SutContext.prototype.getProperties = parameterfy(function(group) {
    return __wrappedInstance.getProperties(group);
  });
  SutContext.prototype.stopTest = parameterfy(function() {
    __wrappedInstance.stopTest();
  });
  SutContext.prototype.stopTestCase = parameterfy(function(expectedFail) {
    if (expectedFail === undefined) {
      expectedFail = false;
    }
    __wrappedInstance.stopTestCase(expectedFail);
  });
  SutContext.prototype.stopTestSet = parameterfy(function() {
    __wrappedInstance.stopTestSet();
  });
  SutContext.prototype.skipTestCase = parameterfy(function() {
    __wrappedInstance.skipTestCase();
  });
  SutContext.prototype.skipTestSet = parameterfy(function() {
    __wrappedInstance.skipTestSet();
  });
  SutContext.prototype.getOption = parameterfy(function(name) {
    return __wrappedInstance.getOption(name);
  });
  SutContext.prototype.setOption = parameterfy(function(name, value) {
    __wrappedInstance.setOption(name, value);
  });
  SutContext.prototype.unsetOption = parameterfy(function(name, ignored) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 1;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 1] = arguments[$jscomp$restIndex];
    }
    var ignored$0 = $jscomp$restParams;
    if (ignored$0) {
      __wrappedInstance.unsetOption(name, ignored$0);
    } else {
      __wrappedInstance.unsetOption(name);
    }
  });
  SutContext.prototype.isOptionSet = parameterfy(function(name) {
    return __wrappedInstance.isOptionSet(name);
  });
  SutContext.prototype.id = parameterfy(function(id) {
    return __wrappedInstance.id(id);
  });
  SutContext.prototype.valueToBoolean = parameterfy(function(value) {
    return __wrappedInstance.valueToBoolean(value);
  });
  SutContext.prototype.logData = parameterfy(function(name, kw) {
    if (name === undefined) {
      name = null;
    }
    if (kw === undefined) {
      kw = null;
    }
    __wrappedInstance.logData(name, kw);
  });
  SutContext.prototype.logNode = parameterfy(function(node) {
    __wrappedInstance.logNode(node);
  });
  SutContext.prototype.execHTTPRequest = parameterfy(function(url, method, query, logresponse, responsevar, islocal, timeout, statusCodeVar, timeoutRet, responseHeaders, headerMap, statusCodeErrorLevel) {
    if (responsevar === undefined) {
      responsevar = null;
    }
    if (islocal === undefined) {
      islocal = false;
    }
    if (timeout === undefined) {
      timeout = null;
    }
    if (statusCodeVar === undefined) {
      statusCodeVar = null;
    }
    if (timeoutRet === undefined) {
      timeoutRet = null;
    }
    if (responseHeaders === undefined) {
      responseHeaders = null;
    }
    if (headerMap === undefined) {
      headerMap = null;
    }
    if (statusCodeErrorLevel === undefined) {
      statusCodeErrorLevel = 3;
    }
    return __wrappedInstance.execHTTPRequest(url, method, query, logresponse, responsevar, islocal, timeout, statusCodeVar, timeoutRet, responseHeaders, headerMap, statusCodeErrorLevel);
  });
  return SutContext;
}();
var $jscompDefaultExport = SutContext;
module$input.SutContext = SutContext;
module$input["default"] = $jscompDefaultExport;
