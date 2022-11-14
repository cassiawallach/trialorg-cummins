/*************************************************************************************
Name:  IAM_LDAP_Util_group_Test
Copyright © 2019  Cummins
**************************************************************************************
Purpose: Test Class for IAM_LDAP_Util_group class
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION       AUTHOR                   DATE               DETAIL                                
1.0      Sandeep Vuyyuru            21/05/2019     INITIAL DEVELOPMENT
1.0      Shubhangi Sardar           09/06/2021     Code Optimization
**************************************************************************************
**************************************************************************************/

@isTest
public class IAM_LDAP_Util_group_Test{

//@testSetup
public static void createTestData(){
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
        conNew.IAM_Contact_Status__c = 'Active';
        conNew.Username__c =  'test@test.com'; 
        insert conNew;      
        
        IAM_Application__c app = new IAM_Application__c();
        app.IAM_Application_Name__c = 'Marketplace';
        app.IAM_Role__c = 'CSS_DN_ADMIN';
        app.IAM_Status__c = 'Active';
        app.IAM_Account_Name__c = accRecord.id;
        app.IAM_Subscription_Name__c = 'test';
        insert app;
          
        
        //IAM Contact Provisioning
        List<IAM_Contact_Provisioning__c> lstconApp = new List<IAM_Contact_Provisioning__c>();
        IAM_Contact_Provisioning__c conApp = new IAM_Contact_Provisioning__c();
        //conApp.IAM_Application_Name__c = 'Marketplace';
        //conApp.IAM_Role__c = 'Supervisor';   
        conApp.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('CUMPAS 2.0').getRecordTypeId();
        conApp.IAM_Application_Name__c = 'CUMPAS 2.0';     
        conApp.IAM_Status__c = 'Active';
        conApp.IAM_Contact__c = conNew.id; 
        conApp.IAM_Account_Application__c = app.id;
        //insert conApp;
        
        IAM_Contact_Provisioning__c conApp2 = new IAM_Contact_Provisioning__c();
        //conApp.IAM_Application_Name__c = 'Marketplace';
        //conApp2.IAM_Role__c = 'Supervisor'; 
        conApp2.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('CUMPAS 2.0').getRecordTypeId();
        conApp2.IAM_Application_Name__c = 'CUMPAS 2.0';      
        conApp2.IAM_Status__c = 'Inactive';
        conApp2.IAM_Contact__c = conNew.id; 
        conApp2.IAM_Account_Application__c = app.id;
        
        lstconApp.add(conApp);
        lstconApp.add(conApp2);
        
        insert lstconApp;
        
        
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
     
       createTestData();
       List<Contact> con = [SELECT Id,Username__c,CMI_User_Id__c,IAM_Ext_Legacy_Uid__c,Email FROM Contact WHERE Username__c = 'test@test.com' LIMIT 1]; 
       
       List<IAM_Contact_Provisioning__c> contactProv = [SELECT Id,IAM_Contact_Status__c,IAM_Status__c,IAM_Contact__r.IAM_Contact_Status__c FROM IAM_Contact_Provisioning__c WHERE IAM_Contact__c =: con[0].Id]; 
      // contactProv[0].IAM_Status__c = 'Active';             
      //update contactProv;     
      Test.startTest();
      Test.setMock(HttpCalloutMock.class, new IAM_LDAP_Util_ApexCallout_Mock());
       IAM_LDAP_Util_group.invokeapexcallout(contactProv);        
       Test.stopTest();
    } 
static testMethod void testinvokeapexcallout2() {
     
       createTestData();
       List<Contact> con = [SELECT Id,Username__c,CMI_User_Id__c,IAM_Ext_Legacy_Uid__c,Email FROM Contact WHERE Username__c = 'test@test.com' LIMIT 1]; 
       
       List<IAM_Contact_Provisioning__c> contactProv = [SELECT Id,IAM_Contact_Status__c,IAM_Status__c,IAM_Contact__r.IAM_Contact_Status__c FROM IAM_Contact_Provisioning__c WHERE IAM_Contact__c =: con[0].Id]; 
      contactProv[0].IAM_Status__c = 'Inactive';             
      update contactProv;     
      Test.startTest();
      Test.setMock(HttpCalloutMock.class, new IAM_LDAP_Util_ApexCallout_Mock());
       IAM_LDAP_Util_group.invokeapexcallout(contactProv);        
       Test.stopTest();
    }  
 static testMethod void testinvokeapexcallout3() {
     
       createTestData();
       List<Contact> con = [SELECT Id,Username__c,CMI_User_Id__c,IAM_Ext_Legacy_Uid__c,Email FROM Contact WHERE Username__c = 'test@test.com' LIMIT 1]; 
       
       List<IAM_Contact_Provisioning__c> contactProv = [SELECT Id,IAM_Contact_Status__c,IAM_Status__c,IAM_Contact__r.IAM_Contact_Status__c FROM IAM_Contact_Provisioning__c WHERE IAM_Status__c ='Inactive']; 
      // contactProv[0].IAM_Status__c = 'Active';             
      //update contactProv;     
      Test.startTest();
      Test.setMock(HttpCalloutMock.class, new IAM_LDAP_Util_ApexCallout_Mock());
       IAM_LDAP_Util_group.invokeapexcallout(contactProv);        
       Test.stopTest();
    } 

}