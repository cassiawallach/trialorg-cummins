/************************************************************
Name:  OSM_SW_RetryOrderUpdateJobs
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is batch class which will take all failed order 
cancellation jobs and will send it to scheduler which 
will run every 1 hr.               
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit S            12/07/2018     INITIAL DEVELOPMENT          

*************************************************************/

global class OSM_SW_RetryOrderUpdateJobs implements Database.Batchable<sObject>,Database.AllowsCallouts{
    
    global String query{get;set;}
    Set<Id> OrderId = new Set<Id>();
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        query = 'Select id, OSM_Order_Update_Integration_Failure__c,ccrz__CCOrder__c from ccrz__E_TransactionPayment__c where OSM_Order_Update_Integration_Failure__c = true';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<ccrz__E_TransactionPayment__c> scope){               
        for(ccrz__E_TransactionPayment__c payment :scope){
            OrderId.add(payment.ccrz__CCOrder__c);
            }
        system.debug('OrderID'+OrderId);     
        OSM_SW_OrderActions.call_DA_OrderUpdatesAsync(OrderId);        
    }

    global void finish(Database.BatchableContext BC){
        OSM_SW_RetryOrderCancellationJobs bjobs = new OSM_SW_RetryOrderCancellationJobs();
        database.executebatch(bjobs,Integer.valueOf(label.OSM_OrderCancellation_Batch_Size));        
    }   
}