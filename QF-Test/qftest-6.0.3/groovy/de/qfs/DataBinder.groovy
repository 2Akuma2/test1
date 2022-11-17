package de.qfs
import java.util.Map
class DataBinder{
    //  redirected constants
    //  redirected methods
    private final de.qfs.apps.qftest.script.modules.DataBinder __wrappedInstance
    private static DataBinder __instance = new DataBinder()
    static DataBinder instance(){
        return __instance
    }
    private DataBinder(){
        __wrappedInstance = de.qfs.apps.qftest.script.modules.DataBinder.instance()
    }
    /**
     * Create and register a databinder that binds a list of values to a
     * variable.
     * 
     * @param varname
     * The name of the variable to bind to.
     * @param values
     * The values to bind. Either a sequence type or a string to
     * split.
     * @param separator
     * Separator character to split the values at in case they're a
     * string. Default is whitespace.
     * @param counter
     * An optional variable name for the iteration counter.
     * @param intervals
     * Optional ranges of indices, separated by comma, e.g. "0,2-3".
     * @throws TestException
     */
    public void bindList(Object rc, String loopname, String varname, Object values, String separator=null, String counter=null, String intervals=null){
        __wrappedInstance.bindList(rc, loopname, varname, values, separator, counter, intervals)
    }
    /**
     * Create and register a databinder that binds a list of values to a
     * variable.
     * 
     * @param varname
     * The name of the variable to bind to.
     * @param values
     * The values to bind. Either a sequence type or a string to
     * split.
     * @param separator
     * Separator character to split the values at in case they're a
     * string. Default is whitespace.
     * @param counter
     * An optional variable name for the iteration counter.
     * @param intervals
     * Optional ranges of indices, separated by comma, e.g. "0,2-3".
     * @throws TestException
     */
    public void bindList(Map mappedParams, Object rc, String loopname, String varname, Object values){
        def separator = null
        if(mappedParams.containsKey("separator")){
            separator = mappedParams.separator
        }
        def counter = null
        if(mappedParams.containsKey("counter")){
            counter = mappedParams.counter
        }
        def intervals = null
        if(mappedParams.containsKey("intervals")){
            intervals = mappedParams.intervals
        }
        __wrappedInstance.bindList(rc, loopname, varname, values, separator, counter, intervals)
    }
    /**
     * Create and register a databinder that binds a list of value-set to a set
     * of variables.
     * 
     * @param loopname
     * The name for which to register the databinder.
     * @param varnames
     * The names of the variables to bind to. Either a sequence type
     * or a string to split.
     * @param values
     * The values to bind. Either a sequence of sequences - each
     * inner sequence being one set of data to bind - or a string to
     * split.
     * @param separator
     * Separator character to split the varnames and value-sets at in
     * case they're a string. Default is space. Value-sets are
     * separated by linebreaks.
     * @param counter
     * An optional variable name for the iteration counter.
     * @param intervals
     * Optional ranges of indices, separated by comma, e.g. "0,2-3".
     * @throws TestException
     */
    public void bindSets(Object rc, String loopname, Object varnames, Object values, String separator=null, String counter=null, String intervals=null){
        __wrappedInstance.bindSets(rc, loopname, varnames, values, separator, counter, intervals)
    }
    /**
     * Create and register a databinder that binds a list of value-set to a set
     * of variables.
     * 
     * @param loopname
     * The name for which to register the databinder.
     * @param varnames
     * The names of the variables to bind to. Either a sequence type
     * or a string to split.
     * @param values
     * The values to bind. Either a sequence of sequences - each
     * inner sequence being one set of data to bind - or a string to
     * split.
     * @param separator
     * Separator character to split the varnames and value-sets at in
     * case they're a string. Default is space. Value-sets are
     * separated by linebreaks.
     * @param counter
     * An optional variable name for the iteration counter.
     * @param intervals
     * Optional ranges of indices, separated by comma, e.g. "0,2-3".
     * @throws TestException
     */
    public void bindSets(Map mappedParams, Object rc, String loopname, Object varnames, Object values){
        def separator = null
        if(mappedParams.containsKey("separator")){
            separator = mappedParams.separator
        }
        def counter = null
        if(mappedParams.containsKey("counter")){
            counter = mappedParams.counter
        }
        def intervals = null
        if(mappedParams.containsKey("intervals")){
            intervals = mappedParams.intervals
        }
        __wrappedInstance.bindSets(rc, loopname, varnames, values, separator, counter, intervals)
    }
    /**
     * Create and register a databinder that binds a dictionary. The keys of the
     * dictionary are the names of the variables and the values are sequences of
     * values to be bound.
     * 
     * @param loopname
     * The name for which to register the databinder.
     * @param dict
     * The dictionary to bind.
     * @param counter
     * An optional variable name for the iteration counter.
     * @param intervals
     * Optional ranges of indices, separated by comma, e.g. "0,2-3".
     * @throws TestException
     */
    public void bindDict(Object rc, String loopname, Map dict, String counter=null, String intervals=null){
        __wrappedInstance.bindDict(rc, loopname, dict, counter, intervals)
    }
    /**
     * Create and register a databinder that binds a dictionary. The keys of the
     * dictionary are the names of the variables and the values are sequences of
     * values to be bound.
     * 
     * @param loopname
     * The name for which to register the databinder.
     * @param dict
     * The dictionary to bind.
     * @param counter
     * An optional variable name for the iteration counter.
     * @param intervals
     * Optional ranges of indices, separated by comma, e.g. "0,2-3".
     * @throws TestException
     */
    public void bindDict(Map mappedParams, Object rc, String loopname, Map dict){
        __wrappedInstance.bindDict(rc, loopname, dict, mappedParams)
    }
}
