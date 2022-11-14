/************************************************************
Name:  IAM_RC_UserGroupMapping_Test
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This Class is for outbound API to add user to LDAP groups 2                        
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION         AUTHOR                DATE              DETAIL                                
1.0 -    Keerthy Gurutmurthy       11/16/2018        INITIAL DEVELOPMENT
1.1 -    Karthik Raj Golakaram     11/16/2020     Made Changes for Mule API
1.2 -    Shubhangi Sardar          09/06/2019     LDAP Changes   
*****************************************************/
/********************************************************************************
***********************************************************************************/
@isTest
public class IAM_RC_UserGroupMapping_Test{
    @testSetup static void dataSetup(){
        IAM_TestData.createIntegrationDetails('IAM_LDAP_Group_Addition_Mule');
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.IAM_Service_Provider_Code__c = '123';
        acc.Type = 'Distributor Account';
        acc.CSS_DistributorCode__c = '1234';
        acc.CSS_DBCode__c = '12345';
        acc.CSS_DealerCode__c = '456';
        insert acc;
        List<Contact> conList = new List<Contact>();
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
        conList.add(Con);
        
        Contact con1 = new contact();
        con1.lastName = 'TestContact1';
        con1.AccountId = acc.id;
        con1.firstName = 'firstContact';
        con1.Email = 'testContact@test.com';
        con1.IAM_Contact_Status__c = System.Label.IAM_Status_Active;
        con1.phone = '8989898989';
        con1.IAM_Applications__c = 'abcd';
        con1.IAM_Qsolexpiration__c = 'testABC';
        con1.IAM_swregexpire__c ='testCon';
        con1.IAM_Qsolview__c = 'testCon';
        con1.IAM_Final_Approver__c = 'Y';
        con1.IAM_Internal__c = true;
        con1.IAM_Legacy_User__c = true;
        Con1.Username__c = 'test_user_helper1@eidm.com';
        conList.add(Con1);
        
        Contact con2 = new contact();
        con2.lastName = 'TestContact1';
        con2.AccountId = acc.id;
        con2.firstName = 'firstContact';
        con2.Email = 'testContact@test.com';
        con2.IAM_Contact_Status__c = System.Label.IAM_Inactive_Label;
        con2.phone = '8989898989';
        con2.IAM_Applications__c = 'abcd';
        con2.IAM_Qsolexpiration__c = 'testABC';
        con2.IAM_swregexpire__c ='testCon';
        con2.IAM_Qsolview__c = 'testCon';
        con2.IAM_Final_Approver__c = 'Y';
        con2.IAM_Legacy_User__c = true;
        con2.IAM_Work_Group_Id__c = '';
        Con2.Username__c = 'test_user_helper2@eidm.com';
        conList.add(Con2);
        insert conList;
        
        IAM_Application__c app5 = new IAM_Application__c();
        app5.IAM_Application_Name__c = System.Label.IAM_AppName_QSOL;
        app5.IAM_Role__c = 'QSOL Dealer';
        app5.IAM_Status__c = 'Active';
        app5.IAM_Account_Name__c = acc.id;
        app5.IAM_Subscription_Name__c = 'test';
        app5.IAM_Qsolexpiration__c = 'test expire';
        app5.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get(System.Label.IAM_AppName_QSOL).getRecordTypeId();
        insert app5;
        
        List<IAM_Contact_Provisioning__c> conProList = new List<IAM_Contact_Provisioning__c>();
        IAM_Contact_Provisioning__c conApp4 = new IAM_Contact_Provisioning__c();
        conApp4.IAM_Application_Name__c = app5.IAM_Application_Name__c;
        conApp4.IAM_Role__c = 'QSOL Dealer';
        conApp4.IAM_Status__c = 'Active';
        conApp4.IAM_Contact__c = con.id; 
        conApp4.IAM_Account_Application__c = app5.id;
        conApp4.IAM_Qsolexpiration__c = 'test expire';
        conApp4.IAM_DA_Customer_List__c = '123456';
        conApp4.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get(System.Label.IAM_AppName_QSOL).getRecordTypeId();
        conProList.add(conApp4);
        
        IAM_Contact_Provisioning__c conApp5 = new IAM_Contact_Provisioning__c();
        conApp5.IAM_Application_Name__c = app5.IAM_Application_Name__c;
        conApp5.IAM_Role__c = 'QSOL Dealer';
        conApp5.IAM_Status__c = 'Active';
        conApp5.IAM_Contact__c = con1.id; 
        conApp5.IAM_Account_Application__c = app5.id;
        conApp5.IAM_Qsolexpiration__c = 'test expire';
        conApp5.IAM_DA_Customer_List__c = '123456';
        conApp5.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get(System.Label.IAM_AppName_QSOL).getRecordTypeId();
        conProList.add(conApp5);
        
        IAM_Contact_Provisioning__c conApp6 = new IAM_Contact_Provisioning__c();
        conApp6.IAM_Application_Name__c = app5.IAM_Application_Name__c;
        conApp6.IAM_Role__c = 'QSOL Dealer';
        conApp6.IAM_Status__c = 'Active';
        conApp6.IAM_Contact__c = con2.id; 
        conApp6.IAM_Account_Application__c = app5.id;
        conApp6.IAM_Qsolexpiration__c = 'test expire';
        conApp6.IAM_DA_Customer_List__c = '123456';
        conApp6.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get(System.Label.IAM_AppName_QSOL).getRecordTypeId();
        conProList.add(conApp6);
        insert conProList;
        
        CSS_Integration_Details__c css_intg = new CSS_Integration_Details__c();
        css_intg.Name = 'IAM_LDAP_oAuth';
        css_intg.ApplicationName__c = 'IAM_LDAP_oAuth';
        css_intg.IsActive__c = true;
        css_intg.End_Point__c = 'https://services-dev-oauth.cummins.com/api/oauth/token/ldaputil';
        css_intg.Key__c = 'thAQWe/AIgUevs8IGTdk4Ddx50z3F9xiqm2Hl/QMu/MuVcRJFcWzFgYxxXvpN2LZEs43hkxTJ3t67B0nx7a1qg==';
        css_intg.Username__c = 'Z7xm9X6ImVl6ND7zTJ2j/jScb740y2NP/TOoSV9vC+U=';
        css_intg.Passcode__c = 'Il3eUr1gk32ejCbujtRoFDgyeVhp+MdwlVe5n/L2Tlk3uQejsj9shK0YOC5Dy/k5HFxa4Ac6EexF+dRmHCEl8Q==';
        css_intg.AuthEnv__c = 'OAGoAuth';
        css_intg.Logging__c = 'LDAPUtil';
        css_intg.Method_Type__c = 'POST';
        css_intg.Timeout__c = 120000;
        insert css_intg;
        
        IAM_Application_Groups__c iamAppGrp2 = new IAM_Application_Groups__c ();
        iamAppGrp2.IAM_Application_Name__c = System.Label.IAM_AppName_QSOL;
        iamAppGrp2.IAM_Role_Name__c = 'QSOL Dealer';
        iamAppGrp2.IAM_DN_value__c = 'cn=QuickServe_Dealers,ou=APP_QuickServe,ou=application,dc=cummins,dc=com';
        iamAppGrp2.Name = System.Label.IAM_AppName_QSOL;
        iamAppGrp2.IAM_Group_Type__c = 'static';
        insert iamAppGrp2; 
    }

