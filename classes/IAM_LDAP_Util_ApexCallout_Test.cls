/************************************************************
Name:  IAM_LDAP_Util_ApexCallout_Test
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
Below class will make maily three parts. LDAP oAuthcall. call request builder class to build JSON request and parser class to parse the JSON.
JSON mainly consists of the data regarding the Contact.   Test Class   2                  
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION         AUTHOR                DATE              DETAIL                                
1.0 -    Keerthy Gutumurthy        11/16/2018        INITIAL DEVELOPMENT
1.1 -    Karthik Raj Golakaram     11/16/2020     Made changes for Mule API
1.2 -    Shubhangi Sardar          09/06/2021     LDAP Changes   
*****************************************************/
/********************************************************************************
***********************************************************************************/
@IsTest
public class IAM_LDAP_Util_ApexCallout_Test {

    
    /* Contact Insert Test */
    static testmethod void callToLdapInsertTest() {
        //IAM_TestData.createIntegrationDetails('IAM_LDAP_Create_Mule');
        CSS_Integration_Details__c csID = new CSS_Integration_Details__c();
        csID.NAme='IAM_LDAP_Create_Mule';
        csID.ApplicationName__c ='IAM_LDAP_Create_Mule';
        csID.End_Point__c = 'https://api-ue-stgnf3-aw-ex.cummins.com:443/salesforce-iam/oracle/ldap/users';
        csId.IsActive__c = true;
        csID.Key__c='aTXBeE+tyTWiUbDFCRc2JRg3FMv/SjyW2I8erCZM0tg=';
        csID.Passcode__c = 'aTXBeE+tyTWiUbDFCRc2JRg3FMv/SjyW2I8erCZM0tg=';
        csId.Username__c = 'aTXBeE+tyTWiUbDFCRc2JRg3FMv/SjyW2I8erCZM0tg=';
        csId.Logging__c ='LADAPUtil';
        csId.AuthEnv__c = 'MuleIAM';
        csId.Method_Type__c = 'POST';
        csId.grant_type__c = 'client_credentials';
        csID.Resource__c = 'https://api-ue-stgnf-aw-ex.cummins.com/salesforce-iam';
        insert csID;
        
        User u = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator'
                  AND UserRoleId != null AND IsActive = true LIMIT 1];
        System.runAs(u) {
            Account acc = IAM_TestData.createAccount();
            Contact con = IAM_TestData.createContact(acc.Id);
            Set<Id> conIdSet = new Set<Id>();
            conIdSet.add(con.Id);
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', Label.IAM_LDAP_Success_Messgae, null));
            IAM_LDAP_Util_Wrapper ldapResponse = new IAM_LDAP_Util_Wrapper();
            IAM_LDAP_Util_ApexCallout.sendToLDAP(conIdSet, 'Insert');
            Test.stopTest();
        }
    }
    
    /* Contact Update Test */
    static testmethod void callToLdapUpdateTest() {
        //IAM_TestData.createIntegrationDetails('IAM_LDAP_Update_Mule');
         CSS_Integration_Details__c csID = new CSS_Integration_Details__c();
        csID.NAme='IAM_LDAP_Create_Mule';
        csID.ApplicationName__c ='IAM_LDAP_Create_Mule';
        csID.End_Point__c = 'https://api-ue-stgnf3-aw-ex.cummins.com:443/salesforce-iam/oracle/ldap/users';
        csId.IsActive__c = true;
        csID.Key__c='aTXBeE+tyTWiUbDFCRc2JRg3FMv/SjyW2I8erCZM0tg=';
        csID.Passcode__c = 'aTXBeE+tyTWiUbDFCRc2JRg3FMv/SjyW2I8erCZM0tg=';
        csId.Username__c = 'aTXBeE+tyTWiUbDFCRc2JRg3FMv/SjyW2I8erCZM0tg=';
        csId.Logging__c ='LADAPUtil';
        csId.AuthEnv__c = 'MuleIAM';
        csId.Method_Type__c = 'POST';
        csId.grant_type__c = 'client_credentials';
        csID.Resource__c = 'https://api-ue-stgnf-aw-ex.cummins.com/salesforce-iam';
        insert csID;
        
        User u = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator'
                  AND UserRoleId != null AND IsActive = true LIMIT 1];
        System.runAs(u) {
            Account acc = IAM_TestData.createAccount();
            Contact con = IAM_TestData.createContact(acc.Id);
            con.Username__c = 'test@test.com';
            update con;
            Set<Id> conIdSet = new Set<Id>();
            conIdSet.add(con.Id);
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', Label.IAM_LDAP_Success_Messgae, null));
            IAM_LDAP_Util_ApexCallout.sendToLDAP(conIdSet, 'Update');
            Test.stopTest();
        }
    }
    
    /* Exception Test */
    static testmethod void callToLdapExceptionTest() {
        //IAM_TestData.createIntegrationDetails('IAM_LDAP_Create_Mule');
        CSS_Integration_Details__c csID = new CSS_Integration_Details__c();
        csID.NAme='IAM_LDAP_Create_Mule';
        csID.ApplicationName__c ='IAM_LDAP_Create_Mule';
        csID.End_Point__c = 'https://api-ue-stgnf3-aw-ex.cummins.com:443/salesforce-iam/oracle/ldap/users';
        csId.IsActive__c = true;
        csID.Key__c='aTXBeE+tyTWiUbDFCRc2JRg3FMv/SjyW2I8erCZM0tg=';
        csID.Passcode__c = 'aTXBeE+tyTWiUbDFCRc2JRg3FMv/SjyW2I8erCZM0tg=';
        csId.Username__c = 'aTXBeE+tyTWiUbDFCRc2JRg3FMv/SjyW2I8erCZM0tg=';
        csId.Logging__c ='LADAPUtil';
        csId.AuthEnv__c = 'MuleIAM';
        csId.Method_Type__c = 'POST';
        csId.grant_type__c = 'client_credentials';
        csID.Resource__c = 'https://api-ue-stgnf-aw-ex.cummins.com/salesforce-iam';
        insert csID;
        
        User u = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator'
                  AND UserRoleId != null AND IsActive = true LIMIT 1];
        System.runAs(u) {
            Account acc = IAM_TestData.createAccount();
            Contact con = IAM_TestData.createContact(acc.Id);
            Set<Id> conIdSet = new Set<Id>();
            conIdSet.add(con.Id);
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(400, 'Error', 'Error', null));
            IAM_LDAP_Util_ApexCallout.sendToLDAP(conIdSet, 'Insert');
            Test.stopTest();
        }
    }
    
    /* Ldap Reclaim Insert Call */
    static testmethod void ldapReclaimInsertCall() {
        //IAM_TestData.createIntegrationDetails('IAM_LDAP_Create_Mule');
        
        User usr = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator'
                  AND UserRoleId != null AND IsActive = true LIMIT 1];
        System.runAs(usr) {
            Account acc = IAM_TestData.createAccount();
            Contact con = IAM_TestData.createContact(acc.Id);
            Set<Id> conIdSet = new Set<Id>();
            conIdSet.add(con.Id);
            IAM_TestData.createUser(con);
            User u = [SELECT Id, Username FROM User WHERE Username =: con.Username__c];
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', Label.IAM_LDAP_Success_Messgae, null));
            IAM_LDAP_Util_ApexCallout.sendToLDAP(conIdSet, 'Insert');
            Test.stopTest();
        }
    }
    
    /* Ldap Reclaim Update Call */
    static testmethod void ldapReclaimUpdateCall() {
        //IAM_TestData.createIntegrationDetails('IAM_LDAP_Update_Mule');
        
        User usr = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator'
                  AND UserRoleId != null AND IsActive = true LIMIT 1];
        System.runAs(usr) {
            Account acc = IAM_TestData.createAccount();
            Contact con = IAM_TestData.createContact(acc.Id);
            con.Username__c = 'test@test.com';
            update con;
            IAM_TestData.createUser(con);
            //Changing the query because of the error in production.
            User u = [SELECT Id, Username FROM User WHERE  Contact.Id=: con.Id];
            
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', Label.IAM_LDAP_Success_Messgae, null));
            //IAM_LDAP_Util_ApexCallout.LDAP_reclaim(u.Id, u.Username, '', con.Email, con.Id, 'Update');
            Test.stopTest();
        }
    }
    
    /* Ldap Reclaim Exception Test */
    static testmethod void ldapReclaimExceptionTest1() {
        //IAM_TestData.createIntegrationDetails('IAM_LDAP_Create_Mule');
        
        User usr = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator'
                  AND UserRoleId != null AND IsActive = true LIMIT 1];
        System.runAs(usr) {
            Account acc = IAM_TestData.createAccount();
            Contact con = IAM_TestData.createContact(acc.Id);
            IAM_TestData.createUser(con);
            User u = [SELECT Id, Username FROM User WHERE Username =: con.Username__c];
            
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(400, 'Error', 'Error', null));
            //IAM_LDAP_Util_ApexCallout.LDAP_reclaim(u.Id, u.Username, '', con.Email, con.Id, 'Insert');
            Test.stopTest();
        }
    }
    
    static testmethod void callToLdapUtilSuccess() {        
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        IAM_LDAP_Util.invokeapexcallout(new List<Contact>{con}, 'Insert');                
    }
    
    static testmethod void callToLdapUtilFailure() {        
        Contact con;
        IAM_LDAP_Util.invokeapexcallout(new List<Contact>{con}, 'Insert');                
    }

    /* Contact Insert Test - Ldap Reclaim Move User Call */ 
    static testmethod void ldapReclaimMoveUserCall() {
        IAM_TestData.createIntegrationDetails('IAM_LDAP_Move_USer_Mule');
        User usr = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator'
                  AND UserRoleId != null AND IsActive = true LIMIT 1];
        System.runAs(usr) {
            Account acc = IAM_TestData.createAccount();
            Contact con = IAM_TestData.createContact(acc.Id);
            IAM_TestData.createUser(con);
            User u = [SELECT Id, Username FROM User WHERE Username =: con.Username__c];
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', Label.IAM_LDAP_Success_Messgae, null));
            Test.startTest();
            IAM_LDAP_Util_MoveUser_ApexCallout.LDAP_reclaim_moveuser(con.Username__c, con.Email, 'Employee');
            Test.stopTest();
        }
    }
    
    /* Ldap Reclaim Move User Exception Call */
    static testmethod void ldapReclaimMoveUserExceptionCall() {
        IAM_TestData.createIntegrationDetails('IAM_LDAP_Move_USer_Mule');
        User usr = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator'
                  AND UserRoleId != null AND IsActive = true LIMIT 1];
        System.runAs(usr) {
            Account acc = IAM_TestData.createAccount();
            Contact con = IAM_TestData.createContact(acc.Id);
            IAM_TestData.createUser(con);
            User u = [SELECT Id, Username FROM User WHERE Username =: con.Username__c];
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(400, 'error', 'error', null));
            Test.startTest();
            IAM_LDAP_Util_MoveUser_ApexCallout.LDAP_reclaim_moveuser(con.Username__c, con.Email, 'Employee');
            Test.stopTest();
        }
    }

    /* Ldap Reclaim Move User Exception Call */
    static testmethod void ldapReclaimMoveUserExceptionCall1() {
        //IAM_TestData.createIntegrationDetails('IAM_LDAP_Move_USer_Mule');
        User usr = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator'
                  AND UserRoleId != null AND IsActive = true LIMIT 1];
        System.runAs(usr) {
            Account acc = IAM_TestData.createAccount();
            Contact con = IAM_TestData.createContact(acc.Id);
            IAM_TestData.createUser(con);
            User u = [SELECT Id, Username FROM User WHERE Username =: con.Username__c];
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(400, 'error', 'error', null));
            Test.startTest();
            IAM_LDAP_Util_MoveUser_ApexCallout.LDAP_reclaim_moveuser(null, null, null);
            Test.stopTest();
        }
    }
}