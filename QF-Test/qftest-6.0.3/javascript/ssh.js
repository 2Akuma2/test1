exports.__esModule = true;
var module$input = exports;
var SSH = function() {
};
var _WrappedSSH = Java.type("de.qfs.apps.qftest.shared.script.modules.SSH");
SSH.Session = function() {
  _WrappedSSH.Session = Java.type("de.qfs.apps.qftest.shared.script.modules.SSH.Session");
  var __wrappedInstanceSession;
  function Session(username, server, port, password, keyfile, checkKnownHosts, knownHostsFile, connectTimeout, command, input, inputFile, mixOut, strong) {
    if (port === undefined) {
      port = 22;
    }
    if (password === undefined) {
      password = null;
    }
    if (keyfile === undefined) {
      keyfile = null;
    }
    if (checkKnownHosts === undefined) {
      checkKnownHosts = true;
    }
    if (knownHostsFile === undefined) {
      knownHostsFile = null;
    }
    if (connectTimeout === undefined) {
      connectTimeout = 5E3;
    }
    if (command === undefined) {
      command = "bash";
    }
    if (input === undefined) {
      input = null;
    }
    if (inputFile === undefined) {
      inputFile = null;
    }
    if (mixOut === undefined) {
      mixOut = false;
    }
    if (strong === undefined) {
      strong = false;
    }
    __wrappedInstanceSession = _WrappedSSH.Session.instance(username, server, port, password, keyfile, checkKnownHosts, knownHostsFile, connectTimeout, command, input, inputFile, mixOut, strong);
  }
  Session.prototype.setHostKeyChecking = parameterfy(function(check, knownHostsFile) {
    if (knownHostsFile === undefined) {
      knownHostsFile = null;
    }
    __wrappedInstanceSession.setHostKeyChecking(check, knownHostsFile);
  });
  Session.prototype.setConnectTimeout = parameterfy(function(timeout) {
    __wrappedInstanceSession.setConnectTimeout(timeout);
  });
  Session.prototype.setCommand = parameterfy(function(command) {
    __wrappedInstanceSession.setCommand(command);
  });
  Session.prototype.setInput = parameterfy(function(input) {
    __wrappedInstanceSession.setInput(input);
  });
  Session.prototype.setInputFile = parameterfy(function(inputFile) {
    __wrappedInstanceSession.setInputFile(inputFile);
  });
  Session.prototype.setEncoding = parameterfy(function(encoding) {
    __wrappedInstanceSession.setEncoding(encoding);
  });
  Session.prototype.open = parameterfy(function() {
    __wrappedInstanceSession.open();
  });
  Session.prototype.send = parameterfy(function(input, addNewline) {
    if (addNewline === undefined) {
      addNewline = true;
    }
    __wrappedInstanceSession.send(input, addNewline);
  });
  Session.prototype.expect = parameterfy(function(regexp, timeout) {
    if (timeout === undefined) {
      timeout = 1E3;
    }
    return __wrappedInstanceSession.expect(regexp, timeout);
  });
  Session.prototype.waitTime = parameterfy(function(timeout) {
    if (timeout === undefined) {
      timeout = 1E3;
    }
    return __wrappedInstanceSession.waitTime(timeout);
  });
  Session.prototype.close = parameterfy(function() {
    __wrappedInstanceSession.close();
  });
  Session.prototype.getExitCode = parameterfy(function() {
    return __wrappedInstanceSession.getExitCode();
  });
  Session.prototype.getStdout = parameterfy(function() {
    return __wrappedInstanceSession.getStdout();
  });
  Session.prototype.getStderr = parameterfy(function() {
    return __wrappedInstanceSession.getStderr();
  });
  return Session;
}();
var $jscompDefaultExport = SSH;
module$input.SSH = SSH;
module$input["default"] = $jscompDefaultExport;
