/************************************************************
Name:  IAM_Guidanz_PSAssign_Queueable_Test
Copyright © 2020  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test Class for IAM_Guidanz_PSAssign_Queueable  
class.                       
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                   DATE              DETAIL                                
1.0 -    Anupam Adhikari       24/01/2022        INITIAL DEVELOPMENT         
*****************************************************/
@isTest
public class IAM_Guidanz_PSAssign_Queueable_Test {
    
    @testSetup
    Static Void testDataSetup(){
        
        List<Account> accListToInsert = new List<Account>();
        Test.startTest();
        Account accP=new Account();
        accP.Name='AccountPp';
        accP.Type='Distributor Account';
        accP.BillingStreet='1260 N MARR ROAD';
        accP.BillingCity='COLUMBUS';
        accP.BillingState='Indiana';
        accP.BillingCountry='United States';
        accP.BillingPostalCode='47201';    
        insert accP;        
        
        Account acc1=new Account(); 
        acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc1.Name='Account12';
        acc1.Type='Dealer Account';
        acc1.ParentId=accP.Id;
        acc1.BillingStreet='1260 N MARR ROAD';
        acc1.BillingCity='COLUMBUS';
        acc1.BillingState='Indiana';
        acc1.BillingCountry='United States';
        acc1.BillingPostalCode='47201';
        accListToInsert.add(acc1);
        insert accListToInsert;
        
        List<IAM_Application__c> guiAppFeatureList = new List<IAM_Application__c>();
        IAM_Application__c newApp = new IAM_Application__c();
        newApp.IAM_Application_Name__c = 'Guidanz';
        newApp.IAM_Role__c = 'Advanced';
        newApp.IAM_Status__c = System.Label.IAM_Active;
        newApp.IAM_Account_Name__c = acc1.Id;
        newApp.IAM_Subscription_Start_Date__c = system.today();
        newApp.IAM_Subscription_End_Date__c = system.today() + 36500;
        newApp.recordtypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        guiAppFeatureList.add(newApp);
        insert guiAppFeatureList;
        
        List<contact> cons=new List<contact>();
        Contact c=new Contact();
        c.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        c.FirstName = 'myfirstn';
        c.LastName ='mylastn';
        c.Email = 'myemail2@abc.com';
        c.Username__c = 'myuserid2@abc.com';
        c.AccountId = accListToInsert[0].ID;
        c.IAM_from_Registration__c=true;
        c.IAM_Contact_Status__c = 'Active';
        c.CMI_Contact_Type__c = 'Secondary';
        cons.add(c);
        
        Contact c2=new Contact();
        c2.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        c2.FirstName = 'mySecondn';
        c2.LastName ='mySecondLastn';
        c2.Email = 'myemail2@xyz.com';
        c2.Username__c = 'myuserid2@xyz.com';
        c2.AccountId = accListToInsert[0].ID;
        c2.IAM_from_Registration__c=true;
        c2.IAM_Contact_Status__c = 'Active';
        c2.CMI_Contact_Type__c = 'Secondary';
        cons.add(c2);
        insert cons;
        
        Id profId  = [SELECT Id,Name FROM Profile Where name = 'IAM_User_Community_License'].Id;
        
        List<User> userListInsert = New List<User>();
		User uesrSampleRecord = new User(
        LastName = 'lstTest',
        FirstName = 'frstTest',
        Email = 'lstTest@test.com',
        Alias = 'lsTest',
        Username = 'lstTest@test.com',
        CommunityNickname = 'lstest1234',
        LocaleSidKey= 'en_US',
        TimeZoneSidKey ='GMT',
        ProfileID = profId,
        LanguageLocaleKey = 'en_US',
        EmailEncodingKey = 'UTF-8',
        contactId = c.Id,
        isActive = true
    );
        userListInsert.add(uesrSampleRecord);
    //insert uesrSampleRecord;
        
		User uesrSampleRecord2 = new User(
        LastName = 'lstTestGui',
        FirstName = 'frstTestGui',
        Email = 'lstTest@testGui.com',
        Alias = 'lsTester',
        Username = 'lstTest@testGui.com',
        CommunityNickname = 'lstest1234987',
        LocaleSidKey= 'en_US',
        TimeZoneSidKey ='GMT',
        ProfileID = profId,
        LanguageLocaleKey = 'en_US',
        EmailEncodingKey = 'UTF-8',
        contactId = c2.Id,
        isActive = true
    );
        userListInsert.add(uesrSampleRecord2);
        insert uesrSampleRecord;
        
        List<IAM_Contact_Provisioning__c> conProvList = New List<IAM_Contact_Provisioning__c>();
        IAM_Contact_Provisioning__c conProv3 = new IAM_Contact_Provisioning__c();
        conProv3.IAM_Contact__c = c.Id;
        conProv3.IAM_Account_Application__c = guiAppFeatureList[0].Id;
        conProv3.IAM_Application_Name__c = 'Guidanz';
        conProv3.IAM_Role__c = 'Advanced';
        conProv3.IAM_Status__c = System.Label.IAM_Active;
        conProv3.IAM_Start_Date__c = system.today();
        conProv3.IAM_End_Date__c = System.Today() + 365;
        //conProv3.IAM_User__c = addConP.IAM_User__c;
        conProv3.recordtypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
		conProvList.add(conProv3);
        
        IAM_Contact_Provisioning__c conProv4 = new IAM_Contact_Provisioning__c();
        conProv4.IAM_Contact__c = c2.Id;
        conProv4.IAM_Account_Application__c = guiAppFeatureList[0].Id;
        conProv4.IAM_Application_Name__c = 'Guidanz';
        conProv4.IAM_Role__c = 'Technician';
        conProv4.IAM_Status__c = System.Label.IAM_Active;
        conProv4.IAM_Start_Date__c = system.today();
        conProv4.IAM_End_Date__c = System.Today() + 365;
        //conProv3.IAM_User__c = addConP.IAM_User__c;
        conProv4.recordtypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
		conProvList.add(conProv4);
		
        if(conProvList.size() > 0){
            insert conProvList;
        }        
        Test.stopTest();
    }
    
