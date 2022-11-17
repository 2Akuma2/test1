from de.qfs.apps.qftest.script.modules import DataBinder as _WrappedDataBinder
#  redirected constants
#  redirected methods
__wrappedInstance = _WrappedDataBinder.instance()
def bindList(rc, loopname, varname, values, separator=None, counter=None, intervals=None):
    """
    Create and register a databinder that binds a list of values to a
    variable.
    
    @param varname
    The name of the variable to bind to.
    @param values
    The values to bind. Either a sequence type or a string to
    split.
    @param separator
    Separator character to split the values at in case they're a
    string. Default is whitespace.
    @param counter
    An optional variable name for the iteration counter.
    @param intervals
    Optional ranges of indices, separated by comma, e.g. "0,2-3".
    @throws TestException
    """
    __wrappedInstance.bindList(rc, loopname, varname, values, separator, counter, intervals)

def bindSets(rc, loopname, varnames, values, separator=None, counter=None, intervals=None):
    """
    Create and register a databinder that binds a list of value-set to a set
    of variables.
    
    @param loopname
    The name for which to register the databinder.
    @param varnames
    The names of the variables to bind to. Either a sequence type
    or a string to split.
    @param values
    The values to bind. Either a sequence of sequences - each
    inner sequence being one set of data to bind - or a string to
    split.
    @param separator
    Separator character to split the varnames and value-sets at in
    case they're a string. Default is space. Value-sets are
    separated by linebreaks.
    @param counter
    An optional variable name for the iteration counter.
    @param intervals
    Optional ranges of indices, separated by comma, e.g. "0,2-3".
    @throws TestException
    """
    __wrappedInstance.bindSets(rc, loopname, varnames, values, separator, counter, intervals)

def bindDict(rc, loopname, dict, counter=None, intervals=None):
    """
    Create and register a databinder that binds a dictionary. The keys of the
    dictionary are the names of the variables and the values are sequences of
    values to be bound.
    
    @param loopname
    The name for which to register the databinder.
    @param dict
    The dictionary to bind.
    @param counter
    An optional variable name for the iteration counter.
    @param intervals
    Optional ranges of indices, separated by comma, e.g. "0,2-3".
    @throws TestException
    """
    __wrappedInstance.bindDict(rc, loopname, dict, counter, intervals)

