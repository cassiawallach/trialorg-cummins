@isTest
global class FSLMakeModelToken implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        {
            //Create a fake response
            res.setHeader('Content-Type','application/x-www-form-urlencoded');
            res.setBody('{"wT8uFrak4EsURZsCerOBedRsSTyRoxdk1KjUSHkNGLaG3yVarNQFns"}');
        }
        return res;
    }
}