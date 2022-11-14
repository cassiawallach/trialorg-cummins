<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CSS_Notify_Support_team_on_Claims_Failure</fullName>
        <description>CSS Notify Support team on Claims Failure</description>
        <protected>false</protected>
        <recipients>
            <recipient>IAM_Guidanz_Admin_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Management/CSS_Siebel_Claim_Failure</template>
    </alerts>
    <alerts>
        <fullName>CSS_Notify_Support_team_on_Claims_Failure_from_BMS</fullName>
        <description>CSS Notify Support team on Claims Failure from BMS</description>
        <protected>false</protected>
        <recipients>
            <recipient>IAM_Guidanz_Admin_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Management/CSS_BMS_Claim_Failure</template>
    </alerts>
    <rules>
        <fullName>CSS Notify Support team on Claims failure</fullName>
        <actions>
            <name>CSS_Notify_Support_team_on_Claims_Failure</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Siebel_Status__c) &amp;&amp;  (Siebel_Status__c = &apos;Error&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CSS Notify Support team on Claims failure from BMS</fullName>
        <actions>
            <name>CSS_Notify_Support_team_on_Claims_Failure_from_BMS</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(ERP_Status__c ) &amp;&amp;  (ERP_Status__c = &apos;Error&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
