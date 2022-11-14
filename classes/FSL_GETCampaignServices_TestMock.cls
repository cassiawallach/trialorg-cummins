@isTest
global class FSL_GETCampaignServices_TestMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setBody('{ "DataArea": { "Details": [{ "Status": "Approved", "CampaignStartDate": "2018-02-02", "FailCode": "WSNF", "SrtList": [{ "SrtCode": "99-902-00", "SrtDescription": "Non SRT details- Campaign/TRP/ATC-0.1Hr" }], "MultipleTimes": "N", "CampaignDesc": "ISB6.7 EURO5, QSB6.7 TIER3 TERBERG STARTER TRP", "FailMode": "WN", "InShopSrtLimitFlag": "N", "CompleteIndicator": "N", "CampaignNumber": 1982, "BusinessUnit": "CMI", "CampaignEndDate": "2020-02-28", "PartList": [{ "PartNumber": "499670900", "PartDescription": "MOTOR,STARTING", "PartQuantity": 1 }], "CampaignType": "TRP" }] }, "Header": { "Status": "Success" }}');
        return res;
    }
}