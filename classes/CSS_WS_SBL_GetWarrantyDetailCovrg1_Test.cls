@isTest
global class CSS_WS_SBL_GetWarrantyDetailCovrg1_Test implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"Header":{"ReturnCodeDescription":"","Status":"Success"}}');
        res.setStatusCode(200);
        return res;
    }
}