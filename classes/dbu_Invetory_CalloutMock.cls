@isTest
global class dbu_Invetory_CalloutMock implements HttpCalloutMock {
        // Implement this interface method
        global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals('https://api-ue-devnf3-aw-ex.cummins.com/cmi/om/v1/inventories/availablity?partNumber=123456&location=US', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('[{"example":"test"}]');
        res.setStatusCode(200);
        return res;
    }
}