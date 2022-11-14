@isTest
global class CSS_BMS_UnitOutboundMockup_Test implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        {
            //Create a fake response
            //res.setHeader('Content-Type','application/x-www-form-urlencoded');
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{ "Header": { "Status": "success", "Sender": { "ServiceName": "GetUnitInfo", "SenderID": "CSS" }, "Target": {"TargetID": "BMS"},"Location": { "LocationID": "02400-02394"} },"DataArea": [{ "CustomerCode" : "A1234567", "UnitNumber": "12345", "UnitDescription": "", "UnitType": "", "Model": "", "VIN": "", "Manufacturer": "KENWORTH", "SalesSegment": "", "ModelNumber": "", "ModelSeq": 0, "ESN": "79834545", "EngineFamily": "", "Applicationcode":  ""} ]}');
        }
        return res;
        
    }
}