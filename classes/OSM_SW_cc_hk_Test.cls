/*********************************************/
//Test Class for the class OSM_SW_cc_hk_Invoice Mar-1411
// 22/7/21 Subbu K MAR-1861
/***********************************************
 History
 --------
 VERSION    AUTHOR          DATE            DETAILS
 1.0        Singaiah        22/04/2021      MAR-1618 Story
 2.0        Sharad          22/07/2021      MAR-1844 Story 
 3.0        Sharad          24/09/2021      updated
 4.0        Sharad          29/09/2021      updated
 4.2        Ashish          01/03/2022      updated
 4.3        Singaiah       05/04/2022      updated
 3.0        Sangeeta        11/02/2022      Updated
 4.3       Ashish          01/03/2022      updated
 4.4        Singaiah       05/04/2022      updated
 5.0        Singaiah       10/06/2022      updated
 */
@isTest
public class OSM_SW_cc_hk_Test {


static testMethod void testMethodForOrdersample1() {    
    
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
       Test.StartTest();
        User usr = [Select id from User where Id =: UserInfo.getUserId()];

      Id portal_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community' Limit 1 ].Id;
          //Id roleId=[select id,name from UserRole where name='CumminsFleetsCustomerUser' limit 1].id; 
           
         UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
          system.debug('portalRole is ' + portalRole);

          Profile profile1 = [Select Id from Profile where name = 'System Administrator' Limit 1];
    system.debug('profile1 is ' + profile1);
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
          TimeZoneSidKey='America/Chicago',
          OSM_Storefront_User_Type__c ='Distributor Admin'
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
          IAM_Contact_Status__c='Pending',
          Username__c = 'testUserName6343354@gmail.com',
          AccountId = portalAccount2.Id,
          Email ='test@test.com'
          );
          System.runAs(portalAccountOwner2){
              Database.insert(contact1);
          }
          
          System.runAs(transecRes.objSetupDate.loggedInUser) {
           Attachment attachment = new Attachment();
            attachment.Body = Blob.valueOf('test data');
            attachment.Name = String.valueOf('FSDInvoice.txt');
            attachment.ParentId = transecRes.invoice.Id;
            insert attachment;
            system.debug('==Attachment inserted==');
          }
    
        User testUser = new User();
          testUser.FirstName = 'Testttt';
          testUser.LastName = 'lasttt';
          testUser.UserName = 'test23425918@test.com'; //changed to bypass test failure in prod
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
            //Test.startTest();
            Account account = transecRes.objSetupDate.account;
            //account.Bolt_Customer_Account_Status__c = 'Active';
            account.BillingCountry='United States';
            update account;
            Contact contact2 = new Contact(
              FirstName = 'Test1232',
              Lastname = 'McTesty9356',
              IAM_Contact_Status__c='Pending',
              Username__c = 'testUserName6745489@gmail.com',
              AccountId = account.Id,
              Email ='test129@test.com',
              IAM_Contact_Owner__c =portalAccountOwner2.id
              );
              insert contact2;
            effectiveAccount_enable_ProfileUserType__c effAccPro = new effectiveAccount_enable_ProfileUserType__c();
            effAccPro.Name ='Distributor Admin';
            effAccPro.Enable_Effective_Account_Selection__c=true;
            insert effAccPro;
            effectiveAccount_enable_ProfileUserType__c effAccPro1 = new effectiveAccount_enable_ProfileUserType__c();
            effAccPro1.Name ='Regular';
            effAccPro1.Enable_Effective_Account_Selection__c=true;
            insert effAccPro1;
            effectiveAccount_enable_ProfileUserType__c effAccPro2 = new effectiveAccount_enable_ProfileUserType__c();
            effAccPro2.Name ='SSOEM Admin';
            effAccPro2.Enable_Effective_Account_Selection__c=true;
            insert effAccPro2;
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

            //Test.startTest();

            OSM_SW_cc_hk_Order objCls = new OSM_SW_cc_hk_Order();
            Map < String, Object > returnMap = objCls.place(inputMap);
            OSM_SW_cc_hk_Order.processRefundForFailedOSMOrderPlacedProcess();
            
            
            
            
            inputMap = new Map < String, Object > ();
            inputMap.put('searchData', '{\"ascending\":\"true\"}');
            objRemotCtx = new ccrz.cc_RemoteActionContext();
            objRemotCtx.storefront = 'SoftwareStore';
            objRemotCtx.currentCartId = transecRes.cart.ccrz__EncryptedId__c;
            objRemotCtx.portalUserId = transecRes.objSetupDate.objUserID;

