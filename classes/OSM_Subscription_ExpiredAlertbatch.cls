global class OSM_Subscription_ExpiredAlertbatch implements Database.Batchable<sObject>, Database.Stateful{
    
    global Database.QueryLocator start(Database.BatchableContext BC){        
        
        return Database.getQueryLocator([Select id,ccrz__CCOrder__r.ccrz__Contact__c,ccrz__CCOrder__r.OSMSecondaryEmail__c,ccrz__CCOrder__r.ccrz__Contact__r.Email,ccrz__CCOrder__r.ccrz__User__c,OSM_Display_Product__r.name,
                                         ccrz__SubscriptionProduct__r.Name,ccrz__SubscriptionStartDate__c,ccrz__SubscriptionStatus__c,OwnerId,Contact__c,ccrz__Account__c,ccrz__SPT__c,ccrz__SubscriptionProduct__c,   
                                         OSM_Subscription_End_Date__c,ccrz__CCOrder__r.Should_Show_Price__c,ccrz__CCOrder__r.ccrz__Account__r.BillingCountry,
                                         ccrz__CCOrder__r.ccrz__Account__r.Name,ccrz__CCOrder__r.OSM_Headquarter_Email__c,ccrz__CCOrder__r.ccrz__Account__r.IAM_Service_Provider_Code__c,
                                         ccrz__CCOrder__r.isOnBehalf__c,ccrz__CCOrder__r.Send_SSOEM_Customer_Email__c,ccrz__CCOrder__r.Purchased_By_User_Type__c,
                                         ccrz__CCOrder__r.createdById
                                         from ccrz__E_Subscription__c 
                                         where OSM_Subscription_End_Date__c!=null and ccrz__SubscriptionStatus__c='Expired' 
                                         and OSM_Subscription_End_Date__c <=: system.now()  and ccrz__CCOrder__c != null]);//id='a3W1F000000ijjZ'
    }
    
    global void execute(Database.BatchableContext BC, List<ccrz__E_Subscription__c> scope){
        //MP-792 Code Start 13-Apr-2022
        Boolean alertBatchProcess=True;
        List<ccrz__E_Subscription__c> findRenew = new List<ccrz__E_Subscription__c>();
        findRenew =[Select id,Name,ccrz__Account__c,ccrz__SPT__c from ccrz__E_Subscription__c where ccrz__Account__c=:scope[0].ccrz__Account__c AND ccrz__SPT__c=:scope[0].ccrz__SPT__c AND ccrz__SubscriptionProduct__c=:scope[0].ccrz__SubscriptionProduct__c AND (ccrz__SubscriptionStatus__c=:'Renew' OR ccrz__SubscriptionStatus__c=:'Active')];
        system.debug('findRenew--->>'+findRenew);
        if(findRenew.size()>0){
            alertBatchProcess=false;
        }
        if(alertBatchProcess){ //MP-792 Code End 13-Apr-2022
        
        Set<String> emailtemplateName = new Set<String>{'OSM_Subscription_Expired_NewTemp_SSOEM', 'OSM_Subscription_Expired_NewTemp'};  
            
            EmailTemplate tempExpired;
        EmailTemplate tempExpiredSSOEM;
        for(EmailTemplate temp : [Select id, Name from EmailTemplate where name IN: emailtemplateName]){
            if(temp.Name == 'OSM_Subscription_Expired_NewTemp'){
                tempExpired = temp;
            }  
            if(temp.Name == 'OSM_Subscription_Expired_NewTemp_SSOEM'){
                tempExpiredSSOEM = temp;
            }  
        }
        Messaging.Email[] messages = new List<Messaging.SingleEmailMessage>();
        
        String[] toaddress = new String[]{}; 
        String[] toSetScondaryaddress = new String[]{};    
            //List<ccrz__E_Subscription__c> subList = new List<ccrz__E_Subscription__c>();
            for(ccrz__E_Subscription__c sub : scope){
                
                toaddress.add(sub.ccrz__CCOrder__r.ccrz__Contact__r.Email);
                if(sub.ccrz__CCOrder__r.OSMSecondaryEmail__c != null){
                    toaddress.add(sub.ccrz__CCOrder__r.OSMSecondaryEmail__c);
                }
                if(sub.ccrz__CCOrder__r.OSMSecondaryEmail__c != null){
                    toaddress.add(sub.ccrz__CCOrder__r.OSMSecondaryEmail__c);
                    toSetScondaryaddress.add(sub.ccrz__CCOrder__r.OSMSecondaryEmail__c);
                } 
                  //Swetha: START for MP-655
                 if(sub.ccrz__CCOrder__r.OSM_Headquarter_Email__c != null){
                toaddress.add(sub.ccrz__CCOrder__r.OSM_Headquarter_Email__c);
            }
            //Swetha: ENDMp-655
                
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                
                if(Label.OSM_SSOEM_Admin_UserType != sub.ccrz__CCOrder__r.Purchased_By_User_Type__c){
                    email = Messaging.renderStoredEmailTemplate(tempExpired.id, sub.ccrz__CCOrder__r.ccrz__Contact__c, sub.id);
                    email.setTargetObjectId(sub.ccrz__CCOrder__r.ccrz__User__c);
                    if(sub.ccrz__CCOrder__r.ccrz__Account__r.BillingCountry == 'United States'){
                        email.setToAddresses(toaddress);
                    }
                    email.setTemplateId(tempExpired.id);
                    email.setSaveAsActivity(false);
                    /*for(OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress where DisplayName='noreply.identity@cummins.com']) 
                    {
                        email.setOrgWideEmailAddressId(owa.id); 
                    }*/
                    email.setSubject(sub.ccrz__CCOrder__r.ccrz__Account__r.Name+'('+sub.ccrz__CCOrder__r.ccrz__Account__r.IAM_Service_Provider_Code__c+') :' +' '+ sub.ccrz__SubscriptionProduct__r.Name +' '+ 'Subscription has expired');
                    System.debug('email-if1---'+email);
                    messages.add(email);
                }
                if((Label.OSM_SSOEM_Admin_UserType == sub.ccrz__CCOrder__r.Purchased_By_User_Type__c) && ((sub.ccrz__CCOrder__r.Send_SSOEM_Customer_Email__c == True) || (sub.ccrz__CCOrder__r.Send_SSOEM_Customer_Email__c == False))) {
                    email = Messaging.renderStoredEmailTemplate(tempExpired.id, sub.ccrz__CCOrder__r.ccrz__Contact__c, sub.id);
                    email.setTargetObjectId(sub.ccrz__CCOrder__r.ccrz__User__c);
                    email.setToAddresses(toSetScondaryaddress);
                    email.setTemplateId(tempExpired.id);
                    email.setSaveAsActivity(false);
                    /*for(OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress where DisplayName='noreply.identity@cummins.com']) 
                    {
                        email.setOrgWideEmailAddressId(owa.id); 
                    }*/
                    email.setSubject(sub.ccrz__CCOrder__r.ccrz__Account__r.Name+'('+sub.ccrz__CCOrder__r.ccrz__Account__r.IAM_Service_Provider_Code__c+') :' +' '+ sub.ccrz__SubscriptionProduct__r.Name +' '+ 'Subscription has expired');
                    System.debug('email-if2---'+email);
                    messages.add(email);
                }
                if((Label.OSM_SSOEM_Admin_UserType == sub.ccrz__CCOrder__r.Purchased_By_User_Type__c) && (sub.ccrz__CCOrder__r.isOnBehalf__c== True) && (sub.ccrz__CCOrder__r.Send_SSOEM_Customer_Email__c == True)){
                    email = Messaging.renderStoredEmailTemplate(tempExpiredSSOEM.id, sub.ccrz__CCOrder__r.ccrz__Contact__c, sub.id);
                    email.setTargetObjectId(sub.ccrz__CCOrder__r.ccrz__Contact__c);
                    email.setToAddresses(toSetScondaryaddress);
                    email.setTemplateId(tempExpiredSSOEM.id);
                    email.setSaveAsActivity(false);
                    /*for(OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress where DisplayName='noreply.identity@cummins.com']) 
                    {
                        email.setOrgWideEmailAddressId(owa.id); 
                    }*/
                    email.setSubject(sub.ccrz__CCOrder__r.ccrz__Account__r.Name+'('+sub.ccrz__CCOrder__r.ccrz__Account__r.IAM_Service_Provider_Code__c+') :' +' '+ sub.ccrz__SubscriptionProduct__r.Name +' '+ 'Subscription has expired');
                    System.debug('email-if3---'+email);
                    messages.add(email);
                } 
                
            }
        
        
        If(messages.size()>0){
            if(!test.isRunningTest()){
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages); 
                system.debug('Send Eamil to user'+messages);
            }
        }
        
       } 
    }    
    global void finish(Database.BatchableContext BC){
        OSM_Integration_Log__c log = new OSM_Integration_Log__c();
        log.Service_Name__c='OSM_Subscription_ExpiredAlertbatch';
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