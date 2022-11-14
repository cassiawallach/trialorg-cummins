/************************************************************
Name:  OSM_WS_RetryOneBMSRefundFSDCall
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is batch class for Refund FSD call Integration 
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Sharad         17/01/2019     INITIAL DEVELOPMENT          
 

*************************************************************/

global class OSM_WS_RetryOneBMSRefundFSDCall implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.Stateful{
    global Set<Id> orderId = new Set<Id>();
    global Database.QueryLocator start(Database.BatchableContext BC){
        String strStatus = 'Cancellation Pending';
        String query = 'Select id,ccrz__CCOrder__c from ccrz__E_Invoice__c where  ccrz__CCOrder__r.OrderProcessedforFSD__c  = true and ccrz__CCOrder__r.OSM_SW_Is_InterCompany_Order__c = false AND OSM_SW_Is_Refund_FSD_Done__c = false and Invoice_Type__c = \'Credit Memo\'';
        
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<ccrz__E_Invoice__c> scope){   
        
        Set<Id> setInvoiceId = new Set<Id>();
        
        for(ccrz__E_Invoice__c objInv :scope){
            setInvoiceId.add(objInv.Id);
        }
        
        List<ccrz__E_Invoice__c> lstInvoice =  new List<ccrz__E_Invoice__c>();
        
        lstInvoice = [Select Id,ccrz__CCOrder__c,(Select Id, ccrz__CCOrderItem__c,ccrz__CCOrderItem__r.IsRevokeLicenseSucess__c from ccrz__InvoiceItems__r where ccrz__Type__c = 'Item') from ccrz__E_Invoice__c where Id IN: setInvoiceId];
        
        for(ccrz__E_Invoice__c objInv : lstInvoice)
        {
            Set<Id> orderItemIdSet=new Set<Id>();
            String orderId = objInv.ccrz__CCOrder__c;
            for(ccrz__E_InvoiceItem__c invItemobj : objInv.ccrz__InvoiceItems__r)
            {
                orderItemIdSet.add(invItemobj.ccrz__CCOrderItem__c);
            }
            OSM_ReturnWrapper objRet = new OSM_ReturnWrapper();
            objRet = OSM_WS_SubmitOrderBusiness_Handler.getOrderInfo(orderId,'Cancel',orderItemIdSet,'partial cancel',true,objInv.Id);
            if(!objRet.exceptionFlag || Test.isRunningTest()) 
            {
                System.debug('Refund call is done for : '+objInv.Id);
                Set<Id> orderItemIdSet2=new Set<Id>();
                    List<ccrz__E_OrderItem__c> orderItemList2=[select id from ccrz__E_OrderItem__c where id IN:orderItemIdSet and OSM_SW_Is_OMS_Revoke_and_Cancel_Not_Done__c = false];
                    for(ccrz__E_OrderItem__c obj: orderItemList2)
                        orderItemIdSet2.add(obj.Id);
                if(orderItemIdSet2.size() > 0 )
                {
                    OSM_SW_OrderCancellationUtility.updateRecordsOnOrderItemCancellation(orderItemIdSet2, Label.OSM_Order_Cancellation);
                    List<ccrz__E_OrderItem__c> orderItemList3=[select id,ccrz__OrderItemStatus__c from ccrz__E_OrderItem__c where ccrz__Order__c =:  orderId];
                    boolean callCancelOrderProcess = true;
                    for(ccrz__E_OrderItem__c oitem : orderItemList3)
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
            }
        }
    }

    global void finish(Database.BatchableContext BC){  
        
            //OSM_SW_RetryOrderCancellationJobs bjobs1 = new OSM_SW_RetryOrderCancellationJobs();
            //database.executebatch(bjobs1,Integer.valueOf(label.OSM_OrderCancellation_Batch_Size));
            
            
        }
    
}

/*

Database.executeBatch(new OSM_WS_RetryOneBMSRefundFSDCall(),1);

*/