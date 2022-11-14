/*************************************************************************************
Name:  IAM_UserSubscriptionCreation_Test
Copyright © 2019  Cummins
**************************************************************************************
Purpose: Test class for IAM_UserSubscriptionCreation
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION         AUTHOR            DATE              DETAIL                                
1.0      Karthik Golakaram      10/12/2019      INITIAL DEVELOPMENT 
1.1      Shubhangi Sardar       09/23/2021      Assigned Value from Label to IAM_Subscription_Count__c
**************************************************************************************
**************************************************************************************/

@IsTest
public class IAM_UserSubscriptionCreation_Test {
    static String blank = '';
    
    /* QSOL - Create User Subscription - account subscrption is available but not user subscription */
    static testmethod void createQSOLUserSubscription() {
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        IAM_TestData.createUser(con);
        createSwRegAccountSub(acc.Id, con.Id, false);
        Test.startTest();
        String appGroups = 'cn=ATLAS_Universal_EMPLOYEE,ou=APP_ATLAS_UNIVERSAL,ou=application,dc=cummins,dc=com';
        IAM_UserSubscriptionCreation.NewSubscriptionInfo sub = new IAM_UserSubscriptionCreation.NewSubscriptionInfo();
        sub = getSubscription('QuickServe Online', 'QuickServe Online EBU', Date.today(), Date.today()+365,'Active',
            'SwReg', blank, 'IAM/11/09/2020', 'QSOL Dealer', 'With EDS', false, con.Username__c, appGroups);
        
        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/user/newsubscriptioncreation/'
            + con.Username__c;
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_UserSubscriptionCreation.CMI_ResponseHandler res =
            IAM_UserSubscriptionCreation.Post(sub);
       // System.assertEquals(true, res != null);
       // System.assertEquals('Success', res.status);
        Test.stopTest();
    }
    
    /* Guidanz Mobile - Create User Subscription - account subscrption is available but not user subscription */
    static testmethod void createGMUserSubscription() {
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        IAM_TestData.createUser(con);
        createSwRegAccountSub(acc.Id, con.Id, false);
        Test.startTest();
        String appGroups = 'cn=ATLAS_Universal_EMPLOYEE,ou=APP_ATLAS_UNIVERSAL,ou=application,dc=cummins,dc=com';
        IAM_UserSubscriptionCreation.NewSubscriptionInfo sub = new IAM_UserSubscriptionCreation.NewSubscriptionInfo();
        sub = getSubscription('Guidanz Mobile', 'Guidanz Mobile Campaign', Date.today(), Date.today()+365,'Active',
            'SwReg', 'IAM/11/09/2020', blank, 'Guidanz Mobile Campaign Dealer', blank, false, con.Username__c, appGroups);
        
        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/user/newsubscriptioncreation/'
            + con.Username__c;
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_UserSubscriptionCreation.CMI_ResponseHandler res =
            IAM_UserSubscriptionCreation.Post(sub);
        //System.assertEquals(true, res != null);
        //System.assertEquals('Success', res.status);
        Test.stopTest();
    }
    
    /* Guidanz Mobile - Create Account and User Subscription */
    static testmethod void createGMAccAndUserSubscription() {
        Account acc = IAM_TestData.createAccount();
        Contact con = new contact();
        con.AccountId = acc.Id;
        con.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        con.FirstName = 'Fname';
        con.LastName = 'Lname';
        con.Email = 'fnamelname@test.com';
        con.Username__c = 'fnamelname@test.com';
        con.phone = '1112223335';
        con.IAM_Contact_Status__c = 'Active';
        con.Username__c= 'fnamelname@test.com';
        insert con;
        IAM_TestData.createUser(con);
        system.debug('accAccessObj@@@@@test1j1h1h');
        IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(con.AccountId, 'Guidanz Mobile','Guidanz Mobile Campaign Dealer');
        accAccessObj.IAM_Subscription_Name__c ='Guidanz Mobile Campaign';
        update accAccessObj;
         IAM_TestData.createUserSubscription(con.Id, accAccessObj.Id, 'Guidanz Mobile', 'Guidanz Mobile Campaign', 
            Date.today(), Date.today()+200, 'Active', 'SwReg', blank, 'IAM/11/09/2020', 'Guidanz Mobile Campaign Dealer', blank);
        system.debug('accAccessObj@@@@@'+accAccessObj);
        Test.startTest();
        String appGroups = 'cn=ATLAS_Universal_EMPLOYEE,ou=APP_ATLAS_UNIVERSAL,ou=application,dc=cummins,dc=com';
        IAM_UserSubscriptionCreation.NewSubscriptionInfo sub = new IAM_UserSubscriptionCreation.NewSubscriptionInfo();
        sub = getSubscription('Guidanz Mobile', 'Guidanz Mobile Campaign', Date.today(), Date.today()+365,'Active',
            'SwReg', 'IAM/11/09/2020', blank, 'Guidanz Mobile Campaign Dealer', blank, false, con.Username__c, appGroups);
        
        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/user/newsubscriptioncreation/'
            + con.Username__c;
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_UserSubscriptionCreation.CMI_ResponseHandler res =
            IAM_UserSubscriptionCreation.Post(sub);
        //System.assertEquals(true, res != null);
        //System.assertEquals('Success', res.status);
        Test.stopTest();
    }
    
