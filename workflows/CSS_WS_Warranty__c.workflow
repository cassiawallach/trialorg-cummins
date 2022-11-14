<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CSS_WS_CSM_Denial_Notification</fullName>
        <description>CSM Denial Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CSS_Templates/CSS_WS_Claim_Denied_CSM</template>
    </alerts>
    <alerts>
        <fullName>CSS_WS_DR_Denial_Notification</fullName>
        <description>DR Denial Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CSS_Templates/CSS_WS_Claim_Denied_DR</template>
    </alerts>
    <alerts>
        <fullName>CSS_WS_Paccar_Denied_Notification</fullName>
        <description>Paccar Denied Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CSS_Templates/CSS_WS_Claim_Denied_Paccar</template>
    </alerts>
    <alerts>
        <fullName>CSS_WS_TSM_Denial_Notification_TSM</fullName>
        <description>TSM Denial Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CSS_Templates/CSS_WS_Claim_Denied_TSM</template>
    </alerts>
    <fieldUpdates>
        <fullName>CSS_WS_Change_Approved_CSM</fullName>
        <field>CSS_WS_Claim_Status__c</field>
        <formula>&quot;Approved for Payment&quot;</formula>
        <name>Status Approved CSM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSS_WS_DR_Date</fullName>
        <field>CSS_WS_DR_Date__c</field>
        <formula>Today()</formula>
        <name>DR Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSS_WS_Dealer_Date</fullName>
        <field>CSS_WS_Dealer_Date__c</field>
        <formula>Today()</formula>
        <name>Dealer Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSS_WS_Name_Approved_TSM</fullName>
        <field>CSS_WS_TSM_Approver_Name__c</field>
        <formula>$User.FirstName &amp; &quot; &quot; &amp; $User.LastName</formula>
        <name>Name Approved/Rejected TSM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSS_WS_Status_Approved_DR</fullName>
        <field>CSS_WS_Claim_Status__c</field>
        <formula>&quot;Pending Review Planta&quot;</formula>
        <name>Status Approved DR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSS_WS_Status_Approved_Factory</fullName>
        <field>CSS_WS_Claim_Status__c</field>
        <formula>IF( OR(CSS_WS_Account_Code__c  = &quot;P101&quot;, CSS_WS_Account_Code__c  = &quot;P99&quot;), &quot;Approved for Payment&quot;, &quot;Pending Planta Payment Policy&quot;)</formula>
        <name>Status Approved Factory</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSS_WS_Status_Approved_Paccar</fullName>
        <field>CSS_WS_Claim_Status__c</field>
        <formula>&quot;Approved for US&quot;</formula>
        <name>Status Approved Paccar</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSS_WS_Status_Approved_TSM</fullName>
        <field>CSS_WS_Claim_Status__c</field>
        <formula>&quot;Pending Planta Payment Policy&quot;</formula>
        <name>Status Approved TSM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSS_WS_Status_Approved_US</fullName>
        <description>If US approved,</description>
        <field>CSS_WS_Claim_Status__c</field>
        <formula>IF(
   (CSS_WS_Claim_Status__c ==&quot;Approved US&quot; &amp;&amp;   
    CSS_WS_Flow__c ==&quot;MX&quot; )
   , &quot;Pending Factory Payment&quot;
   , (IF(
         (CSS_WS_Claim_Status__c ==&quot;Approved US&quot; &amp;&amp;
          CSS_WS_Flow__c ==&quot;CA&quot; )
        ,&quot;Paid&quot;
        ,&quot;Rejected US&quot;
        )
      )
)</formula>
        <name>Status Approved US</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSS_WS_Status_Denied_CSM</fullName>
        <field>CSS_WS_Claim_Status__c</field>
        <formula>&quot;Declined by CSM&quot;</formula>
        <name>Status Denied CSM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSS_WS_Status_Denied_DR</fullName>
        <field>CSS_WS_Claim_Status__c</field>
        <formula>&quot;Getting DR Rejection Reason&quot;</formula>
        <name>Status Denied DR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSS_WS_Status_Denied_Factory</fullName>
        <field>CSS_WS_Claim_Status__c</field>
        <formula>&quot;Denied by Planta&quot;</formula>
        <name>Status DeniedFactory</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSS_WS_Status_Denied_Paccar</fullName>
        <field>CSS_WS_Claim_Status__c</field>
        <formula>&quot;Getting Paccar Rejection Reason&quot;</formula>
        <name>Status Denied Paccar</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSS_WS_Status_Denied_TSM</fullName>
        <field>CSS_WS_Claim_Status__c</field>
        <formula>&quot;Declined by TSM&quot;</formula>
        <name>Status Denied TSM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSS_WS_Status_Denied_US</fullName>
        <field>CSS_WS_Claim_Status__c</field>
        <formula>&quot;Denied US&quot;</formula>
        <name>Status Denied US</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSS_WS_Status_Pending_DR</fullName>
        <field>CSS_WS_Claim_Status__c</field>
        <formula>&quot;Pending DR&quot;</formula>
        <name>Status Pending DR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSS_WS_Status_Pending_DR_P88</fullName>
        <field>CSS_WS_Claim_Status__c</field>
        <formula>&quot;Pending DR&quot;</formula>
        <name>Status Pending DR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSS_WS_Status_Pending_Paccar</fullName>
        <field>CSS_WS_Claim_Status__c</field>
        <formula>&quot;Pending Paccar&quot;</formula>
        <name>Status Pending Paccar</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSS_WS_Status_Pending_Payment</fullName>
        <field>CSS_WS_Claim_Status__c</field>
        <formula>&quot;Pending Payment&quot;</formula>
        <name>Status Pending Payment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_to_CSM_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>CSS_WS_Queue_CSM</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner to CSM Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_to_TSM_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>CSS_WS_Queue_TSM</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner to TSM Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Approved_DR_Policy_88</fullName>
        <field>CSS_WS_Claim_Status__c</field>
        <formula>&quot;Pending TSM&quot;</formula>
        <name>Status Approved DR Policy 88</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Approved_DR_Policy_88_Dealer</fullName>
        <description>Use this status to link Approval Procces from Part1 to Part2</description>
        <field>CSS_WS_Claim_Status__c</field>
        <formula>&quot;Pending TSM by Dealer&quot;</formula>
        <name>Status Approved DR Policy 88 Dealer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Approved_DR_Warranty</fullName>
        <field>CSS_WS_Claim_Status__c</field>
        <formula>&quot;Approved for US&quot;</formula>
        <name>Status Approved DR Warranty</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
</Workflow>
