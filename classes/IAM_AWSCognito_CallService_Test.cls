/*************************************************************************************
Name:  IAM_AWSCognito_CallService_Test
Copyright © 2019  Cummins
**************************************************************************************
Purpose: Test Class for IAM_AWSCognito_CallService for all methods
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION         AUTHOR            DATE              DETAIL                                
1.0      Shubhangi Sardar      10/12/2019      INITIAL DEVELOPMENT 
1.1      Shubhangi Sardar      01/05/2021      Added Comment to push to production
1.2      Shubhangi Sardar      12/03/2020      Added comment to push NPBU Diagnostic Expration change
1.3      Karthik Raj Golakaram 01/25/2021      Making Changes for OSM High Prod issue - INC1022619
1.4      Shubhangi Sardar      06/18/2021      Added customer Code attribute
1.5      Shubhangi Sardar      09/07/2021      Added error logs to capture report
**************************************************************************************
**************************************************************************************/

@isTest
public class IAM_AWSCognito_CallService_Test {
    
    /* Return Disable User, Update User Attribute and Revoke Token API success response body */
    private static String getServiceResonseBodySuccess() {
        return '{"MessageIdentifier": "2-0e8785c0-7aea-11ea-a540-028c02b44b96", "ReturnCode": "200", "ReturnCodeDescription": "Success", "status": "Success", "Message": "Successfully updated attributes for user:Guidanz15test@guidanz.com"}';    
    }
    
    /* Return Disable User, Update User Attribute and Revoke Token API failure response body */
    private static String getServiceResonseBodyFailure() {
        return '{"MessageIdentifier": "2-0e8785c0-7aea-11ea-a540-028c02b44b97", "ReturnCode": "400", "ReturnCodeDescription": "Error", "status": "Error", "Message": "User does not exist :Guidanz15test@guidanz.com"}';    
    }
    
    /* Return AWS Cognito Authentication API response body*/
    private static String getAuthResonseBody() {
        return '{"token_type": "Bearer", "expires_in": "3599", "ext_expires_in": "3599", "expires_on": "1586499076", "not_before": "1586495176", "resource": "https://api-ue-stgnf3-aw-in.cummins.com/cmi-iam", "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IllNRUxIVDBndmIwbXhvU0RvWWZvbWpxZmpZVSIsImtpZCI6IllNRUxIVDBndmIwbXhvU0RvWWZvbWpxZmpZVSJ9.eyJhdWQiOiJodHRwczovL2FwaS11ZS1zdGduZjMtYXctaW4uY3VtbWlucy5jb20vY21pLWlhbSIsImlzcyI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0L2IzMWE1ZDg2LTZkZGEtNDQ1Ny04NWU1LWM1NWJiYzA3OTIzZC8iLCJpYXQiOjE1ODY0OTUxNzYsIm5iZiI6MTU4NjQ5NTE3NiwiZXhwIjoxNTg2NDk5MDc2LCJhaW8iOiI0MmRnWVBqRis1VC96SWFidTA2eWI5Y3FXVmZ4QlFBPSIsImFwcGlkIjoiYWQ3MjQzOTItNTU5NC00ZTg1LWI5ZWItYjBmYzE5YzJmYWJlIiwiYXBwaWRhY3IiOiIxIiwiaWRwIjoiaHR0cHM6Ly9zdHMud2luZG93cy5uZXQvYjMxYTVkODYtNmRkYS00NDU3LTg1ZTUtYzU1YmJjMDc5MjNkLyIsIm9pZCI6ImJiYmYzNTQyLWJmNjUtNGIzOS1hYjM4LTMwMDM2NmNmYmIwZCIsInN1YiI6ImJiYmYzNTQyLWJmNjUtNGIzOS1hYjM4LTMwMDM2NmNmYmIwZCIsInRpZCI6ImIzMWE1ZDg2LTZkZGEtNDQ1Ny04NWU1LWM1NWJiYzA3OTIzZCIsInV0aSI6InpWcFBvNEhXMVVTSDV1d0Z5MFFWQUEiLCJ2ZXIiOiIxLjAifQ.gbn2Kc5DbeGMHantkksslkjSVKfIKhcqtPubJY4bvkwkR0ndwvEKW6YeZsS5w5mXwhHb0xGwDvyVArD1Zc5Oitqb33E9pQMnKlH7vu-UvhQqWrCcnsXJavc2w91WvIRGAcu67CtQP44TS-vNMc0qj-AaO8tRi08mF1UBXPuOxtEer8P-ett_hprXInx1DcQaHAefLMksAie2E7iwIBkLAXMHlwVBsCICQ-HLrWEIdQod8mK8ySMFpVhsUuq3HtNvPS0swQAwUOYrAODTi4ItIzLV-m13fcTx_Ot52PU4WOePdgEB7EIoQpqwI2AXNfMFMdZXQlX1To7FPVAyhgqWlQ"}';    
    }
    
