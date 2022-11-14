/*********************************************************************************
Author       :   Sushma Rajput
Created Date :   23rd Sept,2019
Description  :   Unit test class for  IAM_CreateUser
*********************************************************************************/

@isTest
public class IAM_UserCreation_Test{
    
    /*@isTest
    public static void createTestData(){
    
        Map<id,Boolean> oldmap = new Map<id,Boolean>();
        Map<id,Account> newmap = new Map<id,Account>();
        
        Account accRecord = new Account();
        accRecord.Name = 'Test Company';
        accRecord.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();  
        accRecord.phone = '6884382997';
        accRecord.Type = 'Dealer Account';
        accRecord.IAM_Service_Provider_Code__c = '54699';
        accRecord.CSS_DBCode__c = 'tesC';
        accRecord.CSS_DistributorCode__c = 'tesD';
        //accRecord.Location__c = 'testLoca';
        accRecord.CSS_DealerCode__c = 'testDea';
        accRecord.BillingStreet = 'street';
        accRecord.BillingCity = 'Telangana';
        accRecord.BillingCountry = 'India';
        accRecord.BillingPostalCode = '234567';
        accRecord.IAM_Movex_Customer_Code__c = 'testMov';
        accRecord.IAM_WWSPS_Regions__c = 'US and Canada';
        insert accRecord ;
        
        oldmap.put(accRecord.id, true);
        newmap.put(accRecord.id, accRecord);
        
        //Contact        
        List<Contact> lstContact = new List<Contact>();
        Contact conNew = new Contact();
        conNew.accountID = accRecord.id;  
        conNew.RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();       
        conNew.Email= 'testReclaim@mail.com'; 
        conNew.FirstName = 'Send';
        conNew.LastName = 'Send LDAP'; 
        //conNew.IAM_Contact_Status__c = 'Active';        
        conNew.Username__c =  'testReclaim@mail.com';        
        conNew.phone = '8989898989';  
        conNew.IAM_Final_Approver__c = 'N';
        conNew.IAM_Qsolexpiration__c = 'testABC';
        conNew.IAM_swregexpire__c ='testCon';
        conNew.IAM_Internal__c = true;
        conNew.IAM_Applications__c = 'CSS_DN_Advanced';
        conNew.CMI_Contact_Type__c = 'Primary';
        conNew.IAM_is_Member_of__c = 'testMemeber';
        
        Contact conNew2 = new Contact();
        conNew2.accountID = accRecord.id;  
        conNew2.RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();       
        conNew2.Email= 'reclaimTest@mail.com'; 
        conNew2.FirstName = 'Send2';
        conNew2.LastName = 'Send LDAP2'; 
        conNew2.IAM_Contact_Status__c = 'Active';        
        conNew2.Username__c =  'reclaimTest@mail.com'; 
        //conNew2.IAM_Contact_Status__c = 'Inactive';
        conNew2.IAM_Final_Approver__c = 'N';
        conNew2.phone = '8989898989';  
        //conNew2.IAM_Applications__c = 'CSS_DN_TECH';
        conNew2.CMI_Contact_Type__c = 'Secondary';
        conNew2.IAM_is_Member_of__c = 'testMemeber';
        
        Contact conNew3 = new Contact();
        conNew3.accountID = accRecord.id;  
        conNew3.RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();       
        conNew3.Email= 'reclaimTest2@mail.com'; 
        conNew3.FirstName = 'Send3';
        conNew3.LastName = 'Send LDAP3'; 
        conNew3.IAM_Contact_Status__c = 'Inactive';        
        conNew3.Username__c =  'reclaimTest2@mail.com'; 
        //conNew2.IAM_Contact_Status__c = 'Inactive';
        conNew3.IAM_Final_Approver__c = 'N';
        conNew3.phone = '8989898989';  
        //conNew2.IAM_Applications__c = 'CSS_DN_TECH';
        conNew3.CMI_Contact_Type__c = 'Secondary';
        conNew3.IAM_is_Member_of__c = 'testMemeber';
        
        lstContact.add(conNew);
        lstContact.add(conNew2);
        lstContact.add(conNew3);
        insert lstContact;
        
        List<profile> pf = [select Id,Name from Profile WHERE Name = 'CSS_WS_Distributor_Service' limit 1];
        
        
        User newUser = new User();
        newUser.FirstName = 'Send';
        newUser.LastName = 'Send LDAP';
        newUser.Email = 'testReclaimBSH@mail.com';   
        newUser.CompanyName = 'Test Company';        
        //newUser.CommunityNickname = 'test';
        newUser.CommunityNickname = 'Utes2';
        newUser.Username = 'testReclaimSAK@mail.com' ;
        newUser.Alias = 'test';
        newUser.TimeZoneSidKey = 'GMT';
        newUser.LocaleSidKey= 'en_US';
        newUser.EmailEncodingKey = 'UTF-8';
        newUser.LanguageLocaleKey = 'en_US';         
        newUser.ProfileId = pf[0].Id ;                                  
        newUser.ContactId =conNew.Id;                   
        newUser.isActive = true;
        newUser.Street = '123 Test St';
        newUser.IAM_UID__c = '';
        newUser.FederationIdentifier = conNew.Username__c;  
        
        //insert newUser;
        
        User newUser2 = new User();
        newUser2.FirstName = 'UserFirstNameDWU';
        newUser2.LastName = 'test';
        newUser2.Email = 'reclaimTestQDHBAS@mail.com';   
        newUser2.CompanyName = 'Test Company';        
        //newUser.CommunityNickname = 'test';
        newUser2.CommunityNickname = 'Utest';
        newUser2.Username = 'reclaimTestVSAHDHJ@mail.com' ;
        newUser2.Alias = 'test';
        newUser2.TimeZoneSidKey = 'GMT';
        newUser2.LocaleSidKey= 'en_US';
        newUser2.EmailEncodingKey = 'UTF-8';
        newUser2.LanguageLocaleKey = 'en_US';         
        newUser2.ProfileId = pf[0].Id ;                                  
        newUser2.ContactId =conNew2.Id;                   
        newUser2.isActive = False;
        newUser2.Street = '123 Test St';
        newUser2.IAM_UID__c = conNew2.Username__c; 
        //newUser2.FederationIdentifier = conNew2.Username__c;  
        
        //insert  newUser2;
        
        User newUser3 = new User();
        newUser3.FirstName = 'UserFirstNameDWUom';
        newUser3.LastName = 'test2';
        newUser3.Email = 'reclaimTestQDHBASter@mail.com';   
        newUser3.CompanyName = 'Test Company';        
        //newUser.CommunityNickname = 'test';
        newUser3.CommunityNickname = 'Utest';
        newUser3.Username = 'reclaimTestVSAHDHJgt@mail.com' ;
        newUser3.Alias = 'test';
        newUser3.TimeZoneSidKey = 'GMT';
        newUser3.LocaleSidKey= 'en_US';
        newUser3.EmailEncodingKey = 'UTF-8';
        newUser3.LanguageLocaleKey = 'en_US';         
        newUser3.ProfileId = pf[0].Id ;                                  
        newUser3.ContactId =conNew3.Id;                   
        newUser3.isActive = False;
        newUser3.Street = '123 Test St';
        insert newUser3;
        
        
        IAM_Application__c app = new IAM_Application__c();
        app.IAM_Application_Name__c = 'CUMPAS 2.0';
        app.IAM_Role__c = 'Dealer Admin';
        app.IAM_Status__c = 'Active';
        app.IAM_Account_Name__c = accRecord.id;
        app.IAM_Subscription_Name__c = 'test';
        app.IAM_Cumpas_Modularity__c = 'View Credit';    
        app.IAM_Cumpas_Distributor_Sales_Rep__c = conNew2.id;
        insert app;
        
                
        IAM_Application__c app2 = new IAM_Application__c();    
        app2.IAM_Account_Name__c = conNew.accountID;
        app2.IAM_Application_Name__c = 'Guidanz Mobile';
        app2.IAM_Role__c='Guidanz Mobile Campaign Dealer';
        app2.IAM_Status__c='Active';
        app2.IAM_Subscription_Count__c= 10;
        app2.IAM_Provisioned_User_Count__c=5;
        app2.IAM_Subscription_End_Date__c= System.today() + 5;
        app2.IAM_Subscription_Name__c='TestSubscription1GuidanzMob';
        app2.IAM_Free_Subscription__c= False;
        app2.IAM_Subscription_Start_Date__c=System.today();
        app2.IAM_swregExpire__c = 'Test';
        app2.IAM_Qsolview__c = 'testCon';
        insert app2;
        
        
        IAM_Application__c app3 = new IAM_Application__c();
        app3.IAM_Application_Name__c = 'QuickServe Online';
        app3.IAM_Role__c = 'Advanced';
        app3.IAM_Status__c = 'Active';
        app3.IAM_Account_Name__c = accRecord.id;
        app3.IAM_Subscription_Name__c = 'test';
        app3.IAM_Qsolexpiration__c = 'test';
        insert app3;
        
        IAM_Application__c app4 = new IAM_Application__c();
        app4.IAM_Application_Name__c = 'Guidanz';
        app4.IAM_Role__c = 'Technician';
        app4.IAM_Status__c = 'Active';
        app4.IAM_Account_Name__c = accRecord.id;
        app4.IAM_Subscription_Name__c = 'test';
        app4.IAM_Qsolexpiration__c = 'test';
        app4.IAM_Cumpas_Modularity__c = 'View Credit'; 
        insert app4;
        
        IAM_Application_Groups__c iamAppGrp = new IAM_Application_Groups__c ();
        iamAppGrp.IAM_Application_Name__c = System.Label.IAM_AppName_ConnectedSolutions;
        iamAppGrp.IAM_Role_Name__c = 'Operator';
        iamAppGrp.IAM_DN_value__c = 'cn=Operator,ou=Connected Solutions,ou=application,dc=cummins,dc=com';
        iamAppGrp.Name = System.Label.IAM_AppName_ConnectedSolutions;
        insert iamAppGrp;
        
        IAM_Application_Groups__c iamAppGrp1 = new IAM_Application_Groups__c ();
        iamAppGrp1.IAM_Application_Name__c = System.Label.IAM_AppName_guidanzmobile;
        iamAppGrp1.IAM_Role_Name__c = 'Guidanz Mobile Campaign Dealer';
        iamAppGrp1.IAM_DN_value__c = 'cn=ATLAS_Universal_CAMPAIGN_DEALER,ou=APP_ATLAS_UNIVERSAL,ou=application,dc=cummins,dc=com';
        iamAppGrp1.Name = System.Label.IAM_AppName_guidanzmobile;
        insert iamAppGrp1;
        
        IAM_Application_Groups__c iamAppGrp2 = new IAM_Application_Groups__c ();
        iamAppGrp2.IAM_Application_Name__c = System.Label.IAM_AppName_QSOL;
        iamAppGrp2.IAM_Role_Name__c = 'QSOL Dealer';
        iamAppGrp2.IAM_DN_value__c = 'cn=QuickServe_Dealers,ou=APP_QuickServe,ou=application,dc=cummins,dc=com';
        iamAppGrp2.Name = System.Label.IAM_AppName_QSOL;
        insert iamAppGrp2;
        
        IAM_Application_Groups__c iamAppGrp3 = new IAM_Application_Groups__c ();
        iamAppGrp3.IAM_Application_Name__c = System.Label.IAM_Cummins_Service_Training;
        iamAppGrp3.IAM_Role_Name__c = 'Service Training User';
        iamAppGrp3.IAM_DN_value__c = 'cn=SERVICE_TRAINING_DN_USERS,ou=APP_SERVICE_TRAINING,ou=application,dc=cummins,dc=com';
        iamAppGrp3.Name = System.Label.IAM_Cummins_Service_Training;
        insert iamAppGrp3;
        
        
        //IAM Contact Provisioning
        List<IAM_Contact_Provisioning__c> lstconApp = new List<IAM_Contact_Provisioning__c>();
        IAM_Contact_Provisioning__c conApp = new IAM_Contact_Provisioning__c();
        //conApp.IAM_Application_Name__c = 'Marketplace';
        conApp.RecordTypeId=Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId(); 
        conApp.IAM_Application_Name__c = 'Guidanz';
        conApp.IAM_Role__c = 'Advanced';        
        conApp.IAM_Status__c = 'Active';
        conApp.IAM_Contact__c = conNew.id; 
        conApp.IAM_Account_Application__c = app4.id;    
        //insert conApp;
        
        IAM_Contact_Provisioning__c conApp2 = new IAM_Contact_Provisioning__c();
        // conApp2.RecordTypeId=Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId(); 
        // conApp.IAM_Application_Name__c = 'QuickServe Online';
        conApp2.RecordTypeId=Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId(); 
        conApp2.IAM_Role__c = 'Technician';        
        conApp2.IAM_Status__c = 'Active';
        conApp2.IAM_Contact__c = conNew2.id; 
        conApp2.IAM_Account_Application__c = app.id;
        
        IAM_Contact_Provisioning__c conApp3 = new IAM_Contact_Provisioning__c();
        conApp3.RecordTypeId=Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId(); 
        conApp3.IAM_Application_Name__c = 'QuickServe Online';
        conApp3.IAM_Role__c = 'QSOL Dealer';        
        conApp3.IAM_Status__c = 'Active';
        conApp3.IAM_Contact__c = conNew.id; 
        conApp3.IAM_Account_Application__c = app.id;
        conApp3.IAM_Qsolexpiration__c = 'test';
        
        IAM_Contact_Provisioning__c conApp4 = new IAM_Contact_Provisioning__c();
        conApp4.RecordTypeId=Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Guidanz Mobile').getRecordTypeId(); 
        conApp4.IAM_Application_Name__c = 'Guidanz Mobile';
        conApp4.IAM_Role__c = 'Guidanz Mobile Campaign Distributor';        
        conApp4.IAM_Status__c = 'Active';
        conApp4.IAM_Contact__c = conNew3.id; 
        conApp4.IAM_Account_Application__c = app2.id;
        conApp4.IAM_Qsolexpiration__c = 'test';
        
        lstconApp.add(conApp);
        lstconApp.add(conApp2);
        lstconApp.add(conApp3);
        lstconApp.add(conApp4);
        insert lstconApp;
        
        
        CSS_Integration_Details__c csID = new CSS_Integration_Details__c();
        csID.NAme='IAM_LDAP_oAuth';
        csID.ApplicationName__c ='IAM_LDAP_oAuth';
        csID.End_Point__c = 'https://services-dev-oauth.cummins.com/api/oauth/token/ldaputil';
        csId.IsActive__c = true;
        csID.Key__c='jb6sFHd/KsMjdprFnsnLjPgCf+19v/kh49PHL/bjYO7DmigbFZdIaXN7gVS0/fg06Fx9fPolnF3guPkOncLwHA==';
        csID.Passcode__c = 'lhBxWDMxDkfiIXb2hsMD/sC0HJUv4CRi4HlvvXUtopNctqUHq07R8MVrFKNqGJELb2meudGeoTKfD7yjHDdUJA==';
        csId.Username__c = 'SHnBSQhHEqF+DQgb+tSI6K6+EqIKGt/1yWj/4tG4KG4=';
        csId.Logging__c ='LADAPUtil';
        csId.AuthEnv__c = 'OAGoAuth';
        csId.Method_Type__c = 'POST';
        csId.grant_type__c = 'client_credentials';
        insert csID;
  
        Test.startTest();
        
        List<Account> acc = [Select id,Name From Account WHERE Name = 'Test Company'];
        List<Contact> con = [SELECT Id,Phone,Username__c,CMI_User_Id__c,IAM_Ext_Legacy_Uid__c,Email,FirstName,LastName,IAM_Contact_Status__c,CMI_Contact_Type__c,IAM_Applications__c,IAM_is_Member_of__c,IAM_Product_Group_Access__c,IAM_Qsolexpiration__c,IAM_Qsolview__c,IAM_swregexpire__c,IAM_Work_Group_Id__c,AccountId,Account.Name,Account.CSS_Locale__c,Account.CSS_Language__c,Account.CSS_Timezone__c,Account.Type,IAM_Final_Approver__c,Account.IAM_ABO_Code_Formula__c,IAM_Internal__c,Account.IAM_Service_Provider_Code__c,Account.CSS_DBCode__c,Account.CSS_DistributorCode__c,Account.CMI_Account_Num__c,Account.Location__c,Account.BillingCity,Account.BillingCountry,Account.BillingPostalCode,Account.IAM_Movex_Customer_Code__c,Account.BillingStreet,Account.OwnerId,Account.IAM_WWSPS_Regions__c FROM Contact WHERE Username__c = 'reclaimTest2@mail.com' AND AccountId =: acc[0].Id LIMIT 1];
       
        IAM_UserCreation.CreateUsers(con,oldmap,newmap,True,'Test');
        
        Test.stopTest();
       
  } */
  
