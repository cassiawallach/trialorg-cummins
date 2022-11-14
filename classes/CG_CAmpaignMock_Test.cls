global class CG_CAmpaignMock_Test implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse httpres = new HttpResponse();
        {
            system.debug('InsideMock**');
            //Create a fake response
            //res.setHeader('Content-Type','application/x-www-form-urlencoded');
            httpres.setHeader('Content-Type', 'application/json');
            //res.setBody('{"DataArea": [{   "CustomerCode" : "A1234567",  "UnitNumber": "12345",   "UnitDescription": "",  "UnitType": "",   "Model": "",  "VIN": "",   "Manufacturer": "KENWORTH",  "SalesSegment": "",  "ModelNumber": "",  "ModelSeq": 0,   "ESN": "79834545",  "EngineFamily": "",  "Applicationcode": "" }] ');
            httpres.setStatusCode(200);
            system.debug('StatusCode***'+httpres.getStatusCode());
            //httpres.setBody('{"DataArea":{{"Details":{BusinessUnit=CMI, CampaignDesc=ISX15 CM2350 - TRP FOR CALIBRATION FLEET COUNT COSTS WHEN CHANGING ECM BASE CODE POST, CampaignEndDate=2020-12-31, CampaignNumber=1609, CampaignStartDate=2015-02-27, CampaignType=TRP, CompleteIndicator=N, FailCode=WEQP, FailMode=EZ, InShopSrtLimitFlag=N, MultipleTimes=N, {"PartList":{PartDescription=6.2 CALIBRATION FLT REG., PartNumber=388639600, PartQuantity=1}}, {"SrtList":{SrtCode=00-901-00, SrtDescription=Administrative Time - Open and Close Repair Order (Shop Repairs)},  Status=Approved}}}},"Header":{"ReturnCodeDescription":"Success","Status":"SUCCESS","ReturnCode":"","MessageIdentifier":"CSS-00070849"}}');
            //httpres.SetBody('{"DataArea":{"Details":{BusinessUnit=CMI, CampaignDesc=ISX15 CM2350 - TRP FOR CALIBRATION FLEET COUNT COSTS WHEN CHANGING ECM BASE CODE POST, CampaignEndDate=2020-12-31, CampaignNumber=1609, CampaignStartDate=2015-02-27, CampaignType=TRP, CompleteIndicator=N, FailCode=WEQP, FailMode=EZ, InShopSrtLimitFlag=N, MultipleTimes=N, {"PartList":{PartDescription=6.2 CALIBRATION FLT REG., PartNumber=388639600, PartQuantity=1}}, {"SrtList":{SrtCode=00-901-00, SrtDescription=Administrative Time - Open and Close Repair Order (Shop Repairs)}},  Status=Approved}},"Header":{"ReturnCodeDescription":"Success","Status":"SUCCESS","ReturnCode":"","MessageIdentifier":"CSS-00070849"}}');
            httpres.setBody('{"DataArea":{"Details":[{"BusinessUnit":"CMI", "CampaignDesc":"ISX15 CM2350 - TRP FOR CALIBRATION FLEET COUNT COSTS WHEN CHANGING ECM BASE CODE POST", "CampaignEndDate":"2020-12-31", "CampaignNumber":1609, "CampaignStartDate":"2015-02-27", "CampaignType":"TRP", "CompleteIndicator":"N", "FailCode":"WEQP", "FailMode":"EZ", "InShopSrtLimitFlag":"N", "MultipleTimes":"Y", "PartList":[{"PartDescription":"6.2 CALIBRATION FLT REG.", "PartNumber":"388639600", "PartQuantity":"1"}],"SrtList":[{"SrtCode":"00-901-00", "SrtDescription":"Administrative Time - Open and Close Repair Order (Shop Repairs)"}],  "Status":"Approved"}]},"Header":{"ReturnCodeDescription":"Success","Status":"SUCCESS"}}');
            system.debug('Response***'+httpres.getBody());
        }
        system.debug('Response1***'+httpres.getBody());
        return httpres;
        
        
    }
    
}