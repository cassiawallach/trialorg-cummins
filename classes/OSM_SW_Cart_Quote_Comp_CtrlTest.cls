@isTest
private class OSM_SW_Cart_Quote_Comp_CtrlTest{

  static testMethod void testfetchQuoteListItems(){
   
  /*  Id SYS_ADMIN_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id; 
    User ADMIN_USER = [Select Id, Name from User where ProfileId = :SYS_ADMIN_PROFILE_ID and IsActive = true LIMIT 1];
    UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
    system.debug('portalRole is ' + portalRole);

    Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
    User portalAccountOwner1 = new User(
    UserRoleId = portalRole.Id,
    ProfileId = profile1.Id,
    Username = System.now().millisecond() + 'test2@test.com',
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

    //User u1 = [Select ID From User Where Id =: portalAccountOwner1.Id];
    Id contactIdval;
    Id accountIdval;
    Id userIdval;
    ccrz__E_RequestForQuote__c objRequestForQuote = new ccrz__E_RequestForQuote__c();
    List<ccrz__E_Cart__c> lstECart2 = new List<ccrz__E_Cart__c>();
    System.runAs ( portalAccountOwner1 ) {
    //Create account
    Account portalAccount1 = new Account(
    Name = 'TestAccount',
    OwnerId = portalAccountOwner1.Id
    );
    Database.insert(portalAccount1);
    accountIdval = portalAccount1.Id;
    //Create contact
    Contact contact1 = new Contact(
    FirstName = 'Test',
    Lastname = 'McTesty',
    AccountId = portalAccount1.Id,
    IAM_Contact_Status__c='Active',
    Email = System.now().millisecond() + 'test@test.com'
    );
    Database.insert(contact1);
    contactIdval = contact1.Id;
    //Create user
    Profile portalProfile = [SELECT Id FROM Profile where name = 'Customer Community Plus User' Limit 1];
    User user1 = new User(
    Username = System.now().millisecond() + 'test12345@test.com',
    ContactId = contact1.Id,
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
    userIdval = user1.Id;
    

        

    
     // Create User
        User loggedInUser = [Select id from User where id=: UserInfo.getUserId()];

        
        
    // Create E Cart
        lstECart2 = TestingUtils.CreateCart(1, 'SoftwareStore', 'Wishlist', loggedInUser.Id, true, 'Open', true);*/
        
           // TestProductSetupReq testReq =new TestProductSetupReq();
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
        ccrz__E_RequestForQuote__c objRequestForQuote = new ccrz__E_RequestForQuote__c();
        // Create E Product
        List<ccrz__E_Product__c> lstEProduct = TestingUtils.createEProduct(3, 'TestProduct', 'Released', 2, 'SK100-1', 'DA', true);

        // Create E SubProdTerm
        List<ccrz__E_SubProdTerm__c> lstESubProdTerm = new List<ccrz__E_SubProdTerm__c>();
        for(Integer i=0; i<lstEProduct.size(); i++){
        List<ccrz__E_SubProdTerm__c> lstprodterm = TestingUtils.createSubProdTerm(1, 'TestSubProdTerm', lstEProduct[i].Id, '*', true);
      
        lstESubProdTerm.addAll(lstprodterm);
        }
        objRequestForQuote.CC_SubProdTerm__c = lstESubProdTerm[0].Id;
        objRequestForQuote.Cost_Subscription__c = 2000;
        objRequestForQuote.Status__c = 'Requested';
        objRequestForQuote.CC_Product__c = lstEProduct[0].Id;
        objRequestForQuote.Product_Plan__c = 'Base';
        objRequestForQuote.Quantity__c = 2;
        objRequestForQuote.Display_Product__c = lstEProduct[0].Id;
        objRequestForQuote.ccrz__Amount__c = 500;
        objRequestForQuote.ccrz__Storefront__c = 'SoftwareStore';
        objRequestForQuote.ccrz__Description__c = 'Testing...';
        objRequestForQuote.Discounted_Price__c = 200;
        objRequestForQuote.Discounted_Percentage__c = 20;
        objRequestForQuote.Final_Price__c = 200;
        objRequestForQuote.ccrz__Account__c = transecRes.order.ccrz__Account__c;
        objRequestForQuote.ccrz__Contact__c = transecRes.order.ccrz__Contact__c;
        insert objRequestForQuote;
      //  System.debug('contactIdval===: '+contactIdval);
        //System.debug('objRequestForQuote===: '+objRequestForQuote);
    
    
        test.StartTest();
    
      // Create RemoteActionContext Class Data
      ccrz.cc_RemoteActionContext objRemoteClass = new ccrz.cc_RemoteActionContext();
      objRemoteClass.storefront = 'SoftwareStore';
      objRemoteClass.currentCartId = transecRes.cart.ccrz__EncryptedId__c;
      objRemoteClass.portalUserId = transecRes.objSetupDate.objUserID;
      objRemoteClass.userLocale = 'en_US';
      
      // Call Apex Class Methods
      OSM_SW_Cart_Quote_Comp_Ctrl.fetchQuote(objRemoteClass);
      try
      {
          OSM_SW_Cart_Quote_Comp_Ctrl.approveOrRejectQuote(objRemoteClass, objRequestForQuote.Id, 'Accepted');
      }
      catch(Exception e)
      {
         System.debug(e.getMessage()); 
      }
      
    
        // Stop Test
    test.StopTest();
    
  
  }
  static testMethod void testfetchQuoteListItems2(){

    /* Id SYS_ADMIN_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id; 
     User ADMIN_USER = [Select Id, Name from User where ProfileId = :SYS_ADMIN_PROFILE_ID and IsActive = true LIMIT 1];    
     UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
    system.debug('portalRole is ' + portalRole);

    Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
    User portalAccountOwner1 = new User(
    UserRoleId = portalRole.Id,
    ProfileId = profile1.Id,
    Username = System.now().millisecond() + 'test2@test.com',
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

    //User u1 = [Select ID From User Where Id =: portalAccountOwner1.Id];
    Id contactIdval;
    Id accountIdval;
    Id userIdval;
    ccrz__E_RequestForQuote__c objRequestForQuote = new ccrz__E_RequestForQuote__c();
    List<ccrz__E_Cart__c> lstECart2 = new List<ccrz__E_Cart__c>();
    System.runAs ( portalAccountOwner1 ) {
    //Create account
    Account portalAccount1 = new Account(
    Name = 'TestAccount',
    OwnerId = portalAccountOwner1.Id
    );
    Database.insert(portalAccount1);
accountIdval = portalAccount1.Id;
    //Create contact
    Contact contact1 = new Contact(
    FirstName = 'Test',
    Lastname = 'McTesty',
    AccountId = portalAccount1.Id,
    IAM_Contact_Status__c='Active',
    Email = System.now().millisecond() + 'test@test.com'
    );
    Database.insert(contact1);
    contactIdval = contact1.Id;
    //Create user
    Profile portalProfile = [SELECT Id FROM Profile where name = 'Customer Community Plus User' Limit 1];
    User user1 = new User(
    Username = System.now().millisecond() + 'test12345@test.com',
    ContactId = contact1.Id,
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
    userIdval = user1.Id;
    

        

    
     // Create User
        User loggedInUser = [Select id from User where id=: UserInfo.getUserId()];

        
        
    // Create E Cart
        lstECart2 = TestingUtils.CreateCart(1, 'SoftwareStore', 'Wishlist', loggedInUser.Id, true, 'Open', true);*/
        
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
        ccrz__E_RequestForQuote__c objRequestForQuote = new ccrz__E_RequestForQuote__c();
        // Create E Product
        List<ccrz__E_Product__c> lstEProduct = TestingUtils.createEProduct(3, 'TestProduct', 'Released', 2, 'SK100-1', 'DA', true);

        // Create E SubProdTerm
        List<ccrz__E_SubProdTerm__c> lstESubProdTerm = new List<ccrz__E_SubProdTerm__c>();
        for(Integer i=0; i<lstEProduct.size(); i++){
        List<ccrz__E_SubProdTerm__c> lstprodterm = TestingUtils.createSubProdTerm(1, 'TestSubProdTerm', lstEProduct[i].Id, '*', true);
      
        lstESubProdTerm.addAll(lstprodterm);
        }
        objRequestForQuote.CC_SubProdTerm__c = lstESubProdTerm[0].Id;
        objRequestForQuote.Cost_Subscription__c = 2000;
        objRequestForQuote.Status__c = 'Requested';
        objRequestForQuote.CC_Product__c = lstEProduct[0].Id;
        objRequestForQuote.Product_Plan__c = 'Base';
        objRequestForQuote.Quantity__c = 2;
        objRequestForQuote.Display_Product__c = lstEProduct[0].Id;
        objRequestForQuote.ccrz__Amount__c = 500;
        objRequestForQuote.ccrz__Storefront__c = 'SoftwareStore';
        objRequestForQuote.ccrz__Description__c = 'Testing...';
        objRequestForQuote.Discounted_Price__c = 200;
        objRequestForQuote.Discounted_Percentage__c = 20;
        objRequestForQuote.Final_Price__c = 200;
        objRequestForQuote.ccrz__Account__c = transecRes.order.ccrz__Account__c;
        objRequestForQuote.ccrz__Contact__c = transecRes.order.ccrz__Contact__c;
        insert objRequestForQuote;
      //  System.debug('contactIdval===: '+contactIdval);
        //System.debug('objRequestForQuote===: '+objRequestForQuote);
        
       // Create RemoteActionContext Class Data
      ccrz.cc_RemoteActionContext objRemoteClass = new ccrz.cc_RemoteActionContext();
      objRemoteClass.storefront = 'SoftwareStore';
      objRemoteClass.currentCartId = transecRes.cart.ccrz__EncryptedId__c;
      objRemoteClass.portalUserId = transecRes.objSetupDate.objUserID;
      objRemoteClass.userLocale = 'en_US';
      

      Test.StartTest();
      // Call Apex Class Methods
            OSM_SW_Cart_Quote_Comp_Ctrl.fetchQuote(objRemoteClass);
     // OSM_SW_Cart_Quote_Comp_Ctrl.approveOrRejectQuote(objRemoteClass, objRequestForQuote.Id, 'Accepted');
    
        // Stop Test
    test.StopTest();
    
    
    
  }
    static testMethod void testfetchQuoteListItems3(){

     Id SYS_ADMIN_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id; 
     User ADMIN_USER = [Select Id, Name from User where ProfileId = :SYS_ADMIN_PROFILE_ID and IsActive = true LIMIT 1];
  
    UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
    system.debug('portalRole is ' + portalRole);

    Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
    User portalAccountOwner1 = new User(
    UserRoleId = portalRole.Id,
    ProfileId = profile1.Id,
    Username = System.now().millisecond() + 'test2ppp@test.com',
    Alias = 'batnp',
    Email='bruce.wayne@wayneenterprises.com',
    EmailEncodingKey='UTF-8',
    Firstname='Brucep',
    Lastname='Wayne',
    LanguageLocaleKey='en_US',
    LocaleSidKey='en_US',
    TimeZoneSidKey='America/Chicago'
    );
    Database.insert(portalAccountOwner1);

    //User u1 = [Select ID From User Where Id =: portalAccountOwner1.Id];
    Id contactIdval;
    Id accountIdval;
    Id userIdval;
    ccrz__E_RequestForQuote__c objRequestForQuote = new ccrz__E_RequestForQuote__c();
    List<ccrz__E_Cart__c> lstECart2 = new List<ccrz__E_Cart__c>();
    System.runAs ( portalAccountOwner1 ) {
    //Create account
    Account portalAccount1 = new Account(
    Name = 'TestAccount',
    OwnerId = portalAccountOwner1.Id
    );
    Database.insert(portalAccount1);
    accountIdval = portalAccount1.Id;
    //Create contact
    Contact contact1 = new Contact(
    FirstName = 'Test',
    Lastname = 'McTesty',
    AccountId = portalAccount1.Id,
    IAM_Contact_Status__c='Active',
    Email = System.now().millisecond() + 'test@test.com'
    );
    Database.insert(contact1);
    contactIdval = contact1.Id;
    //Create user
    Profile portalProfile = [SELECT Id FROM Profile where name = 'Customer Community Plus User' Limit 1];
    User user1 = new User(
    Username = System.now().millisecond() + 'test12345dfdfdf@test.com',
    ContactId = contact1.Id,
    ProfileId = portalProfile.Id,
    Alias = 'tdfdf',
    Email = 'test12345@test.com',
    EmailEncodingKey = 'UTF-8',
    LastName = 'McTesty',
    CommunityNickname = 'test12345',
    TimeZoneSidKey = 'America/Los_Angeles',
    LocaleSidKey = 'en_US',
    LanguageLocaleKey = 'en_US'
    );
    Database.insert(user1);
    userIdval = user1.Id;
    

        

    
     // Create User
        User loggedInUser = [Select id from User where id=: UserInfo.getUserId()];

        
        
    // Create E Cart
        lstECart2 = TestingUtils.CreateCart(1, 'SoftwareStore', 'Cart', userIdval, true, 'Open', true);
        
    // Create E Product
        List<ccrz__E_Product__c> lstEProduct = TestingUtils.createEProduct(3, 'TestProduct', 'Released', 2, 'SK100-1', 'DA', true);
        
    // Create E SubProdTerm
    List<ccrz__E_SubProdTerm__c> lstESubProdTerm = new List<ccrz__E_SubProdTerm__c>();
        for(Integer i=0; i<lstEProduct.size(); i++){
            List<ccrz__E_SubProdTerm__c> lstprodterm = TestingUtils.createSubProdTerm(1, 'TestSubProdTerm', lstEProduct[i].Id, '*', true);
            lstESubProdTerm.addAll(lstprodterm);
        }

        objRequestForQuote.CC_SubProdTerm__c = lstESubProdTerm[0].Id;
        objRequestForQuote.Cost_Subscription__c = 2000;
        objRequestForQuote.Status__c = 'Requested';
        objRequestForQuote.CC_Product__c = lstEProduct[0].Id;
        objRequestForQuote.Product_Plan__c = 'Base';
        objRequestForQuote.Quantity__c = 2;
        objRequestForQuote.Display_Product__c = lstEProduct[0].Id;
        objRequestForQuote.ccrz__Amount__c = 500;
        objRequestForQuote.ccrz__Storefront__c = 'SoftwareStore';
        objRequestForQuote.ccrz__Description__c = 'Testing...';
        objRequestForQuote.Discounted_Price__c = 200;
        objRequestForQuote.Discounted_Percentage__c = 20;
        objRequestForQuote.Final_Price__c = 200;
        objRequestForQuote.ccrz__Account__c = accountIdval;
        objRequestForQuote.ccrz__Contact__c = contactIdval;
        insert objRequestForQuote;
        System.debug('contactIdval===: '+contactIdval);
        System.debug('objRequestForQuote===: '+objRequestForQuote);
        
        ccrz__E_ProductMedia__c mediaObj = new ccrz__E_ProductMedia__c();
        mediaObj.ccrz__Enabled__c = true;
        mediaObj.ccrz__EndDate__c = System.today().addMonths(4);
        mediaObj.ccrz__Product__c = lstEProduct[0].Id;
        mediaObj.ccrz__MediaType__c = 'Product Image Thumbnail';
        mediaObj.ccrz__URI__c = 'Product Image Thumbnail';
        
        insert mediaObj;
        
    
    
   // test.StartTest();
    
      // Create RemoteActionContext Class Data
      ccrz.cc_RemoteActionContext objRemoteClass = new ccrz.cc_RemoteActionContext();
      objRemoteClass.storefront = 'SoftwareStore';
      objRemoteClass.currentCartId = lstECart2[0].Id;
      objRemoteClass.portalUserId = userIdval;
      objRemoteClass.userLocale = 'en_US';
      
      // Call Apex Class Methods
            OSM_SW_Cart_Quote_Comp_Ctrl.fetchQuote(objRemoteClass);
      OSM_SW_Cart_Quote_Comp_Ctrl.approveOrRejectQuote(objRemoteClass, objRequestForQuote.Id, 'Accepted');
    
        // Stop Test
    //test.StopTest();
    
    }
  }
  
  
  static testMethod void testfetchQuoteListItems4(){
    
    
    
  
  
  
        Id SYS_ADMIN_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id; 
        User ADMIN_USER = [Select Id, Name from User where ProfileId = :SYS_ADMIN_PROFILE_ID and IsActive = true LIMIT 1];
        
        
        
         UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
    system.debug('portalRole is ' + portalRole);

    Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
    User portalAccountOwner1 = new User(
    UserRoleId = portalRole.Id,
    ProfileId = profile1.Id,
    Username = System.now().millisecond() + 'test2tyu@test.com.osm',
    Alias = 'bantyu',
    Email='bruce.wayne@wayneenterprises.com',
    EmailEncodingKey='UTF-8',
    Firstname='Brucet',
    Lastname='Wayne',
    LanguageLocaleKey='en_US',
    LocaleSidKey='en_US',
    TimeZoneSidKey='America/Chicago'
    );
    Database.insert(portalAccountOwner1);

    //User u1 = [Select ID From User Where Id =: portalAccountOwner1.Id];
    Id contactIdval;
    Id accountIdval;
    Id userIdval;
    ccrz__E_RequestForQuote__c objRequestForQuote = new ccrz__E_RequestForQuote__c();
    List<ccrz__E_Cart__c> lstECart2 = new List<ccrz__E_Cart__c>();
    System.runAs ( portalAccountOwner1 ) {
    //Create account
    Account portalAccount1 = new Account(
    Name = 'TestAccount',
    OwnerId = portalAccountOwner1.Id
    );
    Database.insert(portalAccount1);
accountIdval = portalAccount1.Id;
    //Create contact
    Contact contact1 = new Contact(
    FirstName = 'Test',
    Lastname = 'McTesty',
    AccountId = portalAccount1.Id,
    IAM_Contact_Status__c='Active',
    Email = System.now().millisecond() + 'test@test.com'
    );
    Database.insert(contact1);
    //contactIdval = contact1.Id;
    //Create user
    Profile portalProfile = [SELECT Id FROM Profile where name = 'Customer Community Plus User' Limit 1];
    User user1 = new User(
    Username = System.now().millisecond() + 'test12345zz@test.com',
    ContactId = contact1.Id,
    ProfileId = portalProfile.Id,
    Alias = 'teszz',
    Email = 'test12345@test.com',
    EmailEncodingKey = 'UTF-8',
    LastName = 'McTesty',
    CommunityNickname = 'test12345',
    TimeZoneSidKey = 'America/Los_Angeles',
    LocaleSidKey = 'en_US',
    LanguageLocaleKey = 'en_US'
    );
    Database.insert(user1);
    userIdval = user1.Id;
    

        

    
     // Create User
        User loggedInUser = [Select id from User where id=: UserInfo.getUserId()];

        
        
    // Create E Cart
        lstECart2 = TestingUtils.CreateCart(1, 'SoftwareStore', 'Cart', loggedInUser.Id, true, 'Open', true);
        
    // Create E Product
        List<ccrz__E_Product__c> lstEProduct = TestingUtils.createEProduct(3, 'TestProduct', 'Released', 2, 'SK100-1', 'DA', true);
        
    // Create E SubProdTerm
    List<ccrz__E_SubProdTerm__c> lstESubProdTerm = new List<ccrz__E_SubProdTerm__c>();
        for(Integer i=0; i<lstEProduct.size(); i++){
            List<ccrz__E_SubProdTerm__c> lstprodterm = TestingUtils.createSubProdTerm(1, 'TestSubProdTerm', lstEProduct[i].Id, '*', true);
            lstESubProdTerm.addAll(lstprodterm);
        }
      
    
     
        
        
        objRequestForQuote.CC_SubProdTerm__c = lstESubProdTerm[0].Id;
        objRequestForQuote.Cost_Subscription__c = 2000;
        objRequestForQuote.Status__c = 'Requested';
        objRequestForQuote.CC_Product__c = lstEProduct[0].Id;
        objRequestForQuote.Product_Plan__c = 'Base';
        objRequestForQuote.Quantity__c = 2;
        objRequestForQuote.Display_Product__c = lstEProduct[0].Id;
        objRequestForQuote.ccrz__Amount__c = 500;
        objRequestForQuote.ccrz__Storefront__c = 'SoftwareStore';
        objRequestForQuote.ccrz__Description__c = 'Testing...';
        objRequestForQuote.Discounted_Price__c = 200;
        objRequestForQuote.Discounted_Percentage__c = 20;
        objRequestForQuote.Final_Price__c = 200;
        objRequestForQuote.ccrz__Account__c = accountIdval;
        objRequestForQuote.ccrz__Contact__c = contactIdval;
        insert objRequestForQuote;
        System.debug('contactIdval===: '+contactIdval);
        System.debug('objRequestForQuote===: '+objRequestForQuote);
        
    
    //test.StartTest();
    
      // Create RemoteActionContext Class Data
      ccrz.cc_RemoteActionContext objRemoteClass = new ccrz.cc_RemoteActionContext();
      objRemoteClass.storefront = 'SoftwareStore';
      objRemoteClass.currentCartId = lstECart2[0].Id;
      objRemoteClass.portalUserId = userIdval;
      objRemoteClass.userLocale = 'en_US';
      
      // Call Apex Class Methods
            OSM_SW_Cart_Quote_Comp_Ctrl.fetchQuote(objRemoteClass);
      OSM_SW_Cart_Quote_Comp_Ctrl.approveOrRejectQuote(objRemoteClass, objRequestForQuote.Id, 'Accepted');
    
        // Stop Test
    //test.StopTest();
    
    }
  }
  
