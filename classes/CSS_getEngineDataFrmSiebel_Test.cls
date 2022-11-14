@istest
global class CSS_getEngineDataFrmSiebel_Test implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        {
            //Create a fake response
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"DataArea":{"AutomotiveAppFlag":"Y","Model":"ALL","Esn":"79488917","EtoConversionDate":"","VIN":"1NKDX4TX1EJ965298","EngineAppCode":"130","MarineAppFlag":"N","EngineBillToCode":"","EquipmentId":"EQ6632","CustomerName":"asdasda","BuildDate":"2013-01-15T00:00:00.000-05:00","Manufacturer":"UNLISTED","EngineFamilyCode":"10","WarrantyStartDate":"2013-01-15T00:00:00.000-05:00","ProdAppCode":"BX","ServiceModelName":"ISX15 CM2350 X101","AccessCode":"C","ProdAppDesc":"AUTOMOTIVE","EngineAppDesc":"AUTOMOTIVE"},"Header":{"Status":"Success"}}');
            //res.setStatusCode(200); 
        }
        return res;
    }
    
}