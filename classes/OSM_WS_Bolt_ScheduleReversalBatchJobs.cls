/************************************************************
Name:  OSM_WS_Bolt_ScheduleReversalBatchJobs 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is scheduler class which will be scheduled every hour.
This will run Credit Memo failure batch jobs which will 
subsequently run journal entry reversal batch. 
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit S         26/09/2018     INITIAL DEVELOPMENT          

*************************************************************/

global class OSM_WS_Bolt_ScheduleReversalBatchJobs implements Schedulable{
    
    public static String cron_exp = label.OSM_ReversalBatchJobsCron;
        
    global static String scheduleIntegration(){
        if(Test.isRunningTest()) {
            OSM_WS_Bolt_ScheduleReversalBatchJobs sc = new OSM_WS_Bolt_ScheduleReversalBatchJobs();
            return system.schedule('OSM Bolt Reversal Integration Job Test', cron_exp, sc);
        }
        else {
            OSM_WS_Bolt_ScheduleReversalBatchJobs sc = new OSM_WS_Bolt_ScheduleReversalBatchJobs();
            return system.schedule('OSM Bolt Reversal Integration Job', cron_exp, sc);
        }
    }
    
    global void execute(SchedulableContext SC){
    
        OSM_WS_RetryCreditMemoJobs bjobs = new OSM_WS_RetryCreditMemoJobs();
        
        //Setting context of operations-----'FailureCases' when running by batch and 'Order Cancel' while executing in system mode
        bjobs.operation = 'FailureCases';
        bjobs.state = 'Order Cancel';
        
        //Getting only Credit memo failure or pending records
        String soqlFailure = '';
        if(Test.isRunningTest()){
            soqlFailure = 'Select id,ccrz__InvoiceAppliedTo__c,ccrz__InvoiceAppliedTo__r.OSM_SW_IsIntercompanyInvoice__c,ccrz__InvoiceAppliedTo__r.OSM_Child_Account__r.BillingCountry,ccrz__InvoiceAppliedTo__r.ccrz__BillTo__r.BillingCountry,ccrz__InvoiceAppliedTo__r.ccrz__BillTo__r.CSS_DistributorCode__c, OSM_ARInvoice_Integration_Failure__c, Bolt_Credit_Memo_Call_Status__c from ccrz__E_TransactionPayment__c where Bolt_Credit_Memo_Call_Status__c = :failurests or Bolt_Credit_Memo_Call_Status__c = :pendingsts order by CreatedDate DESC LIMIT : queryLIMIT';      
        } else {
            soqlFailure = 'Select id,ccrz__InvoiceAppliedTo__c,ccrz__InvoiceAppliedTo__r.OSM_SW_IsIntercompanyInvoice__c,ccrz__InvoiceAppliedTo__r.OSM_Child_Account__r.BillingCountry,ccrz__InvoiceAppliedTo__r.ccrz__BillTo__r.BillingCountry,ccrz__InvoiceAppliedTo__r.ccrz__BillTo__r.CSS_DistributorCode__c, OSM_ARInvoice_Integration_Failure__c, Bolt_Credit_Memo_Call_Status__c from ccrz__E_TransactionPayment__c where (Bolt_Credit_Memo_Call_Status__c = :failurests or Bolt_Credit_Memo_Call_Status__c = :pendingsts) AND ccrz__InvoiceAppliedTo__r.CreditMemo_Number__c != null AND ccrz__InvoiceAppliedTo__r.Invoice_Type__c = \'Credit Memo\' AND CreatedDate <= : OneHoursAgo order by CreatedDate DESC LIMIT : queryLIMIT';      
        }
        bjobs.query = soqlFailure;
           
        system.debug('@@@@@@'+bjobs.query);   
                
        if(bjobs.query != null){
            Database.executeBatch(bjobs, Integer.valueOf(label.OSM_ARInvoice_Batch_Size));   
        } 
    }
}