/************************************************************
Name:  MockHttpResponseGenerator
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
Apex Class to make call to ldap to deactivate user.   2                      
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION         AUTHOR                DATE              DETAIL                                
1.0 -    Shuabhngi Sardar          11/16/2018        INITIAL DEVELOPMENT
1.1 -    Karthik Raj Golakaram     11/16/2020    Made Changes to the class for Mule API Conversion     
*****************************************************/
/********************************************************************************
***********************************************************************************/
@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
       
       String resBody='[{"uid":"ldaptestuser@gmail.com.iamosmdev","status":"User has been successfully removed from LDAP group.","reason":""}]';
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(resBody);
        res.setStatusCode(200);
        return res;
    }
}