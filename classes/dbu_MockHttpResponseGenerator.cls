@isTest
global class dbu_MockHttpResponseGenerator implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"example":"test"}');
        if(req.getMethod()=='POST'){
            res.setStatusCode(201);
            res.setStatus('OK');
        }
        if(req.getMethod()=='PUT' || req.getMethod()=='GET'){
            res.setStatusCode(200);
        }
        return res;
    }
}