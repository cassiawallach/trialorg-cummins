@isTest
global class CSS_getEngineDataResponseJ2A_Mockup_Test implements HttpCalloutMock 
{
     global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        {
            //Create a fake response
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
           // res.setBody('{"DataArea":{"EtoConversionDate": "2013-01-15","EquipmentId": "EQ7556","EngineAppCode": "130","DesignPhaseCode": "D3","ETOOldPSN": "","Manufacturer": "INTERNATIONAL","OEMSPCode": "08588","CriticalPartsListNumber": "4515","CustomerName": "STERLING LUMBER","ProdAppCode": "BB","ServiceModelName": "ISB6.7 CM2350 B101","EngineFamilyName": "6B 6.7","EquipmentConfiguration": "MED CONV",PACCARFlag": "N","ShipDate": "2015-02-18 00:00:00.0","AutomotiveAppFlag":"Y","Model":"ALL","Esn":"79488917","EtoConversionDate":"2013-01-15","VIN":"1NKDX4TX1EJ965298","EngineAppCode":"130","MarineAppFlag":"N","EngineBillToCode":"","EquipmentId":"EQ6632","CustomerName":"asdasda","BuildDate":"2013-01-15T00:00:00.000-05:00","Manufacturer":"UNLISTED","EngineFamilyCode":"10","WarrantyStartDate":"2013-01-15T00:00:00.000-05:00","ProdAppCode":"BX","ServiceModelName":"ISX15 CM2350 X101","AccessCode":"C","ProdAppDesc":"AUTOMOTIVE","EngineAppDesc":"AUTOMOTIVE"},"Header":{"Status":"Success"}}');
            //res.setStatusCode(200);
          res.setBody('{'+'"DataArea":{'+'"AutomotiveAppFlag":"",'+'"Model":"VNL SERIES",'+'"Esn":"79464646","'+'EtoConversionDate":"",'+'"EngineAppCode":"2011-03-09T00:00:00.000-05:00",'+'"MarineAppFlag":"",'+'"EngineBillToCode":"",'+'"EquipmentId":"EQ5437",'+'"CustomerName":"SOUTHEASTERN FRT",'+'"BuildDate":"2011-03-09T00:00:00.000-05:00",'+'"Manufacturer":"VOLVO",'+'"EngineFamilyCode":"10",'+'"WarrantyStartDate":"2013-10-14T00:00:00.000-04:00",'+'"ProdAppCode":"BB",'+'"ServiceModelName":"ISX15 CM2250",'+'"AccessCode":"B",'+'"ProdAppDesc":"AUTOMOTIVE",'+'"vin":"1234ZXASSDASASS121212",'+'"EngineAppDesc":""},'+'"Header":{"Status":"Success"}'+'}'); 
        }
        return res;
    }
}