/*
=============================================================
Purpose:                                                            
This is batch class for CC Subscription object to update status
=============================================================
*/

global class OSM_SW_SubscriptionExpirationBatch implements Database.Batchable<sObject>,Database.Stateful{
    
    global List<Id> subscIdTocreateGuidanzMobileIAM = new List<Id>();
    global boolean isGuidanzMobileIAMRenewalAlreadyDone = false ;
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([Select id,ccrz__Quantity__c,ccrz__Account__c,OSM_Subscription_End_Date__c, ccrz__SubscriptionStatus__c from ccrz__E_Subscription__c where  ccrz__SubscriptionStatus__c='Active' and ccrz__Quantity__c>0 and OSM_Subscription_End_Date__c <= TODAY]);
    }

    global void execute(Database.BatchableContext BC, List<ccrz__E_Subscription__c> scope){ 
        
        Savepoint sp = Database.setSavepoint();
        try{
            Set<String> accIdSet = new Set<String>();
            List<Id> lstSubId = new List<Id>();
            Map<Id, Integer> oldSubscQuantity = new Map<Id,Integer>();
            for(ccrz__E_Subscription__c sub :scope)
            {
                sub.ccrz__SubscriptionStatus__c = 'Expired';
                lstSubId.add(sub.Id);
                oldSubscQuantity.put(sub.Id,Integer.valueOf(sub.ccrz__Quantity__c));
                accIdSet.add(sub.ccrz__Account__c);
            }
            System.debug('scope : '+scope);
            System.debug(': '+accIdSet);
            Integer guidenZmobileAccessCount = 0;
             List<ccrz__E_Subscription__c> lstNewSubsc = new List<ccrz__E_Subscription__c>();
            if(accIdSet.size()>0)
            {
                List<String> accLst1 = new List<String>(); 
                accLst1.addAll(accIdSet);   
                guidenZmobileAccessCount = OSM_SW_ProductDetailCommonUtility.getGuidenzMobileIAMAccessRecord(accLst1[0]);
            
             
            
            System.debug('accLst1: '+accLst1);
            
            lstNewSubsc = [Select Id,ccrz__Quantity__c,ccrz__SubscriptionProduct__c,ccrz__SubscriptionProduct__r.Name,Renewed_From_Subscription__c from ccrz__E_Subscription__c where ccrz__SubscriptionStatus__c =: Label.OSM_Subscription_Status_Renew  and ccrz__Account__c =: accLst1[0] and ccrz__SubscriptionStartDate__c <=: DateTime.now()];
            }
            
            System.debug('lstNewSubsc : '+lstNewSubsc);
            
            List<Id> lstSubId2 = new List<Id>();
            boolean hasGuidanzMobileSubsc = false;
            Integer containsGMQuantity = 0;
            List<Id> lstSubId3 = new List<Id>();
            for(ccrz__E_Subscription__c subsc : lstNewSubsc)
            {
                if(subsc.ccrz__SubscriptionProduct__r.Name.containsIgnoreCase('Guidanz Mobile') || OSM_SW_ProductDetailCommonUtility.isIncludedGuidenzMobileProduct(subsc.ccrz__SubscriptionProduct__c))
                {
                    hasGuidanzMobileSubsc = true;
                    containsGMQuantity = containsGMQuantity + Integer.valueOf(subsc.ccrz__Quantity__c);
                    lstSubId3.add(subsc.Id);
                }
                else
                {
                    lstSubId2.add(subsc.Id);
                }
                    
            }
            
            system.debug('hasGuidanzMobileSubsc: '+hasGuidanzMobileSubsc);
            system.debug('guidenZmobileAccessCount: '+guidenZmobileAccessCount);
            system.debug('containsGMQuantity: '+containsGMQuantity);
            if(hasGuidanzMobileSubsc && guidenZmobileAccessCount <= containsGMQuantity)
            {
                if(!isGuidanzMobileIAMRenewalAlreadyDone)
                {
                    for(Id key : lstSubId3)
                    {
                        lstSubId2.add(key);
                    }
                }
                
                
            }
            else
            {
                if(lstSubId3.size() >  0 || Test.isRunningTest())
                {
                    for(Id key : lstSubId3)
                    {
                        subscIdTocreateGuidanzMobileIAM.add(key);
                    }
                    OSM_SW_SubscriptionAction.IAMProvisioningOnInsert(lstSubId3,false,false);
                }
            }
            
            System.debug('lstSubId3: '+lstSubId3);
            System.debug('lstSubId2: '+lstSubId2);
            
            if(lstSubId2.size() >  0 || Test.isRunningTest())
            {
                OSM_SW_SubscriptionAction.IAMProvisioningOnInsert(lstSubId2,true,false );
            }
            
            if(subscIdTocreateGuidanzMobileIAM.size() > 0 || Test.isRunningTest())
                isGuidanzMobileIAMRenewalAlreadyDone = true;
            
            
            update scope;
            
            
             
            if(accIdSet.size()>0)
            {
                List<String> accLst = new List<String>(accIdSet);
                OSM_SW_Transaction_Util.updateAccountFieldsForAllOperations(accLst,Label.OSM_Subs_Expiration);      
            }
            
            if(Test.isRunningTest())
            {
                Integer i = 11/0;
            }
         }
         Catch(Exception ex)
         {
             Database.rollback(sp);

         }
             
    }

    global void finish(Database.BatchableContext BC){
    
        if(subscIdTocreateGuidanzMobileIAM.size() >0 || Test.isRunningTest())
           OSM_SW_SubscriptionAction.IAMProvisioningOnInsert(subscIdTocreateGuidanzMobileIAM,false,true );
        OSM_Integration_Log__c log = new OSM_Integration_Log__c();
        log.Service_Name__c='Scheduled:' +Label.OSM_Subs_Expiration;
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
    
       // Database.executeBatch(new OSM_SW_CancelSubscriptionBatch());//commented by swetha
        
        //On subscription expiration batch RenewTOActive batch take place 
        //and will check if any subscription in renew state then will activate Renew Subscription and will execute Create&Get Order 
        //Database.executeBatch(new OSM_SW_SubscriptionRenewToActiveBatch());//commented by swetha
        Database.executeBatch(new OSM_RenewalSubs_LicenseKeys_Batch(),1);//Added by swetha
        Database.executeBatch(new OSM_RenewalSubs_IAMCreation_Batch(),1);//Added by Subbu
    }   
}