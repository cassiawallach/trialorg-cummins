/************************************************************
Name:  OSM_SubscriptionMigrationBatch
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This batch is written to match coupons codes for all accounts
for which id will be passed
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Sangeeta            3/06/2019    INITIAL DEVELOPMENT          


*************************************************************/

global class OSM_SubscriptionMigrationBatch implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.Stateful{
    
    String query;
    global String AccountId;
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        query='select id,Name,type,DTNA__c,IAM_Service_Provider_Code__c,ccrz__E_AccountGroup__r.name from Account where type=\'Dealer Account\' or type=\'Distributor Account\' or type=\'Distributor Branch Account\'' ;
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope){               
        //Set<Id> dealerAccountIdSet=new Set<Id>();
        //Set<Id> disAccountIdSet=new Set<Id>();
        Map<id,Account> dealerAccountsDataMap=new Map<id,Account>();
        Map<id,Account> disAccountsDataMap=new Map<id,Account>();
        for(Account a :scope)
        {
            if(a.type=='Dealer Account' && a.DTNA__c==false)
            {
                AccountId = a.id;// Added By Dhiraj
                //dealerAccountIdSet.add(a.id);
                dealerAccountsDataMap.put(a.id,a);
            }
            else if(a.type=='Distributor Account' || a.type=='Distributor Branch Account')
            {
                AccountId = a.id;// Added By Dhiraj
                //disAccountIdSet.add(a.id);
                disAccountsDataMap.put(a.id,a);
            }
            
        }                                                                          
        
        //OSM_SW_SubscriptionMigrationLogic.getCouponCodeforDealer(dealerAccountIdSet);    
        //OSM_SW_SubscriptionMigrationLogic.getCouponCodeforDistributors(disAccountIdSet); 
        if(dealerAccountsDataMap != null){
            OSM_SW_SubscriptionMigrationLogic.getCouponCodeforDealer(dealerAccountsDataMap);    
        }
        if(disAccountsDataMap != null){
            OSM_SW_SubscriptionMigrationLogic.getCouponCodeforDistributors(disAccountsDataMap);                                                                                              
        }
        
    }
    
    global void finish(Database.BatchableContext BC){
        
        OSM_Integration_Log__c log = new OSM_Integration_Log__c();
        log.Service_Name__c='OSM_SubscriptionMigrationBatch';
        log.Internal_Batch_Log__c=true;
        AsyncApexJob jobstatus = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =:BC.getJobId()];
        log.Status__c = jobstatus.Status;
        if(jobstatus.Status=='Completed'){
            log.Status__c = 'Processed'; 
        }else if(jobstatus.Status=='Failed'){
            log.Internal_Batch_Failure__c=true;
            log.No_of_Jobs_Failed__c=jobstatus.NumberOfErrors;
        }
        log.Account__c = AccountId;  // Added By Dhiraj 
        insert log;
        
    }
}