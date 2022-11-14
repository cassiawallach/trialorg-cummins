@isTest
global class CSS_SRTParts_MockUP_Test implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        {
            //Create a fake response
            //res.setHeader('Content-Type','application/x-www-form-urlencoded');
            res.setHeader('Content-Type', 'application/json');
            //res.setBody('{"DataArea": [{   "CustomerCode" : "A1234567",  "UnitNumber": "12345",   "UnitDescription": "",  "UnitType": "",   "Model": "",  "VIN": "",   "Manufacturer": "KENWORTH",  "SalesSegment": "",  "ModelNumber": "",  "ModelSeq": 0,   "ESN": "79834545",  "EngineFamily": "",  "Applicationcode": "" }] ');
            res.setBody('{"DataArea":[{"Notes":"","Qty":1,"PartNumberMfg":"","OEM":"OEM14","PartSize":"A2","OptionNumber":"O-111","FailureID":"F02000010","Assignment":"OPTIONAL","PartNameService":"ServiceP14","FailureName":"Cylinder Head","PartNumberService":"P14"},{"Notes":"","Qty":1,"PartNumberMfg":"","OEM":"OEM123","PartSize":"A3","OptionNumber":"O-111","FailureID":"F02000010","Assignment":"OPTIONAL","PartNameService":"ServiceP123","FailureName":"Cylinder Head","PartNumberService":"P123"}],"Header":{"ReturnCodeDescription":"Normal, Successful completion.","ReturnCode":"ORA-00000","MessageIdentifier":"S"}}');
        }
        return res;
        
    }
}