@isTest
global class CSS_WS_TG_GetMakeModelAccessListMockTest implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //System.assertEquals('https://cummins--CSSDEV.cs50.my.salesforce.com/services/apexrest/Assess/V01/CSS/GetMakeModelAccessList/', req.getEndpoint());
        //System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"Header":{"Status":"Success","ServiceVersion":"1.0","ServiceName":"GetMakeModelAccessList","ReturnCodeDescription":"MakeModelAccess list sent successfully"},"DataArea":{"SERVICEMODELNAME":"ISX15 CM2250","SELECTMODEL":null,"SELECTMAKE":null,"SELECTACCESS":null,"PSN":"79484646","MAKEMODELACCESS":[{"MODEL":"Test1","MAKE":"Test1","ACCESS":"D"},{"MODEL":"Test2","MAKE":"Test2","ACCESS":"C"}]}}');
        res.setStatusCode(200);
        return res;
    }
}