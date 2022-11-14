global class OSM_IAMProvisioningUpdate_Batch implements Database.Batchable<sObject>,Database.AllowsCallouts 
{
    String version;
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String activeStatus = 'Active';
        //String query = 'Select ID, Subscription_Start_Date__c, Subscription_End_Date__c, Subscription_Status__c From OSM_Subscription_Account_Provision__c where Subscription_Status__c =:activeStatus AND Subscription_Start_Date__c <= TODAY AND isSubscriptionStarted__c=false';
       String query = 'Select ID,  Subscription_End_Date__c, Subscription_Status__c From OSM_Subscription_Account_Provision__c where Subscription_Status__c =:activeStatus';
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<OSM_Subscription_Account_Provision__c> scope)
    {
        
        /*for(OSM_Subscription_Account_Provision__c junctionRecord :scope)
        {
            junctionRecord.isSubscriptionStarted__c = true;
        }
        
        update scope;*/
    }
    
    
    global void finish(Database.BatchableContext BC)
    {
        System.debug('End : OSM_IAMProvisioningUpdate_Batch');
    }
}