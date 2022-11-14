/**************************************************************************************
Name:  IAM_ExistingLocationSubInfo_Test
Copyright © 2019  Cummins
**************************************************************************************
Purpose: Test class for IAM_ExistingLocationSubscriptionInfo
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION         AUTHOR            DATE              DETAIL                                
1.0      Karthik Golakaram      10/12/2019      INITIAL DEVELOPMENT 
1.1      Shubhangi Sardar       09/23/2021      Assigned Value from Label to IAM_Subscription_Count__c
**************************************************************************************
**************************************************************************************/


@IsTest
private class IAM_ExistingLocationSubInfo_Test {
    
    /* Create QSOL Bundle Subdcription - No Existing Account Access Feature */
    static testmethod void createQSOLBundleSubTest1() {
        Account acc = IAM_TestData.createAccount();
        Test.startTest();
        List<IAM_ExistingLocationSubscriptionInfo.LocationSubscriptionInfo> subList 
            = getSubscriptionList('Active');
        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/location/subscriptioncreation/'
            + acc.IAM_Service_Provider_Code__c;
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_ExistingLocationSubscriptionInfo.CMI_ResponseHandler res =
            IAM_ExistingLocationSubscriptionInfo.Post(subList);
        System.assertEquals(true, res != null);
        System.assertEquals('Success', res.status);
        Test.stopTest();
    }
    
    /* Create QSOL Bundle Subdcription - Existing Account Access Feature */
    static testmethod void createQSOLBundleSubTest2() {
        
        
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.IAM_Service_Provider_Code__c = '123';
        acc.Type = 'Dealer Account';
        acc.CSS_DistributorCode__c = '1234';
        acc.CSS_DBCode__c = '12345';
        acc.CSS_DealerCode__c = '456';
        insert acc;
        
        Contact con = new contact();
        con.lastName = 'Test';
        con.AccountId = acc.id;
        con.firstName = 'contact';
        con.Email = 'testContact@test.com';
        con.IAM_Contact_Status__c = 'Active';
        con.CMI_Contact_Type__c = 'Primary';
        con.phone = '8989898989';
        con.IAM_Application_Roles__c = 'Advanced';
        con.IAM_Promotion__c = '12345';
        con.IAM_Applications__c = 'cn=CSS_DN_Advanced,ou=APP_CSS,ou=application,dc=cummins,dc=com';
        con.IAM_is_member_of__c = 'cn=CSS_DN_Advanced,ou=APP_CSS,ou=application,dc=cummins,dc=com';
        Con.Username__c = 'test_user_helper6@eidm.com';
        Con.recordtypeid=Schema.getGlobalDescribe().get('Contact').getDescribe().getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        
        insert con;
        
        Set<Id> setIds = new Set<Id>();    
        setIds.add(con.id);
        
        //User us1 = [select ProfileId,LastName,Email,Username,CompanyName,IAM_Application_Roles__c,IAM_Applicationgroups__c from user where ContactId =: con.id];
        List<Id> lstApp = new List<Id>();
        List<IAM_Application__c> IAMApp = new List<IAM_Application__c>();
        IAM_Application__c app = new IAM_Application__c();
        app.IAM_Application_Name__c = 'Guidanz';
        app.IAM_Role__c = 'Advanced';
        app.IAM_Status__c = 'Active';
        app.IAM_Account_Name__c = acc.id;
        app.IAM_Subscription_Name__c = 'Guidanz';
        app.IAM_Subscription_End_Date__c = system.today().adddays(5);

        //app.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        insert app;
        IAMApp.add(app);
        lstApp.add(app.Id);
        
        //IAM Contact Provisioning
        List<IAM_Contact_Provisioning__c> lstconApp = new List<IAM_Contact_Provisioning__c>();
        IAM_Contact_Provisioning__c conApp = new IAM_Contact_Provisioning__c();
        conApp.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Repair logistics and Service').getRecordTypeId();
        conApp.IAM_Role__c = 'RLS Admin';
                
        conApp.IAM_Status__c = 'Active';
        conApp.IAM_Contact__c = con.id; 
        conApp.IAM_Account_Application__c = app.id;    
        insert conApp;
        
        IAM_Contact_Provisioning__c conApp1 = new IAM_Contact_Provisioning__c();
        conApp1.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Repair logistics and Service').getRecordTypeId();
        conApp1.IAM_Role__c = 'RLS Admin';
                
        conApp1.IAM_Status__c = 'Inactive';
        conApp1.IAM_Contact__c = con.id; 
        conApp1.IAM_Account_Application__c = app.id;    
        insert conApp1;
        
        lstconApp.add(conApp);
        lstconApp.add(conApp1);
        
        
        IAM_ExistingSubscriptionQueueable.doChainJob = false;
        //Account acc = IAM_TestData.createAccount();
        
        Test.startTest();
       //Account acc1 = IAM_TestData.createAccount();
        createWebAccountSubscriptionList(acc.Id);
        IAM_ExistingLocationSubscriptionInfo.cmiError('message');
        IAM_Contact_Provisioning_Renewal.updateQSOLExpFld(lstconApp);
        
        List<IAM_ExistingLocationSubscriptionInfo.LocationSubscriptionInfo> subList 
            = getSubscriptionList('Active');
        System.enqueueJob(new IAM_ExistingSubscriptionQueueable(IAMApp,Label.IAM_Action_Update,lstApp,true,false));
        System.enqueueJob(new IAM_ExistingSubscriptionQueueable(IAMApp,Label.IAM_Action_Cancel,lstApp,false,true));
        Test.stopTest();
        /*Account acc = IAM_TestData.createAccount();
        createWebAccountSubscriptionList(acc.Id);
        Test.startTest();
        List<IAM_ExistingLocationSubscriptionInfo.LocationSubscriptionInfo> subList 
            = getSubscriptionList('Active');
        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/location/subscriptioncreation/'
            + acc.IAM_Service_Provider_Code__c;
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_ExistingLocationSubscriptionInfo.CMI_ResponseHandler res =
            IAM_ExistingLocationSubscriptionInfo.Post(subList);
        System.assertEquals(true, res != null);
        System.assertEquals('Success', res.status);
        Test.stopTest();*/
    } 
    
