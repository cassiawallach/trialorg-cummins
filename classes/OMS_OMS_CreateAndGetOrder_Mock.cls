global class OMS_OMS_CreateAndGetOrder_Mock implements HttpCalloutMock
{
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatus('OK');
        res.setStatusCode(200);
        
       /* if(req.getEndpoint() == 'https://services-dev-oauth.cummins.com/api/oauth/token/cso')
        {
            res.setBody('Status: OK,Status Code: 200,Response Body: { "access_token": "d6GmuFf6yeAzXSZHjQWM4dQPEQJguIwv2vc0jNngAwppA1YoViZ4J7", "token_type": "Bearer", "expires_in": 24000, "refresh_token": "QZYajnEvAZsXIMw5rOWfj40vsRDtGUIfMwJbXrbxDctqW6", "scope": "CSO"}');
        }
        */
        if(req.getMethod() == 'POST')
        {
            res.setBody('{"Header":{"Sender":{"ServiceName":"CreateOrder","SenderID":"Mrktplc"},"Target":{"TargetID":"OMS"}},"CreateOrderOutput":{"OMSOrderID":77903}}');
        }
        if(req.getMethod() == 'PUT')
        {
            res.setBody('{"Header":{"Sender": {"ServiceName": "GetOrder","SenderID": "Mrktplc"},"Target": {"TargetID": "OMS"}},"ItemInfoList": {"ItemInfo": [{"LicenseInfo": {"LicenseName": "MR-HD Automotive Pro","ActivationKey": "Z5CWMUXUUFZA"},"ItemId": 78395}]}}');
        }
        // Create a fake response
        
        System.debug('JK1 : ' + res.getBody());
        return res;
    }
}