@isTest
global class OSM_SW_ccLogicCartValidate_Test{
    //For Product Interface Test
    global class SingleRequestMockProductPass implements HttpCalloutMock {
           
            global HTTPResponse respond(HTTPRequest req) {
                HttpResponse resp = new HttpResponse();
                resp.setStatusCode(200);
                resp.setBody('{"customerID":"390","productSubscriptionInfo":[{"productID":"1234567","availableCount":0,"totalSubscriptionCount":2069},{"productID":"2345678","message":"Not supported by equipment"},{"productID":"4567890","message":"Not supported by equipment"},{"productID":"5678901","availableCount":0,"totalSubscriptionCount":14}]}');
                return resp;
            }
    }   
    


    static testMethod void validateTest(){
    TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';
        
        
        testReq.compositeProductName = 'Connected Diagnostics';
        testReq.compositeProductSKU = '12345671-BUS';
        testReq.compositeProductGroupName = 'DA';
        testReq.compositeProductProductType = 'Aggregated';
        
        testReq.componentProductName = 'CD Base-BUS';
        testReq.componentProductStatus = 'Released';
        testReq.componentProductSKU = '13012981-BUS';
        testReq.componentProductGroupName = 'DA';
        testReq.componentProductPackageName = 'Base';
        
        
        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';
        
        
        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
        transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
        
        
        
        
        
        
        ccrz__E_CartItem__c objItem = new ccrz__E_CartItem__c();
        objItem.Id =  transecRes.cartItem.Id;
        objItem.ccrz__Quantity__c = 100;
        
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
        
        
        System.debug('CCCCCCCCCCCCCCCCc: '+transecRes.cart);
        System.debug('CCCCCCCCCCCCCCCCc: '+transecRes.cartItem);
        System.debug('CCCCCCCCCCCCCCCCc: '+transecRes.orderItem);
        System.debug('CCCCCCCCCCCCCCCCc: '+objItem);
        System.debug('CCCCCCCCCCCCCCCCc: '+transecRes.order);
        
 
        ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
        objRemotCtx.storefront='SoftwareStore';
        objRemotCtx.currentCartId=transecRes.cart.ccrz__EncryptedId__c;
        objRemotCtx.portalUserId=transecRes.objSetupDate.objUserID;
        
        ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
        
        Map<String, Object> inputMap = new Map<String, Object>();
        ccrz.cc_bean_CartSummary cartSum = new ccrz.cc_bean_CartSummary(transecRes.cart);
        Test.setMock(HttpCalloutMock.class, new SingleRequestMockProductPass());
        inputMap.put('version',7);
        inputMap.put('storefront','SoftwareStore');
        inputMap.put('ownerId',transecRes.objSetupDate.objUserID);
        inputMap.put('cartId',transecRes.cart.Id);
        inputMap.put('sizing','{cart={sz_assc=false, sz_data=sz_s, sz_skiptrz=true}}');
        inputMap.put('CartBean',cartSum );
        
         //List<ccrz__E_CartItem__c> cartLine1 = new List<ccrz__E_CartItem__c>();
        OSM_SW_ccLogicCartValidate  cartvalidateObj = new OSM_SW_ccLogicCartValidate();
        try{
            cartvalidateObj.processValidate(inputMap);
            
        }
        Catch(Exception ex){}
        //cartvalidateObj.fatchAccountDetails(transecRes.cart.Id);
        List<ccrz__E_CartItem__c> cartLine = [Select Id,ccrz__Quantity__c,OSM_Group_Name__c, ccrz__Cart__c, ccrz__Product__c, ccrz__DisplayProduct__c, ccrz__DisplayProduct__r.ccrz__SKU__c, ccrz__Product__r.ccrz__SKU__c from ccrz__E_CartItem__c where Id =: objItem.Id];
        cartLine.add(transecRes.cartItem);
        
        ccrz__E_Cart__c newCartobj1 = new ccrz__E_Cart__c();
        newCartobj1.Id = transecRes.cart.Id;
        newCartobj1.OSM_SW_isInvalid_Done__c = true;
        
        update newCartobj1;
        
        cartvalidateObj.validate(transecRes.cart.Id,cartLine);
        cartvalidateObj.validate1(transecRes.cart.Id,cartLine);
    }
    
    static testMethod void validateTest2(){
     TestProductSetupReq testProductSetupReq = new TestProductSetupReq();
        testProductSetupReq.permissionSetName = 'OSM_Support_Admin';
        
        testProductSetupReq.accountGroupName = 'TestingAccountGroup';
        testProductSetupReq.accountName = 'TestingAccount';
        
        
        testProductSetupReq.compositeProductName = 'Connected Diagnostics';
        testProductSetupReq.compositeProductSKU = '12345671-BUS';
        testProductSetupReq.compositeProductGroupName = 'DA';
        testProductSetupReq.compositeProductProductType = 'Aggregated';
        
        testProductSetupReq.componentProductName = 'CD Base-BUS';
        testProductSetupReq.componentProductStatus = 'Released';
        testProductSetupReq.componentProductSKU = '13012981-BUS';
        testProductSetupReq.componentProductGroupName = 'DA';
        testProductSetupReq.componentProductPackageName = 'Base';
        
        
        testProductSetupReq.priceListName = 'TestPriceList';
        testProductSetupReq.specName = 'TestName';
        
    TestProductSetupRes testProductSetupRes = new TestProductSetupRes();
    UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
        UserRoleId = portalRole.Id,
        ProfileId = profile1.id,
        Username = System.now().millisecond() + 'test2@orgtestclass.com',
        Alias = 'batman',
        Email='bruce.wayne@wayneenterprises.com',
        EmailEncodingKey='UTF-8',
        Firstname='Bruce',
        Lastname='Wayne',
        LanguageLocaleKey='en_US',    
        LocaleSidKey='en_US',
        TimeZoneSidKey='America/Chicago'
        );
        Database.insert(portalAccountOwner1);
        
        testProductSetupRes.loggedInUser =portalAccountOwner1;
        System.runAs ( portalAccountOwner1 ) {
        
        // till here
        
            if(null != testProductSetupReq && null != testProductSetupReq.permissionSetName 
               && null != testProductSetupReq.accountGroupName && null != testProductSetupReq.accountName 
               && null != testProductSetupReq.compositeProductName && null != testProductSetupReq.compositeProductSKU 
               && null != testProductSetupReq.compositeProductGroupName && null != testProductSetupReq.compositeProductProductType 
               && null != testProductSetupReq.componentProductName && null != testProductSetupReq.componentProductStatus 
               && null != testProductSetupReq.componentProductSKU && null != testProductSetupReq.componentProductGroupName 
               && null != testProductSetupReq.componentProductPackageName && null != testProductSetupReq.priceListName 
               && null != testProductSetupReq.specName)
            {
                
                
                //example
                //testProductSetupReq.permissionSetName = 'OSM_Business_Admin';
                
                // get User ID of a particular permission set
                List<PermissionSetAssignment> lstcurrentUserPerSet = [SELECT Id, PermissionSet.Name, AssigneeId 
                                                                      FROM PermissionSetAssignment 
                                                                      WHERE PermissionSet.Name = :testProductSetupReq.permissionSetName];
                
                //ID objUserID = lstcurrentUserPerSet[0].AssigneeId;
                
                ID objUserID;
                
                if(null != objUserID)
                {
                    // create products - product, spec, category, subprodterms, pricelists
                    
                    //Create Account Group
                    List<ccrz__E_AccountGroup__c> listAccountGrp = TestingUtils.createAccountGroup(1, testProductSetupReq.accountGroupName, 'Best Price', true);
                    
                    //Create Account
                    List<Account> listAccount = TestingUtils.createAccount(1, testProductSetupReq.accountName, listAccountGrp[0].Id, objUserID, true) ;
                    
                    //Create Contact
                    List<Contact> listContact  = TestingUtils.createContact(1, listAccount[0].Id, objUserID, true);
                    
                    Profile portalProfile = [SELECT Id FROM Profile where name = 'IAM_Site_Admin_Community' Limit 1];
                    User user1 = new User(
                    Username = System.now().millisecond() + 'test12345@test.com',
                    ContactId = listContact[0].Id,
                    ProfileId = portalProfile.Id,
                    Alias = 'test123',
                    Email = 'test12345@test.com',
                    EmailEncodingKey = 'UTF-8',
                    LastName = 'McTesty',
                    CommunityNickname = 'test12345',
                    TimeZoneSidKey = 'America/Los_Angeles',
                    LocaleSidKey = 'en_US',
                    LanguageLocaleKey = 'en_US'
                    );
                    Database.insert(user1);
                    objUserID = user1.Id;
                    
                  
                    
                    
                    //Create single Product to pass as Composite (Main Product)
                    ccrz__E_Product__c compositeProduct = TestingUtils.createCompositeProduct(testProductSetupReq.compositeProductName, testProductSetupReq.compositeProductSKU, testProductSetupReq.compositeProductGroupName, testProductSetupReq.compositeProductProductType, true);
                    
                    //Create List of Component Products
                    List<ccrz__E_Product__c> lstComponentProductsCombined = new List<ccrz__E_Product__c>();
                    List<ccrz__E_Product__c> lstComponentProductsBase = TestingUtils.createCcComponentProducts(1, testProductSetupReq.componentProductName, testProductSetupReq.componentProductStatus, 1, testProductSetupReq.componentProductSKU, testProductSetupReq.componentProductGroupName, testProductSetupReq.componentProductPackageName, true);
                    
                    lstComponentProductsCombined.addAll(lstComponentProductsBase);
                    
                    //Create CC Composite Product
                    List<ccrz__E_CompositeProduct__c> listCcCompositeProducts = TestingUtils.createCcCompProducts(compositeProduct.Id, lstComponentProductsCombined, true);
                    
                    // Create E SubProdTerm for composite product
                    List<ccrz__E_SubProdTerm__c> lstESubProdTerm = new List<ccrz__E_SubProdTerm__c>();
                    lstESubProdTerm.addAll(TestingUtils.createSubProdTerm(1, 'TestSubProdTerm ' + testProductSetupReq.compositeProductName, lstComponentProductsBase[0].Id, '*', true));
                    
                    // Create PriceList
                    List<ccrz__E_PriceList__c> lstPriceList = TestingUtils.createPriceList(1, testProductSetupReq.priceListName, 'SoftwareStore', true, 'USD', true);
                    
                    //Create Price List Item
                    List<ccrz__E_PriceListItem__c> lstPriceListItem = TestingUtils.createPriceListItem(1,lstESubProdTerm[0].Id, lstPriceList, lstComponentProductsCombined, true);
                    
                    //Create Account Group PriceList
                    List<ccrz__E_AccountGroupPriceList__c> lstAccGrpPriceList = TestingUtils.createAccGrpPriceList(1, listAccountGrp, lstPriceList, true, 500, true);
                    
                    // Create CC Spec
                    List<ccrz__E_Spec__c> lstCcSpec = TestingUtils.createCcSpecs(1, testProductSetupReq.specName, true);
                    
                    // Create CC Product Spec
                    List<ccrz__E_ProductSpec__c> lstCcProdSpec = TestingUtils.createCcProductSpecs(1, compositeProduct.Id, lstCcSpec, true);
                    
                    
                    testProductSetupRes.objUserID = objUserID;
                    
                    testProductSetupRes.accountGroup = listAccountGrp[0];
                    testProductSetupRes.account = listAccount[0];
                    testProductSetupRes.contact = listContact[0];
                    
                    testProductSetupRes.compositeProduct = compositeProduct;
                    testProductSetupRes.componentList = new List<ccrz__E_Product__c>();
                    testProductSetupRes.componentList.addAll(lstComponentProductsBase);
                    
                    testProductSetupRes.compositeProductObjectList = new List<ccrz__E_CompositeProduct__c>();
                    testProductSetupRes.compositeProductObjectList.addAll(listCcCompositeProducts);
                    
                    testProductSetupRes.priceList = lstPriceList[0];
                    testProductSetupRes.subProdTermList = new List<ccrz__E_SubProdTerm__c>();
                    testProductSetupRes.subProdTermList.addAll(lstESubProdTerm);
                    testProductSetupRes.priceListItemList = new List<ccrz__E_PriceListItem__c>();
                    testProductSetupRes.priceListItemList.addAll(lstPriceListItem);
                    
                    TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes = new TestCompletedTransactionSetUpRes();
                    
                    testCompletedTransactionSetUpRes = OSM_TestDataCreationUtility.createCompletedTransactionFlowTestData(testProductSetupRes, 40,6);
                    
                    testCompletedTransactionSetUpRes.objSetupDate = new TestProductSetupRes();
                    
                    testCompletedTransactionSetUpRes.objSetupDate = testProductSetupRes;
                    
                    //return testCompletedTransactionSetUpRes;
                }
                else
                {
                    System.debug('Null value present in request');
                }
            }
            else
            {
                System.debug('Invalid Permission set');
            }
        }
    }
    
    static testMethod void validateTest4(){
    TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';
        
        
        testReq.compositeProductName = 'Connected Diagnostics';
        testReq.compositeProductSKU = '12345671-BUS';
        testReq.compositeProductGroupName = 'DA';
        testReq.compositeProductProductType = 'Aggregated';
        
        testReq.componentProductName = 'CD Base-BUS';
        testReq.componentProductStatus = 'Released';
        testReq.componentProductSKU = '13012981-BUS';
        testReq.componentProductGroupName = 'DA';
        testReq.componentProductPackageName = 'Base';
        
        
        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';
        
        
        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
        transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
 /*
        CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'DA';
        csInt.End_Point__c='https://services-dev.cummins.com/cso/taxquote';
        csInt.IsActive__c=true;
        csInt.AuthEnv__c='DA';
        csInt.Method_Type__c='POST';
        csInt.Timeout__c=120000;
        csInt.Key__c='HHUCc6LbYV4PgjbWwTPZpiTSOTpgyahZLNTgiTYdoCo';
        csInt.Username__c='z2ZbvUV4C3RpoOIoPJ0a4lM';
        csInt.Passcode__c='gosTUpBxi0Ns6mUc/bmioYDfwFzFm+66sNrW30B5Dpo=';
        insert csint;
        
        CSS_Integration_Details__c csInt1 = new CSS_Integration_Details__c();
        csInt1.name = 'COSM-Product';
        csInt1.End_Point__c='https://services-dev.cummins.com/cso/taxquote';
        csInt1.IsActive__c=true;
        csInt1.AuthEnv__c='COSM-Product';
        csInt1.Method_Type__c='POST';
        csInt1.Timeout__c=120000;
        csInt1.Key__c='HHUCc6LbYV4PgjbWwTPZpiTSOTpgyahZLNTgiTYdoCo';
        csInt1.Username__c='z2ZbvUV4C3RpoOIoPJ0a4lM';
        csInt1.Passcode__c='gosTUpBxi0Ns6mUc/bmioYDfwFzFm+66sNrW30B5Dpo=';
        insert csInt1;
        
        */
        
        ccrz__E_CartItem__c objItem = new ccrz__E_CartItem__c();
        objItem.Id =  transecRes.cartItem.Id;
      objItem.ccrz__Quantity__c = 100;
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
        
        
        System.debug('CCCCCCCCCCCCCCCCc: '+transecRes.cart);
        System.debug('CCCCCCCCCCCCCCCCc: '+transecRes.cartItem);
        System.debug('CCCCCCCCCCCCCCCCc: '+transecRes.orderItem);
        System.debug('CCCCCCCCCCCCCCCCc: '+objItem);
        System.debug('CCCCCCCCCCCCCCCCc: '+transecRes.order);
        
 
        ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
        objRemotCtx.storefront='SoftwareStore';
        objRemotCtx.currentCartId=transecRes.cart.ccrz__EncryptedId__c;
        objRemotCtx.portalUserId=transecRes.objSetupDate.objUserID;
        
        ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
        
        Map<String, Object> inputMap = new Map<String, Object>();
        ccrz.cc_bean_CartSummary cartSum = new ccrz.cc_bean_CartSummary(transecRes.cart);
        Test.setMock(HttpCalloutMock.class, new SingleRequestMockProductPass());
        inputMap.put('version',7);
        inputMap.put('storefront','SoftwareStore');
        inputMap.put('ownerId',transecRes.objSetupDate.objUserID);
        inputMap.put('cartId',transecRes.cart.Id);
        inputMap.put('sizing','{cart={sz_assc=false, sz_data=sz_s, sz_skiptrz=true}}');
        inputMap.put('CartBean',cartSum );
        
         //List<ccrz__E_CartItem__c> cartLine1 = new List<ccrz__E_CartItem__c>();
        OSM_SW_ccLogicCartValidate  cartvalidateObj = new OSM_SW_ccLogicCartValidate();
        try{
            cartvalidateObj.processValidate(inputMap);
            
        }
        Catch(Exception ex){}
        cartvalidateObj.fatchAccountDetails(transecRes.cart.Id);
        List<ccrz__E_CartItem__c> cartLine = [Select Id,ccrz__Quantity__c,OSM_Group_Name__c, ccrz__Cart__c, ccrz__Product__c, ccrz__DisplayProduct__c, ccrz__DisplayProduct__r.ccrz__SKU__c, ccrz__Product__r.ccrz__SKU__c from ccrz__E_CartItem__c where Id =: objItem.Id];
        cartLine.add(transecRes.cartItem);
        cartvalidateObj.checkTransectionFailedStatus(cartLine);
        cartvalidateObj.getProoductSubc(transecRes.cart.Id);
        cartvalidateObj.fetchRes.put('cartList',new List<ccrz__E_Cart__c>{transecRes.cart});
        cartvalidateObj.mapCartItem.put(cartLine[0].id,cartLine[0]);
        
        
        cartvalidateObj.validate(transecRes.cart.id,cartLine);
        cartvalidateObj.validate1(transecRes.cart.id,cartLine);
        
        ccrz__E_Cart__c newCartobj1 = new ccrz__E_Cart__c();
        newCartobj1.Id = transecRes.cart.Id;
        newCartobj1.OSM_SW_isInvalid_Done__c = true;
        test.starttest();
        update newCartobj1;
        test.stoptest();
        cartvalidateObj.validate(transecRes.cart.Id,cartLine);
        cartvalidateObj.validate1(transecRes.cart.Id,cartLine);
    }
    static testMethod void validateTest5(){
    TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';
        
        
        testReq.compositeProductName = 'Connected Diagnostics';
        testReq.compositeProductSKU = '12345671-BUS';
        testReq.compositeProductGroupName = 'DA';
        testReq.compositeProductProductType = 'Aggregated';
        
        testReq.componentProductName = 'CD Base-BUS';
        testReq.componentProductStatus = 'Released';
        testReq.componentProductSKU = '13012981-BUS';
        testReq.componentProductGroupName = 'DA';
        testReq.componentProductPackageName = 'Base';
        
        
        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';
        
        
        Account acc = new Account();
                RecordType recid =[select id from recordType where name='wwsps' limit 1];  
                acc.RecordTypeId= recid.id;       
                acc.Name = 'Test Account';
                acc.CMI_Account_Status__c = 'Active';
                acc.CMI_CDA_Status__c = 'New Customer Request';
                acc.CMI_Region__c = 'NORTH AMERICA';
                acc.CSS_Language__c = 'English';              
                insert acc;
                
        ccrz__E_Order__c order = new ccrz__E_Order__c();
            order.ccrz__Account__c = acc.id;
            order.OSM_SW_Should_mail_Send__c = true;
            order.OSM_SW_Is_InterCompany_Order__c = false;
            order.ccrz__OrderStatus__c='Order Submitted';
            
            insert order;
            
             set<string> prodid = new set<string>();
            ccrz__E_Product__c prod = new ccrz__E_Product__c();
            prod.name = 'Service Tech Kit';
            prod.ccrz__SKU__c = '15458771';
            prod.ccrz__Quantityperunit__c = 3343;
            prod.ccrz__StartDate__c = system.today();
            prod.ccrz__EndDate__c = system.today()+1;
            prod.ccrz__ShortDesc__c = 'testing';
            prod.ccrz__ProductType__c = 'Add-On';
            insert prod;
        
        ccrz__E_OrderItem__c bundleOrderItem = new ccrz__E_OrderItem__c();
            bundleOrderItem.ccrz__Order__c = order.ID;
            bundleOrderItem.ccrz__Quantity__c = 1;
                bundleOrderItem.ccrz__Product__c = prod.id;
            bundleOrderItem.ccrz__DisplayProduct__c = prod.id;
            bundleOrderItem.Number_of_Bundles__c = 0;
            bundleOrderItem.Number_of_Counts__c = 0;
            bundleOrderItem.ccrz__Price__c = 15.00;
            bundleOrderItem.ccrz__SubAmount__c = 15.00;
            bundleOrderItem.OSM_SW_Is_without_Coterm__c= false;
            insert bundleOrderItem;
        
        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
        transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
 
        ccrz__E_CartItem__c objItem = new ccrz__E_CartItem__c();
        objItem.Id =  transecRes.cartItem.Id;
        objItem.ccrz__Quantity__c = 100;
        
        objItem.ccrz__Product__c =  prod.Id;
        
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
        
        
        System.debug('CCCCCCCCCCCCCCCCc: '+transecRes.cart);
        System.debug('CCCCCCCCCCCCCCCCc: '+transecRes.cartItem);
        System.debug('CCCCCCCCCCCCCCCCc: '+transecRes.orderItem);
        System.debug('CCCCCCCCCCCCCCCCc: '+objItem);
        System.debug('CCCCCCCCCCCCCCCCc: '+transecRes.order);
        
 
        ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
        objRemotCtx.storefront='SoftwareStore';
        objRemotCtx.currentCartId=transecRes.cart.ccrz__EncryptedId__c;
        objRemotCtx.portalUserId=transecRes.objSetupDate.objUserID;
        
        ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
        
        Map<String, Object> inputMap = new Map<String, Object>();
        ccrz.cc_bean_CartSummary cartSum = new ccrz.cc_bean_CartSummary(transecRes.cart);
        Test.setMock(HttpCalloutMock.class, new SingleRequestMockProductPass());
        inputMap.put('version',7);
        inputMap.put('storefront','SoftwareStore');
        inputMap.put('ownerId',transecRes.objSetupDate.objUserID);
        inputMap.put('cartId',transecRes.cart.Id);
        inputMap.put('sizing','{cart={sz_assc=false, sz_data=sz_s, sz_skiptrz=true}}');
        inputMap.put('CartBean',cartSum );
        
         //List<ccrz__E_CartItem__c> cartLine1 = new List<ccrz__E_CartItem__c>();
        OSM_SW_ccLogicCartValidate  cartvalidateObj = new OSM_SW_ccLogicCartValidate();
        try{
            cartvalidateObj.processValidate(inputMap);
            
        }
        Catch(Exception ex){}
        cartvalidateObj.fatchAccountDetails(transecRes.cart.Id);
        List<ccrz__E_CartItem__c> cartLine = [Select Id,ccrz__Quantity__c,OSM_Group_Name__c, ccrz__Cart__c, ccrz__Product__c, ccrz__DisplayProduct__c, ccrz__DisplayProduct__r.ccrz__SKU__c, ccrz__Product__r.ccrz__SKU__c from ccrz__E_CartItem__c where Id =: objItem.Id];
        cartLine.add(transecRes.cartItem);
        cartvalidateObj.checkTransectionFailedStatus(cartLine);
        cartvalidateObj.getProoductSubc(transecRes.cart.Id);
        cartvalidateObj.fetchRes.put('cartList',new List<ccrz__E_Cart__c>{transecRes.cart});
        cartvalidateObj.mapCartItem.put(cartLine[0].id,cartLine[0]);
        
        
        cartvalidateObj.validate(transecRes.cart.id,cartLine);
        cartvalidateObj.validate1(transecRes.cart.Id,cartLine);
        
        ccrz__E_Cart__c newCartobj1 = new ccrz__E_Cart__c();
        newCartobj1.Id = transecRes.cart.Id;
        newCartobj1.OSM_SW_isInvalid_Done__c = true;
        test.starttest();
        update newCartobj1;
        test.stoptest();
        cartvalidateObj.validate(transecRes.cart.Id,cartLine);
        cartvalidateObj.validate1(transecRes.cart.Id,cartLine);
    }
    
  static testMethod void validateTest1(){
    TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';
        
        
        testReq.compositeProductName = 'Connected Diagnostics';
        testReq.compositeProductSKU = '12345671-BUS';
        testReq.compositeProductGroupName = 'DA';
        testReq.compositeProductProductType = 'Aggregated';
        
        testReq.componentProductName = 'CD Base-BUS';
        testReq.componentProductStatus = 'Released';
        testReq.componentProductSKU = '13012981-BUS';
        testReq.componentProductGroupName = 'DA';
        testReq.componentProductPackageName = 'Base';
        
        
        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';
        
        ccrz__E_Product__c ccCompositeProduct1 = new ccrz__E_Product__c();
       
        ccCompositeProduct1.name = 'testProd1';
        ccCompositeProduct1.ccrz__ProductStatus__c = 'Released';
        ccCompositeProduct1.ccrz__Quantityperunit__c = 1;
        ccCompositeProduct1.ccrz__SKU__c = '1301298-BUS';
        ccCompositeProduct1.ccrz__StartDate__c = System.today().addMonths(-1);
        ccCompositeProduct1.ccrz__EndDate__c = System.today().addMonths(4);
        ccCompositeProduct1.Group_Name__c = 'DA';
        ccCompositeProduct1.ccrz__LongDesc__c = 'Long Description';
        ccCompositeProduct1.ccrz__ProductType__c = 'Bundle';
        ccCompositeProduct1.Product_Class_Code__c = 'SW-Web Access';
        ccCompositeProduct1.QSOL_Power_Generation__c=True;
        insert ccCompositeProduct1;
 
        
        
        
        
        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
        transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
        
        ccrz__E_CartItem__c testCartItem1 = new ccrz__E_CartItem__c();
            testCartItem1.ccrz__Cart__c = transecRes.cart.id;
            testCartItem1.ccrz__Quantity__c = 100;
            testCartItem1.ccrz__OriginalQuantity__c = 100;
            testCartItem1.ccrz__Product__c =ccCompositeProduct1.id ;
            testCartItem1.ccrz__SubProdTerm__c =transecRes.objSetupDate.subProdTermList[0].id;
            testCartItem1.ccrz__Price__c = 100;
            testCartItem1.ccrz__RecurringPrice__c = 100;
            testCartItem1.ccrz__RecurringPriceSubAmt__c = 100;
            //testCartItem1.ccrz__StoreID__c = storefront;
            testCartItem1.ccrz__OriginalItemPrice__c = 100;
            testCartItem1.ccrz__DisplayProduct__c = ccCompositeProduct1.id;
            testCartItem1.ccrz__ProductType__c = 'Product';
            testCartItem1.ccrz__cartItemType__c = 'Cart';
            testCartItem1.ccrz__SubAmount__c = 100;
            testCartItem1.ccrz__Subscription_Duration__c = 12;
            testCartItem1.ccrz__Subscription_Frequency__c = 4;
            testCartItem1.ccrz__UnitOfMeasure__c = 'cm';
            testCartItem1.ccrz__StoreID__c = 'SoftwareStore';
            insert testCartItem1;
        
        ccrz__E_Cart__c newCartobj = new ccrz__E_Cart__c();
        newCartobj.Id = transecRes.cart.Id;
        newCartobj.ccrz__Account__c = transecRes.order.ccrz__Account__c;
        
        update newCartobj;
        
        
        ccrz__E_TransactionPayment__c updateTP = new ccrz__E_TransactionPayment__c();
        updateTP.OSM_Order_Update_Integration_Failure__c = true;
        updateTP.Id = transecRes.transactionPayment.Id;
        updateTP.ccrz__CCOrder__c = transecRes.order.Id;
        
        update updateTP;
 
        ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
        objRemotCtx.storefront='SoftwareStore';
        objRemotCtx.currentCartId=transecRes.cart.ccrz__EncryptedId__c;
        objRemotCtx.portalUserId=transecRes.objSetupDate.objUserID;
        
        ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
        
        Map<String, Object> inputMap = new Map<String, Object>();
        ccrz.cc_bean_CartSummary cartSum = new ccrz.cc_bean_CartSummary(transecRes.cart);
        Test.setMock(HttpCalloutMock.class, new SingleRequestMockProductPass());
       
       inputMap.put('placeStep', 'end');
            //inputMap.put('cartId', transecRes.cart.Id);
            inputMap.put('encCartId', transecRes.cart.ccrz__EncryptedId__c);
            inputMap.put('cart', transecRes.cart);
            List < ccrz__E_CartItem__c > lstCartItem = new List < ccrz__E_CartItem__c > ();
            lstCartItem.add(transecRes.cartItem);
            inputMap.put('cartItems', lstCartItem);
       
       
        inputMap.put('version',7);
        inputMap.put('storefront','SoftwareStore');
        inputMap.put('ownerId',transecRes.objSetupDate.objUserID);
        inputMap.put('cartId',transecRes.cart.Id);
        inputMap.put('sizing','{cart={sz_assc=false, sz_data=sz_s, sz_skiptrz=true}}');
        inputMap.put('CartBean',cartSum );
        inputMap.put('cartitem',testCartItem1);
        
       // Map<Id,ccrz__E_CartItem__c> mapCartLineItem= new Map<Id,ccrz__E_CartItem__c>();
       // mapCartLineItem.put(transecRes.cartItem.id,transecRes.cartItem);
 
          //Test.startTest();
             OSM_SW_ccLogicCartValidate  cartvalidateObj = new OSM_SW_ccLogicCartValidate();
        try{
            cartvalidateObj.processValidate(inputMap);
            
        }
        Catch(Exception ex){}
//Test.stopTest(); 
    }
      
}