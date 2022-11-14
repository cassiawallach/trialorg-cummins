@IsTest
Global class MockHttpAzure_Service implements HttpCalloutMock
{
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        //System.assertEquals('http://devcumminscarewebapp.azurewebsites.net/api/AddressMaster/GetState', req.getEndpoint());
        res.setHeader('Content-Type', 'application/json');
        string jsonstr ='[{"OutputData":"Ongole"},{"OutputData":"Guntur"},{"OutputData":"Vijayawada"}]';
        res.setBody(jsonstr);
        res.setStatusCode(200);
        System.debug(':::::::'+res.getBody());
        return res;
    }
}