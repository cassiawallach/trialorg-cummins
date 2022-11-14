@isTest
public class OSM_SW_SalesRepSendQuoteCtrl_Test{
    
    static testMethod void testOSM_SW_SalesRepSendQuoteCtrl(){
        
        // Create Quote
        List<ccrz__E_RequestForQuote__c> listRequestForQuote = TestingUtils.createRequestForQuote(1, 'In Progress', 20, 10, 100, 'Send', 'Test Data Comments', null, null, true);
        
        // Start Test
        Test.startTest();
        
        	PageReference pageRef = Page.OSM_SW_SalesRepSendQuotePg;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('Id', String.valueOf(listRequestForQuote[0].Id));
            ApexPages.StandardController sc = new ApexPages.StandardController(listRequestForQuote[0]);
            OSM_SW_SalesRepSendQuoteCtrl objClass = new OSM_SW_SalesRepSendQuoteCtrl(sc);
        	objClass.newrequest = listRequestForQuote[0];
        	objClass.sendAction();
        	OSM_SW_SalesRepSendQuoteCtrl.validateAction('Requested','Send');
            OSM_SW_SalesRepSendQuoteCtrl.validateAction('Accepted','Send');
            OSM_SW_SalesRepSendQuoteCtrl.validateAction('Rejected','Send');
        	OSM_SW_SalesRepSendQuoteCtrl.validateAction('InActive','Send');
            OSM_SW_SalesRepSendQuoteCtrl.validateAction('Sent','Send');
            OSM_SW_SalesRepSendQuoteCtrl.validateAction('Expired','Send');
            OSM_SW_SalesRepSendQuoteCtrl.validateAction('In Progress','Cancel');
            OSM_SW_SalesRepSendQuoteCtrl.validateAction('In','Cancel');
        	OSM_SW_SalesRepSendQuoteCtrl.validateAction('InActive','Cancel');
            objClass.backAction();        	
        	
        // Stop Test
        Test.stopTest();
    }
}