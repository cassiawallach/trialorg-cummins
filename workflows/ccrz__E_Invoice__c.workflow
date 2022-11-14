<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Intercompany_notification_to_Primary_Contact</fullName>
        <description>Intercompany notification to Primary Contact</description>
        <protected>false</protected>
        <recipients>
            <field>ccrz__Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>noreply.identity@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Marketplace_Templates/OSM_InterCompany_Invoice</template>
    </alerts>
    <alerts>
        <fullName>OSM_Recurring_Invoice_Email_Alert</fullName>
        <description>OSM_Recurring_Invoice_Email_Alert</description>
        <protected>false</protected>
        <recipients>
            <field>ccrz__Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>noreply.identity@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Marketplace_Templates/OSM_Recurring_Invoice_CC</template>
    </alerts>
    <alerts>
        <fullName>OSM_Revoked_Email_Alert</fullName>
        <description>OSM_Revoked_Email_Alert</description>
        <protected>false</protected>
        <recipients>
            <field>ccrz__Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>noreply.identity@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Marketplace_Templates/OSM_Revoked_Invoice</template>
    </alerts>
    <rules>
        <fullName>OSM_Revoked _WF</fullName>
        <active>true</active>
        <criteriaItems>
            <field>ccrz__E_Invoice__c.ccrz__Status__c</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <criteriaItems>
            <field>ccrz__E_Invoice__c.Payment_Method__c</field>
            <operation>equals</operation>
            <value>cc</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>OSM_Revoked_Email_Alert</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>ccrz__E_Invoice__c.ccrz__DateDue__c</offsetFromField>
            <timeLength>10</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>