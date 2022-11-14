/*************************************************************************************
Name:  IAM_ExistCompUserSubCreation_Test
Copyright © 2019  Cummins
**************************************************************************************
Purpose: Test Class of IAM_ExistCompUserSubCreation
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION         AUTHOR            DATE              DETAIL                                
1.0      Karthik Golakaram      10/12/2019      INITIAL DEVELOPMENT 
1.1      Shubhangi Sardar       09/23/2021      Assigned Value from Label to IAM_Subscription_Count__c
**************************************************************************************
**************************************************************************************/

@IsTest
public class IAM_ExistCompUserSubCreation_Test {
    
    /* Create QSOL Subdcription - No Existing Account Access Feature */
    static testmethod void createQSOLSubTest1() {
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        IAM_TestData.createUser(con);
        createSwRegAccountSub(acc.Id, con.Id, true);
        Test.startTest();
        IAM_ExistCompUserSubCreation.UserLocationSubscriptionInfo sub =
            getSubscription('SwReg', '6767676767', 'PGA01', 'fnamelnameOne@test.com', 'Primary', 
            'fnamelnameOne@test.com', 'Active', 'lname', false, 'fname', Date.today() +365, 'IAM/11/09/2020', 'IAM/11/09/2020', false,
            'With EDS', 'Guidanz Mobile Campaign Dealer', 'Active', 'Guidanz Mobile', Date.today(), 'Guidanz Mobile Campaign');
        
        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/location/UserSubscriptioncreation/'
            + acc.IAM_Service_Provider_Code__c;
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_ExistCompUserSubCreation.CMI_ResponseHandler res =
            IAM_ExistCompUserSubCreation.Post(sub);
        System.assertEquals(true, res != null);
        Test.stopTest();
    }
    
    /* Create QSOL Subdcription - No Existing Account Access Feature */
    static testmethod void createQSOLSubTest2() {
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        IAM_TestData.createUser(con);
        createSwRegAccountSub(acc.Id, con.Id, true);
        Test.startTest();
        IAM_ExistCompUserSubCreation.UserLocationSubscriptionInfo sub =
            getSubscription('SwReg', '6767676767', 'PGA01', 'fnamelnameOne@test.com', 'Primary', 
            'fnamelnameOne@test.com', 'Active', 'lname', false, 'fname', Date.today() +365, 'IAM/11/09/2020', 'IAM/11/09/2020', false,
            'With EDS', 'Technician', 'Active', 'EDS', Date.today(), 'EDS Technician');
        
        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/location/UserSubscriptioncreation/'
            + acc.IAM_Service_Provider_Code__c;
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_ExistCompUserSubCreation.CMI_ResponseHandler res =
            IAM_ExistCompUserSubCreation.Post(sub);
        System.assertEquals(true, res != null);
        Test.stopTest();
    }
    
    /* Exception Test */
    static testmethod void emailCheckInsertFailedTest() {
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        IAM_TestData.createUser(con);
        createSwRegAccountSub(acc.Id, con.Id, true);
        Test.startTest();
        IAM_ExistCompUserSubCreation.UserLocationSubscriptionInfo sub =
            getSubscription('SwReg', '6767676767', 'PGA01', 'fnamelnameOnetest.com', 'Primary', 
            'fnamelnameOnetest.com', 'Active', 'lname', false, 'fname', Date.today() +365, 'IAM/11/09/2020', 'IAM/11/09/2020', false,
            'With EDS', 'Guidanz Mobile Campaign Dealer', 'Active', 'Guidanz Mobile', Date.today(), 'Guidanz Mobile Campaign');
        
        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/location/UserSubscriptioncreation/'
            + acc.IAM_Service_Provider_Code__c;
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_ExistCompUserSubCreation.CMI_ResponseHandler res =
            IAM_ExistCompUserSubCreation.Post(sub);
        System.assertEquals(true, res != null);
        Test.stopTest();
    }
    
    /* Create QSOL Subdcription - No Existing Account Access Feature */
    static testmethod void validateRequestTest() {
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        IAM_TestData.createUser(con);
        createSwRegAccountSub(acc.Id, con.Id, true);
        Test.startTest();
        IAM_ExistCompUserSubCreation.UserLocationSubscriptionInfo sub =
            getSubscription(null, null, null, null, null, null, null, null, null, null, null, null, null, null, null,
                           null, null, null, null, null);
        
        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/location/UserSubscriptioncreation/'
            + acc.IAM_Service_Provider_Code__c;
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_ExistCompUserSubCreation.CMI_ResponseHandler res =
            IAM_ExistCompUserSubCreation.Post(sub);
        System.assertEquals(true, res != null);
        System.assertEquals('error', res.status);
        Test.stopTest();
    }
    
    /* Validate Email */
    static testmethod void validateEmailTest() {
        Test.startTest();
        List<String> email = new List<String>();
        email.add('abc@test.com');
        Boolean isValid = IAM_ExistCompUserSubCreation.validateEmail(email);
        System.assertEquals(true, isValid);
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
    
    /* Prepare Subcription Data for Request Body */
    private static IAM_ExistCompUserSubCreation.UserLocationSubscriptionInfo getSubscription(String source, 
        String phone, String pga, String username, String contactType, String email, String contactStatus,
        String lastName, Boolean siteAdmin, String firstName, Date edDate, String swExpire, String qsolExpire, 
        Boolean free,String licenseType, String role, String subType, String appName, Date stDate, String subName) {          
            
        IAM_ExistCompUserSubCreation.UserLocationSubscriptionInfo mainSub = 
            new IAM_ExistCompUserSubCreation.UserLocationSubscriptionInfo();
        IAM_ExistCompUserSubCreation.subscriptionInfo sub = new IAM_ExistCompUserSubCreation.subscriptionInfo();
        IAM_ExistCompUserSubCreation.userInfo usr = new IAM_ExistCompUserSubCreation.userInfo();
               
        /* Subscription Info */
        sub.endDate = edDate;
        sub.swregExpire = swExpire;
        sub.qsolExpiration = qsolExpire;
        sub.free = free;
        sub.licenseType = licenseType;
        sub.role = role;
        sub.subscriptionType = subType;
        sub.applicationName = appName;
        sub.source = source;
        sub.startDate = stDate;
        sub.SubscriptionName = subName;
        mainSub.subscriptionInfo = sub;
        
        /* User Info */
        usr.source = source;
        usr.phone = phone;
        usr.pga = pga;
        usr.username = username;
        usr.contactType = contactType;
        usr.email = email;
        usr.contactStatus = contactStatus;
        usr.lastName = lastName;
        usr.siteAdmin = siteAdmin;
        usr.firstName = firstName;
        mainSub.userInfo = usr;
            
        return mainSub;
    }
}