    /* Create - CSS_Integration_Details__c - IAM_AWSCognito_Auth */
    public static void create_IAM_AWSCognito_Auth_CS() {
        createCSSIntegrationDetails('IAM_AWSCognito_Auth', 'IAM_AWSCognito_Auth', '', 'https://api-ue-devnf3-aw-ex.cummins.com:443/api/core-security-api/v1/auth/token',
        '', true, 'rZAd55IuOWyWUkvYaYqixRv2DPXOGc9QQP5XssF8cH6O3aCoePMrMK/dZ50jN5F6aqI/LFOVVKtE4QzlUKDxWA==', '', 'POST', 'wOXXcO0IDYfpb8RvkBN6ut8UaHhHdLM0IcvcQLR/NhsVRBgClv0XJvjJorIhNsMsu60kbGmqrvDXZAfr8vzVSw==', 120000, '', 'https://api-ue-devnf3-aw-in.cummins.com/cmi-iam');
    }
    
    /* Create - CSS_Integration_Details__c - IAM_AWSCognito_UserAction */
    public static void create_IAM_AWSCognito_UserAction_CS() {
        createCSSIntegrationDetails('IAM_AWSCognito_UserAction', 'IAM_AWSCognito_UserAction', '', 'https://api-ue-devnf3-aw-ex.cummins.com/cmi-iam/v1/awscognito/users',
        '', true, '24296202-ef54-4be0-bf84-0d1d9cc2c567', '', '', '24296202-ef54-4be0-bf84-0d1d9cc2c567', 120000, '', '');
    }
    
    /* Create Custom Setting CSS_Integration_Details__c */
    public static void createCSSIntegrationDetails(String name, String appName, String authEnv, String endpoint, 
        String grantType, Boolean isActive, String key, String logging, String methodType, String passcode, 
        Integer timeout, String username, String resource) {
        CSS_Integration_Details__c obj = new CSS_Integration_Details__c();
        obj.Name = name;
        obj.ApplicationName__c = appName;
        obj.AuthEnv__c = authEnv;
        obj.End_Point__c = endpoint;
        obj.grant_type__c = grantType;
        obj.IsActive__c = isActive;
        obj.Key__c = key;
        obj.Logging__c = logging;
        obj.Method_Type__c = methodType;
        obj.Passcode__c = passcode;
        obj.Timeout__c = timeout;
        obj.Username__c = username;
        obj.Resource__c = resource;
        insert obj;
    }
    
