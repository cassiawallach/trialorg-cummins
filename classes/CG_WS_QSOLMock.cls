@istest
global class CG_WS_QSOLMock implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        {
            //Create a fake response
            res.setHeader('Content-Type', 'application/json');
            //Old Response
            //res.setBody('{"DataArea":{"AutomotiveAppFlag":"Y","Model":"ALL","Esn":"79488917","EtoConversionDate":"2013-01-15T00:00:00.000-05:00","VIN":"1NKDX4TX1EJ965298","EngineAppCode":"130","MarineAppFlag":"N","EngineBillToCode":"","EquipmentId":"EQ6632","CustomerName":"asdasda","BuildDate":"2013-01-15T00:00:00.000-05:00","Manufacturer":"UNLISTED","EngineFamilyCode":"10","WarrantyStartDate":"2013-01-15T00:00:00.000-05:00","ProdAppCode":"BX","ServiceModelName":"ISX15 CM2350 X101","AccessCode":"C","ProdAppDesc":"AUTOMOTIVE","EngineAppDesc":"AUTOMOTIVE"},"Header":{"Status":"Success"}}');
            //Updated Response
           // res.setBody('{"engineData":"test","engineSerialNumber":"test","Data":[{"warrantyStartDate":"10 Jan 2019","businessUnit":"T2037","customerNumber":"ISX15 CM2350 X101 SCR REPLACEMENT TRP FOR FAULT CODE 3151 OR 3582","cplNumber":"TRP","fuelPumpPartNumber":"en","engineBuildPlant":"OPEN"}]}');
            res.setBody('{"engineSerialNumber":"79462241","data":[{"vin":"1NPTX4EX3CD137011","marketingEngineModel":"ISX15 450","serviceEngineModel":"ISX15 CM2250","epaModelName":"BCEXH0912XAP","engineBuildPlant":"JEP - JAMESTOWN ENGINE PLANT","engineBuildDate":"2011-02-23T00:00:00Z","warrantyStartDate":"2012-03-16T00:00:00Z","ecmCode":"CL10135","fuelPumpPartNumber":"4088507","fuelPumpCalibration":"P846","marketingConfig":"D103009BB09","technicalConfig":"D103009BX03","cplNumber":"CPL3719","customerNumber":"1608","shopOrder":"SO33045","businessUnit":"EBU"}]}');
            res.setStatusCode(200); 
            res.setStatus('OK');
            
        }
        return res;
    }
    
}