    /* Update QSOL Bundle Subdcription - Existing Account Access Feature */
    /*static testmethod void updateQSOLBundleSubTest1() {
        Account acc = IAM_TestData.createAccount();
        createSwRegAccountSubscriptionList(acc.Id);
        Test.startTest();
        List<IAM_ExistingLocationSubscriptionInfo.LocationSubscriptionInfo> subList 
            = getSubscriptionList('Active');
        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/location/subscriptioncreation/'
            + acc.IAM_Service_Provider_Code__c;
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_ExistingLocationSubscriptionInfo.CMI_ResponseHandler res =
            IAM_ExistingLocationSubscriptionInfo.Post(subList);
        System.assertEquals(true, res != null);
        System.assertEquals('Success', res.status);
        Test.stopTest();
    }*/
    
    /* Update QSOL Bundle Subdcription - Existing Account Access Feature With Same End Date */
    static testmethod void updateQSOLBundleSubTest2() {
        Account acc = IAM_TestData.createAccount();
        createSwRegAccountSubscriptionList(acc.Id);
        Test.startTest();
        List<IAM_ExistingLocationSubscriptionInfo.LocationSubscriptionInfo> subList 
            = getDuplicateSubscriptionList('Active');
        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/location/subscriptioncreation/'
            + acc.IAM_Service_Provider_Code__c;
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_ExistingLocationSubscriptionInfo.CMI_ResponseHandler res =
            IAM_ExistingLocationSubscriptionInfo.Post(subList);
        System.assertEquals(true, res != null);
        System.assertEquals('Error', res.status);
        Test.stopTest();
    }
    
    /* Inactive QSOL Bundle Subscription - Existing Account Access Feature */
    /*static testmethod void inactiveQSOLBundleSubTest() {
        Account acc = IAM_TestData.createAccount();
        createSwRegAccountSubscriptionList(acc.Id);
        Test.startTest();
        List<IAM_ExistingLocationSubscriptionInfo.LocationSubscriptionInfo> subList 
            = getSubscriptionList('Inactive');
        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/location/subscriptioncreation/'
            + acc.IAM_Service_Provider_Code__c;
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_ExistingLocationSubscriptionInfo.CMI_ResponseHandler res =
            IAM_ExistingLocationSubscriptionInfo.Post(subList);
        System.assertEquals(true, res != null);
        System.assertEquals('Success', res.status);
        Test.stopTest();
    }*/
    