    static testMethod void errorResponse(){
        Test.startTest();
        try {
            Set<Id> setIds = new Set<Id>();
            Map<id,String> deleteRole = new Map<id,String>();
            for(IAM_Contact_Provisioning__c contProv : [SELECT Id FROM IAM_Contact_Provisioning__c]){
                setIds.add(contProv.id);
                deleteRole.put(contProv.id, 'QSOL Dealer');
            }        
            
            String body = '{"totalSize": 0,"errorDescription": "Unknown Service Training ID","records": {}}';
            User usr = [Select id from User where Id = :UserInfo.getUserId()];
            System.RunAs(usr){
                Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(400, 'Error', body, null));
                IAM_RC_UserGroupMapping.basicAuthCallout(setIds,deleteRole,false);
            }
        } catch(Exception e) {
            System.debug('#### - '+e.getMessage());
        }
        Test.stopTest();
    }

    static testMethod void successResponse(){
        Test.startTest();
        try {
            Set<Id> setIds = new Set<Id>();
            Map<id,String> deleteRole = new Map<id,String>();
            for(IAM_Contact_Provisioning__c contProv : [SELECT Id FROM IAM_Contact_Provisioning__c]){
                setIds.add(contProv.id);
                deleteRole.put(contProv.id, 'QSOL Dealer');
            }        
            
            String body = '[{"uid":"test04061@test.com","status":"User has been successfully added in LDAP group.","reason": ""}]';
            User usr = [Select id from User where Id = :UserInfo.getUserId()];
            System.RunAs(usr){
                Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', body, null));
                IAM_RC_UserGroupMapping.basicAuthCallout(setIds,deleteRole,false);
            }
        } catch(Exception e) {
            System.debug('#### - '+e.getMessage());
        }
        Test.stopTest();
    }
    
    static testMethod void testMethod2(){
        Test.startTest();
        try {
            IAM_TestData.createIntegrationDetails('IAM_LDAP_Group_Addition_Mule');
            IAM_RC_UserGroupMapping.UserApp userInfo = new IAM_RC_UserGroupMapping.UserApp();
            userInfo.uid = 'test_user_helper@eidm.com1';
            userInfo.branch = System.Label.IAM_Value_Internal;
            userInfo.usertype = System.Label.IAM_Value_Internal;
            userInfo.applicationGroups = System.Label.IAM_Value_Internal;
            userInfo.grouptype = 'test';
            userInfo.workgroupId = '12345-12345-P';
        } catch(Exception e) {
            System.debug('#### - '+e.getMessage());
        } 
        Test.stopTest();       
    }
    
}