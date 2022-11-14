/*
Description     : Test class of IAM_Remove_Subscriptions_User
History                                                            
-------                                                            
VERSION     AUTHOR                   DATE              DETAIL                                
1.0 -    Shubhangi Sardar            06/24/2020        INITIAL DEVELOPMENT          
1.1 -    Shubhangi Sardar            05/02/2021        Added comment to push to production
1.2 -    Sandeep Vuyyuru             10/08/2021        Added test data 
1.3 -    Ganesh K M                  16/05/2022        Added comment to push to Prod.
*/

@isTest
public class IAM_Remove_Subscriptions_User_Test {
    private static testmethod void testUserSubscribtionBatch() {
        testData();
        Test.startTest();
        IAM_Remove_Subscriptions_User obj = new IAM_Remove_Subscriptions_User();
        Database.executeBatch(obj);
        Test.stopTest();
        List<IAM_Contact_Provisioning__c> conProList 
            = [SELECT Id FROM IAM_Contact_Provisioning__c WHERE IAM_Status__c = 'Inactive'];
        System.assert(conProList != null && !conProList.isEmpty());
    }
    
    private static void testData() {
    
    List<profile> pf = [select Id,Name from Profile WHERE Name = 'IAM User' limit 1];
        Account accP = new Account();
        accP.Name = 'AccountPp';
        accP.Type = 'Distributor Account';
        accP.BillingStreet = '1260 N MARR ROAD';
        accP.BillingCity = 'COLUMBUS';
        accP.BillingState = 'Indiana';
        accP.BillingCountry = 'United States';
        accP.BillingPostalCode = '47201';    
        insert accP;
        
        Account acc1=new Account(); 
        acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc1.Name = 'Account12';
        acc1.Type = 'Dealer Account';
        acc1.ParentId = accP.Id;
        acc1.BillingStreet = '1260 N MARR ROAD';
        acc1.BillingCity = 'COLUMBUS';
        acc1.BillingState = 'Indiana';
        acc1.BillingCountry = 'United States';
        acc1.BillingPostalCode = '47201';
        acc1.IAM_WWSPS_Regions__c = 'US and Canada';        
      insert acc1;
        
        Contact c2 = new Contact();
        c2.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        c2.FirstName = 'myfirstn';
        c2.LastName ='mylastn';
        c2.Email = 'myemail2@abc.com';
        c2.Username__c = 'myuserid2@abc.com';
        c2.AccountId = acc1.ID;
        c2.IAM_Contact_Status__c = 'Active';
        c2.CMI_Contact_Type__c = 'Primary';            
        insert c2;
        
        IAM_Application__c app1 = new IAM_Application__c();
        app1.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('CUMPAS 2.0').getRecordTypeId(); 
        app1.IAM_Application_Name__c = 'CUMPAS 2.0';
        app1.IAM_Role__c = 'Dealer User;Dealer Admin';
        app1.IAM_Cumpas_Modularity__c = 'View Credit';
        app1.IAM_Subscription_Count__c = 99;
        app1.IAM_Account_Name__c = acc1.Id;
        insert app1;
        
        IAM_Contact_Provisioning__c conP2 = new IAM_Contact_Provisioning__c();
        conP2.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('CUMPAS 2.0').getRecordTypeId(); 
        conP2.IAM_Application_Name__c = 'CUMPAS 2.0';
        conP2.IAM_Account_Application__c = app1.Id;
        conP2.IAM_Role__c = 'Dealer User';
        conP2.IAM_Cumpas_Modularity__c = 'View Credit';
        conP2.IAM_Contact__c = c2.Id;
        conP2.IAM_Status__c = 'Active';
        insert conP2;
        
    }
}