@istest
global class CSS_getAllSRTAdminPM_Test implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        {
            //Create a fake response
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"DataArea":[{"SRTType":"Admin","SRTNumber":"99-202-00","SRTTitle":"PM Inspection 21 - 34 / Natural Gas","BTime":0,"RTime":0,"SRTCategory":"Service, Maintenance, Contract Repair","StepID":139319,"ATime":0,"CTime":2,"DTime":0},{"SRTType":"Admin","SRTNumber":"99-227-00","SRTTitle":"PM Full Service 501 - 600 / Diesel","BTime":0,"RTime":0,"SRTCategory":"Service, Maintenance, Contract Repair","StepID":139342,"ATime":0,"CTime":7,"DTime":0}],"Header":{"ReturnCodeDescription":"Normal, Successful completion.","ReturnCode":"ORA-00000","MessageIdentifier":"S"}}');
        }
        return res;
    }

}