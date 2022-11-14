@isTest
global class CSS_AccessToken_SRT_Test implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        {
            //Create a fake response
            res.setHeader('Content-Type','application/x-www-form-urlencoded');
            res.setBody('{"access_token": "wT8uFrak4EsURZsCerOBedRsSTyRoxdk1KjUSHkNGLaG3yVarNQFns","token_type": "Bearer","expires_in": 1200,"refresh_token": "IyvJ3BFtFudwOeKb3GAqhTDjUCZ8bxx7EsTwEDfs4JvsoB","scope": "CSSCloud"}');
        }
        return res;
    }
}