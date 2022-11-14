//Added for too many query rows issue
// Update Sharad 12 April 2021
// Update Sharad 14 April 2021
// Update Sharad 14 April 2021
//update Sangeeta 27th JAN 2022
//update Subbu 22nd Jul 2021 MAR-1861
//deploying test class
//update Swetha 1st Feb 2022
//Subbu
//Comment
/************************************************
 History
 --------
 VERSION    AUTHOR          DATE            DETAILS
 1.0        Ashish        16/11/2021        MP-337
 */
@IsTest
public class OSM_SW_CartPg_Ctrl_Test {


    static testMethod void OSM_SW_CartPg_Ctrl_TestMethod2()
    {
      TestProductSetupReq testProductSetupReq1 = OSM_TestDataCreationUtility.populatedTestProductSetupReq();
        TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes1 = OSM_TestDataCreationUtility.createProductSetUp(testProductSetupReq1);
        //TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes1=OSM_TestDataCreationUtility.createCompletedTransactionFlowTestData(testProductSetupRes1,20000.0, 10.0);   
        Account account = testCompletedTransactionSetUpRes1.objSetupDate.account;
        IAM_Trigger_Switches__mdt md=new IAM_Trigger_Switches__mdt();
        md.IAM_Active__c=false;
       


        User usr = [Select id from User where Id =: UserInfo.getUserId()];


        Id portal_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community' Limit 1 ].Id;
        //Id roleId=[select id,name from UserRole where name='CumminsFleetsCustomerUser' limit 1].id; 

        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        system.debug('portalRole is ' + portalRole);

        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        
         // Creating User record    
        User portalAccountOwner2 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = 'test24446@test.com',
            Alias = 'batman',
            Email = 'bruce.wayne@wayneenterprises.com',
            EmailEncodingKey = 'UTF-8',
            Firstname = 'Bruce',
            Lastname = 'Wayne',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Chicago'
        );
        Database.insert(portalAccountOwner2);

        //Create account
        Account portalAccount1 = new Account(
            Name = 'TestAccount1',
            OwnerId = portalAccountOwner2.Id,
            OSM_Preferred_Billing_Frequency_Lock__c = true,
            BMS_Customer_ID__c = '1234',
            OSM_Preferred_Payment_Method__c = 'po',
            OSM_Preferred_Payment_IsBolt_PO__c = false,
            type = 'Dealer Account',
            BillingCountry='United States'
            
            
        );
        System.runAs(portalAccountOwner2) {
            Database.insert(portalAccount1);
            //account.type = 'Dealer Account';
            account.BOLT_Account_Number__c = null;
            account.BMS_Customer_ID__c = '1234';
            account.Name='testAccount';
            update account;
        }

        //Create contact
        Contact contact1 = new Contact(
            FirstName = 'Test',
            Lastname = 'McTesty',
            IAM_Contact_Status__c='Pending',
            Username__c = 'testUserName220@gmail.com',
            AccountId = portalAccount1.Id,
            IAM_From_JIT_Execution__c=true,
            Email = 'test852@cummins.com'
        );
       // Email = 'test@test.com'
        System.runAs(portalAccountOwner2) {
            Database.insert(contact1);
        }

        //Create user
        //Profile portalProfile = [SELECT Id FROM Profile Limit 1];


        User testUser = new User();
        testUser.FirstName = 'Testttt';
        testUser.LastName = 'lasttt';
        testUser.UserName = 'test2@test.com';
        testUser.Email = 'bruce.wayne@wayneenterprises.com';
        testUser.Alias = 'batman';
        testUser.ContactId = contact1.Id;
        testUser.CommunityNickname = 'test12345l';
        testUser.ProfileId = portal_PROFILE_ID;
        testUser.TimeZoneSidKey = 'America/Los_Angeles';
        testUser.isActive = true;
        testUser.LocaleSidKey = 'en_US';
        testUser.LanguageLocaleKey = 'en_US';
        testUser.EmailEncodingKey = 'ISO-8859-1';
        //testUser.UserRoleId = portalRole.Id;