    /* Validation of required attributes */
    static testmethod void validationTest() {
        Account acc = IAM_TestData.createAccount();
        Test.startTest();
        List<IAM_ExistingLocationSubscriptionInfo.LocationSubscriptionInfo> subList 
            = getInvalidDataSubscriptionList();
        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/location/subscriptioncreation/'
            + acc.IAM_Service_Provider_Code__c;
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_ExistingLocationSubscriptionInfo.CMI_ResponseHandler res =
            IAM_ExistingLocationSubscriptionInfo.Post(subList);
        System.assertEquals(true, res != null);
        System.assertEquals('Error', res.status);
        Test.stopTest();        
    }
    
    /* Validation of Account Availability */
    static testmethod void validateLocationTest() {
        Test.startTest();
        List<IAM_ExistingLocationSubscriptionInfo.LocationSubscriptionInfo> subList 
            = getSubscriptionList('Active');
        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/location/subscriptioncreation/C0012';
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_ExistingLocationSubscriptionInfo.CMI_ResponseHandler res =
            IAM_ExistingLocationSubscriptionInfo.Post(subList);
        System.assertEquals(true, res != null);
        System.assertEquals('Error', res.status);
        Test.stopTest();        
    }
    
    /* Validation of required attributes */
   	static testmethod void exceptionTest() {
        Account acc = IAM_TestData.createAccount();
        Test.startTest();
        List<IAM_ExistingLocationSubscriptionInfo.LocationSubscriptionInfo> subList 
            = getNullSubscription();
        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/location/subscriptioncreation/'        
            + acc.IAM_Service_Provider_Code__c;
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_ExistingLocationSubscriptionInfo.CMI_ResponseHandler res =
            IAM_ExistingLocationSubscriptionInfo.Post(subList);
        System.assertEquals(true, res != null);
        //System.assertEquals('Error', res.status);
        Test.stopTest();        
    }
    
    private static List<IAM_ExistingLocationSubscriptionInfo.LocationSubscriptionInfo> getSubscriptionList(String status) {
        List<IAM_ExistingLocationSubscriptionInfo.LocationSubscriptionInfo> subList 
            = new List<IAM_ExistingLocationSubscriptionInfo.LocationSubscriptionInfo>();
        String blank = '';
        subList.add(getSubscription('QuickServe Online', 'QuickServe Online EBU', Date.today(), Date.today()+365,
                                   status, 'SwReg', blank, 'IAM/11/09/2020', 'QSOL Dealer', blank, false));
        subList.add(getSubscription('EDS', 'QuickServe Online EBU', Date.today(), Date.today()+365,
                                   status, 'SwReg', blank, blank, blank, blank, false));
        subList.add(getSubscription('Guidanz', 'QuickServe Online EBU', Date.today(), Date.today()+365,
                                   status, 'SwReg', blank, blank, blank, blank, false));
        subList.add(getSubscription('Guidanz Mobile', 'Guidanz Mobile IA', Date.today(), Date.today()+365,
                                   status, 'SwReg', 'IAM/11/09/2020', blank, 'Guidanz Mobile Immediate Assessment Dealer', blank, false));
        return subList;
    }
    
    private static List<IAM_ExistingLocationSubscriptionInfo.LocationSubscriptionInfo> getDuplicateSubscriptionList(String status) {
        List<IAM_ExistingLocationSubscriptionInfo.LocationSubscriptionInfo> subList 
            = new List<IAM_ExistingLocationSubscriptionInfo.LocationSubscriptionInfo>();
        String blank = '';
        subList.add(getSubscription('EDS', 'QuickServe Online EBU', Date.today(), Date.today()+200,
                                   status, 'SwReg', blank, blank, blank, blank, false));
        return subList;
    }
    
    private static List<IAM_ExistingLocationSubscriptionInfo.LocationSubscriptionInfo> getNullSubscription() {
        List<IAM_ExistingLocationSubscriptionInfo.LocationSubscriptionInfo> subList 
            = new List<IAM_ExistingLocationSubscriptionInfo.LocationSubscriptionInfo>();
        String blank = '';
        subList.add(getSubscription('EDS', 'QuickServe Online EBU', Date.today(), Date.today()+365,
                                   'Active', 'SwReg', blank, blank, null, blank, false));
        return subList;
    }
        
