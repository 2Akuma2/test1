parameterfy = (function() {
    var pattern = /function[^(]*\(([^)]*)\)/;

    return function(func) {
        var args = func.toString().match(pattern)[1].split(/,\s*/);

        return function() {
            var named_params = arguments[arguments.length - 1];
            if (typeof named_params === 'object') {
                var params = [].slice.call(arguments, 0, -1);
                if(!(Object.prototype.toString.call( named_params )==="[object Object]")){
                    return func.apply(null, arguments);
                }
                for(var k in named_params) {
                    if(!(args.includes(k))){
                          return func.apply(null, arguments);
                      }
                }
                if (params.length < args.length) {

                    for (var i = params.length, l = args.length; i < l; i++) {
                        params.push(named_params[args[i]]);
                    }
                    return func.apply(this, params);
                }
            }
            return func.apply(null, arguments);
        };
    };
}());

qf = require('qf').QF;
Options = Java.type('de.qfs.apps.qftest.shared.extensions.Options');
SutContext = require('sutcontext').SutContext;
rc = new SutContext('javascript');
qf.setRCProvider(function(){new SutContext("javascript")});
resolvers = require('resolvers').Resolvers;
webResolvers = require('webresolvers').WebResolvers;
notifications = require('usernotifications').UserNotifications;
runEngine = require('runengine').RunEngine;
runAndroid = parameterfy(function(cmd, timeout){
    runEngine.runAndroid("javascript", cmd, timeout);
}
)
runAWT = parameterfy(function(cmd, timeout){
    runEngine.runAWT("javascript", cmd, timeout);
}
)
runSWT = parameterfy(function(cmd, timeout){
    runEngine.runSWT("javascript", cmd, timeout);
}
)
runWeb = parameterfy(function(cmd, timeout){
    runEngine.runWeb("javascript", cmd, timeout);
}
)
runFX = parameterfy(function(cmd, timeout){
    runEngine.runFX("javascript", cmd, timeout);
}
)
runWin = parameterfy(function(cmd, timeout){
    runEngine.runWin("javascript", cmd, timeout);
}
)

