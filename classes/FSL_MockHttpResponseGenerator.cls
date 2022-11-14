@isTest
global class FSL_MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        //res.setBody('{"Header":{"Status":"Success","ReturnCodeDescription":"No Data Found"}}');
       // res.setBody('{"DataArea":{"Details":[{"Status":"Approved","CampaignStartDate":"2015-02-27","FailCode":"WEQP","SrtList":[{"SrtCode":"00-901-00","SrtDescription":"Administrative Time - Open and Close Repair Order (Shop Repairs)"},{"SrtCode":"99-902-00","SrtDescription":"Non SRT details- Campaign/TRP/ATC-0.1Hr"}],"MultipleTimes":"N","CampaignDesc":"ISX15 CM2350 - TRP FOR CALIBRATION FLEET COUNT COSTS WHEN CHANGING ECM BASE CODE POST","FailMode":"EZ","InShopSrtLimitFlag":"N","CompleteIndicator":"N","CampaignNumber":1609,"BusinessUnit":"CMI","CampaignEndDate":"2020-12-31","PartList":[{"PartNumber":"388639600","PartDescription":"6.2 CALIBRATION FLT REG.","PartQuantity":1}],"CampaignType":"TRP"},{"Status":"Approved","CampaignStartDate":"2015-01-30","FailCode":"WEQP","SrtList":[{"SrtCode":"00-901-00","SrtDescription":"Administrative Time - Open and Close Repair Order (Shop Repairs)"},{"SrtCode":"99-902-00","SrtDescription":"Non SRT details- Campaign/TRP/ATC-0.1Hr"}],"MultipleTimes":"N","CampaignDesc":"ISX15 CM2350 - TRP FOR CALIBRATION FLEET COUNT COSTS WHEN CHANGING ECM BASE CODE","FailMode":"E5","InShopSrtLimitFlag":"N","CompleteIndicator":"N","CampaignNumber":1603,"BusinessUnit":"CMI","CampaignEndDate":"2019-12-31","PartList":[{"PartNumber":"388639600","PartDescription":"6.2 CALIBRATION FLT REG.","PartQuantity":1},{"PartNumber":"529740000","PartDescription":"TAG","PartQuantity":1}],"CampaignType":"TRP"}]},"Header":{"Status":"Success"}}');
        res.setBody('{"access_token":"OZ6oIDDyU20vTdrNNfP6acg5aFe8RsUqcAd2ybPuouWsKJrcGqJUWf","token_type":"Bearer","expires_in":1200,"refresh_token":"5i4e6LLNE38oZTeB5QicnZFdNyu62AYglmN0kva81NZZU3","scope":"CSSCloud"}');
        res.setStatusCode(200);
        return res;
    }
}