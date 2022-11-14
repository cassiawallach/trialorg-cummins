/*************************************************************************************
Name:  IAM_autoRenewschedulableBatch_Test
Copyright © 2019  Cummins
**************************************************************************************
Purpose: Test class for IAM_autoRenewschedulableBatch_Test
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION       AUTHOR                  DATE               DETAIL                                
1.0      Lavanya Javvadi          02/10/2022        INITIAL DEVELOPMENT
**************************************************************************************
**************************************************************************************/
@isTest
public class IAM_autoRenewschedulableBatch_Test{
	@isTest
    public static void AutorenewSubscriptionsTestMethod() {
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id); 
        List<IAM_Application__c> app= new List<IAM_Application__c>();
        List<IAM_Contact_Provisioning__c> icp= new List<IAM_Contact_Provisioning__c>();
        
        IAM_Application__c app1 = new IAM_Application__c();
        app1.IAM_Application_Name__c = 'QuickServe Online';
        app1.RecordTypeId=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
        app1.IAM_Role__c = 'Technician';
        app1.IAM_Status__c = 'Active';
        app1.IAM_Account_Name__c = acc.id;
        app1.IAM_Subscription_Name__c = 'test';
        app1.IAM_Subscription_Start_Date__c=System.today();
        app1.IAM_Subscription_End_Date__c= System.today() + 3;
        app1.IAM_Subscription_Count__c = 10;
        app1.IAM_Free_Subscription__c= true;
        app1.IAM_License_Type__c = 'test';
        app1.IAM_Qsolexpiration__c = 'test';
        app1.IAM_Cumpas_Modularity__c = 'Core Swap';
        app1.IAM_Source__c = 'Marketplace';
        insert app1;
        
        IAM_Application__c app2 = new IAM_Application__c();
        app2.IAM_Application_Name__c = 'QuickServe Online';
        app2.RecordTypeId=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
        app2.IAM_Role__c = 'Technician';
        app2.IAM_Status__c = 'Inactive';
        app2.IAM_Account_Name__c = acc.id;
        app2.IAM_Subscription_Name__c = 'test';
        app2.IAM_Subscription_Start_Date__c=System.today();
        app2.IAM_Subscription_End_Date__c= System.today()+1;
        app2.IAM_Subscription_Count__c = 10;
        app2.IAM_Free_Subscription__c= true;
        app2.IAM_License_Type__c = 'test';
        app2.IAM_Qsolexpiration__c = 'test';
        app1.IAM_Cumpas_Modularity__c = 'View Credit';
        app2.IAM_Source__c = 'Marketplace';
        insert app2;
        app.add(app1);
              
        IAM_Contact_Provisioning__c obj = new IAM_Contact_Provisioning__c();
        obj.IAM_Contact__c= con.id; 
        obj.IAM_Start_Date__c = System.today();
        obj.IAM_End_Date__c = System.today()+1;
        obj.IAM_Application_Name__c = 'QuickServe Online';
        obj.IAM_Role__c = 'QSOL Distributor';
        obj.IAM_License_Type__c = 'test';
        obj.IAM_Status__c = 'Inactive';
        obj.IAM_Account_Application__c = app2.id;
        obj.IAM_Subscription_Name__c = 'test'; 
        obj.IAM_Reject_Reason__c ='Subscription Expired';
        obj.RecordtypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();   
        User u = [select id, Name, ProfileId, isActive  from User where Profile.Name = 'System Administrator' and isActive=true limit 1];
        System.runAs(u){
            insert obj;
        }
        icp.add(obj);
        
        Test.startTest();
        IAM_autoRenewschedulableBatch obj1 = new IAM_autoRenewschedulableBatch();
        DataBase.executeBatch(obj1); 
        Test.stopTest();	
    } 
}