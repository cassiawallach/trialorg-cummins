@isTest(seealldata=false)
public class OSM_SW_hk_EffectiveAccount_Test1 {
    
    static testMethod void testMethod1() {
         
        OSM_SW_hk_EffectiveAccount obj = new OSM_SW_hk_EffectiveAccount();
        Map<String,Object> inputData = new Map<String,Object>();
        
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
        a.AccountSource = 'WWSPS';
        upsert a;
        Contact c=transecRes.objSetupDate.contact;
        upsert c;
        
        System.runAs ( transecRes.objSetupDate.loggedInUser   ) {
            
            
            ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
            objRemotCtx.storefront='SoftwareStore';
            objRemotCtx.currentCartId=transecRes.cart.ccrz__EncryptedId__c;
            objRemotCtx.portalUserId=transecRes.objSetupDate.objUserID;
            objRemotCtx.effAccountId = transecRes.objSetupDate.account.id; 
            
            // objRemotCtx.currAccountId = transecRes.objSetupDate.account.id;    
            
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
        inputMap.put(ccrz.cc_hk_EffectiveAccount.PARAM_ACCOUNT_ID,transecRes.order.ccrz__Account__c);
        obj.fetchAccounts(inputMap);
        obj.fetchAccounts(null);
        
    }
    static testMethod void testMethod2() {
        Profile ObjProfile = [SELECT Id FROM Profile WHERE Name='System Administrator'];
	    Profile objPortalProf = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community' Limit 1];
	    UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
	    
	    User objUser = new User(FirstName ='test12', 
	                            Lastname ='12345',
	                            Alias = '0test12', 
	                            localesidkey='en_US',
	                            emailencodingkey='UTF-8',
	                            languagelocalekey='en_US',
	                            profileId = ObjProfile.Id,
	                            UserRoleId = portalRole.Id,
	                            Email ='test123@noemail.com',
                                OSM_Storefront_User_Type__c='Distributor Admin',
	                            username ='test012345@noemail.com',
	                            timezonesidkey='America/Los_Angeles');
	    
        insert objUser;
        System.runAs (objUser ) {
            effectiveAccount_enable_ProfileUserType__c effacc  = new effectiveAccount_enable_ProfileUserType__c();
            effacc.Name='Distributor Admin';
            effacc.Enable_Effective_Account_Selection__c=true;
            insert effacc;
        OSM_SW_hk_EffectiveAccount obj = new OSM_SW_hk_EffectiveAccount();
        Map<String,Object> inputData = new Map<String,Object>();
        
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
        a.AccountSource = 'WWSPS';
        upsert a;
        Contact c=transecRes.objSetupDate.contact;
        upsert c;
        
        
            
            
            ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
            objRemotCtx.storefront='SoftwareStore';
            objRemotCtx.currentCartId=transecRes.cart.ccrz__EncryptedId__c;
            objRemotCtx.portalUserId=transecRes.objSetupDate.objUserID;
            objRemotCtx.effAccountId = transecRes.objSetupDate.account.id; 
            
            // objRemotCtx.currAccountId = transecRes.objSetupDate.account.id;    
            
            System.debug('transecRes.objSetupDate.account '+transecRes.objSetupDate.account );
            
            
            ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
            
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
        inputMap.put(ccrz.cc_hk_EffectiveAccount.PARAM_ACCOUNT_ID,transecRes.order.ccrz__Account__c);
        obj.fetchAccounts(inputMap);
        obj.fetchAccounts(null);
       }
        
    }
    static testMethod void testMethod3() {
        Profile ObjProfile = [SELECT Id FROM Profile WHERE Name='System Administrator'];
	    Profile objPortalProf = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community' Limit 1];
	    UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
	    
	    User objUser = new User(FirstName ='test12', 
	                            Lastname ='12345',
	                            Alias = '0test12', 
	                            localesidkey='en_US',
	                            emailencodingkey='UTF-8',
	                            languagelocalekey='en_US',
	                            profileId = ObjProfile.Id,
	                            UserRoleId = portalRole.Id,
	                            Email ='test123@noemail.com',
                                OSM_Storefront_User_Type__c='SSOEM Admin',
	                            username ='test012345@noemail.com',
	                            timezonesidkey='America/Los_Angeles');
	    
        insert objUser;
        System.runAs (objUser ) {
            effectiveAccount_enable_ProfileUserType__c effacc  = new effectiveAccount_enable_ProfileUserType__c();
            effacc.Name='Distributor Admin';
            effacc.Enable_Effective_Account_Selection__c=false;
            insert effacc;
        OSM_SW_hk_EffectiveAccount obj = new OSM_SW_hk_EffectiveAccount();
        Map<String,Object> inputData = new Map<String,Object>();
        
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
        a.AccountSource = 'WWSPS';
        upsert a;
        Contact c=transecRes.objSetupDate.contact;
        upsert c;
        
        
            
            
            ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
            objRemotCtx.storefront='SoftwareStore';
            objRemotCtx.currentCartId=transecRes.cart.ccrz__EncryptedId__c;
            objRemotCtx.portalUserId=transecRes.objSetupDate.objUserID;
            objRemotCtx.effAccountId = transecRes.objSetupDate.account.id; 
            
            // objRemotCtx.currAccountId = transecRes.objSetupDate.account.id;    
            
            System.debug('transecRes.objSetupDate.account '+transecRes.objSetupDate.account );
            
            
            ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
            
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
        inputMap.put(ccrz.cc_hk_EffectiveAccount.PARAM_ACCOUNT_ID,transecRes.order.ccrz__Account__c);
        obj.fetchAccounts(inputMap);
        obj.fetchAccounts(null);
       }
        
    }
    
}