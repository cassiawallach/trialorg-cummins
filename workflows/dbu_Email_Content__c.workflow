<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_NotifyMe_Email_when_Products_back_in_stock</fullName>
        <description>Send NotifyMe Email when Products back in stock</description>
        <protected>false</protected>
        <recipients>
            <field>dbu_Emailer_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply.identity@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>dbu_eCom_Templates/dbu_NotifyMe_Email</template>
    </alerts>
    <alerts>
        <fullName>Send_NotifyMe_Email_when_Products_back_in_stock_CA_FR</fullName>
        <description>Send NotifyMe Email when Products back in stock CA_FR</description>
        <protected>false</protected>
        <recipients>
            <field>dbu_Emailer_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply.identity@cummins.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>dbu_eCom_Templates/dbu_NotifyMe_Email_CA_FR</template>
    </alerts>
</Workflow>
