global class OSM_WS_RetryInterCompanyOItemforRefund implements Database.Batchable<sObject>,Database.AllowsCallouts{
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        String strStatus = 'Cancelled';
        String strINTStatus = 'Success';
        string creditMemo ='Credit Memo';
        String orderSubmit ='Order Submitted';
        //String testId= 'a3Z1F000000URg3';
        String query = 'Select id,ccrz__CCOrder__c,ccrz__InvoiceAppliedTo__r.Invoice_Type__c,ccrz__InvoiceAppliedTo__c from ccrz__E_TransactionPayment__c where ccrz__CCOrder__r.ccrz__OrderStatus__c  =: orderSubmit AND ccrz__CCOrder__r.Original_Sales_Order__r.OSM_SW_Is_FSD_refund_Call_Done__c = true AND Bolt_JE_Reversal_Call_Status__c  =: strINTStatus AND Bolt_Credit_Memo_Call_Status__c =: strINTStatus AND ccrz__InvoiceAppliedTo__r.Invoice_Type__c=:creditMemo AND ccrz__InvoiceAppliedTo__r.IntercompanyCalled__c = true AND ccrz__InvoiceAppliedTo__r.OSM_SW_IsIntercompanyInvoice__c = True AND ccrz__InvoiceAppliedTo__r.OSM_Child_Account__r.BillingCountry=\'United States\'';
       // String query = 'Select id,ccrz__CCOrder__c,ccrz__InvoiceAppliedTo__r.Invoice_Type__c,ccrz__InvoiceAppliedTo__c from ccrz__E_TransactionPayment__c where ccrz__CCOrder__r.ccrz__OrderStatus__c  =: orderSubmit AND ccrz__CCOrder__r.Original_Sales_Order__r.OSM_SW_Is_FSD_refund_Call_Done__c = true AND Bolt_JE_Reversal_Call_Status__c  =: strINTStatus AND Bolt_Credit_Memo_Call_Status__c =: strINTStatus AND ccrz__InvoiceAppliedTo__r.Invoice_Type__c=:creditMemo AND ccrz__InvoiceAppliedTo__r.IntercompanyCalled__c = true AND id=:testId';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<ccrz__E_TransactionPayment__c> scope){   
        Set<Id> setInvoiceItemId = new Set<Id>();
        Set<Id> setInvoiceId = new Set<Id>();   
        for(ccrz__E_TransactionPayment__c transecObj :scope){
            setInvoiceId.add(transecObj.ccrz__InvoiceAppliedTo__c);
        }
        system.debug('setInvoiceId---->>'+setInvoiceId);
        List<ccrz__E_InvoiceItem__c> listInvoiceItems = new List<ccrz__E_InvoiceItem__c>();
        listInvoiceItems = [Select id,Name,ccrz__Invoice__c,ccrz__CCOrderItem__r.ccrz__OrderItemStatus__c from ccrz__E_InvoiceItem__c where ccrz__Invoice__c IN:setInvoiceId AND Is_Refund_Intercompany_Call_Done__c = false AND ccrz__Type__c='Item' AND ccrz__CCOrderItem__c != Null];//AND ccrz__CCOrderItem__r.ccrz__OrderItemStatus__c='Cancelled'
        for(ccrz__E_InvoiceItem__c invItems:listInvoiceItems){
            setInvoiceItemId.add(invItems.id);
        }
        system.debug('setInvoiceItemId---->>'+setInvoiceItemId);
        if(setInvoiceItemId.size() > 0 )
            OSM_Intercompany_FutureLayerHandler.callIntercompanyInvoiceItemAPI(setInvoiceItemId,true,false);
       
    }

    global void finish(Database.BatchableContext BC){  
    }
    
}