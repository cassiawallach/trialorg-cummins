@isTest
public class OSM_SW_ccLogicCartCheckout_Test {
    static testMethod void testMethod1(){
        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';
        
        
        testReq.compositeProductName = 'Connected Diagnostics';
        testReq.compositeProductSKU = '123456-BUS';
        testReq.compositeProductGroupName = 'DA';
        testReq.compositeProductProductType = 'Aggregated';
        
        testReq.componentProductName = 'CD Base-BUS';
        testReq.componentProductStatus = 'Released';
        testReq.componentProductSKU = '130129-BUS';
        testReq.componentProductGroupName = 'DA';
        testReq.componentProductPackageName = 'Base';
        
        
        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';
        
        
        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
                                
        transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
        ccrz__E_Product__c prod=transecRes.objSetupDate.componentList[0];
        Account a =transecRes.objSetupDate.account;
        Contact c=transecRes.objSetupDate.contact;
       
    
System.runAs ( transecRes.objSetupDate.loggedInUser   ) {
        
            
        ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
        objRemotCtx.storefront='SoftwareStore';
        objRemotCtx.currentCartId=transecRes.cart.ccrz__EncryptedId__c;
        objRemotCtx.portalUserId=transecRes.objSetupDate.objUserID;
        objRemotCtx.effAccountId = transecRes.objSetupDate.account.id;    
        
        System.debug('transecRes.objSetupDate.account '+transecRes.objSetupDate.account );
        
        
    ccrz.cc_CallContext.initRemoteContext(objRemotCtx);}        
        ccrz__E_CartItem__c objItem = new ccrz__E_CartItem__c();
        objItem.Id =  transecRes.cartItem.Id;
        objItem.ccrz__Product__c =  transecRes.objSetupDate.componentList[0].Id;
        
        update objItem;
        
        ccrz__E_Cart__c newCartobj = new ccrz__E_Cart__c();
        newCartobj.Id = transecRes.cart.Id;
        newCartobj.ccrz__Account__c = transecRes.order.ccrz__Account__c;
        
        update newCartobj;
        
        
        ccrz__E_TransactionPayment__c updateTP = new ccrz__E_TransactionPayment__c();
        updateTP.OSM_Order_Update_Integration_Failure__c = true;
        updateTP.Id = transecRes.transactionPayment.Id;
        updateTP.ccrz__CCOrder__c = transecRes.order.Id;
        
        update updateTP;
        test.startTest();
        
        
        Map<String, Object> inputMap = new Map<String, Object>();
        ccrz.cc_bean_CartSummary cartSum = new ccrz.cc_bean_CartSummary(transecRes.cart);
       
        inputMap.put('version',7);
        inputMap.put('storefront','SoftwareStore');
        inputMap.put('ownerId',transecRes.objSetupDate.objUserID);
        inputMap.put('cartId',transecRes.cart.Id);
        inputMap.put('sizing','{cart={sz_assc=false, sz_data=sz_s, sz_skiptrz=true}}');
        inputMap.put('CartBean',cartSum );
        
        //List<ccrz__E_CartItem__c> cartLine1 = new List<ccrz__E_CartItem__c>();
        OSM_SW_ccLogicCartCheckout  cartvalidateObj = new OSM_SW_ccLogicCartCheckout();
        ccrz.cc_bean_CartSummary cartBeanSummary  = (ccrz.cc_bean_CartSummary)inputMap.get(ccrz.cc_api_CartExtension.PARAM_CARTBEAN);
        cartvalidateObj.allowCheckout(inputMap);
         cartvalidateObj.getCartMessages(inputMap);
         cartvalidateObj.validate(cartBeanSummary);
        
        test.stopTest();
        
    }
}