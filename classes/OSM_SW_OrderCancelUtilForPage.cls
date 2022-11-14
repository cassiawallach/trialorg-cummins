/********
* Date                   Updated By                 Changes Made
* 02-03-2021            Sharad Sahu                 Created Class Initially
* 05-16-2022            Karthik Raj Golakaram       Jira_Mp_858 changes
*/
public without sharing class OSM_SW_OrderCancelUtilForPage
{
    
    public static void callFSDAPIFromBatch(Id orderId)
    {
        
        OSM_ReturnWrapper objRet = new OSM_ReturnWrapper();
        objRet = OSM_WS_SubmitOrderBusiness_Handler.getOrderInfo(orderId,'Cancel',null,null,false,null);
        
        
        try{
            if(!objRet.exceptionFlag)
            {
                
                updateIntercompanyOrderCancelSucess(orderId);
                updateSubsc(orderId);
            }
            else
            {
                
                updateIntercompanyOrder(orderId);
                
            }
        }
        Catch(Exception ex)
        {
            system.debug('exception in updating records: '+ex);
        }
    }
    
    public static void updateIntercompanyOrder(Id orderIdOrignal)
    {
        
        List<ccrz__E_Order__c> objOrder = new List<ccrz__E_Order__c>();
        objOrder = [Select Id,ccrz__OrderStatus__c,OSM_SW_Cancel_Reason__c,OSM_SW_Cancel_Comment__c,Original_Sales_Order__r.OSM_SW_Cancel_Reason__c,Original_Sales_Order__r.OSM_SW_Cancel_Comment__c from ccrz__E_Order__c where Original_Sales_Order__c =: orderIdOrignal];
        if(objOrder != null && objOrder.size() > 0 )
        {
            for(ccrz__E_Order__c ordr : objOrder)
            {
                ordr.ccrz__OrderStatus__c = Label.OSM_CancellationPending;
                ordr.OSM_SW_Cancel_Reason__c = ordr.Original_Sales_Order__r.OSM_SW_Cancel_Reason__c;
                ordr.OSM_SW_Cancel_Comment__c = ordr.Original_Sales_Order__r.OSM_SW_Cancel_Comment__c;
            }
            
            update objOrder;
        }
        
    }
    
    public static void updateIntercompanyOrderCancelSucess(Id orderIdOrignal)
    {
        boolean toPerformUpdate = false;// Jira_Mp_858
        List<ccrz__E_Order__c> objOrder = new List<ccrz__E_Order__c>();
        objOrder = [Select Id,ccrz__OrderStatus__c,BMS_Order_reference_number_Refund__c,Original_Sales_Order__r.BMS_Order_reference_number_Refund__c,BMS_OrderRefNumber__c,OSM_SW_Refund_Order_Source_Type__c,Order_Source_Type__c,Original_Sales_Order__r.OSM_SW_Refund_Order_Source_Type__c,Original_Sales_Order__r.Order_Source_Type__c,Original_Sales_Order__r.BMS_OrderRefNumber__c from ccrz__E_Order__c where Original_Sales_Order__c =: orderIdOrignal];
        if(objOrder != null && objOrder.size() > 0 )
        {
            Set<Id> setOrdrId = new Set<Id>();
            for(ccrz__E_Order__c ordr : objOrder)
            {
                //ordr.ccrz__OrderStatus__c =  Label.OSM_Cancelled ;
                ordr.BMS_OrderRefNumber__c = ordr.Original_Sales_Order__r.BMS_OrderRefNumber__c;
                ordr.BMS_Order_reference_number_Refund__c = ordr.Original_Sales_Order__r.BMS_Order_reference_number_Refund__c;
                ordr.Order_Source_Type__c = ordr.Original_Sales_Order__r.Order_Source_Type__c;
                ordr.OSM_SW_Refund_Order_Source_Type__c = ordr.Original_Sales_Order__r.OSM_SW_Refund_Order_Source_Type__c;
                setOrdrId.add(ordr.Id);
            }
            
            update objOrder;
            
            List<ccrz__E_Invoice__c> invoicelst = new List<ccrz__E_Invoice__c>();
            
            invoicelst = [Select Id,BMS_InvoiceNumber__c, BMS_PONumber__c, Original_Sales_Order_Invoice_Number__c ,Original_Sales_Order_Invoice_Number__r.BMS_InvoiceNumber__c, Original_Sales_Order_Invoice_Number__r.BMS_PONumber__c from ccrz__E_Invoice__c where ccrz__CCOrder__c IN: setOrdrId];
            
            if(invoicelst != null && invoicelst.size() > 0)
            {
                for(ccrz__E_Invoice__c objInv : invoicelst)
                {
                    if(objInv.Original_Sales_Order_Invoice_Number__c != null)
                    {   
                        //jira_Mp_858
                        if(objInv.BMS_InvoiceNumber__c != objInv.Original_Sales_Order_Invoice_Number__r.BMS_InvoiceNumber__c) {
                            objInv.BMS_InvoiceNumber__c = objInv.Original_Sales_Order_Invoice_Number__r.BMS_InvoiceNumber__c;
                            toPerformUpdate = true;
                        }

                        if (objInv.BMS_PONumber__c != objInv.Original_Sales_Order_Invoice_Number__r.BMS_PONumber__c) {
                            objInv.BMS_PONumber__c = objInv.Original_Sales_Order_Invoice_Number__r.BMS_PONumber__c;
                            toPerformUpdate = true;
                        }
                        //Jira_Mp_858
                    }
                }
                if(toPerformUpdate) { //Jira_Mp_858- Added if condidtion to perform update
                    update invoicelst;
                }
            }  
        }
    }
    
    
    
    
    
    public static void updateSubsc(Id orderId)
    {
        Set<Id> orderIdSet = new Set<Id>();
        orderIdSet.add(orderId);
        OSM_SW_OrderCancellationUtility.updateRecordsOnOrderCancellation(orderIdSet);
        if(!System.isBatch())
        {
            OSM_SW_OrderTriggerHandlerUtility.getOrderCancel(orderIdSet);
        }
        updateTP(orderId);
        
        
    }
    
    public static void updateTP(Id orderId)
    {
        
        
        if(System.isBatch())
        {   
            List<ccrz__E_TransactionPayment__c> lstTP2 = new List<ccrz__E_TransactionPayment__c>();
            lstTP2 = [Select Id,ccrz__InvoiceAppliedTo__c,OSM_Order_Cancellation_Failure__c,Bolt_Credit_Memo_Call_Status__c,Transaction_Status__c,Bolt_JE_Reversal_Call_Status__c from ccrz__E_TransactionPayment__c where ccrz__CCOrder__c =: orderId];
            
            List<ccrz__E_OrderItem__c> ordrItem = new List<ccrz__E_OrderItem__c>();
            ordrItem = [Select Id,ccrz__Product__r.Group_Name__c from ccrz__E_OrderItem__c where ccrz__Order__c =:  orderId];
            
            boolean isDaCall = false;
            /*
if(ordrItem != null && ordrItem.size() > 0)
{
for(ccrz__E_OrderItem__c objOI : ordrItem)
{
if(objOI.ccrz__Product__r.Group_Name__c == Label.OSM_GroupName_DA)
{
isDaCall = true;
}
}
}
*/
            isDaCall = true;
            if(isDaCall)
            {
                if(lstTP2 != null && lstTP2.size() > 0 )
                {
                    for(ccrz__E_TransactionPayment__c objTP : lstTP2)
                    {
                        objTP.OSM_Order_Cancellation_Failure__c = true;
                    }
                    
                    update lstTP2;
                }
            }
            
        }
        
        List<ccrz__E_Order__c> objOrder = new List<ccrz__E_Order__c>();
        
        
        
        objOrder = [Select Id,ccrz__OrderStatus__c from ccrz__E_Order__c where Original_Sales_Order__c =: orderId];
        Set<Id> setOrdrId = new Set<Id>();
        if(objOrder != null && objOrder.size() > 0 )
        {
            for(ccrz__E_Order__c ordr : objOrder)
            {
                setOrdrId.add(ordr.Id);
            }
            
            List<ccrz__E_TransactionPayment__c> lstTP = new List<ccrz__E_TransactionPayment__c>();
            
            lstTP = [Select Id,ccrz__InvoiceAppliedTo__c,OSM_Order_Cancellation_Failure__c,Bolt_Credit_Memo_Call_Status__c,Transaction_Status__c,Bolt_JE_Reversal_Call_Status__c  from ccrz__E_TransactionPayment__c where ccrz__CCOrder__c IN: setOrdrId];
            
            if(lstTP != null && lstTP.size() > 0 )
            {
                for(ccrz__E_TransactionPayment__c objTP : lstTP)
                {
                    /*if(objTP.Bolt_Credit_Memo_Call_Status__c !='Success')
{
objTP.Bolt_Credit_Memo_Call_Status__c = Label.OSM_ARInvoiceRecurring_Status;
}
if(objTP.Bolt_JE_Reversal_Call_Status__c !='Success')
{
objTP.Bolt_JE_Reversal_Call_Status__c  = Label.OSM_ARInvoiceRecurring_Status;
}*/
                    objTP.Transaction_Status__c  = Label.OSM_Order_Cancel_Success ;
                }
                
                update lstTP;
                
                if(!System.isBatch())
                {
                    List<Id> lstInvoiceId = new List<Id>();
                    Map<Id,Id> mapCTPInvcid = new Map<Id,Id>();
                    
                    for(ccrz__E_TransactionPayment__c objTP2 : lstTP)
                    {
                        if(objTP2.Transaction_Status__c == Label.OSM_Order_Cancel_Success)
                        {
                            lstInvoiceId.add(objTP2.ccrz__InvoiceAppliedTo__c);
                            mapCTPInvcid.put(objTP2.ccrz__InvoiceAppliedTo__c, objTP2.Id);
                        }
                        
                    } 
                    
                    if(lstInvoiceId != null && lstInvoiceId.size() > 0)
                    {
                        List<ccrz__E_Invoice__c> invoiceDetailsList=[Select id,OSM_SW_Is_Bolt_PO__c,ccrz__BillTo__r.Is_Training_Account__c,ccrz__BillTo__r.Is_OEM_Acount__c,ccrz__BillTo__r.Is_Internal_Account__c, ccrz__BillTo__r.BOLT_Account_Number__c,ccrz__BillTo__r.BMS_Customer_ID__c from ccrz__E_Invoice__c where id in:lstInvoiceId];
                        String state = 'Order Cancel';
                        for(ccrz__E_Invoice__c invoice:invoiceDetailsList){
                            if(!invoice.ccrz__BillTo__r.Is_Training_Account__c && !invoice.ccrz__BillTo__r.Is_OEM_Acount__c && !invoice.ccrz__BillTo__r.Is_Internal_Account__c)
                            {
                                //OSM_BOLT_SW_BusinessLayerUtility.getARInvoiceServices(lstInvoiceId, mapCTPInvcid, state);
                                //OSM_BOLT_SW_BusinessLayerUtility.getJournalEntryServices(lstInvoiceId, mapCTPInvcid, state);
                            }
                        }
                    }
                    
                    
                    
                }
                
            }
            
        }
        
        
    }
    
    
    public static void updateOrderCancel(Set<Id> orderIdSet)
    {
        Set<Id> cancelledOrderId = new Set<Id>();
        Set<Id> cancelOrderItemId = new Set<Id>();
        if(orderIdSet != null && orderIdSet.size() > 0 )
        {
            List<ccrz__E_Order__c> lstOrderUpdate = new List<ccrz__E_Order__c>();
            List<ccrz__E_OrderItem__c> lstOrderItemUpdate = new List<ccrz__E_OrderItem__c>();
            List<ccrz__E_Order__c> lstOrder = new List<ccrz__E_Order__c>();
            lstOrder = [Select Id, FW_Product_Count__c, ccrz__OrderStatus__c, OSM_SW_Is_FSD_Done_Or_Not_Needed__c, OSM_SW_Is_DA_Update_Done_Or_Not_Needed__c,OSM_SW_Is_IAM_Call_Done_Or_Not_Needed__c, Is_OMS_Revoke_and_Cancel_Not_Done_Count__c, OSM_SW_Order_Item_Count__c,OSM_SW_Renew_Order_Item_Count__c from ccrz__E_Order__c where   ccrz__OrderStatus__c =: Label.OSM_CancellationPending and Id IN: orderIdSet];
            
            for(ccrz__E_Order__c objOr : lstOrder)
            {
                if(objOr.OSM_SW_Renew_Order_Item_Count__c > 0 && objOr.OSM_SW_Renew_Order_Item_Count__c == objOr.OSM_SW_Order_Item_Count__c)
                {
                    objOr.ccrz__OrderStatus__c = Label.OSM_Cancelled;
                    lstOrderUpdate.add(objOr);
                    cancelledOrderId.add(objOr.Id);
                }
                else if (objOr.OSM_SW_Is_FSD_Done_Or_Not_Needed__c == true && objOr.OSM_SW_Is_DA_Update_Done_Or_Not_Needed__c == true && objOr.OSM_SW_Is_IAM_Call_Done_Or_Not_Needed__c == true && objOr.Is_OMS_Revoke_and_Cancel_Not_Done_Count__c == 0)
                {
                    objOr.ccrz__OrderStatus__c = Label.OSM_Cancelled;
                    lstOrderUpdate.add(objOr);
                    cancelledOrderId.add(objOr.Id);
                }
                
                //Added by Ashish for the FW cancellation fixes 
                else if(objOr.FW_Product_Count__c > 0){ 
                    objOr.ccrz__OrderStatus__c = Label.OSM_Cancelled;   
                    lstOrderUpdate.add(objOr);  
                    cancelledOrderId.add(objOr.Id); 
                }                
            }
            
            if(cancelledOrderId != null && cancelledOrderId.size() > 0 )
            {
                List<ccrz__E_OrderItem__c> lstOrder2 = new List<ccrz__E_OrderItem__c>();
                
                lstOrder2 = [Select Id,ccrz__Order__r.OrderProcessedforFSD__c, isRenew__c from ccrz__E_OrderItem__c where ccrz__Order__c IN: cancelledOrderId];
                for(ccrz__E_OrderItem__c objItem : lstOrder2){
                    objItem.ccrz__OrderItemStatus__c = Label.OSM_Cancelled;
                    if( objItem.ccrz__Order__r.OrderProcessedforFSD__c == true && objItem.isRenew__c == true){
                        lstOrderItemUpdate.add(objItem);
                    }
                    cancelOrderItemId.add(objItem.Id);
                    
                }
            }
            
            
            if(cancelledOrderId != null && cancelledOrderId.size() > 0 )
            {
                List<ccrz__E_Order__c> objOrder = new List<ccrz__E_Order__c>(); 
                
                objOrder = [Select Id,FW_Product_Count__c,OSM_SW_Order_Item_Count__c,ccrz__OrderStatus__c from ccrz__E_Order__c where Original_Sales_Order__c IN: cancelledOrderId];
                if(objOrder != null && objOrder.size() > 0 )
                {
                    for(ccrz__E_Order__c ordr : objOrder)
                    {
                        ordr.ccrz__OrderStatus__c = Label.OSM_Cancelled;
                        lstOrderUpdate.add(ordr);
                    }
                }
                
                
                
                
                
                
                
            }
            
            if(lstOrderUpdate != null && lstOrderUpdate.size() > 0)
                update lstOrderUpdate;
            
            if(lstOrderItemUpdate!=null && lstOrderItemUpdate.size()>0)
                update lstOrderItemUpdate;                              
            
            
            if(cancelOrderItemId != null && cancelOrderItemId.size() > 0)
                updateIAMRecord(cancelOrderItemId);
            
            
            for(ccrz__E_Order__c ordr : lstOrderUpdate){
                if(ordr.OSM_SW_Order_Item_Count__c == ordr.FW_Product_Count__c || Test.IsRunningTest()){
                    /*
ccrz__E_TransactionPayment__c transPayment = new ccrz__E_TransactionPayment__c();
transPayment= [Select id, Transaction_Status__c from ccrz__E_TransactionPayment__c where ccrz__CCOrder__c=:ordr.id]; 
transPayment.Transaction_Status__c ='OrderItem Cancel Success';
Update transPayment;
*/
                    
                    OSM_Integration_Log__c log = new OSM_Integration_Log__c();
                    OSM_SW_LoggingContext.integrationLog = log;
                    log.Service_Name__c = label.OSM_Order_Cancellation;
                    log.Response__c = label.OSM_Order_Cancellation_Message;
                    log.Source__c = 'FluidWatch';
                    log.Target__c = 'FluidWatch'; 
                    log.Status__c = label.OSM_Subs_Cancellation_Success;
                    log.Logged_In_User__c = userinfo.getUserId();
                    system.debug('log'+log);
                    OSM_SW_LoggingContext.saveIntegrationLog(log);  
                }
            }
            
            List<Id> lstOrderId = new List<Id>();
            if(lstOrderUpdate.size() > 0)
            {
                for(ccrz__E_Order__c objOrdr : lstOrderUpdate)
                {
                    lstOrderId.add(objOrdr.Id);
                }
                
                List<ccrz__E_Invoice__c> lstInv = new List<ccrz__E_Invoice__c>();
                for(ccrz__E_Invoice__c inv : [Select Id,CreditMemo_Number__c, ccrz__CCOrder__r.OSM_SW_Order_Item_Count__c, ccrz__CCOrder__r.FW_Product_Count__c from ccrz__E_Invoice__c where ccrz__CCOrder__c IN: lstOrderId AND IsCredited__c = false]){
                    if(inv.ccrz__CCOrder__r.OSM_SW_Order_Item_Count__c != inv.ccrz__CCOrder__r.FW_Product_Count__c){
                        lstInv.add(inv);
                    }
                }
                
                if(lstInv.size() > 0)
                    system.debug('===111 Before making Credit memo method call=='+lstInv);
                {   Map<Id,boolean> OrdCredDetail = new Map<Id,boolean>();
                 Set<Id> lstOrdId = new Set<Id>();
                 Set<Id> lstOrdId2 = new Set<Id>();
                 for(ccrz__E_Invoice__c objInv : lstInv)
                 {
                     if(objInv.CreditMemo_Number__c!='')
                     {
                         lstOrdId.add(objInv.ccrz__CCOrder__c);
                     }
                     lstOrdId2.add(objInv.ccrz__CCOrder__c);
                 }
                 
                 if(lstOrdId.size()>0){
                     if(lstOrdId2.size()>0)
                         lstOrdId2.removeAll(lstOrdId);
                 }
                 List<Id> lstInvId = new List<Id>();
                 system.debug('===1111 Before making Credit memo method call=='+lstOrdId2);
                 if(lstOrdId2.size()>0){    
                     List<ccrz__E_Invoice__c> Invrec =[select id from ccrz__E_Invoice__c where ccrz__CCOrder__c IN: lstOrdId2 ];                    
                     system.debug('===Before making Credit memo method call==');
                     if(Invrec.size() > 0 && Invrec.size() != null)
                     {   system.debug('===333 Before making Credit memo method call=='+Invrec);
                      for(ccrz__E_Invoice__c objInv : Invrec)
                      {
                          lstInvId.add(objInv.Id);
                      }
                      
                      //OSM_Create_CreditMemo.createCreditMemo(lstInvId,Null);
                     }
                 }
                }
            }
            
        }
        
    }
    public static void updateOrderItemCancel(Set<Id> orderIdSet)
    {
        Set<Id> cancelledOrderId = new Set<Id>();
        if(orderIdSet != null && orderIdSet.size() > 0 )
        {
            List<ccrz__E_OrderItem__c> lstOrderUpdate = new List<ccrz__E_OrderItem__c>();
            List<ccrz__E_OrderItem__c> lstOrder = new List<ccrz__E_OrderItem__c>();
            Set<Id> cancelOrderItemId = new Set<Id>();
            //lstOrder = [Select Id, ccrz__OrderStatus__c, OSM_SW_Is_IAM_Call_Done_Or_Not_Needed__c,OSM_SW_Is_FSD_Done_Or_Not_Needed__c, OSM_SW_Is_DA_Update_Done_Or_Not_Needed__c, Is_OMS_Revoke_and_Cancel_Not_Done_Count__c, OSM_SW_Order_Item_Count__c,OSM_SW_Renew_Order_Item_Count__c from ccrz__E_Order__c where   ccrz__OrderStatus__c =: Label.OSM_CancellationPending and Id IN: orderIdSet];
            List<ccrz__E_OrderItem__c> lstOrderItem = new List<ccrz__E_OrderItem__c>();
            lstOrderItem = [Select Id,isRenew__c, ccrz__Order__r.ccrz__OrderStatus__c,ccrz__Order__r.OSM_SW_Is_IAM_Call_Done_Or_Not_Needed__c,ccrz__Order__c,ccrz__OrderItemStatus__c,ccrz__Order__r.Is_OMS_Revoke_and_Cancel_Not_Done_Count__c,ccrz__Order__r.OSM_SW_Renew_Order_Item_Count__c,ccrz__Order__r.OSM_SW_Order_Item_Count__c,ccrz__Order__r.OSM_SW_Is_DA_Update_Done_Or_Not_Needed__c,ccrz__Order__r.OSM_SW_Is_FSD_Done_Or_Not_Needed__c  from ccrz__E_OrderItem__c where Id IN: orderIdSet];
            system.debug('lstOrderItem-->>'+lstOrderItem);
            for(ccrz__E_OrderItem__c objOr : lstOrderItem)
            {
                if(objOr.ccrz__Order__r.OSM_SW_Renew_Order_Item_Count__c > 0 && objOr.ccrz__Order__r.OSM_SW_Renew_Order_Item_Count__c == objOr.ccrz__Order__r.OSM_SW_Order_Item_Count__c)
                {
                    objOr.ccrz__OrderItemStatus__c = Label.OSM_Cancelled;
                    lstOrderUpdate.add(objOr);
                    cancelledOrderId.add(objOr.Id);
                    cancelOrderItemId.add(objOr.Id);
                    
                }
                else if (objOr.ccrz__Order__r.OSM_SW_Is_IAM_Call_Done_Or_Not_Needed__c == true &&  objOr.ccrz__Order__r.Is_OMS_Revoke_and_Cancel_Not_Done_Count__c == 0)
                {
                    objOr.ccrz__OrderItemStatus__c = Label.OSM_Cancelled;
                    lstOrderUpdate.add(objOr);
                    cancelledOrderId.add(objOr.Id);
                    cancelOrderItemId.add(objOr.Id);
                }
                           
                
            }
            
            /*if(cancelledOrderId != null && cancelledOrderId.size() > 0 )
{
List<ccrz__E_OrderItem__c> objOrder = new List<ccrz__E_OrderItem__c>();
objOrder = [Select Id,ccrz__OrderStatus__c from ccrz__E_Order__c where Original_Sales_Order__c IN: cancelledOrderId];
if(objOrder != null && objOrder.size() > 0 )
{
for(ccrz__E_Order__c ordr : objOrder)
{
ordr.ccrz__OrderStatus__c = Label.OSM_Cancelled;
lstOrderUpdate.add(ordr);
}
}
}*/
            
            if(lstOrderUpdate != null && lstOrderUpdate.size() > 0)
                update lstOrderUpdate;
            
            
            if(cancelOrderItemId != null && cancelOrderItemId.size() > 0)
                updateIAMRecord(cancelOrderItemId);
            
            
            List<Id> lstOrderId = new List<Id>();
            if(lstOrderUpdate.size() > 0)
            {
                for(ccrz__E_OrderItem__c objOrdr : lstOrderUpdate)
                {
                    lstOrderId.add(objOrdr.ccrz__Order__c);
                }
                
                List<ccrz__E_Invoice__c> lstInv = new List<ccrz__E_Invoice__c>();
                lstInv = [Select Id from ccrz__E_Invoice__c where ccrz__CCOrder__c IN: lstOrderId];
                
                if(lstInv.size() > 0)
                {
                    List<Id> lstInvId = new List<Id>();
                    for(ccrz__E_Invoice__c objInv : lstInv)
                    {
                        lstInvId.add(objInv.Id);
                    }
                    
                    OSM_Create_CreditMemo.createCreditMemo(lstInvId,lstOrderItem);
                }
            }
            
        }
        
    } 
    
    public static void updateIAMRecord(Set<Id> ItemIds)
    {
        
        List<ccrz__E_OrderItem__c> lstItem = new List<ccrz__E_OrderItem__c>();
        Id accountId;
        Map<Id,ccrz__E_OrderItem__c> mapProductOrderItem = new Map<Id,ccrz__E_OrderItem__c>();
        lstItem = [Select Id,ccrz__Order__r.ccrz__Account__c, ccrz__Product__c, OSM_SW_Cancel_Comment__c, OSM_SW_Cancel_Reason__c from ccrz__E_OrderItem__c where Id IN: ItemIds];
        for(ccrz__E_OrderItem__c objItem : lstItem)
        {
            mapProductOrderItem.put(objItem.ccrz__Product__c,objItem);
            accountId = objItem.ccrz__Order__r.ccrz__Account__c;
        }
        
        List<ccrz__E_Subscription__c> lstSubsc = new List<ccrz__E_Subscription__c>();
        lstSubsc = [Select Id,ccrz__SubscriptionProduct__c from ccrz__E_Subscription__c where ccrz__SubscriptionProduct__c IN: mapProductOrderItem.keySet() and ccrz__Account__c =: accountId and ccrz__SubscriptionStatus__c !=: Label.OSM_Subscription_Status_Renew ORDER BY LastModifiedDate DESC];
        
        System.debug(mapProductOrderItem);
        System.debug(lstSubsc);
        
        List<Id> lstSubId = new List<Id>();
        Map<Id,ccrz__E_OrderItem__c> mapSubscIdOrderItem = new Map<Id,ccrz__E_OrderItem__c>();
        Set<Id> productId = new Set<Id>();
        for(ccrz__E_Subscription__c subObj : lstSubsc)
        {
            lstSubId.add(subObj.Id);
            if(mapProductOrderItem.containsKey(subObj.ccrz__SubscriptionProduct__c) && !productId.contains(subObj.ccrz__SubscriptionProduct__c))
            {
                mapSubscIdOrderItem.put(subObj.Id,mapProductOrderItem.get(subObj.ccrz__SubscriptionProduct__c));
                productId.add(subObj.ccrz__SubscriptionProduct__c);
                
            }
        }
        System.debug(mapSubscIdOrderItem);
        
        List<OSM_Subscription_Account_Provision__c> lstSubspProvis = new List<OSM_Subscription_Account_Provision__c>();
        
        lstSubspProvis = [Select Id, Account_Features_Access__c,CC_Subscription__c from OSM_Subscription_Account_Provision__c where CC_Subscription__c IN: lstSubId and Account_Features_Access__r.IAM_Status__c = 'Inactive' and Account_Features_Access__r.IAM_Source__c = 'Marketplace'];
        
        System.debug(lstSubspProvis);
        List<IAM_Application__c> lstIAMAccessRecToUpdate = new List<IAM_Application__c>();
        
        Set<Id> setOfId = new Set<Id>();
        for(OSM_Subscription_Account_Provision__c provRec: lstSubspProvis)
        {
            if(mapSubscIdOrderItem.containsKey(provRec.CC_Subscription__c) && !setOfId.contains(provRec.Account_Features_Access__c))
            {
                IAM_Application__c accessRecOj = new IAM_Application__c();
                accessRecOj.Id = provRec.Account_Features_Access__c;
                accessRecOj.IAM_Reject_Reason__c = mapSubscIdOrderItem.get(provRec.CC_Subscription__c).OSM_SW_Cancel_Reason__c;
                accessRecOj.IAM_Reason__c = mapSubscIdOrderItem.get(provRec.CC_Subscription__c).OSM_SW_Cancel_Comment__c;
                lstIAMAccessRecToUpdate.add(accessRecOj);
                setOfId.add(provRec.Account_Features_Access__c);
            }
            
        }
        System.debug('update IAM records: '+lstIAMAccessRecToUpdate);
        
        if(lstIAMAccessRecToUpdate.size() > 0)
        {
            update lstIAMAccessRecToUpdate;
        }
        
        
    }
    
}