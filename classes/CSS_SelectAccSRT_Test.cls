@isTest
global class CSS_SelectAccSRT_Test implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        {
            //Create a fake response
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status":"success"}');
        }
        return res;
    }
}