<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_EVL_Stage_of_wo</fullName>
        <field>EVL_Stage__c</field>
        <literalValue>Job Plan</literalValue>
        <name>Update EVL Stage of wo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>Service_Order__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_WO_status</fullName>
        <field>Status</field>
        <literalValue>Job Plan</literalValue>
        <name>Update WO status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>Service_Order__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>EVL Status Change of Work order on NCTML edit</fullName>
        <actions>
            <name>Update_EVL_Stage_of_wo</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_WO_status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Created as part of CT1-150</description>
        <formula>ISPICKVAL( Service_Order__r.Type__c , &quot;Dealer&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
