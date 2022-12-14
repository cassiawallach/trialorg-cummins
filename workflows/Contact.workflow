<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ABO_submit</fullName>
        <description>ABO_submit</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IAM_Templates/ABO_Setpassword</template>
    </alerts>
    <alerts>
        <fullName>AlertPCAdmin</fullName>
        <description>AlertPCAdmin</description>
        <protected>false</protected>
        <recipients>
            <recipient>Customer_Approver</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>PC_Admin</recipient>
            <type>role</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Product_Connectivity/CMI_Customer_Approval</template>
    </alerts>
    <alerts>
        <fullName>FSL_Nightly_Comm</fullName>
        <description>FSL Nightly Comm</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>service.notifications@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Guidanz_FSL/FSL_Nightly_Communication</template>
    </alerts>
    <alerts>
        <fullName>IAM_Contact_deactivate</fullName>
        <description>IAM Contact deactivate</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply.identity@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>IAM_Templates/IAM_User_Deactivate</template>
    </alerts>
    <alerts>
        <fullName>IAM_LocationChange_App_Deactivate</fullName>
        <description>IAM_LocationChange_App_Deactivate</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply.identity@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>IAM_Templates/IAM_LocationChange_App_Deactivate</template>
    </alerts>
    <alerts>
        <fullName>IAM_RSW_Uer_Location_Change</fullName>
        <ccEmails>warranty@cummins.com</ccEmails>
        <description>IAM Contact/User Location change alert for RSW</description>
        <protected>false</protected>
        <senderAddress>noreply.identity@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>IAM_Templates/IAM_RSW_Uer_Location_Change</template>
    </alerts>
    <alerts>
        <fullName>IAM_RSW_Uer_Status_Change</fullName>
        <ccEmails>warranty@cummins.com</ccEmails>
        <description>IAM Contact/User status update alert for RSW</description>
        <protected>false</protected>
        <senderAddress>noreply.identity@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>IAM_Templates/IAM_RSW_Uer_Status_Change</template>
    </alerts>
    <alerts>
        <fullName>IAM_Reclaim_Notification</fullName>
        <description>IAM_Reclaim_Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply.identity@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>IAM_Templates/IAM_Reclaim_Setpassword</template>
    </alerts>
    <alerts>
        <fullName>IAM_Rejection_Email</fullName>
        <description>IAM_Rejection_Email</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply.identity@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>IAM_Templates/IAM_Rejection_email_template</template>
    </alerts>
    <alerts>
        <fullName>IAM_Successfull_Registration</fullName>
        <description>IAM_Successfull_Registration</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply.identity@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>IAM_Templates/IAM_Successfull_Registration</template>
    </alerts>
    <alerts>
        <fullName>IAM_Successfull_Registration_SPcode</fullName>
        <description>IAM_Successfull_Registration_SPcode</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply.identity@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>IAM_Templates/IAM_Successfull_Registration_SPCode</template>
    </alerts>
    <alerts>
        <fullName>IAM_User_Email_Change</fullName>
        <description>User Email Chnage</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>IAM_Previous_User_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>noreply.identity@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>IAM_Templates/IAM_User_Email_Change</template>
    </alerts>
    <alerts>
        <fullName>Other_TSP</fullName>
        <description>Other TSP</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Product_Connectivity/CMI_Other_TSP_Email</template>
    </alerts>
    <alerts>
        <fullName>Submit</fullName>
        <description>Submit</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply.identity@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Product_Connectivity/CMI_Welcome_Customer</template>
    </alerts>
    <fieldUpdates>
        <fullName>Active_status</fullName>
        <field>IAM_Contact_Status__c</field>
        <literalValue>Active</literalValue>
        <name>Active status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approve_flag</fullName>
        <field>IAM_Approved__c</field>
        <literalValue>Y</literalValue>
        <name>Approve flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IAM_BOX_Approval_Status</fullName>
        <field>IAM_Contact_Status__c</field>
        <literalValue>Active</literalValue>
        <name>s</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IAM_Contact_Status_Update</fullName>
        <field>IAM_Contact_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Contact Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IAM_SetApprovedFlag</fullName>
        <field>IAM_Approved__c</field>
        <literalValue>Y</literalValue>
        <name>SetApprovedFlag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IAM_SetApprovedFlag2</fullName>
        <description>To set approved flag to true</description>
        <field>IAM_Approved__c</field>
        <literalValue>Y</literalValue>
        <name>SetApprovedFlag2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IAM_SetApprovedFlag3</fullName>
        <field>IAM_Approved__c</field>
        <literalValue>Y</literalValue>
        <name>SetApprovedFlag3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IAM_SetApprovedFlag4</fullName>
        <field>IAM_Approved__c</field>
        <literalValue>Y</literalValue>
        <name>SetApprovedFlag4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IAM_SetApprovedFlag5</fullName>
        <field>IAM_Approved__c</field>
        <literalValue>Y</literalValue>
        <name>SetApprovedFlag5</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IAM_Update_JIT_Provisioning_Flag</fullName>
        <field>IAM_From_JIT_Execution__c</field>
        <literalValue>0</literalValue>
        <name>IAM_Update_JIT_Provisioning_Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Location_Change_Flag</fullName>
        <field>Location_Change__c</field>
        <literalValue>0</literalValue>
        <name>Location Change Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Registration_Flag</fullName>
        <field>IAM_from_Registration__c</field>
        <literalValue>0</literalValue>
        <name>Registration Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SetApprovedFlag3</fullName>
        <field>IAM_Approved__c</field>
        <literalValue>Y</literalValue>
        <name>SetApprovedFlag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Field_IAM_Reject_Reason</fullName>
        <field>IAM_Reject_Reason__c</field>
        <literalValue>Requested Removal</literalValue>
        <name>Update Field IAM Reject Reason</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Username</fullName>
        <field>IAM_Cummins_login_ID__c</field>
        <formula>Email</formula>
        <name>Username</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>CMI_Customersubmit</fullName>
        <actions>
            <name>AlertPCAdmin</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Submit</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.CMI_Account_Status__c</field>
            <operation>equals</operation>
            <value>Pending</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.CMI_Contact_Type__c</field>
            <operation>equals</operation>
            <value>Primary</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.CMI_Telematics_Service_Provider__c</field>
            <operation>notEqual</operation>
            <value>Other TSP</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Product_Connectivity</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CMI_Customersubmit_otherTSP</fullName>
        <actions>
            <name>Other_TSP</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.CMI_Account_Status__c</field>
            <operation>equals</operation>
            <value>Pending</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.CMI_Contact_Type__c</field>
            <operation>equals</operation>
            <value>Primary</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.CMI_Telematics_Service_Provider__c</field>
            <operation>equals</operation>
            <value>Other TSP</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Product_Connectivity</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>FSL Nightly Comm</fullName>
        <actions>
            <name>FSL_Nightly_Comm</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Send_Nightly_Communication__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>IAM_Successfull_Registration</fullName>
        <actions>
            <name>IAM_Successfull_Registration</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>IAM</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>notEqual</operation>
            <value>Dealer Account,Distributor Account</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.IAM_Contact_Status__c</field>
            <operation>notEqual</operation>
            <value>Reclaim,Inactive</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.IAM_from_Registration__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Work flow to trigger email alert on successful contact creation through registration.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>IAM_Successfull_Registration_SPCode</fullName>
        <actions>
            <name>IAM_Successfull_Registration_SPcode</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>IAM</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>equals</operation>
            <value>Dealer Account,Distributor Account</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.IAM_from_Registration__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Work flow to trigger email alert on successful contact creation through registration to a service provider</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>IAM_Update_JIT_Provisioning_Flag</fullName>
        <actions>
            <name>IAM_Update_JIT_Provisioning_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.IAM_From_JIT_Execution__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Rule to execute when a JIT flag needs to be updated back to false</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
