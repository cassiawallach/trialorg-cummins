@isTest
public class OSM_SW_CartItemTriggerFunctions_Test {

    static testMethod void cartItemTriggerFunctions_Test(){
    
    //Creating test data transaction 1 
   /* TestProductSetupReq testProductSetupReq1=OSM_TestDataCreationUtility.populatedTestProductSetupReq();
    TestProductSetupRes testProductSetupRes1=OSM_TestDataCreationUtility.createProductSetUp(testProductSetupReq1);
    TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes1=OSM_TestDataCreationUtility.createCompletedTransactionFlowTestData(testProductSetupRes1,20000.0, 10.0);*/
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
    ccrz__E_CartItem__c cartItem1=transecRes.cartItem;
    List<ccrz__E_CartItem__c> cartList=new List<ccrz__E_CartItem__c>();
    cartList.add(cartItem1);
    Map<id,ccrz__E_CartItem__c> cartItemMap=new Map<id,ccrz__E_CartItem__c>();
    cartItemMap.put(cartItem1.id,cartItem1);
    
    
    //calling logic from class
    Test.StartTest();
    //calling consturctors 
    OSM_SW_CartItemTriggerFunctions careItemFunctions1=new OSM_SW_CartItemTriggerFunctions(cartList);
    OSM_SW_CartItemTriggerFunctions careItemFunctions2=new OSM_SW_CartItemTriggerFunctions(cartList,cartItemMap); 
    //OSM_SW_TriggerMode triggerMode1=new OSM_SW_TriggerMode();
    
    OSM_SW_ProductDetaiServiceCls.DiscountedPriceWrapper availableSubs=new OSM_SW_ProductDetaiServiceCls.DiscountedPriceWrapper();
    availableSubs.isSubscribed=true;
    availableSubs.isRFQ=true;
        
    //Calling methods
    careItemFunctions1.updateDiscountedPrice(OSM_SW_TriggerMode.INSERT_MODE);
    careItemFunctions1.updateDiscountedPrice(cartList);
    
    
       
    Test.stopTest();
    }
    Catch(Exception ex){}
    }
     
}