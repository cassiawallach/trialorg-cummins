/*********************************************************************************
Author       :   Nishant Verma  
Created Date :   4th sep,2019
Description  :   Unit test class for  IAM_RSW_Inbound.
*********************************************************************************/
@istest
public class IAM_RSW_Inbound_Test {
    
    @testSetup
    public static void createTestData(){
    
       Account accRecordPar = new Account();
       accRecordPar.Name='Cummins - United States';
       accRecordPar.Type = 'Internal';
       insert accRecordPar;
       
    
        Account accRecord = new Account();
        accRecord.Name = 'IT Test Company';
        accRecord.Parentid = accRecordPar.Id;
        accRecord.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();  
        accRecord.phone = '6884382997';
        accRecord.BillingCity='Columbus';
        accRecord.BillingStreet='340 Brown Street';
        accRecord.BillingCountry='United States';
        accRecord.BillingPostalCode='47201';
        accRecord.BillingState='Indiana';       
        insert accRecord ;
        
        //Contact
        Contact conNew = new Contact();
        conNew.accountID = accRecord.id;
        conNew.RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId(); 
        conNew.Email= 'test@test.com'; 
        conNew.FirstName = 'test';
        conNew.LastName = 'test';  
        conNew.Username__c = 'test@test.com'; 
        conNew.IAM_from_Registration__c=true;
        insert conNew;
        
        List<profile> pf = [select Id,Name from Profile WHERE Name = 'IAM_FleetguardUser' limit 1];
        
        //User Creation
        user newUser = new User();
        
        newUser.FirstName = 'UserFirstName';
        newUser.LastName = 'test';
        newUser.Email = 'test@test.com';   
        newUser.CompanyName = 'IT Test Company';        
        newUser.CommunityNickname = 'test12121';
        newUser.Username = 'sushma.rajput@test.com' ;
        newUser.Alias = 'test';
        newUser.TimeZoneSidKey = 'GMT';
        newUser.LocaleSidKey= 'en_US';
        newUser.EmailEncodingKey = 'UTF-8';
        newUser.LanguageLocaleKey = 'en_US';         
        newUser.ProfileId = pf[0].Id ;                                  
        newUser.ContactId =conNew.Id;                   
        newUser.isActive = True;
        newUser.Street = '123 Test St';
        newUser.FederationIdentifier = '2468741';
        //newUser.role='test';
        
        insert newUser;
        
        IAM_Application__c app = new IAM_Application__c();
        app.IAM_Application_Name__c = 'Rapid Serve Web';
        app.IAM_Role__c = 'CSS_DN_ADMIN';
        app.IAM_Status__c = 'Active';
        app.IAM_Account_Name__c = accRecord.id;
        app.IAM_Subscription_Name__c = 'test';
        insert app;
        
         //IAM Contact Provisioning        
        IAM_Contact_Provisioning__c conApp = new IAM_Contact_Provisioning__c();
        conApp.RecordTypeId=Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Rapid Serve Web').getRecordTypeId();
        conApp.IAM_Application_Name__c = 'Rapid Serve Web';
        conApp.IAM_Role__c ='distributor';        
        conApp.IAM_Status__c = 'pending';
        conApp.IAM_Contact__c = conNew.id; 
        conApp.IAM_Account_Application__c = app.id;
        insert conApp;
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

        
    }
    static testMethod void test1(){
        IAM_RSW_Inbound.rswIAMUserResponseDetails objURD = new IAM_RSW_Inbound.rswIAMUserResponseDetails();
        objURD.userID='test@test.com';
        objURD.roleID='BASIC';
        objURD.status='Active';
        objURD.userEmail='test@test.com';
        String JsonMsg=JSON.serialize(objURD );
        
        Test.startTest();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/rswstatus';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
        //IAM_RSW_Inbound.post(objURD);
       
        Test.stopTest();
        
    }
    static testMethod void test2(){
      
        IAM_RSW_Inbound.rswIAMUserResponseDetails objURD = new IAM_RSW_Inbound.rswIAMUserResponseDetails();
        objURD.userID='test@test.com';
        objURD.roleID='CUMMINS';
        objURD.status='Cancelled';
        objURD.userEmail='test12@test.com';
        String JsonMsg=JSON.serialize(objURD );
        Test.startTest();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/rswstatus';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
        IAM_RSW_Inbound.post(objURD);
       
        Test.stopTest();
        
    }
    static testMethod void test3(){
      
        IAM_RSW_Inbound.rswIAMUserResponseDetails objURD = new IAM_RSW_Inbound.rswIAMUserResponseDetails();
        objURD.userID='test@test.com';
        objURD.roleID='test';
        objURD.status='Cancelled';
        objURD.userEmail='test12@test.com';
        String JsonMsg=JSON.serialize(objURD );
        
        Test.startTest();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/rswstatus';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
        IAM_RSW_Inbound.post(objURD);
       
        Test.stopTest();
        
    }
   
}