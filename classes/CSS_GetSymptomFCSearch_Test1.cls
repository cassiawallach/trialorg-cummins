@isTest
global class CSS_GetSymptomFCSearch_Test1 implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        {
            //Create a fake response
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"dsid":"test","faultCode":[{"state":{"name":"dialog","dialogParamater":{}},"views":{"result":{"cases":[{"rank":1,"name":"test","image":"test","title":"requires that ALL solutions be performed"}]}}}]}');
        }
        return res;
    }
}