/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


package org.apache.tomcat.util.digester;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;


/**
 * <p>Default implementation of the <code>Rules</code> interface that supports
 * the standard rule matching behavior.  This class can also be used as a
 * base class for specialized <code>Rules</code> implementations.</p>
 *
 * <p>The matching policies implemented by this class support two different
 * types of pattern matching rules:</p>
 * <ul>
 * <li><em>Exact Match</em> - A pattern "a/b/c" exactly matches a
 *     <code>&lt;c&gt;</code> element, nested inside a <code>&lt;b&gt;</code>
 *     element, which is nested inside an <code>&lt;a&gt;</code> element.</li>
 * <li><em>Tail Match</em> - A pattern "&#42;/a/b" matches a
 *     <code>&lt;b&gt;</code> element, nested inside an <code>&lt;a&gt;</code>
 *      element, no matter how deeply the pair is nested.</li>
 * </ul>
 */

public class RulesBase implements Rules {


    // ----------------------------------------------------- Instance Variables


    /**
     * The set of registered Rule instances, keyed by the matching pattern.
     * Each value is a List containing the Rules for that pattern, in the
     * order that they were originally registered.
     */
    protected HashMap<String,List<Rule>> cache = new HashMap<>();


    /**
     * The Digester instance with which this Rules instance is associated.
     */
    protected Digester digester = null;


    /**
     * The namespace URI for which subsequently added <code>Rule</code>
     * objects are relevant, or <code>null</code> for matching independent
     * of namespaces.
     */
    protected String namespaceURI = null;


    /**注册Rule实例的Set几个,按照注册的方式排序*/
    protected ArrayList<Rule> rules = new ArrayList<>();


    // ------------------------------------------------------------- Properties


    /**
     * Return the Digester instance with which this Rules instance is
     * associated.
     */
    @Override
    public Digester getDigester() {

        return (this.digester);

    }



    @Override
    public void setDigester(Digester digester) {

        this.digester = digester;
        //设置digester的时候将所有的Rule设置为当前digester对象
        Iterator<Rule> items = rules.iterator();
        while (items.hasNext()) {
            Rule item = items.next();
            item.setDigester(digester);
        }

    }


    /**
     * Return the namespace URI that will be applied to all subsequently
     * added <code>Rule</code> objects.
     */
    @Override
    public String getNamespaceURI() {

        return (this.namespaceURI);

    }


    /**
     * Set the namespace URI that will be applied to all subsequently
     * added <code>Rule</code> objects.
     *
     * @param namespaceURI Namespace URI that must match on all
     *  subsequently added rules, or <code>null</code> for matching
     *  regardless of the current namespace URI
     */
    @Override
    public void setNamespaceURI(String namespaceURI) {

        this.namespaceURI = namespaceURI;

    }


    // --------------------------------------------------------- Public Methods


    /**注册一个新的Rule实例匹配指定的模式*/
    @Override
    public void add(String pattern, Rule rule) {
        //如果以／结束,将最后的斜杠给去掉
        int patternLength = pattern.length();
        if (patternLength>1 && pattern.endsWith("/")) {
            pattern = pattern.substring(0, patternLength-1);
        }

        //从cache获取当前pattern的规则集合,如果不存在则构建ArrayList实例,并且put到cache
        List<Rule> list = cache.get(pattern);
        if (list == null) {
            list = new ArrayList<>();
            cache.put(pattern, list);
        }
        //将当前新添加的规则存入到当前list集合
        list.add(rule);
        //将规则添加到一个全局的rules集合
        rules.add(rule);
        //给当前规则设置digester
        if (this.digester != null) {
            rule.setDigester(this.digester);
        }
        //设置namespaceURI
        if (this.namespaceURI != null) {
            rule.setNamespaceURI(this.namespaceURI);
        }

    }


    /**
     * Clear all existing Rule instance registrations.
     */
    @Override
    public void clear() {

        cache.clear();
        rules.clear();

    }


    /**
     * Return a List of all registered Rule instances that match the specified
     * nesting pattern, or a zero-length List if there are no matches.  If more
     * than one Rule instance matches, they <strong>must</strong> be returned
     * in the order originally registered through the <code>add()</code>
     * method.
     *
     * @param namespaceURI Namespace URI for which to select matching rules,
     *  or <code>null</code> to match regardless of namespace URI
     * @param pattern Nesting pattern to be matched
     */
    @Override
    public List<Rule> match(String namespaceURI, String pattern) {

        // List rulesList = (List) this.cache.get(pattern);
        List<Rule> rulesList = lookup(namespaceURI, pattern);
        if ((rulesList == null) || (rulesList.size() < 1)) {
            // Find the longest key, ie more discriminant
            String longKey = "";
            Iterator<String> keys = this.cache.keySet().iterator();
            while (keys.hasNext()) {
                String key = keys.next();
                if (key.startsWith("*/")) {
                    if (pattern.equals(key.substring(2)) ||
                        pattern.endsWith(key.substring(1))) {
                        if (key.length() > longKey.length()) {
                            // rulesList = (List) this.cache.get(key);
                            rulesList = lookup(namespaceURI, key);
                            longKey = key;
                        }
                    }
                }
            }
        }
        if (rulesList == null) {
            rulesList = new ArrayList<>();
        }
        return (rulesList);

    }


    /**
     * Return a List of all registered Rule instances, or a zero-length List
     * if there are no registered Rule instances.  If more than one Rule
     * instance has been registered, they <strong>must</strong> be returned
     * in the order originally registered through the <code>add()</code>
     * method.
     */
    @Override
    public List<Rule> rules() {

        return (this.rules);

    }


    // ------------------------------------------------------ Protected Methods


    /**
     * Return a List of Rule instances for the specified pattern that also
     * match the specified namespace URI (if any).  If there are no such
     * rules, return <code>null</code>.
     *
     * @param namespaceURI Namespace URI to match, or <code>null</code> to
     *  select matching rules regardless of namespace URI
     * @param pattern Pattern to be matched
     */
    protected List<Rule> lookup(String namespaceURI, String pattern) {

        // Optimize when no namespace URI is specified
        List<Rule> list = this.cache.get(pattern);
        if (list == null) {
            return (null);
        }
        if ((namespaceURI == null) || (namespaceURI.length() == 0)) {
            return (list);
        }

        // Select only Rules that match on the specified namespace URI
        ArrayList<Rule> results = new ArrayList<>();
        Iterator<Rule> items = list.iterator();
        while (items.hasNext()) {
            Rule item = items.next();
            if ((namespaceURI.equals(item.getNamespaceURI())) ||
                    (item.getNamespaceURI() == null)) {
                results.add(item);
            }
        }
        return (results);

    }


}
