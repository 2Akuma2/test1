exports.__esModule = true;
var module$input = exports;
UserNotifications = function() {
  _WrappedUserNotifications = Java.type("de.qfs.apps.qftest.shared.script.modules.UserNotifications");
  UserNotifications.NOTIFICATION_PREFIX = UserNotifications.prototype.NOTIFICATION_PREFIX = _WrappedUserNotifications.NOTIFICATION_PREFIX;
  UserNotifications.RECORDING_STARTED = UserNotifications.prototype.RECORDING_STARTED = _WrappedUserNotifications.RECORDING_STARTED;
  UserNotifications.RECORDING_STOPPED = UserNotifications.prototype.RECORDING_STOPPED = _WrappedUserNotifications.RECORDING_STOPPED;
  UserNotifications.RECORDING_PAUSED = UserNotifications.prototype.RECORDING_PAUSED = _WrappedUserNotifications.RECORDING_PAUSED;
  UserNotifications.RECORDING_RESUMED = UserNotifications.prototype.RECORDING_RESUMED = _WrappedUserNotifications.RECORDING_RESUMED;
  UserNotifications.CHECK_RECORDING_STARTED = UserNotifications.prototype.CHECK_RECORDING_STARTED = _WrappedUserNotifications.CHECK_RECORDING_STARTED;
  UserNotifications.CHECK_RECORDING_STOPPED = UserNotifications.prototype.CHECK_RECORDING_STOPPED = _WrappedUserNotifications.CHECK_RECORDING_STOPPED;
  UserNotifications.REQUEST_RECORDING_STARTED = UserNotifications.prototype.REQUEST_RECORDING_STARTED = _WrappedUserNotifications.REQUEST_RECORDING_STARTED;
  UserNotifications.REQUEST_RECORDING_STOPPED = UserNotifications.prototype.REQUEST_RECORDING_STOPPED = _WrappedUserNotifications.REQUEST_RECORDING_STOPPED;
  UserNotifications.COMPONENT_RECORDING_STARTED = UserNotifications.prototype.COMPONENT_RECORDING_STARTED = _WrappedUserNotifications.COMPONENT_RECORDING_STARTED;
  UserNotifications.COMPONENT_RECORDING_STOPPED = UserNotifications.prototype.COMPONENT_RECORDING_STOPPED = _WrappedUserNotifications.COMPONENT_RECORDING_STOPPED;
  UserNotifications.PROCBUILDER_STARTED = UserNotifications.prototype.PROCBUILDER_STARTED = _WrappedUserNotifications.PROCBUILDER_STARTED;
  UserNotifications.PROCBUILDER_STOPPED = UserNotifications.prototype.PROCBUILDER_STOPPED = _WrappedUserNotifications.PROCBUILDER_STOPPED;
  UserNotifications.INSPECTOR_MODE_STARTED = UserNotifications.prototype.INSPECTOR_MODE_STARTED = _WrappedUserNotifications.INSPECTOR_MODE_STARTED;
  UserNotifications.INSPECTOR_MODE_STOPPED = UserNotifications.prototype.INSPECTOR_MODE_STOPPED = _WrappedUserNotifications.INSPECTOR_MODE_STOPPED;
  UserNotifications.RUN_STARTED = UserNotifications.prototype.RUN_STARTED = _WrappedUserNotifications.RUN_STARTED;
  UserNotifications.RUN_STOPPED = UserNotifications.prototype.RUN_STOPPED = _WrappedUserNotifications.RUN_STOPPED;
  UserNotifications.NODE_ENTERED = UserNotifications.prototype.NODE_ENTERED = _WrappedUserNotifications.NODE_ENTERED;
  UserNotifications.NODE_EXITED = UserNotifications.prototype.NODE_EXITED = _WrappedUserNotifications.NODE_EXITED;
  UserNotifications.RUN_ERROR_OCCURED = UserNotifications.prototype.RUN_ERROR_OCCURED = _WrappedUserNotifications.RUN_ERROR_OCCURED;
  UserNotifications.EXECUTE = UserNotifications.prototype.EXECUTE = _WrappedUserNotifications.EXECUTE;
  UserNotifications.WINDOW_RAISE = UserNotifications.prototype.WINDOW_RAISE = _WrappedUserNotifications.WINDOW_RAISE;
  UserNotifications.BROWSER_OPEN = UserNotifications.prototype.BROWSER_OPEN = _WrappedUserNotifications.BROWSER_OPEN;
  UserNotifications.PROCESS_START = UserNotifications.prototype.PROCESS_START = _WrappedUserNotifications.PROCESS_START;
  UserNotifications.WEB_REQUEST_RECEIVED = UserNotifications.prototype.WEB_REQUEST_RECEIVED = _WrappedUserNotifications.WEB_REQUEST_RECEIVED;
  UserNotifications.WEB_REQUEST_RECEIVED_TRACKONLY = UserNotifications.prototype.WEB_REQUEST_RECEIVED_TRACKONLY = _WrappedUserNotifications.WEB_REQUEST_RECEIVED_TRACKONLY;
  UserNotifications.WEB_RESPONSE_RECEIVED = UserNotifications.prototype.WEB_RESPONSE_RECEIVED = _WrappedUserNotifications.WEB_RESPONSE_RECEIVED;
  UserNotifications.WEB_RESPONSE_RECEIVED_TRACKONLY = UserNotifications.prototype.WEB_RESPONSE_RECEIVED_TRACKONLY = _WrappedUserNotifications.WEB_RESPONSE_RECEIVED_TRACKONLY;
  UserNotifications.CREATING_WEBDRIVER = UserNotifications.prototype.CREATING_WEBDRIVER = _WrappedUserNotifications.CREATING_WEBDRIVER;
  UserNotifications.LOGGING_EXCEPTION_HANDLER = UserNotifications.prototype.LOGGING_EXCEPTION_HANDLER = _WrappedUserNotifications.LOGGING_EXCEPTION_HANDLER;
  var __wrappedInstance;
  function UserNotifications() {
    __wrappedInstance = _WrappedUserNotifications.instance();
  }
  UserNotifications.prototype.post = parameterfy(function(notificationName, userInfo) {
    if (userInfo === undefined) {
      userInfo = null;
    }
    __wrappedInstance.post(notificationName, userInfo);
  });
  UserNotifications.prototype.addObserver = parameterfy(function(observerName, method, notificationNames) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var notificationNames$0 = $jscomp$restParams;
    if (notificationNames$0) {
      __wrappedInstance.addObserver(observerName, method, notificationNames$0);
    } else {
      __wrappedInstance.addObserver(observerName, method);
    }
  });
  UserNotifications.prototype.removeObserver = parameterfy(function(observerName) {
    __wrappedInstance.removeObserver(observerName);
  });
  UserNotifications.prototype.removeAllObserver = parameterfy(function() {
    __wrappedInstance.removeAllObserver();
  });
  UserNotifications.prototype.listObserverNames = parameterfy(function() {
    return __wrappedInstance.listObserverNames();
  });
  return UserNotifications;
}();
var UserNotifications_export = new UserNotifications;
var $jscompDefaultExport = UserNotifications_export;
module$input.UserNotifications = UserNotifications_export;
module$input["default"] = $jscompDefaultExport;
