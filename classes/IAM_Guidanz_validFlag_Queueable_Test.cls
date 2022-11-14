/************************************************************
Name:  IAM_Guidanz_validFlag_Queueable_Test
Copyright © 2020  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test Class for IAM_GuiAssign_ConProv_Queueable class.                       
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                   DATE              DETAIL                                
1.0 -    Anupam Adhikari       24/01/2022        INITIAL DEVELOPMENT         
*****************************************************/
@isTest
public class IAM_Guidanz_validFlag_Queueable_Test {
    
    @testSetup
    Static Void testDataSetup(){
        
        List<Account> accListToInsert = new List<Account>();
        List<IAM_Application__c> guiAppFeatureList = new List<IAM_Application__c>();
        
        Test.startTest();
        Account accP=new Account();
        accP.Name='AccountPp';
        accP.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        accP.Type='Distributor Account';
        accP.BillingStreet='1260 N MARR ROAD';
        accP.BillingCity='COLUMBUS';
        accP.BillingState='Indiana';
        accP.BillingCountry='United States';
        accP.BillingPostalCode='47201';    
        insert accP;        
        
        IAM_Application__c newApp = new IAM_Application__c();
        newApp.IAM_Application_Name__c = 'Guidanz';
        newApp.IAM_Role__c = 'Advanced';
        newApp.IAM_Status__c = System.Label.IAM_Active;
        newApp.IAM_Account_Name__c = accP.Id;
        newApp.IAM_Subscription_Start_Date__c = system.today();
        newApp.IAM_Subscription_End_Date__c = system.today() + 36500;
        newApp.recordtypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        //guiAppFeatureList.add(newApp);
        insert newApp;
        
        List<contact> cons=new List<contact>();
        Contact c=new Contact();
        c.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        c.FirstName = 'myfirstn';
        c.LastName ='mylastn';
        c.Email = 'myemail2@abc.com';
        c.Username__c = 'myuserid2@abc.com';
        c.AccountId = accP.ID;
        c.IAM_from_Registration__c=true;
        c.IAM_Contact_Status__c = 'Active';
        c.CMI_Contact_Type__c = 'Secondary';
        c.IAM_Legacy_User__c = True;
        cons.add(c);
        insert cons;
        
        List<IAM_Contact_Provisioning__c> conProvList = New List<IAM_Contact_Provisioning__c>();
        
        IAM_Contact_Provisioning__c conProv3 = new IAM_Contact_Provisioning__c();
        conProv3.IAM_Contact__c = c.Id;
        conProv3.IAM_Account_Application__c = newApp.Id;
        conProv3.IAM_Application_Name__c = 'Guidanz';
        conProv3.IAM_Role__c = 'Advanced';
        conProv3.IAM_Status__c = System.Label.IAM_Active;
        conProv3.IAM_Start_Date__c = system.today();
        conProv3.IAM_End_Date__c = System.Today() + 365;
        conProv3.IAM_Guidanz_Skip_Validation__c = True;
        conProv3.recordtypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        conProvList.add(conProv3);       
        if(conProvList.size() > 0){
            insert conProvList;
        }        
        Test.stopTest();       
    }
    
    static testMethod void guivalidationFlagMethod(){
        
        List<IAM_Contact_Provisioning__c> conProvListData = [Select Id, IAM_Application_Name__c,IAM_Role__c, IAM_Guidanz_Skip_Validation__c
                                                            FROM IAM_Contact_Provisioning__c WHERE IAM_Application_Name__c = 'Guidanz' Limit 1];
        
        IAM_Guidanz_validationFlag_Queueable iam= new IAM_Guidanz_validationFlag_Queueable(conProvListData);
        Test.StartTest();
        System.enqueueJob(iam);
        Test.StopTest();
    }

}