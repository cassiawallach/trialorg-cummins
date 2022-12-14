/*********************************************************************************
Author       :   Sushma Rajput
Created Date :   4th September,2019
Description  :   Unit test class for  LDAP_util.
*********************************************************************************/
@isTest
global class MockHttpFakeResponse implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"example":"test"}');
        res.setStatusCode(200);
        return res;
    }
}