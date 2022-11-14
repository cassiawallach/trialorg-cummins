<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CSS_WS_Rejection_Process</fullName>
        <description>Rejection Process</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CSS_Templates/CSS_WS_No_Availability_Denied_Factory</template>
    </alerts>
    <fieldUpdates>
        <fullName>CSS_WS_Update_Authorizer</fullName>
        <field>CSS_WS_Authorizer__c</field>
        <formula>$User.FirstName + &quot; &quot; +  $User.LastName</formula>
        <name>Update Authorizer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSS_WS_Update_to_Approve</fullName>
        <field>CSS_WS_Status__c</field>
        <literalValue>Authorized by planta</literalValue>
        <name>Update to Approve</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSS_WS_Update_to_Draft</fullName>
        <field>CSS_WS_Status__c</field>
        <literalValue>Draft</literalValue>
        <name>Update to Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSS_WS_Update_to_Pending_Approval</fullName>
        <field>CSS_WS_Status__c</field>
        <literalValue>Pending authorization</literalValue>
        <name>Update to Pending Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSS_WS_Update_to_Rejected</fullName>
        <field>CSS_WS_Status__c</field>
        <literalValue>Denied by planta</literalValue>
        <name>Update to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approver</fullName>
        <field>CSS_WS_Authorizer__c</field>
        <formula>$User.Alias</formula>
        <name>Update Approver</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>changetest</fullName>
        <field>CSS_WS_Status__c</field>
        <name>changetest</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>test3</fullName>
        <field>CSS_WS_Comments__c</field>
        <formula>&quot;sí estoy entrando a la seccion antes de los pasos&quot;</formula>
        <name>test3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
</Workflow>
