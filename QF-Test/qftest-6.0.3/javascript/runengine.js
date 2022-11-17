exports.__esModule = true;
var module$input = exports;
var RunEngine = function() {
};
var _WrappedRunEngine = Java.type("de.qfs.apps.qftest.client.script.modules.RunEngine");
RunEngine.runAndroid = parameterfy(function(languageName, cmd, timeout) {
  if (timeout === undefined) {
    timeout = 5E3;
  }
  return _WrappedRunEngine.runAndroid(languageName, cmd, timeout);
});
RunEngine.runAWT = parameterfy(function(languageName, cmd, timeout) {
  if (timeout === undefined) {
    timeout = 5E3;
  }
  return _WrappedRunEngine.runAWT(languageName, cmd, timeout);
});
RunEngine.runSWT = parameterfy(function(languageName, cmd, timeout) {
  if (timeout === undefined) {
    timeout = 5E3;
  }
  return _WrappedRunEngine.runSWT(languageName, cmd, timeout);
});
RunEngine.runWeb = parameterfy(function(languageName, cmd, timeout) {
  if (timeout === undefined) {
    timeout = 5E3;
  }
  return _WrappedRunEngine.runWeb(languageName, cmd, timeout);
});
RunEngine.runFX = parameterfy(function(languageName, cmd, timeout) {
  if (timeout === undefined) {
    timeout = 5E3;
  }
  return _WrappedRunEngine.runFX(languageName, cmd, timeout);
});
RunEngine.runWin = parameterfy(function(languageName, cmd, timeout) {
  if (timeout === undefined) {
    timeout = 5E3;
  }
  return _WrappedRunEngine.runWin(languageName, cmd, timeout);
});
RunEngine.runCmd = parameterfy(function(languageName, cmd) {
  return _WrappedRunEngine.runCmd(languageName, cmd);
});
var $jscompDefaultExport = RunEngine;
module$input.RunEngine = RunEngine;
module$input["default"] = $jscompDefaultExport;
