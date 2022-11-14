@istest
global class CG_BLIntakeMock_Test implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        {
            system.debug('TestInsideMock**Kal');
            //Create a fake response
            //res.setHeader('Content-Type','application/x-www-form-urlencoded');
            res.setHeader('Content-Type', 'application/json');
            //res.setBody('{"DataArea": [{   "CustomerCode" : "A1234567",  "UnitNumber": "12345",   "UnitDescription": "",  "UnitType": "",   "Model": "",  "VIN": "",   "Manufacturer": "KENWORTH",  "SalesSegment": "",  "ModelNumber": "",  "ModelSeq": 0,   "ESN": "79834545",  "EngineFamily": "",  "Applicationcode": "" }] ');
            res.setStatusCode(200);
            system.debug('StatusCode***'+res.getStatusCode());
            res.setBody('{'+
		'    \"engineSerialNumber\": \"79462241\",'+
		'    \"data\": ['+
		'        {'+
		'            \"vin\": \"1NPTX4EX3CD137011\",'+
		'            \"marketingEngineModel\": \"ISX15 450\",'+
		'            \"serviceEngineModel\": \"ISX15 CM2250\",'+
		'            \"epaModelName\": \"BCEXH0912XAP\",'+
		'            \"engineBuildPlant\": \"JEP - JAMESTOWN ENGINE PLANT\",'+
		'            \"engineBuildDate\": \"2011-02-23T00:00:00Z\",'+
		'            \"warrantyStartDate\": \"2012-03-16T00:00:00Z\",'+
		'            \"ecmCode\": \"CL10135\",'+
		'            \"fuelPumpPartNumber\": \"4088507\",'+
		'            \"fuelPumpCalibration\": \"P846\",'+
		'            \"marketingConfig\": \"D103009BB09\",'+
		'            \"technicalConfig\": \"D103009BX03\",'+
		'            \"cplNumber\": \"CPL3719\",'+
		'            \"customerNumber\": \"1608\",'+
		'            \"shopOrder\": \"SO33045\",'+
		'            \"businessUnit\": \"EBU\"'+
		'        }'+
		'    ]'+
		'}');
            system.debug('Response***'+res.getBody());
        }
        system.debug('Response1***'+res.getBody());
        return res;
        
        
    }

}