@isTest
public class OSM_SW_ProductDetaiServiceCls_Test {

    static testMethod void testMethod1(){
    
       User adminUser = TestingUtils.ADMIN_USER;
        System.runAs(adminUser){
            UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
            
             // Query Profile Id
            List<Profile> listObjProfile = [Select id, name from profile where name = 'CloudBurst Customer Community Profile'];
            
            // Create User
            
              User objUser = [Select id from User where Id = :UserInfo.getUserId()];

            /*User objUser;
            
            if(listObjProfile.size() > 0){
                objUser = TestingUtils.createPortalUser('TestUserDA',portalRole.Id, listContact[0].Id, listObjProfile[0].Id, true);  
            }else{
                listObjProfile = [Select id, name from profile where name = 'Customer Community Plus User'];
                if(listObjProfile.size() > 0){
                    objUser = TestingUtils.createPortalUser('TestUserDA',portalRole.Id, listContact[0].Id, listObjProfile[0].Id, true); 
                }
            } 
            */
    //Creating test data transaction 1 
    //list<account> tstAcc = new list<Account>();
    Account acc = new Account();
    acc.name = 'OSM_Test_Acc';
    acc.OSM_Preferred_Payment_Method__c = 'PO';
    insert acc;
    //tstAcc.add(acc);
    //insert tstAcc;
        
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
        
        set<string> prodid = new set<string>();
        ccrz__E_Product__c prod = new ccrz__E_Product__c();
        prod.name = 'Connected Advisor';
        prod.ccrz__SKU__c = '15458776';
        prod.ccrz__Quantityperunit__c = 3343;
        prod.ccrz__StartDate__c = system.today();
        prod.ccrz__EndDate__c = system.today()+1;
        prod.ccrz__ShortDesc__c = 'testing';
        insert prod;
        String prodidstring = String.valueof(prod.id);
        prodid.add(prodidstring); 
         
        list<ccrz__E_ProductMedia__c>mlist = new list<ccrz__E_ProductMedia__c>(); 
        ccrz__E_ProductMedia__c media = new ccrz__E_ProductMedia__c();
        media.ccrz__Product__c = prod.id;
        media.ccrz__MediaType__c = 'Product Image Thumbnail';
        mlist.add(media);
        insert mlist;
        
        List<ccrz__E_RequestForQuote__c>quoteList = new List<ccrz__E_RequestForQuote__c>();
        ccrz__E_RequestForQuote__c req = new ccrz__E_RequestForQuote__c();
        //req.ccrz__Account__c = objResponseProductSetup.account.id;
        req.ccrz__Storefront__c = 'SoftwareStore';
        req.Display_Product__c = prod.id;
        req.Status__c = 'Requested';
        req.Expired_Date__c = system.today();
        req.Quantity__c = 2;
        //req.CC_Product__c = objResponseProductSetup.compositeProduct.id;
        quoteList.add(req);
        insert quoteList;
        
        List<ccrz__E_Subscription__c> subList = new List<ccrz__E_Subscription__c>();
        ccrz__E_Subscription__c sub = new ccrz__E_Subscription__c();
        sub.OSM_Display_Product__c = prod.id;
        sub.ccrz__Quantity__c = 10;
        sub.ccrz__Sequence__c = 2;
        sub.ccrz__Account__c = acc.id;
        sub.ccrz__Storefront__c ='storefront';
        //sub.ccrz__Storefront__c = 'SoftwareStore';
        sub.ccrz__SubscriptionStartDate__c  = system.today();
        sub.OSM_Subscription_End_Date__c  = System.today()+1;
        sub.ccrz__SubscriptionStatus__c = 'Active';
        sub.ccrz__SubscriptionProduct__c = prod.id;
        sub.OSM_Free_Trial__c =false;
        //sub.OSM_Display_Product__r.ccrz__ShortDesc__c = 'test description';
        subList.add(sub);
        insert subList;
        
//For remote action context 

ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
        objRemotCtx.storefront='SoftwareStore';
        objRemotCtx.currentCartId=transecRes.cart.ccrz__EncryptedId__c;
        objRemotCtx.portalUserId=transecRes.objSetupDate.objUserID;
        

        ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
         
                                //  System.debug(ccrz.cc_CallContext.currAccountId);

    ccrz__E_CartItem__c cartItem1=transecRes.cartItem;
    List<ccrz__E_CartItem__c> cartList=new List<ccrz__E_CartItem__c>();
    cartList.add(cartItem1);
    Map<id,ccrz__E_CartItem__c> cartItemMap=new Map<id,ccrz__E_CartItem__c>();
    cartItemMap.put(cartItem1.id,cartItem1);
    
    
    //calling logic from class
    Test.StartTest();
    //calling consturctors 
    
    //OSM_SW_TriggerMode triggerMode1=new OSM_SW_TriggerMode();
    Test.setMock(HttpCalloutMock.class, new OMS_SubmitOrder_Mock());
             OMS_SubmitOrder_Mock osmoc = new OMS_SubmitOrder_Mock();
        //Requ
        httpRequest res = new httpRequest();
        osmoc.respond(res);
    
    OSM_SW_ProductDetaiServiceCls.DiscountedPriceWrapper availableSubs=new OSM_SW_ProductDetaiServiceCls.DiscountedPriceWrapper();
    availableSubs.isSubscribed=true;
    availableSubs.isRFQ=true;
    availableSubs.hasValidQuote =true;
    availableSubs.subscriptionProduct='test';
    availableSubs.subscriptionStatus  = 'tets1';
    availableSubs.STP = 'test11';
    availableSubs.recurringPrice =1;
    
    //OSM_SW_ProdDetailUtils_Ctrl.getAccountSubscription(string.valueof(acc.id),'storefront');
    OSM_SW_ProductDetaiServiceCls.getDiscountedPrice('storefront',string.valueof(acc.id),prodid); 
    OSM_SW_ProductDetaiServiceCls.fetchDiscountedPrice('storefront',objUser.id,prodid);
    //List<ccrz__E_Subscription__c> accountSubscriptions = OSM_SW_ProdDetailUtils_Ctr.getAccountSubscription(string.valueof(acc.id),'test');
    Test.stopTest();
    }
}   
     static testMethod void testMethod1_N(){
    
    //Creating test data transaction 1 
    //list<account> tstAcc = new list<Account>();
    Account acc = new Account();
    acc.name = 'OSM_Test_Acc';
    acc.OSM_Preferred_Payment_Method__c = 'PO';
    insert acc;
    //tstAcc.add(acc);
    //insert tstAcc;
        
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
        
        set<string> prodid = new set<string>();
        ccrz__E_Product__c prod = new ccrz__E_Product__c();
        prod.name = 'Connected Advisor';
        prod.ccrz__SKU__c = '15458776';
        prod.ccrz__Quantityperunit__c = 3343;
        prod.ccrz__StartDate__c = system.today();
        prod.ccrz__EndDate__c = system.today()+1;
        prod.ccrz__ShortDesc__c = 'testing';
        insert prod;
        String prodidstring = String.valueof(prod.id);
        prodid.add(prodidstring);

        //set<string> prodid1 = new set<string>();
        ccrz__E_Product__c prod1 = new ccrz__E_Product__c();
        prod1.name = 'Connected Diagnostics';
        prod1.ccrz__SKU__c = '15458000';
        prod1.ccrz__Quantityperunit__c = 33;
        prod1.ccrz__StartDate__c = system.today();
        prod1.ccrz__EndDate__c = system.today()+1;
        prod1.ccrz__ShortDesc__c = 'testing11';
        insert prod1;
        //String prodidstring1 = String.valueof(prod1.id);
        //prodid1.add(prodidstring1);       
         
        list<ccrz__E_ProductMedia__c>mlist = new list<ccrz__E_ProductMedia__c>(); 
        ccrz__E_ProductMedia__c media = new ccrz__E_ProductMedia__c();
        media.ccrz__Product__c = prod.id;
        media.ccrz__MediaType__c = 'Product Image Thumbnail';
        mlist.add(media);
        insert mlist;
        
        List<ccrz__E_RequestForQuote__c>quoteList = new List<ccrz__E_RequestForQuote__c>();
        ccrz__E_RequestForQuote__c req = new ccrz__E_RequestForQuote__c();
        //req.ccrz__Account__c = objResponseProductSetup.account.id;
        req.ccrz__Storefront__c = 'SoftwareStore';
        req.Display_Product__c = prod.id;
        req.Status__c = 'Requested';
        req.Expired_Date__c = system.today();
        req.Quantity__c = 2;
        //req.CC_Product__c = objResponseProductSetup.compositeProduct.id;
        quoteList.add(req);
        insert quoteList;
        
        ccrz__E_SubProdTerm__c spt = new ccrz__E_SubProdTerm__c();
        spt.Billing_Display_Name__c = 'Monthly';
        spt.ccrz__CCProduct__c = prod.id;
        spt.ccrz__EffectiveEnd__c = system.now();
        spt.ccrz__EffectiveStart__c = system.now()+2;
        insert spt;
        
        List<ccrz__E_Subscription__c> subList = new List<ccrz__E_Subscription__c>();
        ccrz__E_Subscription__c sub = new ccrz__E_Subscription__c();
        sub.OSM_Display_Product__c = prod.id;
        sub.ccrz__Quantity__c = 10;
        sub.ccrz__Sequence__c = 2;
        sub.ccrz__Account__c = acc.id;
        sub.ccrz__Storefront__c ='storefront';
        //sub.ccrz__Storefront__c = 'SoftwareStore';
        sub.ccrz__SubscriptionStartDate__c  = system.today();
        sub.OSM_Subscription_End_Date__c  = System.today()+1;
        sub.ccrz__SubscriptionStatus__c = 'Active';
       sub.ccrz__SubscriptionProduct__c = prod1.id;
       sub.ccrz__SPT__c = spt.id;
        sub.OSM_Free_Trial__c =false;
        //sub.OSM_Display_Product__r.ccrz__ShortDesc__c = 'test description';
        subList.add(sub);
        insert subList;
        
//For remote action context 

ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
        objRemotCtx.storefront='SoftwareStore';
        objRemotCtx.currentCartId=transecRes.cart.ccrz__EncryptedId__c;
        objRemotCtx.portalUserId=transecRes.objSetupDate.objUserID;
        

        ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
         
                                //  System.debug(ccrz.cc_CallContext.currAccountId);

    ccrz__E_CartItem__c cartItem1=transecRes.cartItem;
    List<ccrz__E_CartItem__c> cartList=new List<ccrz__E_CartItem__c>();
    cartList.add(cartItem1);
    Map<id,ccrz__E_CartItem__c> cartItemMap=new Map<id,ccrz__E_CartItem__c>();
    cartItemMap.put(cartItem1.id,cartItem1);
    
    
    //calling logic from class
    Test.StartTest();
    Test.setMock(HttpCalloutMock.class, new OMS_SubmitOrder_Mock());
    //calling consturctors 
    
    //OSM_SW_TriggerMode triggerMode1=new OSM_SW_TriggerMode();
    
    OSM_SW_ProductDetaiServiceCls.DiscountedPriceWrapper availableSubs=new OSM_SW_ProductDetaiServiceCls.DiscountedPriceWrapper();
    availableSubs.isSubscribed=true;
    availableSubs.isRFQ=true;
    availableSubs.hasValidQuote =true;
    availableSubs.subscriptionProduct='test';
    availableSubs.subscriptionStatus  = 'tets1';
    availableSubs.STP = 'test11';
    availableSubs.recurringPrice =1;
    
    //OSM_SW_ProdDetailUtils_Ctrl.getAccountSubscription(string.valueof(acc.id),'storefront');
    OSM_SW_ProductDetaiServiceCls.getDiscountedPrice('storefront',string.valueof(acc.id),prodid); 
    //List<ccrz__E_Subscription__c> accountSubscriptions = OSM_SW_ProdDetailUtils_Ctr.getAccountSubscription(string.valueof(acc.id),'test');
    Test.stopTest();
    }
    
