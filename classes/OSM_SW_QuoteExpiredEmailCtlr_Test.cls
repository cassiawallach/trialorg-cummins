@isTest
public class OSM_SW_QuoteExpiredEmailCtlr_Test{
   // public static User loggedInUser=OSM_TestDataCreationUtility.getPortalUser();
  //  public static User usr=OSM_testDataCreationUtility.getPortalUser();
    public static testmethod void test1(){
    
        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';
        
        
        testReq.compositeProductName = 'Connected Diagnostics';
        testReq.compositeProductSKU = '1234567-BUS';
        testReq.compositeProductGroupName = 'DA';
        testReq.compositeProductProductType = 'Aggregated';
        
        testReq.componentProductName = 'CD Base-BUS';
        testReq.componentProductStatus = 'Released';
        testReq.componentProductSKU = '1301298-BUS';
        testReq.componentProductGroupName = 'DA';
        testReq.componentProductPackageName = 'Base';
        
        
        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';
        
        
        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
        transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
        System.runAs(transecRes.objSetupDate.loggedInUser){
        List<ccrz__E_RequestForQuote__c>quoteList = new List<ccrz__E_RequestForQuote__c>();
        ccrz__E_RequestForQuote__c req = new ccrz__E_RequestForQuote__c();
        req.ccrz__Account__c = transecRes.objSetupDate.account.id;
        req.ccrz__Storefront__c = 'SoftwareStore';
        req.Status__c = 'Requested';
        req.CC_Product__c = transecRes.objSetupDate.compositeProduct.id;
        quoteList.add(req);
        insert quoteList;
    //system.debug('@@@@'+req.Status__c);
    
        quoteList[0].Status__c = 'In Progress';
        quoteList[0].Discounted_Price__c = 2;
        quoteList[0].Cost_Subscription__c = 40;
        update quoteList[0];
    
        Map<Id,ccrz__E_RequestForQuote__c> oldmapReq = new Map<Id,ccrz__E_RequestForQuote__c> ();
        oldmapReq.put(req.id,req); 
    
       quoteList[0].Status__c = 'Expired';
   
        update quoteList[0];
    
         /*TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
        transecRes = OSM_TestDataCreationUtility.createCompletedTransactionFlowTestData(objResponseProductSetup, 40, 6);*/
        Test.startTest();
         OSM_SW_QuoteExpiredEmailCtlr.sendEmail(quoteList, oldmapReq);
        Test.stopTest();
        }
    }
}