@isTest
global class CG_TSRMock_Test implements HttpCalloutMock {
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
            res.setBody('{"DataArea":{"ActivityDescription":"","ErrorMessage":"Success","ActivityOwner":"Brent A Engel","ActivityID":"1-HIKHTI9","TSRNumber":"1-38128114549","ActivityType":"Escalation","ActivitySubject":"","ErrorCode":"","CSSJobID":"CSS-00070849"},"Header":{"ReturnCodeDescription":"Success","Status":"SUCCESS","ReturnCode":"","MessageIdentifier":"CSS-00070849"}}');
            system.debug('Response***'+res.getBody());
        }
        system.debug('Response1***'+res.getBody());
        return res;
        
        
    }
}