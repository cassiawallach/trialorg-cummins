@isTest
private class IAM_NewUserCreation_Test {
    
    /* Create Primary User */
    static testmethod void createPrimaryUserTest() {
        Account acc = IAM_TestData.createAccount();
        Test.startTest();
        IAM_NewUserCreation.userInfo userInfo = getUserInfo('PGA 01', 'LDAP', '123456789', 'Primary', 'test@test.com',
        'Active', 'test@test.com', '1', 'lname', 'fname');
        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/user/Newuser/'
            + acc.IAM_Service_Provider_Code__c;
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_NewUserCreation.CMI_ResponseHandler3 res =
            IAM_NewUserCreation.Post(userInfo);
        System.assert(res != null);
        System.assertEquals('Success', res.status);
        Test.stopTest();
    }
    
    /* Create Secondary User */
    static testmethod void createSecondaryUserTest() {
        Account acc = IAM_TestData.createAccount();       
        Test.startTest();
        IAM_NewUserCreation.userInfo userInfo = getUserInfo('PGA 01', 'LDAP', '123456789', 'Secondary', 'test@test.com',
        'Active', 'test@test.com', '0', 'lname', 'fname');
        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/user/Newuser/'
            + acc.IAM_Service_Provider_Code__c;
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_NewUserCreation.CMI_ResponseHandler3 res =
            IAM_NewUserCreation.Post(userInfo);
        System.assert(res != null);
        System.assertEquals('Success', res.status);
        Test.stopTest();
    }
    
    /* Create User - Insufficient Data Test */
    static testmethod void exceptionTest1() {
        Test.startTest();
        IAM_NewUserCreation.userInfo userInfo = getUserInfo(null, '', null, '', '','', null, '', '', '');
        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/user/Newuser/12345666';
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_NewUserCreation.CMI_ResponseHandler3 res =
            IAM_NewUserCreation.Post(userInfo);
        System.assert(res != null);
        System.assertEquals('error', res.status);
        Test.stopTest();
    }
    
    /* Exception Test - Invalid username */
    static testmethod void exceptionTest2() {
        Account acc = IAM_TestData.createAccount();       
        Test.startTest();
        IAM_NewUserCreation.userInfo userInfo = getUserInfo('PGA 01', 'LDAP', '123456789', 'Primary', 'te st@test.com',
        'Active', 'test@test.com', '0', 'lname', 'fname');
        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/user/Newuser/'
            + acc.IAM_Service_Provider_Code__c;
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_NewUserCreation.CMI_ResponseHandler3 res =
            IAM_NewUserCreation.Post(userInfo);
        System.assert(res != null);
        //System.assertEquals('error', res.status);
        Test.stopTest();
    }
    
    /* Exception Test - Validate Email */
    static testmethod void exceptionTest3() {
        Test.startTest();
        List<String> strList = new List<String>();
        strList.add('test@test.com');
        Boolean res = IAM_NewUserCreation.validateEmail(strList);
        System.assert(res);
        List<String> strList1 = new List<String>();
        strList1.add('t est@test.com');
        Boolean res1 = IAM_NewUserCreation.validateEmail(strList1);
        System.assert(!res1);
        Test.stopTest();
    }
    
    /* Create a request wrapper */
    private static IAM_NewUserCreation.userInfo getUserInfo(String pga, String source, String phone, String contactType,
    String username, String contactStatus, String email, String siteAdmin, String lastName, String firstName) {
        IAM_NewUserCreation.userInfo obj = new IAM_NewUserCreation.userInfo();
        obj.pga = pga;
        obj.source = source;
        obj.phone = phone;
        obj.contactType = contactType;
        obj.username = username;
        obj.contactStatus = contactStatus;
        obj.email = email;
        obj.siteAdmin = siteAdmin;
        obj.lastName = lastName;
        obj.firstName = firstName;
        return obj;
    }
}