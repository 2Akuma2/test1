package de.qfs
import java.util.List
class WebResolvers{
    //  redirected constants
    //  redirected methods
    private final de.qfs.apps.qftest.client.script.modules.WebResolvers __wrappedInstance
    private static WebResolvers __instance = new WebResolvers()
    static WebResolvers instance(){
        return __instance
    }
    private WebResolvers(){
        __wrappedInstance = de.qfs.apps.qftest.client.script.modules.WebResolvers.instance()
    }
    /**
     * Register a ClassNameResolver for the given target(s), based on the given
     * Javascript function to get the class name to record for a component.If another
     * resolver was previously registered under the given identifier, unregisters
     * that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param jsFunction
     * The function that implements the resolver's getClassName()
     * method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addClassNameResolver(String name, String jsFunction, Object... targets){
        __wrappedInstance.addClassNameResolver(name, jsFunction, targets)
    }
    /**
     * Register a ComponentRecordingFilter for the given target(s), based on the
     * given JavaScript function to determine whether to record a GUI element or filter it..
     * If another resolver was previously registered under the given identifier,
     * unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param jsFunction
     * The function that implements the resolver's filterComponent()
     * method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addComponentRecordingFilter(String name, String jsFunction, Object... targets){
        __wrappedInstance.addComponentRecordingFilter(name, jsFunction, targets)
    }
    /**
     * Register a EnabledResolver for the given target(s), based on the given
     * Javascript function to determine whether a component is enabled. If another resolver
     * was previously registered under the given identifier, unregisters that
     * first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param jsFunction
     * The function that implements the resolver's isEnabled() method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addEnabledResolver(String name, String jsFunction, Object... targets){
        __wrappedInstance.addEnabledResolver(name, jsFunction, targets)
    }
    /**
     * Register an BusyApplicationDetector for the given engine(s), based on the
     * given Javascript function to detect the busy state of the application. Since the
     * function is executed in the browser, it is executed on the dispatch thread of the browser.
     * If another resolver was previously registered under the given
     * identifier, unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param jsFunction
     * The function that implements the resolver's applicationIsBusy()
     * method.
     * @param engines
     * One or more optional engines to register the resolver for.
     */
    public void addBusyApplicationDetector(String name, String jsFunction, Object... engines){
        __wrappedInstance.addBusyApplicationDetector(name, jsFunction, engines)
    }
    /**
     * Register a ExtraFeatureMatcher for the given target(s), based on the
     * given JavaScript function to match one extra feature of a GUI element. If another
     * resolver was previously registered under the given identifier, unregisters
     * that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param jsFunction
     * The function that implements the resolver's matchExtraFeature()
     * method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addExtraFeatureMatcher(String name, String jsFunction, Object... targets){
        __wrappedInstance.addExtraFeatureMatcher(name, jsFunction, targets)
    }
    /**
     * Register a ExtraFeatureMatcher for a given featureName, optionally on the given target(s).
     * It is based on the given javascript function to match one extra feature of a GUI element. If another
     * resolver was previously registered under the given identifier, unregister
     * that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param jsFunction
     * The function that implements the resolver's matchExtraFeature()
     * method.
     * @param featureName      The name of the extra feature to match
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addSpecificExtraFeatureMatcher(String name, String jsFunction, String featureName, Object... targets){
        __wrappedInstance.addSpecificExtraFeatureMatcher(name, jsFunction, featureName, targets)
    }
    /**
     * Register an ExtraFeatureResolver for the given target(s), based on the
     * given JavaScript function to determine the extra features of a GUI element. If another
     * resolver was previously registered under the given identifier, unregisters
     * that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param jsFunction
     * The function that implements the resolver's getExtraFeatures()
     * method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addExtraFeatureResolver(String name, String jsFunction, Object... targets){
        __wrappedInstance.addExtraFeatureResolver(name, jsFunction, targets)
    }
    /**
     * Register a FallbackClassNameResolver for the given target(s), based on
     * the given JavaScript function to get the fallback class name to record for a
     * component. If another resolver was previously registered under the given
     * identifier, unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param jsFunction
     * The function that implements the resolver's
     * getFallbackClassName() method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addFallbackClassNameResolver(String name, String jsFunction, Object... targets){
        __wrappedInstance.addFallbackClassNameResolver(name, jsFunction, targets)
    }
    /**
     * Register a FeatureResolver for the given target(s), based on the given
     * Javascript function to determine the feature of a GUI element. If another resolver was
     * previously registered under the given identifier, unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param jsFunction
     * The function that implements the resolver's getFeature() method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addFeatureResolver(String name, String jsFunction, Object... targets){
        __wrappedInstance.addFeatureResolver(name, jsFunction, targets)
    }
    /**
     * Register a GenericClassNameResolver for the given target(s), based on the
     * given JavaScript function to get the generic class name to record for a component. If
     * another resolver was previously registered under the given identifier,
     * unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param jsFunction
     * The function that implements the resolver's
     * getGenericClassName() method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addGenericClassNameResolver(String name, String jsFunction, Object... targets){
        __wrappedInstance.addGenericClassNameResolver(name, jsFunction, targets)
    }
    /**
     * Register a ElementResolver for the given target(s), based on the
     * given JavaScript function to get the generic class name to record for a component. If
     * another resolver was previously registered under the given identifier,
     * unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param jsFunction
     * The function that implements the resolver's
     * getElement() method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addElementResolver(String name, String jsFunction, Object... targets){
        __wrappedInstance.addElementResolver(name, jsFunction, targets)
    }
    /**
     * Register an IdResolver for the given target(s), based on the given JavaScript function
     * to determine the id of a GUI element. If another resolver was previously
     * registered under the given name, unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param jsFunction
     * The function that implements the resolver's getId() method.
     * @param target
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addIdResolver(String name, String jsFunction, Object... targets){
        __wrappedInstance.addIdResolver(name, jsFunction, targets)
    }
    /**
     * Register a InterestingParentResolver for the given target(s), based on
     * the given JavaScript function to determine whether a parent element of a GUI element
     * is "interesting enough" to be recorded if the component hierarchy mode is
     * set to "intelligent". If another resolver was previously registered under
     * the given identifier, unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param jsFunction
     * The function that implements the resolver's
     * isInterestingParent() method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addInterestingParentResolver(String name, String jsFunction, Object... targets){
        __wrappedInstance.addInterestingParentResolver(name, jsFunction, targets)
    }
    /**
     * Register an IndexBasedItemNameResolver for the given target, based on the
     * given JavaScript function to determine the name of a sub-item of a complex component.
     * If another resolver was previously registered under the given identifier,
     * unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param jsFunction
     * The function that implements the resolver's getItemName()
     * method.
     * @param target
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addIndexBasedItemNameResolver(String name, String jsFunction, Object... targets){
        __wrappedInstance.addIndexBasedItemNameResolver(name, jsFunction, targets)
    }
    /**
     * Register a MainTextResolver for the given target(s), based on the given
     * Javascript function to determine the "main" text of a GUI element, i.e. what should be
     * used as a label, feature, etc. If another resolver was previously
     * registered under the given identifier, unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param jsFunction
     * The function that implements the resolver's getMainText()
     * method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addMainTextResolver(String name, String jsFunction, Object... targets){
        __wrappedInstance.addMainTextResolver(name, jsFunction, targets)
    }
    /**
     * Register a NameResolver for the given target(s), based on the given
     * Javascript function to determine the name of a GUI element. If another resolver was
     * previously registered under the given identifier, unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param jsFunction
     * The function that implements the resolver's getName() method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addNameResolver(String name, String jsFunction, Object... targets){
        __wrappedInstance.addNameResolver(name, jsFunction, targets)
    }
    /**
     * Register a RedirectResolver for the given target(s), based on the given
     * Javascript function to determine whether a mouse event on a component should be
     * redirected. If another resolver was previously registered under the given
     * identifier, unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param jsFunction
     * The function that implements the resolver's shouldRedirect()
     * method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addRedirectResolver(String name, String jsFunction, Object... targets){
        __wrappedInstance.addRedirectResolver(name, jsFunction, targets)
    }
    /**
     * Register a ScrollOffsetResolver for the given target(s), based on the
     * given JavaScript functions to convert a physical scrolled location relative to the
     * event area of a GUI element to the virtual unscrolled location relative
     * to the event area of the same element (= as if it were not scrolled). If
     * another resolver was previously registered under the given identifier,
     * unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param fromScrolledLocationFunction
     * The function that implements the resolver's
     * fromScrolledLocation() method.
     * @param toScrolledLocationFunction
     * The function that implements the resolver's
     * fromScrolledLocation() method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addScrollOffsetResolver(String name, String fromScrolledLocationFunction, String toScrolledLocationFunction, Object... targets){
        __wrappedInstance.addScrollOffsetResolver(name, fromScrolledLocationFunction, toScrolledLocationFunction, targets)
    }
    /**
     * Register a TableWithItemsResolver for the given target(s), based on the
     * given JavaScript function to determine whether to address a table's cells as items. If
     * another resolver was previously registered under the given identifier,
     * unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param jsFunction
     * The function that implements the resolver's hasItems() method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addTableWithItemsResolver(String name, String jsFunction, Object... targets){
        __wrappedInstance.addTableWithItemsResolver(name, jsFunction, targets)
    }
    /**
     * Register a TooltipResolver for the given target(s), based on the given
     * Javascript function to determine the tooltip of a GUI element. If another resolver was
     * previously registered under the given identifier, unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param jsFunction
     * The function that implements the resolver's getTooltip() method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addTooltipResolver(String name, String jsFunction, Object... targets){
        __wrappedInstance.addTooltipResolver(name, jsFunction, targets)
    }
    /**
     * Register a VisibilityResolver for the given target(s), based on the given
     * Javascript function to determine the visibility of a GUI element. If another resolver
     * was previously registered under the given identifier, unregisters that
     * first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param jsFunction
     * The function that implements the resolver's isVisible() method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addVisibilityResolver(String name, String jsFunction, Object... targets){
        __wrappedInstance.addVisibilityResolver(name, jsFunction, targets)
    }
    /**
     * Register a WholeTextResolver for the given target(s), based on the given
     * Javascript function to determine the "whole" text of a GUI element, i.e. what should
     * be used for a check, etc. If another resolver was previously registered
     * under the given identifier, unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param jsFunction
     * The function that implements the resolver's getWholeText()
     * method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addWholeTextResolver(String name, String jsFunction, Object... targets){
        __wrappedInstance.addWholeTextResolver(name, jsFunction, targets)
    }
    /**
     * Register an ItemNameMatcher for the given target, based on the given
     * Javascript function to test whether a sub-item matches a given name. If another
     * resolver was previously registered under the given identifier, unregisters
     * that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param jsFunction
     * The function that implements the resolver's getItemValue()
     * method.
     * @param target
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addItemNameMatcher(String name, String jsFunction, Object... targets){
        __wrappedInstance.addItemNameMatcher(name, jsFunction, targets)
    }
    /**
     * Register an ItemNameResolver for the given target, based on the given
     * Javascript function to get the name of a sub-item of a given GUI element. The type of
     * the item representation depends on the element and the ItemResolver
     * responsible for that element. If another resolver was previously
     * registered under the given identifier, unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param jsFunction
     * The function that implements the resolver's getItemName()
     * method.
     * @param target
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addItemNameResolver(String name, String jsFunction, Object... targets){
        __wrappedInstance.addItemNameResolver(name, jsFunction, targets)
    }
    /**
     * Register a ItemParentResolver for the given target(s), based on the given
     * Javascript functions. If another resolver was previously registered under the given
     * identifier, unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param getElementFunction
     * The function that implements the resolver's getElement() method.
     * @param getItemForIndexFunction
     * The function that implements the resolver's getItemForIndex()
     * method.
     * @param getItemIndexFunction
     * The function that implements the resolver's getItemIndex()
     * method.
     * @param getParentAndItemFunction
     * The function that implements the resolver's getParentAndItem()
     * method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addItemParentResolver(String name, String getElementFunction, String getItemForIndexFunction, String getItemIndexFunction, String getParentAndItemFunction, Object... targets){
        __wrappedInstance.addItemParentResolver(name, getElementFunction, getItemForIndexFunction, getItemIndexFunction, getParentAndItemFunction, targets)
    }
    /**
     * Register a ItemResolver for the given target(s), based on the given
     * Javascript function to enable qftest to interact with sub-items of complex components.
     * If another resolver was previously registered under the given identifier,
     * unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param getItemFunction
     * The function that implements the resolver's getItem() method.
     * @param getItemCountFunction
     * The function that implements the resolver's getItemCount()
     * method.
     * @param getItemForIndexFunction
     * The function that implements the resolver's getItemForIndex()
     * method.
     * @param getItemLocationFunction
     * The function that implements the resolver's getItemLocation()
     * method.
     * @param getItemSizeFunction
     * The function that implements the resolver's getItemSize()
     * method.
     * @param getItemValueFunction
     * The function that implements the resolver's getItemValue()
     * method.
     * @param repositionMouseEventFunction
     * The function that implements the resolver's
     * repositionMouseEvent() method.
     * @param scrollItemVisibleFunction
     * The function that implements the resolver's scrollItemVisible()
     * method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addItemResolver(String name, String getItemFunction, String getItemCountFunction, String getItemForIndexFunction, String getItemLocationFunction, String getItemSizeFunction, String getItemValueFunction, String repositionMouseEventFunction, String scrollItemVisibleFunction, Object... targets){
        __wrappedInstance.addItemResolver(name, getItemFunction, getItemCountFunction, getItemForIndexFunction, getItemLocationFunction, getItemSizeFunction, getItemValueFunction, repositionMouseEventFunction, scrollItemVisibleFunction, targets)
    }
    /**
     * Register an ItemValueResolver for the given target, based on the given
     * JavaScript function to get a sub-item's value. If another resolver was previously
     * registered under the given identifier, unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param jsFunction
     * The function that implements the resolver's getItemValue()
     * method.
     * @param target
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addItemValueResolver(String name, String jsFunction, Object... targets){
        __wrappedInstance.addItemValueResolver(name, jsFunction, targets)
    }
    /**
     * Register a Javascript function as resolver for the given target(s). The type of the
     * resolver can be determined if the method has a name which corresponds to the method of the resolver interface.
     * 
     * Multiple resolvers can be registered with one identifier by giving multiple JS functions. If
     * another resolver was previously registered under the given identifier,
     * unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param resolver
     * The function that represents the resolver
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addResolver(String name, String resolver, Object... targets){
        __wrappedInstance.addResolver(name, resolver, targets)
    }
    /**
     * Unregister a previously registered resolver.
     * 
     * @param name
     * The name of the resolver.
     */
    public void removeResolver(String name){
        __wrappedInstance.removeResolver(name)
    }
    /** Remove all previously registered resolvers */
    public void removeAll(){
        __wrappedInstance.removeAll()
    }
    /** List the names of all registered resolvers */
    public List<String> listNames(){
        return __wrappedInstance.listNames()
    }
}
