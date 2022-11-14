// Created this btach class for MP-739
global class OSM_SW_CreateCreditMemo_Retry_Batch implements Database.Batchable<sObject>, Database.Stateful{

    global Database.QueryLocator start(Database.BatchableContext BC){        
     
       return Database.getQueryLocator([select id,Name,ccrz__CCOrder__c,ccrz__CCOrder__r.ccrz__OrderStatus__c,ccrz__CCOrder__r.OSM_SW_Is_DA_Update_Done_Or_Not_Needed__c,CreditMemo_Number__c from ccrz__E_Invoice__c Where ccrz__CCOrder__r.ccrz__OrderStatus__c='Cancellation Pending' AND CreditMemo_Number__c=Null]);
    }
    
     global void execute(Database.BatchableContext BC, List<ccrz__E_Invoice__c > scope){
          List<id> invoiceListIds = new List<id>();
          Set<id> invoiceSetIds = new Set<id>();
          Set<Id> orderToUpdateDADone = new Set<Id>();
          for(ccrz__E_Invoice__c invoice :scope)
             {
                 invoiceSetIds.add(invoice.ID);
                 orderToUpdateDADone.add(invoice.ccrz__CCOrder__c);
             }
         //MP-884 Code Start
         Set<id> creditMemoInvs = new Set<id>();
         for(ccrz__E_Invoice__c inv:[Select id,Original_Sales_Order_Invoice_Number__c,name from ccrz__E_Invoice__c where Original_Sales_Order_Invoice_Number__c IN:invoiceSetIds And Invoice_Type__c ='Credit Memo']){
             creditMemoInvs.add(inv.Original_Sales_Order_Invoice_Number__c);
         }
         invoiceSetIds.removeAll(creditMemoInvs);
         invoiceListIds.addAll(invoiceSetIds);
         system.debug('invoiceSetIds--->>'+invoiceSetIds);
         //MP-884 Code End
         if(invoiceListIds != Null){
             OSM_Create_CreditMemo.createCreditMemo(invoiceListIds, null); 
         }
         List<ccrz__E_Order__c> objOrder = new List<ccrz__E_Order__c>();
         for(ccrz__E_Order__c objOr : [Select Id, OSM_SW_Is_DA_Update_Done_Or_Not_Needed__c from ccrz__E_Order__c where Id IN: orderToUpdateDADone])
         {
             if(!objOr.OSM_SW_Is_DA_Update_Done_Or_Not_Needed__c){
                 objOr.OSM_SW_Is_DA_Update_Done_Or_Not_Needed__c = true;
                 objOrder.add(objOr);
             }
         }
         update objOrder;
           
     }
     global void finish(Database.BatchableContext BC){
         
     }
 }