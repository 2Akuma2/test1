// {{{ copyright

/********************************************************************
 *
 * Copyright (C) 2004 Gregor Schmid, Quality First Software
 * All rights reserved
 *
 *******************************************************************/

// }}}

package de.qfs.apps.qftest.extensions;

//{{{ imports

import java.util.Locale;

import javax.annotation.Nullable;

import javax.swing.UIManager;

import de.qfs.lib.log.Log;
import de.qfs.lib.util.Reflector;

import de.qfs.apps.qftest.client.Engine;
import de.qfs.apps.qftest.client.web.WebEngine;
import de.qfs.apps.qftest.client.web.js.InjectionCode;
import de.qfs.apps.qftest.client.web.js.InjectionObject;
import de.qfs.apps.qftest.extensions.annotations.Registry;

import lombok.NonNull;
import lombok.extern.qfs.QFLog;

// }}}

/**
 * Helper class with static convenience methods for Resolvers.
 *
 * @author      Gregor Schmid
 */
@Registry(ResolverRegistry.class)
@QFLog
public abstract class ResolverHelper
{
    // {{{ getLocalValue

    /**
     * [issue594] Get a localized UI value, possibly dependent on the locale of the component.
     *
     * @param   com     The component.
     * @param   name    The name of the value to lookup.
     *
     * @return  The localized value.
     */
    public static Object getLocalValue(Object com, String name)
    {
        // Only available with JDK 1.4 and above
        Object locale = Reflector.safeCall(com, "getLocale");
        qflog(DBG,locale);
        Object ret = null;
        if (locale != null) {
            ret =  Reflector.safeCall(UIManager.class, "get",
                                      new Class[] {Object.class, Locale.class},
                                      new Object[] {name, locale});
        }
        if (ret == null) {
            ret =  UIManager.get(name);
        }
        qflog(DBG, ret);
        return ret;
    }

    // }}}
    // {{{ injectCode(InjectionObject)

    /**
     * See {@link WebEngine#injectCode(InjectionObject)}
     */
    @NonNull
    public static WebEngine injectCode(@NonNull final InjectionCode injectionCode)
    {
        final WebEngine engine = (WebEngine) Engine.threadInstance("web");
        return engine.injectCode(injectionCode);
    }

    // }}}
    // {{{ injectCode(String, String, String)

    /**
     * See {@link WebEngine#injectCode(String, String, String)}
     */
    @NonNull
    public static WebEngine injectCode(@NonNull final String fragmentName,
                                @Nullable final String code, @Nullable final String reverseCode)
    {
        final WebEngine engine = (WebEngine) Engine.threadInstance("web");
        return engine.injectCode(fragmentName, code, reverseCode);
    }

    // }}}
    // {{{ removeInjectedCode(InjectionObject)

    /**
     * @see {@link WebEngine#removeInjectedCode(InjectionObject)}
     */
    @NonNull
    public static WebEngine removeInjectedCode(@NonNull final InjectionCode injectionCode)
    {
        final WebEngine engine = (WebEngine) Engine.threadInstance("web");
        return engine.removeInjectedCode(injectionCode);
    }

    // }}}
    // {{{ removeInjectedCode

    /**
     * See {@link WebEngine#removeInjectedCode(String)}
     */
    @NonNull
    public static WebEngine removeInjectedCode(@NonNull final String fragmentName)
    {
        final WebEngine engine = (WebEngine) Engine.threadInstance("web");
        return engine.removeInjectedCode(fragmentName);
    }

    // }}}
}
