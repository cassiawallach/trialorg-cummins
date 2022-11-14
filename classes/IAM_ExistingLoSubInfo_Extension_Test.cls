/*************************************************************************************
Name:  IAM_ExistingLoSubInfo_Extension_Test
Copyright © 2019  Cummins
**************************************************************************************
Purpose: Test class for IAM_ExistingLoSubInfo_Extension
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION         AUTHOR            DATE              DETAIL                                
1.0      Karthik Golakaram      10/12/2019      INITIAL DEVELOPMENT 
1.1      Shubhangi Sardar       09/23/2021      Assigned Value from Label to IAM_Subscription_Count__c
**************************************************************************************
**************************************************************************************/

@isTest
public class IAM_ExistingLoSubInfo_Extension_Test{

static testmethod void test1()
 {    
           
    
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.IAM_Service_Provider_Code__c = '123';
        acc.Type = 'Dealer Account';
        acc.CSS_DistributorCode__c = '1234';
        acc.CSS_DBCode__c = '12345';
        acc.CSS_DealerCode__c = '456';
        insert acc;
        
        Contact con = new contact();
        con.lastName = 'Test';
        con.AccountId = acc.id;
        con.firstName = 'contact';
        con.Email = 'testContact@test.com';
        con.IAM_Contact_Status__c = 'Active';
        con.CMI_Contact_Type__c = 'Primary';
        con.phone = '8989898989';
        con.IAM_Application_Roles__c = 'Advanced';
        con.IAM_Promotion__c = '12345';
        con.IAM_Applications__c = 'cn=CSS_DN_Advanced,ou=APP_CSS,ou=application,dc=cummins,dc=com';
        con.IAM_is_member_of__c = 'cn=CSS_DN_Advanced,ou=APP_CSS,ou=application,dc=cummins,dc=com';
        Con.Username__c = 'test_user_helper6@eidm.com';
        Con.recordtypeid=Schema.getGlobalDescribe().get('Contact').getDescribe().getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        
        insert con;
        
        Set<Id> setIds = new Set<Id>();    
        setIds.add(con.id);
        
        //User us1 = [select ProfileId,LastName,Email,Username,CompanyName,IAM_Application_Roles__c,IAM_Applicationgroups__c from user where ContactId =: con.id];
        List<Id> lstApp = new List<Id>();
        IAM_Application__c app = new IAM_Application__c();
        app.IAM_Application_Name__c = 'Guidanz';
        app.IAM_Role__c = 'Advanced';
        app.IAM_Status__c = 'Active';
        app.IAM_Account_Name__c = acc.id;
        app.IAM_Subscription_Name__c = 'test';
        //app.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        insert app;
        lstApp.add(app.Id);
        
        //IAM Contact Provisioning
        List<IAM_Contact_Provisioning__c> lstconApp = new List<IAM_Contact_Provisioning__c>();
        IAM_Contact_Provisioning__c conApp = new IAM_Contact_Provisioning__c();
        conApp.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Repair logistics and Service').getRecordTypeId();
        conApp.IAM_Role__c = 'RLS Admin';
                
        conApp.IAM_Status__c = 'Active';
        conApp.IAM_Contact__c = con.id; 
        conApp.IAM_Account_Application__c = app.id;    
        insert conApp;
    
    Test.startTest();
    System.enqueueJob(new IAM_ExistingLoSubInfo_Extension(lstApp,'Insert'));    
    Test.stopTest();
 } 

static testmethod void test2()
 {    
           
    
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.IAM_Service_Provider_Code__c = '123';
        acc.Type = 'Dealer Account';
        acc.CSS_DistributorCode__c = '1234';
        acc.CSS_DBCode__c = '12345';
        acc.CSS_DealerCode__c = '456';
        insert acc;
        
        Contact con = new contact();
        con.lastName = 'Test';
        con.AccountId = acc.id;
        con.firstName = 'contact';
        con.Email = 'testContact@test.com';
        con.IAM_Contact_Status__c = 'Active';
        con.CMI_Contact_Type__c = 'Primary';
        con.phone = '8989898989';
        con.IAM_Application_Roles__c = 'Advanced';
        con.IAM_Promotion__c = '12345';
        con.IAM_Applications__c = 'cn=CSS_DN_Advanced,ou=APP_CSS,ou=application,dc=cummins,dc=com';
        con.IAM_is_member_of__c = 'cn=CSS_DN_Advanced,ou=APP_CSS,ou=application,dc=cummins,dc=com';
        Con.Username__c = 'test_user_helper6@eidm.com';
        Con.recordtypeid=Schema.getGlobalDescribe().get('Contact').getDescribe().getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        
        insert con;
        
        Set<Id> setIds = new Set<Id>();    
        setIds.add(con.id);
        
        //User us1 = [select ProfileId,LastName,Email,Username,CompanyName,IAM_Application_Roles__c,IAM_Applicationgroups__c from user where ContactId =: con.id];
        List<Id> lstApp = new List<Id>();
        IAM_Application__c app = new IAM_Application__c();
        app.IAM_Application_Name__c = 'Guidanz';
        app.IAM_Role__c = 'Advanced';
        app.IAM_Status__c = 'Active';
        app.IAM_Account_Name__c = acc.id;
        app.IAM_Subscription_Name__c = 'test';
        //app.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        insert app;
        lstApp.add(app.Id);
        
        //IAM Contact Provisioning
        List<IAM_Contact_Provisioning__c> lstconApp = new List<IAM_Contact_Provisioning__c>();
        IAM_Contact_Provisioning__c conApp = new IAM_Contact_Provisioning__c();
        conApp.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Repair logistics and Service').getRecordTypeId();
        conApp.IAM_Role__c = 'RLS Admin';
                
        conApp.IAM_Status__c = 'Active';
        conApp.IAM_Contact__c = con.id; 
        conApp.IAM_Account_Application__c = app.id;    
        insert conApp;
    
    Test.startTest();
    System.enqueueJob(new IAM_ExistingLoSubInfo_Extension(lstApp,'Update'));    
    Test.stopTest();
 } 



}