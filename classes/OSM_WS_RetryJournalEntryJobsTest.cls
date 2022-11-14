@isTest 
public class OSM_WS_RetryJournalEntryJobsTest {
    static testMethod void testOSM_WS_RetryJournalEntryJobs() 
    {        
        //list<ccrz__E_TransactionPayment__c> transPaymntList = [Select id, ccrz__InvoiceAppliedTo__c from ccrz__E_TransactionPayment__c where OSM_JournalEntry_Integration_Failure__c = true ];
            list<ccrz__E_TransactionPayment__c> transPaymntList=new list<ccrz__E_TransactionPayment__c>();
            //list<ccrz__E_TransactionPayment__c> transPaymntList=new list<ccrz__E_TransactionPayment__c>();
            ccrz__E_TransactionPayment__c payment =new ccrz__E_TransactionPayment__c();
            payment.OSM_ARInvoice_Integration_Failure__c=true;
            insert payment;
            transPaymntList.add(payment);
            Test.startTest();
            OSM_WS_RetryJournalEntryJobs obj = new OSM_WS_RetryJournalEntryJobs();
            obj.operation='FailureCases';
            Database.QueryLocator ql = obj.start(null);
            obj.execute(null,transPaymntList);
            payment.OSM_ARInvoice_Integration_Failure__c=false;
            update payment;
//update payment;
            obj.Finish(null);
            //DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
    static testMethod void testOSM_WS_RetryJournalEntryJobsRecurringOperations() 
    {        
        //list<ccrz__E_TransactionPayment__c> transPaymntList = [Select id, ccrz__InvoiceAppliedTo__c from ccrz__E_TransactionPayment__c where OSM_JournalEntry_Integration_Failure__c = true ];
            list<ccrz__E_TransactionPayment__c> transPaymntList=new list<ccrz__E_TransactionPayment__c>();
            //list<ccrz__E_TransactionPayment__c> transPaymntList=new list<ccrz__E_TransactionPayment__c>();
            ccrz__E_TransactionPayment__c payment =new ccrz__E_TransactionPayment__c();
            payment.OSM_ARInvoice_Integration_Failure__c=true;
            insert payment;
            transPaymntList.add(payment);
            Test.startTest();
            OSM_WS_RetryJournalEntryJobs obj = new OSM_WS_RetryJournalEntryJobs();
            obj.operation='RecurringInvoice';
            Database.QueryLocator ql = obj.start(null);
            obj.execute(null,transPaymntList);
            payment.OSM_ARInvoice_Integration_Failure__c=false;
            update payment;
            //update payment;
            obj.Finish(null);
            //DataBase.executeBatch(obj); 
            
        Test.stopTest();    }

    }