    static testMethod void testMethod2(){
    
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
         
        //  System.debug(ccrz.cc_CallContext.currAccountId);

    ccrz__E_CartItem__c cartItem1=transecRes.cartItem;
    List<ccrz__E_CartItem__c> cartList=new List<ccrz__E_CartItem__c>();
    cartList.add(cartItem1);
    Map<id,ccrz__E_CartItem__c> cartItemMap=new Map<id,ccrz__E_CartItem__c>();
    cartItemMap.put(cartItem1.id,cartItem1);
    
    //calling logic from class
    Test.StartTest();
    Test.setMock(HttpCalloutMock.class, new OMS_SubmitOrder_Mock());
    //calling consturctors 
    
    //OSM_SW_TriggerMode triggerMode1=new OSM_SW_TriggerMode();
    
    OSM_SW_ProductDetaiServiceCls.DiscountedPriceWrapper availableSubs=new OSM_SW_ProductDetaiServiceCls.DiscountedPriceWrapper();
    availableSubs.isSubscribed=false;
    availableSubs.isRFQ=false;
    availableSubs.hasValidQuote =false;
    //availableSubs.subscriptionProduct='test';
    //availableSubs.subscriptionStatus  = 'tets1';
    //availableSubs.STP = 'test11';
    //availableSubs.recurringPrice =1;
    OSM_SW_ProductDetaiServiceCls.getSegmentSku('DEF');
    
    //OSM_SW_ProductDetaiServiceCls.getDiscountedPrice

    Test.stopTest();
    }
     
}