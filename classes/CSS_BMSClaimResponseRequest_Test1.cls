@isTest
global class CSS_BMSClaimResponseRequest_Test1 implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        {
            //Create a fake response
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"DataArea":{"BMSClaimNumber":"1-127827968"},"Header":{"ReturnCodeDescription":"","Status":"500","Sender":{"ServiceName":"","MessageID":"","SenderID":""},"Target":{"TargetID":""},"Location":{"LocationID":""}}}');
            res.setStatusCode(500);
        }
        return res;
    }
}