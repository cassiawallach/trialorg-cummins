public class OSM_SW_QueuePartialOrderCacncellation implements Queueable,Database.AllowsCallouts {
    Set<Id> setOrderIdFrCancel;
    boolean isCancel;
    public OSM_SW_QueuePartialOrderCacncellation(Set<Id> setOrder, boolean isCancl) {
        setOrderIdFrCancel = setOrder;
        isCancel = isCancl;
    }
    public void execute(QueueableContext context) {
        List<ccrz__E_OrderItem__c> list_OrdItemRefundInv = new List<ccrz__E_OrderItem__c>();
        List<Id> list_OrdItemId = new List<Id>();
        Set<Id> set_OrderId = new Set<Id>();
        List<Id> set_InvId = new List<Id>();
        List<Id> lstJunctionObjectId = new List<Id>();
        List<Id> lst_InvId = new List<Id>();
        Set<Id> set_OrdItemId = new Set<Id>();
        try {           
            for(ccrz__E_OrderItem__c ordItm : [SELECT Id, IsInvoiceRefund__c, ccrz__Order__c, ccrz__OrderItemStatus__c, OMS_Product__c FROM ccrz__E_OrderItem__c 
                                                    WHERE ccrz__Order__c IN: setOrderIdFrCancel
                                                    AND IsCancelPending__c = true AND ccrz__OrderItemStatus__c = 'Order Submitted' AND IsRevokeLicenseSucess__c = true]){
                list_OrdItemRefundInv.add(ordItm); 
                set_OrderId.add(ordItm.ccrz__Order__c);
                set_OrdItemId.add(ordItm.Id);
                list_OrdItemId.add(ordItm.Id);  
            }
            
            if(set_OrdItemId.size() > 0){
                
                for(ccrz__E_Invoice__c inv : [Select Id from ccrz__E_Invoice__c where ccrz__CCOrder__c IN: set_OrderId AND IsCredited__c = false]){
                    set_InvId.add(inv.Id);
                    lst_InvId.add(inv.Id);
                }
                for(OSM_Orders_In_Invoice__c osmObj : [Select Id from OSM_Orders_In_Invoice__c where CC_Invoice__c IN: set_InvId and CC_Order__c IN: set_OrderId ]){
                    lstJunctionObjectId.add(osmObj.Id);
                }
                boolean isSuccess = false;
                isSuccess = OSM_SW_PartialInvoiceRefundManager.getVertexInvoiceTax(lstJunctionObjectId, list_OrdItemId);
                OSM_SW_OrderCancellationUtility.updateRecordsOnOrderItemCancellation(set_OrdItemId, 'Revoke');
                if(isSuccess || !isCancel){
                    update list_OrdItemRefundInv;                    
                }
            }
        }catch(Exception excp){
            // do nothing
        }
        try{
            if(set_OrdItemId.size() > 0){
                //OSM_SW_PartialInvoiceRefundManager.createCreditMemo(lst_InvId, list_OrdItemId);
            }
        }catch(Exception exc){
            // do nothing
        }
    }
}