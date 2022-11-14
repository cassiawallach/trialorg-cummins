/*************************************************************************************
Name:  IAM_AcConSubsCreation_Test
Copyright © 2019  Cummins
**************************************************************************************
Purpose: Test Class for IAM_AcConSubsCreation
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION         AUTHOR            DATE              DETAIL                                
1.0      Karthik Golakaram      10/12/2019      INITIAL DEVELOPMENT 
1.1      Shubhangi Sardar       09/23/2021      Assigned Value from Label to IAM_Subscription_Count__c
**************************************************************************************
**************************************************************************************/

@isTest
public class IAM_AcConSubsCreation_Test {
    
    /* Create QSOL Subdcription - No Existing Account Access Feature */
    static testmethod void createQSOLSubTest1() {
        Test.startTest();
        IAM_AcConSubsCreation.RegistrationInfo sub =
            getSubscription('English', 'US and Canada', 'SAINT JOHN', 'Active', 'E2J 2S8', 'Dealer Account', 'New Brunswick', '1234', 'CA',
            '1', '', 'Partner', '351 MCALLISTER DR', 'Test Account', 'QSOL Dealer', 'IAM/11/09/2020', false, 'Active',
            'QuickServe Online', 'SwReg', Date.today()+365, 'QSOL EBU', Date.today(), 'fnamelnameOne@test.com',
            '6767676767', 'fnamelnameOne@test.com', 'PGA01', 'lname', 'fname', 'Primary', false, 'Active');
        
        
        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/IAMregistration/';
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_AcConSubsCreation.CMI_ResponseHandler res =
            IAM_AcConSubsCreation.Post(sub);
        System.assertEquals(true, res != null);
        System.assertEquals('Success', res.Status);
        Test.stopTest();
    }
    
    /* Create QSOL Subcription - Exception Test - Status values are wrong. 
    It should be Active, to generate error we are giving Act */
    static testmethod void exceptionTest() {
        Test.startTest();
        IAM_AcConSubsCreation.RegistrationInfo sub =
            getSubscription('English', 'US and Canada', 'SAINT JOHN', 'Act', 'E2J 2S8', 'Dealer Account', 'New Brunswick', '1234', 'CA',
            '1234', '', 'Partner', '351 MCALLISTER DR', 'Test Account', 'QSOL Dealer', 'IAM/11/09/2020', false, 'Act',
            'QuickServe Online', 'SwReg', Date.today()+365, 'QSOL EBU', Date.today(), 'fnamelnameOne@test.com',
            '6767676767', 'fnamelnameOne@test.com', 'PGA01', 'lname', 'fname', 'Primary', false, 'Active');
        
        
        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/IAMregistration/';
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_AcConSubsCreation.CMI_ResponseHandler res =
            IAM_AcConSubsCreation.Post(sub);
        System.assertEquals(true, res != null);
        System.assertEquals('error', res.Status);
        Test.stopTest();
    }
    
    /* Validate Field Data */
    static testmethod void validateRequestTest() {
        Test.startTest();
        IAM_AcConSubsCreation.RegistrationInfo sub =
            getSubscription(null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null,
                           null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null);
        
        
        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/IAMregistration/';
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_AcConSubsCreation.CMI_ResponseHandler res =
            IAM_AcConSubsCreation.Post(sub);
        System.assertEquals(true, res != null);
        System.assertEquals('error', res.Status);
        Test.stopTest();
    }
    
    /* Validate Email */
    static testmethod void validateEmailTest() {
        Test.startTest();
        List<String> email = new List<String>();
        email.add('abc@test.com');
        Boolean isValid = IAM_AcConSubsCreation.validateEmail(email);
        System.assertEquals(true, isValid);
        Test.stopTest();
    }
    
    /* Picklist Values Test */
    static testmethod void validatePicklistValTest() {
        Test.startTest();
        Set<string> tmplist = IAM_AcConSubsCreation.getPicklistValues('BillingStateCode','Account');
        System.assertEquals(true, tmplist != null);
        Test.stopTest();
    }
    
    /* Prepare Subcription Data for Request Body */
    private static IAM_AcConSubsCreation.RegistrationInfo getSubscription(String language, String region, String city,
        String accStatus, String zipCode, String type, String stateName, String distCode, String countryName,
        String aboCode, String addLine2, String accSource, String addLine1, String name, String role, String qsolExpire,
        Boolean free, String subType, String appName, String source, Date endDate, String subName, Date stDate, String username,
        String phone, String email, String pga, String lname, String fname, String conType, Boolean siteAdmin, String conStatus) {          
            
        IAM_AcConSubsCreation.RegistrationInfo mainSub = new IAM_AcConSubsCreation.RegistrationInfo();
        IAM_AcConSubsCreation.LocationPayloadInfo location = new IAM_AcConSubsCreation.LocationPayloadInfo();
        IAM_AcConSubsCreation.subscriptionInfo sub = new IAM_AcConSubsCreation.subscriptionInfo();
        IAM_AcConSubsCreation.userInfo usr = new IAM_AcConSubsCreation.userInfo();
       	
        /* Location Info */
      	location.language = language;
		location.region = region;
		location.city = city;
		location.accountStatus = accStatus;
		location.zipCode = zipCode;
		location.type = type;
		location.stateName = stateName;
		location.distributorCode = distCode;
		location.countryName = countryName;
		location.aboCode = aboCode;
		location.addressLine2 = addLine2;
		location.accountSource = accSource;
		location.addressLine1 = addLine1;
		location.name = name;        
        mainSub.LocationPayloadInfo = location;
            
        /* subscription Info */
        sub.role = role;
		sub.qsolExpiration = qsolExpire;
		sub.free = free;
		sub.subscriptionType = subType;
		sub.applicationName = appName;
		sub.source = source;
		sub.endDate = endDate;
		sub.subscriptionName = subName;
		sub.startDate = stDate;
        mainSub.subscriptionInfo = sub;
        
        /* User Info */
        usr.username = username;
		usr.phone = phone;
		usr.email = email;
		usr.pga = pga;
		usr.lastName = lname;
		usr.source = source;
		usr.firstName = fname;
		usr.contactType = conType;
		usr.siteAdmin = siteAdmin;
		usr.contactStatus = conStatus;
        mainsub.userInfo = usr;            
        return mainSub;
    }
}