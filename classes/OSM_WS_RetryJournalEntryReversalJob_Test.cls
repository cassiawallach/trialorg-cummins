//Test Class for the class OSM_WS_RetryJournalEntryReversalJobs*****
/************************************************
 History
 --------
 VERSION    AUTHOR          DATE            DETAILS
 1.0        Ashish          01/03/2021      Test Class Fixes
 2.0        Ashish          24/06/2021      Test Class Fixes
 3.0        Dhiraj          21/07/2021      Test Class Fixes
 4.0        Subbu K         28/07/2021      MAR-1861
 4.0        Ashish G        07/12/2021      MP-389
 */
@isTest 
public class OSM_WS_RetryJournalEntryReversalJob_Test {
    static testMethod void testOSM_WS_RetryJournalEntryReversalJobs() 
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
                payment.Bolt_JE_Reversal_Call_Status__c= 'Failure';
                payment.ccrz__InvoiceAppliedTo__c= invc.ID;
                transPaymntList.add(payment);
                insert transPaymntList; 
           test.startTest();
        database.executebatch(new OSM_WS_RetryJournalEntryReversalJobs ());
        test.stopTest();
       // System.assertEquals(10, [select count() from ccrz__E_TransactionPayment__c]);

 
            
    }


    }