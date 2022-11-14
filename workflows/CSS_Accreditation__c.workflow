<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>OSM_Service_Level_Update_Field_Check</fullName>
        <field>Service_Level_Update__c</field>
        <literalValue>1</literalValue>
        <name>OSM Service Level Update Field Check</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>OSM_Service_Level_Update</fullName>
        <actions>
            <name>OSM_Service_Level_Update_Field_Check</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>(ISCHANGED(Product_Details__c) || ISCHANGED(Service_Level__c)) &amp;&amp; (Account__c != NULL) &amp;&amp; Service_Level_Update__c != true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
