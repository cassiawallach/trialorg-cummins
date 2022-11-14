/************************************************************
Name:  IAM_Remove_Subscritions_Test
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
1.0 -        Amarnath Mishra          05/27/2019        INITIAL DEVELOPMENT 
1.1 -    Karthik Raj Golakaram        01/03/2021      Made changes to make sure that we are calling LDAP API to remove changes
                                                        Also made changes to update Contact and User record.
1.2 -    Shubhangi Sardar             09/06/2021      LDAP Sync issue
1.3 -    Sandeep Vuyyuru              10/08/2021      Error fix to Remove subscriptions
1.4 -    Ganesh K M                   16/05/2022      added comment to push to prod.
1.5 -    Chetan Gaikwad               17/08/2022      added comment to push to prod.
***************************************************/
/********************************************************************************
***********************************************************************************/

@isTest
public class IAM_Remove_Subscritions_Test{

    @TestSetup
    Static void InitData(){
    Account accSampleRecord = new Account(name='AccountTest1',
                                   CMI_Account_Status__c='Pending',
                                   CMI_CDA_Status__c='New Customer Request',
                                   Recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId(),
                                   Type='Dealer Account');
    
    insert accSampleRecord;
   
    
    
    Contact contSampleRecord = new Contact(
        FirstName = 'Test',
        LastName ='User',
        Email = 'lstTest@test.com',
        AccountId = accSampleRecord.ID,
        IAM_Contact_Status__c = 'Active',
        CMI_Contact_Type__c = 'Primary',
        IAM_Legacy_User__c=false,
        Recordtypeid=Schema.sObjecttype.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId(),
        Username__c= 'Amartestestvaluet@abc.com',
        Phone = '9743800309'
    );
    
    insert contSampleRecord;
    
  
     
    IAM_Application__c cumpasApplication = new IAM_Application__c(    
        IAM_Account_Name__c = accSampleRecord.ID,
        IAM_Application_Name__c = 'CUMPAS 2.0',
        IAM_Role__c='Dealer User',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Provisioned_User_Count__c=5,
        IAM_Subscription_End_Date__c= System.today() - 5,
        IAM_Subscription_Name__c='TestSubscription1',
        IAM_Free_Subscription__c= False,
        IAM_Subscription_Start_Date__c=System.today()
    );
    
    insert cumpasApplication;
    
  

 IAM_Contact_Provisioning__c iamContSampleRecord = new IAM_Contact_Provisioning__c(
        IAM_Account_Application__c = cumpasApplication.ID,
        RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('CUMPAS 2.0').getRecordTypeId(),
        IAM_Application_Name__c = 'CUMPAS 2.0',
        IAM_Contact__c= contSampleRecord.Id,
        IAM_End_Date__c= System.today() - 5,
        IAM_Role__c='Dealer User',
        IAM_Start_Date__c=System.today(),
        IAM_Status__c='Active'
    );
    insert iamContSampleRecord;    
    
    }
    
    @isTest
    static void testGetsObjectInfo(){
        
        IAM_Remove_Subscritions expiresubscription = new IAM_Remove_Subscritions();
        Test.startTest();
        Database.executeBatch(expiresubscription,10);
        Test.stopTest();
    } 
}