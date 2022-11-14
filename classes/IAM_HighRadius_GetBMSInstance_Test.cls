/*Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test class for IAM_HighRadius_GetBMSInstance_Test class. 
BMS Instance for HighRadius.                         
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                   DATE              DETAIL                                
1.0 -    Nishant Verma          04/12/2020       INITIAL DEVELOPMENT       
*****************************************************/
/********************************************************************************
***********************************************************************************/
@isTest
public class IAM_HighRadius_GetBMSInstance_Test {
       /* Return Disable User, Update User Attribute and Revoke Token API success response body */
    private static String getServiceResonseBodySuccess() {
        return '{"MessageIdentifier": "2-0e8785c0-7aea-11ea-a540-028c02b44b96", "ReturnCode": "200", "ReturnCodeDescription": "Success", "status": "Success", "Message": "test"}';    
    }
     /* Create - CSS_Integration_Details__c - IAM_AWSCognito_Auth */
    public static void IAM_HighRadius_GetAuthToken() {
        createCSSIntegrationDetails('IAM_HighRadius_Auth', 'IAM_HighRadius_Auth', '', 'https://api-ue-devnf-aw-ex.cummins.com:443/api/core-security-api/v1/auth/token',
        '', true, 'eV72-IPCQg5T5wM?jEqp=x_oQisWP7SZ	', '', 'POST', '5b079001-b8eb-41ad-900a-5e549835612f', 120000, '', 'https://api-ue-devnf-aw-ex.cummins.com/customers');
        
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
    static testmethod void testSuccessResponse() {        
        IAM_TestData.create_IAM_HighRadius_BMSInstance_CS();
        String responseBody = '{"status":"SUCCESS","message":"Customer code successfully validated","instance":"ONEBMS","erpCustomerCode":"272629-USA"}';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBody, null));
        IAM_HighRadius_GetBMSInstance.getBMSInstance('561251', '75-28162');
        Test.stopTest();
    }

	static testmethod void testFailureResponse() {
        IAM_TestData.create_IAM_HighRadius_BMSInstance_CS();
        String responseBody = '{"status":"Error","message":"Error Message","instance":"ONEBMS","erpCustomerCode":""}';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBody, null));
        IAM_HighRadius_GetBMSInstance.getBMSInstance('561251', '75-28162');
        Test.stopTest();
    }
    
    static testmethod void testExceptionResponse() {
        String responseBody = '{"status":"Error","message":"Error Message","instance":"ONEBMS","erpCustomerCode":""}';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBody, null));
        IAM_HighRadius_GetBMSInstance.getBMSInstance('561251', '75-28162');
        Test.stopTest();
    }
    
    /* Return HighRadius Authentication API response body*/
    private static String getAuthResonseBody() {
        return '{"token_type": "Bearer", "expires_in": "3599", "ext_expires_in": "3599", "expires_on": "1586499076", "not_before": "1586495176", "resource": "https://api-ue-stgnf3-aw-in.cummins.com/cmi-iam", "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IllNRUxIVDBndmIwbXhvU0RvWWZvbWpxZmpZVSIsImtpZCI6IllNRUxIVDBndmIwbXhvU0RvWWZvbWpxZmpZVSJ9.eyJhdWQiOiJodHRwczovL2FwaS11ZS1zdGduZjMtYXctaW4uY3VtbWlucy5jb20vY21pLWlhbSIsImlzcyI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0L2IzMWE1ZDg2LTZkZGEtNDQ1Ny04NWU1LWM1NWJiYzA3OTIzZC8iLCJpYXQiOjE1ODY0OTUxNzYsIm5iZiI6MTU4NjQ5NTE3NiwiZXhwIjoxNTg2NDk5MDc2LCJhaW8iOiI0MmRnWVBqRis1VC96SWFidTA2eWI5Y3FXVmZ4QlFBPSIsImFwcGlkIjoiYWQ3MjQzOTItNTU5NC00ZTg1LWI5ZWItYjBmYzE5YzJmYWJlIiwiYXBwaWRhY3IiOiIxIiwiaWRwIjoiaHR0cHM6Ly9zdHMud2luZG93cy5uZXQvYjMxYTVkODYtNmRkYS00NDU3LTg1ZTUtYzU1YmJjMDc5MjNkLyIsIm9pZCI6ImJiYmYzNTQyLWJmNjUtNGIzOS1hYjM4LTMwMDM2NmNmYmIwZCIsInN1YiI6ImJiYmYzNTQyLWJmNjUtNGIzOS1hYjM4LTMwMDM2NmNmYmIwZCIsInRpZCI6ImIzMWE1ZDg2LTZkZGEtNDQ1Ny04NWU1LWM1NWJiYzA3OTIzZCIsInV0aSI6InpWcFBvNEhXMVVTSDV1d0Z5MFFWQUEiLCJ2ZXIiOiIxLjAifQ.gbn2Kc5DbeGMHantkksslkjSVKfIKhcqtPubJY4bvkwkR0ndwvEKW6YeZsS5w5mXwhHb0xGwDvyVArD1Zc5Oitqb33E9pQMnKlH7vu-UvhQqWrCcnsXJavc2w91WvIRGAcu67CtQP44TS-vNMc0qj-AaO8tRi08mF1UBXPuOxtEer8P-ett_hprXInx1DcQaHAefLMksAie2E7iwIBkLAXMHlwVBsCICQ-HLrWEIdQod8mK8ySMFpVhsUuq3HtNvPS0swQAwUOYrAODTi4ItIzLV-m13fcTx_Ot52PU4WOePdgEB7EIoQpqwI2AXNfMFMdZXQlX1To7FPVAyhgqWlQ"}';    
    }
    
    static testmethod void testAuthSuccessResponse() {
        IAM_TestData.create_IAM_IAM_HighRadius_Auth_CS();
        String responseBodyAuth = getAuthResonseBody();
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyAuth, null));
        String accessToken;
        Test.startTest();
            accessToken = IAM_HighRadius_GetAuthToken.getAccessToken('IAM_HighRadius_Auth');
        Test.stopTest();
        System.assert(String.isNotBlank(accessToken));
    }
    
    static testmethod void testAuthExceptionResponse() {
        String responseBodyAuth = getAuthResonseBody();
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyAuth, null));
        String accessToken;
        Test.startTest();
            accessToken = IAM_HighRadius_GetAuthToken.getAccessToken('IAM_HighRadius_Auth');
        Test.stopTest();
        System.assert(String.isBlank(accessToken));
    } 
}