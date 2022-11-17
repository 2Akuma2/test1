package de.qfs
import java.util.List
class Resolvers{
    //  redirected constants
    /** State specifying that the extra feature can be ignored. */
    static public final int STATE_IGNORE = de.qfs.apps.qftest.client.script.modules.Resolvers.STATE_IGNORE
    /** State specifying that the extra feature value must match. */
    static public final int STATE_SHOULD_MATCH = de.qfs.apps.qftest.client.script.modules.Resolvers.STATE_SHOULD_MATCH
    /** State specifying that the extra feature value must match as a regexp. */
    static public final int STATE_MUST_MATCH = de.qfs.apps.qftest.client.script.modules.Resolvers.STATE_MUST_MATCH
    //  redirected methods
    private final de.qfs.apps.qftest.client.script.modules.Resolvers __wrappedInstance
    private static Resolvers __instance = new Resolvers()
    static Resolvers instance(){
        return __instance
    }
    private Resolvers(){
        __wrappedInstance = de.qfs.apps.qftest.client.script.modules.Resolvers.instance()
    }
    /**
     * Register an object/method as resolver for the given target(s). The type of the
     * resolver can be determined if
     * (1) the object implements a resolver interface
     * (2) the class of the object or the object itself implements the resolver methods -
     * the methods are associated by their name
     * (3) the method has a name which corresponds to the method of the resolver interface.
     * 
     * Multiple resolvers can be registered with one identifier by adding a list of resolver objects. If
     * another resolver was previously registered under the given identifier,
     * unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param resolver
     * The object that represents the resolver or a list of resolver
     * objects.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addResolver(String name, Object resolver, Object... targets){
        __wrappedInstance.addResolver(name, resolver, targets)
    }
    /**
     * Register a BusyPaneResolver for the given target(s), based on the given
     * method, to determine whether a GUI element is covered by a busy glass
     * pane or some similar mechanism to indicate that the application is busy.
     * If another resolver was previously registered under the given identifier,
     * unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param method
     * The method that implements the resolver's isBusy() method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addBusyPaneResolver(String name, Object method, Object... targets){
        __wrappedInstance.addBusyPaneResolver(name, method, targets)
    }
    /**
     * Register a ClassNameResolver for the given target(s), based on the given
     * method to get the class name to record for a component.If another
     * resolver was previously registered under the given identifier, unregisters
     * that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param method
     * The method that implements the resolver's getClassName()
     * method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addClassNameResolver(String name, Object method, Object... targets){
        __wrappedInstance.addClassNameResolver(name, method, targets)
    }
    /**
     * Register a ComponentRecordingFilter for the given target(s), based on the
     * given method to determine whether to record a GUI element or filter it..
     * If another resolver was previously registered under the given identifier,
     * unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param method
     * The method that implements the resolver's filterComponent()
     * method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addComponentRecordingFilter(String name, Object method, Object... targets){
        __wrappedInstance.addComponentRecordingFilter(name, method, targets)
    }
    /**
     * Register an ElementInfoResolver for the given target(s), based on the
     * given method to get the ElementInfo for a GUI element. Called at every
     * level, i.e. for every ChildInfo and ToplevelInfo tow-down, i.e.
     * ToplevelInfo first. If another resolver was previously registered under
     * the given identifier, unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param method
     * The method that implements the resolver's getElementInfo()
     * method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addElementInfoResolver(String name, Object method, Object... targets){
        __wrappedInstance.addElementInfoResolver(name, method, targets)
    }
    /**
     * Register a EnabledResolver for the given target(s), based on the given
     * method to determine whether a component is enabled. If another resolver
     * was previously registered under the given identifier, unregisters that
     * first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param method
     * The method that implements the resolver's isEnabled() method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addEnabledResolver(String name, Object method, Object... targets){
        __wrappedInstance.addEnabledResolver(name, method, targets)
    }
    /**
     * Register an EventSynchronizer for the given engine(s), based on the given
     * method to synchronize with the event dispatch thread. This method is
     * called from some other thread so it can implement busy waiting or
     * whatever is necessary. If another resolver was previously registered
     * under the given identifier, unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param method
     * The method that implements the resolver's sync() method.
     * @param engines
     * One or more optional engines to register the resolver for.
     */
    public void addEventSynchronizer(String name, Object method, Object... engines){
        __wrappedInstance.addEventSynchronizer(name, method, engines)
    }
    /**
     * Register an BusyApplicationDetector for the given engine(s), based on the
     * given
     * method to detect the busy state of the application. This method is called
     * from some other thread so it can implement busy waiting or whatever is
     * necessary. If another resolver was previously registered under the given
     * identifier, unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param method
     * The method that implements the resolver's applicationIsBusy()
     * method.
     * @param engines
     * One or more optional engines to register the resolver for.
     */
    public void addBusyApplicationDetector(String name, Object method, Object... engines){
        __wrappedInstance.addBusyApplicationDetector(name, method, engines)
    }
    /**
     * Register a ExtraFeatureMatcher for the given target(s), based on the
     * given method to match one extra feature of a GUI element. If another
     * resolver was previously registered under the given identifier, unregisters
     * that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param method
     * The method that implements the resolver's matchExtraFeature()
     * method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addExtraFeatureMatcher(String name, Object method, Object... targets){
        __wrappedInstance.addExtraFeatureMatcher(name, method, targets)
    }
    /**
     * Registers an ExtraFeatureMatcher for a given featureName, optionally on the given target(s).
     * It is based on the given method to match one extra feature of a GUI element. If another
     * resolver was previously registered under the given identifier, unregisters
     * that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param method
     * The method that implements the resolver's matchExtraFeature()
     * method.
     * @param featureName      The name of the extra feature to match
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addSpecificExtraFeatureMatcher(String name, Object method, String featureName, Object... targets){
        __wrappedInstance.addSpecificExtraFeatureMatcher(name, method, featureName, targets)
    }
    /**
     * Register an ExtraFeatureResolver for the given target(s), based on the
     * given method to determine the extra features of a GUI element. If another
     * resolver was previously registered under the given identifier, unregisters
     * that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param method
     * The method that implements the resolver's getExtraFeatures()
     * method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addExtraFeatureResolver(String name, Object method, Object... targets){
        __wrappedInstance.addExtraFeatureResolver(name, method, targets)
    }
    /**
     * Register a FallbackClassNameResolver for the given target(s), based on
     * the given method to get the fallback class name to record for a
     * component. If another resolver was previously registered under the given
     * identifier, unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param method
     * The method that implements the resolver's
     * getFallbackClassName() method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addFallbackClassNameResolver(String name, Object method, Object... targets){
        __wrappedInstance.addFallbackClassNameResolver(name, method, targets)
    }
    /**
     * Register a FeatureResolver for the given target(s), based on the given
     * method to determine the feature of a GUI element. If another resolver was
     * previously registered under the given identifier, unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param method
     * The method that implements the resolver's getFeature() method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addFeatureResolver(String name, Object method, Object... targets){
        __wrappedInstance.addFeatureResolver(name, method, targets)
    }
    /** @deprecated use {@link #addFeatureResolver()} */
    public void addFeatureResolver2(String name, Object method, Object... targets){
        __wrappedInstance.addFeatureResolver2(name, method, targets)
    }
    /**
     * Register a GenericClassNameResolver for the given target(s), based on the
     * given method to get the generic class name to record for a component. If
     * another resolver was previously registered under the given identifier,
     * unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param method
     * The method that implements the resolver's
     * getGenericClassName() method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addGenericClassNameResolver(String name, Object method, Object... targets){
        __wrappedInstance.addGenericClassNameResolver(name, method, targets)
    }
    /**
     * Register a ElementResolver for the given target(s), based on the
     * given method to get the generic class name to record for a component. If
     * another resolver was previously registered under the given identifier,
     * unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param method
     * The method that implements the resolver's
     * findElement() method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addElementResolver(String name, Object method, Object... targets){
        __wrappedInstance.addElementResolver(name, method, targets)
    }
    /**
     * Register a GlassPaneResolver for the given target(s), based on the given
     * method to determine whether a GUI element is a glass pane covering
     * another GUI element to which events should be redirected. If another
     * resolver was previously registered under the given identifier, unregisters
     * that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param method
     * The method that implements the resolver's isGlasPaneFor()
     * method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addGlassPaneResolver(String name, Object method, Object... targets){
        __wrappedInstance.addGlassPaneResolver(name, method, targets)
    }
    /**
     * Register an IdResolver for the given target(s), based on the given method
     * to determine the id of a GUI element. If another resolver was previously
     * registered under the given name, unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param method
     * The method that implements the resolver's getId() method.
     * @param target
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addIdResolver(String name, Object method, Object... targets){
        __wrappedInstance.addIdResolver(name, method, targets)
    }
    /**
     * Register a InterestingParentResolver for the given target(s), based on
     * the given method to determine whether a parent element of a GUI element
     * is "interesting enough" to be recorded if the component hierarchy mode is
     * set to "intelligent". If another resolver was previously registered under
     * the given identifier, unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param method
     * The method that implements the resolver's
     * isInterestingParent() method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addInterestingParentResolver(String name, Object method, Object... targets){
        __wrappedInstance.addInterestingParentResolver(name, method, targets)
    }
    /**
     * Register an IndexBasedItemNameResolver for the given target, based on the
     * given method to determine the name of a sub-item of a complex component.
     * If another resolver was previously registered under the given identifier,
     * unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param method
     * The method that implements the resolver's getItemName()
     * method.
     * @param target
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addIndexBasedItemNameResolver(String name, Object method, Object... targets){
        __wrappedInstance.addIndexBasedItemNameResolver(name, method, targets)
    }
    /**
     * Register a MainTextResolver for the given target(s), based on the given
     * method to determine the "main" text of a GUI element, i.e. what should be
     * used as a label, feature, etc. If another resolver was previously
     * registered under the given identifier, unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param method
     * The method that implements the resolver's getMainText()
     * method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addMainTextResolver(String name, Object method, Object... targets){
        __wrappedInstance.addMainTextResolver(name, method, targets)
    }
    /**
     * Register a NameResolver for the given target(s), based on the given
     * method to determine the name of a GUI element. If another resolver was
     * previously registered under the given identifier, unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param method
     * The method that implements the resolver's getName() method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addNameResolver(String name, Object method, Object... targets){
        __wrappedInstance.addNameResolver(name, method, targets)
    }
    /** @deprecated use {@link #addNameResolver()} */
    public void addNameResolver2(String name, Object method, Object... targets){
        __wrappedInstance.addNameResolver2(name, method, targets)
    }
    /**
     * Register a OverrideClassesResolver for the given target(s), based on the
     * given method to give the resolver a chance to override the classes
     * determined for a component. If another resolver was previously registered
     * under the given identifier, unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param method
     * The method that implements the resolver's overrideClasses()
     * method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addOverrideClassesResolver(String name, Object method, Object... targets){
        __wrappedInstance.addOverrideClassesResolver(name, method, targets)
    }
    /**
     * Register a RedirectResolver for the given target(s), based on the given
     * method to determine whether a mouse event on a component should be
     * redirected. If another resolver was previously registered under the given
     * identifier, unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param method
     * The method that implements the resolver's shouldRedirect()
     * method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addRedirectResolver(String name, Object method, Object... targets){
        __wrappedInstance.addRedirectResolver(name, method, targets)
    }
    /**
     * Register a ScrollOffsetResolver for the given target(s), based on the
     * given method to convert a physical scrolled location relative to the
     * event area of a GUI element to the virtual unscrolled location relative
     * to the event area of the same element (= as if it were not scrolled). If
     * another resolver was previously registered under the given identifier,
     * unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param fromScrolledLocationMethod
     * The method that implements the resolver's
     * fromScrolledLocation() method.
     * @param toScrolledLocationMethod
     * The method that implements the resolver's
     * fromScrolledLocation() method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addScrollOffsetResolver(String name, Object fromScrolledLocationMethod, Object toScrolledLocationMethod, Object... targets){
        __wrappedInstance.addScrollOffsetResolver(name, fromScrolledLocationMethod, toScrolledLocationMethod, targets)
    }
    /**
     * Register a TableWithItemsResolver for the given target(s), based on the
     * given method to determine whether to address a table's cells as items. If
     * another resolver was previously registered under the given identifier,
     * unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param method
     * The method that implements the resolver's hasItems() method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addTableWithItemsResolver(String name, Object method, Object... targets){
        __wrappedInstance.addTableWithItemsResolver(name, method, targets)
    }
    /**
     * Register a TooltipResolver for the given target(s), based on the given
     * method to determine the tooltip of a GUI element. If another resolver was
     * previously registered under the given identifier, unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param method
     * The method that implements the resolver's getTooltip() method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addTooltipResolver(String name, Object method, Object... targets){
        __wrappedInstance.addTooltipResolver(name, method, targets)
    }
    /**
     * Register a TreeTableResolver for the given target, based on the given
     * methods. If another resolver was previously registered under the given
     * identifier, unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param getTreeTableMethod
     * The method that implements the resolver's getTree() method.
     * @param getTreeColumnMethod
     * The method that implements the resolver's getTreeColumn()
     * method.
     * @param target
     * One optional target to register the resolver for. It can be
     * any of the following: - An individual component - The fully
     * qualified name of a class If no target is given a global
     * resolver for all components is registered.
     */
    public void addTreeTableResolver(String name, Object getTreeMethod, Object getTreeColumnMethod=null, Object target=null){
        __wrappedInstance.addTreeTableResolver(name, getTreeMethod, getTreeColumnMethod, target)
    }
    /**
     * Register a TreeTableResolver for the given target, based on the given
     * methods. If another resolver was previously registered under the given
     * identifier, unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param getTreeTableMethod
     * The method that implements the resolver's getTree() method.
     * @param getTreeColumnMethod
     * The method that implements the resolver's getTreeColumn()
     * method.
     * @param target
     * One optional target to register the resolver for. It can be
     * any of the following: - An individual component - The fully
     * qualified name of a class If no target is given a global
     * resolver for all components is registered.
     */
    public void addTreeTableResolver(Map mappedParams, String name, Object getTreeMethod){
        def getTreeColumnMethod = null
        if(mappedParams.containsKey("getTreeColumnMethod")){
            getTreeColumnMethod = mappedParams.getTreeColumnMethod
        }
        def target = null
        if(mappedParams.containsKey("target")){
            target = mappedParams.target
        }
        __wrappedInstance.addTreeTableResolver(name, getTreeMethod, getTreeColumnMethod, target)
    }
    /**
     * Register a VisibilityResolver for the given target(s), based on the given
     * method to determine the visibility of a GUI element. If another resolver
     * was previously registered under the given identifier, unregisters that
     * first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param method
     * The method that implements the resolver's isVisible() method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addVisibilityResolver(String name, Object method, Object... targets){
        __wrappedInstance.addVisibilityResolver(name, method, targets)
    }
    /**
     * Register a WholeTextResolver for the given target(s), based on the given
     * method to determine the "whole" text of a GUI element, i.e. what should
     * be used for a check, etc. If another resolver was previously registered
     * under the given identifier, unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param method
     * The method that implements the resolver's getWholeText()
     * method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addWholeTextResolver(String name, Object method, Object... targets){
        __wrappedInstance.addWholeTextResolver(name, method, targets)
    }
    /**
     * Register an ItemNameMatcher for the given target, based on the given
     * method to test whether a sub-item matches a given name. If another
     * resolver was previously registered under the given identifier, unregisters
     * that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param method
     * The method that implements the resolver's getItemValue()
     * method.
     * @param target
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addItemNameMatcher(String name, Object method, Object... targets){
        __wrappedInstance.addItemNameMatcher(name, method, targets)
    }
    /**
     * Register an ItemNameResolver for the given target, based on the given
     * method to get the name of a sub-item of a given GUI element. The type of
     * the item representation depends on the element and the ItemResolver
     * responsible for that element. If another resolver was previously
     * registered under the given identifier, unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param method
     * The method that implements the resolver's getItemName()
     * method.
     * @param target
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addItemNameResolver(String name, Object method, Object... targets){
        __wrappedInstance.addItemNameResolver(name, method, targets)
    }
    public void addItemNameResolver2(String name, Object method, Object... targets){
        __wrappedInstance.addItemNameResolver2(name, method, targets)
    }
    /**
     * Register a ItemParentResolver for the given target(s), based on the given
     * method. If another resolver was previously registered under the given
     * identifier, unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param getElementMethod
     * The method that implements the resolver's getElement() method.
     * @param getItemForIndexMethod
     * The method that implements the resolver's getItemForIndex()
     * method.
     * @param getItemIndexMethod
     * The method that implements the resolver's getItemIndex()
     * method.
     * @param getParentAndItemMethod
     * The method that implements the resolver's getParentAndItem()
     * method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addItemParentResolver(String name, Object getElementMethod, Object getItemForIndexMethod, Object getItemIndexMethod, Object getParentAndItemMethod, Object... targets){
        __wrappedInstance.addItemParentResolver(name, getElementMethod, getItemForIndexMethod, getItemIndexMethod, getParentAndItemMethod, targets)
    }
    /**
     * Register a ItemResolver for the given target(s), based on the given
     * method to enable qftest to interact with sub-items of complex components.
     * If another resolver was previously registered under the given identifier,
     * unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param getItemMethod
     * The method that implements the resolver's getItem() method.
     * @param getItemCountMethod
     * The method that implements the resolver's getItemCount()
     * method.
     * @param getItemForIndexMethod
     * The method that implements the resolver's getItemForIndex()
     * method.
     * @param getItemLocationMethod
     * The method that implements the resolver's getItemLocation()
     * method.
     * @param getItemSizeMethod
     * The method that implements the resolver's getItemSize()
     * method.
     * @param getItemValueMethod
     * The method that implements the resolver's getItemValue()
     * method.
     * @param repositionMouseEventMethod
     * The method that implements the resolver's
     * repositionMouseEvent() method.
     * @param scrollItemVisibleMethod
     * The method that implements the resolver's scrollItemVisible()
     * method.
     * @param targets
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addItemResolver(String name, Object getItemMethod, Object getItemCountMethod, Object getItemForIndexMethod, Object getItemLocationMethod, Object getItemSizeMethod, Object getItemValueMethod, Object repositionMouseEventMethod, Object scrollItemVisibleMethod, Object... targets){
        __wrappedInstance.addItemResolver(name, getItemMethod, getItemCountMethod, getItemForIndexMethod, getItemLocationMethod, getItemSizeMethod, getItemValueMethod, repositionMouseEventMethod, scrollItemVisibleMethod, targets)
    }
    /**
     * Register an ItemValueResolver for the given target, based on the given
     * method to get a sub-item's value. If another resolver was previously
     * registered under the given identifier, unregisters that first.
     * 
     * @param name
     * The name under which to register the resolver.
     * @param method
     * The method that implements the resolver's getItemValue()
     * method.
     * @param target
     * One or more optional targets to register the resolver for.
     * Each can be any of the following: - An individual component -
     * The fully qualified name of a class If no target is given a
     * global resolver for all components is registered.
     */
    public void addItemValueResolver(String name, Object method, Object... targets){
        __wrappedInstance.addItemValueResolver(name, method, targets)
    }
    /** @deprecated use {@link #addItemValueResolver()} */
    public void addItemValueResolver2(String name, Object method, Object... targets){
        __wrappedInstance.addItemValueResolver2(name, method, targets)
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
    public void setApiLevel(int level){
        __wrappedInstance.setApiLevel(level)
    }
}
