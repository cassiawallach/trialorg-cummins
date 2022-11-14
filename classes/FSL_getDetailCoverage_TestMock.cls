@isTest
global class FSL_getDetailCoverage_TestMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setBody('{"DataArea":{"Details":[{"CoveredTravelBaseFareAmt":"9999999","CoveredOCAmount":"9999999","CoveredLaborHrs":"9999999","CoveredTowingMiles":"","Message":"","CampaignLaborPercentage":"0","CoveredTravelLabor":"9999999","CertificateNumber":"","CampaignTowingPercentage":"0","SystemCode":"BK","AccountCodeType":"NEW-New Engine Warranty","CoveredPartsQty":"9999999","Status":"Success","CampaignOCPercentage":"0","DeductibleAmount":"0","ComponentCode":"CA","PayCode":"I","AccountCode":"67","CampaignPartsPercentage":"0","CoveredMealsLodgingAmt":"9999999","WarrantyId":"1-15S-312","CoveredTravelMiles":"9999999","CampaignTravelPercentage":"0"}],"AccountCode":"67","AccountCodeType":"NEW-New Engine Warranty"},"Header":{"ReturnCodeDescription":"","Status":"Success"}} ))');        
        return res;
    }
}