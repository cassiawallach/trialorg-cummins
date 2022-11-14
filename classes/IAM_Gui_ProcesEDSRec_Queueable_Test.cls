/************************************************************
Name:  IAM_Gui_ProcesEDSRec_Queueable_Test
Copyright © 2020  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test Class for IAM_Guidanz_ProcessEDSRec_Queueable  
class.                       
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                   DATE              DETAIL                                
1.0 -    Anupam Adhikari       21/02/2022        INITIAL DEVELOPMENT         
*****************************************************/
@isTest
public class IAM_Gui_ProcesEDSRec_Queueable_Test {
    
    @testSetup
    Static Void testDataSetup(){
        
        Test.startTest();
        Account acc1=new Account(); 
        acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc1.Name='Account12';
        acc1.Type='Dealer Account';
        //acc1.ParentId=accP.Id;
        acc1.BillingStreet='1260 N MARR ROAD';
        acc1.BillingCity='COLUMBUS';
        acc1.BillingState='Indiana';
        acc1.BillingCountry='United States';
        acc1.BillingPostalCode='47201';
        acc1.IAM_Service_Provider_Code__c = '019900';
        insert acc1;
        
        List<contact> cons=new List<contact>();
        Contact c=new Contact();
        c.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        c.FirstName = 'myfirstn';
        c.LastName ='mylastn';
        c.Email = 'myemail2@abc.com';
        c.Username__c = 'myuserid2@abc.com';
        c.AccountId = acc1.ID;
        c.IAM_from_Registration__c=true;
        c.IAM_Contact_Status__c = 'Active';
        c.CMI_Contact_Type__c = 'Secondary';
        c.IAM_Legacy_User__c = True;
        cons.add(c);
        insert cons;
        
        IAM_Application__c newApp = new IAM_Application__c();
        newApp.IAM_Application_Name__c = 'Guidanz';
        newApp.IAM_Role__c = 'Advanced';
        newApp.IAM_Status__c = System.Label.IAM_Active;
        newApp.IAM_Account_Name__c = acc1.Id;
        newApp.IAM_Subscription_Start_Date__c = system.today();
        newApp.IAM_Subscription_End_Date__c = system.today() + 36500;
        newApp.recordtypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        insert newApp;
        
        List<IAM_Contact_Provisioning__c> conProvList = New List<IAM_Contact_Provisioning__c>();
        IAM_Contact_Provisioning__c conProv3 = new IAM_Contact_Provisioning__c();
        conProv3.IAM_Contact__c = c.Id;
        conProv3.IAM_Account_Application__c = newApp.Id;
        conProv3.IAM_Application_Name__c = 'Guidanz';
        conProv3.IAM_Role__c = 'Advanced';
        conProv3.IAM_Status__c = System.Label.IAM_Active;
        conProv3.IAM_Start_Date__c = system.today();
        conProv3.IAM_End_Date__c = System.Today() + 365;
        //conProv3.IAM_User__c = addConP.IAM_User__c;
        conProv3.recordtypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        conProvList.add(conProv3); 
        
        test.stopTest();
    }
    
    static testMethod void guiProcessEDSRecMethod(){
        
        List<IAM_Contact_Provisioning__c> conProvList = [Select Id, IAM_Role__c, IAM_Contact__c, IAM_Application_Name__c
                                                        FROM IAM_Contact_Provisioning__c
                                                        WHERE IAM_Application_Name__c = 'Guidanz' Limit 1];
        
        IAM_Guidanz_ProcessEDSRec_Queueable iam= new IAM_Guidanz_ProcessEDSRec_Queueable(conProvList);
        Test.StartTest();
        System.enqueueJob(iam);
        Test.StopTest();
    }
}