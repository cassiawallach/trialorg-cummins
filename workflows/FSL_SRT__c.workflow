<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>FSL_Access_Code_Update</fullName>
        <field>SRT_Access_Code__c</field>
        <formula>&apos;R&apos;</formula>
        <name>FSL Access Code Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FSL_SRT_EQID_Access_Update</fullName>
        <field>SRT_Access_Code__c</field>
        <formula>EQID_Access_Code__c</formula>
        <name>FSL SRT EQID Access Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FSL_SRT_EQID_Time_Update</fullName>
        <field>SRT_Time__c</field>
        <formula>CASE(EQID_Access_Code__c, 
&quot;A&quot;, Access_Code_A__c, 
&quot;B&quot;, Access_Code_B__c,
&quot;C&quot;, Access_Code_C__c,
&quot;D&quot;, Access_Code_D__c,
0)</formula>
        <name>FSL SRT EQID Time Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FSL_SRT_RTime_Update</fullName>
        <field>SRT_Time__c</field>
        <formula>Access_Code_R__c</formula>
        <name>FSL SRT RTime Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>FSL SRT EQID Access</fullName>
        <actions>
            <name>FSL_SRT_EQID_Access_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>FSL_SRT_EQID_Time_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( Use_R_Time__c ) &amp;&amp; ( Use_R_Time__c  = FALSE )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>FSL SRT RTime Update</fullName>
        <actions>
            <name>FSL_Access_Code_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>FSL_SRT_RTime_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( Use_R_Time__c ) &amp;&amp; ( Use_R_Time__c  = TRUE )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
