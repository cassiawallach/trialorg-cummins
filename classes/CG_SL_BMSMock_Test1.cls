global class CG_SL_BMSMock_Test1 implements HttpCalloutMock{
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
            res.setBody('{ "DataArea": [ { "MiscDescription": "FREE CUST. SVC-SVC SALES", "CreditType": "", "Maximum": "", "AutoCharage": "N", "FlatAmount": "", "Multiplier": "", "MiscName": "FCS-SVC SALES","ChargeCategory":"TRVL" }, { "MiscDescription": "RLC DISCOUNT", "CreditType": "", "Maximum": "", "AutoCharage": "N", "FlatAmount": "", "Multiplier": "", "MiscName": "RLC DISCOUNT" }, { "MiscDescription": "FREIGHT INTERBRANCH", "CreditType": "", "Maximum": "", "AutoCharage": "N", "FlatAmount": "", "Multiplier": "", "MiscName": "FREIGHT INTERBRANCH" } ], "Header": { "ReturnCodeDescription": "", "Status": "SUCCESS", "Sender": { "ServiceName": "getMISCChargeLOVs", "MessageID": "", "SenderID": "BMS" }, "Target": {"TargetID": "CSS"}, "Location": {"LocationID": "03520-04897"} } }');
            system.debug('Response***'+res.getBody());
        }
        system.debug('Response1***'+res.getBody());
        return res;
        
        
    }

}