    /* Guidanz Mobile - Update User Subscription */
    static testmethod void updateGMUserSubscription() {
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        IAM_TestData.createUser(con);
        createSwRegAccountSub(acc.Id, con.Id, true);
        Test.startTest();
        String appGroups = 'cn=ATLAS_Universal_EMPLOYEE,ou=APP_ATLAS_UNIVERSAL,ou=application,dc=cummins,dc=com';
        IAM_UserSubscriptionCreation.NewSubscriptionInfo sub = new IAM_UserSubscriptionCreation.NewSubscriptionInfo();
        sub = getSubscription('Guidanz Mobile', 'Guidanz Mobile Campaign', Date.today(), Date.today()+365,'Active',
            'SwReg', 'IAM/11/09/2020', blank, 'Guidanz Mobile Campaign Dealer', blank, false, con.Username__c, appGroups);
        
        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/user/newsubscriptioncreation/'
            + con.Username__c;
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_UserSubscriptionCreation.CMI_ResponseHandler res =
            IAM_UserSubscriptionCreation.Post(sub);
        //System.assertEquals(true, res != null);
        //System.assertEquals('Success', res.status);
        Test.stopTest();
    }
    
    /* QSOL - Update User Subscription */
    static testmethod void updateQSOLUserSubscription() {
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        IAM_TestData.createUser(con);
        createSwRegAccountSub(acc.Id, con.Id, true);
        Test.startTest();
        String appGroups = 'cn=ATLAS_Universal_EMPLOYEE,ou=APP_ATLAS_UNIVERSAL,ou=application,dc=cummins,dc=com';
        IAM_UserSubscriptionCreation.NewSubscriptionInfo sub = new IAM_UserSubscriptionCreation.NewSubscriptionInfo();
        sub = getSubscription('QuickServe Online', 'QuickServe Online EBU', Date.today(), Date.today()+365,'Active',
            'SwReg', blank, 'IAM/11/09/2020', 'QSOL Dealer', 'With EDS', false, con.Username__c, appGroups);
        
        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/user/newsubscriptioncreation/'
            + con.Username__c;
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_UserSubscriptionCreation.CMI_ResponseHandler res =
            IAM_UserSubscriptionCreation.Post(sub);
        //System.assertEquals(true, res != null);
        //System.assertEquals('Success', res.status);
        Test.stopTest();
    }
    
    /* QSOL - Update Existing User Subscription OF Same Group with different Role */
    static testmethod void updateQSOLUserSubscriptionDuplicate() {
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        IAM_TestData.createUser(con);
        createSwRegAccountSub(acc.Id, con.Id, true);
        Test.startTest();
        String appGroups = 'cn=ATLAS_Universal_EMPLOYEE,ou=APP_ATLAS_UNIVERSAL,ou=application,dc=cummins,dc=com';
        IAM_UserSubscriptionCreation.NewSubscriptionInfo sub = new IAM_UserSubscriptionCreation.NewSubscriptionInfo();
        sub = getSubscription('QuickServe Online', 'QuickServe Online EBU', Date.today(), Date.today()+365,'Active',
            'SwReg', blank, 'IAM/11/09/2020', 'QSOL Distributor', 'With EDS', false, con.Username__c, appGroups);
        
        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/user/newsubscriptioncreation/'
            + con.Username__c;
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_UserSubscriptionCreation.CMI_ResponseHandler res =
            IAM_UserSubscriptionCreation.Post(sub);
        //System.assertEquals(true, res != null);
        //System.assertEquals('error', res.status);
        Test.stopTest();
    }
    
