<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_wishlist_Notification_email_for_Canada_French</fullName>
        <description>Send wishlist Notification email for Canada French</description>
        <protected>false</protected>
        <recipients>
            <field>dbu_Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>dbu_eCom_Templates/dbu_Wishlist_Email_Notification_FR</template>
    </alerts>
    <alerts>
        <fullName>Send_wishlist_Notification_email_to_customer_when_Products_become_instock_in_his</fullName>
        <description>Send wishlist Notification email to customer when Products become instock in his wishlist</description>
        <protected>false</protected>
        <recipients>
            <field>dbu_Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>dbu_eCom_Templates/dbu_Wishlist_Email_Notification</template>
    </alerts>
</Workflow>
