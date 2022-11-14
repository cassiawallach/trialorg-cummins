@isTest
public class IAM_Assign_Application_PermissionsetTest{
    static testMethod void testMethod1(){
        
        Account acc1 = new Account();
        acc1.Name = 'TestAccount1';
        acc1.Type = 'Distributor Account';
        acc1.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName()
                  .get(System.Label.IAM_WWSPS).getRecordTypeId();
        insert acc1; 
        
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.IAM_Service_Provider_Code__c = '123';
        acc.Type = 'Dealer Account';
        acc.CSS_DistributorCode__c = '1234';
        acc.CSS_DBCode__c = '12345';
        acc.CSS_DealerCode__c = '456';
        insert acc;
        
        
        
        Contact con1 = new contact();
        con1.lastName = 'Te';
        con1.AccountId = acc1.id;
        con1.firstName = 'fi';
        con1.Email = 'testContact1@test.com';
        con1.IAM_Contact_Status__c = 'Active';
        con1.CMI_Contact_Type__c = 'Secondary';
        con1.phone = '8989898989';
        Con1.Username__c = 'test_user_helper7@eidm.com';
        insert con1;
        
    
        
        Contact con3 = new contact();
        con3.lastName = 'Test1';
        con3.AccountId = acc1.id;
        con3.firstName = 'fist1';
        con3.Email = 'testContact1@test.com';
        con3.IAM_Contact_Status__c = 'Active';
        con3.CMI_Contact_Type__c = 'Secondary';
        con3.phone = '8989898989';
        Con3.Username__c = 'test_user_helper9@eidm.com';
        insert con3;
        
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
    
         //User us2 = [select ProfileId,LastName,Email,Username,CompanyName from user where ContactId =: con1.id];
          //User us4 = [select ProfileId,LastName,Email,Username,CompanyName from user where ContactId =: con3.id];

        Id ProfId = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community'].Id;
        
        
        
        IAM_Application__c app1 = new IAM_Application__c();
        app1.IAM_Application_Name__c = 'Guidanz';
        app1.IAM_Role__c = 'Advanced';
        app1.IAM_Status__c = 'Active';
        app1.IAM_Account_Name__c = acc.id;
        app1.IAM_Subscription_Name__c = 'test';
        app1.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        insert app1;
        
            
        IAM_Contact_Provisioning__c conApp1 = new IAM_Contact_Provisioning__c();
        conApp1.IAM_Application_Name__c = app1.IAM_Application_Name__c;
        conApp1.IAM_Role__c = 'Advanced';
        //conApp1.IAM_Start_Date__c = system.now();
        conApp1.IAM_Status__c = 'Active';
        conApp1.IAM_Contact__c = con1.id; 
        conApp1.IAM_Account_Application__c = app1.id;
        conApp1.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        insert conApp1;
        
        
        
        
        
        /*IAM_Application__c app5 = new IAM_Application__c();
        app5.IAM_Application_Name__c = 'Product Connectivity';
        app5.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Product Connectivity').getRecordTypeId();
        app5.IAM_Role__c = 'CSS_DN_ADMIN';
        app5.IAM_Status__c = 'Active';
        app5.IAM_Account_Name__c = acc.id;
        app5.IAM_Subscription_Name__c = 'test';    
        insert app5;
        
        IAM_Contact_Provisioning__c conApp5 = new IAM_Contact_Provisioning__c();
        conApp5.IAM_Application_Name__c = 'Product Connectivity';
        conApp5.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Product Connectivity').getRecordTypeId();
        conApp5.IAM_Role__c = 'Primary Contact';
        //conApp.IAM_Start_Date__c = system.now();
        conApp5.IAM_Status__c = 'Active';
        conApp5.IAM_Contact__c = con1.id; 
        conApp5.IAM_User__c = us2.id;
        conApp5.IAM_Account_Application__c = app5.id;
        insert conApp5;*/
        
        IAM_Application__c app6 = new IAM_Application__c();
        app6.IAM_Application_Name__c = 'Repair logistics and Service';
        app6.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Repair logistics and Service').getRecordTypeId();
        app6.IAM_Role__c = 'RLS Admin';
        app6.IAM_Status__c = 'Active';
        app6.IAM_Account_Name__c = acc.id;
        app6.IAM_Subscription_Name__c = 'test';    
        insert app6;
        
        IAM_Contact_Provisioning__c conApp6 = new IAM_Contact_Provisioning__c();
        conApp6.IAM_Application_Name__c = 'Repair logistics and Service';
        conApp6.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Repair logistics and Service').getRecordTypeId();
        conApp6.IAM_Role__c = 'RLS Admin';
        //conApp.IAM_Start_Date__c = system.now();
        conApp6.IAM_Status__c = 'Inactive';
        conApp6.IAM_Contact__c = con1.id; 
        conApp6.IAM_User__c = us2.id;
        conApp6.IAM_Account_Application__c = app6.id;
        insert conApp6;

        List<IAM_Contact_Provisioning__c> lstContProv = new List<IAM_Contact_Provisioning__c>();
        //lstContProv.add(conApp);
        
        //lstContProv.add(conApp4);
        //lstContProv.add(conApp5);
        lstContProv.add(conApp6);
        //lstContProv.add(conApp7);
        //lstContProv.add(conApp8);
        
        Set<Id> setUserIds = new Set<Id>();
        setUserIds.add(us2.Id);
        Set<Id> setContProvIds = new Set<Id>();
        //setContProvIds.add(conApp.id);
        
        //setContProvIds.add(conApp4.id);
        //setContProvIds.add(conApp5.id);
        setContProvIds.add(conApp6.id);
        //setContProvIds.add(conApp7.id);
        //setContProvIds.add(conApp8.id);
        
        User usr = [Select id,IAM_Final_Approver__c from User where Id = :UserInfo.getUserId()];
        PermissionSet perSet=[SELECT Id,Label,Name,NamespacePrefix,ProfileId FROM PermissionSet where Label=:System.Label.IAM_Application_Name_Archer];
        System.RunAs(us2){
            Test.startTest();
                
                IAM_Assign_Application_Permissionset.AssignApplication(lstContProv);
               /* PermissionSet perSet = new PermissionSet();
                perSet.name = System.Label.IAM_Application_Name_Archer;
                perSet.Label = System.Label.IAM_Application_Name_Archer;
                insert perSet;*/
                IAM_Assign_Application_Permissionset.AssignPermissionSetToUsers(setUserIds, perSet.id, 'Insert');
                IAM_Assign_Application_Permissionset.AssignPermissionSetToUsers(setUserIds, perSet.id, 'Delete');
                //IAM_Assign_Application_Permissionset.APPgroups(lstContProv);
                //IAM_Assign_Application_Permissionset.updateUserAppAttributes(setContProvIds);
            Test.stopTest();
        }
    }   
        
