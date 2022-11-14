@isTest
global class OSMGetOrderInfoServiceMockUp implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        {
            //Create a fake response
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"Header":{"Sender":{"ServiceName":"GetOrder","SenderID":"Mrktpl"},"Target":{"TargetID":"OMS"}},"ItemInfoList":{"ItemInfo":[{"ItemId":"7757","LicenseInfo":{"LicenseName":"Komatsu Tier4 Basic","ActivationKey":"NIQ12IWCSV1D"}},{"ItemId":"7758","LicenseInfo":{"LicenseName":"Komatsu Tier4","ActivationKey":"NIQ12IWCSV1D"}}]}}');
        }
        return res;
    }
}