/**********************************
Date            Updated By
02-03-2021      Sangeeta Rani
08-03-2021      Sharad Sahu
12-03-2021      Sharad Sahu
26-03-2021      Sharad Sahu
14-04-2021      Sharad Sahu
21-04-2021      Pratima 
22-04-2021      Singaiah              MAR-1618 Story
22-07-2021      Singaiah              MAR-1861 Story
01-14-2022      Subbu       Deployment
Subbu Jira MP changes
 ************************************/
@isTest

public class OSM_SW_UserInformationComp_Ctrl_Test{
     static testMethod void userInformationComp_Test(){
     TestProductSetupReq testProductSetupReq1=OSM_TestDataCreationUtility.populatedTestProductSetupReq();
      TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes1=OSM_TestDataCreationUtility.createProductSetUp(testProductSetupReq1);
      Account account=testCompletedTransactionSetUpRes1.objSetupDate.account;
      account.PaymentType__c = 'CHARGE';
      account.BMSAvailableCredit__c=500;
      account.BMS_Customer_ID__c ='1234';
      test.StartTest();
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
        Account portalAccount1 = new Account(
        Name = 'TestAccount',
        OwnerId = portalAccountOwner2.Id,
        
        BMS_Customer_ID__c='1234'
        );
        System.runAs(portalAccountOwner2){
            Database.insert(portalAccount1);
        }

        //Create contact
        Contact contact1 = new Contact(
        FirstName = 'Test999',
        Lastname = 'McTesty999',
        Username__c = 'testUserName999@gmail.com',
        AccountId = portalAccount1.Id,
        IAM_Contact_Status__c='Pending',
        Email ='test@999test.com'
        );
        System.runAs(portalAccountOwner2){
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
        testUser.CommunityNickname = 'test12345zxcw';
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
     
     User usr = [Select id from User where Id = :UserInfo.getUserId()];    
     System.RunAs(usr)
     {                 
         try{          
          
         //gives error
         //insert user
          // Create RemoteActionContext Class Data 
          ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
          objRemotCtx.storefront='SoftwareStore';
          objRemotCtx.currentCartId=testCompletedTransactionSetUpRes1.cart.ccrz__EncryptedId__c;
          objRemotCtx.portalUserId=testUser.id;
           
          // Call Apex Class Method
          Double d=3.14159;
          OSM_SW_UserInformationComp_Ctrl.TestMetod='Test3';
          OSM_SW_UserInformationComp_Ctrl.getPaymentType(objRemotCtx);
          OSM_SW_UserInformationComp_Ctrl.updatePaymentMethod(objRemotCtx,'test',true,'12345','xyz','xyz');
          //OSM_SW_UserInformationComp_Ctrl.updateEDQAddress(objRemotCtx,add1,add2,add3,city,state,country,postalCode,add1,add2,add3,city,state,country,postalCode);
          
          String inputData='{"address1":"2200 SOUTH 75TH AVENUE","address2":"","address3":"","city":"PHOENIX","state":"AZ","country":"US","postalCode":"85043","shippingAddress1":"2200 SOUTH 75TH AVENUE","shippingAddress2":"","shippingAddress3":"","shippingCity":"PHOENIX","shipStateCode":"AZ","shippingCountryCode":"US","shippingPostalCode":"85043"}';
          String inputData2='{"firstName":"TestABC","lastName":"TestCDE","email":"abcde@test.com","phone":"1234565432"}';
          //Map<String,String> inputDataMap=new  Map<String,String>();
          //inputDataMap.put('address1','2200 SOUTH 75TH AVENUE'); 
          //inputDataMap.put('address2',''); 
          //OSM_SW_UserInformationComp_Ctrl.updateEDQAddress(objRemotCtx,inputData);
          OSM_SW_UserInformationComp_Ctrl.updateEDQAddress(objRemotCtx,inputData, inputData2);
          OSM_SW_UserInformationComp_Ctrl.checkOneBMSCreditLimit(account.id,d);
          inputData='{"shippingAddress1":"2200 SOUTH 75TH AVENUE","shippingAddress2":"","shippingAddress3":"","shippingCity":"PHOENIX","shipStateCode":"AZ","shippingCountryCode":"US","shippingPostalCode":"85043"}';
          
          //OSM_SW_UserInformationComp_Ctrl.updateEDQAddressPO(objRemotCtx,inputData);
          OSM_SW_UserInformationComp_Ctrl.updateEDQAddressPO(objRemotCtx,inputData, inputData2);
          account.IsOneBMSFailure__c=true;
          update account;
          OSM_SW_UserInformationComp_Ctrl.checkOneBMSCreditLimit(account.id,d);
          //OSM_SW_UserInformationComp_Ctrl.updateEDQAddressPO(objRemotCtx,null);
          OSM_SW_UserInformationComp_Ctrl.updateEDQAddressPO(objRemotCtx,null, inputData2);
          // Stop Test
          test.StopTest();
          }
          catch(Exception ex){}
      }
  }
   static testMethod void userInformationComp_elseScenarioTest1(){
       //Preparing  the test data
       
         
      TestProductSetupReq testProductSetupReq1=OSM_TestDataCreationUtility.populatedTestProductSetupReq();
      TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes1=OSM_TestDataCreationUtility.createProductSetUp(testProductSetupReq1);
      //TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes1=OSM_TestDataCreationUtility.createCompletedTransactionFlowTestData(testProductSetupRes1,20000.0, 10.0);   
      Account account=testCompletedTransactionSetUpRes1.objSetupDate.account;
      account.PaymentType__c = 'CHARGE';
      account.BMSAvailableCredit__c=500;
      account.BMS_Customer_ID__c ='1234';
      
      test.StartTest();
      User usr = [Select id from User where Id = :UserInfo.getUserId()];
      
      
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

        //User u1 = [Select ID From User Where Id =: portalAccountOwner1.Id];

        //System.runAs ( portalAccountOwner1 ) {
        //Create account
        Account portalAccount1 = new Account(
        Name = 'TestAccount',
        OwnerId = portalAccountOwner2.Id,
        OSM_Preferred_Billing_Frequency_Lock__c=false,
        BMS_Customer_ID__c='1234',
        BOLT_Account_Number__c='123456',
        Bolt_Customer_Account_Status__c='Active',
            BillingCountry='United States'
        );
        System.runAs(portalAccountOwner2){
            Database.insert(portalAccount1);
        }

        //Create contact
        Contact contact1 = new Contact(
        FirstName = 'Test111',
        Lastname = 'McTesty111',
        Username__c = 'testUserName111@gmail.com',
        AccountId = portalAccount1.Id,
        IAM_Contact_status__c='Pending',
        Email ='test@111test.com'
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
        testUser.CommunityNickname = 'test12345sdf';
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
         
     System.RunAs(usr)
     {                 
         try{          
          
          ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
          objRemotCtx.storefront='SoftwareStore';
          objRemotCtx.currentCartId=testCompletedTransactionSetUpRes1.cart.ccrz__EncryptedId__c;
          objRemotCtx.portalUserId=testUser.id;
        
          OSM_SW_UserInformationComp_Ctrl.getPaymentType(objRemotCtx);
            
          System.runAs(portalAccountOwner2){
            portalAccount1.OSM_Preferred_Billing_Frequency_Lock__c=true;
            Database.update(portalAccount1);
          }
             
             ccrz.cc_RemoteActionContext objRemotCtx1 = new ccrz.cc_RemoteActionContext();
          objRemotCtx1.storefront='SoftwareStore';
          objRemotCtx1.currentCartId=testCompletedTransactionSetUpRes1.cart.ccrz__EncryptedId__c;
          objRemotCtx1.portalUserId=testUser.id;
        
          OSM_SW_UserInformationComp_Ctrl.getPaymentType(objRemotCtx1);
          
          test.StopTest();
          }
          catch(Exception ex){}
      }
   }
   static testMethod void userInformationComp_elseScenarioTest2(){
       //Preparing  the test data
       
         
      TestProductSetupReq testProductSetupReq1=OSM_TestDataCreationUtility.populatedTestProductSetupReq();
      TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes1=OSM_TestDataCreationUtility.createProductSetUp(testProductSetupReq1);
      //TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes1=OSM_TestDataCreationUtility.createCompletedTransactionFlowTestData(testProductSetupRes1,20000.0, 10.0);   
     test.StartTest();
      User usr = [Select id from User where Id = :UserInfo.getUserId()];
      
      
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

        //User u1 = [Select ID From User Where Id =: portalAccountOwner1.Id];

        //System.runAs ( portalAccountOwner1 ) {
        //Create account
        Account portalAccount1 = new Account(
        Name = 'TestAccount',
        OwnerId = portalAccountOwner2.Id,
        OSM_Preferred_Billing_Frequency_Lock__c=true,
        BMS_Customer_ID__c='1234',
        //BOLT_Account_Number__c='123456',
        Bolt_Customer_Account_Status__c='Active'
        );
        System.runAs(portalAccountOwner2){
            Database.insert(portalAccount1);
        }

        //Create contact
        Contact contact1 = new Contact(
        FirstName = 'Test987',
        Lastname = 'McTesty987',
        Username__c = 'testUserName987@gmail.com',
        AccountId = portalAccount1.Id,
        IAM_Contact_Status__c='Pending',
        Email ='test@987test.com'
        );
        System.runAs(portalAccountOwner2){
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
        testUser.CommunityNickname = 'test12345qwer';
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
         
     System.RunAs(usr)
     {                 
         try{          
          //test.StartTest();
         //gives error
         //insert user
          // Create RemoteActionContext Class Data 
          ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
          objRemotCtx.storefront='SoftwareStore';
          objRemotCtx.currentCartId=testCompletedTransactionSetUpRes1.cart.ccrz__EncryptedId__c;
          objRemotCtx.portalUserId=testUser.id;
           OSM_SW_UserInformationComp_Ctrl.TestMetod='Test4';
          OSM_SW_UserInformationComp_Ctrl.getPaymentType(objRemotCtx);
          OSM_SW_UserInformationComp_Ctrl.getCleasePaymentMethod(objRemotCtx);
          test.StopTest();
          }
          catch(Exception ex){}
      }
   }
   static testMethod void userInformationComp_elseScenarioTest3(){
       //Preparing  the test data
       
         
      TestProductSetupReq testProductSetupReq1=OSM_TestDataCreationUtility.populatedTestProductSetupReq();
      TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes1=OSM_TestDataCreationUtility.createProductSetUp(testProductSetupReq1);
      //TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes1=OSM_TestDataCreationUtility.createCompletedTransactionFlowTestData(testProductSetupRes1,20000.0, 10.0);   
     test.StartTest();
      User usr = [Select id from User where Id = :UserInfo.getUserId()];
      
      
      Id portal_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community' Limit 1 ].Id;
        //Id roleId=[select id,name from UserRole where name='CumminsFleetsCustomerUser' limit 1].id; 
         
       UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        system.debug('portalRole is ' + portalRole);

        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner3 = new User(
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
        Database.insert(portalAccountOwner3);

        Account portalAccount2 = new Account(
        Name = 'TestAccount',
        OwnerId = portalAccountOwner3.Id,
        OSM_Preferred_Billing_Frequency_Lock__c=true,
        BMS_Customer_ID__c='1234',
        //BOLT_Account_Number__c='123456',
        Bolt_Customer_Account_Status__c='Active',CSS_DistributorCode__c='123456'
        );
        System.runAs(portalAccountOwner3){
            Database.insert(portalAccount2);
        }

        //Create contact
        Contact contact1 = new Contact(
        FirstName = 'Test789',
        Lastname = 'McTesty789',
        Username__c = 'testUserName789@gmail.com',
        AccountId = portalAccount2.Id,
        IAM_Contact_Status__c='Pending',
        Email ='test@789test.com'
        );
        System.runAs(portalAccountOwner3){
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
        testUser.CommunityNickname = 'test12345qwer';
        testUser.ProfileId =portal_PROFILE_ID;
        testUser.TimeZoneSidKey = 'America/Los_Angeles';
        testUser.isActive = true;
        testUser.LocaleSidKey = 'en_US';
        testUser.LanguageLocaleKey = 'en_US';
        testUser.EmailEncodingKey = 'ISO-8859-1';
        //testUser.UserRoleId = portalRole.Id;
        
        
            System.runAs(portalAccountOwner3){
                insert testUser;
          
        }
         
     System.RunAs(usr)
     {                 
         try{          
          //test.StartTest();
         //gives error
         //insert user
          // Create RemoteActionContext Class Data 
          ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
          objRemotCtx.storefront='SoftwareStore';
          objRemotCtx.currentCartId=testCompletedTransactionSetUpRes1.cart.ccrz__EncryptedId__c;
          objRemotCtx.portalUserId=testUser.id;
           OSM_SW_UserInformationComp_Ctrl.TestMetod='Test5';
          OSM_SW_UserInformationComp_Ctrl.getPaymentType(objRemotCtx);
          OSM_SW_UserInformationComp_Ctrl.getInfoFromBMS(objRemotCtx,'Test','02680');
          OSM_SW_UserInformationComp_Ctrl.getInfoFromBMS(objRemotCtx,'US BMS Instance','02680');
          OSM_SW_UserInformationComp_Ctrl.getInfoFromBMS(objRemotCtx,'Southern Plains BMS Instance','02680');
          
          test.StopTest();
          }
          catch(Exception ex){}
      }
   }
   
   static testMethod void userInformationComp_Test1(){
        TestProductSetupReq testProductSetupReq1 = OSM_TestDataCreationUtility.populatedTestProductSetupReq();
        TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes1 = OSM_TestDataCreationUtility.createProductSetUp(testProductSetupReq1);
        //TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes1=OSM_TestDataCreationUtility.createCompletedTransactionFlowTestData(testProductSetupRes1,20000.0, 10.0);   
        Account account = testCompletedTransactionSetUpRes1.objSetupDate.account;


        test.StartTest();
        User usr = [Select id from User where Id =: UserInfo.getUserId()];


        Id portal_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community' Limit 1 ].Id;
        //Id roleId=[select id,name from UserRole where name='CumminsFleetsCustomerUser' limit 1].id; 

        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        system.debug('portalRole is ' + portalRole);

        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        
        /* Account account = testCompletedTransactionSetUpRes1.objSetupDate.account;
            account.type = 'Dealer Account';
            account.BOLT_Account_Number__c = null;
            account.BMS_Customer_ID__c = '1234';
            account.name = 'testAccount';
            update account;*/
            
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
            type = 'Dealer Account'
            
            
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

            /*ccrz__E_Cart__c childCart=new ccrz__E_Cart__c();
            childCart.OSM_Payment_Method__c='po';
            childCart.ccrz__Account__c=account.id;
            childCart.ccrz__EncryptedId__c=cart.id;
            insert childCart;*/
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
            insert cartItemChild;
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
            update ordItem;
            
            ccrz__E_Product__c prod = TestCompletedTransactionSetUpRes1.objSetupDate.compositeProduct;
            prod.Name = Label.VOTECH100OFFINSITE;
            update prod;
            
            //Test.StartTest();
            
            OSM_SW_UserInformationComp_Ctrl.getPaymentType(objRemotCtx);
 
          Test.StopTest();
   }
   }
}