BadComponentException = Java.type('de.qfs.apps.qftest.shared.exceptions.BadComponentException')
BadExitCodeException = Java.type('de.qfs.apps.qftest.shared.exceptions.BadExitCodeException')
BadExpressionException = Java.type('de.qfs.apps.qftest.shared.exceptions.BadExpressionException')
BadItemException = Java.type('de.qfs.apps.qftest.shared.exceptions.BadItemException')
BadRangeException = Java.type('de.qfs.apps.qftest.shared.exceptions.BadRangeException')
BadRegexpException = Java.type('de.qfs.apps.qftest.shared.exceptions.BadRegexpException')
BadTestException = Java.type('de.qfs.apps.qftest.shared.exceptions.BadTestException')
BadVariableSyntaxException = Java.type('de.qfs.apps.qftest.shared.exceptions.BadVariableSyntaxException')
BreakException = Java.type('de.qfs.apps.qftest.shared.exceptions.BreakException')
BusyPaneException = Java.type('de.qfs.apps.qftest.shared.exceptions.BusyPaneException')
CannotAttachException = Java.type('de.qfs.apps.qftest.shared.exceptions.CannotAttachException')
CannotExecuteException = Java.type('de.qfs.apps.qftest.shared.exceptions.CannotExecuteException')
CannotRethrowException = Java.type('de.qfs.apps.qftest.shared.exceptions.CannotRethrowException')
CheckFailedException = Java.type('de.qfs.apps.qftest.shared.exceptions.CheckFailedException')
CheckNotSupportedException = Java.type('de.qfs.apps.qftest.shared.exceptions.CheckNotSupportedException')
ClientNotConnectedException = Java.type('de.qfs.apps.qftest.shared.exceptions.ClientNotConnectedException')
ClientNotTerminatedException = Java.type('de.qfs.apps.qftest.shared.exceptions.ClientNotTerminatedException')
ComponentCannotGetFocusException = Java.type('de.qfs.apps.qftest.shared.exceptions.ComponentCannotGetFocusException')
ComponentFoundException = Java.type('de.qfs.apps.qftest.shared.exceptions.ComponentFoundException')
ComponentIdMismatchException = Java.type('de.qfs.apps.qftest.shared.exceptions.ComponentIdMismatchException')
ComponentNotFoundException = Java.type('de.qfs.apps.qftest.shared.exceptions.ComponentNotFoundException')
ConnectionFailureException = Java.type('de.qfs.apps.qftest.shared.exceptions.ConnectionFailureException')
DeadlockTimeoutException = Java.type('de.qfs.apps.qftest.shared.exceptions.DeadlockTimeoutException')
DependencyNotFoundException = Java.type('de.qfs.apps.qftest.shared.exceptions.DependencyNotFoundException')
DisabledComponentException = Java.type('de.qfs.apps.qftest.shared.exceptions.DisabledComponentException')
DisabledComponentStepException = Java.type('de.qfs.apps.qftest.shared.exceptions.DisabledComponentStepException')
DocumentNotLoadedException = Java.type('de.qfs.apps.qftest.shared.exceptions.DocumentNotLoadedException')
DownloadNotCompleteException = Java.type('de.qfs.apps.qftest.shared.exceptions.DownloadNotCompleteException')
DownloadStillActiveException = Java.type('de.qfs.apps.qftest.shared.exceptions.DownloadStillActiveException')
DuplicateClientException = Java.type('de.qfs.apps.qftest.shared.exceptions.DuplicateClientException')
ExecutionTimeoutExpiredException = Java.type('de.qfs.apps.qftest.shared.exceptions.ExecutionTimeoutExpiredException')
ExtensionException = Java.type('de.qfs.apps.qftest.shared.exceptions.ExtensionException')
InconsistentDependenciesException = Java.type('de.qfs.apps.qftest.shared.exceptions.InconsistentDependenciesException')
IndexFormatException = Java.type('de.qfs.apps.qftest.shared.exceptions.IndexFormatException')
IndexFoundException = Java.type('de.qfs.apps.qftest.shared.exceptions.IndexFoundException')
IndexNotFoundException = Java.type('de.qfs.apps.qftest.shared.exceptions.IndexNotFoundException')
IndexRequiredException = Java.type('de.qfs.apps.qftest.shared.exceptions.IndexRequiredException')
InvalidDirectoryException = Java.type('de.qfs.apps.qftest.shared.exceptions.InvalidDirectoryException')
InvisibleDnDTargetException = Java.type('de.qfs.apps.qftest.shared.exceptions.InvisibleDnDTargetException')
InvisibleTargetComponentException = Java.type('de.qfs.apps.qftest.shared.exceptions.InvisibleTargetComponentException')
InvisibleTargetItemException = Java.type('de.qfs.apps.qftest.shared.exceptions.InvisibleTargetItemException')
MissingPropertiesException = Java.type('de.qfs.apps.qftest.shared.exceptions.MissingPropertiesException')
MissingPropertyException = Java.type('de.qfs.apps.qftest.shared.exceptions.MissingPropertyException')
ModalDialogException = Java.type('de.qfs.apps.qftest.shared.exceptions.ModalDialogException')
NoSuchClientException = Java.type('de.qfs.apps.qftest.shared.exceptions.NoSuchClientException')
NoSuchDownloadException = Java.type('de.qfs.apps.qftest.shared.exceptions.NoSuchDownloadException')
NoSuchEngineException = Java.type('de.qfs.apps.qftest.shared.exceptions.NoSuchEngineException')
OperationNotSupportedException = Java.type('de.qfs.apps.qftest.shared.exceptions.OperationNotSupportedException')
ProcedureNotFoundException = Java.type('de.qfs.apps.qftest.shared.exceptions.ProcedureNotFoundException')
RecursiveDependencyReferenceException = Java.type('de.qfs.apps.qftest.shared.exceptions.RecursiveDependencyReferenceException')
RecursiveVariableException = Java.type('de.qfs.apps.qftest.shared.exceptions.RecursiveVariableException')
ReturnException = Java.type('de.qfs.apps.qftest.shared.exceptions.ReturnException')
ScriptException = Java.type('de.qfs.apps.qftest.shared.exceptions.ScriptException')
StackOverflowException = Java.type('de.qfs.apps.qftest.shared.exceptions.StackOverflowException')
StopException = Java.type('de.qfs.apps.qftest.shared.exceptions.StopException')
TestControlException = Java.type('de.qfs.apps.qftest.shared.exceptions.TestControlException')
TestException = Java.type('de.qfs.apps.qftest.shared.exceptions.TestException')
TestNotFoundException = Java.type('de.qfs.apps.qftest.shared.exceptions.TestNotFoundException')
TestOutOfMemoryException = Java.type('de.qfs.apps.qftest.shared.exceptions.TestOutOfMemoryException')
UnboundVariableException = Java.type('de.qfs.apps.qftest.shared.exceptions.UnboundVariableException')
UnexpectedClientException = Java.type('de.qfs.apps.qftest.shared.exceptions.UnexpectedClientException')
UnexpectedExitCodeException = Java.type('de.qfs.apps.qftest.shared.exceptions.UnexpectedExitCodeException')
UnexpectedIndexException = Java.type('de.qfs.apps.qftest.shared.exceptions.UnexpectedIndexException')
UnresolvedComponentIdException = Java.type('de.qfs.apps.qftest.shared.exceptions.UnresolvedComponentIdException')
UnresolvedIdException = Java.type('de.qfs.apps.qftest.shared.exceptions.UnresolvedIdException')
UserException = Java.type('de.qfs.apps.qftest.shared.exceptions.UserException')
VariableException = Java.type('de.qfs.apps.qftest.shared.exceptions.VariableException')
VariableNumberException = Java.type('de.qfs.apps.qftest.shared.exceptions.VariableNumberException')
