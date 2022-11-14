@istest
Global class CSS_WS_OAGMOCK_createbms implements httpcalloutmock{
    global HttpResponse respond(httprequest req)
    {
        HttpResponse res = new HttpResponse();
        res.setHeader('content-type','application/json');
        res.setStatus('success');
        res.setStatusCode(200);
        res.setBody('{ "Header": { "ReturnCodeDescription": "", "Sender": { "MessageID": "1324", "SenderID": "12344", "ServiceName": "ServiceName" }, "Target": { "TargetID": "123" }, "Location": { "LocationID": "1234" }, "Status": "Success" }, "DataArea": { "CustomerCode": "123", "OpenChargeFlag": "false" } }');
        
        return res;
    }

}