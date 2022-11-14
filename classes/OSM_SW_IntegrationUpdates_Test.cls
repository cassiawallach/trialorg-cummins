/************************************************
 History
 --------
 VERSION    AUTHOR          DATE            DETAILS
 1.0        Ashish          24/06/2021      Test Class Fix
 1.0        Ashish          05/07/2021      Test Class Fix
 */
@istest
public class OSM_SW_IntegrationUpdates_Test {

     static testmethod void updateIntegrationFlagTest(){
     Set<id> idSet=new Set<Id>();
        ccrz__E_TransactionPayment__c cctp1 = new ccrz__E_TransactionPayment__c();
         cctp1.OSM_ARInvoice_Integration_Failure__c = true; 
         cctp1.OSM_ARInvoice_Failed_Count__c = 1; 
         insert cctp1;
         idSet.add(cctp1.id);
     Map<Id,ccrz__E_TransactionPayment__c> transactionPaymentToReset = new Map<Id,ccrz__E_TransactionPayment__c>();
          ccrz__E_TransactionPayment__c cctp2 = new ccrz__E_TransactionPayment__c();
          cctp2.OSM_JournalEntry_Integration_Failure__c = true;
          cctp2.OSM_JournalEntry_Failed_Count__c = 1;
         insert cctp2;
         ccrz__E_TransactionPayment__c cctp3 = new ccrz__E_TransactionPayment__c();
          cctp3.OSM_Order_Update_Integration_Failure__c = true;
          cctp3.OSM_Order_Update_Failed_Count__c = 1;
         insert cctp3;
          ccrz__E_TransactionPayment__c cctp4 = new ccrz__E_TransactionPayment__c();
          cctp4.OSM_Order_Cancellation_Failure__c = true;
          cctp4.OSM_Order_Cancellation_Failed_Count__c = 1;
         insert cctp4;
         
         test.starttest();
         
         OSM_SW_IntegrationUpdates.updateIntegrationFlag(idSet,label.OSM_DA_Order_Update,'DA Order Update');
          OSM_SW_IntegrationUpdates.resetIntegrationFlag(idSet,'AR Invoice','Recurring Invoice');
         test.stopTest();
         
         
         
    }
    static testmethod void updateIntegrationFlagTest1(){
     Set<id> idSet=new Set<Id>();
        ccrz__E_TransactionPayment__c cctp1 = new ccrz__E_TransactionPayment__c();
         cctp1.OSM_ARInvoice_Integration_Failure__c = true; 
         cctp1.OSM_ARInvoice_Failed_Count__c = 1; 
         insert cctp1;
         idSet.add(cctp1.id);
         
          ccrz__E_TransactionPayment__c cctp2 = new ccrz__E_TransactionPayment__c();
          cctp2.OSM_JournalEntry_Integration_Failure__c = true;
          
          cctp2.OSM_JournalEntry_Failed_Count__c = 1;
         insert cctp2;
         cctp2.Bolt_AR_Call_Status__c = 'Pending';
         update cctp2;
         
         ccrz__E_TransactionPayment__c cctp3 = new ccrz__E_TransactionPayment__c();
          cctp3.OSM_Order_Update_Integration_Failure__c = true;
          cctp3.OSM_Order_Update_Failed_Count__c = 1;
         insert cctp3;
          ccrz__E_TransactionPayment__c cctp4 = new ccrz__E_TransactionPayment__c();
          cctp4.OSM_Order_Cancellation_Failure__c = true;
          cctp4.OSM_Order_Cancellation_Failed_Count__c = 1;
         insert cctp4;
         
         test.starttest();
         
         OSM_SW_IntegrationUpdates.updateIntegrationFlag(idSet,'AR Invoice','FailureCases');
          OSM_SW_IntegrationUpdates.resetIntegrationFlag(idSet,'AR Invoice','FailureCases');
         test.stopTest();    
    }
    static testmethod void updateIntegrationFlagTest2(){
     Set<id> idSet=new Set<Id>();
        ccrz__E_TransactionPayment__c cctp1 = new ccrz__E_TransactionPayment__c();
         cctp1.OSM_ARInvoice_Integration_Failure__c = true; 
         cctp1.OSM_ARInvoice_Failed_Count__c = 1; 
         insert cctp1;
         idSet.add(cctp1.id);
         
          ccrz__E_TransactionPayment__c cctp2 = new ccrz__E_TransactionPayment__c();
          cctp2.OSM_JournalEntry_Integration_Failure__c = true;
          
          cctp2.OSM_JournalEntry_Failed_Count__c = 1;
         insert cctp2;
         cctp2.Bolt_AR_Call_Status__c = 'Pending';
         update cctp2;
         
         ccrz__E_TransactionPayment__c cctp3 = new ccrz__E_TransactionPayment__c();
          cctp3.OSM_Order_Update_Integration_Failure__c = true;
          cctp3.OSM_Order_Update_Failed_Count__c = 1;
         insert cctp3;
          ccrz__E_TransactionPayment__c cctp4 = new ccrz__E_TransactionPayment__c();
          cctp4.OSM_Order_Cancellation_Failure__c = true;
          cctp4.OSM_Order_Cancellation_Failed_Count__c = 1;
         insert cctp4;
         
         test.starttest();
         
         OSM_SW_IntegrationUpdates.updateIntegrationFlag(idSet,'Journal Entry','FailureCases');
          OSM_SW_IntegrationUpdates.resetIntegrationFlag(idSet,'Journal Entry','FailureCases');
         test.stopTest();    
    }
    static testmethod void updateIntegrationFlagTest4(){
     Set<id> idSet=new Set<Id>();
        ccrz__E_TransactionPayment__c cctp1 = new ccrz__E_TransactionPayment__c();
         cctp1.OSM_ARInvoice_Integration_Failure__c = true; 
         cctp1.OSM_ARInvoice_Failed_Count__c = 1; 
         insert cctp1;
         idSet.add(cctp1.id);
         
          ccrz__E_TransactionPayment__c cctp2 = new ccrz__E_TransactionPayment__c();
          cctp2.OSM_JournalEntry_Integration_Failure__c = true;
          
          cctp2.OSM_JournalEntry_Failed_Count__c = 1;
         insert cctp2;
         cctp2.Bolt_AR_Call_Status__c = 'Pending';
         update cctp2;
         
         ccrz__E_TransactionPayment__c cctp3 = new ccrz__E_TransactionPayment__c();
          cctp3.OSM_Order_Update_Integration_Failure__c = true;
          cctp3.OSM_Order_Update_Failed_Count__c = 1;
         insert cctp3;
          ccrz__E_TransactionPayment__c cctp4 = new ccrz__E_TransactionPayment__c();
          cctp4.OSM_Order_Cancellation_Failure__c = true;
          cctp4.OSM_Order_Cancellation_Failed_Count__c = 1;
         insert cctp4;
         
         test.starttest();
         
         OSM_SW_IntegrationUpdates.updateIntegrationFlag(idSet,label.DA_Order_Cancellation_Service_Name,'DA Order Cancellation');
         OSM_SW_IntegrationUpdates.resetIntegrationFlag(idSet,label.DA_Order_Cancellation_Service_Name,'DA Order Cancellation');
         test.stopTest();    
    }
    static testmethod void updateIntegrationFlagTest5(){
     Set<id> idSet=new Set<Id>();
        ccrz__E_TransactionPayment__c cctp1 = new ccrz__E_TransactionPayment__c();
         cctp1.OSM_ARInvoice_Integration_Failure__c = true; 
         cctp1.OSM_ARInvoice_Failed_Count__c = 1; 
         insert cctp1;
         idSet.add(cctp1.id);
         
          ccrz__E_TransactionPayment__c cctp2 = new ccrz__E_TransactionPayment__c();
          cctp2.OSM_JournalEntry_Integration_Failure__c = true;
          
          cctp2.OSM_JournalEntry_Failed_Count__c = 1;
         insert cctp2;
         cctp2.Bolt_AR_Call_Status__c = 'Pending';
         update cctp2;
         
         ccrz__E_TransactionPayment__c cctp3 = new ccrz__E_TransactionPayment__c();
          cctp3.OSM_Order_Update_Integration_Failure__c = true;
          cctp3.OSM_Order_Update_Failed_Count__c = 1;
         insert cctp3;
          ccrz__E_TransactionPayment__c cctp4 = new ccrz__E_TransactionPayment__c();
          cctp4.OSM_Order_Cancellation_Failure__c = true;
          cctp4.OSM_Order_Cancellation_Failed_Count__c = 1;
         insert cctp4;
         
         test.starttest();
         
         OSM_SW_IntegrationUpdates.updateIntegrationFlag(idSet,'Order Cancel','FailureCases');
         OSM_SW_IntegrationUpdates.resetIntegrationFlag(idSet,'DA Order Cancellation','FailureCases');
         test.stopTest();    
    }
    static testmethod void updateIntegrationFlagTest6(){
     Set<id> idSet=new Set<Id>();
        ccrz__E_TransactionPayment__c cctp1 = new ccrz__E_TransactionPayment__c();
         cctp1.OSM_ARInvoice_Integration_Failure__c = true; 
         cctp1.OSM_ARInvoice_Failed_Count__c = 1; 
         insert cctp1;
         idSet.add(cctp1.id);
         Map<Id, decimal> map_TPVal = new Map<Id, Decimal>();
         map_TPVal.put(cctp1.id, 2.0);
         
          ccrz__E_TransactionPayment__c cctp2 = new ccrz__E_TransactionPayment__c();
          cctp2.OSM_JournalEntry_Integration_Failure__c = true;
          
          cctp2.OSM_JournalEntry_Failed_Count__c = 1;
         insert cctp2;
         cctp2.Bolt_AR_Call_Status__c = 'Pending';
         update cctp2;
         
         ccrz__E_TransactionPayment__c cctp3 = new ccrz__E_TransactionPayment__c();
          cctp3.OSM_Order_Update_Integration_Failure__c = true;
          cctp3.OSM_Order_Update_Failed_Count__c = 1;
         insert cctp3;
          ccrz__E_TransactionPayment__c cctp4 = new ccrz__E_TransactionPayment__c();
          cctp4.OSM_Order_Cancellation_Failure__c = true;
          cctp4.OSM_Order_Cancellation_Failed_Count__c = 1;
         insert cctp4;
         
         test.starttest();
         
         OSM_SW_IntegrationUpdates.updateIntegrationFlag(idSet,'Order Cancel','FailureCases');
         OSM_SW_IntegrationUpdates.resetIntegrationFlag(map_TPVal,'AR Invoice','AR Invoice');
         test.stopTest();    
    }
    static testmethod void updateIntegrationFlagTest7(){
     Set<id> idSet=new Set<Id>();
        ccrz__E_TransactionPayment__c cctp1 = new ccrz__E_TransactionPayment__c();
         cctp1.OSM_ARInvoice_Integration_Failure__c = true; 
         cctp1.OSM_ARInvoice_Failed_Count__c = 1; 
         insert cctp1;
         idSet.add(cctp1.id);
         Map<Id, decimal> map_TPVal = new Map<Id, Decimal>();
         map_TPVal.put(cctp1.id, 2.0);
         
          ccrz__E_TransactionPayment__c cctp2 = new ccrz__E_TransactionPayment__c();
          cctp2.OSM_JournalEntry_Integration_Failure__c = true;
          
          cctp2.OSM_JournalEntry_Failed_Count__c = 1;
         insert cctp2;
         cctp2.Bolt_AR_Call_Status__c = 'Pending';
         update cctp2;
         
         ccrz__E_TransactionPayment__c cctp3 = new ccrz__E_TransactionPayment__c();
          cctp3.OSM_Order_Update_Integration_Failure__c = true;
          cctp3.OSM_Order_Update_Failed_Count__c = 1;
         insert cctp3;
          ccrz__E_TransactionPayment__c cctp4 = new ccrz__E_TransactionPayment__c();
          cctp4.OSM_Order_Cancellation_Failure__c = true;
          cctp4.OSM_Order_Cancellation_Failed_Count__c = 1;
         insert cctp4;
         
         test.starttest();
         
         OSM_SW_IntegrationUpdates.updateIntegrationFlag(idSet,'Order Cancel','FailureCases');
         OSM_SW_IntegrationUpdates.resetIntegrationFlag(idSet,' DA Order Update','DA Order Update');
         test.stopTest();    
    }
    static testmethod void updateIntegrationFlagTest8(){
     Set<id> idSet=new Set<Id>();
        ccrz__E_TransactionPayment__c cctp1 = new ccrz__E_TransactionPayment__c();
         cctp1.OSM_ARInvoice_Integration_Failure__c = true; 
         cctp1.OSM_ARInvoice_Failed_Count__c = 1; 
         cctp1.Bolt_AR_Call_Status__c = 'Pending';
         cctp1.Bolt_Credit_Memo_Call_Status__c = 'Pending';
         cctp1.Bolt_JE_Call_Status__c = 'Pending';
         cctp1.Bolt_JE_Reversal_Call_Status__c = 'Pending';
         insert cctp1;
         idSet.add(cctp1.id);
         Map<Id, decimal> map_TPVal = new Map<Id, Decimal>();
         map_TPVal.put(cctp1.id, 2.0);
         
          ccrz__E_TransactionPayment__c cctp2 = new ccrz__E_TransactionPayment__c();
          cctp2.OSM_JournalEntry_Integration_Failure__c = true;
          
          cctp2.OSM_JournalEntry_Failed_Count__c = 1;
         insert cctp2;
         cctp2.Bolt_AR_Call_Status__c = 'Pending';
         update cctp2;
         
         ccrz__E_TransactionPayment__c cctp3 = new ccrz__E_TransactionPayment__c();
          cctp3.OSM_Order_Update_Integration_Failure__c = true;
          cctp3.OSM_Order_Update_Failed_Count__c = 1;
         insert cctp3;
          ccrz__E_TransactionPayment__c cctp4 = new ccrz__E_TransactionPayment__c();
          cctp4.OSM_Order_Cancellation_Failure__c = true;
          cctp4.OSM_Order_Cancellation_Failed_Count__c = 1;
         insert cctp4;
         
         test.starttest();
         
         //OSM_SW_IntegrationUpdates.updateIntegrationFlag(idSet,'Order Cancel','FailureCases');
         OSM_SW_IntegrationUpdates.resetIntegrationFlag(map_TPVal,'Journal Entry','Order Placed');
         OSM_SW_IntegrationUpdates.resetIntegrationFlag(map_TPVal,'Journal Entry','Order Cancel');
         OSM_SW_IntegrationUpdates.resetIntegrationFlag(map_TPVal,'Journal Entry','FailureCases');
         OSM_SW_IntegrationUpdates.resetIntegrationFlag(map_TPVal,'AR Invoice','Order Placed');
         OSM_SW_IntegrationUpdates.resetIntegrationFlag(map_TPVal,'AR Invoice','Order Cancel');
         OSM_SW_IntegrationUpdates.resetIntegrationFlag(map_TPVal,'AR Invoice','FailureCases');
         test.stopTest();    
    }
    static testmethod void updateIntegrationFlagTest9(){
        Set<id> idSet=new Set<Id>();
        
        ccrz__E_TransactionPayment__c cctp1 = new ccrz__E_TransactionPayment__c();
         cctp1.OSM_ARInvoice_Integration_Failure__c = true; 
         cctp1.OSM_ARInvoice_Failed_Count__c = 1; 
         cctp1.Bolt_AR_Call_Status__c = 'Pending';
         cctp1.Bolt_Credit_Memo_Call_Status__c = 'Pending';
         cctp1.Bolt_JE_Call_Status__c = 'Pending';
         cctp1.Bolt_JE_Reversal_Call_Status__c = 'Pending';
         insert cctp1;
         idSet.add(cctp1.id);
         Map<Id, decimal> map_TPVal = new Map<Id, Decimal>();
         map_TPVal.put(cctp1.id, 2.0);
         
          ccrz__E_TransactionPayment__c cctp2 = new ccrz__E_TransactionPayment__c();
          cctp2.OSM_JournalEntry_Integration_Failure__c = true;
          
          cctp2.OSM_JournalEntry_Failed_Count__c = 1;
         insert cctp2;
         cctp2.Bolt_AR_Call_Status__c = 'Pending';
         update cctp2;
         
         ccrz__E_TransactionPayment__c cctp3 = new ccrz__E_TransactionPayment__c();
          cctp3.OSM_Order_Update_Integration_Failure__c = true;
          cctp3.OSM_Order_Update_Failed_Count__c = 1;
         insert cctp3;
          ccrz__E_TransactionPayment__c cctp4 = new ccrz__E_TransactionPayment__c();
          cctp4.OSM_Order_Cancellation_Failure__c = true;
          cctp4.OSM_Order_Cancellation_Failed_Count__c = 1;
         insert cctp4;
         
         test.starttest();
         
         OSM_SW_IntegrationUpdates.updateIntegrationFlag(map_TPVal,'Journal Entry','Order Placed');
         OSM_SW_IntegrationUpdates.updateIntegrationFlag(map_TPVal,'Journal Entry','Order Cancel');
         OSM_SW_IntegrationUpdates.updateIntegrationFlag(map_TPVal,'Journal Entry','FailureCases');
         OSM_SW_IntegrationUpdates.updateIntegrationFlag(map_TPVal,'AR Invoice','Order Placed');
         OSM_SW_IntegrationUpdates.updateIntegrationFlag(map_TPVal,'AR Invoice','Order Cancel');
         OSM_SW_IntegrationUpdates.updateIntegrationFlag(map_TPVal,'AR Invoice','FailureCases');
         test.stopTest();    
    }
}