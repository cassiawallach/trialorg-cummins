/************************************************************
Name:  OSM_BMSGetPDFRetryIntBatch
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is batch class for BMSGetPDF Integration 
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Neha Mehta         18/01/2019   INITIAL DEVELOPMENT          


*************************************************************/

global class OSM_BMSGetPDFRetryInt {
      @invocableMethod
      public static void pdfRecievedMethod(List<ccrz__E_Invoice__c> invoiceList)
       {
       Set<Id> invoiveIdSet=new Set<Id>();
        for(ccrz__E_Invoice__c inv:invoiceList){
            invoiveIdSet.add(inv.id);
        }   
        list<OSM_Integration_Log__c> logList=new list<OSM_Integration_Log__c>();
        List<ccrz__E_Invoice__c> invoiceData=[Select id,OSM_SW_IsIntercompanyInvoice__c,ccrz__CCOrder__c,OSM_SW_Is_Bolt_PO__c,ccrz__CCOrder__r.OrderProcessedforFSD__c,OSM_PDF_Received__c,ccrz__BillTo__c from ccrz__E_Invoice__c where id IN:invoiveIdSet];//Added ccrz__BillTo__c field by Dhiraj     
        System.debug('invoiceData_____'+invoiceData);
        OSM_Integration_Log__c log;
        for(ccrz__E_Invoice__c invoice:invoiceData){
         if(!invoice.OSM_SW_Is_Bolt_PO__c && !invoice.OSM_SW_IsIntercompanyInvoice__c && invoice.ccrz__CCOrder__r.OrderProcessedforFSD__c && !invoice.OSM_PDF_Received__c ){
             System.debug('log_____'+log);
             log = new OSM_Integration_Log__c();
             log.Account__c = invoice.ccrz__BillTo__c; // Added by Dhiraj
             log.Service_Name__c = label.PDFInvoiceTransferInBound;
             log.Source__c = label.OSM_BMS_Target_ID;
             log.Target__c = label.OSM_Target;
             log.Logged_In_User__c = userinfo.getUserId();
             log.Response__c  = 'Error';
             log.Status__c = 'Failure';
             log.Error_Description__c ='PDF Not Recieved';
             log.invoice__c=invoice.id;
             logList.add(log);
             System.debug('logList_____'+logList);
          }                 
        }
        if(!Test.isRunningTest()){
             insert logList;
         } 
}
}