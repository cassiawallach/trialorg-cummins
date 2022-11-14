/*********************************************************************************
Author       :   Sushma Rajput
Created Date :   12th JSeptember,2019
Description  :   Unit test class for  IAM_CSTUserLocationOutboundHelper and IAM_CST_OUT_User_wrapper.
*********************************************************************************/

@isTest
public class IAM_CSTUserLocationOutboundHelper_Test{


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
        conNew.Email= 'test@test.com'; 
        conNew.FirstName = 'test';
        conNew.LastName = 'test';  
        conNew.Username__c =  'test@test.com'; 
        conNew.IAM_Contact_Status__c = 'Active';
        insert conNew;
        
         List<profile> pf = [select Id,Name from Profile WHERE Name = 'IAM_FleetguardUser' limit 1];
        
         User newUser = new User();
     
                    newUser.FirstName = 'UserFirstName';
                    newUser.LastName = 'test';
                    newUser.Email = 'test@test.com';   
                    newUser.CompanyName = 'IT Test Company';        
                    newUser.CommunityNickname = 'Testing_TestOne';
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
                    newUser.IAM_Promotion__c = 'testval';
                    
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
        
      /* IAM_Application__c app = new IAM_Application__c();
       //RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Cummins Service Training').getRecordTypeId();
      
        app.IAM_Application_Name__c = 'Cummins Service Training';
        app.IAM_Role__c = 'Service Training User';
        app.IAM_Status__c = 'Active';
        app.IAM_Account_Name__c = accRecord.id;
        app.IAM_Subscription_Name__c = 'test';
        insert app;*/
       
   /*    IAM_Application__c app    = new IAM_Application__c(    
            IAM_Account_Name__c = accRecord.ID,
            IAM_Application_Name__c = 'Cummins Service Training',
            IAM_Role__c='Service Training User',
            IAM_Status__c='Active',
            IAM_Subscription_Name__c = 'test'
        );
        
        insert app;
        */
        
     /*  IAM_Contact_Provisioning__c conApp = new IAM_Contact_Provisioning__c(
        IAM_Account_Application__c = app.ID,
        RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Cummins Service Training').getRecordTypeId(),
        IAM_Application_Name__c = 'Cummins Service Training',
        IAM_Contact__c= conNew.Id,
        IAM_Role__c='Service Training User',
        IAM_Status__c='Active',
        IAM_Promotion__c = 'testvalue',
        IAM_User__c = newUser.id
        );
        insert conApp; 
     */      
       /* 
        //IAM Contact Provisioning        
        IAM_Contact_Provisioning__c conApp = new IAM_Contact_Provisioning__c();
        //conApp.IAM_Application_Name__c = 'Marketplace';
        //RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Cummins Service Training').getRecordTypeId();
      
         //IAM_Contact_Provisioning__c conPro = [SELECT id,IAM_Promotion__c,IAM_User__c,IAM_Contact__c FROM IAM_Contact_Provisioning__c where IAM_Application_Name__c='Cummins Service Training' and IAM_Status__c='Active'];
         //conPro.IAM_Application_Name__c = 'Cummins Service Training';   
         
        conApp.IAM_Role__c = 'Service Training User';        
        conApp.IAM_Status__c = 'Active';
        conApp.IAM_Contact__c = conNew.id; 
        conApp.IAM_Account_Application__c = app.id;
        conApp.IAM_Application_Name__c='Cummins Service Training';
        insert conApp;
     */
     
    }
        static testMethod void testMethodOne()
        {
            Test.startTest();       
            createTestData();
           Account a=[Select id from Account where Name='Test Company'];
            List<Contact> con = [Select id,phone,Username__c,firstName,LastName,email,IAM_Ext_Legacy_Uid__c,Account.IAM_Service_Provider_Code__c,IAM_Contact_Status__c from Contact where IAM_Contact_Status__c='Active' and Accountid=:a.id];
            //User u = [Select id,Name FROM User WHERE Contactid =: con[0].Id];
       
            Set<Id> contactIds = new Set<Id>();
            contactIds.add(con[0].Id); 
        
            Test.setMock(HttpCalloutMock.class, new IAM_CSTUserOutboundHelperMock());
            IAM_CSTUserLocationOutboundHelper.CstUserLocationUpdate(contactIds);
            
         /*   IAM_CST_OUT_User_wrapper wraprecord = new IAM_CST_OUT_User_wrapper();
            
            IAM_CST_OUT_User_wrapper.records wrap= new IAM_CST_OUT_User_wrapper.records();
                wrap.STATUS_ID='test';
                wrap.STATUS='test';
                wrap.JOBTITLE='test';
                wrap.CREATED_BY_ID='test';
                wrap.JOBCODE='test';
                wrap.CREATED_DATE='test';
                wrap.COMPANY_PHONE='test';
                wrap.LAST_MODIFIED_BY_ID='test';
                wrap.COMPANY_EMAIL='test';
                wrap.LAST_MODIFIED_DATE='test';
                wrap.LAST_NAME='test';
                wrap.SERVICE_PROVIDER_ID='test';
                wrap.MIDDLE_NAME='test';
        
        List<IAM_CST_OUT_User_wrapper.records> wraprecordLst = new list<IAM_CST_OUT_User_wrapper.records>();
        wraprecordLst.add(wrap);
        //wraprecord.records = wraprecordLst;
        //String JsonMsg=JSON.serialize(wraprecord);
       // Test.startTest();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/IAM_CSTUserLocationOutboundHelper';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        //req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
        
        List<Contact> contest = [Select id,phone,IAM_Cummins_Login_ID__c,firstName,LastName,email,IAM_Ext_Legacy_Uid__c,Account.IAM_Service_Provider_Code__c,IAM_Contact_Status__c from Contact where IAM_Contact_Status__c='Active'];
            User utest = [Select id,Name FROM User WHERE Contactid =: con[0].Id];
       
            Set<Id> contactIdstest = new Set<Id>();
            contactIdstest.add(contest[0].Id); 
        
        
        IAM_CSTUserLocationOutboundHelper.CstUserLocationUpdate(contactIdstest);
       */
        Test.stopTest();
        
        }
    
}