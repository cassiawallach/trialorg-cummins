global class CG_SL_BMSMock_Test2 implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        {
            //Create a fake response
            //res.setHeader('Content-Type','application/x-www-form-urlencoded');
            res.setHeader('Content-Type', 'application/json');
            //res.setBody('{"DataArea": [{   "CustomerCode" : "A1234567",  "UnitNumber": "12345",   "UnitDescription": "",  "UnitType": "",   "Model": "",  "VIN": "",   "Manufacturer": "KENWORTH",  "SalesSegment": "",  "ModelNumber": "",  "ModelSeq": 0,   "ESN": "79834545",  "EngineFamily": "",  "Applicationcode": "" }] ');
            res.setStatusCode(200);
            system.debug('StatusCode***'+res.getStatusCode());
            res.setBody('{"Header":{"MessageIdentifier":"Identifier from MW","ReturnCode":"<MessageCode from Siebel>","ReturnCodeDescription":"<Message from Siebel>","Status":"Success"},"DataArea":[{"SystemCode":"WS","SystemName":"Broken Filter shell1","ComponentCode":"EF","ComponentName":"Electrical","FailureName":"","ServiceGroupCode":"345","Created":"2010-03-19T16:18:59.000-05:00","Active":"Y","UpdatedDate":"2010-03-19T16:18:59.000-05:00","BusinesUnit":"EBU"},{"SystemCode":"WS1","SystemName":"Broken Filter shell1","ComponentCode":"EF","ComponentName":"Electrical","FailureName":"","ServiceGroupCode":"345","Created":"2010-03-19T16:18:59.000-05:00","Active":"Y","UpdatedDate":"2010-03-19T16:18:59.000-05:00","BusinesUnit":"EBU"},{"SystemCode":"WS2","SystemName":"Broken Filter shell1","ComponentCode":"EF","ComponentName":"Electrical","FailureName":"","ServiceGroupCode":"345","Created":"2010-03-19T16:18:59.000-05:00","Active":"Y","UpdatedDate":"2010-03-19T16:18:59.000-05:00","BusinesUnit":"EBU"}]}');
            system.debug('Response***'+res.getBody());
        }
        system.debug('Response1***'+res.getBody());
        return res;
        
        
    }

}