//Test Class of OSM_SW_OrderTriggerHandlerUtility
/***********************************************/
@isTest
public class OSM_SW_OrderTriggerHandlerUtility_Test {
    
    public static User loggedInUser=OSM_TestDataCreationUtility.getPortalUser();
    static testMethod void revokeInvoice_test(){
        
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
        System.Runas(loggedInUser){
            Test.StartTest();
            //For remote action context 
            ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
            objRemotCtx.storefront='SoftwareStore';
            objRemotCtx.currentCartId=transecRes.cart.ccrz__EncryptedId__c;
            OSM_SW_Invoice_Comp_Ctrl.revokeInvoice(objRemotCtx,transecRes.invoice.Id);
            Test.StopTest();
        }
    }
    static testMethod void revokeInvoiceWithNullStatus(){
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
        
        System.RunAs(loggedInUser){
            Test.StartTest();
            //For remote action context 
            
            ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
            objRemotCtx.storefront='SoftwareStore';
            objRemotCtx.currentCartId=transecRes.cart.ccrz__EncryptedId__c;
            // objRemotCtx.portalUserId=transecRes.objSetupDate.objUserID;
            objRemotCtx.userLocale='en_US';
            
            //   ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
            
            OSM_SW_Invoice_Comp_Ctrl.revokeInvoice(objRemotCtx,null);
            Test.StopTest();
        }
        
    }
    
}