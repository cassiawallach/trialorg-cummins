@isTest
Public class OSM_SW_MyOrders_Comp_Ctrl_Test123{
 static testMethod void tetsMethod1(){
 
 User loggedInUser=[Select id from User where id=:UserInfo.getUserId()];     
 
/*TestProductSetupReq testReq = new TestProductSetupReq();
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

TestProductSetupRes objResponseProductSetup = new TestProductSetupRes();
objResponseProductSetup = OSM_TestDataCreationUtility.createProductSetUp(testReq);
System.debug('objResponseProductSetup: '+objResponseProductSetup);

TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
transecRes = OSM_TestDataCreationUtility.createCompletedTransactionFlowTestData(objResponseProductSetup, 40, 6);
System.debug('transecRes: '+transecRes);
//transecRes.cart.ccrz__EncryptedId__c = cartIdEncrypted;*/
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

        ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
        objRemotCtx.storefront='SoftwareStore';
        objRemotCtx.currentCartId=transecRes.cart.ccrz__EncryptedId__c;
        objRemotCtx.portalUserId=transecRes.objSetupDate.objUserID;

        ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
        
        try{
        test.StartTest();
         // Create RemoteActionContext Class Data 
         ccrz.cc_RemoteActionContext objRemoteClass=new ccrz.cc_RemoteActionContext();
         
        // Call Apex Class Methods
        OSM_SW_MyOrders_Comp_Ctrl.getOrderInfo(objRemoteClass,transecRes.order.id);
        
        
        // Stop Test
        test.StopTest();
        }
        Catch(Exception ex){}
}


}