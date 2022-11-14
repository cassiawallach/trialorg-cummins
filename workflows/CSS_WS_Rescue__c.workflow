<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CSS_WS_Denied_Factory_Email</fullName>
        <description>Denied Factory Email</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CSS_Templates/CSS_WS_Rescue_Denied_Factory</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approved_Rejected_Date_Rescue</fullName>
        <field>CSS_WS_Approved_Rejected_Date__c</field>
        <formula>Today()</formula>
        <name>Approved Rejected Date Rescue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSS_WS_Draft_Status</fullName>
        <field>CSS_WS_RescueStatus__c</field>
        <literalValue>Draft</literalValue>
        <name>Draft Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSS_WS_Status_Approved_Factory</fullName>
        <field>CSS_WS_RescueStatus__c</field>
        <literalValue>Authorized by Planta</literalValue>
        <name>Status Approved Factory</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSS_WS_Status_Pending_Factory</fullName>
        <field>CSS_WS_RescueStatus__c</field>
        <literalValue>Pending Planta Review</literalValue>
        <name>Status Pending Factory</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSS_WS_Status_Rejected_Factory</fullName>
        <field>CSS_WS_RescueStatus__c</field>
        <literalValue>Rejected by Planta</literalValue>
        <name>Status Rejected Factory</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
</Workflow>
