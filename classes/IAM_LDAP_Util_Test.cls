@isTest 
public class IAM_LDAP_Util_Test {
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
        insert conNew;
        
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
    static testMethod void testinvokeapexcallout() {
        Test.startTest();
        createTestData();
       List<Contact> con = [SELECT Id,Username__c,CMI_User_Id__c,IAM_Ext_Legacy_Uid__c,Email FROM Contact WHERE Username__c = 'sendLdap@test.com' LIMIT 1]; 
       con[0].IAM_contact_check__c = true;
       con[0].IAM_Contact_Status__c = 'Inactive';
       update con;   
       
       IAM_LDAP_Util.invokeapexcallout(con,'Update');  
       Test.stopTest();
    }
 static testMethod void testinvokeapexcalloutActive() {
        Test.startTest();
        createTestData();
        List<Contact> con = [SELECT Id,Username__c,CMI_User_Id__c,IAM_Ext_Legacy_Uid__c,Email FROM Contact WHERE Username__c = 'sendLdap@test.com' LIMIT 1]; 
       
       con[0].IAM_contact_check__c = false;
       con[0].IAM_Contact_Status__c = 'Active';
       update con;
       
       IAM_LDAP_Util.invokeapexcallout(con,'delete');
       Test.stopTest();
    } 
    
 static testMethod void testinvokeapexcalloutActive2() {
        Test.startTest();
        createTestData();
        List<Contact> con = [SELECT Id,IAM_Cummins_login_ID__c,CMI_User_Id__c,IAM_Ext_Legacy_Uid__c,Email FROM Contact]; 
       
       IAM_LDAP_Util.invokeapexcallout(con,'Update');
       Test.stopTest();
    } 
    
    
 }