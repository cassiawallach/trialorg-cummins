/***************************************************************
Name:  OSM_WS_RetryJournalEntryJobs 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is batch class for Journal Entry service which will retry
failed jobs.
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit S         19/05/2018     INITIAL DEVELOPMENT          


*************************************************************/

global class OSM_WS_RetryJournalEntryJobs implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.Stateful{
    
    global String query{get;set;}
    global String operation;    
    global String state = label.OSM_Bolt_OrderPlaced;    
    List<Id> invoiceList = new List<Id>();
    Map<Id,Id> mapCTPInvcid = new Map<Id,Id>(); 
    global String sts = label.OSM_JERecurring_Status; 
    global String failurests = 'Failure';    
    global String pendingsts = 'Pending';
    global String poPaymentType = 'po'; // Added for OMG-1041
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        DateTime OneHoursAgo = System.now().addHours(-1);
        System.debug('===Inside Start OSM_WS_RetryJournalEntryJobs==='+operation);
        String queryFailure = '';
        if(Test.isRunningTest()){
            queryFailure = 'Select id, ccrz__InvoiceAppliedTo__c, OSM_JournalEntry_Integration_Failure__c, Bolt_JE_Call_Status__c,ccrz__InvoiceAppliedTo__r.OSM_SW_IsIntercompanyInvoice__c,ccrz__InvoiceAppliedTo__r.OSM_Child_Account__r.BillingCountry,ccrz__InvoiceAppliedTo__r.OSM_Child_Account__r.CSS_DistributorCode__c,ccrz__InvoiceAppliedTo__r.ccrz__BillTo__r.BillingCountry,ccrz__InvoiceAppliedTo__r.ccrz__BillTo__r.CSS_DistributorCode__c from ccrz__E_TransactionPayment__c where Bolt_JE_Call_Status__c = :failurests or Bolt_JE_Call_Status__c = :pendingsts';
        }else{
            queryFailure = 'Select id, ccrz__InvoiceAppliedTo__c, OSM_JournalEntry_Integration_Failure__c, Bolt_JE_Call_Status__c,ccrz__InvoiceAppliedTo__r.OSM_SW_IsIntercompanyInvoice__c,ccrz__InvoiceAppliedTo__r.OSM_Child_Account__r.BillingCountry,ccrz__InvoiceAppliedTo__r.OSM_Child_Account__r.CSS_DistributorCode__c,ccrz__InvoiceAppliedTo__r.ccrz__BillTo__r.BillingCountry,ccrz__InvoiceAppliedTo__r.ccrz__BillTo__r.CSS_DistributorCode__c from ccrz__E_TransactionPayment__c where (Bolt_JE_Call_Status__c = :failurests or Bolt_JE_Call_Status__c = :pendingsts) AND ccrz__AccountType__c=:poPaymentType AND CreatedDate <= : OneHoursAgo';
        }
        query = queryFailure;
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<ccrz__E_TransactionPayment__c> scope){  
    
     invoiceList.clear(); //Added for Mar-939
    mapCTPInvcid.clear(); //Added for Mar-939     
            
        for(ccrz__E_TransactionPayment__c frec :scope){ 
        
            if(frec.ccrz__InvoiceAppliedTo__c != null && frec.ccrz__InvoiceAppliedTo__r.ccrz__BillTo__c != null){
               if(frec.ccrz__InvoiceAppliedTo__r.OSM_SW_IsIntercompanyInvoice__c && frec.ccrz__InvoiceAppliedTo__r.OSM_Child_Account__c !=null && (label.OSM_North_America_Country.contains(frec.ccrz__InvoiceAppliedTo__r.OSM_Child_Account__r.BillingCountry) || label.OSM_PO_Distributor_List.contains(frec.ccrz__InvoiceAppliedTo__r.OSM_Child_Account__r.CSS_DistributorCode__c)))
                {
                    invoiceList.add(frec.ccrz__InvoiceAppliedTo__c);
                    mapCTPInvcid.put(frec.ccrz__InvoiceAppliedTo__c,frec.id);
                }
              else
               {
                  if(label.OSM_North_America_Country.contains(frec.ccrz__InvoiceAppliedTo__r.ccrz__BillTo__r.BillingCountry) || label.OSM_PO_Distributor_List.contains(frec.ccrz__InvoiceAppliedTo__r.ccrz__BillTo__r.CSS_DistributorCode__c)) 
                  {
                      invoiceList.add(frec.ccrz__InvoiceAppliedTo__c);
                      mapCTPInvcid.put(frec.ccrz__InvoiceAppliedTo__c,frec.id);
                
                  }
                }
            }
        }
        system.debug('invoiceListJobJE'+invoiceList);
        system.debug('mapCTPInvcidJobJE'+mapCTPInvcid);
        
        Map<id,ccrz__E_TransactionPayment__c> mapToUpdateFailureFlag = new Map<id,ccrz__E_TransactionPayment__c>(); 
        Map<id,ccrz__E_TransactionPayment__c> mapToResetFailureFlag = new Map<id,ccrz__E_TransactionPayment__c>();
        Map<id,OSM_Integration_Log__c> mapToInsertLogs = new Map<id,OSM_Integration_Log__c>();
        String service = Label.OSM_Bolt_Journal_Entry;
        
        List<OSM_Integration_Log__c> osmlogList = new List<OSM_Integration_Log__c>();
        Map<Id,ccrz__E_TransactionPayment__c> mapToUpdateFlagOnTransactionPayment = new Map<Id,ccrz__E_TransactionPayment__c>();
        Map<Id,ccrz__E_TransactionPayment__c> mapToResetFlagOnTransactionPayment = new Map<Id,ccrz__E_TransactionPayment__c>();
        
        OSM_ReturnWrapper returnWrapper = OSM_BOLT_SW_BusinessLayerHandler.setJournalEntryWrapper(invoiceList,mapCTPInvcid,state,null); //Journal Entry Business handler
        
        mapToInsertLogs = returnWrapper.mapToInsertLogs;
        mapToUpdateFailureFlag = returnWrapper.mapToUpdateFailureFlag;
        mapToResetFailureFlag = returnWrapper.mapToResetFailureFlag;

        // update invoices
        
        if(returnWrapper.updateInvoiceList != null && returnWrapper.updateInvoiceList.size() > 0)
        {
            update returnWrapper.updateInvoiceList;
        }
        
        set<ccrz__E_Order__c> orderSet = new set<ccrz__E_Order__c>();
        List<ccrz__E_Order__c> orderList = new List<ccrz__E_Order__c>();
        if(returnWrapper.updateOrderList != null && returnWrapper.updateOrderList.size() > 0)
        {
            for(ccrz__E_Order__c objOrder : returnWrapper.updateOrderList)
                orderSet.add(objOrder);
            orderList.addAll(orderSet);
            update orderList;
        }
        
        
        //Insert integration logs
        if(mapToInsertLogs.keyset() != null && mapToInsertLogs.size()>0){
            for(OSM_Integration_Log__c logToInsert :mapToInsertLogs.values()){
                osmlogList.add(logToInsert);  
            }
            OSM_SW_LoggingContext.saveIntegrationLogList(osmlogList);       
        }
        
        //Update failure flags
        Map<Id, Decimal> map_UpdateTPIdARJEAmount = new Map<Id, Decimal>();
        Map<Id, Decimal> map_ResetTPIdARJEAmount = new Map<Id, Decimal>();
        if(mapToUpdateFailureFlag.keyset() != null && mapToUpdateFailureFlag.size()>0){
            for(ccrz__E_TransactionPayment__c paymentRecord :mapToUpdateFailureFlag.values()){
                mapToUpdateFlagOnTransactionPayment.put(paymentRecord.id,paymentRecord); 
                map_UpdateTPIdARJEAmount.put(paymentRecord.id,paymentRecord.JE_Batch_Amount__c);
            }
            //OSM_SW_IntegrationUpdates.updateIntegrationFlag(mapToUpdateFlagOnTransactionPayment.keyset(),service,operation);
            OSM_SW_IntegrationUpdates.updateIntegrationFlag(map_UpdateTPIdARJEAmount,service,operation);
        }
         
         //Reset failure flags
        if(mapToResetFailureFlag.keyset() != null && mapToResetFailureFlag.size()>0){
            for(ccrz__E_TransactionPayment__c paymentRecord :mapToResetFailureFlag.values()){
                mapToResetFlagOnTransactionPayment.put(paymentRecord.id,paymentRecord); 
                map_ResetTPIdARJEAmount.put(paymentRecord.id,paymentRecord.JE_Batch_Amount__c); 
            }
            //OSM_SW_IntegrationUpdates.resetIntegrationFlag(mapToResetFlagOnTransactionPayment.keyset(),service,operation);
            OSM_SW_IntegrationUpdates.resetIntegrationFlag(map_ResetTPIdARJEAmount,service,operation);
        }
    
    }

    global void finish(Database.BatchableContext BC){  
    }
    
}