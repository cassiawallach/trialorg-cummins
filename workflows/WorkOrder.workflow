<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>FSLUpdateEditComplaintField</fullName>
        <field>EditComplaint__c</field>
        <formula>General_Symptoms__c</formula>
        <name>FSLUpdateEditComplaintField</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_WO_Registration_field_with_Asset</fullName>
        <field>Registration__c</field>
        <formula>Asset.Registration__c</formula>
        <name>update WO Registration field with Asset</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_WO_asset_nbr_with_asset_no_field</fullName>
        <field>FSL_CSSP_AssetNumber__c</field>
        <formula>Asset.Name</formula>
        <name>update WO asset nbr with asset no field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_WO_unit_number_field_with_asset</fullName>
        <field>Unit_NB__c</field>
        <formula>Asset.Unit_Number__c</formula>
        <name>update WO unit number field with asset</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
</Workflow>
