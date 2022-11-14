<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CCM_Case_Status_to_Reopened</fullName>
        <field>Status</field>
        <literalValue>Re-Opened</literalValue>
        <name>CCM Case Status to Reopened</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CCM_Update_Case_Status_to_Received</fullName>
        <field>Status</field>
        <literalValue>Received – In Process</literalValue>
        <name>CCM Update Case Status to Received</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSTS_Case_Status_Pending</fullName>
        <field>Status</field>
        <literalValue>Pending</literalValue>
        <name>CSTS Case Status Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSTS_Case_Status_to_Response_Received</fullName>
        <field>Status</field>
        <literalValue>Response Received</literalValue>
        <name>CSTS Case Status to Response Received</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSTS_First_Response_update</fullName>
        <field>CSTS_Initial_Response_Check_Box__c</field>
        <literalValue>1</literalValue>
        <name>CSTS First Response update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSTS_Response_date_update</fullName>
        <description>To update Response Date field</description>
        <field>CSTS_Response_Date__c</field>
        <formula>NOW()</formula>
        <name>CSTS Response date update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSTS_Update_First_Response_Time</fullName>
        <field>CSTS_First_Response_Time__c</field>
        <formula>NOW()</formula>
        <name>CSTS Update First Response Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>InBond_Mail_Field_Update</fullName>
        <field>Is_Inbond_Mail__c</field>
        <literalValue>1</literalValue>
        <name>InBond Mail Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>CSTS Case Status Pending</fullName>
        <actions>
            <name>CSTS_Case_Status_Pending</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Opened,Escalated,Response Received</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>OneC Care,OneC UK Insider Sales,Cummins Care Request,OneC CBS</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CSTS Case Status to Response Received</fullName>
        <actions>
            <name>CSTS_Case_Status_to_Response_Received</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CSTS_Response_date_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Cummins Care Request,OneC CBS,OneC Care,OneC UK Insider Sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Opened,Pending,Re-Opened,Closed,Escalated,Cancelled</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CSTS Check First Response</fullName>
        <actions>
            <name>CSTS_Update_First_Response_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Case.CSTS_First_Response_Time__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Cummins Care Request,OneC CBS,OneC Care,OneC UK Insider Sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>CSTS Email,CBSNADAP,CBSAP,OneC PrevenTech</value>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.ReplyToEmailMessageId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CSTS First Response Email</fullName>
        <actions>
            <name>CSTS_First_Response_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ToAddress =Parent.Contact.Email, Incoming=false,OR(Parent.RecordType.Name =&quot;Cummins Care Request&quot;,Parent.RecordType.Name =&quot;OneC CBS&quot;), FromName=&quot;1300Cummins&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email Message Incoming</fullName>
        <actions>
            <name>InBond_Mail_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.Subject</field>
            <operation>notEqual</operation>
            <value>Unsubscribe request</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
