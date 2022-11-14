//This is the test class for the class OSM_SW_MyAccount_ContactInfo_Comp_Ctrl 
@IsTest(seeAllData=true)
public class OSM_SW_MyAccountContactInfoCompCtrl_Test{
    public static testMethod void testMethod1(){
        //User loggedInUser=[Select id from User where id=:UserInfo.getUserId()];
        
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
        
        
        System.debug('transecRes: '+transecRes);
        
        //For remote action context 
        Test.StartTest();
        ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
        objRemotCtx.storefront='SoftwareStore';
        objRemotCtx.currentCartId=transecRes.cart.ccrz__EncryptedId__c;
        objRemotCtx.portalUserId=transecRes.objSetupDate.objUserID;
        
        objRemotCtx.userLocale='en_US';
        ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
        OSM_SW_MyAccount_ContactInfo_Comp_Ctrl.getBillingFreq(objRemotCtx);
        OSM_SW_MyAccount_ContactInfo_Comp_Ctrl.updateBillingFreq(objRemotCtx,'Quarterly');
        Test.StopTest();
    }
    
   
  
}