@isTest
//check gitlab revert feature
global class OSM_SW_hk_EffectiveAccount_Test { 
        
    
    static testMethod void validateTest(){
      
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
          Type= 'Distributor Branch Account',
          OwnerId = portalAccountOwner2.Id,
          OSM_Preferred_Billing_Frequency_Lock__c=false,
          BMS_Customer_ID__c='1234',
          OSM_Preferred_Payment_Method__c='po',
          OSM_Preferred_Payment_IsBolt_PO__c=false,
          IAM_Service_Provider_Code__c='123'
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
          testUser.OSM_Storefront_User_Type__c ='Distributor Admin';
          
              System.runAs(portalAccountOwner2){
                  insert testUser;
            
          }

        // Creating address
        System.runAs(portalAccountOwner2) {

            Account account = transecRes.objSetupDate.account;
            account.Bolt_Customer_Account_Status__c = 'Active';
            account.IAM_Service_Provider_Code__c='1234';
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
            effectiveAccount_enable_ProfileUserType__c effAccPro3 = new effectiveAccount_enable_ProfileUserType__c();
            effAccPro3.Name ='Distributor Admin';
            effAccPro3.Enable_Effective_Account_Selection__c=true;
            insert effAccPro3;
            
            Map < String, Object > inputMap = new Map < String, Object > ();
      ccrz.cc_bean_CartSummary cartSum = new ccrz.cc_bean_CartSummary(transecRes.cart);
      
        inputMap.put('version',7);
        inputMap.put('storefront','SoftwareStore');
        inputMap.put('ownerId',transecRes.objSetupDate.objUserID);
        inputMap.put('cartId',transecRes.cart.Id);
        inputMap.put('sizing','{cart={sz_assc=false, sz_data=sz_s, sz_skiptrz=true}}');
        inputMap.put('CartBean',cartSum );
        inputMap.put(ccrz.cc_hk_EffectiveAccount.PARAM_ACCOUNT_ID,transecRes.order.ccrz__Account__c);
        inputMap.put('DistributorType', 'Distributor Branch Account');
        //inputMap.put('LocationCode', account.IAM_Service_Provider_Code__c);
 

            Test.startTest();

            OSM_SW_cc_hk_Order objCls = new OSM_SW_cc_hk_Order();
            Map < String, Object > returnMap = objCls.place(inputMap);
            OSM_SW_cc_hk_Order.processRefundForFailedOSMOrderPlacedProcess();
            
            
            
            
            inputMap = new Map < String, Object > ();

            try {
             
            OSM_SW_hk_EffectiveAccount Obj = new OSM_SW_hk_EffectiveAccount();
            //invoiceCls.invMap=ab;
            system.debug('Inside Test method');
            returnMap = Obj.fetchAccounts(inputMap);
            //obj.fetchAccounts(null);
            OSM_SW_AccountDao.getDistributorAccountsHierarchy(transecRes.objSetupDate.account.id);
            OSM_SW_AccountDao.getAccountsHierarchy(transecRes.objSetupDate.account.id);

           
           // List<ID> actid =new List<ID>();
           // actid.add(transecRes.objSetupDate.account.id);
            //OSM_SW_AccountDao.getAListOfAccount(setId);
           // OSM_SW_AccountDao.getDistributorAdminAccountRelateData(transecRes.objSetupDate.account.id);
            OSM_SW_AccountDao.getDistributorAdminAccountRelateData(portalAccount2.id);   
            } catch (Exception ex) {}
            
            

            Test.stopTest();

        }
    }
  static testMethod void validateTest1(){
      
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
          Type= 'Distributor Branch Account',
          OwnerId = portalAccountOwner2.Id,
          OSM_Preferred_Billing_Frequency_Lock__c=false,
          BMS_Customer_ID__c='1234',
          OSM_Preferred_Payment_Method__c='po',
          OSM_Preferred_Payment_IsBolt_PO__c=false,
          IAM_Service_Provider_Code__c='123'
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
          testUser.OSM_Storefront_User_Type__c ='Distributor Admin';
          
              System.runAs(portalAccountOwner2){
                  insert testUser;
            
          }

        // Creating address
        System.runAs(portalAccountOwner2) {

            Account account = transecRes.objSetupDate.account;
            account.Bolt_Customer_Account_Status__c = 'Active';
            account.IAM_Service_Provider_Code__c='1234';
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
            effAccPro.Enable_Effective_Account_Selection__c=false;
            insert effAccPro;
            effectiveAccount_enable_ProfileUserType__c effAccPro1 = new effectiveAccount_enable_ProfileUserType__c();
            effAccPro1.Name ='Regular';
            effAccPro1.Enable_Effective_Account_Selection__c=false;
            insert effAccPro1;
            effectiveAccount_enable_ProfileUserType__c effAccPro2 = new effectiveAccount_enable_ProfileUserType__c();
            effAccPro2.Name ='SSOEM Admin';
            effAccPro2.Enable_Effective_Account_Selection__c=false;
            insert effAccPro2;
            effectiveAccount_enable_ProfileUserType__c effAccPro3 = new effectiveAccount_enable_ProfileUserType__c();
            effAccPro3.Name ='Distributor Admin';
            effAccPro3.Enable_Effective_Account_Selection__c=false;
            insert effAccPro3;
            
            Map < String, Object > inputMap = new Map < String, Object > ();
      ccrz.cc_bean_CartSummary cartSum = new ccrz.cc_bean_CartSummary(transecRes.cart);
      
        inputMap.put('version',7);
        inputMap.put('storefront','SoftwareStore');
        inputMap.put('ownerId',transecRes.objSetupDate.objUserID);
        inputMap.put('cartId',transecRes.cart.Id);
        inputMap.put('sizing','{cart={sz_assc=false, sz_data=sz_s, sz_skiptrz=true}}');
        inputMap.put('CartBean',cartSum );
        inputMap.put(ccrz.cc_hk_EffectiveAccount.PARAM_ACCOUNT_ID,transecRes.order.ccrz__Account__c);
        inputMap.put('DistributorType', 'Distributor Branch Account');
        //inputMap.put('LocationCode', account.IAM_Service_Provider_Code__c);
 

            Test.startTest();

            OSM_SW_cc_hk_Order objCls = new OSM_SW_cc_hk_Order();
            Map < String, Object > returnMap = objCls.place(inputMap);
            OSM_SW_cc_hk_Order.processRefundForFailedOSMOrderPlacedProcess();
            
            
            
            
           // inputMap = new Map < String, Object > ();

            try {
             
            OSM_SW_hk_EffectiveAccount Obj = new OSM_SW_hk_EffectiveAccount();
            //invoiceCls.invMap=ab;
            system.debug('Inside Test method');
            returnMap = Obj.fetchAccounts(inputMap);
            //obj.fetchAccounts(null);
            OSM_SW_AccountDao.getDistributorAccountsHierarchy(transecRes.objSetupDate.account.id);
            OSM_SW_AccountDao.getAccountsHierarchy(transecRes.objSetupDate.account.id);

           
           // List<ID> actid =new List<ID>();
           // actid.add(transecRes.objSetupDate.account.id);
            //OSM_SW_AccountDao.getAListOfAccount(setId);
           // OSM_SW_AccountDao.getDistributorAdminAccountRelateData(transecRes.objSetupDate.account.id);
            OSM_SW_AccountDao.getDistributorAdminAccountRelateData(portalAccount2.id);   
            } catch (Exception ex) {}
            
            

            Test.stopTest();

        }
    }
  static testMethod void testMethod1() {

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
          Type= 'Distributor Branch Account'
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
        //testUser.OSM_Storefront_User_Type__c ='Distributor Admin';
          
              System.runAs(portalAccountOwner2){
                  insert testUser;
            
          }

        // Creating address
        System.runAs(portalAccountOwner2) {

            Account account = transecRes.objSetupDate.account;
            account.Bolt_Customer_Account_Status__c = 'Active';
            account.Type= 'Distributor Branch Account';
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

           
              inputMap.put('storefront','SoftwareStore');
        inputMap.put('ownerId',transecRes.objSetupDate.objUserID);
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
            //objInv.ccrz__Status__c = 'Open';
            //objInv.Sub_Status__c = 'Open';
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
            
             Account acc22 = new Account();
            acc22.Name='Test acc';
            acc22.Bolt_Customer_Account_Status__c = 'Active';
            acc22.Type= 'Distributor Branch Account';
            acc22.AccountSource = 'Web';
            insert acc22;
            
            inputMap.put('PARAM_ACCOUNT_ID',acc22);
            
            OSM_SW_hk_EffectiveAccount invoiceCls = new OSM_SW_hk_EffectiveAccount();
            //invoiceCls.invMap=ab;
            system.debug('Inside Test method');
            returnMap = invoiceCls.fetchAccounts(inputMap);
            //OSM_SW_AccountDao.getDistributorAccountsHierarchy(transecRes.objSetupDate.account.id);
           // OSM_SW_AccountDao.getAccountsHierarchy(transecRes.objSetupDate.account.id);


            OSM_SW_AccountDao.getDistributorAdminAccountRelateData(portalAccount2.id);      
            } catch (Exception ex) {}
            
            

            Test.stopTest();

        }
    }
  
 static testMethod void testMethod3(){
      
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
          Type= 'Distributor Branch Account',
          OwnerId = portalAccountOwner2.Id,
          OSM_Preferred_Billing_Frequency_Lock__c=false,
          BMS_Customer_ID__c='1234',
          OSM_Preferred_Payment_Method__c='po',
          OSM_Preferred_Payment_IsBolt_PO__c=false,
          IAM_Service_Provider_Code__c='123'
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
          testUser.OSM_Storefront_User_Type__c ='Distributor Admin';
          
              System.runAs(portalAccountOwner2){
                  insert testUser;
            
          }

        // Creating address
        System.runAs(portalAccountOwner2) {

            Account account = transecRes.objSetupDate.account;
            account.Bolt_Customer_Account_Status__c = 'Active';
            account.IAM_Service_Provider_Code__c='1234';
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
      ccrz.cc_bean_CartSummary cartSum = new ccrz.cc_bean_CartSummary(transecRes.cart);
      
        inputMap.put('version',7);
        inputMap.put('storefront','SoftwareStore');
        inputMap.put('ownerId',transecRes.objSetupDate.objUserID);
        inputMap.put('cartId',transecRes.cart.Id);
        inputMap.put('sizing','{cart={sz_assc=false, sz_data=sz_s, sz_skiptrz=true}}');
        inputMap.put('CartBean',cartSum );
        inputMap.put(ccrz.cc_hk_EffectiveAccount.PARAM_ACCOUNT_ID,transecRes.order.ccrz__Account__c);
        inputMap.put('DistributorType', 'Distributor Branch Account');
        //inputMap.put('LocationCode', account.IAM_Service_Provider_Code__c);
 

            Test.startTest();

            OSM_SW_cc_hk_Order objCls = new OSM_SW_cc_hk_Order();
            Map < String, Object > returnMap = objCls.place(inputMap);
            OSM_SW_cc_hk_Order.processRefundForFailedOSMOrderPlacedProcess();
            
            
            
            
            inputMap = new Map < String, Object > ();

            try {
             
            OSM_SW_hk_EffectiveAccount Obj = new OSM_SW_hk_EffectiveAccount();
            //invoiceCls.invMap=ab;
            system.debug('Inside Test method');
            returnMap = Obj.fetchAccounts(inputMap);
            //obj.fetchAccounts(null);
            //OSM_SW_AccountDao.getDistributorAccountsHierarchy(transecRes.objSetupDate.account.id);
            //OSM_SW_AccountDao.getAccountsHierarchy(transecRes.objSetupDate.account.id);

           
           // List<ID> actid =new List<ID>();
           // actid.add(transecRes.objSetupDate.account.id);
            set<string> actid =new set<string>();
            actid.add(transecRes.objSetupDate.account.id);
            OSM_SW_AccountDao.getAListOfAccount(actid);
           // OSM_SW_AccountDao.getDistributorAdminAccountRelateData(transecRes.objSetupDate.account.id);
            //OSM_SW_AccountDao.getDistributorAdminAccountRelateData(portalAccount2.id);   
            } catch (Exception ex) {}
            
            

            Test.stopTest();

        }
    } 
    
    
}