/************************************************************
Name:  OSM_BAMS_RefundOnOrderItemCancelBatch 
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

global class OSM_BAMS_RefundOnOrderItemCancelBatch implements Database.Batchable<sObject>,Database.AllowsCallouts, Schedulable{
    
    String query;
   
    List<String> orderIdLst;
    global OSM_BAMS_RefundOnOrderItemCancelBatch(){
        // do nothing
    }
    
    //this is for testing only
    global OSM_BAMS_RefundOnOrderItemCancelBatch(List<String> orderIdLst1)
    {
        orderIdLst = orderIdLst1;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        String orderProcessRefundAfterDays = Label.OSM_BAMS_ProcessRefundAfterDays;
        Date curDate = System.today()- Integer.valueof(orderProcessRefundAfterDays);
    
        //if user supplies orderIdLst then process refund for those orders
        if(orderIdLst!=null && orderIdLst.size()>0){
            System.debug('===OrderIdLst ==='+orderIdLst);
            query = 'Select id, ccrz__Order__c, ccrz__SubAmount__c, ccrz__Price__c, Vertex_Tax__c, ccrz__Order__r.Refund_status__c,ccrz__Order__r.BAMS_Merchant_Reference_Number__c,ccrz__OrderItemStatus__c,ccrz__Order__r.ccrz__CurrencyISOCode__c,OrderItem_Cancellation_Date__c from ccrz__E_OrderItem__c where ccrz__Order__r.OrderProcessedforFSD__c = false and ccrz__Order__r.ccrz__OrderStatus__c=\'Order Submitted\' And ccrz__OrderItemStatus__c=\'Cancelled\' AND Is_Refund_Initiated__c = false and id in :orderIdLst' ;
        	System.debug('query==='+query);
        }
        else{
            query = 'Select id,ccrz__Order__c, ccrz__SubAmount__c, ccrz__Price__c, Vertex_Tax__c, ccrz__Order__r.Refund_status__c,ccrz__Order__r.BAMS_Merchant_Reference_Number__c,ccrz__OrderItemStatus__c,ccrz__Order__r.ccrz__CurrencyISOCode__c,OrderItem_Cancellation_Date__c from ccrz__E_OrderItem__c where ccrz__Order__r.OrderProcessedforFSD__c = false and ccrz__Order__r.ccrz__OrderStatus__c=\'Order Submitted\' And ccrz__OrderItemStatus__c=\'Cancelled\' AND Is_Refund_Initiated__c = false and  OrderItem_Cancellation_Date__c  >=: curDate' ;
        }
        return Database.getQueryLocator(query);
    }
 
    global void execute(Database.BatchableContext BC, List<ccrz__E_OrderItem__c> scope){               
        
        Set<Id> orderIdToProcess = new Set<Id>();
        
        List<ccrz__E_OrderItem__c> orderItemList = new List<ccrz__E_OrderItem__c>();
        List<Id> orderIdLst = new List<Id>();
        for(ccrz__E_OrderItem__c order:scope)
        {
            orderIdLst.add(order.ccrz__Order__c);
        }
        
        //logic to initiate the refund the only for Card payments
        for(ccrz__E_TransactionPayment__c transPay : [select id,name,ccrz__CCOrder__c from ccrz__E_TransactionPayment__c where ccrz__CCOrder__c in :orderIdLst and ccrz__AccountType__c='cc'])    
       {
           orderIdToProcess.add(transPay.ccrz__CCOrder__c);
       }
           
        for(ccrz__E_OrderItem__c order :scope){
            if(orderIdToProcess.contains(order.ccrz__Order__c))
            {
                orderItemList.add(order);    
            }
            
        }                                                                                               
                                                                                                       
        OSM_BAMS_BL_Operations.processRefundForCancelledOrderItems(orderItemList);        
    }

    global void finish(Database.BatchableContext BC){
        
        OSM_Integration_Log__c log = new OSM_Integration_Log__c();
        log.Service_Name__c='Scheduled:' + Label.CyberSource_ServiceName;
        log.Status__c = 'Processed';
        insert log;

    }

    global void execute(SchedulableContext SC){
        OSM_BAMS_RefundOnOrderItemCancelBatch  bjobs = new OSM_BAMS_RefundOnOrderItemCancelBatch();
        Database.executeBatch(bjobs,1);       
    }
}