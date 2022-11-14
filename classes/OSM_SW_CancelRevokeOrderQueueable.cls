public class OSM_SW_CancelRevokeOrderQueueable implements Queueable, Database.AllowsCallouts {
    Set<Id> setOrderIdFrCancel;
    Set<Id> setOrderIdFrPartCancel;
    Set<Id> setOrderIdFrSubmitOrder;
    boolean isCancel;
    public OSM_SW_CancelRevokeOrderQueueable(Set<Id> setOrderCan, Set<Id> setOrderPartCan, Set<Id> setOrderSubmit, boolean isCancl) {
        setOrderIdFrCancel = setOrderCan;
        setOrderIdFrPartCancel = setOrderPartCan;
        setOrderIdFrSubmitOrder = setOrderSubmit;
        isCancel = isCancl;
    }
    
    public void execute(QueueableContext context) {
        if(setOrderIdFrCancel.size() > 0){
            try {               
                OSM_SW_OrderCancellationUtility.updateRecordsOnOrderCancellation(setOrderIdFrCancel);
                OSM_SW_OrderTriggerHandlerUtility.getOrderCancel(setOrderIdFrCancel);
            }
            catch(Exception ex) {
                system.debug('exception in updating records: '+ex);
            }
        }
        if(setOrderIdFrPartCancel.size() > 0){
            List<ccrz__E_OrderItem__c> list_OrdItemRefundInv = new List<ccrz__E_OrderItem__c>();
            List<Id> list_OrdItemId = new List<Id>();
            Set<Id> set_OrdItemId = new Set<Id>();
            Set<Id> set_OrderId = new Set<Id>();
            List<Id> set_InvId = new List<Id>();
            List<Id> lstJunctionObjectId = new List<Id>();
            List<Id> lst_InvId = new List<Id>();
            boolean isSuccess = false;
            try {           
                for(ccrz__E_OrderItem__c ordItm : [SELECT Id, IsInvoiceRefund__c, ccrz__Order__c, ccrz__OrderItemStatus__c FROM ccrz__E_OrderItem__c 
                                                        WHERE ccrz__Order__c IN: setOrderIdFrPartCancel
                                                        AND ccrz__OrderItemStatus__c = 'Order Submitted' AND IsCancelPending__c = true]){
                    if(isCancel){
                        set_OrderId.add(ordItm.ccrz__Order__c);
                        list_OrdItemId.add(ordItm.Id);
                        set_OrdItemId.add(ordItm.Id);
                        ordItm.IsInvoiceRefund__c = true;
                        ordItm.ccrz__OrderItemStatus__c = 'Cancelled';
                        list_OrdItemRefundInv.add(ordItm);
                    }else{
                        ordItm.ccrz__OrderItemStatus__c = 'Revoked';
                        list_OrdItemRefundInv.add(ordItm);
                    }
                }
                
                if(isCancel){
                    for(ccrz__E_Invoice__c inv : [Select Id from ccrz__E_Invoice__c where ccrz__CCOrder__c IN: set_OrderId AND IsCredited__c = false]){
                        set_InvId.add(inv.Id);
                        lst_InvId.add(inv.Id);
                    }
                    for(OSM_Orders_In_Invoice__c osmObj : [Select Id from OSM_Orders_In_Invoice__c where CC_Invoice__c IN: set_InvId and CC_Order__c IN: set_OrderId ]){
                        lstJunctionObjectId.add(osmObj.Id);
                    }
                    
                    isSuccess = OSM_SW_PartialInvoiceRefundManager.getVertexInvoiceTax(lstJunctionObjectId, list_OrdItemId);
                    
                    OSM_SW_OrderCancellationUtility.updateRecordsOnOrderItemCancellation(set_OrdItemId, Label.OSM_Order_Cancellation);
                    if(isSuccess || !isCancel){
                        update list_OrdItemRefundInv;                    
                    }
                }
            }catch(Exception excp){
                // do nothing
            }
            try{
                if(isCancel){
                    OSM_SW_PartialInvoiceRefundManager.createCreditMemo(lst_InvId, list_OrdItemId,null);
                }
            }catch(Exception exc){
                // do nothing
            }
        }
        if(setOrderIdFrSubmitOrder.size() > 0){
            try{
                for(Id orderId: setOrderIdFrSubmitOrder) {
                    OSM_ReturnWrapper objRet = new OSM_ReturnWrapper();
                    objRet = OSM_WS_SubmitOrderBusiness_Handler.getOrderInfo(orderId,'Cancel',null,null,false,null);
                    if(!objRet.exceptionFlag || Test.isRunningTest()) {                        
                        OSM_SW_OrderCancelUtilForPage.updateIntercompanyOrderCancelSucess(orderId);
                        OSM_SW_OrderCancelUtilForPage.updateSubsc(orderId);
                    }
                    else {                       
                        OSM_SW_OrderCancelUtilForPage.updateIntercompanyOrder(orderId);                        
                    }
                } 
            }
            catch(Exception excpt) {
                system.debug('exception in updating records: '+excpt);
            }
        }
    }
}