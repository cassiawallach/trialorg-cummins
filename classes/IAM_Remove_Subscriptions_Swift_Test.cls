/************************************************************
Name:  IAM_Remove_Subscriptions_Swift_Test
Copyright © 2022  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is a async class to deactivate EDS and CST subscriptions if QSOL access is removed.                      
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION         AUTHOR                   DATE              DETAIL                                
1.0 -        Chetan Gaikwad          17/08/2022        INITIAL DEVELOPMENT 
***********************************************************************************/

@isTest
public class IAM_Remove_Subscriptions_Swift_Test{

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
    
  	List<IAM_Application__c> appList = new List<IAM_Application__c>();
     
    IAM_Application__c qsolApplication = new IAM_Application__c(    
        IAM_Account_Name__c = accSampleRecord.ID,
        RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId(),
        IAM_Application_Name__c = 'QuickServe Online',
        IAM_Role__c='QSOL Dealer',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Subscription_End_Date__c= System.today() + 365,
        IAM_Subscription_Name__c='QuickServe Online EBU',
        IAM_Free_Subscription__c= False,
        IAM_Qsolexpiration__c='31-DEC-2100EBUActive'
    );
        
    IAM_Application__c cstApplication = new IAM_Application__c(    
        IAM_Account_Name__c = accSampleRecord.ID,
        RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Cummins Service Training').getRecordTypeId(),
        IAM_Application_Name__c = 'Cummins Service Training',
        IAM_Role__c='Service Training User',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Subscription_End_Date__c= System.today() + 365,
        IAM_Subscription_Name__c='Cummins Service Training',
        IAM_Free_Subscription__c= False
    );
        
    IAM_Application__c edsApplication = new IAM_Application__c(    
        IAM_Account_Name__c = accSampleRecord.ID,
        RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('EDS').getRecordTypeId(),
        IAM_Application_Name__c = 'EDS',
        IAM_Role__c='Technician',
        IAM_Status__c='Active',
        IAM_Subscription_Count__c= 10,
        IAM_Subscription_End_Date__c= System.today() + 365,
        IAM_Subscription_Name__c='QuickServe Online EBU',
        IAM_Free_Subscription__c= False
    );
    
    appList.add(qsolApplication);
    appList.add(cstApplication);
    appList.add(edsApplication);
    insert appList;
    
  List<IAM_Contact_Provisioning__c> proList = new List<IAM_Contact_Provisioning__c>();

 IAM_Contact_Provisioning__c iamContSampleRecord1 = new IAM_Contact_Provisioning__c(
        IAM_Account_Application__c = qsolApplication.ID,
        RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId(),
        IAM_Application_Name__c = 'QuickServe Online',
        IAM_Contact__c= contSampleRecord.Id,
        IAM_End_Date__c= System.today() + 365,
        IAM_Role__c='QSOL Dealer',
        IAM_Start_Date__c=System.today(),
        IAM_Status__c='Active',
     	IAM_Qsolexpiration__c='31-DEC-2100EBUActive'
    );
        
   IAM_Contact_Provisioning__c iamContSampleRecord2 = new IAM_Contact_Provisioning__c(
        IAM_Account_Application__c = qsolApplication.ID,
        RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Cummins Service Training').getRecordTypeId(),
        IAM_Application_Name__c = 'Cummins Service Training',
        IAM_Contact__c= contSampleRecord.Id,
        IAM_End_Date__c= System.today() + 365,
        IAM_Role__c='Service Training User',
        IAM_Start_Date__c=System.today(),
        IAM_Status__c='Active'
    );
        
    IAM_Contact_Provisioning__c iamContSampleRecord3 = new IAM_Contact_Provisioning__c(
        IAM_Account_Application__c = qsolApplication.ID,
        RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('EDS').getRecordTypeId(),
        IAM_Application_Name__c = 'EDS',
        IAM_Contact__c= contSampleRecord.Id,
        IAM_End_Date__c= System.today() + 365,
        IAM_Role__c='Technician',
        IAM_Start_Date__c=System.today(),
        IAM_Status__c='Active'
    );
        
    proList.add(iamContSampleRecord1);
    proList.add(iamContSampleRecord2);
    proList.add(iamContSampleRecord3);
    insert proList;    
    
    }
    
    @isTest
    static void testGetsObjectInfo(){
        
        List<IAM_Application__c> deactivateList = [Select id, IAM_Application_Name__c, IAM_Role__c,IAM_Status__c, IAM_Account_Name__c from IAM_Application__c where IAM_Application_Name__c = 'QuickServe Online' and IAM_Status__c = 'Active'];
        Test.startTest();
        if(!deactivateList.isEmpty()){
            for(IAM_Application__c app:deactivateList){
                app.IAM_Status__c = 'Inactive';
            }
        }
        update deactivateList;
        Test.stopTest();
    } 
}