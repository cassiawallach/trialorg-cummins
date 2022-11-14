/*********************************************************************************
Author       :   Sushma Rajput
Created Date :   11th June,2019
Description  :   Unit test class for  IAM_CST_Contact_Updates   .
*********************************************************************************/

@isTest
public class IAM_CST_Contact_Updates_Test{


public Static void createTestData(){
      Account accRecord = new Account();
        accRecord.Name = 'Test Company';
        accRecord.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();  
        accRecord.phone = '6884382997';
        insert accRecord ;
        
        //Contact
        Contact conNew = new Contact();
        conNew.accountID = accRecord.id;
        conNew.RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId(); 
        conNew.Email= 'test59@test.com'; 
        conNew.FirstName = 'test';
        conNew.LastName = 'test';  
        conNew.Username__c =  'test59@test.com'; 
        conNew.IAM_Contact_Status__c = 'Active';
        insert conNew;
        
         List<profile> pf = [select Id,Name from Profile WHERE Name = 'IAM_FleetguardUser' limit 1];
        
         User newUser = new User();
     
                    newUser.FirstName = 'UserFirstName';
                    newUser.LastName = 'test';
                    newUser.Email = 'test@test.com';   
                    newUser.CompanyName = 'IT Test Company';        
                    newUser.CommunityNickname = 'test';
                    newUser.Username = 'Sandeep@test.com' ;
                    newUser.Alias = 'test';
                    newUser.TimeZoneSidKey = 'GMT';
                    newUser.LocaleSidKey= 'en_US';
                    newUser.EmailEncodingKey = 'UTF-8';
                    newUser.LanguageLocaleKey = 'en_US';         
                    newUser.ProfileId = pf[0].Id ;                                  
                    newUser.ContactId =conNew.Id;                   
                    newUser.isActive = TRUE;
                    newUser.Street = '123 Test St';
                    newUser.FederationIdentifier = '2468741';
                    
        //insert newUser;
        
        //custom setting
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
        
        //QSOL
       IAM_Application__c app = new IAM_Application__c();
        app.IAM_Application_Name__c = 'QuickServe Online';
        app.IAM_Role__c = 'QSOL Fleet';
        app.IAM_Status__c = 'Active';
        app.IAM_Account_Name__c = accRecord.id;
        app.IAM_Subscription_Name__c = 'QuickServe Online EBU';
        app.IAM_qsolexpiration__c='12345';
        app.RecordTypeId=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
        insert app;
        
        //CST
        IAM_Application__c appCST = new IAM_Application__c();
        appCST.IAM_Application_Name__c = 'Cummins Service Training';
        appCST.IAM_Role__c = 'Service Training User';
        appCST.IAM_Status__c = 'Active';
        appCST.IAM_Account_Name__c = accRecord.id;
        appCST.IAM_Subscription_Name__c = 'QuickServe Online EBU';
        //app.IAM_qsolexpiration__c='12345';
        appCST.RecordTypeId=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Cummins Service Training').getRecordTypeId();
        insert appCST;
        
        
         IAM_Contact_Provisioning__c conAppQSOL = new IAM_Contact_Provisioning__c();
        conAppQSOL.RecordTypeId=Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId(); 
        conAppQSOL.IAM_Role__c = 'QSOL Fleet';  
        conAppQSOL.IAM_Status__c = 'Active';
        conAppQSOL.IAM_Contact__c = conNew.id; 
        conAppQSOL.IAM_Account_Application__c = app.id;
        conAppQSOL.IAM_Application_Name__c='QuickServe Online';
        conAppQSOL.IAM_qsolexpiration__c='12344';
        conAPPQSOL.IAM_Subscription_Name__c='QuickServe Online EBU';
        insert conAppQSOL;
        

    //IAM Contact Provisioning        
        IAM_Contact_Provisioning__c conApp = new IAM_Contact_Provisioning__c();
        conApp.RecordTypeId=Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Cummins Service Training').getRecordTypeId(); 
        conApp.IAM_Role__c = 'Service Training User'; 
        conApp.IAM_Status__c = 'Active';
        conApp.IAM_Contact__c = conNew.id; 
        conApp.IAM_Account_Application__c = appCST.id;
        conApp.IAM_Application_Name__c='Cummins Service Training';
        conAPP.IAM_Subscription_Name__c='QuickServe Online EBU';
        insert conApp;
    
    }
        static testMethod void testMethodOne()
        {
               
        createTestData();
       
        List<Contact> con = [Select id,phone,Username__c,firstName,LastName,email,IAM_Ext_Legacy_Uid__c,Account.IAM_Service_Provider_Code__c,IAM_Contact_Status__c from Contact where IAM_Contact_Status__c='Active'];
        User u = [Select id,Name FROM User WHERE Contactid =: con[0].Id];
        List<IAM_Contact_Provisioning__c>  UserAccessFea = [select id,IAM_Application_Name__c,IAM_Role__c,IAM_Status__c from IAM_Contact_Provisioning__c where IAM_Contact__c=:con[0].id and IAM_Status__c='Active' and IAM_Application_Name__c='Cummins Service Training'];
        
        Set<Id> contactIds = new Set<Id>();
        Map<id,String> oldUsername = new Map<id,String>();
        Map<id,String> newUsername = new Map<id,String>();
        
        contactIds.add(con[0].Id); 
        oldUsername.put(con[0].id,'test@testold.com');
        newUsername.put(con[0].Id, 'test@testnew.com');
       
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, new IAM_CSTUserOutboundHelperMock());
         
         IAM_CST_Contact_Updates.callCSTUpdate(contactIds, oldUsername , newUsername);
         
         //IAM_CSTUserOutboundHelper_Reclaim.CstOutboundCall('Sushma','Rajput', 'test.testone@cummins.com', '7456382902', 'test','test','test','tests' );      
         }        
        
    }