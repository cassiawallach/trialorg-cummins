/************************************************************
Name:  IAM_Assign_PermSet_Ext_New_Queueable_Test
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is a queable class to update the Contact record Updates.                        
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION         AUTHOR                   DATE              DETAIL                                
1.0 -    Karthik Raj Golakaram          01/16/2020        INITIAL DEVELOPMENT 
1.1 -    Karthik Raj Golakaram          01/03/2021      Made changes to make sure that we are calling LDAP API to remove changes
                                                        Also made changes to update Contact and User record. Test                                                     
*****************************************************/
/********************************************************************************
***********************************************************************************/
@isTest(seeAllData=True)
public class IAM_Assign_PSet_Ext_New_Queueable_Test{

  static testmethod void test1()
 {    
    
         Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.IAM_Service_Provider_Code__c = '1232432';
        acc.Type = 'Dealer Account';
        acc.CSS_DistributorCode__c = '1234';
        acc.CSS_DBCode__c = '12345';
        acc.CSS_DealerCode__c = '456';
        acc.RecordTypeid=Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        insert acc;
        
        Contact con = new contact();
        con.lastName = 'Test';
        con.AccountId = acc.id;
        con.firstName = 'contact';
        con.Email = 'testContact@test.com';
        con.IAM_Contact_Status__c = 'Active';
        con.CMI_Contact_Type__c = 'Secondary';
        con.phone = '8989898989';
        con.IAM_Application_Roles__c = 'Advanced';
        con.IAM_Legacy_User__c=false;
        con.IAM_Promotion__c = '12345';
        con.IAM_Applications__c = 'cn=CSS_DN_Advanced,ou=APP_CSS,ou=application,dc=cummins,dc=com';
        con.IAM_is_member_of__c = 'cn=CSS_DN_Advanced,ou=APP_CSS,ou=application,dc=cummins,dc=com';
        Con.Username__c = 'test_user_helper9@eidm.com';
        Con.recordtypeid=Schema.getGlobalDescribe().get('Contact').getDescribe().getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        
        insert con;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='IAM User'];
        
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='test_user_helper9@eidm.com',Contactid=con.id);
            
        insert u;
        
        IAM_Application__c app = new IAM_Application__c();
        app.IAM_Application_Name__c = 'Guidanz';
        app.IAM_Role__c = 'Advanced';
        app.IAM_Status__c = 'Active';
        app.IAM_Account_Name__c = acc.id;
        app.IAM_Subscription_Name__c = 'test';
        app.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        insert app;
        
        IAM_Contact_Provisioning__c gp= new IAM_Contact_Provisioning__c();
        gp.IAM_Application_Name__c='Guidanz';
        gp.IAM_Role__c='Advanced';
        gp.IAM_Contact__c=con.id;
        gp.IAM_Status__c='Active';
        gp.IAM_Account_Application__c=app.id;
        gp.recordtypeid=Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        
        insert gp;

       

       
        List<Contact> con1=[select id from contact where username__c='test_user_helper9@eidm.com' Limit 1];
        Set<Id> setIds = new Set<Id>();    
        setIds.add(con1[0].id);
        
        User us1 = [select ProfileId,LastName,Email,Username,CompanyName,IAM_Application_Roles__c,IAM_Applicationgroups__c from user where ContactId =: con1[0].id];
        
        
    
    Test.startTest();
    System.enqueueJob(new IAM_Assign_PermSet_Ext_New_Queueable(setIds,'Insert'));    
    Test.stopTest();
 } 


}