@isTest
global class CG_OP_CampaignsresJSONMOck_Test implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        {
            String json = '{ '+
		'\"DataArea\": { '+
		'\"InShopLaborRate\": \"19.06\", '+
		'\"FieldServiceLaborRate\": \"19.06\", '+
		'\"Region\": \"INTERNATIONAL\", '+
		'\"ChannelCode\": \"110\", '+
		'\"TravelRate\": \"0.37\", '+
		'\"Territory\": \"CHINA\", '+
		'\"ChannelOfDistribution\": \"110-DEALER\" '+
		'}, '+
		'\"Header\": {\"Status\": \"Success\"} '+
		'}';
            //Create a fake response
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
           // res.setBody('{ "DataArea": { "Details": [ { "CampaignDesc": "TRP FOR MCRS FUEL PUMP FAILURES TO INSTALL EPLV SYSTEM ON ENGINES", "CampaignEndDate": "2017-12-31", "CampaignStartDate": "2016-08-23", "SrtList": [ { "SrtCode": "00-901-00", "SrtDescription": "Administrative Time - Open and Close Repair Order (Shop Repairs)" } ], "FailCode": "WFHA", "FailMode": "SR", "InShopSrtLimitFlag": "N", "Status": "Approved", "MultipleTimes": "N", "BusinessUnit": "CMI", "CampaignType": "TRP", "CompleteIndicator": "N", "PartList": [ { "PartQuantity": 1, "PartNumber": 540571400, "PartDescription": "KIT,SERVICE" } ], "CampaignNumber": "1820" } ] }, "Header": { "ReturnCodeDescription": "ReturnCodeDescription", "Status": "Success" } }');
            res.setBody(json);  
        }
        return res;
        
    }
}