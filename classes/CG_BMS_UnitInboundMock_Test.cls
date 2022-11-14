@isTest
global class CG_BMS_UnitInboundMock_Test implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        {
            //Create a fake response
            //res.setHeader('Content-Type','application/x-www-form-urlencoded');
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"Header":{"Sender":{"ServiceName":"UpsertUnitInfo","SenderID":"CSS","MessageID":"b3b70396-2d3b-48ce-b164-79131cff4ea4"},"Status":"ERROR","Target":{"TargetID":"BMS"},"ReturnCodeDescription":"Distributor Not Setup","Location":{"LocationID":""}}}');
        }
        return res;
        
    }
}