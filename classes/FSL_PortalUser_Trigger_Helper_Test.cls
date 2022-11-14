/*
* Test Class for Apex Controller - FSL_PortalUser_Trigger_Helper
* Author - Rupesh Ranjan
* Vamsi - 02/24/2022 - To run test classes for IAM issue resolution
*/ 
@isTest
public class FSL_PortalUser_Trigger_Helper_Test{
     public static testmethod void orderControllerTestMethod(){
     
        Profile p = [SELECT Id FROM Profile WHERE Name='FSL_Guidanz_Customer_Community_User'];
        User u2 = [SELECT Id,ContactId,LanguageLocaleKey from User WHERE ProfileId =:p.Id AND IsActive=:TRUE LIMIT 1];
        
      /* Id profid = [SELECT Id FROM Profile WHERE Name = 'FSL_Guidanz_Customer_Community_User' LIMIT 1].Id;
      //create user
        List<User> users = new List<User>();
        users.add(new User(
            ProfileId = profid,
            LastName = 'testUser',
            Email = 'testUserRaghav@testEmail.com',
            Username = 'testUserRaghav@testEmail.com',
            CompanyName = 'testCompany',
            Title = 'testTitle',
            Alias = 'testUsr',
            ERP__C = 'BMS',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ////UserPermissionsKnowledgeUser = true,
            UserPermissionsInteractionUser = true,
            IsActive = true
            //UserPermissionsOfflineUser = true,
            //UserPermissionsSupportUser = true,
            //UserPermissionsMobileUser = true,
            //IAM_UID__c = 'testUserRaghav@testEmail.com',
           // FederationIdentifier = 'testUserRaghav@testEmail.com'
        ));
        Insert users; */
   
        Account acc = new Account();
        acc.Name = 'East Bronx1';
        acc.CMI_Account_Status__c = 'Active';
        acc.PaymentType__c = 'Cash';
        acc.FSL_ERP_Customer_Code__c = '48923';
        acc.FSL_Credit_Limit__c = 78888.5;
        insert acc;
        
         
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con=new Contact();
        con.RecordTypeId = conRecId;
        con.FirstName='Steve';
        con.LastName='Johnson';
        con.Phone='1234567890';
        con.Language_Preferences__c='English';
        con.AccountId=acc.id;
        insert con;
        user us=new user();
            us.ProfileId = p.id;
            us.LastName = 'testUser';
            us.Email = 'testUserRaghav@testEmail.com';
            us.Username = 'testUserRaghav@testEmail.com';
            us.CompanyName = 'testCompany';
            us.Title = 'testTitle';
            us.Alias = 'testUsr';
            us.ERP__C = 'BMS';
            us.IsActive = true;
            us.TimeZoneSidKey = 'America/Los_Angeles';
            us.EmailEncodingKey = 'UTF-8';
            us.LanguageLocaleKey = 'en_US';
            us.LocaleSidKey = 'en_US';
            us.ContactId=con.id;
            insert us;
        List<User> usrs =new List<User>();
        Map<Id, User> oldUserMap = new Map<Id, User>();
        //usrs.add(users);
         usrs.add(us);
         string langLocale ='en_US';
         string langLocale1 ='fr';
         test.starttest();
          FSL_PortalUser_Trigger_Helper.LangContactUpdate(oldUserMap, usrs);
          FSL_PortalUser_Trigger_Helper.updateContact(con.id,langLocale);
           FSL_PortalUser_Trigger_Helper.updateContact(con.id,langLocale1);
          test.stoptest();
     
     }

}