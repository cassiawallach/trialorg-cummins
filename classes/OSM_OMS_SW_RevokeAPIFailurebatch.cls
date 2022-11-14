/************************************************************
Name:  OSM_OMS_SW_RevokeAPIFailurebatch
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This batch class will be used to initiate the RevokedAPIFailure records and pass to same API
============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Neha Sharma        22nd Feb 2019     INITIAL DEVELOPMENT          
2.0 -   Ashish Goyal       15th Sep 2020     Updated for FW release

*************************************************************/
global class OSM_OMS_SW_RevokeAPIFailurebatch implements Database.Batchable<sObject>,Database.AllowsCallouts{
    global Set<Id> set_OrderItemId = new Set<Id>();
    
    global OSM_OMS_SW_RevokeAPIFailurebatch(){
        // do nothing
    }
    
    global OSM_OMS_SW_RevokeAPIFailurebatch(Set<Id> set_OrderItemIdTemp){
        set_OrderItemId = set_OrderItemIdTemp;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        if(set_OrderItemId.size() > 0){
            return Database.getQueryLocator([SELECT ID, IsCancelPending__c, Instance_ID_Count__c,ccrz__Order__c From ccrz__E_OrderItem__c Where (ccrz__Order__r.ccrz__OrderStatus__c='Cancellation Pending' OR (IsCancelPending__c = true AND ccrz__OrderItemStatus__c = 'Order Submitted')) AND (Tool_Instance_Count__c > 0 OR Basic_Tool_Instance_Key_Count__c > 0) AND Id IN: set_OrderItemId]);
        }else{
            return Database.getQueryLocator([SELECT ID, IsCancelPending__c, Instance_ID_Count__c,ccrz__Order__c From ccrz__E_OrderItem__c Where ((ccrz__Order__r.ccrz__OrderStatus__c='Cancellation Pending' AND ccrz__OrderItemStatus__c!='Cancelled') OR (IsCancelPending__c = true AND (ccrz__OrderItemStatus__c = 'Order Submitted' or ccrz__OrderItemStatus__c='Cancellation Pending'))) AND (Tool_Instance_Count__c > 0 OR Basic_Tool_Instance_Key_Count__c > 0)]);
        }
    }
    
    global void execute(Database.BatchableContext BC, List<ccrz__E_OrderItem__c> scope){
        Set<Id> orderItemIdSet=new Set<Id>();
        Set<Id> orderItemIdSet2=new Set<Id>();
        String orderId = '';
        //Set<Id> setOrderId= new Set<Id>();
        //Set<Id> set_PartialCancelOrder = new Set<Id>();
        
        for(ccrz__E_OrderItem__c orderItem :scope) {
            orderItemIdSet.add(orderItem.id);
            /*setOrderId.add(orderItem.ccrz__Order__c);
            if(orderItem.IsCancelPending__c){
                set_PartialCancelOrder.add(orderItem.ccrz__Order__c);
            }*/
        }
        
        OSM_OMS_SW_RevokeAPIUtility.revokeAPIcall(orderItemIdSet);
        //MAR-2175 Start
        
        //List<ccrz__E_OrderItem__c> orderItemList2=[select id,ccrz__Order__c from ccrz__E_OrderItem__c where id IN:orderItemIdSet and OSM_SW_Is_OMS_Revoke_and_Cancel_Not_Done__c = false and (OSM_SW_Is_Refund_FSD_Done__c=true OR ccrz__Order__r.OSM_SW_Is_FSD_Done_Or_Not_Needed__c=true)];
        for(ccrz__E_OrderItem__c obj: [select id,ccrz__Order__c from ccrz__E_OrderItem__c where id IN:orderItemIdSet and OSM_SW_Is_OMS_Revoke_and_Cancel_Not_Done__c = false and (OSM_SW_Is_Refund_FSD_Done__c=true OR ccrz__Order__r.OSM_SW_Is_FSD_Done_Or_Not_Needed__c=true)])
        {
         orderItemIdSet2.add(obj.Id);
         orderId=obj.ccrz__Order__c;
        } 
         
        if(orderItemIdSet2.size() > 0 )
        {
             OSM_SW_OrderCancellationUtility.updateRecordsOnOrderItemCancellation(orderItemIdSet2, Label.OSM_Order_Cancellation);
             //List<ccrz__E_OrderItem__c> orderItemList3=[select id,ccrz__OrderItemStatus__c from ccrz__E_OrderItem__c where ccrz__Order__c =:  orderId];
             boolean callCancelOrderProcess = true;
             for(ccrz__E_OrderItem__c oitem : [select id,ccrz__OrderItemStatus__c from ccrz__E_OrderItem__c where ccrz__Order__c =:  orderId])
             {
                if(oitem.ccrz__OrderItemStatus__c != 'Cancelled')
                  callCancelOrderProcess = false;
             }
                    
             if(callCancelOrderProcess)
             {
                 Set<Id> setItemId = new Set<Id>();
                 setItemId.add(orderId);
                 CallCancleOrderProcessQuable objQua = new CallCancleOrderProcessQuable();
                 objQua.orderId = orderId;
                 ID jobID = System.enqueueJob(objQua);
                 System.debug('jobID'+jobID);
             }
         }
         
        //MAR-2175 End 
        //commneting this below earlier code as part of MAR-2175 story and adding above fresh conditions to call order item cancellation and Order cancellation
        /*//Added for MAR-1412 (Ashish)
        for(ccrz__E_OrderItem__c ordItm : [Select Id, ccrz__Order__c, IsRevokeLicenseSucess__c,ccrz__CCOrder__r.OrderProcessedforFSD__c from ccrz__E_OrderItem__c where Id IN :orderItemIdList]){
            if(!ordItm.IsRevokeLicenseSucess__c && setOrderId.size() > 0) {
                setOrderId.remove(ordItm.ccrz__Order__c);
            }
            if(Test.isRunningTest()){
                setOrderId.add(ordItm.ccrz__Order__c);
            }
        }
        // End: changes for MAR-1412
        
        if(setOrderId != null && setOrderId.size() > 0 ) {
            List<ccrz__E_TransactionPayment__c> lstTP = new List<ccrz__E_TransactionPayment__c>();
            Set<Id> orderIdForOther = new Set<Id>();
            Set<Id> orderIdForDistributedPO = new Set<Id>();
            Set<Id> set_OrdrIdPartialCan = new Set<Id>();
            
            lstTP = [Select Id, ccrz__CCOrder__c, ccrz__CCOrder__r.OrderProcessedforFSD__c, ccrz__CCOrder__r.Is_OMS_Revoke_and_Cancel_Not_Done_Count__c, ccrz__CCOrder__r.ccrz__OrderStatus__c, ccrz__AccountType__c from ccrz__E_TransactionPayment__c where ccrz__CCOrder__c IN: setOrderId];
            System.debug('TP obj: '+lstTP);
            
            for(ccrz__E_TransactionPayment__c objTp : lstTP) {
                if(objTp.ccrz__CCOrder__r.Is_OMS_Revoke_and_Cancel_Not_Done_Count__c == 0 || set_PartialCancelOrder.contains(objTp.ccrz__CCOrder__c)) {
                    if(objTp.ccrz__AccountType__c == 'cc' && (!set_PartialCancelOrder.contains(objTp.ccrz__CCOrder__c) || 
                            (set_PartialCancelOrder.contains(objTp.ccrz__CCOrder__c) && objTp.ccrz__CCOrder__r.ccrz__OrderStatus__c == Label.OSM_CancellationPending))) {
                        orderIdForOther.add(objTp.ccrz__CCOrder__c);
                    }
                    else if(objTp.ccrz__AccountType__c == 'cc' && set_PartialCancelOrder.contains(objTp.ccrz__CCOrder__c) && objTp.ccrz__CCOrder__r.ccrz__OrderStatus__c == 'Order Submitted') {
                        set_OrdrIdPartialCan.add(objTp.ccrz__CCOrder__c);
                    }
                    if(objTp.ccrz__AccountType__c == 'po') {
                        System.debug('objTp.ccrz__CCOrder__r.OrderProcessedforFSD__c: '+objTp.ccrz__CCOrder__r.OrderProcessedforFSD__c);
                        if(objTp.ccrz__CCOrder__r.OrderProcessedforFSD__c) {
                            orderIdForDistributedPO.add(objTp.ccrz__CCOrder__c);
                        }
                        else {
                            orderIdForOther.add(objTp.ccrz__CCOrder__c);
                        }
                    }
                }
            }
            
            if(orderIdForDistributedPO != null && orderIdForDistributedPO.size() > 0) {
                for(Id key: orderIdForDistributedPO) {
                    System.enqueueJob(new OSM_SW_QueueSubmitOrder(key)); 
                }
            }
            System.debug('orderIdForOther: '+orderIdForOther);
            if(orderIdForOther != null && orderIdForOther.size() > 0) {
                System.enqueueJob(new OSM_SW_QueueOrderUpdateonCancel(orderIdForOther));
            }
            if(set_OrdrIdPartialCan.size() > 0){
                System.enqueueJob(new OSM_SW_QueuePartialOrderCacncellation(set_OrdrIdPartialCan, false));
            }
        }*/   
    }
    
    global void finish(Database.BatchableContext BC) {
        OSM_Integration_Log__c log = new OSM_Integration_Log__c();
        log.Service_Name__c='OSM_OMS_SW_RevokeAPIFailurebatch';
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
        Database.executeBatch(new OSM_CancelLicensesRetryIntBatch(true), 1);
    }
}