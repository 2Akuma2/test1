// {{{ copyright

/********************************************************************
 *
 * Copyright (C) 2004 Gregor Schmid, Quality First Software
 * All rights reserved
 *
 *******************************************************************/

// }}}

package de.qfs.apps.qftest.extensions.qftest;

// {{{ imports

import java.util.Vector;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import lombok.extern.qfs.QFLog;

import de.qfs.lib.util.Misc;

// }}}

/**
 * A DOMProcessor implementation that processes the text content of a node,
 * splitting it into paragraphs at empty lines.
 *
 * @author      Gregor Schmid
 */
@QFLog
public class ParagraphProcessor
    implements DOMProcessor
{
    // {{{ variables

    // }}}

    //----------------------------------------------------------------------
    // Constructor
    //----------------------------------------------------------------------
    // {{{ ParagraphProcessor

    /**
     * Create a new ParagraphProcessor.
     */
    @QFLog(skipMtd=true)
    public ParagraphProcessor ()
    {
    }

    // }}}

    // {{{ process

    /**
     * Process one element node. Parse its text content, looking for empty
     * lines. If there's more than one paragraph, replace the node's text
     * content with a list of &lt;p&gt; nodes.
     *
     * @param   node    The node to process.
     *
     * @return Null to enable processing of child nodes.
     */
    @Override
    public Element process(Element node)
    {
        // Merge all text child nodes
        node.normalize();

        // Only process if there's exactly one text child node
        NodeList txt = node.getChildNodes();
        if (txt == null
            || txt.getLength() != 1
            || txt.item(0).getNodeType() != Node.TEXT_NODE) {
            return null;
        }

        String text = txt.item(0).getNodeValue();
        qflog(DBG, text);

        Vector paras = new Vector ();
        Vector lines = new Vector ();
        String[] split = Misc.splitLines(text);

        for (int i = 0; i < split.length; i++) {
            String line = split[i].trim();
            qflog(DBG, line);
            if (line.length() == 0) {
                if (lines.size() > 0) {
                    paras.addElement(lines);
                    lines = new Vector ();
                }
            } else {
                lines.addElement(line);
            }
        }

        if (lines.size() > 0) {
            paras.addElement(lines);
        }

        if (paras.size() > 1) {
            // Several paragraphs
            Document doc = node.getOwnerDocument();
            for (int i = 0; i < paras.size(); i++) {
                lines = (Vector) paras.elementAt(i);
                StringBuffer sb = new StringBuffer ();
                for (int j = 0; j < lines.size(); j++) {
                    if (j > 0) {
                        sb.append("\n");
                    }
                    sb.append((String) lines.elementAt(j));
                }
                // Append one <p> element per paragraph
                Element para = doc.createElement("p");
                para.appendChild(doc.createTextNode(sb.toString()));
                node.appendChild(para);
            }
            // Remove the original text node
            node.removeChild(txt.item(0));
        }
        return null;
    }

    // }}}
}
