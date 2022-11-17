exports.__esModule = true;
var module$input = exports;
ServerContext = function() {
  _WrappedServerContext = Java.type("de.qfs.apps.qftest.script.modules.ServerContext");
  ServerContext.OK = ServerContext.prototype.OK = _WrappedServerContext.OK;
  ServerContext.WARNING = ServerContext.prototype.WARNING = _WrappedServerContext.WARNING;
  ServerContext.ERROR = ServerContext.prototype.ERROR = _WrappedServerContext.ERROR;
  ServerContext.EXCEPTION = ServerContext.prototype.EXCEPTION = _WrappedServerContext.EXCEPTION;
  ServerContext.SKIPPED = ServerContext.prototype.SKIPPED = _WrappedServerContext.SKIPPED;
  ServerContext.NOT_IMPLEMENTED = ServerContext.prototype.NOT_IMPLEMENTED = _WrappedServerContext.NOT_IMPLEMENTED;
  var __wrappedInstance;
  function ServerContext(languageName) {
    __wrappedInstance = _WrappedServerContext.instance(languageName);
  }
  ServerContext.prototype.callProcedure = parameterfy(function(procname, parameters) {
    if (parameters === undefined) {
      parameters = null;
    }
    return __wrappedInstance.callProcedure(procname, parameters);
  });
  ServerContext.prototype.expand = parameterfy(function(text) {
    return __wrappedInstance.expand(text);
  });
  ServerContext.prototype.addResetListener = parameterfy(function(listener) {
    __wrappedInstance.addResetListener(listener);
  });
  ServerContext.prototype.removeResetListener = parameterfy(function(listener) {
    return __wrappedInstance.removeResetListener(listener);
  });
  ServerContext.prototype.isResetListenerRegistered = parameterfy(function(listener) {
    return __wrappedInstance.isResetListenerRegistered(listener);
  });
  ServerContext.prototype.flushLog = parameterfy(function() {
    __wrappedInstance.flushLog();
  });
  ServerContext.prototype.getLastException = parameterfy(function() {
    return __wrappedInstance.getLastException();
  });
  ServerContext.prototype.getCaughtException = parameterfy(function() {
    return __wrappedInstance.getCaughtException();
  });
  ServerContext.prototype.logDiagnostics = parameterfy(function(client, engine) {
    if (engine === undefined) {
      engine = null;
    }
    __wrappedInstance.logDiagnostics(client, engine);
  });
  ServerContext.prototype.toSUT = parameterfy(function(client, vars) {
    __wrappedInstance.toSUT(client, vars);
  });
  ServerContext.prototype.fromSUT = parameterfy(function(client, name) {
    return __wrappedInstance.fromSUT(client, name);
  });
  ServerContext.prototype.clearGlobals = parameterfy(function() {
    __wrappedInstance.clearGlobals();
  });
  ServerContext.prototype.getPropertyGroupNames = parameterfy(function() {
    return __wrappedInstance.getPropertyGroupNames();
  });
  ServerContext.prototype.clearProperties = parameterfy(function(group) {
    __wrappedInstance.clearProperties(group);
  });
  ServerContext.prototype.syncThreads = parameterfy(function(id, timeout, count, remote, raise) {
    if (count === undefined) {
      count = -1;
    }
    if (remote === undefined) {
      remote = 0;
    }
    if (raise === undefined) {
      raise = true;
    }
    return __wrappedInstance.syncThreads(id, timeout, count, remote, raise);
  });
  ServerContext.prototype.addDaemonLog = parameterfy(function(data, name, comment, externalizename) {
    if (name === undefined) {
      name = null;
    }
    if (comment === undefined) {
      comment = null;
    }
    if (externalizename === undefined) {
      externalizename = null;
    }
    __wrappedInstance.addDaemonLog(data, name, comment, externalizename);
  });
  ServerContext.prototype.callTest = parameterfy(function(testname, parameters) {
    if (parameters === undefined) {
      parameters = null;
    }
    return __wrappedInstance.callTest(testname, parameters);
  });
  ServerContext.prototype.callTestAsProcedure = parameterfy(function(testname, parameters) {
    if (parameters === undefined) {
      parameters = null;
    }
    return __wrappedInstance.callTestAsProcedure(testname, parameters);
  });
  ServerContext.prototype.runCleanup = parameterfy(function(dependency) {
    if (dependency === undefined) {
      dependency = null;
    }
    __wrappedInstance.runCleanup(dependency);
  });
  ServerContext.prototype.addDataBinder = parameterfy(function(identifier, binder, counterName, intervals) {
    if (counterName === undefined) {
      counterName = null;
    }
    if (intervals === undefined) {
      intervals = null;
    }
    __wrappedInstance.addDataBinder(identifier, binder, counterName, intervals);
  });
  ServerContext.prototype.getEngine = parameterfy(function(id) {
    return __wrappedInstance.getEngine(id);
  });
  ServerContext.prototype.addTestRunListener = parameterfy(function(listener) {
    __wrappedInstance.addTestRunListener(listener);
  });
  ServerContext.prototype.removeTestRunListener = parameterfy(function(listener) {
    __wrappedInstance.removeTestRunListener(listener);
  });
  ServerContext.prototype.clearTestRunListeners = parameterfy(function() {
    __wrappedInstance.clearTestRunListeners();
  });
  ServerContext.prototype.getConnectedClients = parameterfy(function() {
    return __wrappedInstance.getConnectedClients();
  });
  ServerContext.prototype.resolveDependency = parameterfy(function(dep, namespace, params) {
    if (params === undefined) {
      params = null;
    }
    __wrappedInstance.resolveDependency(dep, namespace, params);
  });
  ServerContext.prototype.resolveDependency = parameterfy(function(dep, params) {
    if (params === undefined) {
      params = null;
    }
    __wrappedInstance.resolveDependency(dep, params);
  });
  ServerContext.prototype.rollbackDependencies = parameterfy(function(namespace) {
    if (namespace === undefined) {
      namespace = null;
    }
    __wrappedInstance.rollbackDependencies(namespace);
  });
  ServerContext.prototype.resetDependencies = parameterfy(function(namespace) {
    if (namespace === undefined) {
      namespace = null;
    }
    __wrappedInstance.resetDependencies(namespace);
  });
  ServerContext.prototype.setContext = parameterfy(function(context) {
    __wrappedInstance.setContext(context);
  });
  ServerContext.prototype.getContext = parameterfy(function() {
    return __wrappedInstance.getContext();
  });
  ServerContext.prototype._setSharedContext = parameterfy(function(context) {
    __wrappedInstance._setSharedContext(context);
  });
  ServerContext.prototype._setLocalContext = parameterfy(function(context) {
    __wrappedInstance._setLocalContext(context);
  });
  ServerContext.prototype.logMessage = parameterfy(function(message, dontcompactify, report, nowrap) {
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
  ServerContext.prototype.logWarning = parameterfy(function(message, report, nowrap) {
    if (report === undefined) {
      report = true;
    }
    if (nowrap === undefined) {
      nowrap = false;
    }
    __wrappedInstance.logWarning(message, report, nowrap);
  });
  ServerContext.prototype.logError = parameterfy(function(message, nowrap) {
    if (nowrap === undefined) {
      nowrap = false;
    }
    __wrappedInstance.logError(message, nowrap);
  });
  ServerContext.prototype.logImage = parameterfy(function(image, title, dontcompactify, report) {
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
  ServerContext.prototype.check = parameterfy(function(condition, message, level, report, nowrap) {
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
  ServerContext.prototype.checkEqual = parameterfy(function(actual, expected, message, level, report, nowrap) {
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
  ServerContext.prototype.checkImage = parameterfy(function(actual, expected, message, level, report, nowrap) {
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
  ServerContext.prototype.checkImageAdvanced = parameterfy(function(actual, expected, message, algorithm, level, report, nowrap) {
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
  ServerContext.prototype.getStr = parameterfy(function(var1, var2, expand) {
    if (var2 === undefined) {
      var2 = null;
    }
    if (expand === undefined) {
      expand = true;
    }
    return __wrappedInstance.getStr(var1, var2, expand);
  });
  ServerContext.prototype.getPattern = parameterfy(function(var1, var2, expand) {
    if (var2 === undefined) {
      var2 = null;
    }
    if (expand === undefined) {
      expand = true;
    }
    return __wrappedInstance.getPattern(var1, var2, expand);
  });
  ServerContext.prototype.getInt = parameterfy(function(var1, var2, expand) {
    if (var2 === undefined) {
      var2 = null;
    }
    if (expand === undefined) {
      expand = true;
    }
    return __wrappedInstance.getInt(var1, var2, expand);
  });
  ServerContext.prototype.getNum = parameterfy(function(var1, var2, expand) {
    if (var2 === undefined) {
      var2 = null;
    }
    if (expand === undefined) {
      expand = true;
    }
    return __wrappedInstance.getNum(var1, var2, expand);
  });
  ServerContext.prototype.getBool = parameterfy(function(var1, var2, expand) {
    if (var2 === undefined) {
      var2 = null;
    }
    if (expand === undefined) {
      expand = true;
    }
    return __wrappedInstance.getBool(var1, var2, expand);
  });
  ServerContext.prototype.lookup = parameterfy(function(var1, var2, expand) {
    if (var2 === undefined) {
      var2 = null;
    }
    if (expand === undefined) {
      expand = true;
    }
    return __wrappedInstance.lookup(var1, var2, expand);
  });
  ServerContext.prototype.setGlobal = parameterfy(function(name, value) {
    __wrappedInstance.setGlobal(name, value);
  });
  ServerContext.prototype.setLocal = parameterfy(function(name, value) {
    __wrappedInstance.setLocal(name, value);
  });
  ServerContext.prototype.setProperty = parameterfy(function(group, name, value) {
    __wrappedInstance.setProperty(group, name, value);
  });
  ServerContext.prototype.getGlobals = parameterfy(function() {
    return __wrappedInstance.getGlobals();
  });
  ServerContext.prototype.getLocals = parameterfy(function(nonEmpty) {
    if (nonEmpty === undefined) {
      nonEmpty = false;
    }
    return __wrappedInstance.getLocals(nonEmpty);
  });
  ServerContext.prototype.getProperties = parameterfy(function(group) {
    return __wrappedInstance.getProperties(group);
  });
  ServerContext.prototype.stopTest = parameterfy(function() {
    __wrappedInstance.stopTest();
  });
  ServerContext.prototype.stopTestCase = parameterfy(function(expectedFail) {
    if (expectedFail === undefined) {
      expectedFail = false;
    }
    __wrappedInstance.stopTestCase(expectedFail);
  });
  ServerContext.prototype.stopTestSet = parameterfy(function() {
    __wrappedInstance.stopTestSet();
  });
  ServerContext.prototype.skipTestCase = parameterfy(function() {
    __wrappedInstance.skipTestCase();
  });
  ServerContext.prototype.skipTestSet = parameterfy(function() {
    __wrappedInstance.skipTestSet();
  });
  ServerContext.prototype.getOption = parameterfy(function(name) {
    return __wrappedInstance.getOption(name);
  });
  ServerContext.prototype.setOption = parameterfy(function(name, value) {
    __wrappedInstance.setOption(name, value);
  });
  ServerContext.prototype.unsetOption = parameterfy(function(name, ignored) {
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
  ServerContext.prototype.isOptionSet = parameterfy(function(name) {
    return __wrappedInstance.isOptionSet(name);
  });
  ServerContext.prototype.id = parameterfy(function(id) {
    return __wrappedInstance.id(id);
  });
  ServerContext.prototype.valueToBoolean = parameterfy(function(value) {
    return __wrappedInstance.valueToBoolean(value);
  });
  ServerContext.prototype.logData = parameterfy(function(name, kw) {
    if (name === undefined) {
      name = null;
    }
    if (kw === undefined) {
      kw = null;
    }
    __wrappedInstance.logData(name, kw);
  });
  ServerContext.prototype.logNode = parameterfy(function(node) {
    __wrappedInstance.logNode(node);
  });
  ServerContext.prototype.execHTTPRequest = parameterfy(function(url, method, query, logresponse, responsevar, islocal, timeout, statusCodeVar, timeoutRet, responseHeaders, headerMap, statusCodeErrorLevel) {
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
  return ServerContext;
}();
var $jscompDefaultExport = ServerContext;
module$input.ServerContext = ServerContext;
module$input["default"] = $jscompDefaultExport;
