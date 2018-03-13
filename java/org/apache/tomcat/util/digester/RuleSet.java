package org.apache.tomcat.util.digester;


public interface RuleSet {

    public String getNamespaceURI();


    public void addRuleInstances(Digester digester);


}
