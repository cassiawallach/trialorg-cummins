<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Capitalize_the_Engine_code_value</fullName>
        <field>Engine_Family_Code__c</field>
        <formula>UPPER(Engine_Family_Code__c)</formula>
        <name>Capitalize the Engine code value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FSL_Access_Code</fullName>
        <field>Access_Code__c</field>
        <formula>Make_Model__r.Access__c</formula>
        <name>FSL Access Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FSL_Change_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>FSL_Detail_Asset_Record_Type</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>FSL Change Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FSL_Equipment</fullName>
        <field>Equipment_Configuration__c</field>
        <formula>Make_Model__r.Configuration__c</formula>
        <name>FSL Equipment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FSL_Equipment_Id</fullName>
        <description>To update Equipment Id on Asset</description>
        <field>Equipment_Id__c</field>
        <formula>Make_Model__r.EquipmentId__c</formula>
        <name>FSL Equipment Id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FSL_Make</fullName>
        <field>Make__c</field>
        <formula>Make_Model__r.Make__c</formula>
        <name>FSL Make</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FSL_Model</fullName>
        <field>Model__c</field>
        <formula>Make_Model__r.Model__c</formula>
        <name>FSL Model</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FSL_Type_PSN_Update</fullName>
        <field>Type_PSN__c</field>
        <formula>IF(NOT(ISPICKVAL($User.ERP__c, &quot;BMS&quot;)), &apos;Engines-&apos; + Name,
IF(TEXT(Type__c) = &apos;Engines&apos; || TEXT(Type__c) = &apos;ENGINE&apos; || TEXT(Type__c) = &apos;GENSET&apos;,
&apos;Engines-&apos; + Name, &apos;Products-&apos; + Name
)
)</formula>
        <name>FSL Type-PSN Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>CAPS Engine family code field</fullName>
        <actions>
            <name>Capitalize_the_Engine_code_value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Asset.Engine_Family_Code__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>CT2-428</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>FSL Change Asset Layout</fullName>
        <actions>
            <name>FSL_Change_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>FSL_Type_PSN_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Asset.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>CSS_Service_Advanced,CSS_Service_Technician,CSS_CPS_Advanced</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>FSL Make Model</fullName>
        <actions>
            <name>FSL_Access_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>FSL_Equipment</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>FSL_Equipment_Id</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>FSL_Make</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>FSL_Model</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISBLANK(Make_Model__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
