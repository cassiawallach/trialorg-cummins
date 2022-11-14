/************************************************
 History
 --------
 VERSION    AUTHOR          DATE            DETAILS
 1.0        Ashish          20/07/2021      Test Class Fixes
 2.0        Ashish          02/08/2021      Test Class Fixes
 3.0        Sharad          07/09/2021      Test Class Fixes 
 **/
@isTest 
public class OSM_WS_RetryInterCompanyInvoiceInt_Test{
    static testMethod void interCompanyInvoiceInt_Test(){
        
        List<ccrz__E_Invoice__c> invoicelst = new List<ccrz__E_Invoice__c>();
        ccrz__E_Invoice__c obj= new ccrz__E_Invoice__c();
        obj.OSM_SW_IsIntercompanyInvoice__c =true;
        obj.OSM_SW_IsBoltARInvoiceDone__c =true;
        obj.OSM_SW_isBoltJournalEntryDone__c =true;
        obj.IntercompanyCalled__c=false;
        invoicelst.add(obj);
        insert invoicelst ;
       
        Test.startTest();
            try{
            OSM_WS_Bolt_ScheduleBatchJobs scheduleTest= new OSM_WS_Bolt_ScheduleBatchJobs();
            OSM_WS_Bolt_ScheduleBatchJobs.scheduleIntegration();
            scheduleTest.execute(null);           
            OSM_WS_RetryInterCompanyInvoiceInt objs = new OSM_WS_RetryInterCompanyInvoiceInt();
            //obj.operation='FailureCases';
            
            objs.execute(null,invoicelst);
            //payment.OSM_ARInvoice_Integration_Failure__c=false;
           // update payment;
            }
            catch(Exception ex){}
            Test.stopTest();
    }
    static testmethod void testmethod2()
    {
        test.startTest();
        database.executebatch(new OSM_WS_RetryInterCompanyInvoiceInt());
        test.stopTest();
        
    }
}