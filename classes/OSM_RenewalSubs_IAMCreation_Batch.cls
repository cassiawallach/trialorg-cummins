global class OSM_RenewalSubs_IAMCreation_Batch implements Database.Batchable<sObject>, Database.AllowsCallouts, Schedulable {
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        string orderStatus = 'Failure';
        string target = 'WINLIMS';
        String queryForBatch = 'SELECT Id, IsIAMDataUpdated__c, ccrz__SubscriptionStartDate__c, OSM_Subscription_End_Date__c FROM ccrz__E_Subscription__c WHERE Is_Renewal_Subscription__c = true AND ( ccrz__SubscriptionStartDate__c = TODAY OR ccrz__SubscriptionStartDate__c = TOMORROW OR IsIAMDataUpdated__c = false)';
        return Database.getQueryLocator(queryForBatch);
    }
    
    
    global void execute(Database.BatchableContext BC, List<ccrz__E_Subscription__c> scope){
        Set<Id> set_SubsId = new Set<Id>();
        for(ccrz__E_Subscription__c subs : scope){
            OSM_SW_SubscriptionAction.IAMProvisioningOnInsert(new List<Id>{subs.Id},true,true);
            set_SubsId.add(subs.Id);
            subs.IsIAMDataUpdated__c = true;
        }
        if(set_SubsId.size() > 0){
            List<ccrz__E_Subscription__c> list_SubsUpdate = new List<ccrz__E_Subscription__c>();
            for(OSM_Order_Subscription__c osmSubs: [SELECT Id, OSM_CCSubscription__c, OSM_CCOrder__c, OSM_CCOrder__r.OSM_SW_IAM_Provisioning__c FROM OSM_Order_Subscription__c WHERE OSM_CCSubscription__c IN :set_SubsId]){
                if(osmSubs.OSM_CCOrder__r.OSM_SW_IAM_Provisioning__c){
                    ccrz__E_Subscription__c newSubs = new ccrz__E_Subscription__c(Id = osmSubs.OSM_CCSubscription__c);
                    newSubs.IsIAMDataUpdated__c = true;
                    list_SubsUpdate.add(newSubs);
                }
            }
            if(list_SubsUpdate.size() > 0){
                update list_SubsUpdate;
            }
        }
    }
    
    
    global void finish(Database.BatchableContext BC){
        // do nothing
    }
    
    
    global void execute(SchedulableContext SC){
        OSM_RenewalSubs_IAMCreation_Batch iamRenwBatch = new OSM_RenewalSubs_IAMCreation_Batch();
        database.executebatch(iamRenwBatch,1);
    }
}