@isTest
global class CSS_RPVMockSecond_Test implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        {
            //Create a fake response
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"DataArea":{"NotificationMessage": "DLR1","RepeatVisitFlag": "RN","NotificationFlag": "ON","ErrorCode": 200},"Header": {"Status": "Success"}}');
        }
        return res;
    }
}