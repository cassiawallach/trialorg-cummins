@isTest

public class OSM_SW_Prod_TermsAndConditions_Ctrl_Test{
   // public static User usr=OSM_testDataCreationUtility.getPortalUser();
    public static User usr=OSM_testDataCreationUtility.getPortalUser();
    static testMethod void testOSM_SW_ProductDetailServiceCls1()
    {
        TestProductSetupReq testReq = OSM_TestDataCreationUtility.populatedTestProductSetupReq();
        
        TestCompletedTransactionSetUpRes objResponseProductSetup = OSM_TestDataCreationUtility.createProductSetUp(testReq);
        
        System.debug('objResponseProductSetup: '+objResponseProductSetup);
        
        //TestCompletedTransactionSetUpRes transecRes = OSM_TestDataCreationUtility.createCompletedTransactionFlowTestData(objResponseProductSetup, 40, 6);
        
        //System.debug('transecRes: '+transecRes);
        System.runAs(usr){
        ccrz__E_Product__c compositeProduct=TestingUtils.createCompositeProduct(testReq.compositeProductName + '-1',testReq.compositeProductSKU + '-1',testReq.compositeProductGroupName,testReq.compositeProductProductType,true);
        compositeProduct.OSM_Term_and_Condition__c='quote';
        compositeProduct.name='test';
        upsert compositeProduct;
        Test.StartTest();
        
        PageReference myVfPage = Page.OSM_SW_Prod_TermsAndConditionsPg;
        Test.setCurrentPage(myVfPage);

        // Put Id into the current page Parameters
        ApexPages.currentPage().getParameters().put('val',compositeProduct.Id);
        
        ApexPages.StandardController con=new ApexPages.StandardController(compositeProduct);
        OSM_SW_Prod_TermsAndConditions_Ctrl condition=new OSM_SW_Prod_TermsAndConditions_Ctrl(); 
        
        //update condition;
        Test.StopTest();
        }
    }
    static testMethod void testOSM_SW_ProductDetailServiceCls2()
    {
        TestProductSetupReq testReq = OSM_TestDataCreationUtility.populatedTestProductSetupReq();
        
        TestCompletedTransactionSetUpRes objResponseProductSetup = OSM_TestDataCreationUtility.createProductSetUp(testReq);
        
        //System.debug('objResponseProductSetup: '+objResponseProductSetup);
        
        //TestCompletedTransactionSetUpRes transecRes = OSM_TestDataCreationUtility.createCompletedTransactionFlowTestData(objResponseProductSetup, 40, 6);
        
        //System.debug('transecRes: '+transecRes);
        System.runAs(usr){

        ccrz__E_Product__c compositeProduct=TestingUtils.createCompositeProduct(testReq.compositeProductName + '-1',testReq.compositeProductSKU + '-1',testReq.compositeProductGroupName,testReq.compositeProductProductType,true);
        compositeProduct.OSM_Term_and_Condition__c='quote';
        compositeProduct.name='test';
        upsert compositeProduct;
        
        ccrz__E_RequestForQuote__c rfq = TestingUtils.createRequestForQuote(1, 'In Progress', 20, 10, 100, 'Send', 'Test Data Comments', null, null, true)[0];
        rfq.Display_Product__c = compositeProduct.ID;
        upsert rfq;
        Test.StartTest();
        
        PageReference myVfPage = Page.OSM_SW_Prod_TermsAndConditionsPg;
        Test.setCurrentPage(myVfPage);

        // Put Id into the current page Parameters
        ApexPages.currentPage().getParameters().put('val','quote'+rfq.Id);
        
        ApexPages.StandardController con=new ApexPages.StandardController(compositeProduct);
        OSM_SW_Prod_TermsAndConditions_Ctrl condition=new OSM_SW_Prod_TermsAndConditions_Ctrl(); 
        condition.getProduct();
        condition.getReqForQuote();
        //update condition;
        Test.StopTest();
    }
    }
}