        System.runAs(portalAccountOwner2) {
            insert testUser;

        }

       
        System.Runas(portalAccountOwner2) {

           
            
            
            ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
            objRemotCtx.storefront = 'SoftwareStore';
            objRemotCtx.currentCartId =TestCompletedTransactionSetUpRes1.order.ccrz__EncryptedId__c;
            objRemotCtx.portalUserId = testuser.id;
            ccrz.cc_CallContext.initRemoteContext(objRemotCtx);


            ccrz__E_Cart__c cart = TestCompletedTransactionSetUpRes1.cart;
            cart.OSM_Payment_Method__c = 'po';
            cart.ccrz__Account__c = portalAccount1.id;
            cart.ccrz__EncryptedId__c = objRemotCtx.currentCartId;
            update cart;

            ccrz__E_Product__c product = TestCompletedTransactionSetUpRes1.objSetupDate.compositeProduct;
            ccrz__E_CartItem__c cartItemChild = new ccrz__E_CartItem__c();
            cartItemChild.ccrz__Cart__c = cart.id;
            //cartItemChild.OSM_SW_AddOn_Product_Of__c = cartItem.id;
            cartItemChild.ccrz__Product__c = product.id;
            //cartItemChild.ccrz__ParentCartItem__c = cartItem.id;
            cartItemChild.ccrz__Quantity__c = 2;
            cartItemChild.ccrz__Price__c = 10;
            cartItemChild.ccrz__ProductType__c = 'Bundle';
            insert cartItemChild;

            ccrz__E_CartItem__c cartItem = TestCompletedTransactionSetUpRes1.cartItem;
            //cartItem.ccrz__ParentCartItem__c=childCart.id;
            cartItem.ccrz__Product__c = product.id;
            cartItem.ccrz__Quantity__c = 2;
            // cartItem.ccrz__ItemTotal__c=10;
            cartItem.ccrz__Price__c = 10;
            cartItem.ccrz__ProductType__c = 'Bundle';
            cartItem.OSM_SW_AddOn_Product_Of__c=cartItemChild.id;
            update cartItem;


            OSM_Existing_Subscription__c sub = new OSM_Existing_Subscription__c();
            sub.account__c = portalAccount1.id;
            sub.Is_Coupon_Already_Used__c = false;
            sub.Discount_for_Distributors_for_Backend__c = 10.0;
            insert sub;

            ccrz__E_Order__c ord = TestCompletedTransactionSetUpRes1.order;
            ord.ccrz__EncryptedId__c = '31f2c7a5-9977-49ae-bfd8-40038e689999';
            ord.OrderProcessedforFSD__c = true;
            ord.ccrz__Account__c = portalAccount1.id;
            ord.ccrz__OriginatedCart__c = cart.id;
            update ord;

            ccrz__E_OrderItem__c ordItem =TestCompletedTransactionSetUpRes1.orderItem;
            ordItem.ccrz__ProductType__c = 'Bundle';
            ordItem.Dn_Price__c = 10;
            //update ordItem;
            
            ccrz__E_Product__c prod = TestCompletedTransactionSetUpRes1.objSetupDate.compositeProduct;
            prod.Name = Label.VOTECH100OFFINSITE;
            update prod;
            
            Test.StartTest();
            
            OSM_SW_CartPg_Ctrl.cartItemDetails(objRemotCtx);
            OSM_SW_CartPg_Ctrl.preApplyCoupon(objRemotCtx);
            OSM_SW_CartPg_Ctrl.postApplyCoupon(objRemotCtx);
            OSM_SW_CartPg_Ctrl.getCouponCode(objRemotCtx);
            
            portalAccount1.Type = 'Votech12';
            update portalAccount1;
            
            OSM_SW_CartPg_Ctrl.getCouponCode(objRemotCtx);
            OSM_SW_CartPg_Ctrl.applyCouponValidation(Label.VOTECH100OFFINSITE, objRemotCtx);
            
            prod.Name = Label.VOTECH100OFFQSOL;
            update prod;
            
            OSM_SW_CartPg_Ctrl.getCouponCode(objRemotCtx);
            OSM_SW_CartPg_Ctrl.applyCouponValidation(Label.VOTECH100OFFQSOL, objRemotCtx);
            
            portalAccount1.type = 'Distributor Account';
            update portalAccount1;
            
            OSM_SW_CartPg_Ctrl.getCouponCode(objRemotCtx);
            
            portalAccount1.type = 'Fleet';
            update portalAccount1;
            
            try {
                
                ccrz.cc_RemoteActionContext objRemotCtx1 = new ccrz.cc_RemoteActionContext();
                objRemotCtx1.storefront = 'SoftwareStore';
                objRemotCtx1.currentCartId = testCompletedTransactionSetUpRes1.cart.ccrz__EncryptedId__c;
                objRemotCtx1.portalUserId = testUser.id;
                ccrz.cc_CallContext.initRemoteContext(objRemotCtx1);
                
                //OSM_SW_CartPg_Ctrl.TestMethod='test1';
                
                OSM_SW_CartPg_Ctrl.callOneBMS(objRemotCtx);
                OSM_SW_CartPg_Ctrl.ShowWarningMsgPaymentOrder(objRemotCtx);
                
            } catch (Exception ex) {}
            
            OSM_SW_CartPg_Ctrl.getCouponCode(objRemotCtx);
            OSM_SW_CartPg_Ctrl.cartItemDetailsSubsc(objRemotCtx);
            OSM_SW_CartPg_Ctrl.ShowcartItemValidationsMsg(objRemotCtx);
           // OSM_SW_CartPg_Ctrl.ShowWarningMsgPaymentOrder(objRemotCtx);
            
            Test.setCurrentPageReference(new PageReference('Page.OSM_SW_CartPg')); 
            System.currentPageReference().getParameters().put('cartId', objRemotCtx.currentCartId);
            OSM_SW_CartPg_Ctrl objCtrl = new OSM_SW_CartPg_Ctrl();

            OSM_SW_CartPg_Ctrl.OSMApplyCoupon(objRemotCtx, new Map < String, Decimal > { 'CIIdToPrice' => 10 }, '12345', true);
            OSM_SW_CartPg_Ctrl.OSMDeleteCoupon(objRemotCtx, '12345');
           // OSM_SW_CartPg_Ctrl.customUpdateCart(objRemotCtx, new map < String, Integer > { TestCompletedTransactionSetUpRes1.cartItem.Id => 10});

            Test.StopTest();
        }
    }
    static testMethod void OSM_SW_CartPg_Ctrl_TestMethod1() {
        TestProductSetupReq testProductSetupReq1 = OSM_TestDataCreationUtility.populatedTestProductSetupReq();
        TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes1 = OSM_TestDataCreationUtility.createProductSetUp(testProductSetupReq1);
        //TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes1=OSM_TestDataCreationUtility.createCompletedTransactionFlowTestData(testProductSetupRes1,20000.0, 10.0);   
        Account account = testCompletedTransactionSetUpRes1.objSetupDate.account;
        IAM_Trigger_Switches__mdt md=new IAM_Trigger_Switches__mdt();
        md.IAM_Active__c=false;
        

        User usr = [Select id from User where Id =: UserInfo.getUserId()];


        Id portal_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community' Limit 1 ].Id;
        //Id roleId=[select id,name from UserRole where name='CumminsFleetsCustomerUser' limit 1].id; 

        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        system.debug('portalRole is ' + portalRole);

        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner2 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = 'test24446@test.com',
            Alias = 'batman',
            Email = 'bruce.wayne@wayneenterprises.com',
            EmailEncodingKey = 'UTF-8',
            Firstname = 'Bruce',
            Lastname = 'Wayne',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Chicago'
        );
        Database.insert(portalAccountOwner2);

        //User u1 = [Select ID From User Where Id =: portalAccountOwner1.Id];

        //Create account
        Account portalAccount1 = new Account(
            Name = 'TestAccount1',
            OwnerId = portalAccountOwner2.Id,
            OSM_Preferred_Billing_Frequency_Lock__c = false,
            BMS_Customer_ID__c = '1234',
            OSM_Preferred_Payment_Method__c = 'po',
            BOLT_Account_Number__c = null,
            OSM_Preferred_Payment_IsBolt_PO__c = false,
            BillingCountry='United States'
        );
        System.runAs(portalAccountOwner2) {
            Database.insert(portalAccount1);
        }

        //Create contact
        Contact contact1 = new Contact(
            FirstName = 'Test',
            Lastname = 'McTesty',
            Username__c = 'testUserName190@gmail.com',
            AccountId = portalAccount1.Id,
            IAM_Contact_Status__c='Pending',
            IAM_From_JIT_Execution__c=true,
            Email = 'test852@cummins.com'
        );
       // Email = 'test@test.com'
        System.runAs(portalAccountOwner2) {
            Database.insert(contact1);
        }

        //Create user
        //Profile portalProfile = [SELECT Id FROM Profile Limit 1];


        User testUser = new User();
        testUser.FirstName = 'Testttt';
        testUser.LastName = 'lasttt';
        testUser.UserName = 'test2@test.com';
        testUser.Email = 'bruce.wayne@wayneenterprises.com';
        testUser.Alias = 'batman';
        testUser.ContactId = contact1.Id;
        testUser.CommunityNickname = 'test12345l';
        testUser.ProfileId = portal_PROFILE_ID;
        testUser.TimeZoneSidKey = 'America/Los_Angeles';
        testUser.isActive = true;
        testUser.LocaleSidKey = 'en_US';
        testUser.LanguageLocaleKey = 'en_US';
        testUser.EmailEncodingKey = 'ISO-8859-1';
        //testUser.UserRoleId = portalRole.Id;


        System.runAs(portalAccountOwner2) {
            insert testUser;

        }
        
        System.RunAs(testUser) {
            try {
                test.StartTest();
                ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
                objRemotCtx.storefront = 'SoftwareStore';
                objRemotCtx.currentCartId = testCompletedTransactionSetUpRes1.cart.ccrz__EncryptedId__c;
                objRemotCtx.portalUserId = testUser.id;
                ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
                
               IAM_Application__c ap=new IAM_Application__c();
               ap.IAM_Account_Name__c=testCompletedTransactionSetUpRes1.cart.ccrz__Account__c;
               ap.IAM_Application_Name__c='Guidanz Mobile';
               ap.IAM_Role__c='Units';
               //insert ap;
               ccrz__E_Product__c product = TestCompletedTransactionSetUpRes1.objSetupDate.compositeProduct;
              // product.Group_Name__c='FluidWatch';
               update product;

                ccrz__E_CartItem__c cartItem = TestCompletedTransactionSetUpRes1.cartItem;
                //cartItem.ccrz__ParentCartItem__c=childCart.id;
                cartItem.ccrz__Product__c = product.id;
                cartItem.ccrz__Quantity__c = 2;
                // cartItem.ccrz__ItemTotal__c=10;
                cartItem.ccrz__Price__c = 10;
                cartItem.ccrz__ProductType__c = 'Bundle';
                cartItem.Unit_Dn_Price__c = 10.00;
                //cartItem.OSM_SW_AddOn_Product_Of__c=cart.id;
                update cartItem;
                //OSM_SW_CartPg_Ctrl.TestMethod='test1';
                
                OSM_SW_CartPg_Ctrl.callOneBMS(objRemotCtx);
                OSM_SW_CartPg_Ctrl.cartItemDetails(objRemotCtx);
                OSM_SW_CartPg_Ctrl.ShowcartItemValidationsMsg(objRemotCtx);
                OSM_SW_CartPg_Ctrl.ShowWarningMsgPaymentOrder(objRemotCtx);
                OSM_SW_CartPg_Ctrl.cartItemDetailsSubsc(objRemotCtx);
                OSM_SW_CartPg_Ctrl.applyCouponValidation(Label.VOTECH100OFFINSITE, objRemotCtx);
                OSM_SW_CartPg_Ctrl.preApplyCoupon(objRemotCtx);
                OSM_SW_CartPg_Ctrl.postApplyCoupon(objRemotCtx);
                OSM_SW_CartPg_Ctrl.getCouponCode(objRemotCtx);
                OSM_SW_CartPg_Ctrl.OSMApplyCoupon(objRemotCtx, new Map < String, Decimal > { 'CIIdToPrice' => 10 }, '12345', true);
                OSM_SW_CartPg_Ctrl.OSMDeleteCoupon(objRemotCtx, '12345');
                //OSM_SW_CartPg_Ctrl.validateCouponCodeQty(listCartItems,listCartCoupon);
                OSM_SW_CartPg_Ctrl.customUpdateCart(objRemotCtx, new map < String, Integer > { TestCompletedTransactionSetUpRes1.cartItem.Id => 15});
                test.StopTest();
            } catch (Exception ex) {}
        }
    } 
   static testMethod void OSM_SW_CartPg_Ctrl_TestMethod3() {
        
        TestProductSetupReq testProductSetupReq1 = OSM_TestDataCreationUtility.populatedTestProductSetupReq();
        TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes1 = OSM_TestDataCreationUtility.createProductSetUp(testProductSetupReq1);
        //TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes1=OSM_TestDataCreationUtility.createCompletedTransactionFlowTestData(testProductSetupRes1,20000.0, 10.0);   
        Account account = testCompletedTransactionSetUpRes1.objSetupDate.account;
        IAM_Trigger_Switches__mdt md=new IAM_Trigger_Switches__mdt();
        md.IAM_Active__c=false;
       

        User usr = [Select id from User where Id =: UserInfo.getUserId()];


        Id portal_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community' Limit 1 ].Id;
        //Id roleId=[select id,name from UserRole where name='CumminsFleetsCustomerUser' limit 1].id; 

        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        system.debug('portalRole is ' + portalRole);

        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        
      
            
        User portalAccountOwner2 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = 'test24446@test.com',
            Alias = 'batman',
            Email = 'bruce.wayne@wayneenterprises.com',
            EmailEncodingKey = 'UTF-8',
            Firstname = 'Bruce',
            Lastname = 'Wayne',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Chicago',
            OSM_Storefront_User_Type__c ='Distributor Admin'
        );
        Database.insert(portalAccountOwner2);

        //User u1 = [Select ID From User Where Id =: portalAccountOwner1.Id];

        //System.runAs ( portalAccountOwner1 ) {
        //Create account
        Account portalAccount1 = new Account(
            Name = 'TestAccount1',
            OwnerId = portalAccountOwner2.Id,
            OSM_Preferred_Billing_Frequency_Lock__c = true,
            BMS_Customer_ID__c = '1234',
            OSM_Preferred_Payment_Method__c = 'po',
            OSM_Preferred_Payment_IsBolt_PO__c = false,
            type = 'Dealer Account',
            BillingCountry='United States',
            DTNA__c=false,
            ServiceLevel__c='Full Service'
            
            
        );
        System.runAs(portalAccountOwner2) {
            Database.insert(portalAccount1);
            //account.type = 'Dealer Account';
            account.BOLT_Account_Number__c = null;
            account.BMS_Customer_ID__c = '1234';
            account.Name='testAccount';
            update account;
        }

        //Create contact
        Contact contact1 = new Contact(
            FirstName = 'Test',
            Lastname = 'McTesty',
            IAM_Contact_Status__c='Pending',
            Username__c = 'testUserName220@gmail.com',
            AccountId = portalAccount1.Id,
            IAM_From_JIT_Execution__c=true,
            Email = 'test852@cummins.com'
        );
       // Email = 'test@test.com'
        System.runAs(portalAccountOwner2) {
            Database.insert(contact1);
        }

        //Create user
        //Profile portalProfile = [SELECT Id FROM Profile Limit 1];


        User testUser = new User();
        testUser.FirstName = 'Testttt';
        testUser.LastName = 'lasttt';
        testUser.UserName = 'test2@test.com';
        testUser.Email = 'bruce.wayne@wayneenterprises.com';
        testUser.Alias = 'batman';
        testUser.ContactId = contact1.Id;
        testUser.CommunityNickname = 'test12345l';
        testUser.ProfileId = portal_PROFILE_ID;
        testUser.TimeZoneSidKey = 'America/Los_Angeles';
        testUser.isActive = true;
        testUser.LocaleSidKey = 'en_US';
        testUser.LanguageLocaleKey = 'en_US';
        testUser.EmailEncodingKey = 'ISO-8859-1';
        //testUser.UserRoleId = portalRole.Id;


        System.runAs(portalAccountOwner2) {
            insert testUser;

        }

       
        System.Runas(portalAccountOwner2) {

           
            
            
            ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
            objRemotCtx.storefront = 'SoftwareStore';
            objRemotCtx.currentCartId =TestCompletedTransactionSetUpRes1.order.ccrz__EncryptedId__c;
            //objRemotCtx.currentCartId=transecRes.order.OrderProcessedforFSD__c;
            //objRemotCtx.portalUserId = transecRes.objSetupDate.objUserID;
            objRemotCtx.portalUserId = testuser.id;
            ccrz.cc_CallContext.initRemoteContext(objRemotCtx);


            ccrz__E_Cart__c cart = TestCompletedTransactionSetUpRes1.cart;
            cart.OSM_Payment_Method__c = 'po';
            cart.ccrz__Account__c = portalAccount1.id;
            cart.ccrz__EncryptedId__c = objRemotCtx.currentCartId;
            update cart;

          
            List<ccrz__E_CartItem__c> listCartItems = new List<ccrz__E_CartItem__c>();
            ccrz__E_Product__c product = TestCompletedTransactionSetUpRes1.objSetupDate.compositeProduct;

            ccrz__E_CartItem__c cartItem = TestCompletedTransactionSetUpRes1.cartItem;
            //cartItem.ccrz__ParentCartItem__c=childCart.id;
            cartItem.ccrz__Product__c = product.id;
            cartItem.ccrz__Quantity__c = 2;
            // cartItem.ccrz__ItemTotal__c=10;
            cartItem.ccrz__Price__c = 10;
            cartItem.ccrz__ProductType__c = 'Bundle';
            cartItem.Unit_Dn_Price__c = 10.00;
            //cartItem.OSM_SW_AddOn_Product_Of__c=cart.id;
            update cartItem;
            listCartItems.add(cartItem);

            ccrz__E_CartItem__c cartItemChild = new ccrz__E_CartItem__c();
            cartItemChild.ccrz__Cart__c = cart.id;
            cartItemChild.OSM_SW_AddOn_Product_Of__c = cartItem.id;
            cartItemChild.ccrz__Product__c = product.id;
            cartItemChild.ccrz__ParentCartItem__c = cartItem.id;
            cartItemChild.ccrz__Quantity__c = 2;
            cartItemChild.ccrz__Price__c = 10;
            cartItemChild.ccrz__ProductType__c = 'Bundle';
            cartItemChild.Unit_Dn_Price__c = 10.00;
            //insert cartItemChild;
            listCartItems.add(cartItemChild);
            
            ccrz__E_Coupon__c coupon = new ccrz__E_Coupon__c();
            coupon.ccrz__CouponCode__c = Label.VOTECH100OFFINSITE;
            coupon.ccrz__CouponName__c = 'testName';
            coupon.ccrz__MaxUse__c = 12;
            coupon.ccrz__TotalUsed__c = 1;
            coupon.ccrz__DiscountAmount__c = 10;
            coupon.ccrz__CouponType__c ='Price';
            coupon.ccrz__DiscountType__c  ='Price';
            coupon.ccrz__RuleType__c = 'General';
            coupon.ccrz__TargetQty__c = 5;
            coupon.ccrz__TargetRelation__c = 'Product';
            coupon.ccrz__TargetProduct__c = TestCompletedTransactionSetUpRes1.objSetupDate.compositeProduct.Id;
            //coupon.OSM_Coupon_Discount_Target_Type__c='MSRP';
            //coupon.Subscription_Migration_Coupon__c = false;
            coupon.ccrz__Storefront__c='SoftwareStore';
            insert coupon;

            OSM_Existing_Subscription__c sub = new OSM_Existing_Subscription__c();
            sub.account__c = portalAccount1.id;
            sub.Is_Coupon_Already_Used__c = false;
            sub.Discount_for_Distributors_for_Backend__c = 10.0;
            sub.Dealer_Coupon_Code__c = coupon.ccrz__CouponCode__c;
            sub.Distributor_Coupon_Code__c = coupon.ccrz__CouponCode__c;
            insert sub;

            ccrz__E_Order__c ord = TestCompletedTransactionSetUpRes1.order;
            ord.ccrz__EncryptedId__c = '31f2c7a5-9977-49ae-bfd8-40038e689999';
            ord.OrderProcessedforFSD__c = true;
            ord.ccrz__Account__c = portalAccount1.id;
            ord.ccrz__OriginatedCart__c = cart.id;
            update ord;

            ccrz__E_OrderItem__c ordItem =TestCompletedTransactionSetUpRes1.orderItem;
            ordItem.ccrz__Coupon__c = coupon.id;
            ordItem.ccrz__ProductType__c = 'Bundle';
            ordItem.Dn_Price__c = 10;
            //update ordItem;
            
            ccrz__E_Product__c prod = TestCompletedTransactionSetUpRes1.objSetupDate.compositeProduct;
            prod.Name = Label.VOTECH100OFFINSITE;
            update prod;
            
            Test.StartTest();
            
            OSM_SW_CartPg_Ctrl.cartItemDetails(objRemotCtx);
            OSM_SW_CartPg_Ctrl.preApplyCoupon(objRemotCtx);
            OSM_SW_CartPg_Ctrl.postApplyCoupon(objRemotCtx);
            OSM_SW_CartPg_Ctrl.getCouponCode(objRemotCtx);
            
            portalAccount1.Type = 'Votech';
            update portalAccount1;
            
            OSM_SW_CartPg_Ctrl.getCouponCode(objRemotCtx);
            OSM_SW_CartPg_Ctrl.applyCouponValidation(Label.VOTECH100OFFINSITE, objRemotCtx);
            
            coupon.ccrz__CouponCode__c = Label.VOTECH100OFFQSOL;
            update coupon;
            prod.Name = Label.VOTECH100OFFQSOL;
            update prod;
            
            OSM_SW_CartPg_Ctrl.getCouponCode(objRemotCtx);
            OSM_SW_CartPg_Ctrl.applyCouponValidation(Label.VOTECH100OFFQSOL, objRemotCtx);
            
            portalAccount1.type = 'Distributor Account';
            update portalAccount1;
            
            OSM_SW_CartPg_Ctrl.getCouponCode(objRemotCtx);
            
            portalAccount1.type = 'Fleet';
            update portalAccount1;
            OSM_SW_CartPg_Ctrl.hasRenewIMMsg cartPgMMsg = new OSM_SW_CartPg_Ctrl.hasRenewIMMsg();
            OSM_SW_CartPg_Ctrl.getCouponCode(objRemotCtx);
            OSM_SW_CartPg_Ctrl.cartItemDetailsSubsc(objRemotCtx);
            OSM_SW_CartPg_Ctrl.ShowcartItemValidationsMsg(objRemotCtx);
            //OSM_SW_CartPg_Ctrl.ShowWarningMsgPaymentOrder(objRemotCtx);
            
            ccrz__E_Coupon__c objCoup = new ccrz__E_Coupon__c(ccrz__CouponCode__c = '12345', ccrz__CouponId__c = '54321',
                                                                ccrz__CouponName__c = 'test', ccrz__MaxUse__c = 10, ccrz__DiscountAmount__c = 0,
                                                                ccrz__CouponType__c ='Price', ccrz__DiscountType__c  ='Price', ccrz__RuleType__c = 'General', ccrz__TargetQty__c = 5,
                                                                ccrz__TargetRelation__c = 'Product', ccrz__Storefront__c='SoftwareStore',
                                                                ccrz__TotalUsed__c = 1, ccrz__TargetProduct__c = TestCompletedTransactionSetUpRes1.objSetupDate.compositeProduct.Id);
            insert objCoup;

            ccrz__E_CartCoupon__c objCC = new ccrz__E_CartCoupon__c(ccrz__Cart__c = cartItemChild.ccrz__Cart__c, ccrz__Coupon__c = objCoup.Id);
            insert objCC;
            List<ccrz__E_CartCoupon__c> listCartCoupon = new List<ccrz__E_CartCoupon__c>();
            listCartCoupon.add(objCC);
            Test.setCurrentPageReference(new PageReference('Page.OSM_SW_CartPg')); 
            System.currentPageReference().getParameters().put('cartId', objRemotCtx.currentCartId);
            OSM_SW_CartPg_Ctrl objCtrl = new OSM_SW_CartPg_Ctrl();
            
            OSM_SW_CartPg_Ctrl.OSMApplyCoupon(objRemotCtx, new Map < String, Decimal > { 'CIIdToPrice' => 10 }, '12345', true);
           // OSM_SW_CartPg_Ctrl.OSMDeleteCoupon(objRemotCtx, '12345');
            OSM_SW_CartPg_Ctrl.customUpdateCart(objRemotCtx, new map < String, Integer > { TestCompletedTransactionSetUpRes1.cartItem.Id => 15});
            try{
            OSM_SW_CartPg_Ctrl.OSMDeleteCoupon(objRemotCtx, '12345');
            OSM_SW_CartPg_Ctrl.validateCouponCodeQty(listCartItems,listCartCoupon);
            } catch (Exception ex) {}
            Test.StopTest();
        }
    }
  
    static testMethod void OSM_SW_CartPg_Ctrl_TestMethod4() {
        
        TestProductSetupReq testProductSetupReq1 = OSM_TestDataCreationUtility.populatedTestProductSetupReq();
        TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes1 = OSM_TestDataCreationUtility.createProductSetUp(testProductSetupReq1);
        //TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes1=OSM_TestDataCreationUtility.createCompletedTransactionFlowTestData(testProductSetupRes1,20000.0, 10.0);   
        Account account = testCompletedTransactionSetUpRes1.objSetupDate.account;

        IAM_Trigger_Switches__mdt md=new IAM_Trigger_Switches__mdt();
        md.IAM_Active__c=false;
       

        User usr = [Select id from User where Id =: UserInfo.getUserId()];


        Id portal_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community' Limit 1 ].Id;
        //Id roleId=[select id,name from UserRole where name='CumminsFleetsCustomerUser' limit 1].id; 

        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        system.debug('portalRole is ' + portalRole);

        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
      
            
        User portalAccountOwner2 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = 'test24446@test.com',
            Alias = 'batman',
            Email = 'bruce.wayne@wayneenterprises.com',
            EmailEncodingKey = 'UTF-8',
            Firstname = 'Bruce',
            Lastname = 'Wayne',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Chicago',
            OSM_Storefront_User_Type__c ='Distributor Admin'
        );
        Database.insert(portalAccountOwner2);

        Account portalAccount1 = new Account(
            Name = 'TestAccount1',
            OwnerId = portalAccountOwner2.Id,
            OSM_Preferred_Billing_Frequency_Lock__c = true,
            BMS_Customer_ID__c = '1234',
            OSM_Preferred_Payment_Method__c = 'po',
            OSM_Preferred_Payment_IsBolt_PO__c = false,
            type = 'Distributor Account',
            BillingCountry='United States'
            
            
        );
        System.runAs(portalAccountOwner2) {
            Database.insert(portalAccount1);
            //account.type = 'Dealer Account';
            account.BOLT_Account_Number__c = null;
            account.BMS_Customer_ID__c = '1234';
            account.Name='testAccount';
            update account;
        }

        //Create contact
        Contact contact1 = new Contact(
            FirstName = 'Test',
            Lastname = 'McTesty',
            IAM_Contact_Status__c='Pending',
            Username__c = 'testUserName220@gmail.com',
            AccountId = portalAccount1.Id,
            IAM_From_JIT_Execution__c=true,
            Email = 'test852@cummins.com'
        );
       // Email = 'test@test.com'
        System.runAs(portalAccountOwner2) {
            Database.insert(contact1);
        }

        //Create user
        //Profile portalProfile = [SELECT Id FROM Profile Limit 1];


        User testUser = new User();
        testUser.FirstName = 'Testttt';
        testUser.LastName = 'lasttt';
        testUser.UserName = 'test2@test.com';
        testUser.Email = 'bruce.wayne@wayneenterprises.com';
        testUser.Alias = 'batman';
        testUser.ContactId = contact1.Id;
        testUser.CommunityNickname = 'test12345l';
        testUser.ProfileId = portal_PROFILE_ID;
        testUser.TimeZoneSidKey = 'America/Los_Angeles';
        testUser.isActive = true;
        testUser.LocaleSidKey = 'en_US';
        testUser.LanguageLocaleKey = 'en_US';
        testUser.EmailEncodingKey = 'ISO-8859-1';
        //testUser.UserRoleId = portalRole.Id;


        System.runAs(portalAccountOwner2) {
            insert testUser;

        }

       
        System.Runas(portalAccountOwner2) {

           
            
            
            ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
            objRemotCtx.storefront = 'SoftwareStore';
            objRemotCtx.currentCartId =TestCompletedTransactionSetUpRes1.order.ccrz__EncryptedId__c;
            //objRemotCtx.currentCartId=transecRes.order.OrderProcessedforFSD__c;
            //objRemotCtx.portalUserId = transecRes.objSetupDate.objUserID;
            objRemotCtx.portalUserId = testuser.id;
            ccrz.cc_CallContext.initRemoteContext(objRemotCtx);


            ccrz__E_Cart__c cart = TestCompletedTransactionSetUpRes1.cart;
            cart.OSM_Payment_Method__c = 'po';
            cart.ccrz__Account__c = portalAccount1.id;
            cart.ccrz__EncryptedId__c = objRemotCtx.currentCartId;
            update cart;

            List<ccrz__E_CartItem__c> listCartItems = new List<ccrz__E_CartItem__c>();
            ccrz__E_Product__c product = TestCompletedTransactionSetUpRes1.objSetupDate.compositeProduct;

            ccrz__E_CartItem__c cartItem = TestCompletedTransactionSetUpRes1.cartItem;
            //cartItem.ccrz__ParentCartItem__c=childCart.id;
            cartItem.ccrz__Product__c = product.id;
            cartItem.ccrz__Quantity__c = 2;
            // cartItem.ccrz__ItemTotal__c=10;
            cartItem.ccrz__Price__c = 10;
            cartItem.ccrz__ProductType__c = 'Bundle';
            cartItem.Unit_Dn_Price__c = 10.00;
            //cartItem.OSM_SW_AddOn_Product_Of__c=cart.id;
            update cartItem;
            listCartItems.add(cartItem);

            ccrz__E_CartItem__c cartItemChild = new ccrz__E_CartItem__c();
            cartItemChild.ccrz__Cart__c = cart.id;
            cartItemChild.OSM_SW_AddOn_Product_Of__c = cartItem.id;
            cartItemChild.ccrz__Product__c = product.id;
            cartItemChild.ccrz__ParentCartItem__c = cartItem.id;
            cartItemChild.ccrz__Quantity__c = 2;
            cartItemChild.ccrz__Price__c = 10;
            cartItemChild.ccrz__ProductType__c = 'Bundle';
            cartItemChild.Unit_Dn_Price__c = 10.00;
            //insert cartItemChild;
            listCartItems.add(cartItemChild);
            
            ccrz__E_Coupon__c coupon = new ccrz__E_Coupon__c();
            coupon.ccrz__CouponCode__c = Label.VOTECH100OFFINSITE;
            coupon.ccrz__CouponName__c = 'testName';
            coupon.ccrz__MaxUse__c = 12;
            coupon.ccrz__TotalUsed__c = 1;
            coupon.ccrz__DiscountAmount__c = 10;
            coupon.ccrz__CouponType__c ='Price';
            coupon.ccrz__DiscountType__c  ='Price';
            coupon.ccrz__RuleType__c = 'General';
            coupon.ccrz__TargetQty__c = 5;
            coupon.ccrz__TargetRelation__c = 'Product';
            coupon.ccrz__CouponType__c = 'Percentage';
            coupon.ccrz__TargetProduct__c = TestCompletedTransactionSetUpRes1.objSetupDate.compositeProduct.Id;
            // coupon.OSM_Coupon_Discount_Target_Type__c='MSRP';
            //coupon.Subscription_Migration_Coupon__c = false;
            coupon.ccrz__Storefront__c='SoftwareStore';
            insert coupon;

            OSM_Existing_Subscription__c sub = new OSM_Existing_Subscription__c();
            sub.account__c = portalAccount1.id;
            sub.Is_Coupon_Already_Used__c = false;
            sub.Discount_for_Distributors_for_Backend__c = 10.0;
            sub.Dealer_Coupon_Code__c = coupon.ccrz__CouponCode__c;
            sub.Distributor_Coupon_Code__c = coupon.ccrz__CouponCode__c;
            insert sub;

            ccrz__E_Order__c ord = TestCompletedTransactionSetUpRes1.order;
            ord.ccrz__EncryptedId__c = '31f2c7a5-9977-49ae-bfd8-40038e689999';
            ord.OrderProcessedforFSD__c = true;
            ord.ccrz__Account__c = portalAccount1.id;
            ord.ccrz__OriginatedCart__c = cart.id;
            update ord;

            ccrz__E_OrderItem__c ordItem =TestCompletedTransactionSetUpRes1.orderItem;
            ordItem.ccrz__Coupon__c = coupon.id;
            ordItem.ccrz__ProductType__c = 'Bundle';
            ordItem.Dn_Price__c = 10;
            //update ordItem;
            
            ccrz__E_Product__c prod = TestCompletedTransactionSetUpRes1.objSetupDate.compositeProduct;
            prod.Name = Label.VOTECH100OFFINSITE;
            update prod;
            
            Test.StartTest();
                      
            portalAccount1.type = 'Fleet';
            update portalAccount1;
            
            OSM_SW_CartPg_Ctrl.hasRenewIMMsg cartPgMMsg = new OSM_SW_CartPg_Ctrl.hasRenewIMMsg();
            
            ccrz__E_Coupon__c objCoup = new ccrz__E_Coupon__c(ccrz__CouponCode__c = '12345', ccrz__CouponId__c = '54321',
                                                                ccrz__CouponName__c = 'test', ccrz__MaxUse__c = 10, ccrz__DiscountAmount__c = 0,
                                                                 ccrz__DiscountType__c  ='Price', ccrz__RuleType__c = 'General', ccrz__TargetQty__c = 5,
                                                                ccrz__TargetRelation__c = 'Product',ccrz__CouponType__c = 'Percentage', ccrz__Storefront__c='SoftwareStore',
                                                                ccrz__TotalUsed__c = 1, ccrz__TargetProduct__c = TestCompletedTransactionSetUpRes1.objSetupDate.compositeProduct.Id);
            insert objCoup;

            Test.setCurrentPageReference(new PageReference('Page.OSM_SW_CartPg')); 
            System.currentPageReference().getParameters().put('cartId', objRemotCtx.currentCartId);
            OSM_SW_CartPg_Ctrl objCtrl = new OSM_SW_CartPg_Ctrl();
            OSM_SW_CartPg_Ctrl.hasRenewIMMsg obb = new OSM_SW_CartPg_Ctrl.hasRenewIMMsg();
            obb.showMsg=true;
            obb.cartItemId=cartItem.Id;
            
            OSM_SW_CartPg_Ctrl.CartValidationMsg obb1 = new OSM_SW_CartPg_Ctrl.CartValidationMsg();
            obb1.showMsg1=true;
            obb1.showMsg2=true;
            obb1.cartItemIds=cartItem.Id;
            
            try{
            OSM_SW_CartPg_Ctrl.OSMApplyCoupon(objRemotCtx, new Map < String, Decimal > { 'CIIdToPrice' => 10 }, '12345', true);
            } catch (Exception ex) {}
            Test.StopTest();
        }
    }  
  }