   static testMethod void testMethod2(){
   
   Test.startTest();
        
        List<Account> acc = [Select id,Name From Account WHERE Name = 'Test Company'];
        List<Contact> con = [SELECT Id,Phone,IAM_Cummins_login_ID__c,CMI_User_Id__c,IAM_Ext_Legacy_Uid__c,Email,FirstName,LastName,IAM_Contact_Status__c,CMI_Contact_Type__c,IAM_Applications__c,IAM_is_Member_of__c,IAM_Product_Group_Access__c,IAM_Qsolexpiration__c,IAM_Qsolview__c,IAM_swregexpire__c,IAM_Work_Group_Id__c,AccountId,Account.Name,Account.CSS_Locale__c,Account.CSS_Language__c,Account.CSS_Timezone__c,Account.Type,IAM_Final_Approver__c,Account.IAM_ABO_Code_Formula__c,IAM_Internal__c,Account.IAM_Service_Provider_Code__c,Account.CSS_DBCode__c,Account.CSS_DistributorCode__c,Account.CMI_Account_Num__c,Account.Location__c,Account.BillingCity,Account.BillingCountry,Account.BillingPostalCode,Account.IAM_Movex_Customer_Code__c,Account.BillingStreet,Account.OwnerId,Account.IAM_WWSPS_Regions__c FROM Contact ];
       
        IAM_UserCreation.validateEmail('sushma.rajput@test.com');
       	IAM_UserCreation.validateEmail('sush  ma.rajput@test.com');
        IAM_UserCreation.CreateUsers(new List<Contact>(), new Map<Id, Boolean>(), new Map<Id, Account>(), True, 'Test');
        
   Test.stopTest();
   }
}