@isTest 
public class IAM_LDAP_Util_ReqParser_Test{
  //@testSetup
    public static void createTestData(){
        Account accRecord = new Account();
        accRecord.Name = 'Send LDAP Test Company';
        accRecord.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM Global').getRecordTypeId();  
        accRecord.phone = '6884382997';          
        insert accRecord ;
        
        //Contact
        Contact conNew = new Contact();
        conNew.accountID = accRecord.id;        
        conNew.Email= 'sendLdap@test.com'; 
        conNew.FirstName = 'Send';
        conNew.LastName = 'Send LDAP';  
        conNew.Username__c =  'sendLdap@test.com'; 
        ConNew.IAM_Contact_Status__c='Active';
        ConNew.CMI_Contact_type__c='Secondary';
        insert conNew;
        
        List<profile> pf = [select Id,Name from Profile WHERE Name = 'IAM_FleetguardUser' limit 1];
        
         User newUser = new User();
     
                    newUser.FirstName = 'UserFirstName';
                    newUser.LastName = 'test';
                    newUser.Email = 'test@test.com';   
                    newUser.CompanyName = 'IT Test Company';        
                    newUser.CommunityNickname = 'sabse';
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
static testMethod void testToLDAPRequestBody() {
        Test.startTest();
        createTestData();
        Contact con = [SELECT Id,Username__c,CMI_User_Id__c,IAM_Ext_Legacy_Uid__c,Email FROM Contact WHERE Username__c = 'sendLdap@test.com']; 
        User u=[Select id,Name FROM User WHERE Contactid =: con.Id];
        Set<Id> contactIds = new SEt<Id>();
        contactIds.add(con.Id);
        Test.setMock(HttpCalloutMock.class, new IAM_LDAP_Util_ApexCallout_Mock());
        IAM_LDAP_Util_ReqParser.IAM_LDAP_Util_ReqBody(contactIds);        
        Test.stopTest();
    }   
    
 static testMethod void testToLDAPRequestBody2() {
        Test.startTest();
        createTestData();
        Contact con = [SELECT Id,Username__c,CMI_User_Id__c,IAM_Ext_Legacy_Uid__c,Email FROM Contact WHERE Username__c = 'sendLdap@test.com']; 
        User u=[Select id,Name FROM User WHERE Contactid =: con.Id];
        Set<Id> contactIds = new SEt<Id>();
        contactIds.add(con.Id);
        Test.setMock(HttpCalloutMock.class, new IAM_LDAP_Util_ApexCallout_Mock());
        IAM_LDAP_Util_ReqParser.IAM_LDAP_Util_ReqBody(contactIds);        
        Test.stopTest();
    } 
    
    static testMethod void testToLDAPRequestBody3() {
        Test.startTest();
        createTestData();
        Contact con = [SELECT Id,Username__c,CMI_User_Id__c,IAM_Ext_Legacy_Uid__c,Email FROM Contact WHERE Username__c = 'sendLdap@test.com']; 
        con.IAM_Contact_Status__c = 'Active';
        con.IAM_Internal__c = true;
        con.IAM_Legacy_User__c = true;
        update con;
        User u=[Select id,Name FROM User WHERE Contactid =: con.Id];
        Set<Id> contactIds = new SEt<Id>();
        contactIds.add(con.Id);
        Test.setMock(HttpCalloutMock.class, new IAM_LDAP_Util_ApexCallout_Mock());
        IAM_LDAP_Util_ReqParser.IAM_LDAP_Util_ReqBody(contactIds);        
        Test.stopTest();
    }   
    
    static testMethod void testToLDAPRequestBody4() {
        Test.startTest();
        createTestData();
        Contact con = [SELECT Id,Username__c,CMI_User_Id__c,IAM_Ext_Legacy_Uid__c,Email FROM Contact WHERE Username__c = 'sendLdap@test.com']; 
        con.IAM_Contact_Status__c = 'Active';
        con.IAM_Internal__c = false;
        con.IAM_Legacy_User__c = false;
        update con;
        User u=[Select id,Name FROM User WHERE Contactid =: con.Id];
        Set<Id> contactIds = new SEt<Id>();
        contactIds.add(con.Id);
        Test.setMock(HttpCalloutMock.class, new IAM_LDAP_Util_ApexCallout_Mock());
        IAM_LDAP_Util_ReqParser.IAM_LDAP_Util_ReqBody(contactIds);        
        Test.stopTest();
    }   
  
  static testMethod void testToLDAPRequestBody5() {
        Test.startTest();
        createTestData();
        Contact con = [SELECT Id,Username__c,CMI_User_Id__c,IAM_Ext_Legacy_Uid__c,Email FROM Contact WHERE Username__c = 'sendLdap@test.com']; 
        con.IAM_Contact_Status__c = 'Active';
        con.IAM_Internal__c = false;
        con.IAM_Legacy_User__c = true;
        update con;
        User u=[Select id,Name FROM User WHERE Contactid =: con.Id];
        Set<Id> contactIds = new SEt<Id>();
        contactIds.add(con.Id);
        Test.setMock(HttpCalloutMock.class, new IAM_LDAP_Util_ApexCallout_Mock());
        IAM_LDAP_Util_ReqParser.IAM_LDAP_Util_ReqBody(contactIds);        
        Test.stopTest();
    }   
   
 }