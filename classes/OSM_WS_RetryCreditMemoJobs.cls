/************************************************************
Name:  OSM_WS_RetryCreditMemoJobs
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is batch class for Credit Memo service which will retry
failed jobs.
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit S         19/05/2018     INITIAL DEVELOPMENT          


*************************************************************/

global class OSM_WS_RetryCreditMemoJobs implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.Stateful{
    
    global String query{get;set;}
    global String operation;
    global String state;
    
    List<Id> invoiceList = new List<Id>();
    Map<Id,Id> mapCTPInvcid = new Map<Id,Id>();  
    global String sts = label.OSM_ARInvoiceRecurring_Status;
    global String failurests = 'Failure';
    global String pendingsts = 'Pending';
    global Integer queryLIMIT = Integer.valueOf(label.OSM_ARInvoice_Batch_Size);
    global DateTime OneHoursAgo = System.now().addHours(-1);
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        System.debug('Query_'+query);
        system.debug('operation'+operation);
        system.debug('state###'+state);        
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<ccrz__E_TransactionPayment__c> scope){  
        system.debug('scope'+scope);
        
        for(ccrz__E_TransactionPayment__c frec :scope){
            if(frec.ccrz__InvoiceAppliedTo__r.OSM_SW_IsIntercompanyInvoice__c && frec.ccrz__InvoiceAppliedTo__r.OSM_Child_Account__c !=null && (label.OSM_North_America_Country.contains(frec.ccrz__InvoiceAppliedTo__r.OSM_Child_Account__r.BillingCountry)||label.OSM_PO_Distributor_List.contains(frec.ccrz__InvoiceAppliedTo__r.OSM_Child_Account__r.CSS_DistributorCode__c)))
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
        system.debug('invoiceListJobAR'+invoiceList);
        system.debug('mapCTPInvcidJobAR'+mapCTPInvcid);
        
        Map<id,ccrz__E_TransactionPayment__c> mapToUpdateFailureFlag = new Map<id,ccrz__E_TransactionPayment__c>(); 
        Map<id,ccrz__E_TransactionPayment__c> mapToResetFailureFlag = new Map<id,ccrz__E_TransactionPayment__c>();
        Map<id,OSM_Integration_Log__c> mapToInsertLogs = new Map<id,OSM_Integration_Log__c>();
        String service = label.OSM_Bolt_AR_Invoice;
        
        List<OSM_Integration_Log__c> osmlogList = new List<OSM_Integration_Log__c>();
        Map<Id,ccrz__E_TransactionPayment__c> mapToUpdateFlagOnTransactionPayment = new Map<Id,ccrz__E_TransactionPayment__c>();
        Map<Id,ccrz__E_TransactionPayment__c> mapToResetFlagOnTransactionPayment = new Map<Id,ccrz__E_TransactionPayment__c>();
        
        OSM_ReturnWrapper returnWrapper = OSM_BOLT_SW_BusinessLayerHandler.setARInvoiceOutboundWrapper(invoiceList,mapCTPInvcid,state,null); //AR Invoice Business handler
        system.debug('returnWrapper'+returnWrapper);
        
        
        if(returnWrapper.updateInvoiceList != null && returnWrapper.updateInvoiceList.size() > 0|| Test.isRunningTest())
        {
            update returnWrapper.updateInvoiceList;
        }
        //MAR-1992 Code start
        set<ccrz__E_Order__c> orderSet = new set<ccrz__E_Order__c>();
        List<ccrz__E_Order__c> orderList = new List<ccrz__E_Order__c>();
        
        if(returnWrapper.updateOrderList != null && returnWrapper.updateOrderList.size() > 0|| Test.isRunningTest())
        {
            for(ccrz__E_Order__c objOrder : returnWrapper.updateOrderList){
                orderSet.add(objOrder);
                }
            orderList.addAll(orderSet);
            update orderList;
            //update returnWrapper.updateOrderList;
        }
        // MAR-1992 Code End
        
        mapToInsertLogs = returnWrapper.mapToInsertLogs;
        
        mapToUpdateFailureFlag = returnWrapper.mapToUpdateFailureFlag;
        mapToResetFailureFlag = returnWrapper.mapToResetFailureFlag;
        
        //Insert integration logs
        if(mapToInsertLogs.keyset() != null && mapToInsertLogs.size()>0|| Test.isRunningTest()){
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
                map_UpdateTPIdARJEAmount.put(paymentRecord.id,paymentRecord.AR_Amount__c);
            }
            //OSM_SW_IntegrationUpdates.updateIntegrationFlag(mapToUpdateFlagOnTransactionPayment.keyset(),service,operation);
            OSM_SW_IntegrationUpdates.updateIntegrationFlag(map_UpdateTPIdARJEAmount,service,operation);
        }
        
        //Reset failure flags
        if(mapToResetFailureFlag.keyset() != null && mapToResetFailureFlag.size()>0){
            for(ccrz__E_TransactionPayment__c paymentRecord :mapToResetFailureFlag.values()){
                mapToResetFlagOnTransactionPayment.put(paymentRecord.id,paymentRecord); 
                map_ResetTPIdARJEAmount.put(paymentRecord.id,paymentRecord.AR_Amount__c); 
            }
            //OSM_SW_IntegrationUpdates.resetIntegrationFlag(mapToResetFlagOnTransactionPayment.keyset(),service,operation);
            OSM_SW_IntegrationUpdates.resetIntegrationFlag(map_ResetTPIdARJEAmount,service,operation);
        }        
    
 } 
    global void finish(Database.BatchableContext BC){    
       
        System.debug('======Inside finish ===='+operation);
        OSM_WS_RetryJournalEntryReversalJobs bjobs = new OSM_WS_RetryJournalEntryReversalJobs();             
        bjobs.operation = operation;
        bjobs.state = state;
        Database.executeBatch(bjobs,5);
        
    } 
}