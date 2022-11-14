@isTest
public class OSM_ccLogicAccountGetCurrentCustom_Test {
    
    
    
    
    static testMethod void testMethodForOrder() {
        
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
        
        Id portal_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community' Limit 1 ].Id;
        //Id roleId=[select id,name from UserRole where name='CumminsFleetsCustomerUser' limit 1].id; 
        
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        system.debug('portalRole is ' + portalRole);
        
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner2 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username ='test24446@test.com',
            Alias = 'batman',
            Email='bruce.wayne@wayneenterprises.com',
            EmailEncodingKey='UTF-8',
            Firstname='Bruce',
            Lastname='Wayne',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
        );
        Database.insert(portalAccountOwner2);
        Account portalAccount2 = new Account(
            Name = 'TestAccount2',
            OwnerId = portalAccountOwner2.Id,
            OSM_Preferred_Billing_Frequency_Lock__c=false,
            BMS_Customer_ID__c='1234',
            OSM_Preferred_Payment_Method__c='po',
            OSM_Preferred_Payment_IsBolt_PO__c=false
        );
        System.runAs(portalAccountOwner2){
            Database.insert(portalAccount2);
        }
        
        //Create contact
        Contact contact1 = new Contact(
            FirstName = 'Test',
            Lastname = 'McTesty',
            IAM_Contact_Status__c='Pending',
            Username__c = 'testUserName654@gmail.com',
            AccountId = portalAccount2.Id,
            Email ='test@test.com'
        );
        System.runAs(portalAccountOwner2){
            Database.insert(contact1);
        } 
        
        User testUser = new User();
        testUser.FirstName = 'Testttt';
        testUser.LastName = 'lasttt';
        testUser.UserName = 'test2@test.com';
        testUser.Email = 'bruce.wayne@wayneenterprises.com';
        testUser.Alias = 'batman';
        testUser.ContactId = contact1.Id;
        testUser.CommunityNickname = 'test12345h';
        testUser.ProfileId =portal_PROFILE_ID;
        testUser.TimeZoneSidKey = 'America/Los_Angeles';
        testUser.isActive = true;
        testUser.LocaleSidKey = 'en_US';
        testUser.LanguageLocaleKey = 'en_US';
        testUser.EmailEncodingKey = 'ISO-8859-1';
        //testUser.UserRoleId = portalRole.Id;
        
        
        System.runAs(portalAccountOwner2){
            insert testUser;
            
        }
        
        // Creating address
        System.runAs(portalAccountOwner2) {
            
            Account account = transecRes.objSetupDate.account;
            account.Bolt_Customer_Account_Status__c = 'Active';
            update account;
            
            Map < String, Object > inputMap = new Map < String, Object > ();
            
            inputMap.put('placeStep', 'end');
            inputMap.put('cartId', transecRes.cart.Id);
            inputMap.put('encCartId', transecRes.cart.ccrz__EncryptedId__c);
            inputMap.put('cart', transecRes.cart);
            List < ccrz__E_CartItem__c > lstCartItem = new List < ccrz__E_CartItem__c > ();
            lstCartItem.add(transecRes.cartItem);
            inputMap.put('cartItems', lstCartItem);
            inputMap.put('order', transecRes.order);
            List < ccrz__E_OrderItem__c > lstOrderItem = new List < ccrz__E_OrderItem__c > ();
            lstOrderItem.add(transecRes.orderItem);
            inputMap.put('orderItems', lstOrderItem);
            inputMap.put('invoice', transecRes.invoice);
            inputMap.put('invoiceItems', transecRes.invoiceItems);
            
            ccrz.cc_hk_Payment.TransactionPaymentParams objTranPay = new ccrz.cc_hk_Payment.TransactionPaymentParams();
            objTranPay.accountNumber = '12345';
            objTranPay.accountType = 'po';
            objTranPay.ammount = 50;
            objTranPay.amount = 100;
            inputMap.put('transationProcessedData', objTranPay);
            
            ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
            objRemotCtx.storefront = 'SoftwareStore';
            objRemotCtx.currentCartId = transecRes.cart.ccrz__EncryptedId__c;
            //objRemotCtx.portalUserId = transecRes.objSetupDate.objUserID;
            objRemotCtx.portalUserId=testUser.id;
            
            ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
            
            Test.startTest();
            
            OSM_ccLogicAccountGetCurrentCustom objCls = new OSM_ccLogicAccountGetCurrentCustom();
            Map < String, Object > returnMap = objCls.process(inputMap);
            // OSM_SW_cc_hk_Order.processRefundForFailedOSMOrderPlacedProcess();
            
            Test.stopTest();
            
        }
        
    }
}