    /* Call access token service with oauth integration details */
    static testmethod void callAccessTokenServicePositive() {
        create_IAM_AWSCognito_Auth_CS();
        String responseBodyAuth = getAuthResonseBody();
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyAuth, null));
        String accessToken;
        Test.startTest();
            accessToken = IAM_AWSCognito_GetAuthToken.getAccessToken('IAM_AWSCognito_Auth');
        Test.stopTest();
        System.assert(String.isNotBlank(accessToken));
    }
    
    /* Call access token service without oauth integration details */
    static testmethod void callAccessTokenServiceNegative() {
        String responseBodyAuth = getAuthResonseBody();
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyAuth, null));
        String accessToken;
        Test.startTest();
            accessToken = IAM_AWSCognito_GetAuthToken.getAccessToken('IAM_AWSCognito_Auth');
        Test.stopTest();
        System.assert(String.isBlank(accessToken));
    }
    
    /* call Disable User API with Success Response */
    static testmethod void callDisableServiceSuccessResponse() {
        create_IAM_AWSCognito_UserAction_CS();
        String responseUserAction = getServiceResonseBodySuccess();
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseUserAction, null));
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        Test.startTest();
            Contact newContact = [Select Id, IAM_Contact_Status__c FROM Contact WHERE Id =: con.Id];
            newContact.IAM_Contact_Status__c = 'Inactive';
            update newContact;  
        Test.stopTest();
        Contact updatedContact = [SELECT Id, IAM_Contact_Status__c FROM Contact WHERE Id =: con.Id];
        System.assert(updatedContact.IAM_Contact_Status__c == 'Inactive');
    }
    
    /* call Disable User API with Failure Response */
    static testmethod void callDisableServiceFailureResponse() {
        create_IAM_AWSCognito_UserAction_CS();
        String responseUserAction = getServiceResonseBodyFailure();
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseUserAction, null));
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        Test.startTest();
            Contact newContact = [Select Id, IAM_Contact_Status__c FROM Contact WHERE Id =: con.Id];
            newContact.IAM_Contact_Status__c = 'Inactive';
            update newContact;  
        Test.stopTest();
        Contact updatedContact = [SELECT Id, IAM_Contact_Status__c FROM Contact WHERE Id =: con.Id];
        System.assert(updatedContact.IAM_Contact_Status__c == 'Inactive');
    }
    
    /* call Disable User API with saleforce exception */
    static testmethod void callDisableServiceWithException() {        
        String responseUserAction = getServiceResonseBodySuccess();
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseUserAction, null));
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        Test.startTest();
            Contact newContact = [Select Id, IAM_Contact_Status__c FROM Contact WHERE Id =: con.Id];
            newContact.IAM_Contact_Status__c = 'Inactive';
            update newContact;  
        Test.stopTest();
        Contact updatedContact = [SELECT Id, IAM_Contact_Status__c FROM Contact WHERE Id =: con.Id];
        System.assert(updatedContact.IAM_Contact_Status__c == 'Inactive');
    }
    
    /* call Update User API with Success Response */
    static testmethod void callUpdateServiceSuccessResponse() {
        create_IAM_AWSCognito_UserAction_CS();
        String responseUserAction = getServiceResonseBodySuccess();
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseUserAction, null));
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        Test.startTest();
            Contact newContact = [
                SELECT Id
                     , FirstName
                     , LastName
                     , IAM_Product_Group_Access__c
                     , IAM_NpbuDiagExpire__c
                     , IAM_swregexpire__c
                     , IAM_Work_Group_Id__c
                     , Username__c
                  FROM Contact
                 WHERE Id =: con.Id
            ];
            newContact.FirstName = 'NewTestName';
            newContact.LastName = 'NewTestName';
            newContact.IAM_Product_Group_Access__c = 'P1004';
            newContact.IAM_NpbuDiagExpire__c = 'Test 1004';
            newContact.IAM_swregexpire__c = 'Test 1004';
            newContact.IAM_Work_Group_Id__c = 'Test 1004';
            newContact.Username__c = 'test10042@test.com';
            update newContact;  
        Test.stopTest();
        Contact updatedContact = [SELECT Id, Username__c FROM Contact WHERE Id =: con.Id];
        System.assert(updatedContact.Username__c == 'test10042@test.com');
    }

    /* call Update User API with Success Response */
    static testmethod void callUpdateServiceSuccessResponsePT() {
        create_IAM_AWSCognito_UserAction_CS();
        String responseUserAction = getServiceResonseBodySuccess();
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseUserAction, null));
        Account acc = IAM_TestData.createAccount();
        Contact con = createContact(acc.Id);
        Test.startTest();
            Contact newContact = [
                SELECT Id
                     , FirstName
                     , LastName
                     , IAM_Product_Group_Access__c
                     , IAM_NpbuDiagExpire__c
                     , IAM_swregexpire__c
                     , IAM_Work_Group_Id__c
                     , Username__c
                  FROM Contact
                 WHERE Id =: con.Id
            ];
            newContact.FirstName = 'NewTestName';
            newContact.LastName = 'NewTestName';
            newContact.IAM_Product_Group_Access__c = 'P1004';
            newContact.IAM_NpbuDiagExpire__c = 'Test 1004';
            newContact.IAM_swregexpire__c = 'Test 1004';
            newContact.IAM_Work_Group_Id__c = 'Test 1004';
            newContact.Username__c = 'test10042@test.com';
            update newContact;  
        Test.stopTest();
        Contact updatedContact = [SELECT Id, Username__c FROM Contact WHERE Id =: con.Id];
        System.assert(updatedContact.Username__c == 'test10042@test.com');
    }
    
    /* call Update User API with Failure Response */
    static testmethod void callUpdateServiceFailureResponse() {
        create_IAM_AWSCognito_UserAction_CS();
        String responseUserAction = getServiceResonseBodyFailure();
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseUserAction, null));
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        Test.startTest();
            Contact newContact = [
                SELECT Id
                     , IAM_swregexpire__c
                     , IAM_Work_Group_Id__c
                     , Username__c
                  FROM Contact
                 WHERE Id =: con.Id
            ];
            newContact.IAM_swregexpire__c = 'Test 1004';
            newContact.IAM_Work_Group_Id__c = 'Test 1004';
            newContact.Username__c = 'test10042@test.com';
            update newContact;  
        Test.stopTest();
        Contact updatedContact = [SELECT Id, Username__c FROM Contact WHERE Id =: con.Id];
        System.assert(updatedContact.Username__c == 'test10042@test.com');
    }
    
    /* call Update User API with saleforce exception */
    static testmethod void callUpdateServiceWithException() {        
        String responseUserAction = getServiceResonseBodySuccess();
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseUserAction, null));
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        Test.startTest();
            Contact newContact = [
                SELECT Id
                     , IAM_swregexpire__c
                     , IAM_Work_Group_Id__c
                     , Username__c
                  FROM Contact
                 WHERE Id =: con.Id
            ];
            newContact.IAM_swregexpire__c = 'Test 1004';
            newContact.IAM_Work_Group_Id__c = 'Test 1004';
            newContact.Username__c = 'test10042@test.com';
            update newContact;  
        Test.stopTest();
        Contact updatedContact = [SELECT Id, Username__c FROM Contact WHERE Id =: con.Id];
        System.assert(updatedContact.Username__c == 'test10042@test.com');
    }
    
    /* call Revoke Token API with Success Response */
    static testmethod void callRevokeServiceSuccessResponse() {        
        create_IAM_AWSCognito_UserAction_CS();
        String responseUserAction = getServiceResonseBodySuccess();
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseUserAction, null));
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        Contact newContact = [Select Id, Username__c FROM Contact WHERE Id =: con.Id];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', EmailEncodingKey='UTF-8', 
                          LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='test1041@testorg.com');        
        Test.startTest();
            User user = [SELECT Id, IAM_Lastpassword__c FROM User WHERE Username =: newContact.Username__c];
            user.IAM_Lastpassword__c = 'test123';
            System.runAs(u) {
                    update user;
            }
        Test.stopTest();        
        User updatedUser = [SELECT Id, IAM_Lastpassword__c FROM User WHERE Id =: user.Id];
        System.assert(updatedUser.IAM_Lastpassword__c == 'test123');
    }
    
    /* call Revoken Token API with Failure Response */
    static testmethod void callRevokeServiceFailureResponse() {
        create_IAM_AWSCognito_UserAction_CS();
        String responseUserAction = getServiceResonseBodyFailure();
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseUserAction, null));
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        Contact newContact = [Select Id, Username__c FROM Contact WHERE Id =: con.Id];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', EmailEncodingKey='UTF-8', 
                          LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='test1041@testorg.com');        
        Test.startTest();
            User user = [SELECT Id, IAM_Lastpassword__c FROM User WHERE Username =: newContact.Username__c];
            user.IAM_Lastpassword__c = 'test123';
            System.runAs(u) {
                    update user;
            }
        Test.stopTest();        
        User updatedUser = [SELECT Id, IAM_Lastpassword__c FROM User WHERE Id =: user.Id];
        System.assert(updatedUser.IAM_Lastpassword__c == 'test123');
    }
    
    /* call Revoke Token API with saleforce exception */
    static testmethod void callRevokeServiceWithException() {        
        String responseUserAction = getServiceResonseBodySuccess();
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseUserAction, null));
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        Contact newContact = [Select Id, Username__c FROM Contact WHERE Id =: con.Id];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', EmailEncodingKey='UTF-8', 
                          LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='test1041@testorg.com');        
        Test.startTest();
            User user = [SELECT Id, IAM_Lastpassword__c FROM User WHERE Username =: newContact.Username__c];
            user.IAM_Lastpassword__c = 'test123';
            System.runAs(u) {
                    update user;
            }
        Test.stopTest();        
        User updatedUser = [SELECT Id, IAM_Lastpassword__c FROM User WHERE Id =: user.Id];
        System.assert(updatedUser.IAM_Lastpassword__c == 'test123');    
    }

    static testmethod void callErrorHandlingMethods() {        
        Test.startTest();
        try {
            IAM_ErrorHandling.IAMerrorCapture('Test Error Methods', Label.IAM_AWSCognito, 
            'Test Error Methods', IAM_AWSCognito_CallService_Test.class.getName());
            String tst;
            tst.toUpperCase();
        } catch(Exception e) {
            IAM_ErrorHandling.Error obj = new IAM_ErrorHandling.Error('test', 'test', 'test',
            'test', e);
            IAM_ErrorHandling objErr = new IAM_ErrorHandling();
            objErr.createLog(obj);
        }
        Test.stopTest();
    }

    /* Create test contact data */
    public static Contact createContact(Id accId) {
        Contact con = new contact();
        con.AccountId = accId;
        con.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        con.FirstName = 'Fname1';
        con.LastName = 'Lname1';
        con.Email = 'fnamel1name1@test.com';
        con.Username__c = 'fnamel1name1@test.com';
        con.phone = '1112223336';
        con.IAM_Contact_Status__c = 'Active';
        con.CMI_Contact_Type__c='Secondary';
        con.IAM_Contact_source__c='QSOL';
        con.IAM_Person_Type__c = 'Contractor';
        insert con;
        return con;
    }
}