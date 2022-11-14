@IsTest
private class IAM_AccountCreationTest {
    
    /* Create Account */
    static testmethod void createAccountTest() {
        Account acc = createAccount();
        Test.startTest();
        IAM_AccountCreation.LocationPayloadInfo accInfo = getLocationInfo('Test Acc 2', 'CA', 'Street 123', 
        	'Test St', 'SAINT JOHN', 'New Brunswick', 'E2J 2S8', 'English', 'US and Canada', 'Active', '56330',
            'Dealer Account', '56330', 'Partner');
        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/IAMaccount';
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_AccountCreation.CMI_ResponseHandler res =
            IAM_AccountCreation.Post(accInfo);
        System.assertEquals(true, res != null);
        System.assertEquals('Success', res.status);
        Test.stopTest();
    }
    
    /* Exception - Create Account - Passing Country Name instead Country Code */
    static testmethod void exceptionCreateAccountTest() {
        Account acc = createAccount();
        Test.startTest();
        IAM_AccountCreation.LocationPayloadInfo accInfo = getLocationInfo('Test Acc 2', 'Canada', 'Street 123', 
        	'Test St', 'SAINT JOHN', 'New Brunswick', 'E2J 2S8', 'English', 'US and Canada', 'Active', '56330',
            'Dealer Account', '56330', 'Partner');
        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/IAMaccount';
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_AccountCreation.CMI_ResponseHandler res =
            IAM_AccountCreation.Post(accInfo);
        System.assertEquals(true, res != null);
        System.assertEquals('error', res.status);
        Test.stopTest();
    }
    
    /* Validate request with few incorrect values */
    static testmethod void validateRequest1() {
        Account acc = IAM_TestData.createAccount();
        Test.startTest();
        IAM_AccountCreation.LocationPayloadInfo accInfo = getLocationInfo('Test Acc 2', 'Canada', 'Street 123', 
        	'Test St', 'SAINT JOHN', 'Test Check', 'E2J 2S8', 'Test Check', 'Test Check', 'Active', '50000',
            'Dealer Account', '56330', 'Partner');
        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/IAMaccount';
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_AccountCreation.CMI_ResponseHandler res =
            IAM_AccountCreation.Post(accInfo);
        System.assertEquals(true, res != null);
        System.assertEquals('error', res.status);
        Test.stopTest();
    }
    
    /* Validate request with all null/blank values */
    static testmethod void validateRequest2() {
        Account acc = IAM_TestData.createAccount();
        Test.startTest();
        IAM_AccountCreation.LocationPayloadInfo accInfo = getLocationInfo(null, null, null, 
        	null, null, null, null, null, null, null, null, null, null, null);
        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/IAMaccount';
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_AccountCreation.CMI_ResponseHandler res =
            IAM_AccountCreation.Post(accInfo);
        System.assertEquals(true, res != null);
        System.assertEquals('error', res.status);
        Test.stopTest();
    }
    
    /* Validate Email */
    static testmethod void validateEmailTest() {
        Test.startTest();
        List<String> email = new List<String>();
        email.add('abc@test.com');
        Boolean isValid = IAM_AccountCreation.validateEmail(email);
        System.assertEquals(true, isValid);
        Test.stopTest();
    }
    
    public static Account createAccount() {
        Account acc = new account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc.name = 'Test Account';
        acc.BillingCountryCode = 'CA';
        acc.CMI_Address2__c = '';
        acc.BillingStreet = '351 MCALLISTER DR'; 
        acc.BillingCity = 'SAINT JOHN';
        acc.BillingCountry='Canada';
        acc.BillingStateCode = 'NB';
        acc.BillingPostalCode = 'E2J 2S8';
        acc.BillingState='New Brunswick';        

        acc.CSS_DistributorCode__c='56330';
        acc.CSS_DealerCode__c='test';
        
        acc.Type = 'Distributor Account';
        acc.IAM_Service_Provider_Code__c = '56330';
        insert acc;
        return acc;
    }
    
    private static IAM_AccountCreation.LocationPayloadInfo getLocationInfo(String name, String countryName,
        String addressLine1, String addressLine2, String city, String stateName, String zipCode, String language,
        String region, String accountStatus, String distributorCode, String type, String aboCode, String accountSource) {
        IAM_AccountCreation.LocationPayloadInfo obj = new IAM_AccountCreation.LocationPayloadInfo();
        obj.name = name;
        obj.countryName = countryName;
        obj.addressLine1 = addressLine1;
        obj.addressLine2 = addressLine2;
        obj.city = city;
        obj.stateName = stateName;
        obj.zipCode = zipCode;
        obj.language = language;
        obj.region = region;
        obj.accountStatus = accountStatus;
        obj.distributorCode = distributorCode;
        obj.type = type;
        obj.aboCode = aboCode;
        obj.accountSource = accountSource;
        return obj;
    }
}