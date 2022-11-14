<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CCM_More_Info_Needed</fullName>
        <description>CCM - More Info Needed</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>guidanz@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CCM_Email_Templates/CCM_More_Info_Needed_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>CSCA_Case_Closure</fullName>
        <description>CSCA - Case Closure</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>cssna.channelsupport.canada@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CCM_Email_Templates/CS_Case_Closure_Email</template>
    </alerts>
    <alerts>
        <fullName>CSCA_More_Info_Needed</fullName>
        <description>CSCA - More Info Needed</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>cssna.channelsupport.canada@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CCM_Email_Templates/CCM_More_Info_Needed_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>CSEMail_More_Info_Needed</fullName>
        <description>CSEMail_More_Info_Needed</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>cssna.channelsupport.north@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CCM_Email_Templates/CCM_More_Info_Needed_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>CSEmail_CaseClosure</fullName>
        <description>CSEmail_CaseClosure</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>cssna.channelsupport.north@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CCM_Email_Templates/CS_Case_Closure_Email</template>
    </alerts>
    <alerts>
        <fullName>CSM_Customer_Support_Management_Case_Creation_Auto_Response</fullName>
        <description>CSM Customer Support Management Case Creation Auto Response</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply.identity@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CCM_Email_Templates/CSM_Customer_Support_Management_Case_Creation_Auto_Response</template>
    </alerts>
    <alerts>
        <fullName>CSNorth_Case_Closure</fullName>
        <description>CSNorth - Case Closure</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>cssna.channelsupport.north@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CCM_Email_Templates/CS_Case_Closure_Email</template>
    </alerts>
    <alerts>
        <fullName>CSNorth_More_Info_Needed</fullName>
        <description>CSNorth - More Info Needed</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>cssna.channelsupport.north@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CCM_Email_Templates/CCM_More_Info_Needed_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>CSS_Case_Comment_Owner_Notification</fullName>
        <description>CSS Case Comment Owner Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Management/Update_Feedback_Form</template>
    </alerts>
    <alerts>
        <fullName>CSS_FeedBack_Case_Create</fullName>
        <description>CSS_FeedBack_Case_Create</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Management/CSS_FeedBack_Case_Create_Template</template>
    </alerts>
    <alerts>
        <fullName>CSSouth_Case_Closure</fullName>
        <description>CSSouth - Case Closure</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>cssna.channelsupport.south@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CCM_Email_Templates/CS_Case_Closure_Email</template>
    </alerts>
    <alerts>
        <fullName>CSSouth_More_Info_Needed</fullName>
        <description>CSSouth - More Info Needed</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>cssna.channelsupport.south@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CCM_Email_Templates/CCM_More_Info_Needed_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>CSTS_SR_Closed_Email</fullName>
        <description>CSTS SR Closed Email</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply.identity@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CSTS_SouthPac_Australia_Team/CSTS_Survey</template>
    </alerts>
    <alerts>
        <fullName>CSWest_Case_Closure</fullName>
        <description>CSWest - Case Closure</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>cssna.channelsupport.west@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CCM_Email_Templates/CS_Case_Closure_Email</template>
    </alerts>
    <alerts>
        <fullName>CSWest_More_Info_Needed</fullName>
        <description>CSWest - More Info Needed</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>cssna.channelsupport.west@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CCM_Email_Templates/CCM_More_Info_Needed_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>CS_Dlr_Case_Closure</fullName>
        <description>CS Dlr- Case Closure</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>dealersystemssetup@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CCM_Email_Templates/CS_Case_Closure_Email</template>
    </alerts>
    <alerts>
        <fullName>CS_Dlr_More_Info_Needed</fullName>
        <description>CS Dlr - More Info Needed</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>dealersystemssetup@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CCM_Email_Templates/CCM_More_Info_Needed_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Case_Email_Communication_Alert</fullName>
        <description>Case Email Communication Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Target_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>service.notifications@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Guidanz_FSL/Comunication_ERPs_Template</template>
    </alerts>
    <alerts>
        <fullName>Customer_Support_Management_Case_Creation_Auto_Response</fullName>
        <description>Customer Support Management Case Creation Auto Response</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply.identity@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CCM_Email_Templates/Customer_Support_Management_Case_Creation_Auto_Response</template>
    </alerts>
    <alerts>
        <fullName>Email_Notification_for_Guest_User</fullName>
        <description>CCM Email Notification for Guest User</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply.identity@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CCM_Email_Templates/CSM_Customer_Support_Management_Case_Creation_Auto_Response</template>
    </alerts>
    <alerts>
        <fullName>FSL_CSSP_Service_Request_Email</fullName>
        <description>FSL CSSP Service Request Email</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>service.notifications@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Guidanz_FSL/FSL_CSSP_ServiceRequestEmail</template>
    </alerts>
    <alerts>
        <fullName>FSL_STC_Email_Forward_from_Case</fullName>
        <description>FSL STC Email Forward from Case</description>
        <protected>false</protected>
        <recipients>
            <field>Forward_An_Email_To_STC__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>service.notifications@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Guidanz_FSL/STC_Email_Forward</template>
    </alerts>
    <alerts>
        <fullName>MP_Case_Closure</fullName>
        <description>MP - Case Closure</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>marketplace@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CCM_Email_Templates/Case_Closure_Email</template>
    </alerts>
    <alerts>
        <fullName>MP_More_Info_Needed</fullName>
        <description>MP - More Info Needed</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>marketplace@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CCM_Email_Templates/CCM_More_Info_Needed_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>New_FeedBack_Form</fullName>
        <description>New FeedBack Form</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Management/New_Feedback_Form</template>
    </alerts>
    <alerts>
        <fullName>QuickServe_Case_Closure</fullName>
        <description>QuickServe- Case Closure</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply.identity@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CCM_Email_Templates/Case_Closure_Email</template>
    </alerts>
    <alerts>
        <fullName>QuickServe_More_Info_Needed</fullName>
        <description>QuickServe- More Info Needed</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply.identity@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CCM_Email_Templates/CCM_More_Info_Needed_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_email_to_contact</fullName>
        <description>Send email to contact</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>guidanz@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CCM_Email_Templates/Case_Closure_Email</template>
    </alerts>
    <alerts>
        <fullName>Subscriptions_Case_Closure</fullName>
        <description>Subscriptions- Case Closure</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>cssna.etools@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CCM_Email_Templates/Case_Closure_Email</template>
    </alerts>
    <alerts>
        <fullName>Subscriptions_More_Info_Needed</fullName>
        <description>Subscriptions - More Info Needed</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>cssna.etools@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CCM_Email_Templates/CCM_More_Info_Needed_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Telematics_Case_Closure</fullName>
        <description>Telematics - Case Closure</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply.identity@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CCM_Email_Templates/Case_Closure_Email</template>
    </alerts>
    <alerts>
        <fullName>Telematics_More_Info_Needed</fullName>
        <description>Telematics- More Info Needed</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply.identity@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CCM_Email_Templates/CCM_More_Info_Needed_Email_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>Accept_button_status_update</fullName>
        <field>Status</field>
        <literalValue>Work in Progress</literalValue>
        <name>Accept button status update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CCM_Update_Case_Owner_as_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Customer_Support_Management</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>CCM Update Case Owner as Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSCA_Reassign_to_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Channel_Support_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>CSCA Reassign to Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSTS_Escalated_Status_Change</fullName>
        <field>Status</field>
        <literalValue>Escalated</literalValue>
        <name>CSTS Escalated Status Change</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSTS_SR_Escalated</fullName>
        <field>IsEscalated</field>
        <literalValue>1</literalValue>
        <name>CSTS SR Escalated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSTS_Set_Status_to_Closed</fullName>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>CSTS Set Status to Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSTS_Status_Update</fullName>
        <field>Status</field>
        <literalValue>Opened</literalValue>
        <name>CSTS Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FSL_RecordType_field_Update</fullName>
        <field>RecordTypeId</field>
        <lookupValue>FSL_IA_Rejected</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>FSL RecordType field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FSL_Reject_StatusValidation</fullName>
        <field>Bypass_Validation_Rule__c</field>
        <literalValue>0</literalValue>
        <name>FSL_RejectStatusValidation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MP_Reassign_to_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Marketplace_Support</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>MP Reassign to Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Bold_Un_Bold_Flag</fullName>
        <field>Case_Viewed_User_Ids__c</field>
        <name>Update Bold Un Bold Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Counter_Flag</fullName>
        <field>Case_Update_Flag__c</field>
        <literalValue>1</literalValue>
        <name>Update Case Counter Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>to_update_SR_asset_no_with_asset</fullName>
        <field>FSL_CSSP_AssetNumber__c</field>
        <formula>Asset.Name</formula>
        <name>to update SR asset no with asset</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_SR_Registration_field_with_asset</fullName>
        <field>Registration__c</field>
        <formula>Asset.Registration__c</formula>
        <name>update SR Registration field with asset</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_unit_no_with_asset_unitno</fullName>
        <field>Unit_Number__c</field>
        <formula>Asset.Unit_Number__c</formula>
        <name>update unit no with asset unitno</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>CSS Case Comment Owner Notification</fullName>
        <actions>
            <name>CSS_Case_Comment_Owner_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>To send notification to case owner when new case comment is added</description>
        <formula>AND(IF(RecordType.Name == &apos;Feedback&apos;, TRUE, FALSE),IF(CONTAINS($Profile.Name, &quot;Dealer&quot;), TRUE, FALSE), ISCHANGED(Recent_Case_Comment__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CSS_Feedback_Notification</fullName>
        <actions>
            <name>CSS_FeedBack_Case_Create</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Feedback</value>
        </criteriaItems>
        <description>Notification for CSS Feedback Case</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CSTS L2 Owner Change</fullName>
        <actions>
            <name>CSTS_Escalated_Status_Change</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CSTS_SR_Escalated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Cummins Care Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>contains</operation>
            <value>L2</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CSTS Status change with new owner</fullName>
        <actions>
            <name>CSTS_Status_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 5 AND (3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>notContain</operation>
            <value>L1,L2</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Cummins Care Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>notContain</operation>
            <value>ARIBA,RTTMS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>ARIBA,RTTMS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Email Communication</fullName>
        <actions>
            <name>Case_Email_Communication_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>(
(ISPICKVAL(Email_Communication_Trigger_Name__c,&apos;Troubleshooting Started&apos;) &amp;&amp; ServiceJob__r.Fault_Code_Communication_Trigger__c ==false)
|| (ISPICKVAL(Email_Communication_Trigger_Name__c,&apos;Service Work Completed&apos;) &amp;&amp; ServiceJob__r.Service_Work_Completed__c == false)
|| (ISPICKVAL(Email_Communication_Trigger_Name__c,&apos;Authorized Work Started&apos;) &amp;&amp; ServiceJob__r.Authorized_Work_Started__c== false)
|| (ISPICKVAL(Email_Communication_Trigger_Name__c,&apos;Equipment available&apos;) &amp;&amp; (ServiceJob__r.Equipment_available__c== false || ISCHANGED(ServiceJob__c))) || (((ISCHANGED( IAS_Number__c ) &amp;&amp; NOT(ISNEW()))) || ((NOT(ISBLANK(IAS_Number__c)) &amp;&amp; ISNEW()))) &amp;&amp; (ServiceJob__r.IAS_Number_Populated__c == True)

|| ((ISPICKVAL(Email_Communication_Trigger_Name__c, &apos;Equipment ready for pick up&apos;)|| ISPICKVAL(Email_Communication_Trigger_Name__c, &apos;Service Work Proceeding&apos;)) &amp;&amp; (ISPICKVAL(Communication_Type__c, &apos;Manual Communication&apos;))) || (ISPICKVAL(Email_Communication_Trigger_Name__c,&apos;Invoice Ready&apos;)&amp;&amp; ServiceJob__r.Invoice_Generated__c== false)

)
&amp;&amp; NOT(ISBLANK(Target_Email__c)) &amp;&amp; NOT(ISNULL(Target_Email__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>FSL STC Email Forward from case</fullName>
        <actions>
            <name>FSL_STC_Email_Forward_from_Case</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>FSL_STC_Email_Body_Id__c  &lt;&gt; null &amp;&amp;  ISCHANGED(FSL_STC_Email_Body_Id__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>FSL Service Request record type update</fullName>
        <actions>
            <name>FSL_RecordType_field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>FSL_Reject_StatusValidation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New_Feedback_Form</fullName>
        <actions>
            <name>New_FeedBack_Form</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>IF( RecordType.Name  == &apos;Feedback&apos;, IF( CONTAINS($Profile.Name, &quot;dealer&quot;), true, false), false)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>OneC CBS Status change with new owner</fullName>
        <actions>
            <name>CSTS_Status_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>notContain</operation>
            <value>Ops,CSSNA,Preventech,OneC</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>OneC CBS,OneC Care,OneC UK Insider Sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Workflow_rule_to_update_case_Counter_flag_and _Bold_unbold_stamping</fullName>
        <actions>
            <name>Update_Bold_Un_Bold_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Case_Counter_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  NOT(ISNEW()),ISCHANGED(Status), CreatedById !=  $User.Id )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