    /* QSOL - Revoke User Subscription */
    static testmethod void revokeQSOLUserSubscription() {
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        IAM_TestData.createUser(con);
        createSwRegAccountSub(acc.Id, con.Id, true);
        Test.startTest();
        String appGroups = 'cn=ATLAS_Universal_EMPLOYEE,ou=APP_ATLAS_UNIVERSAL,ou=application,dc=cummins,dc=com';
        IAM_UserSubscriptionCreation.NewSubscriptionInfo sub = new IAM_UserSubscriptionCreation.NewSubscriptionInfo();
        sub = getSubscription('QuickServe Online', 'QuickServe Online EBU', Date.today(), Date.today()+200,'Inactive',
            'SwReg', blank, 'IAM/11/09/2020', 'QSOL Dealer', 'With EDS', false, con.Username__c, appGroups);
        
        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/user/newsubscriptioncreation/'
            + con.Username__c;
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_UserSubscriptionCreation.CMI_ResponseHandler res =
            IAM_UserSubscriptionCreation.Post(sub);
        //System.assertEquals(true, res != null);
        //System.assertEquals('Success', res.status);
        Test.stopTest();
    }
    
    /* Invalid Username Test */
    static testmethod void invalidUsernameTest() {
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        createSwRegAccountSub(acc.Id, con.Id, false);
        Test.startTest();
        String appGroups = 'cn=ATLAS_Universal_EMPLOYEE,ou=APP_ATLAS_UNIVERSAL,ou=application,dc=cummins,dc=com';
        IAM_UserSubscriptionCreation.NewSubscriptionInfo sub = new IAM_UserSubscriptionCreation.NewSubscriptionInfo();
        sub = getSubscription('QuickServe Online', 'QuickServe Online EBU', Date.today(), Date.today()+365,'Active',
            'SwReg', blank, 'IAM/11/09/2020', 'QSOL Dealer', 'With EDS', false, con.Username__c, appGroups);
        
        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/user/newsubscriptioncreation/test@test1.com.test';
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_UserSubscriptionCreation.CMI_ResponseHandler res =
            IAM_UserSubscriptionCreation.Post(sub);
        //System.assertEquals(true, res != null);
        //System.assertEquals('error', res.status);
        Test.stopTest();
    }
    
    /* Validation test of field values */
    static testmethod void invalidFieldDataTest1() {
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        createSwRegAccountSub(acc.Id, con.Id, false);
        Test.startTest();
        String appGroups = 'cn=ATLAS_Universal_EMPLOYEE,ou=APP_ATLAS_UNIVERSAL,ou=application,dc=cummins,dc=com';
        IAM_UserSubscriptionCreation.NewSubscriptionInfo sub = new IAM_UserSubscriptionCreation.NewSubscriptionInfo();
        sub = getSubscription(blank, null, null, null, null, null, blank, null, null, blank, null, 
                              con.Username__c, appGroups);
        
        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/user/newsubscriptioncreation/'
            + con.Username__c;
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_UserSubscriptionCreation.CMI_ResponseHandler res =
            IAM_UserSubscriptionCreation.Post(sub);
        //System.assertEquals(true, res != null);
        //System.assertEquals('error', res.status);
        Test.stopTest();
    }
    
    /* Validation test of field values */
    static testmethod void invalidFieldDataTest2() {
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        createSwRegAccountSub(acc.Id, con.Id, false);
        Test.startTest();
        String appGroups = 'cn=ATLAS_Universal_EMPLOYEE,ou=APP_ATLAS_UNIVERSAL,ou=application,dc=cummins,dc=com';
        IAM_UserSubscriptionCreation.NewSubscriptionInfo sub = new IAM_UserSubscriptionCreation.NewSubscriptionInfo();
        sub = getSubscription('QuickServe Online', 'QuickServe Online EBU', Date.today(), Date.today()+365,'test',
            'SwReg', blank, blank, 'QSOL Test', blank, false, con.Username__c, appGroups);
        
        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/user/newsubscriptioncreation/'
            + con.Username__c;
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_UserSubscriptionCreation.CMI_ResponseHandler res =
            IAM_UserSubscriptionCreation.Post(sub);
        //System.assertEquals(true, res != null);
        //System.assertEquals('error', res.status);
        Test.stopTest();
    }
    
