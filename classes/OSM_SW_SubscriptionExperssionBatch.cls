/*
=============================================================
Purpose:                                                            
This is batch class for CC Subscription object to update status
=============================================================
*/

global class OSM_SW_SubscriptionExperssionBatch implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('Select id,ccrz__Quantity__c,OSM_Subscription_End_Date__c, ccrz__SubscriptionStatus__c from ccrz__E_Subscription__c where  ccrz__Quantity__c>=0 and OSM_Subscription_End_Date__c <= YESTERDAY LIMIT 1');
    }

    global void execute(Database.BatchableContext BC, List<ccrz__E_Subscription__c> scope){               
        for(ccrz__E_Subscription__c sub :scope){
        if(sub .ccrz__SubscriptionStatus__c!='Cancelled' ){
        sub.ccrz__SubscriptionStatus__c = 'Expired';
            }
           }
             update scope;
    }

    global void finish(Database.BatchableContext BC){
    
    Database.executeBatch(new OSM_SW_CancelSubscriptionBatch());
    }   
}