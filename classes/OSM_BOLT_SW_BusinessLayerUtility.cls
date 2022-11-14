/************************************************************
Name:  OSM_BOLT_SW_BusinessLayerUtility 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is business layer utility class which will call future 
method of AR Invoice & Journal Entry. 
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit S         19/05/2018     INITIAL DEVELOPMENT          


*************************************************************/
public class OSM_BOLT_SW_BusinessLayerUtility{

    @future(callout = true)
    public static void getARInvoiceServices(List<Id> invoiceList, Map<Id,Id> mapCTPInvcid, String state){
        
        system.debug('state'+state);
        //System.enqueueJob(new OSM_BOLT_SW_ARBusinessLayerQueueable(invoiceList, mapCTPInvcid, state));
            
        Map<id,ccrz__E_TransactionPayment__c> mapToUpdateFailureFlag = new Map<id,ccrz__E_TransactionPayment__c>(); 
        Map<id,ccrz__E_TransactionPayment__c> mapToResetFailureFlag = new Map<id,ccrz__E_TransactionPayment__c>();
        Map<id,OSM_Integration_Log__c> mapToInsertLogs = new Map<id,OSM_Integration_Log__c>();
        String service = label.OSM_Bolt_AR_Invoice;
        
        List<OSM_Integration_Log__c> osmlogList = new List<OSM_Integration_Log__c>();
        Map<Id,ccrz__E_TransactionPayment__c> mapToUpdateFlagOnTransactionPayment = new Map<Id,ccrz__E_TransactionPayment__c>();
        Map<Id,ccrz__E_TransactionPayment__c> mapToResetFlagOnTransactionPayment = new Map<Id,ccrz__E_TransactionPayment__c>();
        List<AR_JE_Failure__c> list_AEFailure = new List<AR_JE_Failure__c>();
        boolean isExp = false;
        
        //OSM_BOLT_SW_BusinessLayerHandler.setARInvoiceOutboundWrapper(invoiceList,mapCTPInvcid); //AR Invoice Business handler
        OSM_ReturnWrapper returnWrapper = OSM_BOLT_SW_BusinessLayerHandler.setARInvoiceOutboundWrapper(invoiceList,mapCTPInvcid,state,null); //AR Invoice Business handler
        system.debug('returnWrapper'+returnWrapper);
        
        mapToInsertLogs = returnWrapper.mapToInsertLogs;
        mapToUpdateFailureFlag = returnWrapper.mapToUpdateFailureFlag;
        mapToResetFailureFlag = returnWrapper.mapToResetFailureFlag;
        
        // update invoices
        try{
            integer cnt = 0;
            for(ccrz__E_Order__c ordr : returnWrapper.updateOrderList){
                AR_JE_Failure__c arje = new AR_JE_Failure__c(Order__c = ordr.Id);                
                if(returnWrapper.updateInvoiceList.size() > 0 && returnWrapper.updateInvoiceList.get(cnt) != null){
                    arje.Invoice__c = returnWrapper.updateInvoiceList.get(cnt).Id;
                }
                list_AEFailure.add(arje);
                cnt ++;
            } 
            if((returnWrapper.updateInvoiceList != null && returnWrapper.updateInvoiceList.size() > 0)|| Test.isRunningTest()) {
                update returnWrapper.updateInvoiceList;
            }
            
            if((returnWrapper.updateOrderList != null && returnWrapper.updateOrderList.size() > 0 )|| Test.isRunningTest()) {
                update returnWrapper.updateOrderList;
            }
        
            //Insert integration logs
            /*if((mapToInsertLogs.keyset() != null && mapToInsertLogs.size()>0) || Test.isRunningTest()){
                for(OSM_Integration_Log__c logToInsert :mapToInsertLogs.values()){
                    osmlogList.add(logToInsert);  
                }        
                OSM_SW_LoggingContext.saveIntegrationLogList(osmlogList);                  
            }
            
            //Update failure flags
            if((mapToUpdateFailureFlag.keyset() != null && mapToUpdateFailureFlag.size()>0) || Test.isRunningTest()){
                for(ccrz__E_TransactionPayment__c paymentRecord :mapToUpdateFailureFlag.values()){
                    mapToUpdateFlagOnTransactionPayment.put(paymentRecord.id,paymentRecord); 
                }
                system.debug('mapToUpdateFlagOnTransactionPayment'+mapToUpdateFlagOnTransactionPayment);
                OSM_SW_IntegrationUpdates.updateIntegrationFlag(mapToUpdateFlagOnTransactionPayment.keyset(),service,state);
            }
            
            //Reset failure flags
            if((mapToResetFailureFlag.keyset() != null && mapToResetFailureFlag.size()>0) || Test.isRunningTest()){
                for(ccrz__E_TransactionPayment__c paymentRecord :mapToResetFailureFlag.values()){
                    mapToResetFlagOnTransactionPayment.put(paymentRecord.id,paymentRecord); 
                }
                system.debug('mapToResetFlagOnTransactionPayment'+mapToResetFlagOnTransactionPayment);
                //OSM_SW_IntegrationUpdates.resetIntegrationFlag(mapToResetFlagOnTransactionPayment.keyset(),service,'');
                OSM_SW_IntegrationUpdates.resetIntegrationFlag(mapToResetFlagOnTransactionPayment.keyset(),service,state);
            }*/
        }
        catch(Exception ex){
          isExp = true;
        }
        finally {
            if((mapToInsertLogs.keyset() != null && mapToInsertLogs.size()>0) || Test.isRunningTest()){
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
                    //mapToUpdateFlagOnTransactionPayment.put(paymentRecord.id,paymentRecord); 
                    map_UpdateTPIdARJEAmount.put(paymentRecord.id,paymentRecord.AR_Amount__c);
                }
                //OSM_SW_IntegrationUpdates.updateIntegrationFlag(mapToUpdateFlagOnTransactionPayment.keyset(),service,state);
                OSM_SW_IntegrationUpdates.updateIntegrationFlag(map_UpdateTPIdARJEAmount,service,state);
            }
            
            //Reset failure flags
            if(mapToResetFailureFlag.keyset() != null && mapToResetFailureFlag.size()>0){
                for(ccrz__E_TransactionPayment__c paymentRecord :mapToResetFailureFlag.values()){
                    //mapToResetFlagOnTransactionPayment.put(paymentRecord.id,paymentRecord); 
                    map_ResetTPIdARJEAmount.put(paymentRecord.id,paymentRecord.AR_Amount__c); 
                }
                //OSM_SW_IntegrationUpdates.resetIntegrationFlag(mapToResetFlagOnTransactionPayment.keyset(),service,state);
                OSM_SW_IntegrationUpdates.resetIntegrationFlag(map_ResetTPIdARJEAmount,service,state);
            }
            
            if((isExp && list_AEFailure.size() > 0)|| Test.isRunningTest()){
                insert list_AEFailure;
            }
        }
    }
    
    @future(callout = true)
    public static void getJournalEntryServices(List<Id> invoiceList, Map<Id,Id> mapCTPInvcid, String state){
        
        system.debug('state'+state);
        /*Map<id,ccrz__E_TransactionPayment__c> mapToUpdateFailureFlag = new Map<id,ccrz__E_TransactionPayment__c>(); 
        Map<id,ccrz__E_TransactionPayment__c> mapToResetFailureFlag = new Map<id,ccrz__E_TransactionPayment__c>();
        Map<id,OSM_Integration_Log__c> mapToInsertLogs = new Map<id,OSM_Integration_Log__c>();
        String service = Label.OSM_Bolt_Journal_Entry;
        
        List<OSM_Integration_Log__c> osmlogList = new List<OSM_Integration_Log__c>();
        Map<Id,ccrz__E_TransactionPayment__c> mapToUpdateFlagOnTransactionPayment = new Map<Id,ccrz__E_TransactionPayment__c>();
        Map<Id,ccrz__E_TransactionPayment__c> mapToResetFlagOnTransactionPayment = new Map<Id,ccrz__E_TransactionPayment__c>();
        
        //OSM_BOLT_SW_BusinessLayerHandler.setJournalEntryWrapper(invoiceList,mapCTPInvcid); //Journal Entry Business handler
        OSM_ReturnWrapper returnWrapper = OSM_BOLT_SW_BusinessLayerHandler.setJournalEntryWrapper(invoiceList,mapCTPInvcid,state); //Journal Entry Business handler
        system.debug('returnWrapper'+returnWrapper);
        
        mapToInsertLogs = returnWrapper.mapToInsertLogs;
        mapToUpdateFailureFlag = returnWrapper.mapToUpdateFailureFlag;
        mapToResetFailureFlag = returnWrapper.mapToResetFailureFlag;
        
        // update invoices
        
        if(returnWrapper.updateInvoiceList != null && returnWrapper.updateInvoiceList.size() > 0)
        {
            update returnWrapper.updateInvoiceList;
        }
        
        if(returnWrapper.updateOrderList != null && returnWrapper.updateOrderList.size() > 0)
        {
            update returnWrapper.updateOrderList;
        }
        //Insert integration logs
        if(mapToInsertLogs.keyset() != null && mapToInsertLogs.size()>0){
            for(OSM_Integration_Log__c logToInsert :mapToInsertLogs.values()){
                osmlogList.add(logToInsert);  
            }
            
            OSM_SW_LoggingContext.saveIntegrationLogList(osmlogList);       
            
        }
        
        //Update failure flags
        if(mapToUpdateFailureFlag.keyset() != null && mapToUpdateFailureFlag.size()>0){
            for(ccrz__E_TransactionPayment__c paymentRecord :mapToUpdateFailureFlag.values()){
                mapToUpdateFlagOnTransactionPayment.put(paymentRecord.id,paymentRecord); 
            }
            system.debug('mapToUpdateFlagOnTransactionPayment'+mapToUpdateFlagOnTransactionPayment);
            //OSM_SW_IntegrationUpdates.updateIntegrationFlag(mapToUpdateFlagOnTransactionPayment.keyset(),service,'');
            OSM_SW_IntegrationUpdates.updateIntegrationFlag(mapToUpdateFlagOnTransactionPayment.keyset(),service,state);
        }
        
        //Reset failure flags
        if(mapToResetFailureFlag.keyset() != null && mapToResetFailureFlag.size()>0){
            for(ccrz__E_TransactionPayment__c paymentRecord :mapToResetFailureFlag.values()){
                mapToResetFlagOnTransactionPayment.put(paymentRecord.id,paymentRecord); 
            }
            system.debug('mapToResetFlagOnTransactionPayment'+mapToResetFlagOnTransactionPayment);
            //OSM_SW_IntegrationUpdates.resetIntegrationFlag(mapToResetFlagOnTransactionPayment.keyset(),service,'');
        
            OSM_SW_IntegrationUpdates.resetIntegrationFlag(mapToResetFlagOnTransactionPayment.keyset(),service,state);
           
        }*/
        System.enqueueJob(new OSM_BOLT_SW_BusinessLayerQueueable(invoiceList, mapCTPInvcid, state));
    }
    
}