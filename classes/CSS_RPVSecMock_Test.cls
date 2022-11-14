@isTest
global class CSS_RPVSecMock_Test implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        {
            //Create a fake response
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"DataArea":{"NotificationMessage": "DLR1","RepeatVisitFlag": "FS","NotificationFlag": "ON","ErrorCode": 200},"Header": {"Status": "Success"}}');
        }
        return res;
    }
}