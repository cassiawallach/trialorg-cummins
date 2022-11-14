/************************************************************
Name:  IAM_GuiCreate_PartnerUser_Test
Copyright © 2020  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test Class for IAM_GuiCreate_PartnerUser_Test  
class.                       
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                   DATE              DETAIL                                
1.0 -    Anupam Adhikari       10/02/2022        INITIAL DEVELOPMENT         
******************************************************/
@isTest
public class IAM_GuiCreate_PartnerUser_Test {
    
    @testSetup
    Static Void testDataSetup(){
    
    List<Account> accListToInsert = new List<Account>();
        List<IAM_Application__c> guiAppFeatureList = new List<IAM_Application__c>();
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
        acc1.IAM_Service_Provider_Code__c = '01900';
        acc1.CSS_DBCode__c = '45fg4';
        acc1.CSS_DistributorCode__c = '01001';
        accListToInsert.add(acc1);
        insert accListToInsert;
        
        //Account acc = IAM_TestData.createAccount();
        //Contact con = IAM_TestData.createContact(acc.Id);
        IAM_Application__c accProv1 = IAM_TestData.createAccountSubscription(acc1.Id, 'QuickServe Online', 'QSOL Dealer');
        IAM_Application__c accProv2 = IAM_TestData.createAccountSubscription(acc1.Id, 'EDS', 'Advanced');
        
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
    	c.IAM_Partner_User_Record__c = True;
    	c.IAM_Contact_Owner__c = Null;
        cons.add(c);
        insert cons;
        
        IAM_Application__c accCumpas = IAM_TestData.createAccountSubscription(acc1.Id, 'CUMPAS 2.0', 'Dealer User');
        accCumpas.IAM_Cumpas_Dist_CS_Rep__c = c.Id;
        accCumpas.IAM_Cumpas_Distributor_Sales_Rep__c = c.Id;
        update accCumpas;
        
        List<IAM_Contact_Provisioning__c> conProvList = New List<IAM_Contact_Provisioning__c>();
        IAM_Contact_Provisioning__c conProv1 = new IAM_Contact_Provisioning__c();
        conProv1.IAM_Contact__c= c.Id; 
        conProv1.IAM_Start_Date__c = System.Today();
        conProv1.IAM_End_Date__c = System.Today() + 365;
        conProv1.IAM_Application_Name__c = 'QuickServe Online';
        conProv1.IAM_Role__c = 'QSOL Dealer';
        conProv1.IAM_Qsolexpiration__c = 'IAM-2020';
        conProv1.IAM_License_Type__c = 'Test';
        conProv1.IAM_Status__c = 'Active';
        conProv1.IAM_Account_Application__c = accProv1.Id;
        conProv1.IAM_Subscription_Name__c = 'QuickServeOnline EBU';        
        conProv1.RecordtypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
        conProvList.add(conProv1);
        
        IAM_Contact_Provisioning__c conProv2 = new IAM_Contact_Provisioning__c();
        conProv2.IAM_Contact__c= c.Id; 
        conProv2.IAM_Start_Date__c = System.Today();
        conProv2.IAM_End_Date__c = System.Today() + 365;
        conProv2.IAM_Application_Name__c = 'EDS';
        conProv2.IAM_Role__c = 'Advanced';
        //conProv2.IAM_Qsolexpiration__c = 'IAM-2020';
        conProv2.IAM_License_Type__c = 'Test';
        conProv2.IAM_Status__c = 'Active';
        conProv2.IAM_Account_Application__c = accProv1.Id;
        conProv2.IAM_Subscription_Name__c = 'QuickServeOnline EBU';        
        conProv2.RecordtypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('EDS').getRecordTypeId();
        conProvList.add(conProv2);
        
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
		
        if(conProvList.size() > 0){
            insert conProvList;
        }   
    Test.stopTest();
    }
    
    static testMethod void guidanzPartnerUserCreate(){
        IAM_GuiCreate_PartnerUser sch = new IAM_GuiCreate_PartnerUser();
        sch.execute(null);       
    }
    
    static testMethod void guidanzPtnerUserCreate2(){
        String sRole = 'Technician';
        String sAccType = 'Dealer Account';
        String sPortalRole = IAM_GuiCreate_PartnerUser.portalRoleToAssign(sRole,sAccType);
        
        String sRoles = 'Technician;Advanced';
        String sPortalRoles = IAM_GuiCreate_PartnerUser.portalRoleToAssign(sRoles,sAccType);
    }

}