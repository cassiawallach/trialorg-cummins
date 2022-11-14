<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>FSLPopulateName</fullName>
        <field>Name__c</field>
        <formula>User__r.FirstName &amp; &quot; &quot; &amp; User__r.LastName</formula>
        <name>FSLPopulateName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FSLPopulateRootST</fullName>
        <field>Root_Service_Territory__c</field>
        <formula>IF(ISPICKVAL(Primary_Service_Territory__r.ERP__c, &quot;BMS&quot;), Primary_Service_Territory__r.ParentTerritory.ParentTerritory.ParentTerritory.Name, Primary_Service_Territory__r.ParentTerritory.ParentTerritory.Name)</formula>
        <name>FSLPopulateRootST</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>FSL_Update_Name</fullName>
        <actions>
            <name>FSLPopulateName</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Setup_Resource__c.User__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