   /* static testMethod void testMethod2(){
        Account acc1 = new Account();
        acc1.Name = 'TestAccount1';
        acc1.Type = 'Distributor Account';
        acc1.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName()
                  .get(System.Label.IAM_WWSPS).getRecordTypeId();
        insert acc1;
        
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.IAM_Service_Provider_Code__c = '123';
        acc.Type = 'Dealer Account';
        acc.CSS_DistributorCode__c = '1234';
        acc.CSS_DBCode__c = '12345';
        acc.CSS_DealerCode__c = '456';
        insert acc;
        
        Contact con = new contact();
        con.lastName = 'Test';
        con.AccountId = acc.id;
        con.firstName = 'contact';
        con.Email = 'testContact@test.com.mytest';
        con.IAM_Contact_Status__c = 'Active';
        con.CMI_Contact_Type__c = 'Primary';
        con.phone = '8989898989';
        Con.Username__c = 'test_user_helper6@eidm.com';
        insert con;
        
        User us1 = [select ProfileId,LastName,Email,Username,CompanyName from user where ContactId =: con.id];
        Id ProfId = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community'].Id;
        
        IAM_Application__c app = new IAM_Application__c();
        app.IAM_Application_Name__c = 'Marketplace';
        app.IAM_Role__c = 'OSM Fleet Admin';
        app.IAM_Status__c = 'Active';
        app.IAM_Account_Name__c = acc.id;
        app.IAM_Subscription_Name__c = 'test';
        app.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get('Marketplace').getRecordTypeId();
        insert app;
        
        
        IAM_Contact_Provisioning__c conApp = new IAM_Contact_Provisioning__c();
        conApp.IAM_Application_Name__c = app.IAM_Application_Name__c;
        conApp.IAM_Role__c = 'OSM Fleet Admin';
        //conApp.IAM_Start_Date__c = system.now();
        conApp.IAM_Status__c = 'Active';
        conApp.IAM_Contact__c = con.id; 
        conApp.IAM_Account_Application__c = app.id;
        conApp.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get('Marketplace').getRecordTypeId();
        insert conApp;
        
        
        List<IAM_Contact_Provisioning__c> lstContProv = new List<IAM_Contact_Provisioning__c>();
        lstContProv.add(conApp);
        
        Set<Id> setUserIds = new Set<Id>();
        setUserIds.add(us1.Id);
        Set<Id> setContProvIds = new Set<Id>();
        setContProvIds.add(conApp.id);
        User usr = [Select id,IAM_Final_Approver__c from User where Id = :UserInfo.getUserId()];
        PermissionSet perSet=[SELECT Id,Label,Name,NamespacePrefix,ProfileId FROM PermissionSet where Label=:System.Label.IAM_Application_Name_Archer];
        System.RunAs(usr){
            Test.startTest();
                
                IAM_Assign_Application_Permissionset.AssignApplication(lstContProv);
                /*PermissionSet perSet = new PermissionSet();
                perSet.name = System.Label.IAM_Application_Name_Archer;
                perSet.Label = System.Label.IAM_Application_Name_Archer;
                insert perSet;*/
                /*IAM_Assign_Application_Permissionset.AssignPermissionSetToUsers(setUserIds, perSet.id, 'Insert');
                IAM_Assign_Application_Permissionset.AssignPermissionSetToUsers(setUserIds, perSet.id, 'Delete');
                IAM_Assign_Application_Permissionset.APPgroups(lstContProv);
                IAM_Assign_Application_Permissionset.updateUserAppAttributes(setContProvIds);
            Test.stopTest();
        }
    }*/
    
