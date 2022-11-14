// Created this btach class for MP-739
global class OSM_SW_UpdateOrderCancel_Retry_Batch implements Database.Batchable<sObject>, Database.Stateful{

   global Database.QueryLocator start(Database.BatchableContext BC){        
    
      return Database.getQueryLocator([select id,Name,ccrz__CCOrder__c,ccrz__CCOrder__r.ccrz__OrderStatus__c,ccrz__CCOrder__r.OSM_SW_Is_DA_Update_Done_Or_Not_Needed__c,CreditMemo_Number__c from ccrz__E_Invoice__c Where ccrz__CCOrder__r.ccrz__OrderStatus__c='Cancellation Pending' AND CreditMemo_Number__c!=Null AND ccrz__CCOrder__r.OSM_SW_Is_DA_Update_Done_Or_Not_Needed__c =True]);
   }
   
    global void execute(Database.BatchableContext BC, List<ccrz__E_Invoice__c> scope){
        
         Set<Id> orderToUpdateCancelled = new Set<Id>();
         for(ccrz__E_Invoice__c invoice :scope)
            {
                orderToUpdateCancelled.add(invoice.ccrz__CCOrder__c);
            }
          OSM_SW_OrderCancelUtilForPage.updateOrderCancel(orderToUpdateCancelled);  
          
    }
    global void finish(Database.BatchableContext BC){
        
    }
}