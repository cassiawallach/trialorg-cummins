/************************************************************
Name:  OSM_InterCompanyInvoice_RetryBatch
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This batch class will be used to initiate the Intercompany 
record creation process.
============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Sangeeta         27th Dec 2018     INITIAL DEVELOPMENT  
1.1 -   Nandigam Sasi    19th APR 2021     Updated   Batch Execution as part of MAR-1548 
*************************************************************/
global class OSM_InterCompanyInvoice_RetryBatch implements Database.Batchable<sObject>,Database.AllowsCallouts,Schedulable,Database.RaisesPlatformEvents{
    global OSM_InterCompanyInvoice_RetryBatch(){
        // do nothing
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
       return Database.getQueryLocator([select Id from ccrz__E_Order__c where ccrz__OrderStatus__c = 'Order Submitted' AND OrderProcessedforFSD__c=true And IsInterCompanyProcessSuccess__c=false And OSM_SW_Is_InterCompany_Order__c=false And CreatedDate = THIS_MONTH AND FW_Product_Count__c<=0 AND ccrz__Storefront__c='SoftwareStore' ORDER BY LastModifiedDate DESC]);
    }
    
    global void execute(Database.BatchableContext BC, List<ccrz__E_Order__c> scope){
        Set<Id> set_OrderId = new Set<Id>();
        for(ccrz__E_Order__c order : scope){
            set_OrderId.add(order.id);
        }
        if(set_OrderId.size() > 0){
            System.enqueueJob(new OSM_InterCompanyQueueable(set_OrderId));
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
    
    global void execute(SchedulableContext SC){
        Database.executeBatch(new OSM_InterCompanyInvoice_RetryBatch(),Integer.valueOf(Label.OSM_InterCompany_Batch_Size));
    }
}