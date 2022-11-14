//Adding comment for deployment -- Akansha MV_688 8/25/2022

/*********************************************************************************
/*********************************************************************************
Name:  FSL_workorderListTriggerHandle_Test
Copyright © 2021  Cummins
======================================================
======================================================
Purpose:  Test class to cover the code coverage for
		  FSL_CSSP_LoginUserSetup class 	
======================================================
======================================================
History:

Version        Author             Date            Details               
1.0            Rajkumar BT        08/13/2021      INITIAL DEVELOPMENT
//Comment added for deployment - Sep 22 Release
***********************************************************************************/
@isTest
public class FSL_CSSP_LoginUserSetup_Test {
    
    public testMethod static void testMethod1(){
        Id recId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('CSS_WS_RT_Customer_Accounts').getRecordTypeId();
        Account accParent = new Account();
        accParent.Name = 'Test Parent Account';
        accParent.CSS_DistributorCode__c = '12341';
        accParent.IAM_Service_Provider_Code__c = '12341';
        accParent.CMI_Account_Status__c = 'Active';
        accParent.FSL_ERP_Customer_Code__c = '100023-USA';
        accParent.Type='Distributor Account';
        insert accParent;
        
        Contact contParent = new Contact();
        contParent.FirstName = 'Test Parent Contact FN';
        contParent.LastName = 'Test Parent Contact LN';
        contParent.Username__c = 'testparent@test.com';
        contParent.Email = 'testparent@test.com';
        contParent.AccountId = accParent.Id;
        insert contParent;
        
        Account accChild = new Account();
        accChild.Name = 'Test Child Account';
        accChild.CSS_DistributorCode__c = '12342';
        accChild.IAM_Service_Provider_Code__c = '12342';
        accChild.CMI_Account_Status__c = 'Active';
        accChild.FSL_ERP_Customer_Code__c = '100024-USA';
        accChild.ParentId = accParent.Id;
        accChild.IAM_CDH_Sync__c = true;
        insert accChild;
        
        Contact contChild = new Contact();
        contChild.FirstName = 'Test Child Contact FN';
        contChild.LastName = 'Test Child Contact LN';
        contChild.Username__c = 'testchild@test.com';
        contChild.Email = 'testchild@test.com';
        contChild.AccountId = accChild.Id;
        insert contChild;
        
        Id profid = [SELECT Id FROM Profile WHERE Name = 'FSL_Guidanz_Customer_Community_User' LIMIT 1].Id;
        
        User usr = new User();
        usr.ProfileId = profid;
        usr.LastName = 'testUsertwo';
        usr.Email = 'testUser@testEmail.com';
        usr.Username = 'testUser237@testEmail.com';
        usr.CompanyName = 'testCompany';
        usr.Title = 'testTitle';
        usr.Alias = 'testUsr';
        usr.ERP__C = 'BMS';
        usr.TimeZoneSidKey = 'America/Los_Angeles';
        usr.EmailEncodingKey = 'UTF-8';
        usr.LanguageLocaleKey = 'en_US';
        usr.LocaleSidKey = 'en_US';
        usr.IsActive = true;
        usr.ContactId = contChild.Id;
		
        Insert usr;
          test.startTest();
        system.runAs(usr){
            FSL_CSSP_LoginUserSetup.getUserLocation(); 
        }
         test.stopTest();
    }

}