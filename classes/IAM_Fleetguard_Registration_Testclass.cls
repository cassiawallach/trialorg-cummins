/*********************************************************************************

Author       :   Sandeep Vuyyuru

Created Date :   22nd May,2019

Description  :   Unit test class for  IAM_Fleetguard_Registration.

*********************************************************************************/

@isTest
public class IAM_Fleetguard_Registration_Testclass{
    
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
        conNew.Email= 'test#test@test.com'; 
        conNew.FirstName = 'test';
        conNew.LastName = 'test';  
        conNew.IAM_Cummins_login_ID__c = 'test#test@test.com'; 
        //insert conNew;
        
        List<profile> pf = [select Id,Name from Profile WHERE Name = 'IAM_FleetguardUser' limit 1];
        
        //User Creation
        User newUser = new User();
        
        newUser.FirstName = 'UserFirstName';
        newUser.LastName = 'test';
        newUser.Email = 'test@test.com';   
        newUser.CompanyName = 'IT Test Company';        
        newUser.CommunityNickname = 'test@eet';
        newUser.Username = conNew.IAM_Cummins_login_ID__c;
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
        
         IAM_Application__c app = new IAM_Application__c();
        app.IAM_Application_Name__c = 'Fleetguard FIT';
        app.IAM_Role__c = 'CSS_DN_ADMIN';
        app.IAM_Status__c = 'Active';
        app.IAM_Account_Name__c = accRecord.id;
        app.IAM_Subscription_Name__c = 'test';
        insert app;
          
        
       CSS_Integration_Details__c csID = new CSS_Integration_Details__c();
        csID.NAme='IAM_LDAP_oAuth';
        csID.ApplicationName__c ='IAM_LDAP_oAuth';
        csID.End_Point__c = 'https://services-stg-oauth.cummins.com/api/oauth/token/ldaputil';
        csId.IsActive__c = true;
        csID.Key__c='qNE0R9+FsVQwxkSYGAIKV0T89M1s2v6NOQHO+FrgABMtIkrvv4a4NijFe6FoTPfRa0Q66bOYzeQsOy9PeniAkQ==';
        csID.Passcode__c = 'AlLKvzp6S8+/CeALWrLP7fT6bs3jeT97NSOyVKQy0ijq0+W2IL6bqFaqnArFH1K9jlbSoNGmAZ7VuvbPa4uyhA==';
        csId.Username__c = '5ySfIP0NSyTbggi9mOVjS4sIlf8/90+8LcDAuNiQqnA=';
        csId.Logging__c ='LDAPUtil';
        csId.AuthEnv__c = 'OAGoAuth';
        csId.Method_Type__c = 'POST';
        csId.grant_type__c = 'client_credentials';
        insert csID;
        
        
       
    }
    static testMethod void test1(){
        IAMUserCreationRequestWrapper wraprecord = new IAMUserCreationRequestWrapper();
        IAMUserCreationRequestWrapper.cls_UserInformation  wrap= new IAMUserCreationRequestWrapper.cls_UserInformation();
        
        wrap.FirstName = 'test';   
        wrap.LastName = 'test';
        wrap.Email = 'testtestuser@testuser.com';   
        wrap.CompanyName = 'IT Test Company1 test1';       
        wrap.CommunityNickname = 'test i'+Math.Random();
        wrap.Alias = 'test';
        wrap.TimeZoneSidKey = 'GMT';
        wrap.LocaleSidKey= 'en_US';
        wrap.EmailEncodingKey = 'UTF-8';
        wrap.LanguageLocaleKey = 'en_US';         
        wrap.Street = '123 Test St';
        //wrap.State = 'Florida';
        //wrap.Country = 'United States';
        wrap.FederationIdentifier = '';
        
        List<IAMUserCreationRequestWrapper.cls_UserInformation > wraprecordLst =new list<IAMUserCreationRequestWrapper.cls_UserInformation >();
        wraprecordLst.add(wrap);
        wraprecord.UserInformation =wraprecordLst;
        String JsonMsg=JSON.serialize(wraprecord );
        Test.startTest();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/IAM_Fleetguard_Registration';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
        IAM_Fleetguard_Registration.doPost();
       
        Test.stopTest();
        
    }
    
    static testMethod void test2(){
      
       List<Account> acc = [select id,type,BillingState,BillingCountry,Name,BillingStreet,BillingPostalCode,BillingCity From account where name = 'IT Test Company' limit 1];
       IAM_Application__c iamApp = [Select id,Name FROM IAM_Application__c WHERE IAM_Account_Name__c =: acc[0].Id];
       
        IAMUserCreationRequestWrapper wraprecord = new IAMUserCreationRequestWrapper();
        IAMUserCreationRequestWrapper.cls_UserInformation  wrap= new IAMUserCreationRequestWrapper.cls_UserInformation();
        
        wrap.FirstName = 'test';   
        wrap.LastName = 'test';
        wrap.Email = 'testtestuser@testuser.com';   
        wrap.CompanyName = 'IT Test Company';        
        wrap.CommunityNickname = 'test i'+Math.Random();
        wrap.Alias = 'test';
        wrap.TimeZoneSidKey = 'GMT';
        wrap.LocaleSidKey= 'en_US';
        wrap.EmailEncodingKey = 'UTF-8';
        wrap.LanguageLocaleKey = 'en_US';         
        wrap.Street = '123 Test St';
        //wrap.State = 'Florida';
        //wrap.Country = 'United States';
        wrap.FederationIdentifier = '';
        
        List<IAMUserCreationRequestWrapper.cls_UserInformation > wraprecordLst =new list<IAMUserCreationRequestWrapper.cls_UserInformation >();
        wraprecordLst.add(wrap);
        wraprecord.UserInformation =wraprecordLst;
        String JsonMsg=JSON.serialize(wraprecord );
        Test.startTest();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/IAM_Fleetguard_Registration';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
        IAM_Fleetguard_Registration.doPost();
       
        Test.stopTest();
        
    }
}