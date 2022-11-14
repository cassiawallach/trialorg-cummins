<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>FSL_InShop_SA_Notification</fullName>
        <description>FSL InShop SA Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>vamsi.jandhyala@cummins.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>noreply.identity@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Guidanz_FSL/FSL_Appointment_24HR_Notification_Inshop</template>
    </alerts>
    <alerts>
        <fullName>FSL_Mobile_SA_Notification</fullName>
        <description>FSL Mobile SA Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>vamsi.jandhyala@cummins.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>noreply.identity@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Guidanz_FSL/FSL_Appointment_24HR_Notification_Mobile</template>
    </alerts>
</Workflow>