    private static List<IAM_ExistingLocationSubscriptionInfo.LocationSubscriptionInfo> getInvalidDataSubscriptionList() {
        List<IAM_ExistingLocationSubscriptionInfo.LocationSubscriptionInfo> subList 
            = new List<IAM_ExistingLocationSubscriptionInfo.LocationSubscriptionInfo>();
        String blank = '';
        subList.add(getSubscription(blank, null, null, null,
                                   null, null, blank, null, 'QSOL Dealer', blank, false));
        subList.add(getSubscription('QuickServe Online', 'QuickServe Online EBU', Date.today(), Date.today()+365,
                                   'Active', 'SwReg', blank, blank, 'QSOL Dealer', blank, false));
        subList.add(getSubscription('Guidanz Mobile', 'Guidanz Mobile IA', Date.today(), Date.today()+365,
                                   'Active', 'SwReg', blank, blank, 'Guidanz Mobile Immediate Assessment Dealer', blank, false));
        
        return subList;
    }
    
    private static void createWebAccountSubscriptionList(Id accId) {
        List<IAM_Application__c> existingSubList = new List<IAM_Application__c>();
        String blank = '';
        existingSubList.add(IAM_TestData.createAccountSubscription(accId, 'QuickServe Online', 'QSOL LOP', Date.today(), Date.today()+200,
                                   'Active', 'WEB', blank, 'IAM/11/09/2020', 'QSOL LOP', blank, false));
        existingSubList.add(IAM_TestData.createAccountSubscription(accId, 'EDS', 'EDS', Date.today(), Date.today()+200,
                                   'Active', 'WEB', blank, blank, 'Technician', blank, false));
        existingSubList.add(IAM_TestData.createAccountSubscription(accId, 'Guidanz', 'Guidanz', Date.today(), Date.today()+200,
                                   'Active', 'WEB', blank, blank, 'Technician', blank, false));
        insert existingSubList;
    }
    
    private static void createSwRegAccountSubscriptionList(Id accId) {
        String blank = '';
        Contact con = IAM_TestData.createContact(accId);
        IAM_Application__c app1 = IAM_TestData.createAccountSubscription(accId, 'QuickServe Online', 'QuickServe Online EBU', Date.today(), Date.today()+200,
                                   'Active', 'SwReg', blank, 'IAM/11/09/2020', 'QSOL Dealer', blank, false);
        insert app1;
        IAM_TestData.createUserSubscription(con.Id, app1.Id, 'QuickServe Online', 'QuickServe Online EBU', Date.today(), Date.today()+200,
                                   'Active', 'SwReg', blank, 'IAM/11/09/2020', 'QSOL Dealer', blank);
        IAM_Application__c app2 = IAM_TestData.createAccountSubscription(accId, 'Guidanz Mobile', 'Guidanz Mobile IA', Date.today(), Date.today()+200,
                                   'Active', 'SwReg', 'IAM/11/09/2020', blank, 'Guidanz Mobile Immediate Assessment Dealer', blank, false);
      /*IAM_TestData.createUserSubscription(con.Id, app2.Id, 'Guidanz Mobile', 'Guidanz Mobile IA', Date.today(), Date.today()+200,
                                   'Active', 'SwReg', 'IAM/11/09/2020', blank, 'Guidanz Mobile Immediate Assessment Dealer', blank);*/
        IAM_Application__c app3 = IAM_TestData.createAccountSubscription(accId, 'EDS', 'QuickServe Online EBU', Date.today(), Date.today()+200,
                                   'Active', 'SwReg', blank, blank, Label.IAM_Default_Role_EDS_External_Acc, blank, false);
        insert app3;
    }
    
    private static IAM_ExistingLocationSubscriptionInfo.LocationSubscriptionInfo getSubscription(
        String appName, String subName, Date stDate, Date edDate, String subType,
        String source, String swExpire, String qsolExpire, String role, String licenseType, Boolean free) {        
        IAM_ExistingLocationSubscriptionInfo.LocationSubscriptionInfo sub 
            = new IAM_ExistingLocationSubscriptionInfo.LocationSubscriptionInfo();
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
        return sub;
    }   
}