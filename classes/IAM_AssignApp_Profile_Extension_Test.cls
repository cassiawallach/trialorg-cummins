/************************************************************
Name:  IAM_AssignApplication_Profile_Extension
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test class for IAM_AssignApplication_Profile_Extension class.
//below class is mainly used as a invokable class fron process builder in order to assaign and delete permission sets from users.
//this class will have two functions which gets invoked on insertion and update on the application status                           
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE              DETAIL                                
1.0 -    Nishant Verma             02/10/2020        Fluidwatch Changes for site admin page -INITIAL DEVELOPMENT
1.3 -    Karthik Raj Golakaram     01/25/2021        Making Changes for OSM High Prod issue - INC1022619
1.4 -    SureshRathod Nanavath     03/16/2022        Added comment to push to prod
*****************************************************/
/********************************************************************************
***********************************************************************************/ 
@isTest
public class IAM_AssignApp_Profile_Extension_Test{
     static testMethod void testMethodOSMRole(){
          Map<Id,String> roleUrsIdsMap = new Map<Id,String>();
            Map<String,Id> rolepsIdSMap=new Map<String,Id>();
         map<string,string> mapofConIdOsmRoles =  new map<string,string>();
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
          PermissionSet PS =[SELECT Id,Label,Name,NamespacePrefix,ProfileId FROM PermissionSet where Name ='OSM_Distributor_Admin'];
         roleUrsIdsMap.put(newUser.id,'Distributor Admin');
         rolepsIdSMap.put('Distributor Admin',ps.id);
         mapofConIdOsmRoles.put(newUser.FederationIdentifier,'Distributor Admin');
        System.enqueueJob(new IAM_AssignApplication_Profile_Extension(mapofConIdOsmRoles,roleUrsIdsMap,rolepsIdSMap,'Insert'));

    }
         static testMethod void testMethodOSMRole2(){
          Map<Id,String> roleUrsIdsMap = new Map<Id,String>();
            Map<String,Id> rolepsIdSMap=new Map<String,Id>();
         map<string,string> mapofConIdOsmRoles =  new map<string,string>();
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
          PermissionSet PS =[SELECT Id,Label,Name,NamespacePrefix,ProfileId FROM PermissionSet where Name ='OSM_Distributor_Admin'];
         roleUrsIdsMap.put(newUser.id,'OSM Sales Admin');
         rolepsIdSMap.put('OSM Sales Admin',ps.id);
         mapofConIdOsmRoles.put(newUser.FederationIdentifier,'OSM Sales Admin');
        System.enqueueJob(new IAM_AssignApplication_Profile_Extension(mapofConIdOsmRoles,roleUrsIdsMap,rolepsIdSMap,'Insert'));

    }
           static testMethod void testMethodOSMRole3(){
          Map<Id,String> roleUrsIdsMap = new Map<Id,String>();
            Map<String,Id> rolepsIdSMap=new Map<String,Id>();
         map<string,string> mapofConIdOsmRoles =  new map<string,string>();
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
    
        IAM_Application__c app = new IAM_Application__c();
        app.IAM_Application_Name__c = 'Marketplace';
        app.IAM_Role__c = 'OSM Support Admin';
        app.IAM_Status__c = 'Active';
        app.IAM_Account_Name__c = acc.id;
        app.IAM_Subscription_Name__c = 'test';
        app.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get('Marketplace').getRecordTypeId();
        insert app;
        list<IAM_Contact_Provisioning__c> lstconpro = new list<IAM_Contact_Provisioning__c>();
         IAM_Contact_Provisioning__c conApp = new IAM_Contact_Provisioning__c();
        conApp.IAM_Application_Name__c = app.IAM_Application_Name__c;
        conApp.IAM_Role__c = 'OSM Support Admin';
        //conApp.IAM_Start_Date__c = system.now();
        conApp.IAM_Status__c = 'Active';
        conApp.IAM_Contact__c = con2.id; 
        conApp.IAM_Account_Application__c = app.id;
        conApp.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get('Marketplace').getRecordTypeId();
        lstconpro.add(conapp);
        insert lstconpro;
          PermissionSet PS =[SELECT Id,Label,Name,NamespacePrefix,ProfileId FROM PermissionSet where Name ='OSM_Distributor_Admin'];
         roleUrsIdsMap.put(newUser.id,'OSM Support Admin');
         rolepsIdSMap.put('OSM Support Admin',ps.id);
         mapofConIdOsmRoles.put(newUser.FederationIdentifier,'OSM Support Admin');
        System.enqueueJob(new IAM_AssignApplication_Profile_Extension(mapofConIdOsmRoles,roleUrsIdsMap,rolepsIdSMap,'Insert'));

    }
           static testMethod void testMethodOSMRole4(){
          Map<Id,String> roleUrsIdsMap = new Map<Id,String>();
            Map<String,Id> rolepsIdSMap=new Map<String,Id>();
         map<string,string> mapofConIdOsmRoles =  new map<string,string>();
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
    
        IAM_Application__c app = new IAM_Application__c();
        app.IAM_Application_Name__c = 'Marketplace';
        app.IAM_Role__c = 'OSM Business Admin';
        app.IAM_Status__c = 'Active';
        app.IAM_Account_Name__c = acc.id;
        app.IAM_Subscription_Name__c = 'test';
        app.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get('Marketplace').getRecordTypeId();
        insert app;
        list<IAM_Contact_Provisioning__c> lstconpro = new list<IAM_Contact_Provisioning__c>();
         IAM_Contact_Provisioning__c conApp = new IAM_Contact_Provisioning__c();
        conApp.IAM_Application_Name__c = app.IAM_Application_Name__c;
        conApp.IAM_Role__c = 'OSM Business Admin';
        //conApp.IAM_Start_Date__c = system.now();
        conApp.IAM_Status__c = 'Active';
        conApp.IAM_Contact__c = con2.id; 
        conApp.IAM_Account_Application__c = app.id;
        conApp.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get('Marketplace').getRecordTypeId();
        lstconpro.add(conapp);
        insert lstconpro;
          PermissionSet PS =[SELECT Id,Label,Name,NamespacePrefix,ProfileId FROM PermissionSet where Name ='OSM_Distributor_Admin'];
         roleUrsIdsMap.put(newUser.id,'OSM Business Admin');
         rolepsIdSMap.put('OSM Business Admin',ps.id);
         mapofConIdOsmRoles.put(newUser.FederationIdentifier,'OSM Business Admin');
        System.enqueueJob(new IAM_AssignApplication_Profile_Extension(mapofConIdOsmRoles,roleUrsIdsMap,rolepsIdSMap,'Insert'));

    }
}