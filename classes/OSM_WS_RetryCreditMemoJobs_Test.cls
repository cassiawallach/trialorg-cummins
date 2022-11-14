/************************************************
 History
 --------
 VERSION    AUTHOR          DATE            DETAILS
 1.0        Ashish          06/03/2021      Test Class Fixes
 2.0        Ashish          24/03/2021      Test Class Fixes
 3.0        Ashish          24/06/2021      Test Class Fixes
 4.0        Dhiraj          21/07/2021      Test Class Fixes
 5.0        Subbu           28/07/2021      MAR-1861
 */
@isTest

public class OSM_WS_RetryCreditMemoJobs_Test{
    static testMethod void testOSM_WS_RetryCreditMemoInvoiceJobs() 
    {        
           //list<ccrz__E_TransactionPayment__c> transPaymntList = [Select id,ccrz__InvoiceAppliedTo__c,ccrz__InvoiceAppliedTo__r.OSM_SW_IsIntercompanyInvoice__c,ccrz__InvoiceAppliedTo__r.OSM_Child_Account__r.BillingCountry,ccrz__InvoiceAppliedTo__r.ccrz__BillTo__r.BillingCountry, OSM_ARInvoice_Integration_Failure__c, Bolt_Credit_Memo_Call_Status__c from ccrz__E_TransactionPayment__c where Bolt_Credit_Memo_Call_Status__c = 'Failure' or Bolt_Credit_Memo_Call_Status__c = 'Pending'];
                
                List<Account>  lstacc = new List<Account>();
                Account acc = new Account();
                RecordType recid =[select id from recordType where name='wwsps' limit 1];  
                acc.RecordTypeId= recid.id;       
                acc.Name = 'Test Account';
                acc.CMI_Account_Status__c = 'Active';
                //acc.CMI_CDA_Status__c = 'New Customer Request';
                //acc.CMI_Region__c = 'NORTH AMERICA';
                //acc.CSS_Language__c = 'English';
                acc.BillingCountry = 'United States';
                acc.CSS_DistributorCode__c = '02580';
                lstacc.add(acc);
                insert lstacc;
                
                list<ccrz__E_Invoice__c> invcList = new list<ccrz__E_Invoice__c>();
                ccrz__E_Invoice__c  invc = new ccrz__E_Invoice__c ();
                invc.ccrz__BillTo__c=acc.id;
                //invc.Is_GOMS_Integration_Processed__c = true;
                //invc.Is_GOMS_Intercompany_Invoice__c= true;
                //invc.GOMS_Invoice_ID__c = '123';
                invc.OSM_SW_IsIntercompanyInvoice__c =false;
                invc.OSM_Child_Account__c =acc.id;
                invcList.add(invc);
                insert invcList ;
          
          
          
                list<ccrz__E_TransactionPayment__c> transPaymntList =new list<ccrz__E_TransactionPayment__c>();
                ccrz__E_TransactionPayment__c payment=new ccrz__E_TransactionPayment__c();
                payment.OSM_ARInvoice_Integration_Failure__c=true;
                payment.Bolt_Credit_Memo_Call_Status__c = 'Failure';
                payment.Bolt_Credit_Memo_Call_Status__c = 'Pending';
                payment.ccrz__InvoiceAppliedTo__c= invc.ID;
                insert payment;
                transPaymntList.add(payment);
                
            Test.startTest();
             try{
            OSM_WS_Bolt_ScheduleReversalBatchJobs  scheduleTest= new OSM_WS_Bolt_ScheduleReversalBatchJobs();
            OSM_WS_Bolt_ScheduleReversalBatchJobs.scheduleIntegration();
            scheduleTest.execute(null);           
            OSM_WS_RetryCreditMemoJobs obj = new OSM_WS_RetryCreditMemoJobs();
            obj.operation='FailureCases';
            
            obj.execute(null,transPaymntList);
           // payment.OSM_ARInvoice_Integration_Failure__c=false;
            //update payment;
            }
           
             catch(Exception ex){}
           
             Test.stopTest();
           
    }
    
}