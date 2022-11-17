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
import java.awt.Window;

import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JLabel;
import javax.swing.JOptionPane;

import de.qfs.lib.log.Log;
import de.qfs.lib.log.Logger;

// }}}

/**
 * Name resolver for JOptionPane components.
 *
 * @author      Karlheinz Kellerer
 */
public class JOptionPaneResolver
    implements ComponentNameResolver
{
    // {{{ variables

    /**
     * The Logger used for logging.
     */
    private final static Logger logger =
        new Logger ("de.qfs.apps.qftest.extensions.JOptionPaneResolver");

    /**
     * Singleton instance.
     */
    protected static JOptionPaneResolver instance = new JOptionPaneResolver ();

    /**
     * Whether the resolver is installed.
     */
    protected boolean installed;

    // }}}

    //----------------------------------------------------------------------
    // Constructor
    //----------------------------------------------------------------------
    // {{{ JOptionPaneResolver

    /**
     * Create a new JOptionPaneResolver.
     */
    protected JOptionPaneResolver ()
    {
        if (logger.level >= Log.MTD) {
            logger.log(Log.MTD, "JOptionPaneResolver()", "");
        }
    }

    // }}}

    //----------------------------------------------------------------------
    // Static convenience methods
    //----------------------------------------------------------------------
    // {{{ install

    /**
     * Register the JOptionPaneResolver instance as global
     * ComponentNameResolver.
     */
    public static void install()
    {
        ResolverRegistry.instance().registerComponentNameResolver(instance);
        instance.installed = true;
    }

    // }}}
    // {{{ uninstall

    /**
     * Register the JOptionPaneResolver instance as global
     * ComponentNameResolver.
     */
    public static void uninstall()
    {
        ResolverRegistry.instance().unregisterComponentNameResolver(instance);
        instance.installed = false;
    }

    // }}}
    // {{{ isInstalled

    /**
     * Test whether the JOptionPaneResolver is installed.
     *
     * @return  True if the resolver is installed, false otherwise.
     */
    public static boolean isInstalled()
    {
        return instance.installed;
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

//         if ( com.getName() != null
//             // the JOptionPaneResolver might have a name set, but for the
//             // sake of unification we need to override that
//             && ! ((com instanceof JDialgo) ||
//                   (com instanceof JButton) ||
//                   (com instanceof JLabel))
//             && ! ComponentHelper.isTrivialName(com.getName())) {
//             // Never interfere with others
//             return null;
//         }
        if ( ! ((com instanceof JDialog) ||
                (com instanceof JButton) ||
                (com instanceof JLabel))     ) {
            // We are only looking for these components
            return null;
        }


        JOptionPane op = isOptionPaneComponent(com);
        if (op != null) {
            String type = new String ();

            switch (op.getMessageType())
            {
                case JOptionPane.ERROR_MESSAGE:
                    type = "ErrorDialog";
                    break;
                case JOptionPane.INFORMATION_MESSAGE:
                    type = "InfoDialog";
                    break;
                case JOptionPane.WARNING_MESSAGE:
                    type = "WarningDialog";
                    break;
                case JOptionPane.QUESTION_MESSAGE:
                    type = "QuestionDialog";
                    break;
                default:
                    type = "PlainDialog";
            }

            if (com instanceof JDialog) {
                return "JOptionPane." + type;
            }
            else if (com instanceof JButton) {
                String text = ((JButton)com).getText();
                if (text != null && text.length() > 0) {
                    if (text.equals(ResolverHelper.getLocalValue
                                    (com, "OptionPane.okButtonText"))) {
                        return  "JOptionPane." + type + ".OK";
                    } else if (text.equals(ResolverHelper.getLocalValue
                                           (com, "OptionPane.cancelButtonText"))) {
                        return "JOptionPane." + type +".CANCEL";
                    } else if (text.equals(ResolverHelper.getLocalValue
                                           (com, "OptionPane.yesButtonText"))) {
                        return "JOptionPane." + type + ".YES";
                    } else if (text.equals(ResolverHelper.getLocalValue
                                           (com, "OptionPane.noButtonText"))) {
                        return "JOptionPane." + type + ".NO";
                    } else {
                        Component [] buttons = com.getParent().getComponents();
                        for (int i = 0; i < buttons.length; i++) {
                            if (buttons[i] instanceof JButton && (JButton)buttons[i] == com) {
                                return "JOptionPane." + type + ".Custom" + (i + 1);
                            }
                        }
                    }
                }
            }
            else if (com instanceof JLabel) {
                Component [] labels = com.getParent().getComponents();
                for (int i = 0; i < labels.length; i++) {
                    if (labels[i] instanceof JLabel
                        && (JLabel)labels[i] == com
                        // we are not interested in empty labels
                        && ((JLabel)labels[i]).getText() != null) {
                        return "JOptionPane." + type + ".Label" + (i + 1);
                    }
                }
           }
           // XXX , Other custon components ...

        }
        return null;
    }

    // }}}

    //----------------------------------------------------------------------
    // Helper methods
    //----------------------------------------------------------------------
    // {{{ isOptionPaneComponent

    /**
     * Test whether a Component belongs to a JOptionPane.
     *
     * @param   com     The component to test.
     *
     * @return  The JOptionPane or null.
     */
    private JOptionPane isOptionPaneComponent(Component com)
    {
        if (logger.level >= Log.MTD) {
            logger.log(Log.MTD, "isOptionPaneComponent(Component)",
                       logger.level < Log.MTDDETAIL ? "" :
                       "com: " + com);
        }
        while (com != null) {
            if (com instanceof JOptionPane) {
                return (JOptionPane) com;
            }
            if (com instanceof Window) {
                if (com instanceof JDialog) {
                    try {
                        // The option pane is the first component added to the dialogs content pane
                        return (JOptionPane) ((JDialog) com).getContentPane().getComponents()[0];
                    } catch(Exception ex) {
                        // ArrayOutOfBounds, ClassCast...
                    }
                }
                else {
                    // If a window is found which is no dialog, we can stop searching
                    return null;
                }
            }
            com = com.getParent();
        }
        return null;
    }

    // }}}
}
