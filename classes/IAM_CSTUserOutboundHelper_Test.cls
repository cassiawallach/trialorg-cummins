/*********************************************************************************
Author       :   Sushma Rajput
Created Date :   12th September,2019
Description  :   Unit test class for  IAM_CSTUserStatusOutboundHelper.
*********************************************************************************/

@isTest
public class IAM_CSTUserOutboundHelper_Test{

  public static void createTestData(){
        Account accRecord = new Account();
        accRecord.Name = 'Send LDAP Test Company';
        accRecord.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();  
        accRecord.phone = '6884382997';          
        insert accRecord ;
        
        //Contact
        List<Contact> listConNew = new List<Contact>();
        Contact conNew = new Contact();
        conNew.RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId(); 
        conNew.accountID = accRecord.id;        
        conNew.Email= 'Cumminstest@test.com'; 
        conNew.FirstName = 'Ram';
        conNew.LastName = 'Singh';  
        conNew.Username__c =  'NetOne@test.com'; 
              
        insert ConNew;
        
         List<profile> pf = [select Id,Name from Profile WHERE Name = 'IAM_FleetguardUser' limit 1];
        
         User newUser = new User();
     
                    newUser.FirstName = 'FirstTestName';
                    newUser.LastName = 'test';
                    newUser.Email = 'testOne@test.com';   
                    newUser.CompanyName = 'IT Test Company';        
                    newUser.CommunityNickname = 'testValueOne';
                    newUser.Username = 'Cognizant@test.com' ;
                    newUser.Alias = 'test';
                    newUser.TimeZoneSidKey = 'GMT';
                    newUser.LocaleSidKey= 'en_US';
                    newUser.EmailEncodingKey = 'UTF-8';
                    newUser.LanguageLocaleKey = 'en_US';         
                    newUser.ProfileId = pf[0].Id ;                                  
                    newUser.ContactId = ConNew.Id;                   
                    newUser.isActive = TRUE;
                    newUser.Street = '123 Test St';
                    newUser.FederationIdentifier = '2468741';
                    
        //insert newUser;

        IAM_Application__c appQSOL = new IAM_Application__c();
       //
      
        
        appQSOL.IAM_Application_Name__c = 'QuickServe Online';
        appQSOL.IAM_Role__c = 'QSOL Fleet';
        appQSOL.IAM_Status__c = 'Active';
        appQSOL.IAM_Account_Name__c = accRecord.id;
        appQSOL.IAM_Subscription_Name__c = 'QuickServe Online EBU';
        appQSOL.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
        appQSOL.IAM_qsolexpiration__c='12344';
        insert appQSOL;
        
        
        IAM_Application__c appCST=  new IAM_Application__c();
        appCST.IAM_Application_Name__c = 'Cummins Service Training';
        appCST.IAM_Role__c = 'Service Training User';
        appCST.IAM_Status__c = 'Active';
        appCST.IAM_Account_Name__c = accRecord.id;
        appCST.IAM_Subscription_Name__c = 'QuickServe Online EBU';
        appQSOL.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Cummins Service Training').getRecordTypeId();
        insert appCST;
       
        IAM_Contact_Provisioning__c conAppQSOL = new IAM_Contact_Provisioning__c(
        IAM_Account_Application__c = appQSOL.ID,
        RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId(),
        IAM_Application_Name__c = 'QuickServe Online',
        IAM_Contact__c= conNew.Id,
        IAM_Role__c='QSOL Fleet',
        IAM_Status__c='Active',
        IAM_qsolexpiration__c='12344',
        IAM_Subscription_Name__c='QuickServe Online EBU'
        );
        insert conAppQSOL; 
   
        
       IAM_Contact_Provisioning__c conAppCST = new IAM_Contact_Provisioning__c(
        IAM_Account_Application__c = appCST.ID,
        RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Cummins Service Training').getRecordTypeId(),
        IAM_Application_Name__c = 'Cummins Service Training',
        IAM_Contact__c= conNew.Id,
        IAM_Role__c='Service Training User',
        IAM_Status__c='Active',
        IAM_Promotion__c = 'testvalue',
        IAM_Subscription_Name__c='QuickServe Online EBU'
        );
        insert conAppCST; 
        
        
       
        
        
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
    
      static testMethod void TestOne() {
        Test.startTest();
        createTestData();
        
        List<Contact> con =  [Select id,phone,Username__c,firstName,LastName,email,IAM_Ext_Legacy_Uid__c,Account.IAM_Service_Provider_Code__c,IAM_Contact_Status__c from Contact where IAM_Contact_Status__c='Active'];
       
        User u=[Select id,Name FROM User WHERE Contactid =: con[0].Id];
    
        Set<Id> contactIds = new Set<Id>();
        contactIds.add(con[0].Id); 
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/IAM_CSTUserLocationOutboundHelper';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        //req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
        
        List<Contact> contest = [Select id,phone,Username__c,firstName,LastName,email,IAM_Ext_Legacy_Uid__c,Account.IAM_Service_Provider_Code__c,IAM_Contact_Status__c from Contact where IAM_Contact_Status__c='Active'];
        List<IAM_Contact_Provisioning__c> iamProv=[select id from IAM_Contact_Provisioning__c where IAM_Contact__c=:contest[0].id];
        User utest = [Select id,Name FROM User WHERE Contactid =: con[0].Id];
       
            Set<Id> contactIdstest = new Set<Id>();
            contactIdstest.add(iamProv[0].Id); 
        
        
        IAM_CST_OUT_User_wrapper wraprecord = new IAM_CST_OUT_User_wrapper();
        IAM_CST_OUT_User_wrapper.records wrap = new IAM_CST_OUT_User_wrapper.records();
        
        //Test.setMock(HttpCalloutMock.class, new IAM_CSTUserOutboundHelperMock());
        IAM_CSTUserOutboundHelper.CstOutboundCall(contactIdstest);
         
        Test.stopTest();
    }
    
}