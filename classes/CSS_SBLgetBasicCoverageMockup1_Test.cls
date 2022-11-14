global class CSS_SBLgetBasicCoverageMockup1_Test implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        {
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
			res.setBody('{"Header": {"Status": "Success","ReturnCodeDescription": ""},"BasicCoverageResponseHeader": {"Response": {"ListOfCoverageDetails": {"CoverageDetails": [{"Status": "Active","ListOfCoverageDedutibles": {"CoverageDedutibles": []},"WarrantyManualURL": "https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate": "12/9/2020","CoverageType": "REW-Recon Engine Warranty","ProcedureNumber": "111-507-033","ListOfCoverageComponentList": {"CoverageComponentList": [{"CoverageHours": "0","CoverageMaxMonths": "24","CoverageComponentTypeCode": "BASE","MegawattHours": "0","CoverageDefenitionType": "BASE","CoverageMinMonths": "0","CoverageMiles": "9999999"}]}}]},"ListOfExtendedCoverageDetails": {"ExtendedCoverageDetails": []}}}}');
        }
        return res;
        
    }
}