    static testMethod void guidanzconPSAssign(){
        Set<Id> activeContactId = new Set<Id>();
        Map<Id, Id> mapConIdNewUser = New Map<Id, Id>();
        
        List<Contact> conListOfPartnerAcc = [Select Id, IAM_Contact_Status__c, IAM_Contact_Owner__c, IAM_Legacy_User__c FROM Contact WHERE 
                              (IAM_Contact_Status__c =: System.Label.IAM_Active OR IAM_Contact_Status__c =: System.Label.IAM_Reclaim)];
        if(conListOfPartnerAcc.size() > 0){
            for(Contact con : conListOfPartnerAcc){
                activeContactId.add(con.Id);
            }
        }
        
        List<IAM_Contact_Provisioning__c> guiConProvList = [Select Id, IAM_Role__c, IAM_User__c, IAM_Contact__c,
                                                            IAM_Contact__r.IAM_Contact_Owner__c
                                                           FROM IAM_Contact_Provisioning__c 
                                                            WHERE IAM_Contact__c IN : activeContactId];
        for(IAM_Contact_Provisioning__c cp : guiConProvList){
            if(!mapConIdNewUser.containsKey(cp.IAM_Contact__c)){
                mapConIdNewUser.put(cp.IAM_Contact__c, cp.IAM_Contact__r.IAM_Contact_Owner__c);
            }
        }
        
        IAM_Guidanz_PSAssign_Queueable iam= new IAM_Guidanz_PSAssign_Queueable(guiConProvList,mapConIdNewUser,guiConProvList);
        Test.StartTest();
        System.enqueueJob(iam);
        Test.StopTest();
    }

}