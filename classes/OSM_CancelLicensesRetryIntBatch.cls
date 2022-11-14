/************************************************************
Name:  OSM_CancelLicensesRetryIntBatch
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is batch class for CancelLicensesAPI Integration 
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE              DETAIL                                
1.0 -   Neha Mehta                26/12/2018     INITIAL DEVELOPMENT          
1.1 -   Karthik Raj Golakaram     08/22/2022     Changes for OMG-935

*************************************************************/

global class OSM_CancelLicensesRetryIntBatch implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.Stateful{
    
    global Set<ID> orderItemIdSet = new Set<ID>();
    global Set<Id> set_OrderItemId = new Set<Id>();
    global boolean isRevoke = false;

    global OSM_CancelLicensesRetryIntBatch(){
        // do nothing
    }
    
    global OSM_CancelLicensesRetryIntBatch(boolean isRevInt){
        isRevoke = isRevInt;
    }

    global OSM_CancelLicensesRetryIntBatch(Set<Id> set_OrderItemIdTemp){
        set_OrderItemId = set_OrderItemIdTemp;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        if(set_OrderItemId.size() > 0){
            return Database.getQueryLocator([Select ID, ccrz__Order__c, OMS_Product__c,CancelLicenseAPICalled__c From ccrz__E_OrderItem__c Where CancelLicenseAPICalled__c!=true AND IsRevokeLicenseSucess__c!=true AND OMS_Product__c=true AND (ccrz__Order__r.ccrz__OrderStatus__c=: Label.OSM_CancellationPending OR (IsCancelPending__c = true AND ccrz__OrderItemStatus__c = 'Order Submitted')) AND Id IN: set_OrderItemId]);
        }else{
            return Database.getQueryLocator([Select ID, ccrz__Order__c, OMS_Product__c,CancelLicenseAPICalled__c From ccrz__E_OrderItem__c Where CancelLicenseAPICalled__c!=true AND IsRevokeLicenseSucess__c!=true AND OMS_Product__c=true AND (ccrz__Order__r.ccrz__OrderStatus__c=: Label.OSM_CancellationPending OR (IsCancelPending__c = true AND ccrz__OrderItemStatus__c = 'Order Submitted'))]);
        }
    }
    
    global void execute(Database.BatchableContext BC, List<ccrz__E_OrderItem__c> scope) {
       // throw new OtherException('This is bad');
       Set<ID> orderItemIdSetTmp = new Set<ID>(); 
       for(ccrz__E_OrderItem__c orderItem :scope) {
            orderItemIdSet.add(orderItem.ID); 
            orderItemIdSetTmp.add(orderItem.ID);           
        }
        if(orderItemIdSetTmp.size() > 0 )
            OSM_OMS_GetTI_Batch_Helper.callGetTILicensesAPI(orderItemIdSetTmp);          
    }

    global void finish(Database.BatchableContext BC){  
    
    Set<Id> orderItemIdSetForCancel=new Set<Id>();
    //Set<Id> setOrderId= new Set<Id>();
    //Set<Id> set_PartialCancelOrder = new Set<Id>();
    List<ccrz__E_OrderItem__c> orderItemList=[Select ID, IsCancelPending__c, ccrz__Order__c,OSM_GetTI_Success__c, OMS_Product__c,CancelLicenseAPICalled__c From ccrz__E_OrderItem__c Where CancelLicenseAPICalled__c!=true AND OMS_Product__c=true AND (ccrz__Order__r.ccrz__OrderStatus__c=: Label.OSM_CancellationPending OR IsCancelPending__c = true) AND id IN:orderItemIdSet] ;
        for(ccrz__E_OrderItem__c orderItem :orderItemList) {
            if(orderItem.OSM_GetTI_Success__c) {
                orderItemIdSet.add(orderItem.ID);
               
            }            
        }
        
        if(orderItemIdSet.size() > 0 )
        {
            OSM_SW_CancelAPIBatch b=new OSM_SW_CancelAPIBatch(orderItemIdSet);
            Database.executebatch(b,1);
        }
        //OSM_CancelLicenses_ServiceHandler.callCancelLicensesAPI(orderItemIdSet);
         
         
        /*Set<Id> orderItemIdSet2=new Set<Id>();
        String orderId = '';
        for(ccrz__E_OrderItem__c obj: [select id,ccrz__Order__c from ccrz__E_OrderItem__c where id IN:orderItemIdSet and OSM_SW_Is_OMS_Revoke_and_Cancel_Not_Done__c = false and (OSM_SW_Is_Refund_FSD_Done__c=true OR ccrz__Order__r.OSM_SW_Is_FSD_Done_Or_Not_Needed__c=true)])
        {
         orderItemIdSet2.add(obj.Id);
         orderId=obj.ccrz__Order__c;
        } 
        if(orderItemIdSet2.size() > 0)
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
         }*/
        
       /* 
        //Added for MAR-1412 (Ashish)
        for(ccrz__E_OrderItem__c ordItm : [Select Id, ccrz__Order__c, CancelLicenseAPICalled__c, IsRevokeLicenseSucess__c from ccrz__E_OrderItem__c where Id IN :orderItemIdSet]){
            if((!isRevoke && !ordItm.CancelLicenseAPICalled__c && setOrderId.size() > 0) || (isRevoke && !ordItm.IsRevokeLicenseSucess__c)){
                setOrderId.remove(ordItm.ccrz__Order__c);
            }
            if(Test.isRunningTest()){
                setOrderId.add(ordItm.ccrz__Order__c);
            }
        }
        // End: changes for MAR-1412

        if(setOrderId != null && setOrderId.size() > 0) {
            List<ccrz__E_TransactionPayment__c> lstTP = new List<ccrz__E_TransactionPayment__c>();
            lstTP = [Select Id, ccrz__CCOrder__c, ccrz__CCOrder__r.OrderProcessedforFSD__c, ccrz__CCOrder__r.Is_OMS_Revoke_and_Cancel_Not_Done_Count__c, ccrz__CCOrder__r.ccrz__OrderStatus__c, ccrz__AccountType__c from ccrz__E_TransactionPayment__c where ccrz__CCOrder__c IN: setOrderId];
            System.debug('TP obj: '+lstTP);
            
            Set<Id> orderIdForOther = new Set<Id>();
            Set<Id> orderIdForDistributedPO = new Set<Id>();
            Set<Id> set_OrdrIdPartialCan = new Set<Id>();
            
            for(ccrz__E_TransactionPayment__c objTp : lstTP) {
                System.debug('objTp.ccrz__CCOrder__r.Is_OMS_Revoke_and_Cancel_Not_Done_Count__c____: '+objTp.ccrz__CCOrder__r.Is_OMS_Revoke_and_Cancel_Not_Done_Count__c);
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
            }*/
            
            /*
            * Code COmmneted by Ashish for MAR-1179
            * Created only 1 Queueabe job rather than 3 different Queueable
            
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
                System.enqueueJob(new OSM_SW_QueuePartialOrderCacncellation(set_OrdrIdPartialCan, true));
            }
            */
            OSM_Integration_Log__c log = new OSM_Integration_Log__c();
            log.Service_Name__c='OSM_CancelLicensesRetryIntBatch';
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
            /*if(set_OrdrIdPartialCan.size() > 0 || orderIdForOther.size() > 0 || orderIdForDistributedPO.size() > 0){
                System.enqueueJob(new OSM_SW_CancelRevokeOrderQueueable(orderIdForOther, set_OrdrIdPartialCan, orderIdForDistributedPO, true));
            }*/
       
     }   
}