// {{{ copyright

/********************************************************************
 *
 * Copyright (C) 2000 Gregor Schmid, Quality First Software
 * All rights reserved
 *
 *******************************************************************/

// }}}

package de.qfs.apps.qftest.extensions;

// {{{ imports

import java.awt.Component;
import java.awt.Point;
import java.awt.Window;

import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JDialog;
import javax.swing.JFileChooser;
import javax.swing.JList;
import javax.swing.JPopupMenu;
import javax.swing.JScrollPane;
import javax.swing.JTextField;
import javax.swing.SwingUtilities;

import de.qfs.lib.log.Log;
import de.qfs.lib.log.Logger;

import de.qfs.apps.qftest.extensions.ComponentNameResolver;
import de.qfs.apps.qftest.extensions.ResolverHelper;
import de.qfs.apps.qftest.extensions.ResolverRegistry;

// }}}

/**
 * Name resolver for JFileChooser components.
 *
 * @author      Gregor Schmid
 */
public class JFileChooserResolver
    implements ComponentNameResolver
{
    // {{{ variables

    /**
     * The Logger used for logging.
     */
    private final static Logger logger =
        new Logger ("de.qfs.apps.qftest.extensions.JFileChooserResolver");

    /**
     * Singleton instance.
     */
    protected static JFileChooserResolver
        instance = new JFileChooserResolver ();

    // }}}

    //----------------------------------------------------------------------
    // Constructor
    //----------------------------------------------------------------------
    // {{{ JFileChooserResolver

    /**
     * Create a new JFileChooserResolver.
     */
    protected JFileChooserResolver ()
    {
        if (logger.level >= Log.MTD) {
            logger.log(Log.MTD, "JFileChooserResolver()", "");
        }
    }

    // }}}

    //----------------------------------------------------------------------
    // Static convenience methods
    //----------------------------------------------------------------------
    // {{{ install

    /**
     * Register the JFileChooserResolver instance as global
     * ComponentNameResolver.
     */
    public static void install()
    {
        ResolverRegistry.instance().registerComponentNameResolver(instance);
    }

    // }}}
    // {{{ uninstall

    /**
     * Register the JFileChooserResolver instance as global
     * ComponentNameResolver.
     */
    public static void uninstall()
    {
        ResolverRegistry.instance().unregisterComponentNameResolver(instance);
    }

    // }}}

    //----------------------------------------------------------------------
    // The ComponentNameResolver interface
    //----------------------------------------------------------------------
    // {{{ getComponentName

    /**
     * Determine the name of a component.
     *
     * @param   com     The component to extract the name from.
     *
     * @return  The name or null if the component cannot be handled.
     */
    @Override
    public String getComponentName(Component com)
    {
        if (logger.level >= Log.MTD) {
            logger.log(Log.MTD, "getComponentName(Component)",
                       logger.level < Log.MTDDETAIL ? "" :
                       "com: " + com);
        }

        if (ResolverRegistry.getComponentName(com) != null
            // [issue393] use publlic resolver registry interface now
            // the JFileChooserResolver might have a name set, but for the
            // sake of unification we need to override that
            && ! (com instanceof JFileChooser)) {
            // Never interfere with others
            return null;
        }
        JPopupMenu[] popup = new JPopupMenu[1];
        JFileChooser fc = isFileChooserComponent(com, popup);
        if (fc != null) {
            if (com == fc) {
                return "JFileChooser.Main";
            } else if (com instanceof JDialog) {
                return "JFileChooser.Dialog";
            } else if (com instanceof JTextField) {
                return "JFileChooser.Filename";
            } else if (com instanceof JButton) {
                String text = ((JButton) com).getText();
                if (logger.level >= Log.DBG) {
                    logger.log(Log.DBG, "getComponentName(Component)",
                               "text: " + text +
                               ", approve:" + fc.getApproveButtonText());
                }
                if (text != null && text.length() > 0) {
                    if (text.equals(fc.getApproveButtonText())
                        || (fc.getApproveButtonText() == null
                            && (text.equals(ResolverHelper.getLocalValue
                                            (com, "FileChooser.openButtonText"))
                                || text.equals(ResolverHelper.getLocalValue
                                               (com, "FileChooser.saveButtonText"))))) {
                        return "JFileChooser.OK";
                    } else if (text.equals(ResolverHelper.getLocalValue
                                           (com, "FileChooser.cancelButtonText"))) {
                        return "JFileChooser.Cancel";
                    }
                } else if (isFilter(com.getParent(), fc)) {
                    return "JFileChooser.Filters.Button";
                } else if (isSearchPath(com.getParent(), fc)) {
                    return "JFileChooser.SearchPath.Button";
                }
            } else if (com instanceof JList) {
                if (popup[0] == null) {
                    return "JFileChooser.List";
                } else if (isFilter(popup[0].getInvoker(), fc)) {
                    return "JFileChooser.Filters.List";
                } else if (isSearchPath(popup[0].getInvoker(), fc)) {
                    return "JFileChooser.SearchPath.List";
                }
            } else if (com instanceof JComboBox) {
                if (isFilter(com, fc)) {
                    return "JFileChooser.Filters";
                } else if (isSearchPath(com, fc)) {
                    return "JFileChooser.SearchPath";
                }
            } else if (com instanceof JScrollPane) {
                if (popup[0] == null) {
                    return "JFileChooser.ListScroll";
                } else if (isFilter(popup[0].getInvoker(), fc)) {
                    return "JFileChooser.Filters.ListScroll";
                } else if (isSearchPath(popup[0].getInvoker(), fc)) {
                    return "JFileChooser.SearchPath.ListScroll";
                }
            } else if (com instanceof JPopupMenu) {
                if (isFilter(((JPopupMenu) com).getInvoker(), fc)) {
                    return "JFileChooser.Filters.Popup";
                } else if (isSearchPath(((JPopupMenu) com).getInvoker(), fc)) {
                    return "JFileChooser.SearchPath.Popup";
                }
            }
            // XXX , Other buttons...
        }
        return null;
    }

    // }}}

    //----------------------------------------------------------------------
    // Helper methods
    //----------------------------------------------------------------------
    // {{{ isFileChooserComponent

    /**
     * Test whether a Component belongs to a JFileChooser.
     *
     * @param   com     The component to test.
     *
     * @return  The JFileChooseror null.
     */
    private JFileChooser isFileChooserComponent(Component com,
                                                JPopupMenu[] popup)
    {
        if (logger.level >= Log.MTD) {
            logger.log(Log.MTD, "isFileChooserComponent(Component)",
                       logger.level < Log.MTDDETAIL ? "" :
                       "com: " + com);
        }
        while (com != null) {
            if (com instanceof JFileChooser) {
                return (JFileChooser) com;
            }
            if (com instanceof Window) {
                if (com instanceof JDialog) {
                    try {
                        return (JFileChooser) ((JDialog) com).getContentPane()
                            .getComponents()[0];
                    } catch(Exception ex) {
                        // ArrayOutOfBounds, ClassCast...
                    }
                }
            }
            if (com instanceof JPopupMenu) {
                popup[0] = (JPopupMenu) com;
            }
            com = com.getParent();
        }
        return null;
    }

    // }}}
    // {{{ isFilter

    /**
     * Check if the component is the Filters combo box.
     *
     * @param   com     The component to test.
     * @param   fc      The JFileChooser parent.
     *
     * @return  True if the component is the Filters combo box.
     */
    private boolean isFilter(Component com, JFileChooser fc)
    {
        if (com instanceof JComboBox) {
            // upper half or lower half
            Point pos = SwingUtilities.convertPoint(com, 0, 0, fc);
            if (pos.y > fc.getSize().height / 2) {
                return true;
            }
        }
        return false;
    }

    // }}}
    // {{{ isSearchPath

    /**
     * Check if the component is SearchPath combo box.
     *
     * @param   com     The component to test.
     * @param   fc      The JFileChooser parent.
     *
     * @return  True if the component is the SearchPath combo box.
     */
    private boolean isSearchPath(Component com, JFileChooser fc)
    {
        if (com instanceof JComboBox) {
            // upper half or lower half
            Point pos = SwingUtilities.convertPoint(com, 0, 0, fc);
            if (pos.y < fc.getSize().height / 2) {
                return true;
            }
        }
        return false;
    }

    // }}}
}