    /* Exception Test Case */
    static testmethod void exceptionTest() {
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        createSwRegAccountSub(acc.Id, con.Id, false);
        Test.startTest();
        String appGroups = 'cn=ATLAS_Universal_EMPLOYEE,ou=APP_ATLAS_UNIVERSAL,ou=application,dc=cummins,dc=com';
        IAM_UserSubscriptionCreation.NewSubscriptionInfo sub = new IAM_UserSubscriptionCreation.NewSubscriptionInfo();
        sub = getSubscription('Guidanz Mobile', 'Guidanz Mobile Campaign', Date.today(), Date.today()+365,'Active',
            'SwReg', 'IAM/11/09/2020', blank, 'Guidanz Mobile Campaign Dealer', blank, false, con.Username__c, appGroups);
        
        RestRequest request = new RestRequest();
        /* There is no requestUri is set therefore it should throw error */
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_UserSubscriptionCreation.CMI_ResponseHandler res =
            IAM_UserSubscriptionCreation.Post(sub);
        //System.assertEquals(true, res != null);
        //System.assertEquals('error', res.status);
        Test.stopTest();
    }
    
    /** Create account and user subscription */
    private static void createSwRegAccountSub(Id accId, Id conId, Boolean isCreate) {
        String blank = '';
        IAM_Application__c app1 = IAM_TestData.createAccountSubscription(accId, 'QuickServe Online', 'QuickServe Online EBU', Date.today(), Date.today()+200,
                                   'Active', 'SwReg', blank, 'IAM/11/09/2020', 'QSOL Dealer', blank, false);
        insert app1;
        IAM_Application__c app2 = IAM_TestData.createAccountSubscription(accId, 'Guidanz Mobile', 'Guidanz Mobile Campaign', Date.today(), Date.today()+200,
                                   'Active', 'SwReg', 'IAM/11/09/2020', blank, 'Guidanz Mobile Campaign Dealer', blank, false);
        insert app2;
        if(isCreate) {
            IAM_TestData.createUserSubscription(conId, app1.Id, 'QuickServe Online', 'QuickServe Online EBU', 
            Date.today(), Date.today()+200, 'Active', 'SwReg', blank, 'IAM/11/09/2020', 'QSOL Dealer', blank);
            IAM_TestData.createUserSubscription(conId, app2.Id, 'Guidanz Mobile', 'Guidanz Mobile Campaign', 
            Date.today(), Date.today()+200, 'Active', 'SwReg', blank, 'IAM/11/09/2020', 'Guidanz Mobile Campaign Dealer', blank);
        }        
    }
    
