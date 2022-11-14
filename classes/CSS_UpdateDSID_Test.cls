@isTest
global class CSS_UpdateDSID_Test implements HttpCalloutMock {
 global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        {
            //Create a fake response
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"key": "ds.error.dsiddoesntexist","message": "Error: Diagnostic Session not found"}');
        }
        return res;
    }
}