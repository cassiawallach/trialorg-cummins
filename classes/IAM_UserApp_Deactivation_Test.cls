/************************************************************
Name:  IAM_UserApp_Deactivation
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
Below class will be invoked from the trigger of IAM_Contact_Provisioning__c and will pickup  all the records
and for loop will be present in order to execute for each record and apex transactions will have 100 callouts. 2                       
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION         AUTHOR                DATE              DETAIL                                
1.0 -    Karthik Raj Golakaram     11/16/2018        INITIAL DEVELOPMENT
1.1 -    Karthik Raj Golakaram     11/16/2020    Made Changes to the class for Mule API Conversion 
                                                 Also Made changes for username that needs to be send in API.       
*****************************************************/
/********************************************************************************
***********************************************************************************/
@isTest
Private class IAM_UserApp_Deactivation_Test{
     @TestSetup
     static void Testdata(){
        IAM_TestData.createIntegrationDetails('IAM_User_Deactivation_Cumpas_Mule');
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.IAM_Service_Provider_Code__c = '12332';
        acc.Type = 'Distributor Account';
        acc.CSS_DistributorCode__c = '12332';
        acc.CSS_DBCode__c = '12345';
        acc.CSS_DealerCode__c = '12332';
        insert acc;
        
        Contact con = new contact();
        con.lastName = 'TestContact';
        con.AccountId = acc.id;
        con.firstName = 'firstContact';
        con.Email = 'testContact@test.com';
        con.IAM_Contact_Status__c = System.Label.IAM_Status_Active;
        con.phone = '8989898989';
        con.IAM_Applications__c = 'abcd';
        con.IAM_Qsolexpiration__c = 'testABC';
        con.IAM_swregexpire__c ='testCon';
        con.IAM_Qsolview__c = 'testCon';
        con.IAM_Final_Approver__c = 'Y';
        Con.Username__c = 'test_user_helper@eidm.com';
        insert con;
        
        
               
        IAM_Application__c app5 = new IAM_Application__c();
        app5.IAM_Application_Name__c ='CUMPAS 2.0';
        app5.IAM_Role__c = 'Dealer User';
        app5.IAM_Status__c = 'Active';
        app5.IAM_Account_Name__c = acc.id;
        app5.IAM_Cumpas_Modularity__c='Parts Order';
        app5.IAM_Subscription_Name__c = 'test';
        app5.IAM_Qsolexpiration__c = 'test expire';
        app5.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get('CUMPAS 2.0').getRecordTypeId();
        insert app5;
        
        IAM_Contact_Provisioning__c conApp4 = new IAM_Contact_Provisioning__c();
        conApp4.IAM_Application_Name__c = app5.IAM_Application_Name__c;
        conApp4.IAM_Role__c = 'Dealer User';
        conApp4.IAM_Status__c = 'Active';
        conApp4.IAM_Cumpas_Modularity__c='Parts Order';
        conApp4.IAM_Contact__c = con.id; 
        conApp4.IAM_Account_Application__c = app5.id;
        conApp4.IAM_Qsolexpiration__c = 'test expire';
        conApp4.IAM_DA_Customer_List__c = '123456';
        conApp4.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get('CUMPAS 2.0').getRecordTypeId();
        insert conApp4;
        }
        
        Static testMethod void testmethod1(){
        
        
        Set<id> appIds= new Set<id>();
        IAM_Contact_Provisioning__c conApp=[Select id,IAM_Status__c from IAM_Contact_Provisioning__c where IAM_Application_Name__c='CUMPAS 2.0' and IAM_Status__c='Active'];
        appIds.add(conApp.id);
        
        IAM_UserApp_Deactivation.deactivateCallOut(appIds);
        }     
}