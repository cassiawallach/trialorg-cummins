/************************************************************
Name:  IAM_Assign_App_Permissionset_Test
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test class for IAM_Assign_Application_Permissionset_Test class.
//below class is mainly used as a invokable class fron process builder in order to assaign and delete permission sets from users.
//this class will have two functions which gets invoked on insertion and update on the application status  test                         
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE              DETAIL                                
1.0 -    Karthik Golakaram         20/04/2019        INITIAL DEVELOPMENT  
1.1 -    Nishant Verma             02/10/2020        Fluidwatch Changes for site admin page 
1.3 -    Karthik Raj Golakaram     01/25/2021        Making Changes for OSM High Prod issue - INC1022619
1.4 -    Karthik Raj Golakaram     03/25/2021        Making Changes for Bulk User API
1.5 -    Shubhangi Sardar          27/04/2021        LDAP Code Optimization changes
1.6 -    Shubhangi Sardar          09/08/2021        Added EVL Guidanz Permission Set Changes
1.7 -    Sandeep Vuyyuru           20/01/2022        Market Place and Guidanz Mobile 101 soql issue on registration page
1.8 -    Suresh Rathod             04/05/2022        Added comment to push to prod
1.9 -    Souvik Lahiri             09/01/2022        Added comment to push to prod
2.0 -    Chetan Gaikwad            26/09/2022        Added comment to push to prod 
*****************************************************/
/********************************************************************************
***********************************************************************************/  
@isTest
public class IAM_Assign_App_Permissionset_Test{
    static testMethod void testMethod1(){
        
        Test.startTest();
        try {
        List<Account> accList = new List<Account>();
        Account acc1 = new Account();
        acc1.Name = 'TestAccount1';
        acc1.Type = 'Distributor Account';
        acc1.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName()
                  .get(System.Label.IAM_WWSPS).getRecordTypeId();
        accList.add(acc1);
        
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.IAM_Service_Provider_Code__c = '123';
        acc.Type = 'Dealer Account';
        acc.CSS_DistributorCode__c = '1234';
        acc.CSS_DBCode__c = '12345';
        acc.CSS_DealerCode__c = '456';
        accList.add(acc);       
        insert accList;

        List<Contact> conList = new List<Contact>();
        Contact con1 = new contact();
        con1.lastName = 'Te';
        con1.AccountId = acc1.id;
        con1.firstName = 'fi';
        con1.Email = 'testContact1@test.com';
        con1.IAM_Contact_Status__c = 'Active';
        con1.CMI_Contact_Type__c = 'Secondary';
        con1.phone = '8989898989';
        Con1.Username__c = 'test_user_helper7@eidm.com';
        conList.add(con1);       
        
        Contact con3 = new contact();
        con3.lastName = 'Test1';
        con3.AccountId = acc1.id;
        con3.firstName = 'fist1';
        con3.Email = 'testContact1@test.com';
        con3.IAM_Contact_Status__c = 'Active';
        con3.CMI_Contact_Type__c = 'Secondary';
        con3.phone = '8989898989';
        Con3.Username__c = 'test_user_helper9@eidm.com';
        conList.add(con3);
        insert conList;
        
        User us2 = new User(
           ProfileId = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community'].Id,
           LastName = 'last',
           Email = 'puser000@amamama.com',
           Username = 'puser000@amamama.com' + System.currentTimeMillis(),
           CompanyName = 'TEST',
           Title = 'title',
           Alias = 'alias',
           TimeZoneSidKey = 'America/Los_Angeles',
           EmailEncodingKey = 'UTF-8',
           LanguageLocaleKey = 'en_US',
           LocaleSidKey = 'en_US',
           contactId =con1.Id
       );
    
        Id ProfId = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community'].Id;
        
        List<IAM_Application__c> appList = new List<IAM_Application__c>();
        IAM_Application__c app1 = new IAM_Application__c();
        app1.IAM_Application_Name__c = 'Guidanz';
        app1.IAM_Role__c = 'Advanced';
        app1.IAM_Status__c = 'Active';
        app1.IAM_Account_Name__c = acc.id;
        app1.IAM_Subscription_Name__c = 'test';
        app1.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        appList.add(app1);

        IAM_Application__c app6 = new IAM_Application__c();
        app6.IAM_Application_Name__c = 'Repair logistics and Service';
        app6.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Repair logistics and Service').getRecordTypeId();
        app6.IAM_Role__c = 'RLS Admin';
        app6.IAM_Status__c = 'Active';
        app6.IAM_Account_Name__c = acc.id;
        app6.IAM_Subscription_Name__c = 'test';
        appList.add(app6);  
        insert appList;
        
        List<IAM_Contact_Provisioning__c> conProAppList = new List<IAM_Contact_Provisioning__c>();    
        IAM_Contact_Provisioning__c conApp1 = new IAM_Contact_Provisioning__c();
        conApp1.IAM_Application_Name__c = app1.IAM_Application_Name__c;
        conApp1.IAM_Role__c = 'Advanced';
        conApp1.IAM_Status__c = 'Active';
        conApp1.IAM_Contact__c = con1.id; 
        conApp1.IAM_Account_Application__c = app1.id;
        conApp1.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        conProAppList.add(conApp1);
        
        IAM_Contact_Provisioning__c conApp6 = new IAM_Contact_Provisioning__c();
        conApp6.IAM_Application_Name__c = 'Repair logistics and Service';
        conApp6.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Repair logistics and Service').getRecordTypeId();
        conApp6.IAM_Role__c = 'RLS Admin';
        conApp6.IAM_Status__c = 'Inactive';
        conApp6.IAM_Contact__c = con1.id; 
        conApp6.IAM_User__c = us2.id;
        conApp6.IAM_Account_Application__c = app6.id;
        conProAppList.add(conApp6);
        insert conProAppList;

        List<IAM_Contact_Provisioning__c> lstContProv = new List<IAM_Contact_Provisioning__c>();
        lstContProv.add(conApp6);
    
        Set<Id> setUserIds = new Set<Id>();
        setUserIds.add(us2.Id);
        Set<Id> setContProvIds = new Set<Id>();
        
        setContProvIds.add(conApp6.id);
        
        User usr = [Select id,IAM_Final_Approver__c from User where Id = :UserInfo.getUserId()];
        PermissionSet perSet=[SELECT Id,Label,Name,NamespacePrefix,ProfileId FROM PermissionSet where Label=:System.Label.IAM_Application_Name_Archer];
        //System.RunAs(us2){
            IAM_Assign_Application_Permissionset.AssignApplication(lstContProv);
            IAM_Assign_Application_Permissionset.AssignPermissionSetToUsers(setUserIds, perSet.id, 'Insert');
            IAM_Assign_Application_Permissionset.AssignPermissionSetToUsers(setUserIds, perSet.id, 'Delete');
            IAM_Assign_Application_Permissionset.AssignPermissionSetToUsers(setUserIds, '097865', 'Delete');
            //}
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
        Test.stopTest();
    }   
        
   
    static testMethod void testMethod3(){
        Test.startTest();
        try {
            List<Account> accList = new List<Account>();
        Account acc1 = new Account();
        acc1.Name = 'TestAccount1';
        acc1.Type = 'Distributor Account';
        acc1.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName()
                  .get(System.Label.IAM_WWSPS).getRecordTypeId();
        accList.add(acc1);
        
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.IAM_Service_Provider_Code__c = '123';
        acc.Type = 'Dealer Account';
        acc.CSS_DistributorCode__c = '1234';
        acc.CSS_DBCode__c = '12345';
        acc.CSS_DealerCode__c = '456';
        accList.add(acc);
        insert accList;
        
        Contact con2 = new contact();
        con2.lastName = 'Tes';
        con2.AccountId = acc1.id;
        con2.firstName = 'fis';
        con2.Email = 'testContact1@test.com';
        con2.IAM_Contact_Status__c = 'Active';
        con2.CMI_Contact_Type__c = 'Secondary';
        con2.phone = '8989898989';
        Con2.Username__c = 'test_user_helper8@eidm.com';
        insert con2;
        
       User u = new User(
           ProfileId = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community'].Id,
           LastName = 'last',
           Email = 'puser000@amamama.com',
           Username = 'puser000@amamama.com' + System.currentTimeMillis(),
           CompanyName = 'TEST',
           Title = 'title',
           Alias = 'alias',
           TimeZoneSidKey = 'America/Los_Angeles',
           EmailEncodingKey = 'UTF-8',
           LanguageLocaleKey = 'en_US',
           LocaleSidKey = 'en_US',
           contactId =con2.Id
       );
        insert u;
        
        IAM_Application__c app4 = new IAM_Application__c();
        app4.IAM_Application_Name__c = System.Label.IAM_AppName_ConnectedSolutions;
        app4.IAM_Role__c = 'Operator';
        app4.IAM_Status__c = 'Active';
        app4.IAM_Account_Name__c = acc.id;
        app4.IAM_Subscription_Name__c = 'test';
        app4.IAM_Qsolexpiration__c = 'test expire';
        app4.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get(System.Label.IAM_AppName_ConnectedSolutions).getRecordTypeId();
        insert app4;
        
        
        IAM_Contact_Provisioning__c conApp7 = new IAM_Contact_Provisioning__c();
        conApp7.IAM_Application_Name__c = app4.IAM_Application_Name__c;
        conApp7.IAM_Role__c = 'Operator';
        //conApp2.IAM_Start_Date__c = system.now();
        conApp7.IAM_Status__c = 'Active';
        conApp7.IAM_Contact__c = con2.id; 
        conApp7.IAM_Account_Application__c = app4.id;
        conApp7.IAM_Qsolexpiration__c = 'test expire';
        conApp7.IAM_DA_Customer_List__c = '123456';
        conApp7.IAM_User_Type__c = 'Internal';
        //conApp7.IAM_User__c = us1.id;
        conApp7.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get(System.Label.IAM_AppName_ConnectedSolutions).getRecordTypeId();
        insert conApp7;
        
        
        List<IAM_Contact_Provisioning__c> lstContProv = new List<IAM_Contact_Provisioning__c>();
        lstContProv.add(conApp7);
        
        Set<Id> setUserIds = new Set<Id>();
        setUserIds.add(u.Id);
        Set<Id> setContProvIds = new Set<Id>();
        setContProvIds.add(conApp7.id);
        User usr = [Select id,IAM_Final_Approver__c from User where Id = :UserInfo.getUserId()];
        PermissionSet perSet=[SELECT Id,Label,Name,NamespacePrefix,ProfileId FROM PermissionSet where Label=:System.Label.IAM_Application_Name_Archer];
        //System.RunAs(usr){
                IAM_Assign_Application_Permissionset.AssignApplication(lstContProv);
                IAM_Assign_Application_Permissionset.AssignPermissionSetToUsers(setUserIds, perSet.id, 'Insert');
                IAM_Assign_Application_Permissionset.AssignPermissionSetToUsers(setUserIds, perSet.id, 'Delete');
            
            //}
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
        Test.stopTest();
    }
    static testMethod void testMethodOSMRole(){
        Test.startTest();
        try {
         IAM_PermissionSet_Assignment__c cst = new IAM_PermissionSet_Assignment__c();
        cst.Name='Distributor Admin';
        cst.IAM_Permission_Set_Name__c ='OSM_Distributor_Admin';
        insert cst;
        List<Account> accList = new List<Account>();
        Account acc1 = new Account();
        acc1.Name = 'TestAccount1';
        acc1.Type = 'Distributor Account';
        acc1.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName()
                  .get(System.Label.IAM_WWSPS).getRecordTypeId();
        accList.add(acc1);
        
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.IAM_Service_Provider_Code__c = '123';
        acc.Type = 'Dealer Account';
        acc.CSS_DistributorCode__c = '1234';
        acc.CSS_DBCode__c = '12345';
        acc.CSS_DealerCode__c = '456';
        accList.add(acc);
        insert accList;
        
        Contact con2 = new contact();
        con2.lastName = 'Tes';
        con2.AccountId = acc.id;
        con2.firstName = 'fis';
        con2.Email = 'testContact1@test.com';
        con2.IAM_Contact_Status__c = 'Active';
        con2.CMI_Contact_Type__c = 'Secondary';
        con2.phone = '8989898989';
        Con2.Username__c = 'test_user_helper8@eidm.com';
        con2.IAM_Contact_Status__c ='Active';
        con2.IAM_Internal__c =true;
        con2.IAM_Legacy_User__c =true;
        insert con2;
        List<profile> pf = [select Id,Name from Profile WHERE Name ='IAM_Admin_User'limit 1];
       User newUser = new User();
        newUser.FirstName = con2.FirstName;
        newUser.LastName = con2.LastName;
        newUser.Email = con2.Email;   
        newUser.CompanyName = acc.Name;        
        newUser.CommunityNickname = 'tts';
        newUser.Username = con2.Username__c ;
        newUser.Alias = 'tts';
        newUser.TimeZoneSidKey = 'GMT';
        newUser.LocaleSidKey= 'en_US';
        newUser.EmailEncodingKey = 'UTF-8';
        newUser.LanguageLocaleKey = 'en_US';         
        newUser.ProfileId = pf[0].Id ;                                  
        //newUser.ContactId = con2.Id;                   
        newUser.isActive = true;
        newUser.Street = '123 Test St';
        newUser.FederationIdentifier = Con2.Username__c;
        insert newUser;
    
        List<IAM_Application__c> appList = [SELECT IAM_Application_Name__c, IAM_Role__c, IAM_Status__c,
        IAM_Subscription_Name__c FROM IAM_Application__c WHERE IAM_Account_Name__c = :acc.Id];
        if(appList.isEmpty()) {
            IAM_Application__c app = new IAM_Application__c();
            app.IAM_Application_Name__c = 'Marketplace';
            app.IAM_Role__c = 'Distributor Admin';
            app.IAM_Status__c = 'Active';
            app.IAM_Account_Name__c = acc.id;
            app.IAM_Subscription_Name__c = 'test';
            app.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get('Marketplace').getRecordTypeId();
            insert app;
            list<IAM_Contact_Provisioning__c> lstconpro = new list<IAM_Contact_Provisioning__c>();
            IAM_Contact_Provisioning__c conApp = new IAM_Contact_Provisioning__c();
            conApp.IAM_Application_Name__c = app.IAM_Application_Name__c;
            conApp.IAM_Role__c = 'Distributor Admin';
            //conApp.IAM_Start_Date__c = system.now();
            conApp.IAM_Status__c = 'Active';
            conApp.IAM_Contact__c = con2.id; 
            conApp.IAM_Account_Application__c = app.id;
            conApp.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get('Marketplace').getRecordTypeId();
            lstconpro.add(conapp);
            insert lstconpro;
            IAM_Assign_Application_Permissionset.AssignApplication(lstconpro);
        } else {
            list<IAM_Contact_Provisioning__c> lstconpro = new list<IAM_Contact_Provisioning__c>();
            IAM_Contact_Provisioning__c conApp = new IAM_Contact_Provisioning__c();
            conApp.IAM_Application_Name__c = appList[0].IAM_Application_Name__c;
            conApp.IAM_Role__c = appList[0].IAM_Role__c;
            //conApp.IAM_Start_Date__c = system.now();
            conApp.IAM_Status__c = 'Active';
            conApp.IAM_Contact__c = con2.id; 
            conApp.IAM_Account_Application__c = appList[0].Id;
            conApp.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get('Marketplace').getRecordTypeId();
            lstconpro.add(conapp);
            insert lstconpro;
            IAM_Assign_Application_Permissionset.AssignApplication(lstconpro);
        }
        } catch(Exception e) {
            System.debug('#### Exception - '+e.getMessage());
        }
        Test.stopTest();
    }
    static testMethod void testMethodOSMRole1(){
        Test.startTest();
        try {
         IAM_PermissionSet_Assignment__c cst = new IAM_PermissionSet_Assignment__c();
        cst.Name='OSM Sales Admin';
        cst.IAM_Permission_Set_Name__c ='OSM_Sales_Admin';
        insert cst;

        List<Account> accList = new List<Account>();
        Account acc1 = new Account();
        acc1.Name = 'TestAccount1';
        acc1.Type = 'Distributor Account';
        acc1.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName()
                  .get(System.Label.IAM_WWSPS).getRecordTypeId();
        accList.add(acc1);
        
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.IAM_Service_Provider_Code__c = '123';
        acc.Type = 'Dealer Account';
        acc.CSS_DistributorCode__c = '1234';
        acc.CSS_DBCode__c = '12345';
        acc.CSS_DealerCode__c = '456';
        accList.add(acc);
        insert accList;
        
        Contact con2 = new contact();
        con2.lastName = 'Tes';
        con2.AccountId = acc.id;
        con2.firstName = 'fis';
        con2.Email = 'testContact1@test.com';
        con2.IAM_Contact_Status__c = 'Active';
        con2.CMI_Contact_Type__c = 'Secondary';
        con2.phone = '8989898989';
        Con2.Username__c = 'test_user_helper8@eidm.com';
        con2.IAM_Contact_Status__c ='Active';
        con2.IAM_Internal__c =true;
        con2.IAM_Legacy_User__c =true;
        insert con2;
        List<profile> pf = [select Id,Name from Profile WHERE Name ='IAM_Admin_User'limit 1];
       User newUser = new User();
        newUser.FirstName = con2.FirstName;
        newUser.LastName = con2.LastName;
        newUser.Email = con2.Email;   
        newUser.CompanyName = acc.Name;        
        newUser.CommunityNickname = 'tts';
        newUser.Username = con2.Username__c ;
        newUser.Alias = 'tts';
        newUser.TimeZoneSidKey = 'GMT';
        newUser.LocaleSidKey= 'en_US';
        newUser.EmailEncodingKey = 'UTF-8';
        newUser.LanguageLocaleKey = 'en_US';         
        newUser.ProfileId = pf[0].Id ;                                  
        //newUser.ContactId = con2.Id;                   
        newUser.isActive = true;
        newUser.Street = '123 Test St';
        newUser.FederationIdentifier = Con2.Username__c;
        insert newUser;
    
        //User us3 = [select ProfileId,LastName,Email,Username,CompanyName from user where ContactId =: con2.id];
        IAM_Application__c app = new IAM_Application__c();
        app.IAM_Application_Name__c = 'Marketplace';
        app.IAM_Role__c = 'OSM Sales Admin';
        app.IAM_Status__c = 'Active';
        app.IAM_Account_Name__c = acc.id;
        app.IAM_Subscription_Name__c = 'test';
        app.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get('Marketplace').getRecordTypeId();
        insert app;
        list<IAM_Contact_Provisioning__c> lstconpro = new list<IAM_Contact_Provisioning__c>();
         IAM_Contact_Provisioning__c conApp = new IAM_Contact_Provisioning__c();
        conApp.IAM_Application_Name__c = app.IAM_Application_Name__c;
        conApp.IAM_Role__c = 'OSM Sales Admin';
        //conApp.IAM_Start_Date__c = system.now();
        conApp.IAM_Status__c = 'Active';
        conApp.IAM_Contact__c = con2.id; 
        conApp.IAM_Account_Application__c = app.id;
        conApp.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get('Marketplace').getRecordTypeId();
        lstconpro.add(conapp);
        insert lstconpro;
        IAM_Assign_Application_Permissionset.AssignApplication(lstconpro);
        } catch(Exception e) {
            System.debug('#### Exception - ' + e.getMessage());
        }
        Test.stopTest();
    }
	static testMethod void testMethodOSMRole2(){
        Test.starttest();
        try {
         IAM_PermissionSet_Assignment__c cst = new IAM_PermissionSet_Assignment__c();
        cst.Name='OSM Storefront Admin';
        cst.IAM_Permission_Set_Name__c ='OSM_Storefront_Admin';
        insert cst;
        List<Account> accList = new List<Account>();
        Account acc1 = new Account();
        acc1.Name = 'TestAccount1';
        acc1.Type = 'Fleet';
        acc1.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName()
                  .get(System.Label.IAM_WWSPS).getRecordTypeId();
        accList.add(acc1);
        
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.IAM_Service_Provider_Code__c = '123';
        acc.Type = 'Dealer Account';
        acc.CSS_DistributorCode__c = '123445';
        acc.CSS_DBCode__c = '12345';
        acc.CSS_DealerCode__c = '45623';
        accList.add(acc);
        insert accList;
        
        Contact con2 = new contact();
        con2.lastName = 'Tes';
        con2.AccountId = acc.id;
        con2.firstName = 'fis';
        con2.Email = 'testContact1@test.com';
        con2.IAM_Contact_Status__c = 'Active';
        con2.CMI_Contact_Type__c = 'Secondary';
        con2.phone = '8989898989';
        Con2.Username__c = 'test_user_helper8@eidm.com';
        con2.IAM_Contact_Status__c ='Active';
        insert con2;
        List<profile> pf = [select Id,Name from Profile WHERE Name ='IAM_Site_Admin_Community'limit 1];
       User newUser = new User();
        newUser.FirstName = con2.FirstName;
        newUser.LastName = con2.LastName;
        newUser.Email = con2.Email;   
        newUser.CompanyName = acc.Name;        
        newUser.CommunityNickname = 'tts';
        newUser.Username = con2.Username__c ;
        newUser.Alias = 'tts';
        newUser.TimeZoneSidKey = 'GMT';
        newUser.LocaleSidKey= 'en_US';
        newUser.EmailEncodingKey = 'UTF-8';
        newUser.LanguageLocaleKey = 'en_US';         
        newUser.ProfileId = pf[0].Id ;                                  
        newUser.ContactId = con2.Id;                   
        newUser.isActive = true;
        newUser.Street = '123 Test St';
        //newUser.FederationIdentifier = Con2.Username__c;
        insert newUser;
    
        //User us3 = [select ProfileId,LastName,Email,Username,CompanyName from user where ContactId =: con2.id];
        IAM_Application__c app = new IAM_Application__c();
        app.IAM_Application_Name__c = 'Marketplace';
        app.IAM_Role__c = 'OSM Storefront Admin';
        app.IAM_Status__c = 'Active';
        app.IAM_Account_Name__c = acc.id;
        app.IAM_Subscription_Name__c = 'test';
        app.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get('Marketplace').getRecordTypeId();
        insert app;
        list<IAM_Contact_Provisioning__c> lstconpro = new list<IAM_Contact_Provisioning__c>();
         IAM_Contact_Provisioning__c conApp = new IAM_Contact_Provisioning__c();
        conApp.IAM_Application_Name__c = app.IAM_Application_Name__c;
        conApp.IAM_Role__c = 'OSM Storefront Admin';
        //conApp.IAM_Start_Date__c = system.now();
        conApp.IAM_Status__c = 'Active';
        conApp.IAM_Contact__c = con2.id; 
        conApp.IAM_Account_Application__c = app.id;
        conApp.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get('Marketplace').getRecordTypeId();
        lstconpro.add(conapp);
      
        insert lstconpro;

        IAM_Assign_Application_Permissionset.AssignApplication(lstconpro);
        } catch(Exception e) {
            System.debug('#### Exception - '+e.getMessage());
        }
        Test.stopTest();
    }

    static testMethod void testMethodOSMRole3(){
        Test.startTest();
        try {
        IAM_PermissionSet_Assignment__c cst = new IAM_PermissionSet_Assignment__c();
        cst.Name='OSM Storefront Admin';
        cst.IAM_Permission_Set_Name__c ='OSM_Storefront_Admin';
        insert cst;
        List<Account> accList = new List<Account>();
        Account acc1 = new Account();
        acc1.Name = 'TestAccount1';
        acc1.Type = 'Fleet';
        acc1.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName()
                  .get(System.Label.IAM_WWSPS).getRecordTypeId();
        accList.add(acc1);
        
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.IAM_Service_Provider_Code__c = '123';
        acc.Type = 'Dealer Account';
        acc.CSS_DistributorCode__c = '123445';
        acc.CSS_DBCode__c = '12345';
        acc.CSS_DealerCode__c = '45623';
        accList.add(acc);
        insert accList;
        
        Contact con2 = new contact();
        con2.lastName = 'Tes';
        con2.AccountId = acc.id;
        con2.firstName = 'fis';
        con2.Email = 'testContact1@test.com';
        con2.IAM_Contact_Status__c = 'Active';
        con2.CMI_Contact_Type__c = 'Secondary';
        con2.phone = '8989898989';
        Con2.Username__c = 'test_user_helper8@eidm.com';
        con2.IAM_Contact_Status__c ='Active';
        //con2.IAM_Internal__c =true;
        //con2.IAM_Legacy_User__c =true;
        insert con2;
        List<profile> pf = [select Id,Name from Profile WHERE Name ='IAM_Site_Admin_Community'limit 1];
       User newUser = new User();
        newUser.FirstName = con2.FirstName;
        newUser.LastName = con2.LastName;
        newUser.Email = con2.Email;   
        newUser.CompanyName = acc.Name;        
        newUser.CommunityNickname = 'tts';
        newUser.Username = con2.Username__c ;
        newUser.Alias = 'tts';
        newUser.TimeZoneSidKey = 'GMT';
        newUser.LocaleSidKey= 'en_US';
        newUser.EmailEncodingKey = 'UTF-8';
        newUser.LanguageLocaleKey = 'en_US';         
        newUser.ProfileId = pf[0].Id ;                                  
        newUser.ContactId = con2.Id;                   
        newUser.isActive = true;
        newUser.Street = '123 Test St';
        //newUser.FederationIdentifier = Con2.Username__c;
        insert newUser;
    
        //User us3 = [select ProfileId,LastName,Email,Username,CompanyName from user where ContactId =: con2.id];
        IAM_Application__c app = new IAM_Application__c();
        app.IAM_Application_Name__c = 'Marketplace';
        app.IAM_Role__c = 'OSM Storefront Admin';
        app.IAM_Status__c = 'Active';
        app.IAM_Account_Name__c = acc.id;
        app.IAM_Subscription_Name__c = 'test';
        app.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get('Marketplace').getRecordTypeId();
        insert app;
        list<IAM_Contact_Provisioning__c> lstconpro = new list<IAM_Contact_Provisioning__c>();
         IAM_Contact_Provisioning__c conApp = new IAM_Contact_Provisioning__c();
        conApp.IAM_Application_Name__c = app.IAM_Application_Name__c;
        conApp.IAM_Role__c = 'OSM Storefront Admin';
        //conApp.IAM_Start_Date__c = system.now();
        conApp.IAM_Status__c = 'Inactive';
        conApp.IAM_Contact__c = con2.id; 
        conApp.IAM_Account_Application__c = app.id;
        conApp.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get('Marketplace').getRecordTypeId();
        lstconpro.add(conapp);
      
        insert lstconpro;

        IAM_Assign_Application_Permissionset.AssignApplication(lstconpro);
        } catch(Exception e) {
            System.debug('#### Exception - '+e.getMessage());
        }
        Test.stopTest();
    }

    static testMethod void testFailureCase() {
        Test.startTest();
            try {
                Account acc = IAM_TestData.createAccount();
                Contact con = IAM_TestData.createContact(acc.Id);
                IAM_Assign_Application_Permissionset.AssignPermissionSetToUsers(null, null, null);
                List<Contact> conList = [SELECT Id FROM Contact WHERE Id = :con.Id];
                Boolean conExist = IAM_Assign_Application_Permissionset.checkIfContactExist(conList[0].Id);
                Boolean conNotExist = IAM_Assign_Application_Permissionset.checkIfContactExist(null);
            } catch(Exception e) {
                System.debug(e.getMessage());
            }
        Test.stopTest();
    }

    static testMethod void testFailureCase2() {
        Test.startTest();
            try {
                IAM_RC_UserGroupMapping_Reclaim.checkAccess();
                IAM_LDAP_Util_group_GuidazMobile.invokeapexcallout_GM(new List<IAM_Contact_Provisioning__c>());
            } catch(Exception e) {
                System.debug(e.getMessage());
            }
        Test.stopTest();
    }

}