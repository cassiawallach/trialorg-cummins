public with sharing class dbu_Integration_Error_Log 
{
    public static void createErrorLog(Integer ErrorCode,String ErrorDescription,String Request,
                                      String Response,String ServiceName,String Status)
    {
        dbu_Integration_Error_Log__c objdbuIntegrationErrorLog = new dbu_Integration_Error_Log__c();  
        List<dbu_Integration_Error_Log__c> lstdbuntegrationErrorLog = new List<dbu_Integration_Error_Log__c>();
        System.debug('Inside Try Block');
        objdbuIntegrationErrorLog.dbu_Error_Code__c             =   ErrorCode;
        objdbuIntegrationErrorLog.dbu_Error_Description__c      =   ErrorDescription;
        objdbuIntegrationErrorLog.dbu_Request__c                =   Request;
        objdbuIntegrationErrorLog.dbu_Response__c               =   Response;
        objdbuIntegrationErrorLog.dbu_Service_Name__c           =   ServiceName;
        objdbuIntegrationErrorLog.dbu_Status__c                 =   Status; 
        
        lstdbuntegrationErrorLog.add(objdbuIntegrationErrorLog);
        Insert lstdbuntegrationErrorLog;
       /* if(Status != 'Success'){
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'dbu_IntegrationLog_Notification'];
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            dbu_IntegrationErrorLog__c errorLogDetails = dbu_IntegrationErrorLog__c.getValues('ErrorLogEmail');
            User cnt = [select id, Email from User where email != null limit 1];
            String htmlBody = emailTemplate.HtmlValue;
            if(ErrorDescription != Null){
                htmlBody = htmlBody.replace('{!Description}', ErrorDescription);
            }
            if(Request != null){
                htmlBody = htmlBody.replace('{!Request}', Request);
            }
            if(Response != null){
                htmlBody = htmlBody.replace('{!Response}', Response);
            }
            if(ServiceName != null){
                htmlBody = htmlBody.replace('{!Service_Name}', ServiceName);
            }
            if(Status != null){
                htmlBody = htmlBody.replace('{!Status}', Status);
            }
            if(ErrorCode != null){
                htmlBody = htmlBody.replace('{!Code}', string.Valueof(ErrorCode));
            }
            system.debug('errorLogDetails.SetToAddress__c--->>'+errorLogDetails.SetToAddress__c);
            List <String> toaddress = errorLogDetails.SetToAddress__c.split(','); 
            mail.setHtmlBody(htmlBody);
            mail.setSubject('Dbu integration failed/exception error log email');
            mail.setToAddresses(toaddress);
            mail.setTargetObjectId(cnt.id); 
            mail.setSenderDisplayName('Ecomm Support'); 
            mail.setReplyTo('no-reply@cummins.com');
            mail.setUseSignature(false);
            mail.setBccSender(false);
            mail.setSaveAsActivity(false);
           // mail.setTemplateID(emailTemplate.Id);
            emails.add(mail);
            // Send the emails in a transaction, then roll it back
            Savepoint sp = Database.setSavepoint();
            Messaging.sendEmail(emails); // Dummy email send
            Database.rollback(sp); // Email will not send as it is rolled Back
            // Send Actual email
            List<Messaging.SingleEmailMessage> msgListToBeSend = new List<Messaging.SingleEmailMessage>();
            for (Messaging.SingleEmailMessage email : emails) {
                Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                emailToSend.setToAddresses(email.getToAddresses());
                //emailToSend.setPlainTextBody(email.getPlainTextBody());
                emailToSend.setHTMLBody(email.getHTMLBody());
                emailToSend.setSubject(email.getSubject());
                emailToSend.setSenderDisplayName(email.getSenderDisplayName());
                emailToSend.setReplyTo(email.getReplyTo());
                msgListToBeSend.add(emailToSend);
            }
            //Messaging.sendEmail(msgListToBeSend);
            Messaging.SendEmailResult[] results = Messaging.sendEmail(msgListToBeSend);     
    
        }
        
        try{
            dbu_Integration_Error_Log__c objdbuIntegrationErrorLog = new dbu_Integration_Error_Log__c();  
            List<dbu_Integration_Error_Log__c> lstdbuntegrationErrorLog = new List<dbu_Integration_Error_Log__c>();
            System.debug('Inside Try Block');
            objdbuIntegrationErrorLog.dbu_Error_Code__c             =   ErrorCode;
            objdbuIntegrationErrorLog.dbu_Error_Description__c      =   ErrorDescription;
            objdbuIntegrationErrorLog.dbu_Request__c                =   Request;
            objdbuIntegrationErrorLog.dbu_Response__c               =   Response;
            objdbuIntegrationErrorLog.dbu_Service_Name__c           =   ServiceName;
            objdbuIntegrationErrorLog.dbu_Status__c                 =   Status; 
            
            lstdbuntegrationErrorLog.add(objdbuIntegrationErrorLog);
            System.debug('lstdbuntegrationErrorLog.size()+++ ' + lstdbuntegrationErrorLog.size());
            System.debug('lstdbuntegrationErrorLog+++ ' + lstdbuntegrationErrorLog);
            //Insert lstdbuntegrationErrorLog;
            
        }catch(CallOutException ce){
            //throw ce;
            throw new AuraHandledException('Something went wrong:::: '+ ce.getMessage());    
        }  
        */
    }  
    
    
        // Overloaded function
        public static void createErrorLog(List<dbu_Integration_Error_Log__c> lstDbuErrorLog)
        { 
            if(lstDbuErrorLog != null && lstDbuErrorLog.size() > 0){
                Database.Insert(lstDbuErrorLog);
            }

        }  
}