    static testMethod void testMethod3(){
       
        
        Account acc1 = new Account();
        acc1.Name = 'TestAccount1';
        acc1.Type = 'Distributor Account';
        acc1.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName()
                  .get(System.Label.IAM_WWSPS).getRecordTypeId();
        insert acc1;
        
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.IAM_Service_Provider_Code__c = '123';
        acc.Type = 'Dealer Account';
        acc.CSS_DistributorCode__c = '1234';
        acc.CSS_DBCode__c = '12345';
        acc.CSS_DealerCode__c = '456';
        insert acc;
        
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
        //Id ProfId = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community'].Id;
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
        //User us3 = [select ProfileId,LastName,Email,Username,CompanyName from user where ContactId =: con2.id];
        
        //Id ProfId = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community'].Id;
        
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
        System.RunAs(usr){
            Test.startTest();
                
                IAM_Assign_Application_Permissionset.AssignApplication(lstContProv);
                /*PermissionSet perSet = new PermissionSet();
                perSet.name = System.Label.IAM_Application_Name_Archer;
                perSet.Label = System.Label.IAM_Application_Name_Archer;
                insert perSet;*/
                IAM_Assign_Application_Permissionset.AssignPermissionSetToUsers(setUserIds, perSet.id, 'Insert');
                IAM_Assign_Application_Permissionset.AssignPermissionSetToUsers(setUserIds, perSet.id, 'Delete');
                //IAM_Assign_Application_Permissionset.APPgroups(lstContProv);
                //IAM_Assign_Application_Permissionset.updateUserAppAttributes(setContProvIds);
            Test.stopTest();
        }
    }
    static testMethod void testMethodOSMRole(){
         IAM_PermissionSet_Assignment__c cst = new IAM_PermissionSet_Assignment__c();
        cst.Name='Distributor Admin';
        cst.IAM_Permission_Set_Name__c ='OSM_Distributor_Admin';
        insert cst;
        Account acc1 = new Account();
        acc1.Name = 'TestAccount1';
        acc1.Type = 'Distributor Account';
        acc1.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName()
                  .get(System.Label.IAM_WWSPS).getRecordTypeId();
        insert acc1;
        
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.IAM_Service_Provider_Code__c = '123';
        acc.Type = 'Dealer Account';
        acc.CSS_DistributorCode__c = '1234';
        acc.CSS_DBCode__c = '12345';
        acc.CSS_DealerCode__c = '456';
        insert acc;
        
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

    }
    static testMethod void testMethodOSMRole1(){
         IAM_PermissionSet_Assignment__c cst = new IAM_PermissionSet_Assignment__c();
        cst.Name='OSM Sales Admin';
        cst.IAM_Permission_Set_Name__c ='OSM_Sales_Admin';
        insert cst;
        Account acc1 = new Account();
        acc1.Name = 'TestAccount1';
        acc1.Type = 'Distributor Account';
        acc1.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName()
                  .get(System.Label.IAM_WWSPS).getRecordTypeId();
        insert acc1;
        
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.IAM_Service_Provider_Code__c = '123';
        acc.Type = 'Dealer Account';
        acc.CSS_DistributorCode__c = '1234';
        acc.CSS_DBCode__c = '12345';
        acc.CSS_DealerCode__c = '456';
        insert acc;
        
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

    }
	static testMethod void testMethodOSMRole2(){
         IAM_PermissionSet_Assignment__c cst = new IAM_PermissionSet_Assignment__c();
        cst.Name='OSM Storefront Admin';
        cst.IAM_Permission_Set_Name__c ='OSM_Storefront_Admin';
        insert cst;
        Account acc1 = new Account();
        acc1.Name = 'TestAccount1';
        acc1.Type = 'Fleet';
        acc1.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName()
                  .get(System.Label.IAM_WWSPS).getRecordTypeId();
        insert acc1;
        
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.IAM_Service_Provider_Code__c = '123';
        acc.Type = 'Dealer Account';
        acc.CSS_DistributorCode__c = '123445';
        acc.CSS_DBCode__c = '12345';
        acc.CSS_DealerCode__c = '45623';
        insert acc;
        
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
        conApp.IAM_Status__c = 'Active';
        conApp.IAM_Contact__c = con2.id; 
        conApp.IAM_Account_Application__c = app.id;
        conApp.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get('Marketplace').getRecordTypeId();
        lstconpro.add(conapp);
      
        insert lstconpro;

        IAM_Assign_Application_Permissionset.AssignApplication(lstconpro);

    }

}