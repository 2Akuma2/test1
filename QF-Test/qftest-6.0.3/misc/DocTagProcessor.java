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

import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;

import org.w3c.dom.Attr;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import lombok.extern.qfs.QFLog;

import de.qfs.lib.util.Misc;

import de.qfs.apps.qftest.shared.Util;

// }}}

/**
 * A DOMProcessor implementation that processes the text content of a node,
 * splitting it into paragraphs at empty lines.
 *
 * @author      Gregor Schmid
 */
@QFLog
public class DocTagProcessor
    implements DOMProcessor
{
    // {{{ variables

    /**
     * The supported tags in the order in which they should be created.
     */
    private final static String[] orderedTagsPackage = new String[] {
        "deprecated", "author", "version", "since"};

    /**
     * Matching name counts for the tags.
     */
    private final static  int[] countsPackage = new int[] {0, 0, 0, 0};

    /**
     * The supported tags in the order in which they should be created.
     */
    private final static String[] orderedTagsProcedure = new String[] {
        "deprecated", "param", "return", "result", "throws", "author", "version", "since"};

    /**
     * Matching name counts for the tags.
     */
    private final static  int[] countsProcedure = new int[] {0, 1, 0, 0, 1, 0, 0, 0};

    /**
     * The supported tags in the order in which they should be created.
     */
    private final static String[] orderedTagsDependency = new String[] {
        "deprecated", "param", "charvar", "result", "catches", "author", "version", "since"};

    /**
     * Matching name counts for the tags.
     */
    private final static  int[] countsDependency = new int[] {0, 1, 1, 0, 1, 0, 0, 0};

    /**
     * The supported tags in the order in which they should be created.
     */
    private final static String[] orderedTagsTestsuite = new String[] {
        "title", "deprecated", "param", "author", "version", "since"};

    /**
     * Matching name counts for the tags.
     */
    private final static  int[] countsTestsuite = new int[] {0, 0, 1, 0, 0, 0};

    /**
     * The supported tags in the order in which they should be created.
     */
    private final static String[] orderedTagsTestset = new String[] {
        "deprecated", "condition", "param", "charvar", "author", "version", "since"};

    /**
     * Matching name counts for the tags.
     */
    private final static  int[] countsTestset = new int[] {0, 0, 1, 1, 0, 0, 0};

    /**
     * The supported tags in the order in which they should be created.
     */
    private final static String[] orderedTagsTestcase = new String[] {
        "deprecated", "condition", "param", "charvar", "author", "version", "since"};

    /**
     * Matching name counts for the tags.
     */
    private final static  int[] countsTestcase = new int[] {0, 0, 1, 1, 0, 0, 0};

    /**
     * The supported tags in the order in which they should be created.
     */
    private final static String[] orderedTagsTeststep = new String[] {
        "author", "version", "since"};

    /**
     * Matching name counts for the tags.
     */
    private final static  int[] countsTeststep = new int[] {0, 0, 0};

    /**
     * Mapping from tag name to ordererd tags.
     */
    private final static Hashtable orderedTags = new Hashtable ();

    /**
     * Mapping from tag name to mapping from tag to count.
     */
    private final static Hashtable definedTags = new Hashtable ();

    // Initialize definedTags.
    static{
        orderedTags.put("package", orderedTagsPackage);
        orderedTags.put("procedure", orderedTagsProcedure);
        orderedTags.put("dependency", orderedTagsDependency);
        orderedTags.put("test-suite", orderedTagsTestsuite);
        orderedTags.put("testset", orderedTagsTestset);
        orderedTags.put("testcase", orderedTagsTestcase);
        orderedTags.put("teststep", orderedTagsTeststep);
        Hashtable tmp = new Hashtable ();
        for (int i = 0; i < orderedTagsPackage.length; i++) {
            tmp.put(orderedTagsPackage[i], new Integer (countsPackage[i]));
        }
        definedTags.put("package", tmp);
        tmp = new Hashtable ();
        for (int i = 0; i < orderedTagsProcedure.length; i++) {
            tmp.put(orderedTagsProcedure[i], new Integer (countsProcedure[i]));
        }
        definedTags.put("procedure", tmp);
        tmp = new Hashtable ();
        for (int i = 0; i < orderedTagsDependency.length; i++) {
            tmp.put(orderedTagsDependency[i], new Integer (countsDependency[i]));
        }
        definedTags.put("dependency", tmp);
        tmp = new Hashtable ();
        for (int i = 0; i < orderedTagsTestsuite.length; i++) {
            tmp.put(orderedTagsTestsuite[i], new Integer (countsTestsuite[i]));
        }
        definedTags.put("test-suite", tmp);
        tmp = new Hashtable ();
        for (int i = 0; i < orderedTagsTestset.length; i++) {
            tmp.put(orderedTagsTestset[i], new Integer (countsTestset[i]));
        }
        definedTags.put("testset", tmp);
        tmp = new Hashtable ();
        for (int i = 0; i < orderedTagsTestcase.length; i++) {
            tmp.put(orderedTagsTestcase[i], new Integer (countsTestcase[i]));
        }
        definedTags.put("testcase", tmp);
        tmp = new Hashtable ();
        for (int i = 0; i < orderedTagsTeststep.length; i++) {
            tmp.put(orderedTagsTeststep[i], new Integer (countsTeststep[i]));
        }
        definedTags.put("teststep", tmp);
    }

    // }}}

    //----------------------------------------------------------------------
    // Constructor
    //----------------------------------------------------------------------
    // {{{ DocTagProcessor

    /**
     * Create a new DocTagProcessor.
     */
    @QFLog(skipMtd=true)
    public DocTagProcessor ()
    {
    }

    // }}}

    //------------------------------------------------------------------------------------------
    // DOMProcessor interface
    //------------------------------------------------------------------------------------------
    // {{{ process

    /**
     * Process one procedure or package node: Parse the comment, extract the pkgdoc tags and build
     * a matching DOM subtree.
     *
     * @param   node    The node to process.
     *
     * @return Null to enable processing of child nodes.
     */
    @Override
    public Element process(Element node)
    {
        try {
        String element = node.getTagName();

        // Only handle procedure, package, test-suite, testset, testcase and teststep nodes.
        if (! element.equals("procedure")
            && ! element.equals("package")
            && ! element.equals("dependency")
            && ! element.equals("test-suite")
            && ! element.equals("testset")
            && ! element.equals("testcase")
            && ! element.equals("teststep")) {
            return null;
        }

        // Look for the comment.
        NodeList nl = node.getElementsByTagName("comment");
        qflog(DBG, nl);
        if (nl == null || nl.getLength() == 0) {
            return null;
        }

        Node comment = nl.item(0);
        if (comment.getParentNode() != node) {
            // Beware of grandchildren
            qflog(DBG, "Not a child node");
            return null;
        }

        // Merge all text child nodes
        comment.normalize();
        qflog(DBG, comment);

        NodeList txt = comment.getChildNodes();
        qflog(DBG, txt);
        if (txt == null || txt.getLength() == 0) {
            node.removeChild(comment);
            // [issue184] Must return null, otherwise package children won't be processed.
            return null;
        }

        // Parse doctags
        Hashtable tags = parse(element, txt.item(0).getNodeValue());
        qflog(DBG, tags);
        if (tags == null) {
            // Empty comment, remove it
            node.removeChild(comment);
            // [issue184] Must return null, otherwise package children won't be processed.
            return null;
        }

        if (tags.size() == 0) {
            // No doctags.
            // [issue184] Must return null, otherwise package children won't be processed.
            return null;
        }

        // Create new nodes for the comment and tags
        Document doc = node.getOwnerDocument();

        // Comment first
        if (tags.containsKey("comment")) {
            // Create new comment node
            Element cmt = doc.createElement("comment");
            cmt.appendChild(doc.createTextNode((String) tags.get("comment")));
            qflog(DBG, cmt);
            qflog(DBG, comment);
            node.insertBefore(cmt, comment);
        }

        // Now the tags in the predefined order
        String[] ot = (String[]) orderedTags.get(element);
        for (int i = 0; i < ot.length; i++) {
            if (tags.containsKey(ot[i])) {
                Object values = tags.get(ot[i]);
                qflog(DBG, values);
                if (values instanceof String) {
                    Element child = doc.createElement(ot[i]);
                    child.appendChild(doc.createTextNode((String) values));
                    node.insertBefore(child, comment);
                } else {
                    for (int j = 0; j < ((ArrayList) values).size(); j++) {
                        String[] value = (String[]) ((ArrayList) values).get(j);
                        // Create one element node per tag value
                        Element child = doc.createElement(ot[i]);
                        child.setAttribute("name", value[0]);
                        child.appendChild(doc.createTextNode(value[1]));
                        node.insertBefore(child, comment);
                    }
                }
            }
        }
        // Finally remove the original comment node
        node.removeChild(comment);
        Attr screenshotAttr = node.getAttributeNode("sfile0");
        qflog(DBG, screenshotAttr);
        if (screenshotAttr != null) {
            String val = screenshotAttr.getValue();
            Element ssNode = doc.createElement("screenshot");
            node.appendChild(ssNode);
            node.removeAttributeNode(screenshotAttr);
        }
        // [issue184] Must return null, otherwise package children won't be processed.
        return null;
        } catch (Throwable ex) {
            qflog(ERR, ex);
            return null;
        }
    }

    // }}}

    //------------------------------------------------------------------------------------------
    // Helper methods
    //------------------------------------------------------------------------------------------
    // {{{ parse

    /**
     * Parse one comment for doctags.
     *
     * @param   element The current element type.
     * @param   text    The string to parse.
     *
     * @return A Hashtable where the keys are tag names (or 'comment') and the values are lists of
     * tag values (there may be multiple params for example). Named values (like @param) are
     * represented as pairs [name, description], simple values are plain strings.
     */
    private Hashtable parse(String element, String text)
    {
        if (Misc.emptyOrNull(text)) {
            return null;
        }

        Hashtable result = new Hashtable ();

        String stripped = Util.stripDoctags(text);
        if (Misc.equalOrEmpty(stripped, text.trim())) {
            qflog(DBG, stripped);
            // No tags.
            return result;
        }

        result.put("comment", stripped);

        String[] ordered = (String[]) orderedTags.get(element);
        Hashtable defined = (Hashtable) definedTags.get(element);

        for (int i = 0; i < ordered.length; i++) {
            int named = ((Integer) defined.get(ordered[i])).intValue();
            if (named == 0) {
                String tag = Util.getDoctag(text, ordered[i]);
                if (tag != null) {
                    result.put(ordered[i], tag);
                }
            } else {
                List tags = Util.getNamedDoctags(text, ordered[i]);
                if (tags.size() > 0) {
                    result.put(ordered[i], tags);
                }
            }
        }
        return result;
    }

    // }}}
}
