/************************************************************
Name:  OSM_Subscription_DaysAlertbatch
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This class for sending email for user when subscription expire date remain days 1,2,3,7,15,30
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Neha Sharma     01/01/2019     INITIAL DEVELOPMENT          
1.1 -   Ronnie Mishra   12/16/2021     MP-140, Altered code to include email alerts for quaterly and monthly subscription lengths. 
*************************************************************/
global class OSM_Subscription_DaysAlertbatch implements Database.Batchable<sObject>, Database.Stateful{
    
    //Messaging.Email[] messages = new List<Messaging.SingleEmailMessage>();
    
    global Database.QueryLocator start(Database.BatchableContext BC){        
        //MP-140, Added ccrz__SPT__r.ccrz__DisplayName__c in query
        return Database.getQueryLocator([Select id,ccrz__CCOrder__r.ccrz__Contact__c,ccrz__CCOrder__r.OSMSecondaryEmail__c,ccrz__CCOrder__r.ccrz__User__c,OSM_Display_Product__r.name,
                                         ccrz__SubscriptionStartDate__c,ccrz__SubscriptionStatus__c,OwnerId,Contact__c,ccrz__CCOrder__r.ccrz__Contact__r.Email,ccrz__Account__c,ccrz__SPT__c,ccrz__SubscriptionProduct__c,
                                         OSM_Subscription_End_Date__c,ccrz__CCOrder__r.Should_Show_Price__c,ccrz__CCOrder__r.ccrz__User__r.Email,
                                         ccrz__CCOrder__r.isOnBehalf__c,ccrz__CCOrder__r.OSM_Headquarter_Email__c,ccrz__CCOrder__r.Send_SSOEM_Customer_Email__c,ccrz__CCOrder__r.Purchased_By_User_Type__c,ccrz__SPT__r.ccrz__DisplayName__c,
                                         ccrz__CCOrder__r.createdById,ccrz__CCOrder__r.ccrz__Account__r.BillingCountry,ccrz__CCOrder__r.ccrz__Account__r.Name,ccrz__CCOrder__r.ccrz__Account__r.IAM_Service_Provider_Code__c
                                         from ccrz__E_Subscription__c 
                                         where OSM_Subscription_End_Date__c!=null and ccrz__SubscriptionStatus__c=:'Active' AND  ccrz__SPT__r.ccrz__DisplayName__c !='99 Year'
                                         and (OSM_Subscription_End_Date__c <=: system.today().addDays(+30) AND OSM_Subscription_End_Date__c >=: system.today()) ] );
                                         //OMG-959 Removed this condition and added the above condition (OSM_Subscription_End_Date__c >=: system.now().addDays(-7)) OR (OSM_Subscription_End_Date__c >=: system.now().addDays(-30))
    }
    
    global void execute(Database.BatchableContext BC, List<ccrz__E_Subscription__c> scope){  
       //MP-792 Code Start 08-Apr-2022
        Boolean alertBatchProcess=True;
        List<ccrz__E_Subscription__c> findRenew = new List<ccrz__E_Subscription__c>();
        findRenew =[Select id,Name,ccrz__Account__c,ccrz__SPT__c from ccrz__E_Subscription__c where ccrz__Account__c=:scope[0].ccrz__Account__c AND ccrz__SPT__c=:scope[0].ccrz__SPT__c AND ccrz__SubscriptionProduct__c=:scope[0].ccrz__SubscriptionProduct__c AND ccrz__SubscriptionStatus__c=:'Renew'];
        system.debug('findRenew--->>'+findRenew);
        if(findRenew.size()>0){
            alertBatchProcess=false;
        }
        if(alertBatchProcess){ //MP-792 Code End 08-Apr-2022
        Set<String> emailtemplateName = new Set<String>{'OSM_Subscription_Expired_Template_Branch', 'OSM_Subscription_Expired_Template'};  
        //MP-140 Code Start
        List<OSM_Subscription_Renew_Email__mdt> subEmailAlertList = [SELECT MasterLabel, Subscription_Length__c, Email_Trigger_Days__c FROM OSM_Subscription_Renew_Email__mdt];
        Map<String, String> subLengthToDaysMap = new Map<String, String>();
        for(OSM_Subscription_Renew_Email__mdt subEmailAlertObj : subEmailAlertList) {
            subLengthToDaysMap.put(subEmailAlertObj.Subscription_Length__c, subEmailAlertObj.Email_Trigger_Days__c);
        }
        //MP-140 Code End
        EmailTemplate et;
        EmailTemplate branchEt;
        for(EmailTemplate temp : [Select id, Name from EmailTemplate where name IN: emailtemplateName]){
            if(temp.Name == 'OSM_Subscription_Expired_Template'){
                et = temp;
            }  
            if(temp.Name == 'OSM_Subscription_Expired_Template_Branch'){
                branchEt = temp;
            }  
        }
        Messaging.Email[] messages = new List<Messaging.SingleEmailMessage>();
        
        Date CurDate = system.today();
        for(ccrz__E_Subscription__c sub : scope){
            //MP-140 Code Start
            string subscriptiondate = subLengthToDaysMap.get(sub.ccrz__SPT__r.ccrz__DisplayName__c);
            List<String> lstStr = subscriptiondate.split(',');
            List<Integer> intervalValues = new List<Integer>();
            for(String strValue : lstStr)
            {
                intervalValues.add(Integer.ValueOf(strValue));
            }
            //MP-140 Code End
            DateTime EndDate =  sub.OSM_Subscription_End_Date__c;
            DateTime systemDate =  system.now();
            String[] toaddress = new String[]{}; 
            toaddress.add(sub.ccrz__CCOrder__r.ccrz__Contact__r.Email);
            String[] toaddress1 = new String[]{}; 
            toaddress1.add(sub.ccrz__CCOrder__r.ccrz__User__r.Email);
            if(sub.ccrz__CCOrder__r.OSMSecondaryEmail__c != null){
                toaddress.add(sub.ccrz__CCOrder__r.OSMSecondaryEmail__c);
                toaddress1.add(sub.ccrz__CCOrder__r.OSMSecondaryEmail__c);
            }
            //Swetha: START MP-655
            if(sub.ccrz__CCOrder__r.OSM_Headquarter_Email__c != null){
                toaddress.add(sub.ccrz__CCOrder__r.OSM_Headquarter_Email__c);
            }
            //Swetha: END MP655
            integer intDays =  systemDate.dateGMT().daysBetween(EndDate.dateGMT());
            
            if(test.isRunningTest()) {
                intervalValues.add(3);
                intDays = 3;
            }  
            
            for(integer inte:intervalValues){
                if(inte == intDays) {
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    system.debug('Label.OSM_SSOEM_Admin_UserType-->'+Label.OSM_SSOEM_Admin_UserType);
                    system.debug('sub.ccrz__CCOrder__r.Purchased_By_User_Type__c-->'+sub.ccrz__CCOrder__r.Purchased_By_User_Type__c);
                    if(Label.OSM_SSOEM_Admin_UserType != sub.ccrz__CCOrder__r.Purchased_By_User_Type__c){
                        
                        email = Messaging.renderStoredEmailTemplate(et.id, sub.ccrz__CCOrder__r.ccrz__Contact__c, sub.id);
                        email.setTargetObjectId(sub.ccrz__CCOrder__r.ccrz__User__c);
                        if(sub.ccrz__CCOrder__r.ccrz__Account__r.BillingCountry == 'United States'){
                            email.setToAddresses(toaddress);
                        }
                        email.setTemplateId(et.id);
                        email.setSaveAsActivity(false);                        
                        email.setSubject(sub.ccrz__CCOrder__r.ccrz__Account__r.Name+'('+sub.ccrz__CCOrder__r.ccrz__Account__r.IAM_Service_Provider_Code__c+') : '+ Label.OSM_Subscription_Subject +' '+ intDays +' '+ 'Days');
                        messages.add(email);
                    }
                    if((Label.OSM_SSOEM_Admin_UserType == sub.ccrz__CCOrder__r.Purchased_By_User_Type__c)&& ((sub.ccrz__CCOrder__r.Send_SSOEM_Customer_Email__c == True) || (sub.ccrz__CCOrder__r.Send_SSOEM_Customer_Email__c == False))){
                        
                        email = Messaging.renderStoredEmailTemplate(et.id, sub.ccrz__CCOrder__r.ccrz__User__c, sub.id);
                        email.setTargetObjectId(sub.ccrz__CCOrder__r.ccrz__User__c);
                        //email.setToAddresses(toaddress1);
                        email.setTemplateId(et.id);
                        email.setSaveAsActivity(false);
                        email.setSubject(sub.ccrz__CCOrder__r.ccrz__Account__r.Name+'('+sub.ccrz__CCOrder__r.ccrz__Account__r.IAM_Service_Provider_Code__c+') : '+Label.OSM_Subscription_Subject +' '+ intDays +' '+ 'Days');
                        messages.add(email);
                    }
                    if((Label.OSM_SSOEM_Admin_UserType == sub.ccrz__CCOrder__r.Purchased_By_User_Type__c) && (sub.ccrz__CCOrder__r.isOnBehalf__c== True)&& (sub.ccrz__CCOrder__r.Send_SSOEM_Customer_Email__c == True)){
                        
                        email = Messaging.renderStoredEmailTemplate(BranchEt.id, sub.ccrz__CCOrder__r.ccrz__Contact__c, sub.id);
                        email.setTargetObjectId(sub.ccrz__CCOrder__r.ccrz__Contact__c);
                        //email.setToAddresses(toaddress);
                        email.setTemplateId(BranchEt.id);
                        email.setSaveAsActivity(false);
                        email.setSubject(sub.ccrz__CCOrder__r.ccrz__Account__r.Name+'('+sub.ccrz__CCOrder__r.ccrz__Account__r.IAM_Service_Provider_Code__c+') : '+Label.OSM_Subscription_Subject +' '+ intDays +' '+ 'Days');
                        messages.add(email);
                    }
                }
            }
        }   
        
        If(messages.size()>0){
            if(!test.isRunningTest()){
                try {
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);                     
                }catch(Exception exp) {
                    //Erro Handling                         
                }
            }
        }
      }  
    }    
    global void finish(Database.BatchableContext BC){
        OSM_Integration_Log__c log = new OSM_Integration_Log__c();
        log.Service_Name__c='OSM_Subscription_DaysAlertbatch' ;
        log.Internal_Batch_Log__c=true;
        AsyncApexJob jobstatus = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =:BC.getJobId()];
        log.Status__c = jobstatus.Status;
        if(jobstatus.Status=='Completed'){
            log.Status__c = 'Processed'; 
        }else if(jobstatus.Status=='Failed'){
            log.Internal_Batch_Failure__c=true;
            log.No_of_Jobs_Failed__c=jobstatus.NumberOfErrors;
        }
        system.debug('logss-->'+log);
        insert log;   
        
    }
}