            try {
                ccrz.cc_CallContext.initRemoteContext(objRemotCtx);

            ccrz__E_Invoice__c objInv = new ccrz__E_Invoice__c();
            objInv.ccrz__Status__c = 'Revoked';
            objInv.Sub_Status__c = 'Open';
            objInv.BMS_Invoice_No__c='123';
            objInv.Invoice_Type__c='Credit Memo';
            insert objInv;
            
            Attachment attachment = new Attachment();
            attachment.Body = Blob.valueOf('test data');
            attachment.Name = String.valueOf('FSDInvoice.txt');
            attachment.ParentId = objInv.Id;
            insert attachment;
           
            List<Map<String,Object>> ab = new List<Map<String,Object>>();
            Map<String,Object> xy = new Map<String,Object>();
            xy.put('sfid',(object)objInv.Id);
            ab.add(xy);
            
            OSM_SW_cc_hk_Invoice invoiceCls = new OSM_SW_cc_hk_Invoice();
            
            invoiceCls.invMap=ab;
            system.debug('Inside Test method');
            returnMap = invoiceCls.fetchInvoices(inputMap);
                
            } catch (Exception ex) {}
            
            

            Test.stopTest();

        }
    }
    static testMethod void testMethodForOrdersample6() {

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
         Test.StartTest();
        User usr = [Select id from User where Id =: UserInfo.getUserId()];

        
         Id portal_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community' Limit 1 ].Id;
          //Id roleId=[select id,name from UserRole where name='CumminsFleetsCustomerUser' limit 1].id; 
           
         UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
          system.debug('portalRole is ' + portalRole);

          Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
          User portalAccountOwner2 = new User(
          UserRoleId = portalRole.Id,
          ProfileId = profile1.Id,
          Username ='test2454354446@test.com',
          Alias = 'batman',
          Email='bruce.wayne@wayneenterprises.com',
          EmailEncodingKey='UTF-8',
          Firstname='Bruce',
          Lastname='Wayne',
          LanguageLocaleKey='en_US',
          LocaleSidKey='en_US',
          TimeZoneSidKey='America/Chicago',
          OSM_Storefront_User_Type__c ='Distributor Admin'
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
          IAM_Contact_Status__c='Pending',
          Username__c = 'testUserName654@gmail.com',
          AccountId = portalAccount2.Id,
          Email ='test@test.com'
          );
          System.runAs(portalAccountOwner2){
              Database.insert(contact1);
          }
          
          System.runAs(transecRes.objSetupDate.loggedInUser) {
           Attachment attachment = new Attachment();
            attachment.Body = Blob.valueOf('test data');
            attachment.Name = String.valueOf('FSDInvoice.txt');
            attachment.ParentId = transecRes.invoice.Id;
            insert attachment;
            system.debug('==Attachment inserted==');
          }
    
        User testUser = new User();
          testUser.FirstName = 'Testttt';
          testUser.LastName = 'lasttt';
          testUser.UserName = 'test43543542@test.com'; //changed to bypass test failure in prod
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
            //Test.startTest();
            Account account = transecRes.objSetupDate.account;
            account.Bolt_Customer_Account_Status__c = 'Active';
            account.BillingCountry='United States';
            update account;
            Contact contact2 = new Contact(
              FirstName = 'Test12',
              Lastname = 'McTesty9356',
              IAM_Contact_Status__c='Pending',
              Username__c = 'testUserName6789@gmail.com',
              AccountId = account.Id,
              Email ='test129@test.com',
              IAM_Contact_Owner__c =portalAccountOwner2.id
              );
              insert contact2;
            effectiveAccount_enable_ProfileUserType__c effAccPro = new effectiveAccount_enable_ProfileUserType__c();
            effAccPro.Name ='Distributor Admin';
            effAccPro.Enable_Effective_Account_Selection__c=true;
            insert effAccPro;
            effectiveAccount_enable_ProfileUserType__c effAccPro1 = new effectiveAccount_enable_ProfileUserType__c();
            effAccPro1.Name ='Regular';
            effAccPro1.Enable_Effective_Account_Selection__c=true;
            insert effAccPro1;
            effectiveAccount_enable_ProfileUserType__c effAccPro2 = new effectiveAccount_enable_ProfileUserType__c();
            effAccPro2.Name ='SSOEM Admin';
            effAccPro2.Enable_Effective_Account_Selection__c=true;
            insert effAccPro2;
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

            

            OSM_SW_cc_hk_Order objCls = new OSM_SW_cc_hk_Order();
            Map < String, Object > returnMap = objCls.place(inputMap);
            OSM_SW_cc_hk_Order.processRefundForFailedOSMOrderPlacedProcess();
            
            
            
            
            inputMap = new Map < String, Object > ();
            inputMap.put('searchData', '{\"ascending\":\"true\"}');
            objRemotCtx = new ccrz.cc_RemoteActionContext();
            objRemotCtx.storefront = 'SoftwareStore';
            objRemotCtx.currentCartId = transecRes.cart.ccrz__EncryptedId__c;
            objRemotCtx.portalUserId = transecRes.objSetupDate.objUserID;

            try {
                ccrz.cc_CallContext.initRemoteContext(objRemotCtx);

            ccrz__E_Invoice__c objInv = new ccrz__E_Invoice__c();
            objInv.ccrz__Status__c = 'Revoked';
            objInv.Sub_Status__c = 'Open';
            objInv.BMS_Invoice_No__c='123';
            objInv.Invoice_Type__c='Credit Memo';
            insert objInv;
            
            Attachment attachment = new Attachment();
            attachment.Body = Blob.valueOf('test data');
            attachment.Name = String.valueOf('FSDInvoice.txt');
            attachment.ParentId = objInv.Id;
            insert attachment;
           
            List<Map<String,Object>> ab = new List<Map<String,Object>>();
            Map<String,Object> xy = new Map<String,Object>();
            xy.put('sfid',(object)objInv.Id);
            ab.add(xy);
            
            OSM_SW_cc_hk_Invoice invoiceCls = new OSM_SW_cc_hk_Invoice();
            
            invoiceCls.invMap=ab;
            system.debug('Inside Test method');
            returnMap = invoiceCls.fetchInvoices(inputMap);
                
            } catch (Exception ex) {}
            
            

            Test.stopTest();

        }
    }
    static testMethod void testMethodinvoiceGOMS() {

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
          Test.StartTest();
        User usr = [Select id from User where Id =: UserInfo.getUserId()];

        
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
          TimeZoneSidKey='America/Chicago',
          OSM_Storefront_User_Type__c ='Distributor Admin'
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
          
          System.runAs(transecRes.objSetupDate.loggedInUser) {
           Attachment attachment = new Attachment();
            attachment.Body = Blob.valueOf('test data');
            attachment.Name = String.valueOf('FSDInvoice.txt');
            attachment.ParentId = transecRes.invoice.Id;
            insert attachment;
            system.debug('==Attachment inserted==');

          }
          User testUser = new User();
          testUser.FirstName = 'Testttt';
          testUser.LastName = 'lasttt';
          testUser.UserName = 'test245451345@test.com'; //changed to bypass test failure in prod
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
            //Test.startTest();
            Account account = transecRes.objSetupDate.account;
            account.Bolt_Customer_Account_Status__c = 'Active';
            account.BillingCountry='United States';
            update account;
            
            Contact contact2 = new Contact(
              FirstName = 'Test12',
              Lastname = 'McTesty9356',
              IAM_Contact_Status__c='Pending',
              Username__c = 'testUserName6789@gmail.com',
              AccountId = account.Id,
              Email ='test129@test.com',
              IAM_Contact_Owner__c =portalAccountOwner2.id
              );
              insert contact2;

            effectiveAccount_enable_ProfileUserType__c effAccPro = new effectiveAccount_enable_ProfileUserType__c();
            effAccPro.Name ='Distributor Admin';
            effAccPro.Enable_Effective_Account_Selection__c=true;
            insert effAccPro;
            effectiveAccount_enable_ProfileUserType__c effAccPro1 = new effectiveAccount_enable_ProfileUserType__c();
            effAccPro1.Name ='Regular';
            effAccPro1.Enable_Effective_Account_Selection__c=true;
            insert effAccPro1;
            effectiveAccount_enable_ProfileUserType__c effAccPro2 = new effectiveAccount_enable_ProfileUserType__c();
            effAccPro2.Name ='SSOEM Admin';
            effAccPro2.Enable_Effective_Account_Selection__c=true;
            insert effAccPro2;
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


            OSM_SW_cc_hk_Order objCls = new OSM_SW_cc_hk_Order();
            Map < String, Object > returnMap = objCls.place(inputMap);
            OSM_SW_cc_hk_Order.processRefundForFailedOSMOrderPlacedProcess();
            
          
            
            inputMap = new Map < String, Object > ();
            inputMap.put('searchData', '{\"ascending\":\"true\"}');
            objRemotCtx = new ccrz.cc_RemoteActionContext();
            objRemotCtx.storefront = 'SoftwareStore';
            objRemotCtx.currentCartId = transecRes.cart.ccrz__EncryptedId__c;
            objRemotCtx.portalUserId = transecRes.objSetupDate.objUserID;

            try {
                ccrz.cc_CallContext.initRemoteContext(objRemotCtx);

            ccrz__E_Order__c ordr = new ccrz__E_Order__c();
        ordr.ccrz__Storefront__c = 'SoftwareStore';
        ordr.ccrz__Account__c = account.Id;
        ordr.OrderProcessedforFSD__c = true;
        ordr.IsInterCompanyProcessSuccess__c = false;
        //o1.ccrz__AbsoluteDiscount__c = 
        ordr.ccrz__CurrencyISOCode__c = 'USD';
        ordr.ccrz__OrderStatus__c = 'Order Submitted';
        insert ordr;        
            
            
            
            ccrz__E_Invoice__c objInv = new ccrz__E_Invoice__c();
            objInv.Id = transecRes.invoice.Id;
            objInv.ccrz__Status__c = 'test';
            objInv.Sub_Status__c = 'test';
            //objInv.ccrz__CCOrder__c = ordr.id;
            objInv.BMS_Invoice_No__c='123';
            objInv.OSM_SW_Is_Bolt_PO__c=false;
            objInv.Invoice_Type__c='Invoice';
            objInv.Is_GOMS_Intercompany_Invoice__c=true;
            objInv.GOMS_Invoice_ID__c='234';
            objInv.ccrz__BillTo__c=account.id;
            objInv.Payment_Method__c='po';
            //objInv.ccrz__DateDue__c= date.parse('2020-06-02');
  
            update objInv;
           
        ccrz__E_InvoiceItem__c invoiceItem_Item = new ccrz__E_InvoiceItem__c();
        invoiceItem_Item.ccrz__OriginalAmount__c = 1000;
        invoiceItem_Item.ccrz__Invoice__c = objInv.id;
        //invoiceItem_Item.ccrz__CCOrderItem__c = oi11.id;
        //invoiceItem_Item.ccrz__CCOrder__c = o1.id;
        invoiceItem_Item.Quantity__c = 1;
        //invoiceItem_Item.CC_Subscription__c = subscriptionID;
        invoiceItem_Item.ccrz__Status__c = 'Open';
        invoiceItem_Item.ccrz__Type__c = 'Item';
        insert invoiceItem_Item;
            
            
            
            
            Attachment attachment = new Attachment();
            attachment.Body = Blob.valueOf('test data');
            attachment.Name = String.valueOf('FSDInvoice.txt');
            attachment.ParentId = objInv.Id;
            insert attachment;
           
            List<Map<String,Object>> ab = new List<Map<String,Object>>();
            Map<String,Object> xy = new Map<String,Object>();
            xy.put('sfid',(object)objInv.Id);
            ab.add(xy);
            
            OSM_SW_cc_hk_Invoice invoiceCls = new OSM_SW_cc_hk_Invoice();
            invoiceCls.invMap=ab;
            system.debug('Inside Test method');
            returnMap = invoiceCls.fetchInvoices(inputMap);
                
            } catch (Exception ex) {}
            
            

            Test.stopTest();

        }
    }
    static testMethod void testMethodinvoiceordernotnull3() {

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
        
         Test.StartTest();
        User usr = [Select id from User where Id =: UserInfo.getUserId()];

        
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
          TimeZoneSidKey='America/Chicago',
          OSM_Storefront_User_Type__c ='Distributor Admin'
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
          
          System.runAs(transecRes.objSetupDate.loggedInUser) {
           Attachment attachment = new Attachment();
            attachment.Body = Blob.valueOf('test data');
            attachment.Name = String.valueOf('FSDInvoice.txt');
            attachment.ParentId = transecRes.invoice.Id;
            insert attachment;
            system.debug('==Attachment inserted==');

          }
          User testUser = new User();
          testUser.FirstName = 'Testttt';
          testUser.LastName = 'lasttt';
          testUser.UserName = 'test209988343@test.com'; //changed to bypass test failure in prod
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
            //Test.startTest();
            Account account = transecRes.objSetupDate.account;
            account.Bolt_Customer_Account_Status__c = 'Active';
            account.BillingCountry='United States';
            update account;
            
            Contact contact2 = new Contact(
              FirstName = 'Test12',
              Lastname = 'McTesty9356',
              IAM_Contact_Status__c='Pending',
              Username__c = 'testUserName6789@gmail.com',
              AccountId = account.Id,
              Email ='test129@test.com',
              IAM_Contact_Owner__c =portalAccountOwner2.id
              );
              insert contact2;

            effectiveAccount_enable_ProfileUserType__c effAccPro = new effectiveAccount_enable_ProfileUserType__c();
            effAccPro.Name ='Distributor Admin';
            effAccPro.Enable_Effective_Account_Selection__c=true;
            insert effAccPro;
            effectiveAccount_enable_ProfileUserType__c effAccPro1 = new effectiveAccount_enable_ProfileUserType__c();
            effAccPro1.Name ='Regular';
            effAccPro1.Enable_Effective_Account_Selection__c=true;
            insert effAccPro1;
            effectiveAccount_enable_ProfileUserType__c effAccPro2 = new effectiveAccount_enable_ProfileUserType__c();
            effAccPro2.Name ='SSOEM Admin';
            effAccPro2.Enable_Effective_Account_Selection__c=true;
            insert effAccPro2;
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


            OSM_SW_cc_hk_Order objCls = new OSM_SW_cc_hk_Order();
            Map < String, Object > returnMap = objCls.place(inputMap);
            OSM_SW_cc_hk_Order.processRefundForFailedOSMOrderPlacedProcess();
            
          
            
            inputMap = new Map < String, Object > ();
            inputMap.put('searchData', '{\"ascending\":\"true\"}');
            objRemotCtx = new ccrz.cc_RemoteActionContext();
            objRemotCtx.storefront = 'SoftwareStore';
            objRemotCtx.currentCartId = transecRes.cart.ccrz__EncryptedId__c;
            objRemotCtx.portalUserId = transecRes.objSetupDate.objUserID;

            try {
                ccrz.cc_CallContext.initRemoteContext(objRemotCtx);

            ccrz__E_Order__c ordr = new ccrz__E_Order__c();
        ordr.ccrz__Storefront__c = 'SoftwareStore';
        ordr.ccrz__Account__c = account.Id;
        ordr.OrderProcessedforFSD__c = true;
        ordr.IsInterCompanyProcessSuccess__c = false;
        //o1.ccrz__AbsoluteDiscount__c = 
        ordr.ccrz__CurrencyISOCode__c = 'USD';
        ordr.ccrz__OrderStatus__c = 'Order Submitted';
        insert ordr;
            
            ccrz__E_Invoice__c objInv = new ccrz__E_Invoice__c();
             objInv.Id = transecRes.invoice.Id;
            objInv.ccrz__Status__c = 'Open';
            objInv.Sub_Status__c = 'Open';
            objInv.ccrz__CCOrder__c = ordr.id;
            //objInv.BMS_Invoice_No__c='123';
            //objInv.OSM_SW_Is_Bolt_PO__c=false;
            objInv.Invoice_Type__c='Invoice';
            //objInv.Is_GOMS_Intercompany_Invoice__c=true;
           // objInv.GOMS_Invoice_ID__c='234';
            objInv.ccrz__BillTo__c=account.id;
            objInv.Payment_Method__c='po';
           // objInv.ccrz__DateDue__c= date.parse('2020-06-02');
            update objInv;


            
            Attachment attachment = new Attachment();
            attachment.Body = Blob.valueOf('test data');
            attachment.Name = String.valueOf('FSDInvoice.txt');
            attachment.ParentId = objInv.Id;
            insert attachment;
           
            List<Map<String,Object>> ab = new List<Map<String,Object>>();
            Map<String,Object> xy = new Map<String,Object>();
            xy.put('sfid',(object)objInv.Id);
            ab.add(xy);
            
            OSM_SW_cc_hk_Invoice invoiceCls = new OSM_SW_cc_hk_Invoice();
            invoiceCls.invMap=ab;
            system.debug('Inside Test method');
            returnMap = invoiceCls.fetchInvoices(inputMap);
                
            } catch (Exception ex) {}
            
            

            Test.stopTest();

        }
    }
    
    static testMethod void testMethodinvoiceordernull3() {

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
        Test.startTest();
         User usr = [Select id from User where Id =: UserInfo.getUserId()];
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
          TimeZoneSidKey='America/Chicago',
          OSM_Storefront_User_Type__c ='Distributor Admin'
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
        
          Account portalAccount3 = new Account(
          Name = 'TestAccount3',
          OwnerId = portalAccountOwner2.Id,
          OSM_Preferred_Billing_Frequency_Lock__c=false,
          BMS_Customer_ID__c='12343',
          OSM_Preferred_Payment_Method__c='po',
          OSM_Preferred_Payment_IsBolt_PO__c=false
          );
        
          System.runAs(portalAccountOwner2){
              Database.insert(portalAccount2);
              Database.insert(portalAccount3);
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
          
          System.runAs(transecRes.objSetupDate.loggedInUser) {
           Attachment attachment = new Attachment();
           attachment.Body = Blob.valueOf('test data');
           attachment.Name = String.valueOf('FSDInvoice.txt');
           attachment.ParentId = transecRes.invoice.Id;
           insert attachment;
              
           system.debug('==Attachment inserted==');
          }
        
          User testUser = new User();
          testUser.FirstName = 'Testttt';
          testUser.LastName = 'lasttt';
          testUser.UserName = 'test24534534500911@test.com'; //changed to bypass test failure in prod
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
          account.BillingCountry='United States';
        update account;
            
          Contact contact2 = new Contact(
              FirstName = 'Test12',
              Lastname = 'McTesty9356',
              IAM_Contact_Status__c='Pending',
              Username__c = 'testUserName6789@gmail.com',
              AccountId = account.Id,
              Email ='test129@test.com',
              IAM_Contact_Owner__c =portalAccountOwner2.id
              );
         insert contact2;

            effectiveAccount_enable_ProfileUserType__c effAccPro = new effectiveAccount_enable_ProfileUserType__c();
            effAccPro.Name ='Distributor Admin';
            effAccPro.Enable_Effective_Account_Selection__c=true;
         insert effAccPro;
              
            effectiveAccount_enable_ProfileUserType__c effAccPro1 = new effectiveAccount_enable_ProfileUserType__c();
            effAccPro1.Name ='Regular';
            effAccPro1.Enable_Effective_Account_Selection__c=true;
         insert effAccPro1;
              
            effectiveAccount_enable_ProfileUserType__c effAccPro2 = new effectiveAccount_enable_ProfileUserType__c();
            effAccPro2.Name ='SSOEM Admin';
            effAccPro2.Enable_Effective_Account_Selection__c=true;
         insert effAccPro2;
              
            Map < String, Object > inputMap = new Map < String, Object > ();
            ccrz__E_Cart__c newCartobj = new ccrz__E_Cart__c();
              
            newCartobj.Id = transecRes.cart.Id;
            newCartobj.ccrz__Account__c = transecRes.order.ccrz__Account__c;
          update newCartobj;
            
            inputMap.put('placeStep', 'end');
            inputMap.put('cartId', newCartobj.Id);
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

          //Test.startTest();

            OSM_SW_cc_hk_Order objCls = new OSM_SW_cc_hk_Order();
            Map < String, Object > returnMap = objCls.place(inputMap);
            OSM_SW_cc_hk_Order.processRefundForFailedOSMOrderPlacedProcess();
              
            inputMap = new Map < String, Object > ();
            inputMap.put('searchData', '{\"ascending\":\"true\"}');
            
            objRemotCtx = new ccrz.cc_RemoteActionContext();
            objRemotCtx.storefront = 'SoftwareStore';
            objRemotCtx.currentCartId = transecRes.cart.ccrz__EncryptedId__c;
            objRemotCtx.portalUserId = transecRes.objSetupDate.objUserID;

            try {
                ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
            
              ccrz__E_Invoice__c objInv = new ccrz__E_Invoice__c();
                objInv.Id = transecRes.invoice.Id;
                objInv.ccrz__Status__c = 'Open';
                objInv.Sub_Status__c = 'Open';
                //objInv.BMS_Invoice_No__c='123';
                //objInv.OSM_SW_Is_Bolt_PO__c=false;
                objInv.Invoice_Type__c='Invoice';
                //objInv.Is_GOMS_Intercompany_Invoice__c=true;
                //objInv.GOMS_Invoice_ID__c='234';
                //objInv.ccrz__BillTo__c=account.id;
                objInv.Payment_Method__c='po';
                //objInv.ccrz__DateDue__c= date.parse('2020-06-02');
                update objInv;

                Attachment attachment = new Attachment();
                attachment.Body = Blob.valueOf('test data');
                attachment.Name = String.valueOf('FSDInvoice.txt');
                attachment.ParentId = objInv.Id;
                insert attachment;
           
                List<Map<String,Object>> ab = new List<Map<String,Object>>();
                Map<String,Object> xy = new Map<String,Object>();
                xy.put('sfid',(object)objInv.Id);
                ab.add(xy);
            
                OSM_SW_cc_hk_Invoice invoiceCls = new OSM_SW_cc_hk_Invoice();
                invoiceCls.invMap=ab;
                system.debug('Inside Test method');
                ccrz.cc_CallContext.effAccountId = portalAccount3.Id;
              returnMap = invoiceCls.fetchInvoices(inputMap);
                invoiceCls.onOrder(inputMap);  
            } catch (Exception ex) {}
        Test.stopTest();
        }
    }
    static testMethod void testMethodinvoiceordernull() {

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
         Test.StartTest();
        User usr = [Select id from User where Id =: UserInfo.getUserId()]; 
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
          TimeZoneSidKey='America/Chicago',
          OSM_Storefront_User_Type__c ='Distributor Admin'
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
          
          System.runAs(transecRes.objSetupDate.loggedInUser) {
           Attachment attachment = new Attachment();
            attachment.Body = Blob.valueOf('test data');
            attachment.Name = String.valueOf('FSDInvoice.txt');
            attachment.ParentId = transecRes.invoice.Id;
            insert attachment;
            system.debug('==Attachment inserted==');

          }
          User testUser = new User();
          testUser.FirstName = 'Testttt';
          testUser.LastName = 'lasttt';
          testUser.UserName = 'test2077665543@test.com'; //changed to bypass test failure in prod
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
            //Test.startTest();
            Account account = transecRes.objSetupDate.account;
            account.Bolt_Customer_Account_Status__c = 'Active';
            account.BillingCountry='United States';
            update account;
            
            Contact contact2 = new Contact(
              FirstName = 'Test12',
              Lastname = 'McTesty9356',
              IAM_Contact_Status__c='Pending',
              Username__c = 'testUserName6789@gmail.com',
              AccountId = account.Id,
              Email ='test129@test.com',
              IAM_Contact_Owner__c =portalAccountOwner2.id
              );
              insert contact2;

            effectiveAccount_enable_ProfileUserType__c effAccPro = new effectiveAccount_enable_ProfileUserType__c();
            effAccPro.Name ='Distributor Admin';
            effAccPro.Enable_Effective_Account_Selection__c=true;
            insert effAccPro;
            effectiveAccount_enable_ProfileUserType__c effAccPro1 = new effectiveAccount_enable_ProfileUserType__c();
            effAccPro1.Name ='Regular';
            effAccPro1.Enable_Effective_Account_Selection__c=true;
            insert effAccPro1;
            effectiveAccount_enable_ProfileUserType__c effAccPro2 = new effectiveAccount_enable_ProfileUserType__c();
            effAccPro2.Name ='SSOEM Admin';
            effAccPro2.Enable_Effective_Account_Selection__c=true;
            insert effAccPro2;
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


            OSM_SW_cc_hk_Order objCls = new OSM_SW_cc_hk_Order();
            Map < String, Object > returnMap = objCls.place(inputMap);
            OSM_SW_cc_hk_Order.processRefundForFailedOSMOrderPlacedProcess();
            
          
            
            inputMap = new Map < String, Object > ();
            inputMap.put('searchData', '{\"ascending\":\"true\"}');
            objRemotCtx = new ccrz.cc_RemoteActionContext();
            objRemotCtx.storefront = 'SoftwareStore';
            objRemotCtx.currentCartId = transecRes.cart.ccrz__EncryptedId__c;
            objRemotCtx.portalUserId = transecRes.objSetupDate.objUserID;

            try {
                ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
            
            ccrz__E_Invoice__c objInv = new ccrz__E_Invoice__c();
             objInv.Id = transecRes.invoice.Id;
            objInv.ccrz__Status__c = 'Open';
            objInv.Sub_Status__c = 'Open';
            //objInv.BMS_Invoice_No__c='123';
           // objInv.OSM_SW_Is_Bolt_PO__c=false;
            objInv.Invoice_Type__c='Invoice';
            //objInv.Is_GOMS_Intercompany_Invoice__c=true;
           // objInv.GOMS_Invoice_ID__c='234';
           // objInv.ccrz__BillTo__c=account.id;
            objInv.Payment_Method__c='po';
           // objInv.ccrz__DateDue__c= date.parse('2020-06-02');
            update objInv;


            
            Attachment attachment = new Attachment();
            attachment.Body = Blob.valueOf('test data');
            attachment.Name = String.valueOf('FSDInvoice.txt');
            attachment.ParentId = objInv.Id;
            insert attachment;
           
            List<Map<String,Object>> ab = new List<Map<String,Object>>();
            Map<String,Object> xy = new Map<String,Object>();
            xy.put('sfid',(object)objInv.Id);
            ab.add(xy);
            
            OSM_SW_cc_hk_Invoice invoiceCls = new OSM_SW_cc_hk_Invoice();
            invoiceCls.invMap=ab;
            system.debug('Inside Test method');
            returnMap = invoiceCls.fetchInvoices(inputMap);
                
            } catch (Exception ex) {}
            
            

            Test.stopTest();

        }
    }

    static testMethod void testMethodForInvoice() {

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
        System.debug('transecRes: ' + transecRes);

        PermissionSet objPer = [SELECT Id FROM PermissionSet WHERE Name = 'OSM_Support_Admin'Limit 1];
        
       // if (objPer != null) {
          //  PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = objPer.Id, AssigneeId = transecRes.objSetupDate.loggedInUser.Id);
          //  insert psa;
       // }


        // Creating address
        System.runAs(transecRes.objSetupDate.loggedInUser) {


            Attachment attachment = new Attachment();
            attachment.Body = Blob.valueOf('test data');
            attachment.Name = String.valueOf('FSDInvoice.txt');
            attachment.ParentId = transecRes.invoice.Id;
            insert attachment;

Account account = transecRes.objSetupDate.account;
            account.Bolt_Customer_Account_Status__c = 'Active';
            account.BillingCountry='United States';
            update account;



ccrz__E_Order__c ordr = new ccrz__E_Order__c();
        ordr.ccrz__Storefront__c = 'SoftwareStore';
        ordr.ccrz__Account__c = account.Id;
        ordr.OrderProcessedforFSD__c = true;
        ordr.IsInterCompanyProcessSuccess__c = false;
        //o1.ccrz__AbsoluteDiscount__c = 
        ordr.ccrz__CurrencyISOCode__c = 'USD';
        ordr.ccrz__OrderStatus__c = 'Order Submitted';
        insert ordr;


            ccrz__E_Invoice__c objInv = new ccrz__E_Invoice__c();
            objInv.Id = transecRes.invoice.Id;
            objInv.ccrz__CCOrder__c=ordr.id;
            objInv.ccrz__Status__c = 'Revoked';
            objInv.Sub_Status__c = 'Open';
            update objInv;


            Map < String, Object > inputMap = new Map < String, Object > ();
            inputMap.put('searchData', '{\"ascending\":\"true\"}');
            ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
            objRemotCtx.storefront = 'SoftwareStore';
            objRemotCtx.currentCartId = transecRes.cart.ccrz__EncryptedId__c;
            objRemotCtx.portalUserId = transecRes.objSetupDate.objUserID;

            try {
                ccrz.cc_CallContext.initRemoteContext(objRemotCtx);


                Test.startTest();
                OSM_SW_cc_hk_Invoice invoiceCls = new OSM_SW_cc_hk_Invoice();
                Map < String, Object > returnMap = invoiceCls.fetchInvoices(inputMap);
                Test.stopTest();
            } catch (Exception ex) {}
        }
    }

    static testMethod void testMethodForInvoice2() {

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
        System.debug('transecRes: ' + transecRes);

        PermissionSet objPer = [SELECT Id FROM PermissionSet WHERE Name = 'OSM_Support_Admin' Limit 1];
        
       // if (objPer != null) {
         //   PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = objPer.Id, AssigneeId = transecRes.objSetupDate.loggedInUser.Id);
          //  insert psa;
       // }


        // Creating address
        System.runAs(transecRes.objSetupDate.loggedInUser) {

            Attachment attachment = new Attachment();
            attachment.Body = Blob.valueOf('test data');
            attachment.Name = String.valueOf('FSDInvoice.txt');
            attachment.ParentId = transecRes.invoice.Id;
            insert attachment;

Account account = transecRes.objSetupDate.account;
            account.Bolt_Customer_Account_Status__c = 'Active';
            account.BillingCountry='United States';
            update account;

            
            ccrz__E_Order__c ordr = new ccrz__E_Order__c();
        ordr.ccrz__Storefront__c = 'SoftwareStore';
        ordr.ccrz__Account__c = account.Id;
        ordr.OrderProcessedforFSD__c = true;
        ordr.IsInterCompanyProcessSuccess__c = false;
        //o1.ccrz__AbsoluteDiscount__c = 
        ordr.ccrz__CurrencyISOCode__c = 'USD';
        ordr.ccrz__OrderStatus__c = 'Order Submitted';
        insert ordr;

            ccrz__E_Invoice__c objInv = new ccrz__E_Invoice__c();
            objInv.Id = transecRes.invoice.Id;
            objInv.ccrz__CCOrder__c= ordr.id;
            objInv.ccrz__Status__c = 'Open';
            objInv.Sub_Status__c = 'Open';
            update objInv;

            Map < String, Object > inputMap = new Map < String, Object > ();
            inputMap.put('searchData', '{\"ascending\":\"true\"}');
            ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
            objRemotCtx.storefront = 'SoftwareStore';
            objRemotCtx.currentCartId = transecRes.cart.ccrz__EncryptedId__c;
            objRemotCtx.portalUserId = transecRes.objSetupDate.objUserID;

            try {
                ccrz.cc_CallContext.initRemoteContext(objRemotCtx);

                Test.startTest();
                OSM_SW_cc_hk_Invoice invoiceCls = new OSM_SW_cc_hk_Invoice();
                Map < String, Object > returnMap = invoiceCls.fetchInvoices(inputMap);
                Test.stopTest();
            } catch (Exception ex) {}
        }
    }

    static testMethod void testMethodForPayment() {


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
        System.debug('transecRes: ' + transecRes);
        
        Map < String, Object > inputMap = new Map < String, Object > ();
        inputMap.put('paymentTypesContext', 'co');

        ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
        objRemotCtx.storefront = 'SoftwareStore';
        objRemotCtx.currentCartId = transecRes.cart.ccrz__EncryptedId__c;
        objRemotCtx.portalUserId = transecRes.objSetupDate.objUserID;


        ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
        Test.startTest();
        try {
            OSM_SW_cc_hk_Payment paymentCls = new OSM_SW_cc_hk_Payment();
            Map < String, Object > returnMap = paymentCls.getApplicablePaymentTypes(inputMap);
            inputMap.put('paymentTypesContext', 'po');
            Map < String, Object > returnMap2 = paymentCls.getApplicablePaymentTypes(inputMap);
        } catch (Exception ex) {}
        Test.stopTest();
    }

    static testMethod void testMethodForSubsc() {
        
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


        System.runAs(transecRes.objSetupDate.loggedInUser) {
            System.debug('transecRes: ' + transecRes);
            Map < String, Object > inputMap = new Map < String, Object > ();
            inputMap.put('searchData', '{\"ascending\":\"true\"}');
            inputMap.put('orderId', transecRes.order.Id);
            inputMap.put('paymentTypesContext', 'co');

            List < ccrz__E_TransactionPayment__c > lstTP = new List < ccrz__E_TransactionPayment__c > ();
            lstTP.add(transecRes.transactionPayment);
            inputMap.put('transactionData', lstTP);

            ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
            objRemotCtx.storefront = 'SoftwareStore';
            objRemotCtx.currentCartId = transecRes.cart.ccrz__EncryptedId__c;
            objRemotCtx.portalUserId = transecRes.objSetupDate.objUserID;

            ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
            Test.startTest();
            try {
                OSM_SW_cc_hk_Subscriptions SubscCls = new OSM_SW_cc_hk_Subscriptions();
                SubscCls.accountIdTest = transecRes.objSetupDate.account.Id;
                Map < String, Object > returnMap1 = SubscCls.onOrder(inputMap);
            } catch (Exception ex) {}
            
            try {
                OSM_SW_cc_hk_Subscriptions SubscCls = new OSM_SW_cc_hk_Subscriptions();
                SubscCls.accountIdTest = transecRes.objSetupDate.account.Id;
                Map < String, Object > returnMap = SubscCls.getSubscriptionProcessQuery(inputMap);
            } catch (Exception ex) {}
            
            try {
                OSM_SW_cc_hk_Subscriptions SubscCls = new OSM_SW_cc_hk_Subscriptions();
                SubscCls.accountIdTest = transecRes.objSetupDate.account.Id;
                Map < String, Object > returnMap = SubscCls.processSubscriptions(inputMap);
            } catch (Exception ex) {}
            
            try {
                OSM_SW_cc_hk_Subscriptions SubscCls = new OSM_SW_cc_hk_Subscriptions();
                SubscCls.accountIdTest = transecRes.objSetupDate.account.Id;
                Map < String, Object > returnMap = SubscCls.fetchSubscriptions(inputMap);
            } catch (Exception ex) {}

            OSM_ReturnWrapper objTest = new OSM_ReturnWrapper();
            objTest.exceptionFlag = true;
            objTest.exceptionMessage = 'test';

            Test.stopTest();
        }
    }
}