@isTest
global class CSS_BMS_SendGSQPartsMockup_Test implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        {
            //Create a fake response
            //res.setHeader('Content-Type','application/x-www-form-urlencoded');
            res.setHeader('Content-Type', 'application/json');
            //res.setBody('{"DataArea": [{   "CustomerCode" : "A1234567",  "UnitNumber": "12345",   "UnitDescription": "",  "UnitType": "",   "Model": "",  "VIN": "",   "Manufacturer": "KENWORTH",  "SalesSegment": "",  "ModelNumber": "",  "ModelSeq": 0,   "ESN": "79834545",  "EngineFamily": "",  "Applicationcode": "" }] ');
            res.setBody('{"Header": "ReturnCodeDescription": "SUCCESS: For Record Number- 1, Part Number- 007070500: WOQT Parts inserted/updated successfully.\\n SUCCESS: For Record Number- 2, Part Number- 430917500RX: WOQT Parts inserted/updated successfully.\\n", "Status": "SUCCESS", "Sender":    { "ServiceName": "WOParts","MessageID": "bac053ab-5b99-4301-8895-aeb67c10a2c9","SenderID": "CSS" },"Target": {"TargetID": "BMS"}, "Location": {"LocationID": "03742-03750"}}');
        }
        return res;
        
    }
}