//Test Class for OSM_WS_RetryJournalEntryJobs****
/************************************************
 History
 --------
 VERSION    AUTHOR          DATE            DETAILS
 1.0        Ashish          01/03/2021      Test Class Fixes
 2.0        Dhiraj          19/07/2021      Test Class Fixes for 1845
 3.0        Ashish          24/06/2021      Test Class Fixes
 4.0        Sharad          30/07/2021      Test Class Fixes
 3.0        Subbu           28/07/2021       MAR-1861 Fixes
 */
@isTest 
public class OSM_WS_RetryJournalEntryJobs_Test {
    static testMethod void testOSM_WS_RetryJournalEntryJobs() 
    {        
        List<Account>  lstacc = new List<Account>();
                Account acc = new Account();
                RecordType recid =[select id from recordType where name='wwsps' limit 1];  
                acc.RecordTypeId= recid.id;       
                acc.Name = 'Test Account';
                acc.CMI_Account_Status__c = 'Active';
                acc.CMI_CDA_Status__c = 'New Customer Request';
                acc.CMI_Region__c = 'NORTH AMERICA';
                acc.CSS_Language__c = 'English';
                acc.BillingCountry = 'United States';
                acc.CSS_DistributorCode__c = '02580';
                lstacc.add(acc);
                insert lstacc;
                
                list<ccrz__E_Invoice__c> invcList = new list<ccrz__E_Invoice__c>();
                ccrz__E_Invoice__c  invc = new ccrz__E_Invoice__c ();
                invc.ccrz__BillTo__c=acc.id;
                invc.Is_GOMS_Integration_Processed__c = true;
                invc.Is_GOMS_Intercompany_Invoice__c= true;
                invc.GOMS_Invoice_ID__c = '123';
                invc.OSM_SW_IsIntercompanyInvoice__c =false;
                invc.OSM_Child_Account__c =acc.id;
                invcList.add(invc);
                insert invcList ;
        
        
                list<ccrz__E_TransactionPayment__c> transPaymntList =new list<ccrz__E_TransactionPayment__c>();
                ccrz__E_TransactionPayment__c payment=new ccrz__E_TransactionPayment__c();
                payment.OSM_ARInvoice_Integration_Failure__c=true;
                payment.Bolt_JE_Call_Status__c='Failure';
                payment.ccrz__InvoiceAppliedTo__c= invc.ID;
                transPaymntList.add(payment);
                insert transPaymntList; 
                
                Test.startTest();
                try{
                    payment.OSM_ARInvoice_Integration_Failure__c=false;
                    update payment;
                    
                    /*OSM_WS_Bolt_ScheduleBatchJobs scheduleTest= new OSM_WS_Bolt_ScheduleBatchJobs();
                    OSM_WS_Bolt_ScheduleBatchJobs.scheduleIntegration();
                    scheduleTest.execute(null);    */       
                    OSM_WS_RetryJournalEntryJobs obj = new OSM_WS_RetryJournalEntryJobs();
                    obj.operation='FailureCases';
                    database.executeBatch(obj);
                    //obj.execute(null,transPaymntList);
                    //obj.Finish(null);
        
                    
                }
            catch(Exception ex){}
      System.assertNotEquals(null,transPaymntList,'Transaction Payment not created.');
      System.assertEquals('Failure', transPaymntList[0].Bolt_JE_Call_Status__c);
            Test.stopTest();

 
            
    }
 

    }