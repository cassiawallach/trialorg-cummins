@isTest
global class CSS_WS_TG_IACSSJobMockTest_V4 implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"Header":{"toolId":"GUIDANZ","status":"Success","serviceVersion":"4.0","serviceName":"IACSSJobCreation","senderId":"rf671","returnCodeDescription":"CG01-Guidanz Job is created successfully"},"DataArea":{"woNumber":"CSS-00631655","iasNumber":"IAS-256"}}');
        res.setStatusCode(200);
        return res;
    }
}