    /* Prepare a post request data */
    private static IAM_UserSubscriptionCreation.NewSubscriptionInfo getSubscription(
        String appName, String subName, Date stDate, Date edDate, String subType, String source, String swExpire,
        String qsolExpire, String role, String licenseType, Boolean free, String username, String appGroups) {        
        IAM_UserSubscriptionCreation.NewSubscriptionInfo sub 
            = new IAM_UserSubscriptionCreation.NewSubscriptionInfo();
        sub.applicationName = appName;
        sub.subscriptionName = subName;
        sub.startDate = stDate;
        sub.endDate = edDate;
        sub.subscriptionType = subType;
        sub.source = source;
        sub.swregExpire = swExpire;
        sub.qsolExpiration = qsolExpire;
        sub.role = role;
        sub.licenseType = licenseType;
        sub.free = free;
        sub.username = username;
        sub.applicationGroups = appGroups;
        return sub;
    }   
    /* Guidanz Mobile - Create Account and User Subscription */
    static testmethod void createGMAccAndUserSubscription_test1() {
        Account acc = IAM_TestData.createAccount();
        Contact con = new contact();
        con.AccountId = acc.Id;
        con.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        con.FirstName = 'Fname';
        con.LastName = 'Lname';
        con.Email = 'fnamelname@test.com';
        con.Username__c = 'fnamelname@test.com';
        con.phone = '1112223335';
        con.IAM_Contact_Status__c = 'Active';
        con.Username__c= 'fnamelname@test.com';
        con.IAM_Internal__c=false;
        insert con;
        IAM_TestData.createUser(con);
        system.debug('accAccessObj@@@@@test1j1h1h');
        //IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(con.AccountId, 'Guidanz Mobile','Guidanz Mobile Campaign Dealer');
        //accAccessObj.IAM_Subscription_Name__c ='Guidanz Mobile Campaign';
        //update accAccessObj;
         //IAM_TestData.createUserSubscription(con.Id, accAccessObj.Id, 'Guidanz Mobile', 'Guidanz Mobile Campaign', 
           // Date.today(), Date.today()+200, 'Active', 'SwReg', blank, 'IAM/11/09/2020', 'Guidanz Mobile Campaign Dealer', blank);
        //system.debug('accAccessObj@@@@@'+accAccessObj);
        Test.startTest();
        String appGroups = 'cn=ATLAS_Universal_EMPLOYEE,ou=APP_ATLAS_UNIVERSAL,ou=application,dc=cummins,dc=com';
        IAM_UserSubscriptionCreation.NewSubscriptionInfo sub = new IAM_UserSubscriptionCreation.NewSubscriptionInfo();
        sub = getSubscription('Guidanz Mobile', 'Guidanz Mobile Campaign', Date.today(), Date.today()+365,'Active',
            'SwReg', 'IAM/11/09/2020', blank, 'Guidanz Mobile Campaign Dealer', blank, false, con.Username__c, appGroups);
        
        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/user/newsubscriptioncreation/'
            + con.Username__c;
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_UserSubscriptionCreation.CMI_ResponseHandler res =
            IAM_UserSubscriptionCreation.Post(sub);
        //System.assertEquals(true, res != null);
        //System.assertEquals('Success', res.status);
        Test.stopTest();
    }
    static testmethod void createGMAccAndUserSubscription_test2() {
        Account acc = IAM_TestData.createAccount();
        Contact con = new contact();
        con.AccountId = acc.Id;
        con.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        con.FirstName = 'Fname';
        con.LastName = 'Lname';
        con.Email = 'fnamelname@test.com';
        con.Username__c = 'fnamelname@test.com';
        con.phone = '1112223335';
        con.IAM_Contact_Status__c = 'Active';
        con.Username__c= 'fnamelname@test.com';
        con.IAM_Internal__c=false;
        insert con;
        IAM_TestData.createUser(con);
        system.debug('accAccessObj@@@@@test1j1h1h');
       IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(con.AccountId, 'Guidanz Mobile','Guidanz Mobile Campaign Dealer');
       accAccessObj.IAM_Subscription_Name__c ='Guidanz Mobile Campaign';
        update accAccessObj;
        IAM_TestData.createUserSubscription(con.Id, accAccessObj.Id, 'Guidanz Mobile', 'Guidanz Mobile Campaign', 
         Date.today(), Date.today()+200, 'Active', 'SwReg', blank, 'IAM/11/09/2020', 'Guidanz Mobile Campaign Dealer', blank);
        system.debug('accAccessObj@@@@@'+accAccessObj);
        Test.startTest();
        String appGroups = 'cn=ATLAS_Universal_EMPLOYEE,ou=APP_ATLAS_UNIVERSAL,ou=application,dc=cummins,dc=com';
        IAM_UserSubscriptionCreation.NewSubscriptionInfo sub = new IAM_UserSubscriptionCreation.NewSubscriptionInfo();
        sub = getSubscription('Guidanz Mobile', 'Guidanz Mobile Campaign', Date.today(), Date.today()+365,'InActive',
            'SwReg', 'IAM/11/09/2020', blank, 'Guidanz Mobile Campaign Dealer', blank, false, con.Username__c, appGroups);
        
        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/user/newsubscriptioncreation/'
            + con.Username__c;
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_UserSubscriptionCreation.CMI_ResponseHandler res =
            IAM_UserSubscriptionCreation.Post(sub);
        //System.assertEquals(true, res != null);
        //System.assertEquals('Success', res.status);
        Test.stopTest();
    }
}