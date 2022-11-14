/************************************************************
Name:  IAM_RC_DeleteUser_Test
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
Apex Class to make call to ldap to deactivate user.  2                       
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION         AUTHOR                DATE              DETAIL                                
1.0 -    Keerhty Gurumurthy        11/16/2018        INITIAL DEVELOPMENT
1.1 -    Karthik Raj Golakaram     11/16/2020    Made Changes to the class for Mule API Conversion 
1.2 -    Shubhangi Sardar          09/06/2021    LDAP Sync issue change
*****************************************************/
/********************************************************************************
***********************************************************************************/
@isTest
public class IAM_RC_DeleteUser_Test{
    
    /* Delete User Test 1 */
    private static testmethod void deleteUserTest1() {
        IAM_TestData.createIntegrationDetails('IAM_LDAP_User_Delete_Mule');
        User u = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator'
                  AND UserRoleId != null AND IsActive = true LIMIT 1];
        System.runAs(u) {
            Account acc = IAM_TestData.createAccount();
            Contact con = createContact(acc.Id, true, true);
            Set<Id> conIdSet = new Set<Id>();
            conIdSet.add(con.Id);
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', 'Success', null));
            Test.startTest();
            IAM_RC_DeleteUser.basicAuthCallout(conIdSet);
            Test.stopTest();
        }
    }
    
    /* Delete User Test 2 */
    private static testmethod void deleteUserTest2() {
    IAM_TestData.createIntegrationDetails('IAM_LDAP_User_Delete_Mule');
        User u = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator'
                  AND UserRoleId != null AND IsActive = true LIMIT 1];
        System.runAs(u) {
            Account acc = IAM_TestData.createAccount();
            Contact con = createContact(acc.Id, false, false);
            Set<Id> conIdSet = new Set<Id>();
            conIdSet.add(con.Id);
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', 'Success', null));
            Test.startTest();
            IAM_RC_DeleteUser.basicAuthCallout(conIdSet);
            Test.stopTest();
        }
    }
    
    /* Delete User Test 3 */
    private static testmethod void deleteUserTest3() {
    IAM_TestData.createIntegrationDetails('IAM_LDAP_User_Delete_Mule');
        User u = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator'
                  AND UserRoleId != null AND IsActive = true LIMIT 1];
        System.runAs(u) {
            Account acc = IAM_TestData.createAccount();
            Contact con = createContact(acc.Id, true, false);
            Set<Id> conIdSet = new Set<Id>();
            conIdSet.add(con.Id);
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', 'Success', null));
            Test.startTest();
            IAM_RC_DeleteUser.basicAuthCallout(conIdSet);
            Test.stopTest();
        }
    }
    
    /* Delete User Test 4 */
    private static testmethod void deleteUserTest4() {
    IAM_TestData.createIntegrationDetails('IAM_LDAP_User_Delete_Mule');
        User u = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator'
                  AND UserRoleId != null AND IsActive = true LIMIT 1];
        System.runAs(u) {
            Account acc = IAM_TestData.createAccount();
            Contact con = createContact(acc.Id, true, false);
            Set<Id> conIdSet = new Set<Id>();
            conIdSet.add(con.Id);
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(400, 'Error', '{"errorDescription" : "test error", "errorCode" : "1" }', null));
            Test.startTest();
            IAM_RC_DeleteUser.basicAuthCallout(conIdSet);
            Test.stopTest();
        }
    }
    
    /* Create test contact data */
    public static Contact createContact(Id accId, Boolean legacyUser, Boolean internal) {
    IAM_TestData.createIntegrationDetails('IAM_LDAP_User_Delete_Mule');
        Contact con = new contact();
        con.AccountId = accId;
        con.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        con.FirstName = 'Fname';
        con.LastName = 'Lname';
        con.Email = 'fnamelname@test.com';
        con.Username__c = 'fnamelname@test.com';
        con.phone = '1112223335';
        con.IAM_Contact_Status__c = 'Active';
        con.IAM_Legacy_User__c = legacyUser;
        con.IAM_Internal__c = internal;
        insert con;
        return con;
    }
    
    /*static testMethod void testMethod1(){
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.IAM_Service_Provider_Code__c = '123';
        acc.Type = 'Distributor Account';
        acc.CSS_DistributorCode__c = '1234';
        acc.CSS_DBCode__c = '12345';
        acc.CSS_DealerCode__c = '456';
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
        Con.IAM_Cummins_login_ID__c = 'test_user_helper@eidm.com';
        insert con;
        
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
        Con1.IAM_Cummins_login_ID__c = 'test_user_helper1@eidm.com';
        insert con1;
        
        Contact con2 = new contact();
        con2.lastName = 'TestContact2';
        con2.AccountId = acc.id;
        con2.firstName = 'firstContact';
        con2.Email = 'testContact@test.com';
        con2.IAM_Contact_Status__c = System.Label.IAM_Status_Active;
        con2.phone = '8989898989';
        con2.IAM_Applications__c = 'abcd';
        con2.IAM_Qsolexpiration__c = 'testABC';
        con2.IAM_swregexpire__c ='testCon';
        con2.IAM_Qsolview__c = 'testCon';
        con2.IAM_Final_Approver__c = 'Y';
        con2.IAM_Legacy_User__c = true;
        Con2.IAM_Cummins_login_ID__c = 'test_user_helper2@eidm.com';
        insert con2;
        
        List<Contact> lstCont = new List<Contact> ();
        lstCont.add(con);
        lstCont.add(con1);
        lstCont.add(con2);
        Set<Id> setIds = new Set<Id>();
        for(Contact cont : lstCont){
            setIds.add(cont.id);
        }
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
        
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
        System.RunAs(usr){
            Test.startTest();
                IAM_RC_DeleteUser.UserPayload usrPayLoad = new IAM_RC_DeleteUser.UserPayload(lstCont);
                Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
                IAM_RC_DeleteUser.basicAuthCallout(setIds);
                
            Test.stopTest();
        }
    }
    static testMethod void testMethod2(){
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
        System.RunAs(usr){
            Test.startTest();
                IAM_RC_DeleteUser iamRC = new IAM_RC_DeleteUser();
                IAM_RC_DeleteUser.UserApp userInfo = new IAM_RC_DeleteUser.UserApp();
                userInfo.uid = 'test_user_helper@eidm.com';
                userInfo.branch = System.Label.IAM_Value_Internal;
                userInfo.usertype = System.Label.IAM_Value_Internal;
            Test.stopTest();
        }
    }*/
}