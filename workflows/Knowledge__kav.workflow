<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Knowledge_Article_Rejection_Email</fullName>
        <description>Knowledge Article Rejection Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CCM_Email_Templates/CCM_Knowledge_Rejection_Email</template>
    </alerts>
    <knowledgePublishes>
        <fullName>Publish_Article</fullName>
        <action>PublishAsNew</action>
        <label>Publish_Article</label>
        <language>en_US</language>
        <protected>false</protected>
    </knowledgePublishes>
</Workflow>
