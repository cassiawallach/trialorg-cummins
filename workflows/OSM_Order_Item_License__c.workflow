<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Product_Name</fullName>
        <field>Reissued_OR_Revoked_Product_Name__c</field>
        <formula>Product__c</formula>
        <name>Update Product Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>CC_Order_Item__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Product Name Update on Order Item</fullName>
        <actions>
            <name>Update_Product_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>OSM_Order_Item_License__c.Status__c</field>
            <operation>equals</operation>
            <value>ReIssued</value>
        </criteriaItems>
        <criteriaItems>
            <field>OSM_Order_Item_License__c.Status__c</field>
            <operation>equals</operation>
            <value>Revoked</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