  static testMethod void testfetchQuoteListItems5(){
    
    
    
  
  
  
        Id SYS_ADMIN_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id; 
        User ADMIN_USER = [Select Id, Name from User where ProfileId = :SYS_ADMIN_PROFILE_ID and IsActive = true LIMIT 1];
        
        
        
         UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
    system.debug('portalRole is ' + portalRole);

    Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
    User portalAccountOwner1 = new User(
    UserRoleId = portalRole.Id,
    ProfileId = profile1.Id,
    Username = System.now().millisecond() + 'test2bnmi@test.com',
    Alias = 'banvb',
    Email='bruce.wayne@wayneenterprises.com',
    EmailEncodingKey='UTF-8',
    Firstname='Brucevb',
    Lastname='Wayne',
    LanguageLocaleKey='en_US',
    LocaleSidKey='en_US',
    TimeZoneSidKey='America/Chicago'
    );
    Database.insert(portalAccountOwner1);

    //User u1 = [Select ID From User Where Id =: portalAccountOwner1.Id];
    Id contactIdval;
    Id accountIdval;
    Id userIdval;
    ccrz__E_RequestForQuote__c objRequestForQuote = new ccrz__E_RequestForQuote__c();
    List<ccrz__E_Cart__c> lstECart2 = new List<ccrz__E_Cart__c>();
    System.runAs ( portalAccountOwner1 ) {
    //Create account
    Account portalAccount1 = new Account(
    Name = 'TestAccount',
    OwnerId = portalAccountOwner1.Id
    );
    Database.insert(portalAccount1);
accountIdval = portalAccount1.Id;
    //Create contact
    Contact contact1 = new Contact(
    FirstName = 'Test',
    Lastname = 'McTesty',
    AccountId = portalAccount1.Id,
    IAM_Contact_Status__c='Active',
    Email = System.now().millisecond() + 'test@test.com'
    );
    Database.insert(contact1);
    contactIdval = contact1.Id;
    //Create user
    Profile portalProfile = [SELECT Id FROM Profile where name = 'Customer Community Plus User' Limit 1];
    User user1 = new User(
    Username = System.now().millisecond() + 'test12345iii@test.com',
    ContactId = contact1.Id,
    ProfileId = portalProfile.Id,
    Alias = 't3',
    Email = 'test12345@test.com',
    EmailEncodingKey = 'UTF-8',
    LastName = 'McTesty',
    CommunityNickname = 'test12345',
    TimeZoneSidKey = 'America/Los_Angeles',
    LocaleSidKey = 'en_US',
    LanguageLocaleKey = 'en_US'
    );
    Database.insert(user1);
    userIdval = user1.Id;
    

        

    
     // Create User
        User loggedInUser = [Select id from User where id=: UserInfo.getUserId()];

        
        
    // Create E Cart
        lstECart2 = TestingUtils.CreateCart(1, 'SoftwareStore', 'Cart', loggedInUser.Id, true, 'Open', true);
        
    // Create E Product
        List<ccrz__E_Product__c> lstEProduct = TestingUtils.createEProduct(3, 'TestProduct', 'Released', 2, 'SK100-1', 'DA', true);
        
    // Create E SubProdTerm
    List<ccrz__E_SubProdTerm__c> lstESubProdTerm = new List<ccrz__E_SubProdTerm__c>();
        for(Integer i=0; i<lstEProduct.size(); i++){
            List<ccrz__E_SubProdTerm__c> lstprodterm = TestingUtils.createSubProdTerm(1, 'TestSubProdTerm', lstEProduct[i].Id, '*', true);
            lstESubProdTerm.addAll(lstprodterm);
        }
      
    
     
        
        
        objRequestForQuote.CC_SubProdTerm__c = lstESubProdTerm[0].Id;
        objRequestForQuote.Cost_Subscription__c = 2000;
        objRequestForQuote.Status__c = 'Requested';
        objRequestForQuote.CC_Product__c = lstEProduct[0].Id;
        objRequestForQuote.Product_Plan__c = 'Base';
        objRequestForQuote.Quantity__c = 2;
        objRequestForQuote.Display_Product__c = lstEProduct[0].Id;
        objRequestForQuote.ccrz__Amount__c = 500;
        objRequestForQuote.ccrz__Storefront__c = 'SoftwareStore';
        objRequestForQuote.ccrz__Description__c = 'Testing...';
        objRequestForQuote.Discounted_Price__c = 200;
        objRequestForQuote.Discounted_Percentage__c = 20;
        objRequestForQuote.Final_Price__c = 200;
        objRequestForQuote.ccrz__Account__c = accountIdval;
        objRequestForQuote.ccrz__Contact__c = contactIdval;
        insert objRequestForQuote;
        System.debug('contactIdval===: '+contactIdval);
        System.debug('objRequestForQuote===: '+objRequestForQuote);
        
        
        ccrz__E_RequestForQuote__c objRequestForQuote2 = new ccrz__E_RequestForQuote__c();
        objRequestForQuote2.CC_SubProdTerm__c = lstESubProdTerm[0].Id;
        objRequestForQuote2.Cost_Subscription__c = 1000;
        objRequestForQuote2.Status__c = 'Requested';
        objRequestForQuote2.CC_Product__c = lstEProduct[0].Id;
        objRequestForQuote2.Product_Plan__c = 'Base';
        objRequestForQuote2.Quantity__c = 1;
        objRequestForQuote2.Display_Product__c = lstEProduct[0].Id;
        objRequestForQuote2.ccrz__Amount__c = 1000;
        objRequestForQuote2.ccrz__Storefront__c = 'SoftwareStore';
        objRequestForQuote2.ccrz__Description__c = 'Testing...';
        objRequestForQuote2.Discounted_Price__c = 300;
        objRequestForQuote2.Discounted_Percentage__c = 20;
        objRequestForQuote2.Final_Price__c = 300;
        objRequestForQuote2.ccrz__Account__c = accountIdval;
        objRequestForQuote2.ccrz__Contact__c = contactIdval;
        insert objRequestForQuote2;
        System.debug('contactIdval===: '+contactIdval);
        System.debug('objRequestForQuote2===: '+objRequestForQuote2);
    
    
    //test.StartTest();
    
      // Create RemoteActionContext Class Data
      ccrz.cc_RemoteActionContext objRemoteClass = new ccrz.cc_RemoteActionContext();
      objRemoteClass.storefront = 'SoftwareStore';
      objRemoteClass.currentCartId = lstECart2[0].Id;
      objRemoteClass.portalUserId = userIdval;
      objRemoteClass.userLocale = 'en_US';
      
            OSM_SW_Cart_Quote_Comp_Ctrl.fetchQuote(objRemoteClass);
      OSM_SW_Cart_Quote_Comp_Ctrl.approveOrRejectQuote(objRemoteClass, objRequestForQuote.Id, 'Accepted');
    
      // Call Apex Class Methods
        // Stop Test
   // test.StopTest();
    
    }
  }
  
 }