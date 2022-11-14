<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
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
    <fieldUpdates>
        <fullName>Update_SRT_Fetched</fullName>
        <description>To Update SRT_Fetched when ever the Selected Component</description>
        <field>SRT_Fetched__c</field>
        <literalValue>1</literalValue>
        <name>Update SRT_Fetched</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>CSS_Update_SRT_Fetched</fullName>
        <actions>
            <name>Update_SRT_Fetched</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CSS_Solution_Component__c.Selected_Component__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>CSS_Solution_Component__c.SRT_Fetched__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>CSS_Solution_Component__c.GetAccountCodeServiceRun__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>CSS_Solution_Component__c.Over_The_Counter__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Automatically updates SRT_Fetched field to True, when ever the component is selected.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
