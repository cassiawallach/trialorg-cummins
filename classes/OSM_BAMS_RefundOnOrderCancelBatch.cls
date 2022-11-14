/************************************************************
Name:  OSM_BAMS_RefundOnOrderCancelBatch
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This batch class will be used to initiate the refund whenever 
order is cancelled by User/Admins and payment is done by cards.

This will pick up the records which got cancelled 3 days back.
3 days is configurable.
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Vaibhav            79/2018     INITIAL DEVELOPMENT          


*************************************************************/

global class OSM_BAMS_RefundOnOrderCancelBatch implements Database.Batchable<sObject>,Database.AllowsCallouts, Database.Stateful{
    
    String query;
    global String AccountId;
    
    global OSM_BAMS_RefundOnOrderCancelBatch()
    {
        
    }
    global OSM_BAMS_RefundOnOrderCancelBatch(String soql)
    {
        this.query=soql;
    }
    List<String> orderIdLst;
    //this is for testing only
    global OSM_BAMS_RefundOnOrderCancelBatch(List<String> orderIdLst1)
    {
        orderIdLst = orderIdLst1;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        String orderProcessRefundAfterDays = Label.OSM_BAMS_ProcessRefundAfterDays;
        Date curDate = System.today()- Integer.valueof(orderProcessRefundAfterDays);
        
        //if user supplies orderIdLst then process refund for those orders
        if(orderIdLst!=null && orderIdLst.size()>0){
            System.debug('===OrderIdLst ==='+orderIdLst);
            query = 'Select id, Is_Refund_Initiated__c, Refund_status__c,BAMS_Merchant_Reference_Number__c,ccrz__CurrencyISOCode__c,Order_Cancellation_Date__c from ccrz__E_Order__c where Refund_status__c=\'Pending Refund\' and OrderProcessedforFSD__c = false and Is_OMS_Revoke_and_Cancel_Not_Done_Count__c = 0 and  ccrz__OrderStatus__c=\'Cancelled\' and Is_Refund_Initiated__c != true AND id in :orderIdLst' ;
        }
        else{
            query = 'Select id, Is_Refund_Initiated__c, Refund_status__c,BAMS_Merchant_Reference_Number__c,ccrz__CurrencyISOCode__c,Order_Cancellation_Date__c from ccrz__E_Order__c where Refund_status__c=\'Pending Refund\' and OrderProcessedforFSD__c = false and Is_OMS_Revoke_and_Cancel_Not_Done_Count__c = 0 and ccrz__OrderStatus__c=\'Cancelled\' and Is_Refund_Initiated__c != true AND Order_Cancellation_Date__c  >=: curDate' ;
        }
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<ccrz__E_Order__c> scope){               
        
        Set<Id> orderIdToProcess = new Set<Id>();
        
        List<ccrz__E_Order__c> orderList = new List<ccrz__E_Order__c>();
        List<Id> orderIdLst = new List<Id>();
        for(ccrz__E_Order__c order:scope)
        {
            orderIdLst.add(order.id);
        }
        
        //logic to initiate the refund the only for Card payments
        for(ccrz__E_TransactionPayment__c transPay : [select id,name,ccrz__CCOrder__c,ccrz__Account__c,ccrz__Amount__c from ccrz__E_TransactionPayment__c where ccrz__CCOrder__c in :orderIdLst and ccrz__AccountType__c='cc']) //Modify the Query for ccrz__Account__c field By Dhiraj  
        {
            AccountId = transPay.ccrz__Account__c;// Added By Dhiraj
            if(transPay.ccrz__Amount__c > 0) orderIdToProcess.add(transPay.ccrz__CCOrder__c);//@Vishnu LL-39 added condition to skip 0 price orders refund
        }
        
        for(ccrz__E_Order__c order :scope){
            if(orderIdToProcess.contains(order.id))
            {
                orderList.add(order);    
            }
            
        }                                                                                               
        
        OSM_BAMS_BL_Operations.processRefundForCancelledOrders(orderList);        
    }
    
    global void finish(Database.BatchableContext BC){
        OSM_Integration_Log__c log = new OSM_Integration_Log__c();
        log.Service_Name__c='Scheduled:' + Label.CyberSource_ServiceName;
        log.Internal_Batch_Log__c=true;
        AsyncApexJob jobstatus = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =:BC.getJobId()];
         log.Status__c = jobstatus.Status;
        if(jobstatus.Status=='Completed'){
            log.Status__c = 'Processed'; 
        }else if(jobstatus.Status=='Failed'){
            log.Internal_Batch_Failure__c=true;
            log.No_of_Jobs_Failed__c=jobstatus.NumberOfErrors;
        }
         log.Account__c = AccountId;  // Added By Dhiraj for MAR-1621 - Story On 21st April 2021
        insert log;
        
    }
}