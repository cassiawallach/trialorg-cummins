/************************************************************
Name:  OSM_WS_ScheduleBatchJobs 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is scheduler class which will be scheduled every hour.
This will run AR Invoice batch job which will subsequently run
journal entry and vertex batch class. 
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit S         19/05/2018     INITIAL DEVELOPMENT          

*************************************************************/

global class OSM_WS_Bolt_ScheduleBatchJobs implements Schedulable{
    
    public static String cron_exp = label.OSM_Bolt_Cron_Expression;  //Every Hour
        
        global static String scheduleIntegration(){
            
           if(Test.isRunningTest())
           {
               OSM_WS_Bolt_ScheduleBatchJobs sc = new OSM_WS_Bolt_ScheduleBatchJobs();
               return system.schedule('OSM Bolt Integration Job Test', cron_exp, sc);
           }
           else{
               OSM_WS_Bolt_ScheduleBatchJobs sc = new OSM_WS_Bolt_ScheduleBatchJobs();
               return system.schedule('OSM Bolt Integration Job', cron_exp, sc);
           }
       }
         
    global void execute(SchedulableContext SC){
    
        OSM_WS_RetryARInvoiceJobs bjobs = new OSM_WS_RetryARInvoiceJobs();
        bjobs.operation = 'FailureCases';
        bjobs.state = 'Order Placed';
        
        //String soqlFailure = 'Select id, ccrz__InvoiceAppliedTo__c, OSM_ARInvoice_Integration_Failure__c, Bolt_AR_Call_Status__c, Bolt_Credit_Memo_Call_Status__c from ccrz__E_TransactionPayment__c where OSM_ARInvoice_Integration_Failure__c = true or Bolt_AR_Call_Status__c = :failurests or Bolt_Credit_Memo_Call_Status__c = :failurests';
        String soqlFailure = '';
        if(Test.isRunningTest()){
            soqlFailure = 'Select id,Name,ccrz__InvoiceAppliedTo__c,ccrz__InvoiceAppliedTo__r.OSM_Child_Account__c,ccrz__InvoiceAppliedTo__r.OSM_SW_IsIntercompanyInvoice__c,ccrz__InvoiceAppliedTo__r.OSM_Child_Account__r.BillingCountry,ccrz__InvoiceAppliedTo__r.ccrz__BillTo__r.BillingCountry,ccrz__InvoiceAppliedTo__r.OSM_Child_Account__r.CSS_DistributorCode__c,ccrz__InvoiceAppliedTo__r.ccrz__BillTo__r.CSS_DistributorCode__c, OSM_ARInvoice_Integration_Failure__c, Bolt_AR_Call_Status__c from ccrz__E_TransactionPayment__c where OSM_ARInvoice_Integration_Failure__c = true or Bolt_AR_Call_Status__c = :failurests or Bolt_AR_Call_Status__c = :pendingsts order by CreatedDate DESC LIMIT : queryLIMIT';      
        } else{
            soqlFailure = 'Select id, Name,ccrz__InvoiceAppliedTo__c,ccrz__InvoiceAppliedTo__r.OSM_Child_Account__c,ccrz__InvoiceAppliedTo__r.OSM_SW_IsIntercompanyInvoice__c,ccrz__InvoiceAppliedTo__r.OSM_Child_Account__r.BillingCountry,ccrz__InvoiceAppliedTo__r.ccrz__BillTo__r.BillingCountry,ccrz__InvoiceAppliedTo__r.OSM_Child_Account__r.CSS_DistributorCode__c,ccrz__InvoiceAppliedTo__r.ccrz__BillTo__r.CSS_DistributorCode__c, OSM_ARInvoice_Integration_Failure__c, Bolt_AR_Call_Status__c from ccrz__E_TransactionPayment__c where (OSM_ARInvoice_Integration_Failure__c = true or Bolt_AR_Call_Status__c = :failurests or Bolt_AR_Call_Status__c = :pendingsts) AND ccrz__AccountType__c=:poPaymentType AND CreatedDate <= : OneHoursAgo AND ccrz__InvoiceAppliedTo__r.ccrz__OriginalAmount__c > 0 order by CreatedDate DESC LIMIT : queryLIMIT';      
        }
        bjobs.query = soqlFailure;
        
        if(bjobs.query != null){
            Database.executeBatch(bjobs,Integer.valueOf(label.OSM_ARInvoice_Batch_Size));   
        } 
    }
}