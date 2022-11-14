public class OSM_BOLT_SW_BusinessLayerQueueable implements Queueable, Database.AllowsCallouts {

    @TestVisible public List<Id> invoiceList;
    @TestVisible public Map<Id,Id> mapCTPInvcid;
    @TestVisible public String state;
    
    public OSM_BOLT_SW_BusinessLayerQueueable(List<Id> invoiceListTmp, Map<Id,Id> mapCTPInvcidTmp, String stateTmp){
        invoiceList = invoiceListTmp;
        mapCTPInvcid = mapCTPInvcidTmp;
        state = stateTmp;
    }
    
    public void execute(QueueableContext context) {
        /*List<Id> invoiceListtemp = new List<Id>();
        Map<Id,Id> mapCTPInvcidTemp = new Map<Id,Id>();
        
        for(ccrz__E_TransactionPayment__c trnsPay : [SELECT Id, ccrz__InvoiceAppliedTo__c from ccrz__E_TransactionPayment__c 
                                                            where (Bolt_JE_Call_Status__c = 'Failure' or Bolt_JE_Call_Status__c = 'Pending') AND Id IN : mapCTPInvcid.values()]){
            invoiceListtemp.add(trnsPay.ccrz__InvoiceAppliedTo__c);
            mapCTPInvcidTemp.put(trnsPay.ccrz__InvoiceAppliedTo__c, trnsPay.Id);
        }
        if(invoiceListtemp.size() > 0){
            invoiceList = invoiceListtemp;
            mapCTPInvcid = mapCTPInvcidTemp;*/
        Map<id,ccrz__E_TransactionPayment__c> mapToUpdateFailureFlag = new Map<id,ccrz__E_TransactionPayment__c>(); 
        Map<id,ccrz__E_TransactionPayment__c> mapToResetFailureFlag = new Map<id,ccrz__E_TransactionPayment__c>();
        Map<id,OSM_Integration_Log__c> mapToInsertLogs = new Map<id,OSM_Integration_Log__c>();
        String service = Label.OSM_Bolt_Journal_Entry;
        
        List<OSM_Integration_Log__c> osmlogList = new List<OSM_Integration_Log__c>();
        Map<Id,ccrz__E_TransactionPayment__c> mapToUpdateFlagOnTransactionPayment = new Map<Id,ccrz__E_TransactionPayment__c>();
        Map<Id,ccrz__E_TransactionPayment__c> mapToResetFlagOnTransactionPayment = new Map<Id,ccrz__E_TransactionPayment__c>();
        
        //OSM_BOLT_SW_BusinessLayerHandler.setJournalEntryWrapper(invoiceList,mapCTPInvcid); //Journal Entry Business handler
        OSM_ReturnWrapper returnWrapper = OSM_BOLT_SW_BusinessLayerHandler.setJournalEntryWrapper(invoiceList,mapCTPInvcid,state,null); //Journal Entry Business handler
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
                map_UpdateTPIdARJEAmount.put(paymentRecord.id,paymentRecord.JE_Batch_Amount__c);
            }
            //OSM_SW_IntegrationUpdates.updateIntegrationFlag(mapToUpdateFlagOnTransactionPayment.keyset(),service,operation);
            OSM_SW_IntegrationUpdates.updateIntegrationFlag(map_UpdateTPIdARJEAmount,service,state);
        }
        
        //Reset failure flags
        if(mapToResetFailureFlag.keyset() != null && mapToResetFailureFlag.size()>0){
            for(ccrz__E_TransactionPayment__c paymentRecord :mapToResetFailureFlag.values()){
                //mapToResetFlagOnTransactionPayment.put(paymentRecord.id,paymentRecord); 
                map_ResetTPIdARJEAmount.put(paymentRecord.id,paymentRecord.JE_Batch_Amount__c); 
            }
            //OSM_SW_IntegrationUpdates.resetIntegrationFlag(mapToResetFlagOnTransactionPayment.keyset(),service,operation);
            OSM_SW_IntegrationUpdates.resetIntegrationFlag(map_ResetTPIdARJEAmount,service,state);
        }
    }
}