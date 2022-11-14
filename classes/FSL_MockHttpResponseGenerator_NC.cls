/************************************************************
Name:  FSL_MockHttpResponseGenerator_NC
Copyright © 2022  Cummins
=============================================================
=============================================================
Purpose:                                                            
Apex Class to make mock response using named credentials                      
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION         AUTHOR                DATE              DETAIL                                
1.0 -    Rajender Mittapalli          05/26/2022        INITIAL DEVELOPMENT     
*****************************************************/
@isTest
global class FSL_MockHttpResponseGenerator_NC implements HttpCalloutMock {
    
    string endpoint;
    string username;
    string password;
    string callbody;
    string responsebody ='{"Response":{"claim":{"serviceModelName":" oh559","claimSubSource":"Draft","possessionFlag":"oh559","claimStatus":"Draft","status":"SUCCESS","claimSource":"oh559"},"DecisionID":"2022-05-02T14:10:05.671-05:00"},"Header":{"Sender":{"ServiceName":"Mock_Service","SenderID":"oh559"},"Target":{"TargetID":"Mock_Target"}}}';
    string responseContentType = 'application/json';
    Integer responseStatus = 200;
    Map<String, String> callHeaders = new Map<String, String>();
    
    //Set the response body from test
    global FSL_MockHttpResponseGenerator_NC (string response){
        this.responsebody = response;
    }
    
    //Set the response status from test
    global FSL_MockHttpResponseGenerator_NC setResponseStatus(Integer status) {
        this.responseStatus = status;
        return this;
    }
    
    global HTTPResponse respond(HTTPRequest req) {
        this.endpoint = req.getendpoint();
        this.username = req.getHeader('client-id');
        this.password = req.getHeader('client-secret');
        this.callBody = req.getBody();
        this.callHeaders.put('content-type', req.getHeader('Content-Type'));
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(this.responsebody);
        res.setStatusCode(200);
        return res;
    }
}