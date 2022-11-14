<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CSS_EUJobReviewEmail</fullName>
        <description>Email alert sent to users when the job is moved to Review</description>
        <protected>false</protected>
        <recipients>
            <field>Email_Review__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply.identity@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CSS_Templates/CSS_EUJobReviewEmail</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_NYCT_Repairs_for_NF</fullName>
        <ccEmails>CSS_NYCT_Internal_Repairs@cummins.com,James_hamilton@newflyer.com,Vincent_Albino@newflyer.com,Anthony_Cirillo@newflyer.com,Brian_Smith@newflyer.com</ccEmails>
        <description>Email Alert NYCT Repairs for NF</description>
        <protected>false</protected>
        <recipients>
            <recipient>kelvina.rivera.ph867@cummins.com.cso</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CSS_Templates/CSS_Jobclosure_Email</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_NYCT_Repairs_for_NOVA</fullName>
        <ccEmails>CSS_NYCT_Internal_Repairs@cummins.com; brent.evans@volvo.com; pierre-olivier.trudel@volvo.com; michael.quinn@volvo.com</ccEmails>
        <description>Email Alert NYCT Repairs for NOVA</description>
        <protected>false</protected>
        <recipients>
            <recipient>kelvina.rivera.ph867@cummins.com.cso</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CSS_Templates/CSS_Jobclosure_Email</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_to_NYCT_Internal_Repairs</fullName>
        <ccEmails>CSS_NYCT_Internal_Repairs@cummins.com</ccEmails>
        <description>Email Alert to NYCT Internal Repairs</description>
        <protected>false</protected>
        <recipients>
            <recipient>kelvina.rivera.ph867@cummins.com.cso</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CSS_Templates/CSS_Jobclosure_Email</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Engine_Tech_Support</fullName>
        <ccEmails>ml237@cummins.com, nt382@cummins.com</ccEmails>
        <description>Send Email to Engine Tech Support</description>
        <protected>false</protected>
        <recipients>
            <field>RPV_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CSS_Templates/CSS_RPV_Email_Alert</template>
    </alerts>
    <fieldUpdates>
        <fullName>CSS_EditComplaintUpdate</fullName>
        <field>General_Symptoms__c</field>
        <formula>General_Symptoms__c</formula>
        <name>CSS_EditComplaintUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ComplaintUpdate</fullName>
        <field>EditComplaint__c</field>
        <formula>General_Symptoms__c</formula>
        <name>ComplaintUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Email_Review</fullName>
        <field>Email_Review__c</field>
        <formula>CASE(Territory_Class_Name__c, 
&quot;BELGIUM&quot;, $Label.CSS_Belgium, 
&quot;NETHERLANDS&quot;, $Label.CSS_Holland,
&quot;HOLLAND&quot;, $Label.CSS_Holland, 
&quot;SPAIN&quot;, $Label.CSS_Spain, 
&quot;&quot;)</formula>
        <name>Email_Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>CSS_EUJobReviewEmail</fullName>
        <actions>
            <name>CSS_EUJobReviewEmail</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Review</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>An automated email notification ,when a job is sent for review(after triage and after repair). Email should be sent to a defined list of recipients for Belgium, Spain and Holland jobs</description>
        <formula>AND( ISCHANGED(Status__c) , (ISPICKVAL( Status__c , &quot;Review&quot;) || ISPICKVAL( Status__c , &quot;Closed&quot;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CSS_WF_EditComplaint</fullName>
        <actions>
            <name>CSS_EditComplaintUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ComplaintUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(General_Symptoms__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Jobclosure eMail for NYCT Internal Repairs</fullName>
        <actions>
            <name>Email_Alert_to_NYCT_Internal_Repairs</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 3) AND (2 OR 4)</booleanFilter>
        <criteriaItems>
            <field>CSS_Job_Order__c.Customer_Name__c</field>
            <operation>contains</operation>
            <value>NYCT</value>
        </criteriaItems>
        <criteriaItems>
            <field>CSS_Job_Order__c.Status__c</field>
            <operation>contains</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>CSS_Job_Order__c.Customer_Name__c</field>
            <operation>contains</operation>
            <value>New York City Transit Authority</value>
        </criteriaItems>
        <criteriaItems>
            <field>CSS_Job_Order__c.Status__c</field>
            <operation>contains</operation>
            <value>Review</value>
        </criteriaItems>
        <description>Send email to NYCT Internal / Repairs</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Jobclosure eMail for NYCT NewFlyer</fullName>
        <actions>
            <name>Email_Alert_NYCT_Repairs_for_NF</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 4) AND (2 OR  5) AND 3</booleanFilter>
        <criteriaItems>
            <field>CSS_Job_Order__c.Customer_Name__c</field>
            <operation>contains</operation>
            <value>NYCT</value>
        </criteriaItems>
        <criteriaItems>
            <field>CSS_Job_Order__c.Status__c</field>
            <operation>contains</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>CSS_Job_Order__c.Make__c</field>
            <operation>equals</operation>
            <value>NEW FLYER</value>
        </criteriaItems>
        <criteriaItems>
            <field>CSS_Job_Order__c.Customer_Name__c</field>
            <operation>contains</operation>
            <value>New York City Transit Authority</value>
        </criteriaItems>
        <criteriaItems>
            <field>CSS_Job_Order__c.Status__c</field>
            <operation>contains</operation>
            <value>Review</value>
        </criteriaItems>
        <description>Send email to NYCT Internal / Repairs for New Flyer Make</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Jobclosure eMail for NYCT Nova</fullName>
        <actions>
            <name>Email_Alert_NYCT_Repairs_for_NOVA</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 4) AND (2 OR 5) AND 3</booleanFilter>
        <criteriaItems>
            <field>CSS_Job_Order__c.Customer_Name__c</field>
            <operation>contains</operation>
            <value>NYCT</value>
        </criteriaItems>
        <criteriaItems>
            <field>CSS_Job_Order__c.Status__c</field>
            <operation>contains</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>CSS_Job_Order__c.Make__c</field>
            <operation>equals</operation>
            <value>NOVA</value>
        </criteriaItems>
        <criteriaItems>
            <field>CSS_Job_Order__c.Customer_Name__c</field>
            <operation>contains</operation>
            <value>New York City Transit Authority</value>
        </criteriaItems>
        <criteriaItems>
            <field>CSS_Job_Order__c.Status__c</field>
            <operation>contains</operation>
            <value>Review</value>
        </criteriaItems>
        <description>Send email to NYCT Internal / Repairs for Nova Make</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send RPV Mail</fullName>
        <actions>
            <name>Send_Email_to_Engine_Tech_Support</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CSS_Job_Order__c.RPV_Email_Has_Sent__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>CSS_Job_Order__c.RPV_Email_Send_To__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Send email to RPV team</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
