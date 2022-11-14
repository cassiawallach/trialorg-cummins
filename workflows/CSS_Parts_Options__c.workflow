<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CSS_Default_Parts_Select_field_update</fullName>
        <field>Selected_Part__c</field>
        <literalValue>1</literalValue>
        <name>CSS Default Parts Select field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ODM_NA_Set</fullName>
        <field>ODM_Status__c</field>
        <literalValue>NA</literalValue>
        <name>ODM NA Set</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>PO Account Code 61 Rule</fullName>
        <actions>
            <name>ODM_NA_Set</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CSS_Parts_Options__c.Account_Code__c</field>
            <operation>contains</operation>
            <value>61</value>
        </criteriaItems>
        <description>When the account code 61 make odm status as na</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
