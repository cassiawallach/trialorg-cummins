@isTest
global class CSS_GetdsidDetails_Test implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        {
             String json = '{\"Status\": true}';
            //Create a fake response
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody(json);
            }
        return res;
    }
}