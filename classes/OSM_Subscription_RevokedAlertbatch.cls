global class OSM_Subscription_RevokedAlertbatch implements Database.Batchable<sObject>, Database.Stateful{
    
    global Database.QueryLocator start(Database.BatchableContext BC){        
        
        return Database.getQueryLocator([Select id,ccrz__CCOrder__r.ccrz__Contact__c,ccrz__CCOrder__r.OSMSecondaryEmail__c,ccrz__CCOrder__r.ccrz__Contact__r.Email,ccrz__CCOrder__r.ccrz__User__c,OSM_Display_Product__r.name,
                                         ccrz__SubscriptionProduct__r.Name,ccrz__SubscriptionStartDate__c,ccrz__SubscriptionStatus__c,OwnerId,Contact__c,
                                         OSM_Subscription_End_Date__c,ccrz__CCOrder__r.Should_Show_Price__c,ccrz__CCOrderItem__c,ccrz__CCOrder__r.ccrz__Account__r.BillingCountry,ccrz__CCOrderItem__r.id,
                                         ccrz__CCOrder__r.isOnBehalf__c,ccrz__Account__r.Name,ccrz__Account__r.IAM_Service_Provider_Code__c,ccrz__CCOrder__r.Send_SSOEM_Customer_Email__c,ccrz__CCOrder__r.Purchased_By_User_Type__c
                                         from ccrz__E_Subscription__c 
                                         where ccrz__CCOrderItem__r.Revocation_Status__c='Revoked' AND ccrz__CCOrderItem__r.OSM_Revocation_Email_Sent__c=false]); 
        // and id='a3W1F000000ikUv']);
    }
    
    global void execute(Database.BatchableContext BC, List<ccrz__E_Subscription__c> scope){
        Set<String> emailtemplateName = new Set<String>{'OSM_SW_Revoke_Temp', 'OSM_SW_Revoke_Temp_SSOEM'};  
            EmailTemplate tempRevoke;
        EmailTemplate tempRevokeSSOEM;
        for(EmailTemplate temp : [Select id, Name from EmailTemplate where name IN: emailtemplateName]){
            if(temp.Name == 'OSM_SW_Revoke_Temp'){
                tempRevoke = temp;
            }  
            if(temp.Name == 'OSM_SW_Revoke_Temp_SSOEM'){
                tempRevokeSSOEM = temp;
            }  
        }
        Messaging.Email[] messages = new List<Messaging.SingleEmailMessage>();
        
        String[] toaddress = new String[]{}; 
            
            //List<ccrz__E_Subscription__c> subList = new List<ccrz__E_Subscription__c>();
            list<ccrz__E_OrderItem__c> items = new list<ccrz__E_OrderItem__c>();
            for(ccrz__E_Subscription__c sub: scope){
                
                toaddress.add(sub.ccrz__CCOrder__r.ccrz__Contact__r.Email);
                toaddress.add(sub.ccrz__CCOrder__r.OSMSecondaryEmail__c);
                //if(intervalValues.contins(intDays)){
                
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                
                if(Label.OSM_SSOEM_Admin_UserType != sub.ccrz__CCOrder__r.Purchased_By_User_Type__c){
                    email = Messaging.renderStoredEmailTemplate(tempRevoke.id, sub.ccrz__CCOrder__r.ccrz__Contact__c, sub.id);
                    email.setTargetObjectId(sub.ccrz__CCOrder__r.ccrz__User__c);
                    if(sub.ccrz__SubscriptionProduct__r.Name.Contains('INCAL')){
                        toaddress.add(Label.INCAL_EmailAddress);
                    }
                    
                    if(sub.ccrz__CCOrder__r.ccrz__Account__r.BillingCountry == 'United States'){
                        email.setToAddresses(toaddress);
                    }
                    email.setTemplateId(tempRevoke.id);
                    email.setSaveAsActivity(false);
                    for(OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress where Address='noreply.identity@cummins.com']) 
                    {
                        email.setOrgWideEmailAddressId(owa.id); 
                    }
                    
                    email.setSubject(sub.ccrz__Account__r.Name+'('+sub.ccrz__Account__r.IAM_Service_Provider_Code__c +') '+'subscriptions have been revoked');
                    System.debug('email--if1--'+email);
                    messages.add(email);
                }
                if((Label.OSM_SSOEM_Admin_UserType == sub.ccrz__CCOrder__r.Purchased_By_User_Type__c) && ((sub.ccrz__CCOrder__r.Send_SSOEM_Customer_Email__c == True) || (sub.ccrz__CCOrder__r.Send_SSOEM_Customer_Email__c == False))){
                    email = Messaging.renderStoredEmailTemplate(tempRevoke.id, sub.ccrz__CCOrder__r.ccrz__Contact__c, sub.id);
                    email.setTargetObjectId(sub.ccrz__CCOrder__r.ccrz__User__c);
                    email.setTemplateId(tempRevoke.id);
                    if(sub.ccrz__SubscriptionProduct__r.Name.Contains('INCAL')){
                        toaddress.add(Label.INCAL_EmailAddress);
                        email.setToAddresses(toaddress);
                    }
                    email.setSaveAsActivity(false);
                    for(OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress where Address='noreply.identity@cummins.com']) 
                    {
                        email.setOrgWideEmailAddressId(owa.id); 
                    }
                    email.setSubject(sub.ccrz__Account__r.Name +'('+sub.ccrz__Account__r.IAM_Service_Provider_Code__c +') '+'subscriptions have been revoked');
                    System.debug('email--if2--'+email);
                    messages.add(email);
                }
                if((Label.OSM_SSOEM_Admin_UserType == sub.ccrz__CCOrder__r.Purchased_By_User_Type__c) && (sub.ccrz__CCOrder__r.isOnBehalf__c== True) && (sub.ccrz__CCOrder__r.Send_SSOEM_Customer_Email__c == True)){
                    email = Messaging.renderStoredEmailTemplate(tempRevokeSSOEM.id, sub.ccrz__CCOrder__r.ccrz__Contact__c, sub.id);
                    email.setTargetObjectId(sub.ccrz__CCOrder__r.ccrz__Contact__c);
                    email.setTemplateId(tempRevokeSSOEM.id);
                    if(sub.ccrz__SubscriptionProduct__r.Name.Contains('INCAL')){
                        toaddress.add(Label.INCAL_EmailAddress);
                        email.setToAddresses(toaddress);
                    }
                    email.setSaveAsActivity(false);
                    for(OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress where DisplayName='noreply.identity@cummins.com']) 
                    {
                        email.setOrgWideEmailAddressId(owa.id); 
                    }
                    email.setSubject(sub.ccrz__Account__r.Name +'('+sub.ccrz__Account__r.IAM_Service_Provider_Code__c +') '+'subscriptions have been revoked');
                    System.debug('email-if3---'+email);
                    messages.add(email);
                } 
                
                items.add(new ccrz__E_OrderItem__c(id=sub.ccrz__CCOrderItem__r.id,OSM_Revocation_Email_Sent__c=true));
            }
        
        
        If(messages.size()>0){
            if(!test.isRunningTest()){
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages); 
                system.debug('Send Eamil to user'+messages);
                Database.upsert(items);
            }
        }
        
        
    }    
    global void finish(Database.BatchableContext BC){
        OSM_Integration_Log__c log = new OSM_Integration_Log__c();
        log.Service_Name__c='OSM_Subscription_RevokedAlertbatch' ;
        log.Internal_Batch_Log__c=true;
        AsyncApexJob jobstatus = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =:BC.getJobId()];
        log.Status__c = jobstatus.Status;
        if(jobstatus.Status=='Completed'){
            log.Status__c = 'Processed'; 
        }else if(jobstatus.Status=='Failed'){
            log.Internal_Batch_Failure__c=true;
            log.No_of_Jobs_Failed__c=jobstatus.NumberOfErrors;
        }
        insert log;
        
    }
}