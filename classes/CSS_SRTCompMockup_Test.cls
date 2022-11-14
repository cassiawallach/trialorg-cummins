@isTest
global class CSS_SRTCompMockup_Test implements HttpCalloutMock {
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
            res.setBody('{'+
    '                \"DataArea\": ['+
    '                {'+
    '                                \"ComponentCode\": \"CG\",'+
    '                                \"FailureMode\": \"\",'+
    '                                \"FailureID\": \"F30000860\",'+
    '                                \"FailureName\": \"Accessory Plate Cover Gasket\",'+
    '                                \"SystemCode\": \"BG\"'+
    '                }],'+
    ''+
    '                \"Header\": {'+
    '                                \"ReturnCodeDescription\":\"Normal, Successful completion.\",'+
    '                                \"ReturnCode\": \"ORA-00000\",'+
    '                                \"MessageIdentifier\": \"S\"'+
    '                }'+
    '}');
            system.debug('Response***'+res.getBody());
        }
        system.debug('Response1***'+res.getBody());
        return res;
        
        
    }
}