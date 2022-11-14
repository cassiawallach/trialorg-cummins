<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>FSL_ChangeRecordType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>MOVEX_In_Progress</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>FSL_ChangeRecordType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FSL_UpdateRecordType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Non_Editable</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>FSL_UpdateRecordType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
</Workflow>
