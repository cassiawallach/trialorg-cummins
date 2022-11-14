@istest
global class CG_J2AQsolTokenMock1 implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        {
            res.setHeader('Content-Type', 'application/json');
            res.setStatus('Success');
            res.setStatusCode(200);
            system.debug('StatusCode***'+res.getStatusCode());
            String resp = '[{"optionNumber":"PE1027-05","optionDescription":"Aftertreatment Device","repairGroup":"11.01.1"},{"optionNumber":"PE1715-03","optionDescription":"DOSER,FLUID","repairGroup":"11.01.1"},{"optionNumber":"PE1715-01","optionDescription":"Fluid Doser","repairGroup":"11.01"}]';
            res.setBody(resp);
            //res.setBody('{"optionNumber": "PE1027-05","optionDescription": "Aftertreatment Device","repairGroup": "11.01.1"}');
            system.debug('Response***'+res.getBody());
        }
        system.debug('Response1***'+res.getBody());
        return res;
        
        
    }

}