<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CSS_SRT_field_action_Account_code</fullName>
        <field>Account_Code__c</field>
        <formula>Component_Id__r.CSS_Account_Formula__c</formula>
        <name>CSS_SRT field action Account code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSS_SRT_field_action_Fail_code</fullName>
        <field>FailCode__c</field>
        <formula>Component_Id__r.Fail_Code__c</formula>
        <name>CSS_SRT field action Fail code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FieldUpdatesToR</fullName>
        <field>Access_Code__c</field>
        <formula>(&quot;R&quot;)</formula>
        <name>FieldUpdatesToR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
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
        <fullName>Flex SRT - Access Code Rule</fullName>
        <actions>
            <name>FieldUpdatesToR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CSS_SRT__c.Flex_Flag__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>For Flex SRTs, Access Code will always be R.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
