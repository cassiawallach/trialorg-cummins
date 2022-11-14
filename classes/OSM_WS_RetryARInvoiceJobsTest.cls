@isTest 
public class OSM_WS_RetryARInvoiceJobsTest {
    static testMethod void testOSM_WS_RetryARInvoiceJobs() 
    {        
      // list<ccrz__E_TransactionPayment__c> transPaymntList = [Select id, ccrz__InvoiceAppliedTo__c,OSM_ARInvoice_Integration_Failure__c from ccrz__E_TransactionPayment__c where OSM_ARInvoice_Integration_Failure__c = true ];
           list<ccrz__E_TransactionPayment__c> transPaymntList =new list<ccrz__E_TransactionPayment__c>();
            ccrz__E_TransactionPayment__c payment=new ccrz__E_TransactionPayment__c();
            payment.OSM_ARInvoice_Integration_Failure__c=true;
            insert payment;
            transPaymntList.add(payment);
            Test.startTest();
            try{
            OSM_WS_Bolt_ScheduleBatchJobs scheduleTest= new OSM_WS_Bolt_ScheduleBatchJobs();
            OSM_WS_Bolt_ScheduleBatchJobs.scheduleIntegration();
            scheduleTest.execute(null);           
            OSM_WS_RetryARInvoiceJobs obj = new OSM_WS_RetryARInvoiceJobs();
            obj.operation='FailureCases';
            
            obj.execute(null,transPaymntList);
            payment.OSM_ARInvoice_Integration_Failure__c=false;
            update payment;
            }
            catch(Exception ex){}
            Test.stopTest();
    }
}