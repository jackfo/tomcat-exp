<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE hibernate-mapping PUBLIC "-//Hibernate/Hibernate Mapping DTD 3.0//EN"
	"http://hibernate.sourceforge.net/hibernate-mapping-3.0.dtd">

<hibernate-mapping>
	<class entity-name="${entity.name}" table="${entity.alias}">
		<id name="id" column="`ID`" type="long" >
			<generator class="increment" />
		</id>
		<#if entity.attrs?exists>
			<#list entity.attrs as attr>
				<#if attr.name == "id">
				<#elseif attr.clazz?contains("#")>
		<many-to-one name="${attr.name}" class="${attr.clazz?replace("#","")}" column="`${((attr.alias?replace("#ID",""))?replace("#INSERTDATE",""))?replace("#ISSENT","")}`"/>
				<#elseif attr.clazz=="java.lang.String">
		<property name="${attr.name}" type="java.lang.String" column="`${((attr.alias?replace("#ID",""))?replace("#INSERTDATE",""))?replace("#ISSENT","")}`" length="${attr.length?c}"/>
				<#else>
		<property name="${attr.name}" type="${attr.clazz}" column="`${((attr.alias?replace("#ID",""))?replace("#INSERTDATE",""))?replace("#ISSENT","")}`"/>
				</#if>
			</#list>
		</#if>
		<!-- 1:sent, null:not sent, 99:not previously sent -->
		<property name="isSent" type="java.lang.Integer" column="`ISSENT`"/>
		<property name="insertDate" type="java.sql.Timestamp" column="`INSERTDATE`"/>
	</class>
</hibernate-mapping>