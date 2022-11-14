/************************************************************
Name:  OSM_SW_OrderConfirmationPg_Ctrl_Test
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test class for OSM_SW_OrderConfirmationPg_Ctrl class.                          
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Neha Sharma      21/02/2019     INITIAL DEVELOPMENT          
Added for Mar-1571
updated by Sangeeta on 17thDec2021
2.0     Subbu K          22/07/2019     MAR-1861
// updated by sharad 22/Nov/2021
3.0     Sangeeta         04/01/2022     MP-366
4.0     Ashish           11/01/2022     MP-508
4.1     Ashish           24/01/2022     MP-508
//Updated by swetha 25-feb-2022

*************************************************************
**************************************************************/

@isTest
global class OSM_SW_OrderConfirmationPg_Ctrl_Test {
    public static testmethod void testOrderConfirmationPg() {

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
        test.StartTest();
          Id portal_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community' Limit 1 ].Id;
          
           
         UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
          system.debug('portalRole is  ' + portalRole);

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
          OSM_Preferred_Payment_IsBolt_PO__c=false,
          BillingCountry='United States'
          );
          System.runAs(portalAccountOwner2){
              Database.insert(portalAccount2);
          }

          //Create contact
          Contact contact1 = new Contact(
          FirstName = 'Test',
          Lastname = 'McTesty',
          Username__c = 'testUserName4553@gmail.com',
          AccountId = portalAccount2.Id,
          IAM_Contact_Status__c='Pending',
          Email ='test@test.com'
          );
          System.runAs(portalAccountOwner2){
              Database.insert(contact1);
          } 
          
          User testUser = new User();
          testUser.FirstName = 'Testttt';
          testUser.LastName = 'lasttt';
          testUser.UserName = 'test12399@test.com'; //changed to bypass test failure in prod
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
            System.runAs(portalAccountOwner2){
                  insert testUser;
            
          }
          //testUser.UserRoleId = portalRole.Id;
        ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
        objRemotCtx.storefront = 'SoftwareStore';
        objRemotCtx.currentCartId=transecRes.order.ccrz__EncryptedId__c;
        //objRemotCtx.currentCartId=transecRes.order.OrderProcessedforFSD__c;
       // objRemotCtx.portalUserId = transecRes.objSetupDate.objUserID;
       objRemotCtx.portalUserId=testuser.id;
        objRemotCtx.effAccountId=portalAccount2.Id;
        ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
        
        System.Runas(portalAccountOwner2) {
            
            /*Account account = transecRes.objSetupDate.account;
            portalAccount2.type = 'Dealer Account';
            portalAccount2.BOLT_Account_Number__c = null;
            portalAccount2.BMS_Customer_ID__c = '1234';
            portalAccount2.name = 'testAccount';
            portalAccount2.OSM_Service_Level__c = 'Full Service';
            update account;*/
            portalAccount2.type = 'Dealer Account';
            portalAccount2.BOLT_Account_Number__c = null;
            portalAccount2.BMS_Customer_ID__c = '1234';
            portalAccount2.name = 'testAccount';
           // portalAccount2.OSM_Service_Level__c = 'Full Service'; Mar-1236
            portalAccount2.ServiceLevel__c = 'Full Service';
            update portalAccount2;
            
            ccrz__E_Cart__c cart = new ccrz__E_Cart__c();
            cart.OSM_Payment_Method__c = 'po';
            cart.ccrz__Account__c = portalAccount2.id;
            //cart.ccrz__EncryptedId__c=;
            insert cart;

            ccrz__E_Cart__c childCart = new ccrz__E_Cart__c();
            childCart.OSM_Payment_Method__c = 'po';
            childCart.ccrz__Account__c = portalAccount2.id;
            childCart.ccrz__EncryptedId__c = cart.id;
            insert childCart;
            
             ccrz__E_Product__c product = transecRes.objSetupDate.compositeProduct;
        
        ccrz__E_CartItem__c cartItem = transecRes.cartItem;
        //cartItem.ccrz__ParentCartItem__c=childCart.id;
        cartItem.ccrz__Product__c = product.id;
        cartItem.ccrz__Quantity__c = 2;
        // cartItem.ccrz__ItemTotal__c=10;
        cartItem.ccrz__Price__c = 10;
        cartItem.ccrz__ProductType__c = 'Bundle';
        update cartItem;
        
        ccrz__E_CartItem__c cartItemChild = new ccrz__E_CartItem__c();
        cartItemChild.ccrz__Cart__c = cart.id;
        cartItemChild.OSM_SW_AddOn_Product_Of__c = cartItem.id;
        cartItemChild.ccrz__Product__c = product.id;
        cartItemChild.ccrz__ParentCartItem__c = cartItem.id;
        cartItemChild.ccrz__Quantity__c = 2;
        cartItemChild.ccrz__Price__c = 10;
        cartItemChild.ccrz__ProductType__c = 'Bundle';
        insert cartItemChild;

            ccrz__E_Coupon__c coupon = new ccrz__E_Coupon__c();
            coupon.ccrz__CouponCode__c = 'testCoupon';
            coupon.ccrz__CouponName__c = 'testName';
            coupon.ccrz__MaxUse__c = 2;
            coupon.ccrz__TotalUsed__c = 1;
            coupon.ccrz__DiscountAmount__c = 10;
            coupon.ccrz__CouponType__c = 'Absolute';
            coupon.ccrz__DiscountType__c = 'Percentage';
            coupon.ccrz__RuleType__c = 'General';
            coupon.ccrz__TargetQty__c = 1;
            coupon.ccrz__TargetRelation__c = 'Product';
            coupon.ccrz__TargetProduct__c = transecRes.objSetupDate.compositeProduct.Id;
            coupon.ccrz__Storefront__c='SoftwareStore';
            insert coupon;
            
            

            OSM_Existing_Subscription__c sub = new OSM_Existing_Subscription__c();
            sub.account__c = portalAccount2.id;
            sub.Is_Coupon_Already_Used__c = false;
            sub.Discount_for_Distributors_for_Backend__c = 10.0;
            sub.Dealer_Coupon_Code__c = coupon.ccrz__CouponCode__c;
            insert sub;

            ccrz__E_Order__c ord = transecRes.order;
            ord.ccrz__EncryptedId__c = '31f2c7a5-9977-49ae-bfd8-40038e689999';
            ord.OrderProcessedforFSD__c = false;
            ord.ccrz__Account__c = portalAccount2.id;
            ord.ccrz__OriginatedCart__c = cart.id;
            ord.OSM_SW_Is_Bolt_PO__c = false;
            ord.OSMRequestCounter__c=1;
            update ord;

            ccrz__E_OrderItem__c ordItem = transecRes.orderItem;
            ordItem.ccrz__Coupon__c = coupon.id;
            ordItem.ccrz__ProductType__c = 'Bundle';
            ordItem.Dn_Price__c = 10;
            update ordItem;

            ccrz__E_Invoice__c invoice = transecRes.invoice;
            invoice.Payment_Method__c = 'po';
            invoice.OSM_SW_Is_Bolt_PO__c = false;
            update invoice;

            system.debug('!!!!ord' + ord);
            system.debug('Cart___' + cart);
            
            //system.debug('account___' + account);

            //test.StartTest();
            
            //ccrz__E_Order__c orde = [Select Id,OrderProcessedforFSD__c from ccrz__E_Order__c where ccrz__EncryptedId__c =: ord.id];
            
            OSM_SW_OrderConfirmationPg_Ctrl.doOneBMSFSDCall(objRemotCtx, ord.ccrz__EncryptedId__c);
            OSM_SW_OrderConfirmationPg_Ctrl.callInterCompany(objRemotCtx, ord.ccrz__EncryptedId__c);
            OSM_SW_OrderConfirmationPg_Ctrl.deleteSubscOfOrder(ord.id);
            
            OSM_SW_OrderConfirmationPg_Ctrl.callIAM_CreateOrder(ord.Id);
            OSM_SW_OrderConfirmationPg_Ctrl.callDiscountingLogic(objRemotCtx, ord.ccrz__EncryptedId__c);
            OSM_SW_OrderConfirmationPg_Ctrl.DNPriceDiscountOnDealerLogin(ord.ccrz__EncryptedId__c, portalAccount2.Id);
            OSM_SW_OrderConfirmationPg_Ctrl.flagUpdateForDistributorAndDealer(ord.ccrz__EncryptedId__c, portalAccount2.Id);
            //OSM_SW_OrderConfirmationPg_Ctrl.DNPriceDiscountUpdate(ord.ccrz__EncryptedId__c, portalAccount2.Id);
            
            
            /*ordItem.ccrz__ProductType__c = 'Non Bundle';
            //update ordItem;
            OSM_SW_OrderConfirmationPg_Ctrl.couponDiscountLogicForAllAccounts(ord.ccrz__EncryptedId__c, portalAccount2.Id);
            
            portalAccount2.BOLT_Account_Number__c = '12345';
            update portalAccount2;
            //OSM_SW_OrderConfirmationPg_Ctrl.couponDiscountLogicForAllAccounts(ord.ccrz__EncryptedId__c, portalAccount2.Id);
            
            // OSM_SW_OrderConfirmationPg_Ctrl.DNPriceDiscountOnDealerLogin(ord.id, ord.ccrz__Account__c, ord.ccrz__OriginatedCart__c);
            //OSM_SW_OrderConfirmationPg_Ctrl.DNPriceDiscountOnFleetLogin(ord.id, ord.ccrz__Account__c);*/
            
            test.StopTest();
        }
    }
    
        public static testmethod void testOrderConfirmationPg_New() {

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
        test.StartTest();
          Id portal_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community' Limit 1 ].Id;
          //Id roleId=[select id,name from UserRole where name='CumminsFleetsCustomerUser' limit 1].id; 
           
         UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
          system.debug('portalRole is  ' + portalRole);

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
          OSM_Preferred_Payment_IsBolt_PO__c=false,
          BillingCountry='United States'
          );
          System.runAs(portalAccountOwner2){
              Database.insert(portalAccount2);
          }

          //Create contact
          Contact contact1 = new Contact(
          FirstName = 'Test',
          Lastname = 'McTesty',
          Username__c = 'testUserName4553@gmail.com',
          AccountId = portalAccount2.Id,
          IAM_Contact_Status__c='Pending',
          Email ='test@test.com'
          );
          System.runAs(portalAccountOwner2){
              Database.insert(contact1);
          } 
          
          User testUser = new User();
          testUser.FirstName = 'Testttt';
          testUser.LastName = 'lasttt';
          testUser.UserName = 'test55566690@test.com'; //changed to bypass test failure in prod
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
            System.runAs(portalAccountOwner2){
                  insert testUser;
            
          }
        ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
        objRemotCtx.storefront = 'SoftwareStore';
        objRemotCtx.currentCartId=transecRes.order.ccrz__EncryptedId__c;
       objRemotCtx.portalUserId=testuser.id;
        objRemotCtx.effAccountId=portalAccount2.Id;
        ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
        
        System.Runas(portalAccountOwner2) {
            
            portalAccount2.type = 'Dealer Account';
            portalAccount2.BOLT_Account_Number__c = null;
            portalAccount2.BMS_Customer_ID__c = '1234';
            portalAccount2.name = 'testAccount';
            portalAccount2.ServiceLevel__c = 'Full Service';
            update portalAccount2;
            
            ccrz__E_Cart__c cart = new ccrz__E_Cart__c();
            cart.OSM_Payment_Method__c = 'po';
            cart.ccrz__Account__c = portalAccount2.id;
            insert cart;

            ccrz__E_Cart__c childCart = new ccrz__E_Cart__c();
            childCart.OSM_Payment_Method__c = 'po';
            childCart.ccrz__Account__c = portalAccount2.id;
            childCart.ccrz__EncryptedId__c = cart.id;
            insert childCart;

            ccrz__E_Coupon__c coupon = new ccrz__E_Coupon__c();
            coupon.ccrz__CouponCode__c = 'testCoupon';
            coupon.ccrz__CouponName__c = 'testName';
            coupon.ccrz__MaxUse__c = 2;
            coupon.ccrz__TotalUsed__c = 1;
            coupon.ccrz__DiscountAmount__c = 10;
            coupon.ccrz__CouponType__c = 'Absolute';
            coupon.ccrz__DiscountType__c = 'Percentage';
            coupon.ccrz__RuleType__c = 'General';
            coupon.ccrz__TargetQty__c = 1;
            coupon.ccrz__TargetRelation__c = 'Product';
            coupon.ccrz__TargetProduct__c = transecRes.objSetupDate.compositeProduct.Id;
            coupon.ccrz__Storefront__c='SoftwareStore';
            insert coupon;

            OSM_Existing_Subscription__c sub = new OSM_Existing_Subscription__c();
            sub.account__c = portalAccount2.id;
            sub.Is_Coupon_Already_Used__c = false;
            sub.Discount_for_Distributors_for_Backend__c = 10.0;
            sub.Dealer_Coupon_Code__c = coupon.ccrz__CouponCode__c;
            insert sub;

            ccrz__E_Order__c ord = transecRes.order;
            ord.ccrz__EncryptedId__c = '31f2c7a5-9977-49ae-bfd8-40038e689999';
            ord.OrderProcessedforFSD__c = false;
            ord.ccrz__Account__c = portalAccount2.id;
            ord.ccrz__OriginatedCart__c = cart.id;
            ord.OSM_SW_Is_Bolt_PO__c = false;
            update ord;

            ccrz__E_OrderItem__c ordItem = transecRes.orderItem;
            ordItem.ccrz__Coupon__c = coupon.id;
            ordItem.ccrz__ProductType__c = 'Bundle';
            ordItem.Dn_Price__c = 10;
            update ordItem;

            ccrz__E_Invoice__c invoice = transecRes.invoice;
            invoice.Payment_Method__c = 'po';
            invoice.OSM_SW_Is_Bolt_PO__c = false;
            update invoice;

            system.debug('!!!!ord' + ord);
            system.debug('Cart___' + cart);
            
            /*OSM_SW_OrderConfirmationPg_Ctrl.doOneBMSFSDCall(objRemotCtx, ord.ccrz__EncryptedId__c);
            OSM_SW_OrderConfirmationPg_Ctrl.callInterCompany(objRemotCtx, ord.ccrz__EncryptedId__c);
            OSM_SW_OrderConfirmationPg_Ctrl.deleteSubscOfOrder(ord.id);
            
            OSM_SW_OrderConfirmationPg_Ctrl.callIAM_CreateOrder(ord.Id);
            OSM_SW_OrderConfirmationPg_Ctrl.callDiscountingLogic(objRemotCtx, ord.ccrz__EncryptedId__c);
            OSM_SW_OrderConfirmationPg_Ctrl.DNPriceDiscountOnDealerLogin(ord.ccrz__EncryptedId__c, portalAccount2.Id);
            OSM_SW_OrderConfirmationPg_Ctrl.flagUpdateForDistributorAndDealer(ord.ccrz__EncryptedId__c, portalAccount2.Id);
            OSM_SW_OrderConfirmationPg_Ctrl.DNPriceDiscountUpdate(ord.ccrz__EncryptedId__c, portalAccount2.Id);*/
            
            
            ordItem.ccrz__ProductType__c = 'Non Bundle';
            update ordItem;
            OSM_SW_OrderConfirmationPg_Ctrl.couponDiscountLogicForAllAccounts(ord.ccrz__EncryptedId__c, portalAccount2.Id);
            
            portalAccount2.BOLT_Account_Number__c = '12345';
            update portalAccount2;
           
            test.StopTest();
        }
    }
    
    public static testmethod void testOrderConfirmationPg1() {


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
        //test.StartTest(); // testing 
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
          Username__c = 'testUserName4553@gmail.com',
          AccountId = portalAccount2.Id,
          IAM_Contact_Status__c='Pending',
          Email ='test@test.com'
          );
          System.runAs(portalAccountOwner2){
              Database.insert(contact1);
          } 
          
          User testUser = new User();
          testUser.FirstName = 'Testttt';
          testUser.LastName = 'lasttt';
          testUser.UserName = 'test809781@test.com'; //changed to bypass test failure in prod
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
            System.runAs(portalAccountOwner2){
                  insert testUser;
            
          }
          //testUser.UserRoleId = portalRole.Id;
        ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
        objRemotCtx.storefront = 'SoftwareStore';
        objRemotCtx.currentCartId=transecRes.order.ccrz__EncryptedId__c;
        //objRemotCtx.currentCartId=transecRes.order.OrderProcessedforFSD__c;
       // objRemotCtx.portalUserId = transecRes.objSetupDate.objUserID;
       objRemotCtx.portalUserId=testuser.id;
        objRemotCtx.effAccountId=portalAccount2.Id;
        ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
        test.StartTest();
        System.Runas(portalAccountOwner2) {
            
            /*Account account = transecRes.objSetupDate.account;
            portalAccount2.type = 'Dealer Account';
            portalAccount2.BOLT_Account_Number__c = null;
            portalAccount2.BMS_Customer_ID__c = '1234';
            portalAccount2.name = 'testAccount';
            portalAccount2.OSM_Service_Level__c = 'Full Service';
            update account;*/
            portalAccount2.type = 'Dealer Account';
            portalAccount2.BOLT_Account_Number__c = null;
            portalAccount2.BMS_Customer_ID__c = '1234';
            portalAccount2.name = 'testAccount';
           // portalAccount2.OSM_Service_Level__c = 'Full Service'; Mar-1236
            portalAccount2.ServiceLevel__c = 'Full Service';
            portalAccount2.BillingCountry='United States';
            update portalAccount2;
            
            ccrz__E_Cart__c cart = new ccrz__E_Cart__c();
            cart.OSM_Payment_Method__c = 'po';
            cart.ccrz__Account__c = portalAccount2.id;
            //cart.ccrz__EncryptedId__c=;
            insert cart;

            ccrz__E_Cart__c childCart = new ccrz__E_Cart__c();
            childCart.OSM_Payment_Method__c = 'po';
            childCart.ccrz__Account__c = portalAccount2.id;
            childCart.ccrz__EncryptedId__c = cart.id;
            insert childCart;
            
            ccrz__E_Product__c product = transecRes.objSetupDate.compositeProduct;
        
        ccrz__E_CartItem__c cartItem = transecRes.cartItem;
        //cartItem.ccrz__ParentCartItem__c=childCart.id;
        cartItem.ccrz__Product__c = product.id;
        cartItem.ccrz__Quantity__c = 2;
        // cartItem.ccrz__ItemTotal__c=10;
        cartItem.ccrz__Price__c = 10;
        cartItem.ccrz__ProductType__c = 'Bundle';
        update cartItem;
        
        ccrz__E_CartItem__c cartItemChild = new ccrz__E_CartItem__c();
        cartItemChild.ccrz__Cart__c = cart.id;
        cartItemChild.OSM_SW_AddOn_Product_Of__c = cartItem.id;
        cartItemChild.ccrz__Product__c = product.id;
        cartItemChild.ccrz__ParentCartItem__c = cartItem.id;
        cartItemChild.ccrz__Quantity__c = 2;
        cartItemChild.ccrz__Price__c = 10;
        cartItemChild.ccrz__ProductType__c = 'Bundle';
        insert cartItemChild;

            ccrz__E_Coupon__c coupon = new ccrz__E_Coupon__c();
            coupon.ccrz__CouponCode__c = 'testCoupon';
            coupon.ccrz__CouponName__c = 'testName';
            coupon.ccrz__MaxUse__c = 2;
            coupon.ccrz__TotalUsed__c = 1;
            coupon.ccrz__DiscountAmount__c = 10;
            coupon.ccrz__CouponType__c = 'Absolute';
            coupon.ccrz__DiscountType__c = 'Percentage';
            coupon.ccrz__RuleType__c = 'General';
            coupon.ccrz__TargetQty__c = 1;
            coupon.ccrz__TargetRelation__c = 'Product';
            coupon.ccrz__TargetProduct__c = transecRes.objSetupDate.compositeProduct.Id;
            coupon.ccrz__Storefront__c='SoftwareStore';
            insert coupon;
            
            

            OSM_Existing_Subscription__c sub = new OSM_Existing_Subscription__c();
            sub.account__c = portalAccount2.id;
            sub.Is_Coupon_Already_Used__c = false;
            sub.Discount_for_Distributors_for_Backend__c = 10.0;
            sub.Dealer_Coupon_Code__c = coupon.ccrz__CouponCode__c;
            insert sub;

            ccrz__E_Order__c ord = transecRes.order;
            ord.ccrz__EncryptedId__c = '31f2c7a5-9977-49ae-bfd8-40038e689999';
            ord.OrderProcessedforFSD__c = false;
            ord.ccrz__Account__c = portalAccount2.id;
            ord.ccrz__OriginatedCart__c = cart.id;
            ord.OSM_SW_Is_Bolt_PO__c = true;
            ord.OSMRequestCounter__c=1;
            
            update ord;

            ccrz__E_OrderItem__c ordItem = transecRes.orderItem;
            ordItem.ccrz__Coupon__c = coupon.id;
            ordItem.ccrz__ProductType__c = 'Bundle';
            ordItem.Dn_Price__c = 10;
            update ordItem;

            ccrz__E_Invoice__c invoice = transecRes.invoice;
            invoice.Payment_Method__c = 'po';
            invoice.OSM_SW_Is_Bolt_PO__c = true;
            update invoice;
            

            system.debug('!!!!ord' + ord);
            system.debug('Cart___' + cart);
            //system.debug('account___' + account);

           // test.StartTest();
            
            //ccrz__E_Order__c orde = [Select Id,OrderProcessedforFSD__c from ccrz__E_Order__c where ccrz__EncryptedId__c =: ord.id];
            
            OSM_SW_OrderConfirmationPg_Ctrl.doOneBMSFSDCall(objRemotCtx, ord.ccrz__EncryptedId__c);
            OSM_SW_OrderConfirmationPg_Ctrl.callInterCompany(objRemotCtx, ord.ccrz__EncryptedId__c);
            OSM_SW_OrderConfirmationPg_Ctrl.deleteSubscOfOrder(ord.id);
            
            OSM_SW_OrderConfirmationPg_Ctrl.callIAM_CreateOrder(ord.Id);
            OSM_SW_OrderConfirmationPg_Ctrl.callDiscountingLogic(objRemotCtx, ord.ccrz__EncryptedId__c);
            OSM_SW_OrderConfirmationPg_Ctrl.DNPriceDiscountOnDealerLogin(ord.ccrz__EncryptedId__c, portalAccount2.Id);
            OSM_SW_OrderConfirmationPg_Ctrl.flagUpdateForDistributorAndDealer(ord.ccrz__EncryptedId__c, portalAccount2.Id);
            OSM_SW_OrderConfirmationPg_Ctrl.DNPriceDiscountUpdate(ord.ccrz__EncryptedId__c, portalAccount2.Id);
                        
            ordItem.ccrz__ProductType__c = 'Non Bundle';
            update ordItem;
            OSM_SW_OrderConfirmationPg_Ctrl.couponDiscountLogicForAllAccounts(ord.ccrz__EncryptedId__c, portalAccount2.Id);
            
            portalAccount2.BOLT_Account_Number__c = '12345';
            update portalAccount2;
            OSM_SW_OrderConfirmationPg_Ctrl.couponDiscountLogicForAllAccounts(ord.ccrz__EncryptedId__c, portalAccount2.Id);
            
            // OSM_SW_OrderConfirmationPg_Ctrl.DNPriceDiscountOnDealerLogin(ord.id, ord.ccrz__Account__c, ord.ccrz__OriginatedCart__c);
            //OSM_SW_OrderConfirmationPg_Ctrl.DNPriceDiscountOnFleetLogin(ord.id, ord.ccrz__Account__c);
            
            PageReference pref = Page.PdfGeneratorTemplate;       
            pref.getParameters().put('id',invoice.id);
            Test.setCurrentPage(pref);
            ApexPages.StandardController con = new ApexPages.StandardController(invoice);
           // OSM_SW_OrderConfCntrl.addShippingAddress(objRemotCtx,pref);
            //PdfGeneratorTemplate mycon = new PdfGeneratorTemplate(con);
            OSM_SW_OrderConfirmationPg_Ctrl.savepdf(invoice.id);
            
            
          
            ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
            test.StopTest();
        }
    }
}